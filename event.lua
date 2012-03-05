local wmiir = require("wmiir")
local export = require("export")

local handlers = {
    -- called for every event
    catchall = function (t) true end,
    -- called for every iteration of the event loop AFTER event processing
    nilevent = function () true end,
    -- if non-nil, called ONCE at the beginning of the next iteration of the loop and then CLEARED
    -- interrupt() will get loop()'s pipe as an argument
    interrupt = function (p) true end,
    -- called if there is no handler for a event e
    drop = function (e, t) true end,
    -- called if no events are available, before loop() returns
    -- If set, loop() will return cleanup().
    cleanup = function() true end
    -- every wmii event gets an entry here ↓, of the form
    -- event-name = function(...) <chunk> end
    -- Arguments will be passed via unpack()
}

local function parseline(line)
    local space = {}
    local e
    local args = {}
    local l, r = 0, string.len(line)
    local x, y
--[[
    while l ~= r do
        x = string.find(line, "[%s]", l)
        if not x then break end
        table.insert(space, x)
        if x < r then l = x + 1 end
    end
--]]
    repeat
        x = string.find(line, "[%s]", l)
        if not x then break end
        table.insert(space, x)
        l = x + 1
    until l > r 
    while #space > 1 do
        x, y = table.remove(space, 1), table.remove(space, 1)
        table.insert(args, string.sub(line, x, y))
    end
    e = table.remove(args, 1)
    return e, args
end

local function loop()
    local line, pipe, e, args
    while true do
        if handlers.interrupt then
            handlers.interrupt()
            handlers.interrupt = nil
        end
        line, pipe = wmii.read("/event", true)
        if not line then
            if handlers.cleanup then
                return handlers.cleanup()
            else
                return nil
            end
        end
        e, args = parseline(line)
        if handlers[e] then
            handlers[e](unpack(args))
        else


        if handlers.nilevent then
            handlers.nilevent()
        end
    end
end
