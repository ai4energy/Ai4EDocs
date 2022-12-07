using ModelingToolkit, DifferentialEquations

# 定义独立时间变量
@variables t

# 器件端口作为连接点
@connector function Pin(; name)
    sts = @variables v(t) = 1.0 i(t) = 1.0 [connect = Flow]
    return ODESystem(Equation[], t, sts, []; name=name)
end

# 地
function Ground(; name)
    @named g = Pin()
    eqs = [g.v ~ 0; g.i ~ 0]
    return compose(ODESystem(eqs, t, [], []; name=name), g)
end
# 电阻元件
function Resistor(; name, R=1.0)
    @named p = Pin()
    @named n = Pin()
    ps = @parameters R = R
    eqs = [
        p.v - n.v ~ p.i * R
        0 ~ p.i + n.i
    ]
    return compose(ODESystem(eqs, t, [], ps; name=name), p, n)
end
# 电容元件
function Capacitor(; name, C=1.0)
    @named p = Pin()
    @named n = Pin()
    ps = @parameters C = C
    sts = @variables v(t) = 1.0
    D = Differential(t)
    eqs = [
        v ~ p.v - n.v
        D(v) ~ p.i / C
        0 ~ p.i + n.i
    ]
    return compose(ODESystem(eqs, t, sts, ps; name=name), p, n)
end
# 电压源
function ConstantVoltage(; name, V=1.0)
    @named p = Pin()
    @named n = Pin()
    ps = @parameters V = V
    eqs = [
        V ~ p.v - n.v
        0 ~ p.i + n.i
    ]
    return compose(ODESystem(eqs, t, [], ps; name=name), p, n)
end

# 定义组件
R = 1.0
C = 1.0
V = 1.0
@named resistor = Resistor(R=R)
@named capacitor = Capacitor(C=C)
@named source = ConstantVoltage(V=V)
@named ground = Ground()

# 构建连接关系
rc_eqs = [
    connect(source.p, resistor.p) # 注意电源的正负极定义与器件的定义方式不同
    connect(resistor.n, capacitor.p)
    connect(capacitor.n, source.n, ground.g)
]
# 组件与组件连接关系一起构建系统
@named _rc_model = ODESystem(rc_eqs, t)
@named rc_model = compose(_rc_model,
    [resistor, capacitor, source, ground])

# 系统化简
sys = structural_simplify(rc_model)

# 定义初值
u0 = [
    capacitor.v => 0.0
]

# 求解
prob = ODAEProblem(sys, u0, (0, 10.0))
sol = solve(prob, Tsit5())

# 查看
sol[capacitor.v]
sol[resistor.n.v]
sol[capacitor.p.v]