using CSV, DataFrames, Plots
data = CSV.read("./data.csv", DataFrame)
data[!, 3]
plot(data[:, 1], data[:, 3]) #画出图像

using DifferentialEquations
function fun(a)
    if a >= 0
        1
    else
        0
    end
end
function ff(u, p, t)
    -u * fun(t - p[3]) / p[1] + p[2] * fun(t - p[3]) / p[1]
end

u0 = 3.6
tspan = (0.0, 3000.0)
p = [1.0, 1.0, 1.0]
prob = ODEProblem(ff, u0, tspan, p)

sol = solve(prob, Tsit5())
plot(sol)

using DiffEqParamEstim
realdata = data[:, 3]
t = data[:, 1]
cost_function = build_loss_objective(prob, Tsit5(), L2Loss(t, realdata),
    maxiters=10000, verbose=false)

using Optim
result_bfgs = Optim.optimize(cost_function, [1.0, 1.0, 1.0])
print(result_bfgs.minimizer)

result_bfgs = Optim.optimize(cost_function, [773.0,49.0,652.0])
print(result_bfgs.minimizer)


u0=3.6
tspan = (0.0,3000.0)
p = [267.0,45.0,343.0]
prob = ODEProblem(ff,u0,tspan,p)
sol = solve(prob, Tsit5())
plot(sol)
