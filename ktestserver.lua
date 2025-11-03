local kserver = dofile("lib/kserver.lua")
kserver.open()

print(os.getComputerID())

local server = kserver.server.new()
server.debug = true
server.funcList.testFunc = kserver.servFunc.new()
server.funcList.testFunc.name = "testFunc"
server.funcList.testFunc.func = function() print("Weh!") return "weh!" end

for i,v in pairs(server.funcList.testFunc) do
    print(i..": "..tostring(v))
end

server:run("kserver")