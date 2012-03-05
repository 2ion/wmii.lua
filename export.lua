#!/usr/bin/env lua
--[[
    export.lua
--]]

local setfenv = setfenv or function(f, t)
    f = (type(f) == 'function' and f or debug.getinfo(f + 1, 'f').func)
    local name
    local up = 0
    repeat
        up = up + 1
        name = debug.getupvalue(f, up)
    until name == '_ENV' or name == nil
    if name then
        debug.upvaluejoin(f, up, function() return name end, 1)
        debug.setupvalue(f, up, t)
    end
end

local function tjoin(tl)
    local t = {}
    for k,v in ipairs(tl) do
        if type(v) == "table" then
            for i,r in pairs(v) do
                t[i] = r
            end
        end
    end
    return t
end

local function export(t)
    local t = t
    for k,v in pairs(t) do
        if type(v) == "function" then
            setfenv(t[k], tjoin{t,_G})
        end
    end
    return t
end

return export
