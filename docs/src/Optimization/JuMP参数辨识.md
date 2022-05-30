# JuMP非线性参数辨识实例

!!! tip
    Contents：参数辨识、优化、JuMP

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

!!! note

    JuMP = JuMP.jl

    NLP = NonlinearnProblem，非线性问题

    [JuMP](https://jump.dev/JuMP.jl/v0.21.8/tutorials/Nonlinear%20programs/clnlbeam/)是计算优化问题的Julia软件包。

## JuMP介绍

JuMP是一种特定领域的建模语言，用于嵌入Julia中的数学优化。可以用于解决各类优化问题。JuMP的[指南](https://jump.dev/JuMP.jl/v0.21.8/installation/)中列出了可用的求解器，以及能够求解问题的类型。

JuMP建模的思路主要分为3步：

1. 定义求解器
2. 明确问题
3. 求解

使用[MTK非线性参数辨识实例](./参数辨识实例_MTK.md)中的参数优化问题作为求解实例展开介绍

## 求解实例

为了优化下面模型中的参数$a,b$：

```math
y = ax^2+sin(bx)\\a=1.5,b=0.8
```  

人为生成数据，

```julia
##### 生成真实数据 #####
x = collect(-1:0.01:1)
N = length(x)
# 产生随机误差，范围在-0.1~0.1之间
rands = rand(-0.1:0.01:0.1, N)
a1 = 1.5
a2 = 0.8
# 计算y值
y = @. a1 * x^2 + sin(a2 * x) + rands
```

JuMP优化：

首先，定义求解器：

```julia
###### 定义求解器 #######
model = Model(Ipopt.Optimizer)
```

随后，定义优化变量，在参数辨识问题中，被优化的参数为$a,b$：

```julia
###### 定义变量 #######
@variable(model, para[1:2])
```

其次，构建优化问题的数学表达，需要用@NLexpression生成非线性优化中的中间表达Loss。使用@NLobjective，从Loss中构建最小化优化问题。参数优化问题没有变量约束，也可以说是全局优化问题。

!!! tip
    @NLobjective、@NLexpression与非线性优化问题有关，在线性优化问题中，使用@expression。不同问题类型使用不同的宏，是JuMP问题构建的特点。

```julia
###### 构建问题 #######
@NLexpression(model, Loss,
    sum((para[1] * x[i]^2 + sin(para[2] * x[i]) - y[i])^2 for i in 1:N))
@NLobjective(model, Min, Loss)
```

最后求解

```julia
###### 赋初值 #######
for i in 1:2
    set_start_value(para[i], 0.3)
end
###### 求解 #######
JuMP.optimize!(model)
JuMP.value.(para)
```

结果：

```julia
2-element Vector{Float64}:
 1.4989653389675912
 0.8133014851045581
```

!!! warning
    优化的求解器不是万能的，当一个参数辨识问题无法求解时有很多原因，例如：
    * 用来描述系统的数学模型不精确
    
    上述例子中，优化数据集本身就来自于模型，所以可以肯定数据的本质一定是我们选定的模型。在实际中，面对大量的数据，数学模型准不准确往往是未知的。

    * 优化问题较为复杂

    多变量的复合函数，以及多优化目标的优化问题。在数学上可能有多个局部最优解。有些结果往往不太理想，典型的表现上是不同的初值获得不同的结果。或表现为初值敏感，当初值有微小改变，也能引起结果的巨大不同。

    面对这些数学上的难点，需要采取一些其它的策略。优化模型或者采取更加强大的求解器......

全部代码：

```julia
using JuMP, Ipopt

##### 生成真实数据 ####
x = collect(-1:0.01:1)
N = length(x)
# 产生随机误差，范围在-0.1~0.1之间
rands = rand(-0.1:0.01:0.1, N)
a1 = 1.5
a2 = 0.8
# 计算y值
y = @. a1 * x^2 + sin(a2 * x) + rands

model = Model(Ipopt.Optimizer)
@variable(model, para[1:2])
@NLexpression(model, Loss,
    sum((para[1] * x[i]^2 + sin(para[2] * x[i]) - y[i])^2 for i in 1:N))
@NLobjective(model, Min, Loss)
for i in 1:2
    set_start_value(para[i], 0.3)
end

JuMP.optimize!(model)
JuMP.value.(para)
```