
# MTK常见问题

!!! tip
    Contents：建模、MTK、外部函数

    Contributor: YYB

    Email: 812987139@qq.com

    如有错误，请批评指正。

## UndefVarError

目前官方在此方面可能有bug，可以关注模型边界条件尝试避开问题

## key not found

在structural_simplify后，有些等式条件会自动微分，导致变量数没变，但是方程增加，进而导致模型不平衡

## xxx are missing from variables map

可能是初值没有设置。建议所有模型均设置初值，动态模型初值直接输入至defaults参数。

```julia
@connector function flowPortNode(; name)
    #通流元件节点，在热力学节点上包装了体积、质量流量 
    #如果同时需要标记connect类型，还要赋值，那么一定要括起来
    #initialValue写作Dict或者数组都可以
    sts = @variables begin
        p(t)
        T(t)
        (qm(t), [connect = Flow])
        (rho(t), [connect = Stream])
        (mu(t), [connect = Stream])
        (qv(t), [connect = Stream])
    end
    initialValue = [
        p => 1.013e5
        T => 300
        qm => 0
        rho => 1.2
        mu => 1.819e-5
        qv => 0
    ]
    eqs = [
        0 ~ stateEquation(p, rho, T)
        mu ~ 1.819e-5
        #qm ~ rho * qv
        qv ~ qm / rho
    ]
    ODESystem(eqs, t, sts, []; name=name, defaults=initialValue)
end
```

在生成问题前再统一传入初值。

```julia
u01 = [
    d_temp => 0
]

a = ModelingToolkit.defaults(sys1)
for i in keys(a)
    global u01
    u01 = [u01; i => a[i]]
end
```

该问题的产生原因与DAE问题的求解算法有关。将DAE问题降指数为ODE问题后，模型可能需要更多的初始条件作为输入。
