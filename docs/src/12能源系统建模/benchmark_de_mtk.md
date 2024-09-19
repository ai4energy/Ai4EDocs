# MTK为什么比DE慢？

!!! tip
    Contents：代码优化

    Contributor: HY

    Email:1171006975@qq.com

    如有错误，请批评指正。

## 前言

SCIML是一个非常强大的开源社区，提供了从建模到仿真的一条龙计算工具链。

建模用[ModelingToolkit.jl](https://mtk.sciml.ai/stable/)；求解用[DifferentialEquations.jl](https://diffeq.sciml.ai/dev_/)。

## MTK和DE计算时间对比

以一个简单的ODE为例：
$$\frac{\partial T}{\partial t}=p*t*T$$

一个ODE算的太快了，体现不出来差距，我们重复这个方程n次，组成一个n维的ODEs。
$$\frac{\partial T(i)}{\partial t}=p*t*T(i),i∈(1,2,3...,n)$$

然后我们用MTK方法和DE方法分别建模：

### DE方法

```
using ModelingToolkit, DifferentialEquations
n=10000
#DE
function de_test!(dT, T, p, t)
    n=length(T)
    for i in 1:n
        dT[i]=p[i]*t*T[i]
    end
    nothing
end
u0 = [1.0 for i in 1:n]
p = [1e-3 for i in 1:n]
prob_de = ODEProblem(de_test!, u0, (0, 100), p, saveat=1)
@time sol_de=solve(prob_de);
```

### MTK方法
```
#ModelingToolkit
@variables t 
∂ = Differential(t)
sts = @variables T(t)[1:n]=1.0 
par = @parameters p[1:n]=1e-3
eqs=[∂(T[i])~p[i]*t*T[i] for i in 1:n]
@named sys_mtk = ODESystem(eqs,t,sts...,par...)
@named prob_mtk = ODEProblem(sys_mtk,[],(0,100))
@time sol_mtk=solve(prob_mtk);
```
计算结果：
```
#第一次计算(包含预编译时间)
#@time sol_de=solve(prob_de);
 0.265494 seconds (217.39 k allocations: 21.561 MiB, 95.65% compilation time: 100% of which was recompilation)
 #@time sol_mtk=solve(prob_mtk);
 507.240792 seconds (193.00 M allocations: 6.895 GiB, 0.84% gc time, 100.00% compilation time)

 #第二次计算(不需要预编译)
 #@time sol_de=solve(prob_de);
0.013862 seconds (453 allocations: 10.783 MiB)
 #@time sol_mtk=solve(prob_mtk);
0.009364 seconds (451 allocations: 10.489 MiB)
```

我们可以很惊奇的发现，MTK的编译时间竟然要500秒！而DE却只要0.26秒。但是在第二次计算时，MTK却实现了弯道超车，时间只需要0.009秒，而DE需要0.013秒。

这是什么原因导致的呢？有同学可能会说，是不是符号运算导致系统额外的开销？尤其是编译时，符号运算会不会导致编译时间大幅增加？但是，我们只统计了`solve`这个步骤的时间，符号运算确实很费时间，但主要是体现在`ODESystem`和`structural_simplify`这些步骤上。到了`solve`时，其实符号运算已经完成了，已经生成了对应的函数了，在接下来的运算中，应该是基于生成的函数进行计算，而不是进行符号计算。那么，编译时间慢，到底是不是符号运算导致的呢？

或许，我们可以尝试将MTK中生成的函数剥离出来，直接进行DE运算，彻底摒弃MTK中所有与符号相关的东西。

简单写一个函数，把MTK中生成的函数取出来：

```
#get_expr_from_mtk
using RuntimeGeneratedFunctions
_cache_lock = Threads.SpinLock()
_cachename = Symbol("#_RuntimeGeneratedFunctions_cache")
_tagname = Symbol("#_RGF_ModTag")
function get_expr(f::RuntimeGeneratedFunction{argnames, cache_tag, context_tag, id}) where {
    argnames,
    cache_tag,
    context_tag,
    id,
}
    return Expr(:->, Expr(:tuple, argnames...), _lookup_body(cache_tag, id))
end
function _lookup_body(cache_tag, id)
    lock(_cache_lock) do
        cache = getfield(parentmodule(cache_tag), _cachename)
        body = cache[id]
        body isa WeakRef ? body.value : body
    end
end
mtk_expr = get_expr(prob_mtk.f.f.f_iip);
```

提取出来的代码比较长，我大概展示一下：

```
:(
    (_-out, -arg1,-arg2,t)->
    begin
    ˍ₋out[1] = (*)((*)(t, ˍ₋arg2[1]), ˍ₋arg1[1])
    ˍ₋out[2] = (*)((*)(t, ˍ₋arg2[2]), ˍ₋arg1[2])
    ˍ₋out[3] = (*)((*)(t, ˍ₋arg2[3]), ˍ₋arg1[3])
    ...
    ˍ₋out[9997] = (*)((*)(t, ˍ₋arg2[9997]), ˍ₋arg1[9997])
    ˍ₋out[9998] = (*)((*)(t, ˍ₋arg2[9998]), ˍ₋arg1[9998])
    ˍ₋out[9999] = (*)((*)(t, ˍ₋arg2[9999]), ˍ₋arg1[9999])
    ˍ₋out[10000] = (*)((*)(t, ˍ₋arg2[10000]), ˍ₋arg1[10000])
    end
)
```


这是一个`Expr`，我们`eval`一下，就是一个函数了，然后我们生成对应的`ODEProblem`，再`solve`一下。
```
u0 = [1.0 for i in 1:n]
p = [1e-3 for i in 1:n]
prob_mtk_expr = ODEProblem(eval(mtk_expr), u0, (0, 100), p, saveat=1)
@time sol_mtk_expr=solve(prob_mtk_expr);
```
计算结果：
```
#@time sol_mtk_expr=solve(prob_mtk_expr);
#第一次
513.691586 seconds (129.78 M allocations: 4.903 GiB, 0.36% gc time, 100.00% compilation time)
#第二次
0.020437 seconds (453 allocations: 10.783 MiB)
```
抛掉了MTK中所有的符号运算，只保留DE最原汁的本味，我们发现，编译时间竟然还需要513秒！这说明，导致MTK编译时间长的"罪魁祸首"不是符号运算！

真正的"罪魁祸首"是什么呢？我们对比一下手搓的DE和MTK自动生成的DE：

```
#手搓DE
function de_test!(dT, T, p, t)
    n=length(T)
    for i in 1:n
        dT[i]=p[i]*t*T[i]
    end
    nothing
end

#MTK自动生成DE
(_-out, -arg1,-arg2,t)->
    begin
    ˍ₋out[1] = (*)((*)(t, ˍ₋arg2[1]), ˍ₋arg1[1])
    ˍ₋out[2] = (*)((*)(t, ˍ₋arg2[2]), ˍ₋arg1[2])
    ˍ₋out[3] = (*)((*)(t, ˍ₋arg2[3]), ˍ₋arg1[3])
    ...
    ˍ₋out[9997] = (*)((*)(t, ˍ₋arg2[9997]), ˍ₋arg1[9997])
    ˍ₋out[9998] = (*)((*)(t, ˍ₋arg2[9998]), ˍ₋arg1[9998])
    ˍ₋out[9999] = (*)((*)(t, ˍ₋arg2[9999]), ˍ₋arg1[9999])
    ˍ₋out[10000] = (*)((*)(t, ˍ₋arg2[10000]), ˍ₋arg1[10000])
end
```

大家看出区别了吗？手搓DE用的是`for`循环，而MTK生成的DE将方程组全部展开了！在Julia中，`for`能够很好的被编译优化，而将方程组展开，会消耗大量的计算资源用于编译优化！

因此，我们可以得出一个结论：在DE中，适当运用`for`，能够显著提高编译速度！

进一步的，既然`for`可以，那`broadcast`可以不可以呢？咱们试试：

```
function de_broadcast_test!(dT, T, p, t)
    dT .= p*t.*T
    nothing
end
u0 = [1.0 for i in 1:n]
p = [1e-3 for i in 1:n]
prob_de = ODEProblem(de_broadcast_test!, u0, (0, 100), p, saveat=1)
@time sol_de=solve(prob_de);
```

计算结果：
```
#第一次
 0.605884 seconds (1.17 M allocations: 75.106 MiB, 97.80% compilation time)
#第二次
 0.013741 seconds (603 allocations: 16.509 MiB)
```

对比`for`和`broadcast`的计算结果，我们发现两者相差不大，编译时间都远远小于MTK生成的代码。

## 小结

1.MTK编译慢的原因不全是因为符号计算，还有一部分原因是自动生成的函数不利于编译优化。

2.在编写函数的过程中，适当运用`for`和`broadcast`可以显著提高代码性能，减少编译时间。
