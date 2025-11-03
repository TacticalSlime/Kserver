local kserver = dofile("lib/kserver.lua")

local id = tonumber(read())

local client = kserver.client.new()
print(client:request("testFunc","kserver"))