local cprint = {}

local function tableConcatForamt(...)
    local fstring = ""
    for i = 0, #{ ... }, 1 do
        if i == 1 then
            fstring = "%s"
        else
            fstring = fstring .. " " .. "%s"
        end
    end
    return string.format(fstring, ...)
end

local function tocode(char)
    return 2 ^ (tonumber(char, 16) or 0)
end

function cprint.write(...)
    local msg                   = tableConcatForamt(...)
    local old_text_colour       = term.getTextColor()
    local old_background_colour = term.getBackgroundColor()

    local i = 0
    while i < #msg + 1 do
        local char = msg:sub(i, i)

        if char == '$' then
            local code = msg:sub(i + 1, i + 1)
            if code == 'r' then
                term.setTextColor(old_text_colour)
            else
                term.setTextColor(tocode(code))
            end
            i = i + 2
        elseif char == '&' then
            local code = msg:sub(i + 1, i + 1)
            if code == 'r' then
                term.setBackgroundColor(old_background_colour)
            else
                term.setBackgroundColor(tocode(code))
            end
            i = i + 2
        else
            write(char)
            i = i + 1
        end
    end
    term.setTextColor(old_text_colour)
    term.setBackgroundColor(old_background_colour)
end

function cprint.print(...)
    cprint.write(...)
    write('\n')
end

return cprint
