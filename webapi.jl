include("pacman.jl")
using Genie, Genie.Renderer.Json, Genie.Requests, HTTP

route("/run") do
    run!(model, 1)
    state = model_state(model)
    state[:message] = "Adios"
    json(state)
end

Genie.config.run_as_server = true
Genie.config.cors_headers["Access-Control-Allow-Origin"] = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

up()
