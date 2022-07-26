-- mbs.stack_trace
-- by SquidDev
-- MIT License
-- GitHub: https://github.com/SquidDev-CC/mbs/blob/c0dd46832610ec78b817184056e1b80b5c5da964/lib/stack_trace.lua
-- Last updated: Jul 4 2021

-- Changelog:
-- [Date]        [Author]         [Change]
-- (July 24 2022) (Commandcracker) (success if error code is 0 and include xpcall_with in os.run)

local debug_traceback = type(debug) == "table" and type(debug.traceback) == "function" and debug.traceback

--- Run a function with a traceback.
local function xpcall_with(fn)
    -- So this is rather grim: we need to get the full traceback and current one and remove
    -- the common prefix
    local co = coroutine.create(fn)
    local args, result = { n = 0 }
    while true do
        result = table.pack(coroutine.resume(co, table.unpack(args, 1, args.n)))

        if #result == 1 then return true end -- success if no error
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

-- TODO: bios.strict_globals
-- https://github.com/cc-tweaked/CC-Tweaked/blob/5d65b3e6547c6879be0217434482c5f9f235b069/src/main/resources/data/computercraft/lua/bios.lua#L487-L518

local expect = dofile("rom/modules/main/cc/expect.lua").expect

function os.run(env, path, ...)
    expect(1, env, "table")
    expect(2, path, "string")

    setmetatable(env, { __index = _G })
    local func, err = loadfile(path, nil, env)
    if not func then
        printError(err)
        return false
    end

    local ok, err
    if settings.get("mbs.shell.traceback") then
        local arg = table.pack(...)
        ok, err = xpcall_with(function() return func(table.unpack(arg, 1, arg.n)) end)
    else
        ok, err = pcall(func, ...)
    end

    if not ok and err and err ~= "" then printError(err) end
    return ok
end
