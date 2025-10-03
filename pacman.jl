using Agents
using Random

const GRID_DIMS = (5, 5)
const START_POS = (3, 3)
const DIRECTIONS = ((1, 0), (-1, 0), (0, 1), (0, -1))

@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end

function agent_step!(agent, model)
    new_pos = choose_next_position(agent.pos, model)
    isnothing(new_pos) && return
    move_agent!(agent, new_pos, model)
end

function choose_next_position(position, model)
    dims = GRID_DIMS
    candidates = Tuple{Int, Int}[]
    for (dx, dy) in DIRECTIONS
        trial = (position[1] + dx, position[2] + dy)
        if is_valid_position(trial, dims)
            push!(candidates, trial)
        end
    end
    isempty(candidates) && return nothing
    return rand(model.rng, candidates)
end

@inline function is_valid_position(pos::Tuple{Int, Int}, dims::Tuple{Int, Int})
    return 1 <= pos[1] <= dims[1] && 1 <= pos[2] <= dims[2]
end

function initialize_model()
    space = GridSpace(GRID_DIMS; periodic = false, metric = :manhattan)
    model = StandardABM(Ghost, space; agent_step!)
    add_agent!(Ghost, pos = START_POS, model)
    return model
end

function agent_state(agent)
    return Dict(
        :id => agent.id,
        :type => agent.type,
        :pos => collect(agent.pos),
    )
end

function model_state(model)
    return Dict(
        :agents => [agent_state(agent) for agent in allagents(model)],
    )
end

model = initialize_model()
