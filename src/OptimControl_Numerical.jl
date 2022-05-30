using JuMP, LinearAlgebra, Ipopt, Statistics

θ = [π / 3, -π / 4, π / 2]
θ = [π / 18, π / 6, π / 4]
θ = [π / 3, π / 4, π / 5]
N = 100
tf = 4.0

#---------------------------------------------#
function initPara()
    J1 = 1.0 / 12 * collect(I(3))
    C1 = 0.5 * [1 2 2; 0 1 2; 0 0 2]
    D1 = 0.5 * [1 0 0; 2 1 0; 4 2 1]
    J = J1 + C1 * D1
    K = 0.5 * [5 0 0; 0 3 0; 0 0 1]
    B = [1 -1 0; 0 1 -1; 0 0 1]
    A = inv(J) * K
    B = inv(J) * B
    return A, B
end
A, B = initPara()
model = Model(Ipopt.Optimizer)
@variables(model, begin
    -π / 2 <= x1[1:N, 1:3] <= π / 2
    x2[1:N, 1:3]
    -10 <= u[1:N, 1:3] <= 10
end)
initzeros = zeros(3)
for j in 1:3
    @NLconstraint(model, x1[1, j] == θ[j])
    @NLconstraint(model, x2[1, j] == initzeros[j])
    @NLconstraint(model, x1[N, j] == initzeros[j])
    @NLconstraint(model, x2[N, j] == initzeros[j])
end
for i in 1:N-1
    a1 = x1[i, :] + (x2[i+1, :] + x2[i, :]) * 0.5 * tf / N
    a2 = x2[i, :] + (A * (x1[i+1, :] + x1[i, :]) + B * (u[i+1, :] + u[i, :])) * 0.5tf / N
    for j in 1:3
        @NLconstraint(model, x1[i+1, j] == a1[j])
        @NLconstraint(model, x2[i+1, j] == a2[j])
    end
end
@NLobjective(model, Min, sum(20 / π * x1[i, j]^2 + u[i, j]^2 for i in 1:N-1 for j in 1:3))
JuMP.optimize!(model)
degrees = JuMP.value.(x1)
velocity = JuMP.value.(x2)


using Plots
filename = "./u_x_a4.gif"
len = 1
anim = @animate for i in 1:N
    strings = "Numerical t=$(i/N*tf)  "
    strings *= "v₁=" * string(round(velocity[i, 1], digits=2))
    strings *= " v₂=" * string(round(velocity[i, 2], digits=2))
    strings *= " v₃=" * string(round(velocity[i, 3], digits=2))
    l = collect(0:0.01:len)
    xs1 = l .* sin(degrees[i, 1])
    ys1 = l .* cos(degrees[i, 1])
    xs2 = l .* sin(degrees[i, 2]) .+ xs1[end]
    ys2 = l .* cos(degrees[i, 2]) .+ ys1[end]
    xs3 = l .* sin(degrees[i, 3]) .+ xs2[end]
    ys3 = l .* cos(degrees[i, 3]) .+ ys2[end]
    plot([xs1, xs2, xs3], [ys1, ys2, ys3],
        ylims=(0, 4), xlims=(-3, 3), w=3,
        grid=false, showaxis=false, legend=false,
        title=strings)
end
gif(anim, filename, fps=24)