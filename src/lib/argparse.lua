-- Argparse
-- By Commandcracker
-- based on
--      [metis.argparse](https://github.com/SquidDev-CC/metis/blob/874c65de209df5c9489a47b9dc4cd11795b65dd1/src/metis/argparse.lua)
--      from [SquidDev-CC](https://github.com/SquidDev-CC)
--      Last updated: Mar 26 2022
-- Unlicense
-- Last updated: July 26 2022

--- A really basic argument parser.
--
-- @module metis.argparse

local expect = require "cc.expect".expect

local function errorf(msg, ...)
    error(msg:format(...), 0)
end

local function setter(argument, result, value)
    result[argument.name] = value or true
end

--- A collection of arguments, and a parser for them.
--
-- @type ArgumentParser
local ArgumentParser = {}

--[[- Add a new argument which is accepted by this parser.

@tparam string|{ string... } names The names of this argument. These may be
prefixed with "--" or "-" (i.e. "--foo") to mark this as an option, or left
raw to be considered a positional argument.
@tparam {
  action? = function(table, table, string),
  name? = string,
  required? = boolean,
  mvar? = string,
  doc? = string,
} options Additional options for this argument.
]]
function ArgumentParser:add_argument(names, options)
    expect(1, names, "string", "table")
    expect(2, options, "table", "nil")

    if type(names) == "string" then names = { names } end
    if not options then options = {} end

    options.names = names
    for i = 1, #names do
        local name = names[i]
        if name:sub(1, 2) == "--" then self.options[name:sub(3)] = options
        elseif name:sub(1, 1) == "-" then self.flags[name:sub(2)] = options
        else self.arguments[#self.arguments + 1] = options
            options.argument = true
        end
    end

    table.insert(self.list, #self.list, options)

    -- Default to the setter action
    if options.action == nil then options.action = setter end
    -- Require if we're an argument, otherwise continue as normal
    if options.required == nil then options.required = names[1]:sub(1, 1) ~= "-" end
    if options.name == nil then options.name = names[1]:gsub("^-+", "") end
    if options.mvar == nil then options.mvar = options.name:upper() end
end

--- Parse a series of arguments according to the previously given options.
--
-- @tparam string ... The arguments to parse, as given to the program.
-- @treturn table The result of argument parsing.
-- @throws If invalid arguments were given.
function ArgumentParser:parse_args(...)
    local args = table.pack(...)
    for i = 1, args.n do expect(i, args[i], "string") end

    local i, n = 1, args.n
    local arg_idx = 1

    local result = {}
    while i <= n do
        local arg = args[i]
        i = i + 1

        if arg:find("^%-%-([^=]+)=(.+)$") then
            local name, value = arg:match("^%-%-([^=]+)=(.+)$")
            local arg = self.options[name]

            -- Some sanity checking for arguments
            if not arg then errorf("Unknown argument %q", name) end
            if not arg.many and result[arg.name] ~= nil then errorf("%s has already been set", name) end
            if not arg.value then errorf("%s does not accept a value", name) end

            -- Run the setter
            arg:action(result, value)
        elseif arg:find("^%-%-(.*)$") then
            local name = arg:match("^%-%-(.*)$")
            local arg = self.options[name]

            -- Some sanity checking for arguments
            if not arg then errorf("Unknown argument %q", name) end
            if not arg.many and result[arg.name] ~= nil then errorf("%s has already been set", name) end

            -- Consume the value and run the setter
            if arg.value then
                local value = args[i]
                i = i + 1
                if not value then errorf("%s needs a value", name) end
                arg:action(result, value)
            else
                arg:action(result)
            end
        elseif arg:find("^%-(.+)$") then
            local flags = arg:match("^%-(.+)$")
            for j = 1, #flags do
                local name = flags:sub(j, j)
                local arg = self.flags[name]

                -- Some sanity checking
                if not arg then errorf("Unknown argument %q", name) end
                if not arg.many and result[arg.name] ~= nil then errorf("%s has already been set", name) end

                -- Consume the value and run the setter
                if arg.value then
                    local value
                    if j == #flags then
                        value = args[i]
                        i = i + 1
                    else
                        value = flags:sub(j + 1)
                    end

                    if not value then errorf("%s expects a value", name) end
                    arg:action(result, value)
                    break
                else
                    arg:action(result)
                end
            end
        else
            local argument = self.arguments[arg_idx]
            if argument then
                argument:action(result, arg)
                arg_idx = arg_idx + 1
            else
                errorf("Unexpected argument %q", arg)
            end
        end
    end

    for i = 1, #self.list do
        local arg = self.list[i]
        if arg and arg.required and result[arg.name] == nil then
            errorf("%s is required (use -h to see usage)", arg.name)
        end
    end

    return result
end

local function get_name(options)
    local name
    if options.argument then name = options.mvar
    elseif options.value then name = options.names[1] .. "=" .. options.mvar
    else name = options.names[1]
    end

    return name
end

local function get_usage(options)
    local name = get_name(options)

    if #options.names > 1 then name = name .. " (" .. table.concat(options.names, ", ", 2) .. ")" end
    return name
end

local arg_mt = { __name = "ArgumentParser", __index = ArgumentParser }

--- Create a new argument parser.
--
-- @treturn ArgumentParser The constructed parser.
function ArgumentParser.new(prefix)
    expect(1, prefix, "string", "nil")

    local parser = setmetatable({
        options = {},
        flags = {},
        arguments = {},

        list = {},
    }, arg_mt)

    parser:add_argument({ "--help", "-h", "-?" }, {
        value = false, required = false,
        help = "Show this help message",
        action = function()
            if prefix then
                term.setTextColor(colors.magenta)
                print("Usage: " .. prefix .. " [OPTIONS]")
                print()
            end

            term.setTextColor(colors.orange)
            print("Options:")

            local max = 0
            --for i = 1, #parser.list do max = math.max(max, #get_usage(parser.list[i])) end
            --local format = "  %-" .. max .. "s"

            for i = 1, #parser.list do
                local arg = parser.list[i]

                term.setTextColor(colors.white)
                term.write(get_name(arg))

                if #arg.names > 1 then
                    term.setTextColor(colors.brown)
                    term.write(" (" .. table.concat(arg.names, ", ", 2) .. ")")
                end

                term.setTextColor(colors.lightGray)
                print("", arg.help or "")
            end

            error("", 0)
        end,
    })

    return parser
end

return {
    ArgumentParser = ArgumentParser
}
