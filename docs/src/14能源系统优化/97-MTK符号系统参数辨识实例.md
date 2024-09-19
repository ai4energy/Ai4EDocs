# MTK符号系统参数辨识

!!! tip
    Contents：MTK模型、优化、DiffEqParamEstim

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

!!! note
    DEPE = DiffEqParamEstim.jl(Differential Equation Parameters Estimate)

    [DiffEqParamEstim.jl](https://diffeqparamestim.sciml.ai/dev/)是计算微分方程参数估计的软件包。

## 原理

MTK与DE在问题层面具有一致性。MTK是符号处理的软件包，问题的求解仍然推给DE。而DEPE是从DE的problem层面构建的参数优化问题，所以使用MTK进行建模后，依然可以使用DEPE进行参数估计。对于DEPE来说，不管是MTK还是DE，它接受的问题都是DE的Problem。所以，不管是使用MTK还是DE构建模型，到DEPE这一层面都是贯通的。

**下面以RC电路模型为例，进行电路中正弦电压源的电压值估计**。

## RC组件建模

基于ModelingToolkit，建立RC电路模型，模型如下图所示。这是一个震荡电路
![在这里插入图片描述](https://img-blog.csdnimg.cn/b312000df0f8482cb63ec877e63e3a63.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


## 构建组件

首先完成电路模型的组件编写，一共有5个组件，分别是电源、电阻、电容、电感、接地
```julia
using ModelingToolkit, Plots, DifferentialEquations

@variables t
@connector function Pin(; name)
    sts = @variables v(t) = 1.0 i(t) = 1.0 [connect = Flow]
    ODESystem(Equation[], t, sts, []; name=name)
end

function Ground(; name)
    @named g = Pin()
    eqs = [g.v ~ 0]
    compose(ODESystem(eqs, t, [], []; name=name), g)
end

function OnePort(; name)
    @named p = Pin()
    @named n = Pin()
    sts = @variables v(t) = 1.0 i(t) = 1.0
    eqs = [
        v ~ p.v - n.v
        0 ~ p.i + n.i
        i ~ p.i
    ]
    compose(ODESystem(eqs, t, sts, []; name=name), p, n)
end

function Resistor(; name, R=1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters R = R
    eqs = [
        v ~ i * R
    ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function Capacitor(; name, C=1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters C = C
    D = Differential(t)
    eqs = [
        D(v) ~ i / C
    ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function ConstantVoltage(; name, V=1.0)
    @named oneport = OnePort()
    @unpack v = oneport
    ps = @parameters V = V
    eqs = [
        V ~ v
    ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function Inductor(; name, L=1.0)
    @named oneport = OnePort()
    @unpack v, i = oneport
    ps = @parameters L = L
    D = Differential(t)
    eqs = [
        D(i) ~ v / L
    ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function ChangeableVoltage(; name)
    @named oneport = OnePort()
    @unpack v, i = oneport
    eqs = [
        v ~ 16 * sin(2π * t)
    ]
    extend(ODESystem(eqs, t, [], []; name=name), oneport)
end
```
可以看到，系统一共定义有4个参数，分别是电阻值，电容值，电感值以及电压的最大值

---

然后，通过连接函数，组建系统
```julia
@named resistor = Resistor(R=3.0)
@named capacitor = Capacitor(C=1.0/24)
@named source = ChangeableVoltage(vol=10.0)
@named inductor = Inductor(L=0.1)
@named ground = Ground()


rc_eqs = [
          connect(source.p, capacitor.p)
          connect(capacitor.n, inductor.p)
          connect(inductor.n, resistor.p)
          connect(source.n,resistor.n,ground.g)
         ]

@named _rc_model = ODESystem(rc_eqs, t)
@named rc_model = compose(_rc_model,
    [resistor, inductor, capacitor, source, ground])

sys = structural_simplify(rc_model)

using Plots
u0 = [
    capacitor.v => 0.0
    capacitor.p.i => 0.0
    inductor.i => 0
    inductor.v => 0
     ]
P=[3.0,1.0/24,0.1,10.0]  #系统的参数
prob = ODAEProblem(sys, u0, (0, 10.0),P)
sol = solve(prob, Tsit5())

p1 = plot(sol,vars=[capacitor.v capacitor.p.i],xlims = (0,10),ylim = (-10,15))
p2 = plot(sol,vars=[inductor.v inductor.i],xlims = (0,10),ylim = (-5,5))
plot(p1,p2,layout=(2,1))

```
运行代码可以得到结果图：
![在这里插入图片描述](https://img-blog.csdnimg.cn/4a8b8330938b4964a6d30d47cde6cf9d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

电容的电压电流、电感的电压电流都是震荡的。

初值向量P分别对应4个参数的参数值，电压值为最后一个，设定为10.0

在不知道参数的顺序时，可以使用parameters函数查看系统参数。
```julia
parameters(sys)
```

# 建立问题

为了能够模拟参数辨识，给其中一个变量加上扰动（这里依旧采用手动生成数据的思想，可能保证模型与数据匹配）。可以使用states函数查看系统变量（在组件设计过程中定义的）。

```
states(sys)
```
这里对两个变量都添加扰动。
```julia
using RecursiveArrayTools
t = collect(range(0,stop=10,length=1000)) # 建立时间向量
randomized = VectorOfArray([(sol(t[i]) + .5randn(2)) for i in 1:length(t)])
data = convert(Array,randomized)  
```
对sol的结果，选取了1000个点作为样本点加入扰动。

加入的扰动的方式是：通过生成绝对值小于0.5的随机数加入到从sol中选取出来的样本点中去，将其作为需要参数辨识的样本数据。

看一看扰动生成的结果：
```julia
p1=plot(t,data[1,:],ylim=(-8,8))
p1=plot!(t,data[2,:],ylim=(-8,8))
p2=plot(sol,vars=[inductor.i,capacitor.v],ylim=(-8,8))
plot(p1,p2,layout=(2,1))
```
产生的结果图为：
![在这里插入图片描述](https://img-blog.csdnimg.cn/4aba83f22f884c3e923454fe04619e58.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)


# 辨识过程
参数辨识使用DiffEqParamEstim，
```julia
using DiffEqParamEstim
cost_function = build_loss_objective(prob,Tsit5(),
L2Loss(t,data),maxiters=10000,verbose=false)
```
通过build_loss_objective建立了辨识模型，即通过该函数可以求处理后的样本点与模型计算结果的方差和（L2Loss），当然方差和只是作为拟合的评价指标之一，可以选取不同的函数或者构建不同的指标。

接下来，看一看不同的电压值，带来的方差和的变化。
```julia
vals = 0:0.1:20.0
plot(vals,[cost_function([3.0,1.0/24,0.1,i]) for i in vals],yscale=:log10,
     xaxis = "Parameter", yaxis = "Cost", title = "1-Parameter Cost Function",
     lw = 3)
```
val为从0开始，到20，步长为0.1。对这些电压值，去匹配模型，算出来的与样本值的方差和会不同。

结果为：
![在这里插入图片描述](https://img-blog.csdnimg.cn/b3b199f69d714e389db2910f44c28cc8.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16#pic_center)

可以看到，在10.0的地方，方差和最小（因为设定的值就是10.0，扰动是在此基础之上叠加的）。说明辨识结果有效。

以上是通过“肉眼”观察的出来的结果。科学的方法是**求一组参数，使得方差和最小**。这是一个最优化问题。使用Optim

```julia
using Optim
result = optimize(cost_function, [3.0,1.0/24,0.1,15])
result.minimizer
```
将电压的初始值设为15去寻优，得到的结果为：
```
4-element Vector{Float64}:
 2.975801390547115
 0.04266590691854741
 0.09999565290932136
 9.923607580088433
```
和真实值是非常接近的！寻优有效！

也可以将4个初始值都改变去寻优。
```julia
result = optimize(cost_function, [2.0,0.1,0.5,16])
result.minimizer
```
得到的结果也很好
```
4-element Vector{Float64}:
 2.972037379476059
 0.04300492580277582
 0.09998659716890046
 9.911215185371102
```

!!! note
    该参数辨识仍然是优化问题的子集，选择不同的初值很可能得到不同的结果。
