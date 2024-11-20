include("get_data.jl")

using Statistics
using Plots


variance_values = Pair[]
for i in 4:length(data_names)
    for j in 4:length(data_names)
        diff_name = "$(data_names[i]) - $(data_names[j])"
        variance = Statistics.var(data[:,i] - data[:,j])
        push!(variance_values, diff_name => variance)
        diff_name = "$(data_names[i]) + $(data_names[j])"
        variance = Statistics.var(data[:,i] + data[:,j])
        push!(variance_values, diff_name => variance)
    end
end

variance_values |> 
    x -> sort(x, by=x->x.second) |> 
    x -> println.(x)

#= 
output:

"Bx1 - By2" => 10.890188010161163
"By2 - Bx1" => 10.890188010161163
"By1 - Bx2" => 46.1238272126024
"Bx2 - By1" => 46.1238272126024
"Bz1 + Bz2" => 48.52880329168716
"Bz2 + Bz1" => 48.52880329168716
"Bx1 - By1" => 206.48142246272099
"By1 - Bx1" => 206.48142246272099
"By1 - By2" => 212.49676881693858
...

Bx1, By2 - Co-directional
Bz1, Bz2 - Opposite directional
=#

#=
task 2


xt1 = (data.Bx1+data.By2)/2
xt2 = (data.By1+data.Bx2)/2
xt3 = (data.Bz1-data.Bz2)/2

tau1 = 2 * (abs.(0.05*max(data.Bx1, data.By2)) .+ 3)
tau2 = 2 * (abs.(0.05*max(data.By1, data.Bx2)) .+ 3)
tau3 = 2 * (abs.(0.05*max(data.Bz1, data.Bz2)) .+ 3)

abs.(data.Bx1 - xt1) .> tau1
abs.(data.By2 - xt1) .> tau1

abs.(data.By1 - xt2) .> tau2
abs.(data.Bx2 - xt2) .> tau2

abs.(data.Bz1 - xt3) .> tau3
abs.(data.Bz2 + xt3) .> tau3
=#

# task 3
# Kotelnikov series

function kotelnikov_reconstruction_freq(x, n, t_span)
    function f(t)
        res = 0
        for n in 1:n
            res += x[2*n]*(-1)^(2*n)*sin(pi*t/12)/(t-12*n)/pi
        end
        res
    end
    f.(t_span)
end

function kotelnikov_reconstruction(x, n, t_span)
    function f(t)
        res = 0
        for n in 1:n
            res += x[n]*(-1)^n*sin(pi*t/6)/(t-6*n)/pi
        end
        res
    end
    f.(t_span)
end

# Run Kotelnikov-series calculating and plot data
t = [0.0 : 0.1 : 150...]
if !isdir("results")
    mkdir("results")
    cd("results")
end

for i in 4:length(data_names)
    plot(
        t, 
        kotelnikov_reconstruction(
            data[:, i], 32, t), 
            label="$(data_names[i])_32",
            color=:blue, 
            lw=2
    )
    plot!(
        t, 
        kotelnikov_reconstruction(
            data[:, i], 64, t), 
            label="$(data_names[i])_64",
            color=:red, 
            lw=2
    )
    plot!(
        t, 
        kotelnikov_reconstruction(
            data[:, i], 128, t), 
            label="$(data_names[i])_128",
            color=:green, 
            lw=2
    )
    xlabel!("t, sec")
    savefig("$(data_names[i])_$(data_names[i])_distance.png")

    plot(
        t, 
        kotelnikov_reconstruction(
            data[:, i], 32, t), 
            label="$(data_names[i])_32",
            color=:blue, 
            lw=2
    )
    plot!(
        t, 
        kotelnikov_reconstruction_freq(
            data[:, i], 32, t), 
            label="$(data_names[i])_32_freq",
            color=:green, 
            lw=2
    )   
    xlabel!("t, sec")
    savefig("$(data_names[i])_$(data_names[i])_freq_32.png") 
end
cd("..")