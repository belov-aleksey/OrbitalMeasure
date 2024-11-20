include("get_data.jl")

using Statistics 


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