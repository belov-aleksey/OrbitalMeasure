using CSV, DataFrames

data = CSV.read("data.csv", DataFrame)
data_names = data |> names |> x -> Symbol.(x)
