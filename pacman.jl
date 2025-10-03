using Agents
using Random

# --- Agente ---
@agent struct Ghost(GridAgent{2})
    type::String = "Ghost"
end

# --- Laberinto (1=caminable, 0=muro) ---
const MAZE = [
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

const NROWS = size(MAZE, 1) # filas (y)
const NCOLS = size(MAZE, 2) # cols  (x)

in_bounds(x, y) = (1 <= x <= NCOLS) && (1 <= y <= NROWS)
is_free(x, y)   = in_bounds(x, y) && (MAZE[y, x] == 1)

function free_neighbors(pos::NTuple{2,Int})
    x, y = pos
    cand = ((x+1,y), (x-1,y), (x,y+1), (x,y-1)) # 4 vecinos (Manhattan)
    [p for p in cand if is_free(p[1], p[2])]
end

# Movimiento aleatorio RESTRINGIDO a celdas libres
function agent_step!(agent, model)
    opts = free_neighbors(agent.pos)
    if !isempty(opts)
        move_agent!(agent, rand(abmrng(model), opts), model) # (agent, pos, model)
    end
end

function initialize_model()
    space = GridSpace((NCOLS, NROWS); periodic = false, metric = :manhattan)
    model = StandardABM(Ghost, space; agent_step!)
    # coloca al fantasma en una celda libre (1, la (2,2) es libre)
    add_agent!((2, 2), model) # posición (x,y)
    return model
end
