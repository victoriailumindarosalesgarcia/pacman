using Agents
using Random


const M = [
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 1 0 1 0 0 0 1 1 1 0 1 0 1 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 0 1 0 1 0 0 0 0 0 1 1 1 0 1 0;
    0 1 1 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 0 1 0 1 1 1 0 1 0 1 0 1 0;
    0 1 0 1 1 1 0 0 1 0 0 1 0 1 1 1 0;
    0 1 0 0 0 1 1 1 1 1 1 1 0 0 0 1 0;
    0 1 1 1 0 1 0 0 0 0 0 1 0 1 1 1 0;
    0 1 0 1 0 1 0 1 1 1 0 0 0 1 0 1 0;
    0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

is_free(x::Int, y::Int) =
    1 ≤ y ≤ size(M, 1) && 1 ≤ x ≤ size(M, 2) && M[y, x] == 1

@agent Ghost GridAgent{2} begin
    type::String
end

function initialize_model()
    dims = (size(M, 2), size(M, 1))
    space = GridSpace(dims; periodic=false, metric=:manhattan)
    model = StandardABM(Ghost, space; agent_step!)

    start = (1, 1)
    if !is_free(start[1], start[2])
        found = false
        for y in 1:size(M, 1), x in 1:size(M, 2)
            if is_free(x, y)
                start = (x, y);
                found = true; break
            end
        end
        @assert found "No hay celdas libres en la matriz del laberinto."
    end

    add_agent!(Ghost, model; pos=start, type="Ghost")
    return model
end

function agent_step!(agent::Ghost, model)
    x, y = agent.pos
    candidates = ((x+1, y), (x-1, y), (x, y+1), (x, y-1))
    valid = Tuple{Int,Int}[]
    for (nx, ny) in candidates
        if is_free(nx, ny)
            push!(valid, (nx, ny))
        end
    end
   
    if !isempty(valid)
        move_agent!(agent, rand(valid), model)
    end
end