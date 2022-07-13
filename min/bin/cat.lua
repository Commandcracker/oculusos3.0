local e={...}if#e==0 then print("Usage: cat <path>")return end local
t=shell.resolve(e[1])if fs.exists(t)and fs.isDir(t)then
printError("Cannot cat a directory.")return end if fs.exists(t)then local
a=fs.open(t,"rb")print(a.readAll())a.close()else
printError("File not found")return
end