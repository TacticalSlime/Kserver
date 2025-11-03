local kserver = dofile("lib/kserver.lua")
kserver.open()

local id = tonumber(read())

local client = kserver.client.new()
print(client:request(id, "testFunc","kserver"))