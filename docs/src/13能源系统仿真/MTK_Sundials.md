# MTK调用Sundials计算
!!! tip
    Contents：MTK、Sundials

    Contributor: HY

    Email:1171006975@qq.com

    如有错误，请批评指正。

!!! note

    MTK = ModelingToolkit.jl

    [Sundials](https://computing.llnl.gov/projects/sundials)基于Fortran/C的求解器

    [ModelingToolkit.jl ](https://mtk.sciml.ai/stable/)符号建模包

## 前言

Sundials是一款非常成熟和受欢迎的开源求解器，它在求解速度和适用范围上领先绝大多数求解器。当我们使用传统求解器遇到困难时，不妨调用Sundials试试。

Sundials可以求解ODEs，DAEs和NonlinearEqs等问题。接下来，我将以锂电池的P2D模型为例，分别介绍如何调用Sundials计算`DAEProblem`，`ODEProblem`，`NonlinearProblem`：


## 1.ODEProblem

选取锂电池P2D模型中的ODEs部分进行计算：

```
using ModelingToolkit, DifferentialEquations,Sundials
include("P2D_并行_固液相模型.jl")
include("P2D_并行_电路模型.jl")

#ODEProblem
@named batter_chemistry = P2D_Libatter_chemistry(n_mesh_neg=8, n_mesh_sep=8, n_mesh_pos=8)
@named OdeFun_chemistry = ODESystem([], t)
@named model_chemistry = compose(OdeFun_chemistry, [batter_chemistry])
sys_chemistry = structural_simplify(model_chemistry)
prob_chemistry = ODEProblem(sys_chemistry, [], (0.0, 100.0))
#不调用Sundials
@time sol_chemistry = solve(prob_chemistry);
#调用Sundials
@time sol_chemistry = solve(prob_chemistry, CVODE_Adams());
```

计算结果
```
#不调用Sundials
0.000980 seconds (171 allocations: 828.094 KiB)
#调用Sundials
0.000151 seconds (111 allocations: 37.734 KiB)
```
## 2.NonlinearProblem

选取锂电池P2D模型中的NonlinearEqs部分进行计算：

```
#NonlinearProblem
@named batter_electric = P2D_Libatter_electric()
@named current = Constant(U=20)
@named current_source = Current_source()
@named ground = Ground()
eqs = [
    connect(batter_electric.n, ground.g, current_source.n)
    connect(batter_electric.p, current_source.p)
    connect(current.u, current_source.u)]
@named OdeFun_electric = ODESystem(eqs, t)
@named model_electric = compose(OdeFun_electric, [batter_electric, current, current_source, ground])
sys_electric = structural_simplify(model_electric)
prob_electric = NonlinearProblem(ODEProblem(sys_electric, [], (0.0, 0.0), []))
#不调用Sundials
@time sol_electric = solve(prob_electric);
#调用Sundials
@time sol_electric = solve(prob_electric, KINSOL());
```

计算结果
```
#不调用Sundials
0.000283 seconds (92 allocations: 31.922 KiB)
#调用Sundials
0.000487 seconds (270 allocations: 11.703 KiB)
```

## 3.DAEProblem

选取锂电池P2D模型(DAEs)进行计算：

### NOTE:如果之前建模生成的是ODESystem，需要生成对应的DAEProblem才能调用Sundials进行求解，不调用Sundials的话，直接生成ODEProblem即可。
```
#DAEProblem
include("P2D组件 copy.jl")

series_num=1;
parallel_num=1;
batters = [@named batter[(i-1)*series_num+j]= P2D_Libatter() for i in 1:parallel_num, j in 1:series_num]
@named current = Constant(U = 20);
@named current_source = Current_source();
@named ground = Ground();


eqs = [
    [connect(batters[i,j].n, batters[i,j+1].p) for i in 1:parallel_num, j in 1:series_num-1]...
    [connect(batters[i,1].p, batters[i+1,1].p) for i in 1:parallel_num-1]...
    [connect(batters[i,end].n, batters[i+1,end].n) for i in 1:parallel_num-1]...
    connect(batters[end,end].n, ground.g, current_source.n)
    connect(batters[1,1].p, current_source.p)
    connect(current.u, current_source.u)

]

@named OdeFun = ODESystem(eqs, t)
@named model = compose(OdeFun, [batters..., current, current_source, ground])

sys = structural_simplify(model)

prob = DAEProblem(sys, zeros(length(states(sys))),[], (0.0, 2500.0),[])
prob_ode = ODEProblem(sys,[], (0.0, 2500.0),[])
#不调用Sundials
@time sol = solve(prob_ode);
#调用Sundials
@time sol = solve(prob,IDA());
```

计算结果
```
#不调用Sundials
0.313776 seconds (13.57 k allocations: 7.203 MiB)
#调用Sundials
0.095321 seconds (38.60 k allocations: 1.576 MiB)
```

## 总结

Sundials求解器和SCIML默认的求解器各有胜负。总的来说，对于一些简单的方程组，SCIML默认的求解器更快，对于一些较为复杂的方程组，Sundials求解器更快。
