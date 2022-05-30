# MTK非线性参数辨识实例

!!! tip
    Contents：参数辨识、优化、MTK

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

!!! note

    MTK = ModelingToolkit.jl

    NLP = NonlinearnProblem，非线性问题

    [OptimizationSystem](https://mtk.sciml.ai/stable/tutorials/optimization/)为MTK中的系统类型之一

## 参数辨识概念

系统中的参数作为优化变量，找到一组参数，使得通过模型计算结果与实际值误差最小，实际值一般为一系列数值。参数辨识本质为回归问题。数学表达如下：

```math
y = f(a,b)\\
\min (y_{real} - y)^2\\
```

## 实例

考虑下面的模型：

```math
y = ax^2+sin(bx)\\a=1.5,b=0.8
```

采用生成数据的方法构造真实的数据$y_{real}$。
方法为通过模型计算出准确值并加上随机误差。


```julia
##### 生成真实数据 ####
x = collect(-1:0.01:1)
N = length(x)
# 产生随机误差，范围在-0.1~0.1之间
rands = rand(-0.1:0.01:0.1, N)
a1 = 1.5
a2 = 0.8
# 计算y值
y = @. a1 * x^2 + sin(a2 * x) + rands

```
因为测试数据集$y_{real}$本身即来自模型，同时添加的扰动范围不大，可以认为数据集的内涵就是模型$y = ax^2+sin(bx)$
接下来构建问题并且求解：

```julia
# 计算损失Loss
@variables para[1:2]
errors = @. (para[1] * x^2 + sin(para[2] * x) - y)^2

# 计算方差和，采用均方差亦可
Loss = sum(errors)

# 构建问题并求解
@named sys = OptimizationSystem(Loss, [para[i] for i in 1:2], [])
a0 = [0.1,0.1]
prob = OptimizationProblem(sys, a0, [], grad=true, hess=true, reltol=1e-8, abstol=1e-8)
s = solve(prob, Optim.Newton())
```

最后的结果为:

```julia
u: 2-element Vector{Float64}:
 1.502064883762093
 0.7908724806965902
```

和我们的真实值$a=1.5,b=0.8$比较接近。
优化成功！

!!! tip
    影响优化效果的因素有

    * 初值
    * 生成扰动大小

    可以尝试修改它们并查看求解效果。

全部代码：

```julia
using ModelingToolkit, GalacticOptim, Optim
Loss = 0.0
#number of samples
ypre = 0
#y-predict
x = collect(-1:0.01:1)
N = length(x)
rands = rand(-0.1:0.01:0.1, N)
a1 = 1.5
a2 = 0.8
y = @. a1 * x^2 + sin(a2 * x) + rands


@variables para[1:2]
errors = @. (para[1] * x^2 + sin(para[2] * x) - y)^2
Loss = sum(errors)

#Opt
@named sys = OptimizationSystem(Loss, [para[i] for i in 1:2], [])
a0 = [0.1, 0.1]
prob = OptimizationProblem(sys, a0, [], grad=true, hess=true, reltol=1e-8, abstol=1e-8)
s = solve(prob, Optim.Newton())
```