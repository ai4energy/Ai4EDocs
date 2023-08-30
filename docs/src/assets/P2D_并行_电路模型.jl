using ModelingToolkit, DifferentialEquations
using Interpolations
using DelimitedFiles
using Sundials
using NonlinearSolve
@variables t
∂ = Differential(t)
@connector function Pin(; name)
    sts = @variables v(t) = 1.0 i(t) = 1.0 [connect = Flow]
    ODESystem(Equation[], t, sts, []; name=name)
end
@connector function RealInput(; name, nin = 1, u_start = nin > 1 ? zeros(nin) : 0.0)
    if nin == 1
        @variables u(t)=u_start [input = true]
    else
        @variables u(t)[1:nin]=u_start [input = true]
        u = collect(u)
    end
    ODESystem(Equation[], t, [u...], []; name = name)
end
@connector function RealOutput(; name, nout = 1, u_start = nout > 1 ? zeros(nout) : 0.0)
    if nout == 1
        @variables u(t)=u_start [output = true]
    else
        @variables u(t)[1:nout]=u_start [output = true]
        u = collect(u)
    end
    ODESystem(Equation[], t, [u...], []; name = name)
end
function Ground(; name)
    @named g = Pin()
    eqs = [g.v ~ 0]
    compose(ODESystem(eqs, t, [], []; name=name), g)
end
function OnePort(; name, v_start=1.0, i_start=-1.0)
    @named p = Pin()
    @named n = Pin()
    sts = @variables begin
        v(t) = v_start
        i(t) = i_start
    end
    eqs = [v ~ p.v - n.v
        0 ~ p.i + n.i
        i ~ p.i]
    return compose(ODESystem(eqs, t, sts, []; name=name), p, n)
end
function OnePort_key(; name, v_start=1.0, i_start=-1.0)
    @named p = Pin()
    @named n = Pin()
    sts = @variables v(t) = v_start [irreducible = true] i(t) = i_start [irreducible = true]
    eqs = [
        v ~ p.v - n.v
        0 ~ p.i + n.i
        i ~ p.i
    ]
    compose(ODESystem(eqs, t, sts, []; name=name), p, n)
end
function Current_source(; name)
    @named oneport = OnePort()
    @unpack v, i = oneport
    @named u = RealInput()
    eqs = [
        i ~ u.u,
    ]

    extend(ODESystem(eqs, t, [], []; name=name, systems=[u]), oneport)
end
function Constant(; name, U = 1)
    @named u = RealOutput()
    pars = @parameters U = U
    eqs = [
        u.u ~ U,
    ]
    compose(ODESystem(eqs, t, [], pars; name = name), [u])
end
function calculate_ocv_neg(soc, ocv_neg::Interpolations.Extrapolation)
    return ocv_neg(soc)
end
function calculate_ocv_pos(soc, ocv_pos::Interpolations.Extrapolation)
    return ocv_pos(soc)
end
@register_symbolic calculate_ocv_neg(soc, ocv_neg::Interpolations.Extrapolation)
@register_symbolic calculate_ocv_pos(soc, ocv_pos::Interpolations.Extrapolation)
function zhankai(list)
    jieguo = []
    for i in list
        println(i...)
        push!(jieguo, i...)
    end
    return jieguo
end
function P2D_Libatter_electric(; name, soc_init_neg=0.9, soc_init_pos=0.1,
    L_neg=46.6e-6, L_sep=18.7e-6, L_pos=43e-6, r_s_neg=6.3e-6, r_s_pos=2.13e-6,
    n_mesh_neg=8, n_mesh_sep=8, n_mesh_pos=8,
    eps_l_neg=0.29, eps_l_sep=0.4, eps_l_pos=0.21,
    eps_s_neg=0.49, eps_s_pos=0.57,
    Bruggeman_neg=1.52, Bruggeman_sep=1.62, Bruggeman_pos=1.44,
    sigma_s_neg=100, c_s_max_neg=31390, k_ct_neg=2e-11,
    filename_neg="./neg_OCV.txt", filename_pos="./pos_OCV.txt",
    sigma_s_pos=10, c_s_max_pos=48390, k_ct_pos=2e-11,
    sigma_l=1, tplus=0.26, f_a=0.2,
    vmax = 4.2, vmin = 3.0)
    F = 96485
    R = 8.3145
    T = 293.15

    h_neg = L_neg / n_mesh_neg
    h_sep = L_sep / n_mesh_sep
    h_pos = L_pos / n_mesh_pos

    Sa_neg = 3 * eps_s_neg / r_s_neg # spacific surface area m^2/m^3^, assume sphere shape particle
    Sa_pos = 3 * eps_s_pos / r_s_pos # spacific surface area m^2/m^3^, assume sphere shape particle

    data_neg = readdlm(filename_neg)
    data_pos = readdlm(filename_pos)

    # 创建插值函数
    ocv_neg = LinearInterpolation(data_neg[:, 1], data_neg[:, 2])
    ocv_pos = LinearInterpolation(data_pos[:, 1], data_pos[:, 2])


    sigma_l_eff_pos = eps_l_pos^Bruggeman_pos * sigma_l # effective pos conductivity S/m
    sigma_l_eff_neg = eps_l_neg^Bruggeman_neg * sigma_l # effective neg conductivity S/m
    sigma_l_eff_sep = eps_l_sep^Bruggeman_sep * sigma_l # effective sep conductivity S/m
    sigma_s_eff_pos = eps_s_pos^Bruggeman_pos * sigma_s_pos # effective pos conductivity S/m
    sigma_s_eff_neg = eps_s_neg^Bruggeman_neg * sigma_s_neg # effective neg conductivity S/m

    R_s_neg = h_neg / sigma_s_eff_neg
    R_s_pos = h_pos / sigma_s_eff_pos
    R_l_neg = h_neg / sigma_l_eff_neg
    R_l_pos = h_pos / sigma_l_eff_pos
    R_l_sep = h_sep / sigma_l_eff_sep

    #电子输运方程
    stas1 = @variables i_s_neg(t)[1:n_mesh_neg] = 0 i_s_pos(t)[1:n_mesh_pos] = 0 i_l_neg(t)[1:n_mesh_neg] = 0 i_l_pos(t)[1:n_mesh_pos] = 0 i_l_sep(t)[1:n_mesh_sep] = 0
    stas2 = @variables phi_s_neg(t)[1:n_mesh_neg+1] = 0 phi_s_pos(t)[1:n_mesh_pos+1] = 0 phi_l_neg(t)[1:n_mesh_neg+1] = 0 phi_l_pos(t)[1:n_mesh_pos+1] = 0 phi_l_sep(t)[1:n_mesh_sep-1] = 0
    stas3 = @variables U_ct_neg(t)[1:n_mesh_neg+1] = 0 [irreducible = true] U_ct_pos(t)[1:n_mesh_pos+1] = 0 [irreducible = true]
    stas4 = @variables i_ct_neg(t)[1:n_mesh_neg+1] = 0 i_ct_pos(t)[1:n_mesh_pos+1] = 0
    #浓度场
    pars1 = @parameters c_s_neg_para[1:n_mesh_neg+1] = soc_init_neg * c_s_max_neg c_s_pos_para[1:n_mesh_pos+1] = soc_init_pos * c_s_max_pos
    pars2 = @parameters c_l_neg_para[1:n_mesh_neg+1] = 1000 c_l_pos_para[1:n_mesh_pos+1] = 1000 c_l_sep_para[1:n_mesh_sep-1] = 1000
    pars3 = @parameters U_neg_para[1:n_mesh_neg+1] = calculate_ocv_neg(soc_init_neg, ocv_neg) U_pos_para[1:n_mesh_pos+1] = calculate_ocv_pos(soc_init_pos, ocv_pos)
    @named oneport = OnePort_key()
    @unpack v, i = oneport

    eqs = [
        #电子输运方程
        #基尔霍夫电流平衡
        (phi_s_neg[1]) ~ 0
        [0 ~ -i_s_neg[i-1] + i_s_neg[i] + i_ct_neg[i] for i in 2:n_mesh_neg]...
        0 ~ i + i_s_neg[1] + i_ct_neg[1] #组件化
        0 ~ -v + phi_s_pos[end] - phi_s_neg[1] #组件化
        0 ~ -i_s_neg[end] + i_ct_neg[end]
        [0 ~ -i_s_pos[i] + i_s_pos[i-1] - i_ct_pos[i] for i in 2:n_mesh_pos]...
        0 ~ -i_s_pos[1] - i_ct_pos[1]
        # 0 ~ i + i_s_pos[end] - i_ct_pos_para[end]
        [0 ~ -i_l_neg[i] + i_l_neg[i-1] + i_ct_neg[i] for i in 2:n_mesh_neg]...
        0 ~ -i_l_neg[1] + i_ct_neg[1]
        0 ~ -i_l_sep[1] + i_l_neg[end] + i_ct_neg[end]
        [0 ~ -i_l_pos[i] + i_l_pos[i-1] + i_ct_pos[i] for i in 2:n_mesh_pos]...
        0 ~ -i_l_sep[end] + i_l_pos[1] - i_ct_pos[1]
        0 ~ -i_l_pos[end] - i_ct_pos[end]
        [0 ~ -i_l_sep[i] + i_l_sep[i+1] for i in 1:n_mesh_sep-1]...
        #求i_s
        [0 ~ -i_s_neg[i] + (phi_s_neg[i] - phi_s_neg[i+1]) / R_s_neg for i in 1:n_mesh_neg]...
        [0 ~ -i_s_pos[i] + (phi_s_pos[i] - phi_s_pos[i+1]) / R_s_pos for i in 1:n_mesh_pos]...
        #求i_l
        [0 ~ -i_l_neg[i] + (phi_l_neg[i] - phi_l_neg[i+1]) / R_l_neg + 2 * sigma_l_eff_neg * R * T / F * (1 + f_a) * (1 - tplus) * (log(c_l_neg_para[i+1]) - log(c_l_neg_para[i])) / h_neg for i in 1:n_mesh_neg]...
        [0 ~ -i_l_pos[i] + (phi_l_pos[i] - phi_l_pos[i+1]) / R_l_pos + 2 * sigma_l_eff_pos * R * T / F * (1 + f_a) * (1 - tplus) * (log(c_l_pos_para[i+1]) - log(c_l_pos_para[i])) / h_pos for i in 1:n_mesh_pos]...
        [0 ~ -i_l_sep[i] + (phi_l_sep[i] - phi_l_sep[i+1]) / R_l_sep + 2 * sigma_l_eff_sep * R * T / F * (1 + f_a) * (1 - tplus) * (log(c_l_sep_para[i+1]) - log(c_l_sep_para[i])) / h_sep for i in 1:n_mesh_sep-2]...
        0 ~ -i_l_sep[1] + (phi_l_neg[end] - phi_l_sep[1]) / R_l_sep + 2 * sigma_l_eff_sep * R * T / F * (1 + f_a) * (1 - tplus) * (log(c_l_sep_para[1]) - log(c_l_neg_para[end])) / h_sep
        0 ~ -i_l_sep[end] + (phi_l_sep[end] - phi_l_pos[1]) / R_l_sep + 2 * sigma_l_eff_sep * R * T / F * (1 + f_a) * (1 - tplus) * (log(c_l_pos_para[1]) - log(c_l_sep_para[end])) / h_sep
        #求i_ct和U_ct和U
        [0 ~ -U_ct_neg[i] + phi_s_neg[i] - phi_l_neg[i] - U_neg_para[i] for i in 1:n_mesh_neg+1]...
        [0 ~ -U_ct_pos[i] + phi_s_pos[i] - phi_l_pos[i] - U_pos_para[i] for i in 1:n_mesh_pos+1]...
        [0 ~ -i_ct_neg[i] + Sa_neg * h_neg * (F * k_ct_neg * (c_s_max_neg - c_s_neg_para[i])^0.5 * c_s_neg_para[i]^0.5 * c_l_neg_para[i]^0.5) * (exp(0.5*F*U_ct_neg[i]/R/T)-exp(-0.5*F*U_ct_neg[i]/R/T)) for i in 2:n_mesh_neg]...
        [0 ~ -i_ct_pos[i] + Sa_pos * h_pos * (F * k_ct_pos * (c_s_max_pos - c_s_pos_para[i])^0.5 * c_s_pos_para[i]^0.5 * c_l_pos_para[i]^0.5) * (exp(0.5*F*U_ct_pos[i]/R/T)-exp(-0.5*F*U_ct_pos[i]/R/T)) for i in 2:n_mesh_pos]...
        0 ~ -i_ct_neg[1] + 0.5 * Sa_neg * h_neg * (F * k_ct_neg * (c_s_max_neg - c_s_neg_para[1])^0.5 * c_s_neg_para[1]^0.5 * c_l_neg_para[1]^0.5) * (exp(0.5*F*U_ct_neg[1]/R/T)-exp(-0.5*F*U_ct_neg[1]/R/T))
        0 ~ -i_ct_pos[1] + 0.5 * Sa_pos * h_pos * (F * k_ct_pos * (c_s_max_pos - c_s_pos_para[1])^0.5 * c_s_pos_para[1]^0.5 * c_l_pos_para[1]^0.5) * (exp(0.5*F*U_ct_pos[1]/R/T)-exp(-0.5*F*U_ct_pos[1]/R/T))
        0 ~ -i_ct_neg[end] + 0.5 * Sa_neg * h_neg * (F * k_ct_neg * (c_s_max_neg - c_s_neg_para[end])^0.5 * c_s_neg_para[end]^0.5 * c_l_neg_para[end]^0.5) * (exp(0.5*F*U_ct_neg[end]/R/T)-exp(-0.5*F*U_ct_neg[end]/R/T))
        0 ~ -i_ct_pos[end] + 0.5 * Sa_pos * h_pos * (F * k_ct_pos * (c_s_max_pos - c_s_pos_para[end])^0.5 * c_s_pos_para[end]^0.5 * c_l_pos_para[end]^0.5) * (exp(0.5*F*U_ct_pos[end]/R/T)-exp(-0.5*F*U_ct_pos[end]/R/T))
    ]

    stas = zhankai([stas1..., stas2..., stas3..., stas4...])
    pars = zhankai([pars1..., pars2...,pars3...])
    extend(ODESystem(eqs, t, stas, pars; name=name), oneport)
end
function get_variables_index(batters,sys)
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