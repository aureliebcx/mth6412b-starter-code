include(joinpath(@__DIR__, "plot_picture.jl"))
using Test

plot_picture("blue-hour-paris", true, 100, 50)
