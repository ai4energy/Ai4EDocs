# using DifferentialEquations,Plots
# function lorenz!(du,u,p,t)
#         du[1] = p[1]*(u[2]-u[1])
#         du[2] = u[1]*(p[2]-u[3]) - u[2]
#         du[3] = u[1]*u[2] - p[3]*u[3]
# end
# p = [10.0,28.0,8/3]
# u0 = [1.0;0.0;0.0]
# tspan = (0.0,100.0)
# prob = ODEProblem(lorenz!,u0,tspan,p)
# sol = solve(prob, Tsit5())
# plot(sol,vars=(1,2,3))

function f(du, u, p, t)
    du[1] = u[2]
    du[2] = -p
end
function condition(u, t, integrator) # Event when event_f(u,t) == 0
    u[1]
end
function affect!(integrator)
    integrator.u[2] = -integrator.u[2]
end
cb = ContinuousCallback(condition, affect!)
u0 = [50.0, 0.0]
tspan = (0.0, 15.0)
p = 9.8
prob = ODEProblem(f, u0, tspan, p)
sol = solve(prob, Tsit5(), callback=cb)
plot(sol)
