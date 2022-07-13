-- mbs
-- by SquidDev
-- MIT License
-- Last updated: Jul 4 2021

local debug_traceback = type(debug) == "table" and type(debug.traceback) == "function" and debug.traceback

--- Run a function with a traceback.
local function xpcall_with(fn)
    -- So this is rather grim: we need to get the full traceback and current one and remove
    -- the common prefix
    local co = coroutine.create(fn)
    local args, result = { n = 0 }
    while true do
        result = table.pack(coroutine.resume(co, table.unpack(args, 1, args.n)))

        if not result[1] then break end
        if coroutine.status(co) == "dead" then return table.unpack(result, 1, result.n) end

        args = table.pack(coroutine.yield(result[2]))
    end

    if debug_traceback then
        return false, debug_traceback(co, result[2])
    else
        return false, result[2]
    end
end

-- by Commandcracker

function os.run(env, path, ...)
    --expect(1, env, "table")
    --expect(2, path, "string")

    setmetatable(env, { __index = _G })
    local func, err = loadfile(path, env)
    if not func then
        printError(err)
        return false
    end

    local ok, err
    if 1 then -- settings.get("mbs.shell.traceback")
        local arg = table.pack(...)
        ok, err = xpcall_with(function() return func(table.unpack(arg, 1, arg.n)) end)
    else
        ok, err = pcall(func, ...)
    end

    if not ok and err and err ~= "" then printError(err) end
    return ok
end
