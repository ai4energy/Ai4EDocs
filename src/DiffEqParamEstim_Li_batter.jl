
using DiffEqParamEstim, DifferentialEquations, Random, ModelingToolkit, PlotlyJS
using OptimizationOptimJL
using IfElse: ifelse
import RecursiveArrayTools.VectorOfArray
@variables t
∂ = Differential(t)
@connector function Pin(; name)
    sts = @variables v(t) = 1.0 i(t) = 1.0 [connect = Flow]
    ODESystem(Equation[], t, sts, []; name=name)
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
function OnePort_key(; name, v_start=1.0, i_start=0.0)
    @named p = Pin()
    @named n = Pin()
    sts = @variables v(t) = v_start [irreducible = true] i(t) = i_start [irreducible = true]
    eqs = [
        v ~ p.v - n.v
        0 ~ p.i + n.i
        i ~ p.i
    ]
    compose(ODESystem(eqs, t, sts, []; name=name), p, n)
end
function Ground(; name)
    @named g = Pin()
    eqs = [g.v ~ 0]
    compose(ODESystem(eqs, t, [], []; name=name), g)
end
function Lithium_ion_batteries(; name, OCV=3.9998, R0=0.029031, R1=0.00994, R2=0.01408, C1=147.462, C2=902.911)
    @named oneport = OnePort()
    @unpack v, i = oneport
    sts = @variables v_c1(t) = 0.001 v_c2(t) = 0.001 v_b(t) = 1.0 i_b(t) = 0.0
    ps = @parameters(
        R0 = R0,
        R1 = R1,
        R2 = R2,
        C1 = C1,
        C2 = C2,
        OCV = OCV,
    )
    eqs = [
        OCV ~ i_b * R0 + v_c1 + v_c2 + v_b
        i_b ~ C1 * ∂(v_c1) + v_c1 / R1
        i_b ~ C2 * ∂(v_c2) + v_c2 / R2
        v ~ v_b
        i ~ -i_b
    ]
    return extend(ODESystem(eqs, t, sts, ps; name=name), oneport)
end
function charge_controller(; name)
    @named oneport = OnePort_key()
    @unpack v, i = oneport
    equa = ifelse(t <= 10.0, 16.0, ifelse(t <= 40.0, 0.0, ifelse(t <= 50.0, -16.0, 0.0)))
    eqs = [i ~ equa]
    return extend(ODESystem(eqs, t, [], []; name=name), oneport)
end


@named ground = Ground()
@named cg = charge_controller()
@named batter = Lithium_ion_batteries()
eqs = [
    connect(batter.p, cg.p)
    connect(batter.n, cg.n, ground.g)
]



@named OdeFun = ODESystem(eqs, t)
@named model = compose(OdeFun, [batter, cg, ground])
sys = structural_simplify(model)


#仿真计算
u0 = [
    batter.v_c1 => 0.0
    batter.v_c2 => 0.0
    cg.v => 0
    cg.i => 0
    batter.R0 => 0.037517357
    batter.R1 => 0.020913201
    batter.R2 => 0.006915906
    batter.C1 => 4636.08469
    batter.C2 => 1292.103841
    batter.OCV => 3.955556293
]
prob = ODEProblem(sys, u0, (0.0, 40.0))
sol = solve(prob)
C_av2 = scatter(; name="仿真数据", x=sol.t, y=sol[batter.v_b], mode="lines")
plot([C_av2])

#放电阶段参数估计
begin
    time = [1.502811712
        3.005623424
        4.508435137
        6.011246849
        7.489819663
        11.9982548
        13.50106651
        15.00387822
        16.50668994
        18.00950165
        19.48807446
        20.99088617
        22.49369789
        23.9965096
        25.49932131
        27.00213302
        28.50494474
        30.00775645
        31.51056816
        32.98914097
        34.49195269
        35.9947644]
    real_data = [
        3.335698724
        3.31503268
        3.295860566
        3.277933396
        3.266977902
        3.864799253
        3.878244631
        3.880734516
        3.888702148
        3.897167756
        3.898910675
        3.902645503
        3.908372238
        3.911858077
        3.915094927
        3.918082789
        3.91957672
        3.926797386
        3.923311547
        3.92107065
        3.92107065
        3.926299409]
end


randomized = VectorOfArray([[0, 0, real_data[i], 0] for i in 1:length(time)])
data = convert(Array, randomized)

weight = VectorOfArray([[0.0, 0.0, 1.0, 0.0] for i in 1:length(time)])
data_weight = convert(Array, weight)

obj = build_loss_objective(prob, Rosenbrock23(), L2Loss(time, data, data_weight=data_weight), maxiters=100000)
# using NLopt
# opt = Opt(:LD_LBFGS, 6)
# min_objective!(opt, obj)
# (minf,minx,ret) = NLopt.optimize(opt,[0.029031, 0.00994, 0.01408, 147.462, 902.91, 3.9998])

result = OptimizationOptimJL.optimize(obj,
    [0.037517357, 0.020913201, 0.006915906, 4636.08469, 1292.103841, 3.955556293])
result.minimizer
minx = result.minimizer


#充电阶段参数估计
u0 = [
    batter.v_c1 => 0.024058864
    batter.v_c2 => 0.002594792
    cg.v => 3.928902637
    cg.i => 0
]
prob = ODEProblem(sys, u0, (40.0, 60.0))
begin
    time = [
        40.98797751
        42.00601125
        42.99980609
        43.99360093
        45.01163467
        46.00542951
        46.99922436
        47.9930192
        50.99864262
        53.0104712
        55.99185573
    ]
    real_data = [
        4.511920324
        4.536819172
        4.551011516
        4.570183629
        4.57665733
        4.5881108
        4.593588547
        4.598817305
        3.985060691
        3.94746343
        3.910364146
    ]
end

randomized = VectorOfArray([[0, 0, real_data[i], 0] for i in 1:length(time)])
data = convert(Array, randomized)
weight = VectorOfArray([[0.0, 0.0, 1.0, 0.0] for i in 1:length(time)])
data_weight = convert(Array, weight)

obj = build_loss_objective(prob, Rosenbrock23(), L2Loss(time, data, data_weight=data_weight), maxiters=100000)
result = OptimizationOptimJL.optimize(obj,
    [0.037517357, 0.020913201, 0.006915906, 4636.08469, 1292.103841, 3.955556293])
result.minimizer
minx = result.minimizer

#模型验证
continuous_events = [
    [t ~ 40.0] => [batter.R0 ~ minx[1]
        batter.R1 ~ minx[2]
        batter.R2 ~ minx[3]
        batter.C1 ~ minx[4]
        batter.C2 ~ minx[5]
        batter.OCV ~ minx[6]],
]
@named OdeFun = ODESystem(eqs, t, continuous_events=continuous_events)
@named model = compose(OdeFun, [batter, cg, ground])
sys = structural_simplify(model)

u0 = [
    batter.v_c1 => 0.0
    batter.v_c2 => 0.0
    cg.v => 0.0
    cg.i => 0.0
    batter.R0 => 0.037517357
    batter.R1 => 0.020913201
    batter.R2 => 0.006915906
    batter.C1 => 4636.08469
    batter.C2 => 1292.103841
    batter.OCV => 3.955556293
]


prob = ODEProblem(sys, u0, (0.0, 250.0))
sol = solve(prob)
