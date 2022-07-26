_G.processes = {}

local old_coroutine = {}
old_coroutine.create = coroutine.create

function coroutine.create(f)
    local process = {}

    local function f_override(...)
        process.status = coroutine.status(coroutine.running())
        process.name = math.random(1, 100)
        f(...)
    end

    local thread = old_coroutine.create(f_override)
    process.thread = thread
    table.insert(processes, process)

    return thread
end
