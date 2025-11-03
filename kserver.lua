--Very early test build!

local kserver = {}

function kserver.open()
    peripheral.find("modem", rednet.open)
end

kserver.servFunc = {}
kserver.servFunc.__index = kserver.servFunc
function kserver.servFunc.new()
    local self = setmetatable({
        type = "servFunc",
        func = function() return "ping!" end, -- Payload function
    },kserver.servFunc)
    return self
end

function kserver.servFunc:invoke(user, args)
    args = args or {}
    local ok, result = pcall(self.func, unpack(args))
    if not ok then return nil end
    return result
end

kserver.server = {}
kserver.server.__index = kserver.server
function kserver.server.new()
    local self = setmetatable({
        type = "server",
        debug = false,
        timeout = 5,
        funcList = {},
        protocol = "kserver",
    }, kserver.server)
    return self
end

function kserver.server:run(protocol)
    if self.debug then print("Debug mode enabled!") end
    protocol = protocol or self.protocol
    while true do
        local id, msg = rednet.receive(protocol)
        if self.debug then print("Debug: "..id.." - "..msg) end
    
        --Handle server functions

        if self.funcList[msg] then
            if self.debug then print("Debug: Func detected") end
            local func = self.funcList[msg]:invoke()
            print(id.." ran"..self.funcList[msg].name)
            rednet.send(id, func, proto)
        end
    end
end

--Client side

kserver.client = {}
kserver.client.__index = kserver.client
function kserver.client.new()
    local self = setmetatable({
        type = "client",
        name = "Client",
    }, kserver.client)
    return self
end

function kserver.client:request(id, msg, proto)
    rednet.send(id, msg, proto)
    local rid, rmsg = rednet.receive(1)
    if not rid then return false end
    return rmsg
end


return kserver