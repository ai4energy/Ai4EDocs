using ModelingToolkit
using DifferentialEquations
using Plots
@variables t x(t)
D = Differential(t)
eqs =[
    D(x) ~ 1-x
]
@named sys = ODESystem(eqs)
tspan = (0.0,10.0)
u0 =[
    x => 0.0
]

prob = ODEProblem(sys,u0,tspan,[])
sol = solve(prob,Tsit5())
plot(sol)