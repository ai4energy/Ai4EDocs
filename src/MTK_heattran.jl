using ModelingToolkit, DifferentialEquations
using Dates

println("=====MTK TEST=====")
starttime = now()

a = 1.27E-5
n = 10
L = 0.2
δ = L / n
λ = 50
h = 1.0E9
Tf = 0.0
A = a / δ^2
B = a / (δ^2 / 2 + δ * λ / h)

@variables t T[1:n, 1:n](t)

D = Differential(t)

insides = [
    D(T[i, j]) ~ A * (T[i+1, j] + T[i-1, j] + T[i, j+1] + T[i, j-1] - 4 * T[i, j])
    for i in 2:n-1 for j in 2:n-1]

Wb = [
    D(T[i, 1]) ~ A * (T[i+1, 1] + T[i-1, 1] + T[i, 2]) - (3B + A) * T[i, 1] + B * Tf
    for i in 2:n-1
]

Eb = [
    D(T[i, n]) ~ A * (T[i+1, n] + T[i-1, n] + T[i, n-1]) - (3B + A) * T[i, n] + B * Tf
    for i in 2:n-1
]

Nb = [
    D(T[1, i]) ~ A * (T[1, i+1] + T[1, i-1] + T[2, i]) - (3B + A) * T[1, i] + B * Tf
    for i in 2:n-1
]

Sb = [
    D(T[n, i]) ~ A * (T[n, i+1] + T[n, i-1] + T[n-1, i]) - (3B + A) * T[1, i] + B * Tf
    for i in 2:n-1
]

# 4 corner boundary

corner = [
    D(T[1, 1]) ~ A * (T[2, 1] + T[1, 2]) - (2B + 2A) * T[1, 1] + 2B * Tf,
    D(T[n, n]) ~ A * (T[n-1, n] + T[n, n-1]) - (2B + 2A) * T[n, n] + 2B * Tf,
    D(T[n, 1]) ~ A * (T[n, 2] + T[n-1, 1]) - (2B + 2A) * T[n, 1] + 2B * Tf,
    D(T[1, n]) ~ A * (T[2, n] + T[1, n-1]) - (2B + 2A) * T[1, n] + 2B * Tf
]


eqs = append!(insides, Wb, Eb, Nb, Sb, corner)

@named sys = ODESystem(eqs, t)

sys = structural_simplify(sys)

u0 = [1000.0 for i in 1:n for j in 1:n]
prob = ODEProblem(sys, u0, (0, 100), [], saveat=1)
sol = solve(prob, Tsit5())

endtime = now()
println("time use:"*string(endtime - starttime))
# using Plots, GR
# res = rand(n,n,an_len)
# for t in 1:an_len
#     for i in 1:n
#         for j in 1:n
#             res[i,j,t] = sol[T[i,j]][t]
#         end
#     end
# end
# xs = LinRange(0.0, L, n)
# ys = LinRange(0.0, L, n)
# contourf!(xs, ys, res[:,:,10])
# anim = @animate for i ∈ 1:50
#     contourf!(xs, ys, res[:,:,i])
# end
# gif(anim, "anim.gif", fps = 24)