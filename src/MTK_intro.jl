using ModelingToolkit
using DifferentialEquations
@variables t x(t) y(t) z(t)
@parameters  σ ρ β
D = Differential(t)
eqs =[
    D(x) ~ σ*(y-x)
    D(y) ~ x*(ρ-z) - y
    D(z) ~ x*y - β*z
]
@named sys = ODESystem(eqs)
tspan = (0.0,10.0)
u0 =[
    x => 1.0
    y => 0.0
    z => 0.0
]
p=[
    σ => 10.0
    ρ => 28.0
    β => 8/3
]
prob = ODEProblem(sys,u0,tspan,p)
sol = solve(prob,Tsit5())