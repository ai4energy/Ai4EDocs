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



@named resistor = Resistor(R=3.0)
@named capacitor = Capacitor(C=1.0 / 24)
@named source = ChangeableVoltage()
@named inductor = Inductor(L=0.1)
@named ground = Ground()


rc_eqs = [
    connect(source.p, capacitor.p)
    connect(capacitor.n, inductor.p)
    connect(inductor.n, resistor.p)
    connect(source.n, resistor.n, ground.g)
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
prob = ODAEProblem(sys, u0, (0, 10.0))
sol = solve(prob, Tsit5())
sol[resistor.p.i]
p1 = plot(sol, vars=[capacitor.v capacitor.p.i], xlims=(0, 10), ylim=(-20, 20))
p2 = plot(sol, vars=[inductor.v inductor.i], xlims=(0, 10), ylim=(-5, 5))
plot(p1, p2, layout=(2, 1))
