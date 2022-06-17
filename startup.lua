-- Load _G libs
for _, sFile in ipairs(fs.list("/lib_G")) do
    if string.sub(sFile, 1, 1) ~= "." then
        local sPath = "/lib_G/" .. sFile
        if not fs.isDir(sPath) then
            dofile(sPath)
        end
    end
end

term.clear()
term.setCursorPos(1, 1)

term.setTextColor(colours.green)
term.write("Lib OS 1.0b ")

term.setTextColor(colours.lightGrey)
term.write("(")

term.setTextColor(colours.orange)
term.write(os.version())

term.setTextColor(colours.lightGrey)
term.write(")")

print()
