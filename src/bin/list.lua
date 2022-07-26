local argparse = require("/lib/argparse")

local parser = argparse.ArgumentParser.new("ls")

parser:add_argument({ "--all", "-a" }, { help = "do not ignore entries starting with ." })
parser:add_argument({ "--human-readable", "-h" }, { help = "with -l and -s, print sizes like 1K 234M 2G etc." })
parser:add_argument({ "-l" }, { help = "use a long listing format" })
parser:add_argument({ "" }, { help = "folder to run ls on", name = "path", required = false })


local args = parser:parse_args(...) -- arg / ... (arg[0] = "command")

--print("DEBUG ARGS:" .. textutils.serialize(args))

-- Get all the files in the directory
local sDir = shell.dir()

if args.path then
    sDir = shell.resolve(args.path)
end

if not fs.isDir(sDir) then
    printError("Not a directory")
    return
end

-- Sort into dirs/files, and calculate column count
local tAll = fs.list(sDir)
local tFiles = {}
local tDirs = {}

local bShowHidden = settings.get("list.show_hidden") or args.all
for _, sItem in pairs(tAll) do
    if bShowHidden or string.sub(sItem, 1, 1) ~= "." then
        local sPath = fs.combine(sDir, sItem)
        if fs.isDir(sPath) then
            table.insert(tDirs, sItem)
        else
            table.insert(tFiles, sItem)
        end
    end
end
table.sort(tDirs)
table.sort(tFiles)

local function size(nSpace)
    if nSpace >= 1000 * 1000 then
        return (math.floor(nSpace / (100 * 1000)) / 10) .. "MB"
    elseif nSpace >= 1000 then
        return (math.floor(nSpace / 100) / 10) .. "KB"
    else
        return nSpace .. "B"
    end
end

local function long_listing_format()
    for _, sItem in pairs(tDirs) do
        term.write(fs.getSize(sItem))
        term.setTextColor(colors.blue)
        print("", sItem)
        term.setTextColor(colors.white)
    end

    for _, sItem in pairs(tFiles) do
        term.write(size(fs.getSize(sDir .. "/" .. sItem)))

        if sItem:sub(-4) == ".lua" then
            term.setTextColor(colors.green)
        else
            term.setTextColor(colors.white)
        end

        print("", sItem)
        term.setTextColor(colors.white)
    end
end

if args.l then
    long_listing_format()
else

    if term.isColour() then
        textutils.pagedTabulate(colors.blue, tDirs, colors.white, tFiles)
    else
        textutils.pagedTabulate(colors.lightGray, tDirs, colors.white, tFiles)
    end
end
