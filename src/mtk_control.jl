using ModelingToolkit

@variables t T(t) Q(t)
p = @parameters α β Tout
D = Differential(t)

loss = (58.0 - T)^2
eqs = [
    D(T) ~ α * (Tout - T) + β * Q
]

@named sys = ControlSystem(loss, eqs, t, [T], [Q], p)

dt = 1
tspan = (0.0, 10.0)
sys = runge_kutta_discretize(sys, dt, tspan)

lb = [0.0 for i in 1:length(states(sys))]
ub = [10.0 for i in 1:length(states(sys))]

u0 = rand(length(states(sys))) # guess for the state values
prob = OptimizationProblem(sys, u0, [α => 0.2, β => 0.1, Tout => 18.0], grad=true, lb=lb, ub=ub)

using GalacticOptim, Optim
sol = solve(prob, BFGS())

structural_simplify