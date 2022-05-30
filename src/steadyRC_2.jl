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

function GroundDIFF(; name)
    @named g = Pin()
    sts = @variables v(t)
    D = Differential(t)
    eqs = [
        g.v ~ 0,
        D(v) ~ 0
    ]
    compose(ODESystem(eqs, t, sts, []; name=name), g)
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

function ConstantVoltage(; name, V=1.0)
    @named oneport = OnePort()
    @unpack v = oneport
    ps = @parameters V = V
    eqs = [
        V ~ v
    ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end

function ConstantCurrent(; name, I=1.0)
    @named oneport = OnePort()
    @unpack i = oneport
    ps = @parameters I = I
    # D = Differential(t)
    eqs = [
        i ~ I
    ]
    extend(ODESystem(eqs, t, [], ps; name=name), oneport)
end


@named resistor1 = Resistor(R=5.0)
@named resistor2 = Resistor(R=5.0)
@named resistor3 = Resistor(R=30.0)
@named resistor4 = Resistor(R=20.0)
@named Isource = ConstantCurrent()
@named Vsource1 = ConstantVoltage(V=30.0)
@named Vsource2 = ConstantVoltage(V=5.0)
@named ground = GroundDIFF()


rc_eqs = [
    connect(Vsource1.p, resistor1.p)
    connect(resistor1.n, resistor2.p, Isource.p)
    connect(resistor2.n, resistor3.p, resistor4.p)
    connect(resistor4.n, Isource.n, Vsource2.p)
    connect(Vsource1.n, Vsource2.n, resistor3.n, ground.g)
]

@named _rc_model = ODESystem(rc_eqs, t)
@named rc_model = compose(_rc_model,
    [resistor1, resistor2, resistor3, resistor4,
        Isource, Vsource1, Vsource2, ground])

sys = structural_simplify(rc_model)

using Plots

u0 = [
    ground.v => 0.0
]
prob = ODAEProblem(sys, u0, (0, 10.0))
sol = solve(prob, Tsit5())
observed(sys)
# plot(sol[resistor4.n.i])
