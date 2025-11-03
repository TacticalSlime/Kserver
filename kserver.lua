--This is a very unfinished version, do not use!
--Basically bypass everything

local kserver = {}

function kserver.open()
    peripheral.find("modem", rednet.open)
end

--Server side

kserver.listClient = {}
kserver.listClient.__index = kserver.listClient
function kserver.listClient.new()
    local self = setmetatable({
        id = nil,
        name = "client",
        role = "user",
    },kserver.listClient)
    return self
end

kserver.servFunc = {}
kserver.servFunc.__index = kserver.servFunc
function kserver.servFunc.new()
    local self = setmetatable({
        name = "server function"
        whitelist = {"admin", "user"}, --Roles that can invoke this {"admin", "user"}
        func = function() return "ping!" end, -- Payload function
    },kserver.servFunc)
    return self
end

function kserver.servFunc:invoke(user, args)
    args = args or {}
    --[[
    for i, v in pairs(self.whitelist) do
        if v == user.role then
            return pcall(self.func(unpack(args)))
        end
    end
    --]]
    return pcall(self.func(unpack(args)))
end

kserver.server = {}
kserver.server.__index = kserver.server
function kserver.server.new()
    local self = setmetatable({
        enableClients = true,
        timeout = 5,
        clients = {},
        funcList = {},
        protocol = "kserver",
        whitelist = {}, -- {"id" = "role"} will override roles to specific id's
    }, kserver.server)
    return self
end


--[[
function kserver.server:startTimeoutCheck(timeout)
    while true do
        local timer = os.startTimer(timeout)
        local event, id = os.pullEvent("timer")
        if event == "timer" then

            --Check clients for heartbeat
            for i,v in pairs(self.clients) do
                rednet.send(v.id, "check", self.protocol)

                --Check if they send back
                local id, msg = rednet.receive(self.protocol)
                if msg == "ack" then
                    --They are alive! and uh put stuff in here just in case
                else
                    --They are dead!
                    self.clients.remove(i)
                    print(v.id "was kill")
                end
            end
        end
    end
end

function kserver.server:clientConnect(id) --handle client connecting and whitelist overrides
    local client == kserver.listClient.new()
    client.id = id
    if self.whitelist[id] then
        client.role = self.whitelist[id]
    end
    self.clients.insert(client)
    return true
end

function kserver.server:clientDisconnect(id)
    if self.clients[id] then self.clients[id].remove() else return false end
    return true
end
--]]

function kserver.server:run(protocol)
    protocol = protocol or self.protocol
    ---parallel.waitForAny(function() self:startTimeoutCheck(self.timeout) end, function()
    --Ignore all timeout functionality for now
    while true do
        local id, msg = rednet.receive(protocol)
        --Handle main commands
        --[[
        if msg == "ks-connect" then
            self.clientConnect(id)
        end
        if msg == "ks-disconnect" then
            self.clientDisconnect(id)
        end

        if msg == "ks-getstate" then
            rednet.send(id, {self}, protocol)
        end
        ]]--
        --Handle server functions
        if msg == self.funcList[msg] then
            local func = self.funcList[msg].invoke()
            if func then
                print(id.." ran"..self.funcList[msg].name)
                rednet.send(id, func, proto)
            end
        end

        rednet.send(id, "ack", protocol)
    end
end

--Client side

kserver.client = {}
kserver.client.__index = kserver.client
function kserver.client.new()
    local self = setmetatable({
        name = "Client",
        role = "user",
        rolePass = nil,
        serverState = nil,
    }, kserver.client)
    return self
end

kserver.client:request(id, msg, proto)
    rednet.send(id, msg, proto)
    local rid, rmsg = rednet.receive(1)
    if not rid then return false end
    return rmsg
end


return kserver