local kserver = dofile("lib/kserver.lua")

print(os.getComputerID)

local testFunc = server.servFunc.new()
testFunc.name = "testFunc"
testFunc.func = function() return "Hewwo!" end

local server = kserver.server.new()
server.funcList = funcs
server:run("kserver")