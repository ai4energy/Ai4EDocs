using Flux
using Flux: train!
using Plots

W1 = rand(3,1)
b1 = rand(3)
layer1(x) = W1 * x .+ b1

W2 = rand(1,3)
b2 = rand(1)
layer2(x) = W2 * x .+ b2

model(x) = layer2(tanh.(layer1(x)))[1]

x_train = collect(-1.0:.1:2.0)
y_train = x_train.^2

model.(x_train)
loss(x,y) = Flux.Losses.mse(model.(x),y)
parameters = [W1,b1,W2,b2]
data = [(x_train,y_train)]
opt = Descent(0.1)
for i in 1:10000
    train!(loss, parameters, data, opt)
end
println(loss(x_train,y_train))
begin
    scatter(x_train,y_train,legend=false,title="tanh",color="red")
    plot!(x_train,model.(x_train),color="blue")

end

begin
    x_learned = collect(-1.0:0.07:2)
    scatter!(x_learned,x_learned.^2,legend=false,color="green")
    #plot!(x_learned,model.(x_learned),color="red")
end

begin
    x_pred = collect(2:.1:3)
    scatter!(x_pred, x_pred.^2,legend=false,color="green")
    plot!(x_pred,model.(x_pred),color="blue")
end

begin
    x_pred = collect(-2.0:.1:-1.0)
    scatter!(x_pred, x_pred.^2,legend=false,color="green")
    plot!(x_pred,model.(x_pred),color="blue")
end
