using Symbolics, EquationsSolver, LinearAlgebra
# ==========================functions==================== #
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

function x1(A, B, t, C1, C2, M1, M2)
    A = sqrt(A)
    B = inv(A) * B * B / 4
    s = -(B * t) .* exp.(A * t) .* C1
    s = s .+ exp.(A * t) .* M1
    s = s .+ (B * t) .* exp.(-A * t) .* C2
    s = s .+ exp.(-A * t) .* M2
    return s
end

function x2(A, B, t, C1, C2, M1, M2)
    A = sqrt(A)
    B = B * B / 4
    s = (-B * t .* C1 .+ A * M1 .- inv(A) * B * C1) .* exp.(A * t)
    s = s .+ (-B * t .* C2 .- A * M2 .+ inv(A) * B * C2) .* exp.(-A * t)
    return s
end

function SolvePro(eqs, init, vars)
    pro = NLProblem(eqs, init)
    res = solve(pro)
    return [reshape([res[var[i]] for i in 1:3], (3, 1)) for var in vars]
end

function condition(θfields, A, B, tfields, C1, C2, M1, M2)
    res = x1(A, B, tfields[1], C1, C2, M1, M2)
    eqs = [res[i] ~ θfields[1][i] for i in 1:3]
    res = x1(A, B, tfields[2], C1, C2, M1, M2)
    append!(eqs, [res[i] ~ θfields[2][i] for i in 1:3])
    res = x2(A, B, tfields[1], C1, C2, M1, M2)
    append!(eqs, [res[i] ~ θfields[3][i] for i in 1:3])
    res = x2(A, B, tfields[2], C1, C2, M1, M2)
    append!(eqs, [res[i] ~ θfields[4][i] for i in 1:3])
    return eqs
end

function Problem(A, B, θfields, tfields)
    vars = @variables C1[1:3] C2[1:3] M1[1:3] M2[1:3]
    C1, C2, M1, M2 = [reshape(collect(var), 3, 1) for var in vars]
    eqs = condition(θfields, A, B, tfields, C1, C2, M1, M2)
    init = Dict(var[i] => 0.0 for var in vars for i in 1:3)
    return SolvePro(eqs, init, vars)
end


# ==========================main==================== #
A, B = initPara()
θfields = [[π / 3, -π / 4, π / 2], [0, 0, 0], [0, 0, 0], [0, 0, 0]]
tfields = (fill(0.0, 3, 1), fill(1.0, 3, 1))
N = 100
C1, C2, M1, M2 = Problem(A, B, θfields, tfields)
t = (0, 1)

degrees = [x1(A, B, fill(i, 3, 1), C1, C2, M1, M2) for i in range(t[1], t[2], length=N)]
velocity = [x2(A, B, fill(i, 3, 1), C1, C2, M1, M2) for i in range(t[1], t[2], length=N)]


degrees = real.(degrees)
velocity = real.(velocity)
using Plots
filename = "./a.gif"
len = 1
anim = @animate for i in 1:N
    strings = "t=$(i/N*(t[2]-t[1])+t[1])  "
    strings *= "v₁=" * string(round.(velocity[i][1], digits=2))
    strings *= " v₂=" * string(round.(velocity[i][2], digits=2))
    strings *= " v₃=" * string(round.(velocity[i][3], digits=2))
    l = collect(0:0.01:len)
    xs1 = l .* sin(degrees[i][1])
    ys1 = l .* cos(degrees[i][1])
    xs2 = l .* sin(degrees[i][2]) .+ xs1[end]
    ys2 = l .* cos(degrees[i][2]) .+ ys1[end]
    xs3 = l .* sin(degrees[i][3]) .+ xs2[end]
    ys3 = l .* cos(degrees[i][3]) .+ ys2[end]
    plot([xs1, xs2, xs3], [ys1, ys2, ys3],
        ylims=(0, 4), xlims=(-3, 3), w=3,
        grid=false, showaxis=false, legend=false,
        title=strings)
end
gif(anim, filename, fps=24)