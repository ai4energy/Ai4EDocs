using ModelingToolkit, DifferentialEquations
using Dates

println("=====DE TEST=====")
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
p = [A, B, n]
function to_index(i, j, n)
    return (i - 1) * n + j
end
function heat!(dT, T, p, t)
    A, B, n = p
    n = Int(n)
    Tf = 400.0 * (1 + sin(t))
    # 内部节点
    for i in 2:n-1
        for j in 2:n-1
            dT[to_index(i, j, n)] = A * (T[to_index(i + 1, j, n)] + T[to_index(i - 1, j, n)] + T[to_index(i, j + 1, n)] + T[to_index(i, j - 1, n)] - 4 * T[to_index(i, j, n)])
        end
    end
    # 边边界
    for i in 2:n-1
        dT[to_index(i, 1, n)] = A * (T[to_index(i + 1, 1, n)] + T[to_index(i - 1, 1, n)] + T[to_index(i, 2, n)]) - (3B + A) * T[to_index(i, 1, n)] + B * Tf
    end
    for i in 2:n-1
        dT[to_index(i, n, n)] = A * (T[to_index(i + 1, n, n)] + T[to_index(i - 1, n, n)] + T[to_index(i, n - 1, n)]) - (3B + A) * T[to_index(i, n, n)] + B * Tf
    end
    for i in 2:n-1
        dT[to_index(1, i, n)] = A * (T[to_index(1, i + 1, n)] + T[to_index(1, i - 1, n)] + T[to_index(2, i, n)]) - (3B + A) * T[to_index(1, i, n)] + B * Tf
    end
    for i in 2:n-1
        dT[to_index(n, i, n)] = A * (T[to_index(n, i + 1, n)] + T[to_index(n, i - 1, n)] + T[to_index(n - 1, i, n)]) - (3B + A) * T[to_index(1, i, n)] + B * Tf
    end
    # 角边界
    dT[to_index(1, 1, n)] = A * (T[to_index(2, 1, n)] + T[to_index(1, 2, n)]) - (2B + 2A) * T[to_index(1, 1, n)] + 2B * Tf
    dT[to_index(n, n, n)] = A * (T[to_index(n - 1, n, n)] + T[to_index(n, n - 1, n)]) - (2B + 2A) * T[to_index(n, n, n)] + 2B * Tf
    dT[to_index(n, 1, n)] = A * (T[to_index(n, 2, n)] + T[to_index(n - 1, 1, n)]) - (2B + 2A) * T[to_index(n, 1, n)] + 2B * Tf
    dT[to_index(1, n, n)] = A * (T[to_index(2, n, n)] + T[to_index(1, n - 1, n)]) - (2B + 2A) * T[to_index(1, n, n)] + 2B * Tf
end
u0 = [1000.0 for i in 1:n for j in 1:n]
prob = ODEProblem(heat!, u0, (0, 100), p, saveat=1)
sol = solve(prob, Tsit5())
endtime = now()
println("time use:"*string(endtime - starttime))


# an_len = length(sol.u)

# using Plots, GR
# res = rand(n, n, an_len)
# for t in 1:an_len
#     for i in 1:n
#         for j in 1:n
#             res[i, j, t] = sol.u[t][to_index(i, j, n)]
#         end
#     end
# end
# xs = LinRange(0.0, L, n)
# ys = LinRange(0.0, L, n)

# anim = @animate for i ∈ 1:an_len
#     contourf!(xs, ys, res[:, :, i])
# end
# gif(anim, "DE_trans.gif", fps=24)
