# Pacman ABM — Julia + React

## Ejecutar backend (Julia)
```bash
julia
julia> import Pkg; Pkg.add(["Agents", "Genie"])
julia> include("pacman.jl")
julia> include("webapi.jl")   # levanta http://localhost:8000

Ejecutar frontend (Vite)

cd frontend
npm install
npm run dev
# abre el puerto que muestre (p.ej. http://localhost:5173)