using JuMP, Ipopt

##### 生成真实数据 ####
x = collect(-1:0.01:1)
N = length(x)
# 产生随机误差，范围在-0.1~0.1之间
rands = rand(-0.1:0.01:0.1, N)
a1 = 1.5
a2 = 0.8
# 计算y值
y = @. a1 * x^2 + sin(a2 * x) + rands

model = Model(Ipopt.Optimizer)
@variable(model, para[1:2])
@NLexpression(model, Loss,
    sum((para[1] * x[i]^2 + sin(para[2] * x[i]) - y[i])^2 for i in 1:N))
@NLobjective(model, Min, Loss)
for i in 1:2
    set_start_value(para[i], 0.3)
end

JuMP.optimize!(model)
JuMP.value.(para)