include("pacman.jl")

using Genie
using Genie.Renderer.Json
using Genie.Requests
using HTTP

model = initialize_model()

Genie.config.run_as_server = true
Genie.config.cors_headers["Access-Control-Allow-Origin"] = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]


route("/run") do
    run!(model, 1)
    agents_json = [
        Dict(
            :id => a.id,
            :type => a.type,
            :x => a.pos[1],
            :y => a.pos[2]
        ) for a in allagents(model)
    ]
    json(Dict(:agents => agents_json))
end


route("/meta") do
    json(Dict(
        :dims => Dict(:width => size(M, 2), :height => size(M, 1)),
        :matrix => [[M[y, x] for x in 1:size(M, 2)] for y in 1:size(M, 1)]
    ))
end

up() 
