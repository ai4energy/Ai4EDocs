using Flux
using Flux: train!
using Plots

W1 = rand(10,2)
b1 = rand(10)
layer1(x) = W1 * x .+ b1

W2 = rand(10,10)
b2 = rand(10)
layer2(x) = W2 * x .+ b2

W3 = rand(1,10)
b3 = rand(1)
layer3(x) = W3 * x .+ b3

model(x) = layer3(tanh.(layer2(tanh.(layer1(x)))))[1]

xs = collect(0:0.1:1.0)
x_grid = [x for x = xs for y = xs]
a_grid = [y for x = xs for y = xs]
z_train = cos.(x_grid) .* sin.(a_grid)
xy = [[x,y] for x in xs for y in xs]
model.(z_train)

loss(x,y) = Flux.Losses.mse(model.(x),y)
parameters = [W1,b1,W2,b2,W3,b3]
data = [(xy,z_train)]
opt = Descent(0.1)

for i in 1:1000
    train!(loss, parameters, data, opt)
end
println(loss(xy,z_train))



xs = collect(0:0.1:2.0)
x_grid = [x for x = xs for y = xs]
a_grid = [y for x = xs for y = xs]
xy = [[x,y] for x in xs for y in xs]
z_predic = model.(xy)
plot(x_grid,a_grid,z_predic, st = :surface)
scatter!(x_grid,a_grid,cos.(x_grid) .* sin.(a_grid))


xs = collect(0:0.1:2.0)
x_grid = [x for x = xs for y = xs]
a_grid = [y for x = xs for y = xs]
xy = [[x,y] for x in xs for y in xs]
z_predic = model.(xy)
plot(x_grid,a_grid,z_predic, st = :surface)
xs = collect(0.05:0.1:1.0)
x_grid = [x for x = xs for y = xs]
a_grid = [y for x = xs for y = xs]
scatter!(x_grid,a_grid,cos.(x_grid) .* sin.(a_grid),color="yellow",legend=false)
xs = collect(0:0.1:1.0)
x_grid = [x for x = xs for y = xs]
a_grid = [y for x = xs for y = xs]
scatter!(x_grid,a_grid,cos.(x_grid) .* sin.(a_grid),color="red")
xs = collect(0:0.1:2.0)
x_grid = [x for x = xs for y = xs if x>=1.0||y>=1.0]
a_grid = [y for x = xs for y = xs if x>=1.0||y>=1.0]
scatter!(x_grid,a_grid,cos.(x_grid) .* sin.(a_grid),color="green")