# using LinearAlgebra
# F = [1.0 2 2; 0 1 2; 0 0 1]
# Γ = [0.0, 0, 0]
# H = [1.0, 0, 0]
# Q = 0.15

# P = diagm([8.0, 10, 5])
# x = [0, 0, 0.2]

# measure = [0.2, 0.36, 1.56, 3.64, 6.44, 10.5, 14.8, 20.0, 25.2, 32.2, 40.4]

# x_res = zeros(3, 1, 11)
# p_res = zeros(3, 3, 11)

# p_res[:, :, 1] = P
# x_res[:, :, 1] = x

# for i in 1:10
#     _P = F * p_res[:, :, i] * F' .+ Γ' * Q * Γ
#     _G = _P * H * inv(H' * _P * H + Q)
#     _x = F * x_res[:, :, i]
#     global x_res[:, :, i+1] = _x + _G * (measure[i+1] .- H' * _x)
#     global p_res[:, :, i+1] = (1 - _G' * H) * _P
# end


# using Plots

# plot(t, measure)
# plot!(t, x_res[1, 1, :])

using DifferentialEquations
using Statistics, Plots

f(u, t, p) = -(u - 20) + 10

prob = ODEProblem(f, 20.0, (0, 5))

sol = solve(prob, saveat=0.1)
noise = rand(-0.5:0.0001:0.5, length(sol.u))
cov(noise)

measureT = noise + sol.u
t = collect(0:0.1:5)
plot(t, measureT, label="measure", legend_position=:topleft)
plot!(t, sol.u, label="real", legend_position=:topleft)


begin
    F = 0.9
    Γ = 0.1
    H = 1
    Qv = 0.8
    Qw = 10

    P = 10
    x = 20.0

    x_res = zeros(1, length(measureT))
    p_res = zeros(1, length(measureT))

    p_res[:, 1] = [P]
    x_res[:, 1] = [x]

    for i in 1:length(measureT)-1
        _P = F * p_res[1, i] * F' .+ Γ' * Qw * Γ
        _G = _P * H * inv(H * _P * H + Qv)
        _x = F * x_res[1, i] + 3
        global x_res[1, i+1] = _x + _G * (measureT[i+1] - H' * _x)
        global p_res[1, i+1] = (1 - _G' * H) * _P
    end

    plot!(t, x_res[1, :], label="Right Model", legend_position=:topleft)
end


begin
    F = 1
    Γ = 0.1
    H = 1
    Qv = 0.8
    Qw = 1

    P = 10
    x = 20.0

    x_res = zeros(1, length(measureT))
    p_res = zeros(1, length(measureT))

    p_res[:, 1] = [P]
    x_res[:, 1] = [x]

    for i in 1:length(measureT)-1
        _P = F * p_res[1, i] * F' .+ Γ' * Qw * Γ
        _G = _P * H * inv(H * _P * H + Qv)
        _x = F * x_res[1, i]
        global x_res[1, i+1] = _x + _G * (measureT[i+1] - H' * _x)
        global p_res[1, i+1] = (1 - _G' * H) * _P
    end

    plot!(t, x_res[1, :], label="Wrong Model", legend_position=:topleft)
end