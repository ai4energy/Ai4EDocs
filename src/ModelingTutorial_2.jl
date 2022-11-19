using ModelingToolkit, DifferentialEquations

# 定义变量
@variables t
@variables V₁(t) V₂(t) V₃(t) I(t)

# 定义微分
D = Differential(t)
V\_3
# 设置参数
R = 1.0
C = 1.0
V = 1.0

# 输入方程
rc_eqs = [
    V₁ - V₃ ~ V
    V₁ - V₂ ~ I * R
    D(V₂) ~ I / C
    V₃ ~ 0
]

# 构建系统
@named rc_model = ODESystem(rc_eqs, t)

# 系统化简
sys = structural_simplify(rc_model)

equations(rc_model)

# 设置初值
u0 = [
    V₂ => 0.0
]
# 求解时间范围
tspan = (0.0, 10.0)

# 构建问题并求解
prob = ODAEProblem(sys, u0, tspan)
sol = solve(prob, Tsit5())

# 分别查看 V₁, V₂, V₃ 的变化
sol[V₂]
sol[V₁]
sol[V₃]
