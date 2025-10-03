include("pacman.jl")

using Genie, Genie.Renderer.Json
using Agents

const model = initialize_model()

route("/run") do
    run!(model, 1)  # avanza un paso
    agents_json = [Dict(:id => a.id, :pos => a.pos) for a in allagents(model)]
    json(Dict(:agents => agents_json))
end

# CORS abierto para el frontend local
Genie.config.run_as_server = true
Genie.config.cors_headers["Access-Control-Allow-Origin"]  = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

up()
