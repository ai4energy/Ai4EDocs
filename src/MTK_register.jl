using ModelingToolkit,CoolProp,DifferentialEquations
@variables t T(t)
D = Differential(t)
function u(t)
    PropsSI("H","P",1.0E6,"T",t,"Water")
end
@register u(t)
eqs = [
    D(T) ~ u(t+300.0)
]
@named sys = ODESystem(eqs)
sys = structural_simplify(sys)
u0=[
    T => 0.0
]
tspan = (0.0,100.0)
prob = ODEProblem(sys,u0,tspan,[])
sol = solve(prob)
using Plots
plot(sol)
