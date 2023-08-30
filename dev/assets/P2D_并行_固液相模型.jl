using ModelingToolkit, DifferentialEquations
using Interpolations
using DelimitedFiles
using Sundials
using NonlinearSolve
@variables t
∂ = Differential(t)
function zhankai(list)
    jieguo = []
    for i in list
        println(i...)
        push!(jieguo, i...)
    end
    return jieguo
end
function P2D_Libatter_chemistry(; name, soc_init_neg=0.9, soc_init_pos=0.1,
    L_neg=46.6e-6, L_sep=18.7e-6, L_pos=43e-6, r_s_neg=6.3e-6, r_s_pos=2.13e-6,
    n_mesh_neg=8, n_mesh_sep=8, n_mesh_pos=8, n_mesh_s=9,
    eps_l_neg=0.29, eps_l_sep=0.4, eps_l_pos=0.21,
    eps_s_neg=0.49, eps_s_pos=0.57,
    Bruggeman_neg=1.52, Bruggeman_sep=1.62, Bruggeman_pos=1.44,
    D_s_neg=3e-14, c_s_max_neg=31390, k_ct_neg=2e-11,
    D_s_pos=5e-15, c_s_max_pos=48390, k_ct_pos=2e-11,
    D_l=2.5e-10, tplus=0.26)
    F = 96485
    R = 8.3145
    T = 293.15

    h_neg = L_neg / n_mesh_neg
    h_sep = L_sep / n_mesh_sep
    h_pos = L_pos / n_mesh_pos
    h_s_neg = r_s_neg / n_mesh_s
    h_s_pos = r_s_pos / n_mesh_s

    Sa_neg = 3 * eps_s_neg / r_s_neg # spacific surface area m^2/m^3^, assume sphere shape particle
    Sa_pos = 3 * eps_s_pos / r_s_pos # spacific surface area m^2/m^3^, assume sphere shape particle

    D_l_eff_pos = eps_l_pos^Bruggeman_pos * D_l # effective pos diffusion coefficient of the electrolyte m^2/s
    D_l_eff_neg = eps_l_neg^Bruggeman_neg * D_l # effective neg diffusion coefficient of the electrolyte m^2/s
    D_l_eff_sep = eps_l_sep^Bruggeman_sep * D_l # effective sep diffusion coefficient of the electrolyte m^2/s
    D_s_eff_pos = D_s_pos # effective pos diffusion coefficient of the electrolyte m^2/s
    D_s_eff_neg = D_s_neg # effective neg diffusion coefficient of the electrolyte m^2/s


    #变量
    stas1 = @variables c_l_neg(t)[1:n_mesh_neg+1] = 1000 c_l_pos(t)[1:n_mesh_pos+1] = 1000 c_l_sep(t)[1:n_mesh_sep-1] = 1000
    stas2 = @variables c_s_neg(t)[1:n_mesh_neg+1, 1:n_mesh_s+1] = soc_init_neg * c_s_max_neg c_s_pos(t)[1:n_mesh_pos+1, 1:n_mesh_s+1] = soc_init_pos * c_s_max_pos
    #参数
    pars1 = @parameters U_ct_neg_para(t)[1:n_mesh_neg+1] = 0 U_ct_pos_para(t)[1:n_mesh_pos+1] = 0
    pars2 = @parameters i_ct_neg_para(t)[1:n_mesh_neg+1] = 0 i_ct_pos_para(t)[1:n_mesh_pos+1] = 0


    eqs = [
        #液相扩散方程
        [∂(c_l_neg[i]) ~ (D_l_eff_neg * (c_l_neg[i+1] - c_l_neg[i]) - D_l_eff_neg * (c_l_neg[i] - c_l_neg[i-1]) + i_ct_neg_para[i] * h_neg * (1 - tplus) / F) / (h_neg^2 * eps_l_neg) for i in 2:n_mesh_neg]...
        [∂(c_l_pos[i]) ~ (D_l_eff_pos * (c_l_pos[i+1] - c_l_pos[i]) - D_l_eff_pos * (c_l_pos[i] - c_l_pos[i-1]) + i_ct_pos_para[i] * h_pos * (1 - tplus) / F) / (h_pos^2 * eps_l_pos) for i in 2:n_mesh_pos]...
        [∂(c_l_sep[i]) ~ (D_l_eff_sep * (c_l_sep[i+1] - c_l_sep[i]) - D_l_eff_sep * (c_l_sep[i] - c_l_sep[i-1])) / (h_sep^2 * eps_l_sep) for i in 2:n_mesh_sep-2]...
        ∂(c_l_sep[1]) ~ (D_l_eff_sep * (c_l_sep[2] - c_l_sep[1]) - D_l_eff_sep * (c_l_sep[1] - c_l_neg[end])) / (h_sep^2 * eps_l_sep)
        ∂(c_l_sep[end]) ~ (D_l_eff_sep * (c_l_pos[1] - c_l_sep[end]) - D_l_eff_sep * (c_l_sep[end] - c_l_sep[end-1])) / (h_sep^2 * eps_l_sep)
        ∂(c_l_neg[1]) ~ (D_l_eff_neg * (c_l_neg[2] - c_l_neg[1]) + i_ct_neg_para[1] * h_neg * (1 - tplus) / F) / (h_neg^2 * 0.5 * eps_l_neg)
        ∂(c_l_pos[end]) ~ (-D_l_eff_pos * (c_l_pos[end] - c_l_pos[end-1]) + i_ct_pos_para[end] * h_pos * (1 - tplus) / F) / (h_pos^2 * 0.5 * eps_l_pos)
        ∂(c_l_neg[end]) ~ (D_l_eff_sep / h_sep * (c_l_sep[1] - c_l_neg[end]) - D_l_eff_neg / h_neg * (c_l_neg[end] - c_l_neg[end-1]) + i_ct_neg_para[end] * (1 - tplus) / F) / (h_neg * 0.5 * eps_l_neg + h_sep * 0.5 * eps_l_sep)
        ∂(c_l_pos[1]) ~ (D_l_eff_pos / h_pos * (c_l_pos[2] - c_l_pos[1]) - D_l_eff_sep / h_sep * (c_l_pos[1] - c_l_sep[end]) + i_ct_pos_para[1] * (1 - tplus) / F) / (h_pos * 0.5 * eps_l_pos + h_sep * 0.5 * eps_l_sep)
        # 固相扩散方程
        [∂(c_s_neg[j, i]) ~ (D_s_eff_neg * (i - 0.5)^2 * (c_s_neg[j, i+1] - c_s_neg[j, i]) - D_s_eff_neg * (i - 1.5)^2 * (c_s_neg[j, i] - c_s_neg[j, i-1])) / (h_s_neg^2 * (i^2 - 2 * i + 13 / 12)) for i in [2,n_mesh_s], j in 1:n_mesh_neg+1]...
        [∂(c_s_pos[j, i]) ~ (D_s_eff_pos * (i - 0.5)^2 * (c_s_pos[j, i+1] - c_s_pos[j, i]) - D_s_eff_pos * (i - 1.5)^2 * (c_s_pos[j, i] - c_s_pos[j, i-1])) / (h_s_pos^2 * (i^2 - 2 * i + 13 / 12)) for i in [2,n_mesh_s], j in 1:n_mesh_pos+1]...
        [∂(c_s_neg[j, i]) ~ (D_s_eff_neg * (i - 0.5)^2 * (-1/24*c_s_neg[j,i+2]+9/8*c_s_neg[j, i+1] - 9/8*c_s_neg[j, i] + 1/24*c_s_neg[j,i-1]) - D_s_eff_neg * (i - 1.5)^2 * (-1/24*c_s_neg[j,i+1]+9/8*c_s_neg[j, i] - 9/8*c_s_neg[j, i-1] + 1/24*c_s_neg[j,i-2])) / (h_s_neg^2 * (i^2 - 2 * i + 13 / 12)) for i in 3:n_mesh_s-1, j in 1:n_mesh_neg+1]...
        [∂(c_s_pos[j, i]) ~ (D_s_eff_pos * (i - 0.5)^2 * (-1/24*c_s_pos[j,i+2]+9/8*c_s_pos[j, i+1] - 9/8*c_s_pos[j, i] + 1/24*c_s_pos[j,i-1]) - D_s_eff_pos * (i - 1.5)^2 * (-1/24*c_s_pos[j,i+1]+9/8*c_s_pos[j, i] - 9/8*c_s_pos[j, i-1] + 1/24*c_s_pos[j,i-2])) / (h_s_pos^2 * (i^2 - 2 * i + 13 / 12)) for i in 3:n_mesh_s-1, j in 1:n_mesh_pos+1]...
        [∂(c_s_neg[j, 1]) ~ (D_s_eff_neg / 4 * (c_s_neg[j, 2] - c_s_neg[j, 1])) / (h_s_neg^2 / 24) for j in 1:n_mesh_neg+1]...
        [∂(c_s_pos[j, 1]) ~ (D_s_eff_pos / 4 * (c_s_pos[j, 2] - c_s_pos[j, 1])) / (h_s_pos^2 / 24) for j in 1:n_mesh_pos+1]...
        [∂(c_s_neg[j, end]) ~ (D_s_eff_neg * (n_mesh_s^2 * h_s_neg * (-(F * k_ct_neg * (c_s_max_neg - c_s_neg[j, end])^0.5 * c_s_neg[j, end]^0.5 * c_l_neg[j]^0.5) * (exp(0.5 * F * U_ct_neg_para[j] / R / T) - exp(-0.5 * F * U_ct_neg_para[j] / R / T)) / F / D_s_eff_neg) - (n_mesh_s - 0.5)^2 * (c_s_neg[j, end] - c_s_neg[j, end-1]))) / (h_s_neg^2 / 3 * (n_mesh_s^3 - (n_mesh_s - 0.5)^3)) for j in 1:n_mesh_neg+1]...
        [∂(c_s_pos[j, end]) ~ (D_s_eff_pos * (n_mesh_s^2 * h_s_pos * (-(F * k_ct_pos * (c_s_max_pos - c_s_pos[j, end])^0.5 * c_s_pos[j, end]^0.5 * c_l_pos[j]^0.5) * (exp(0.5 * F * U_ct_pos_para[j] / R / T) - exp(-0.5 * F * U_ct_pos_para[j] / R / T)) / F / D_s_eff_pos) - (n_mesh_s - 0.5)^2 * (c_s_pos[j, end] - c_s_pos[j, end-1]))) / (h_s_pos^2 / 3 * (n_mesh_s^3 - (n_mesh_s - 0.5)^3)) for j in 1:n_mesh_pos+1]...
       ]
    stas = zhankai([stas1..., stas2...])
    pars = zhankai([pars1..., pars2...])
    ODESystem(eqs, t, stas, pars; name=name)
end
function get_chemistery_index(sys)
    x_index = Int64[]
    x_map = states(sys)
    for i in 1:length(batters)
        for j in 1:length(states(sys))
            if isequal(batters[i].v,x_map[j])
                push!(x_index,j)
                break
            end
        end
    end
    return x_index
end