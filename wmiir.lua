--[[
    wmiir abstraction layer
    Written by Jens Oliver John <jens.o.john.at.gmail.com>
    
    TODO: Currently, this is a wrapper around the wmiir command, and should be
    replaced by a real binding do libixp.

    Credits:
    * setfenv backport implementation written by sergroj.at.mail.ru
--]]

-- For compatibility with Lua >= 5.2
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

-- Creates the element at path
-- @return success: path
-- @return failure: nil
local function create(path)
    ls(path)
end

-- Lists path if it is a directory.
-- @return success: array of entries
-- @return failure: nil
local function ls(path)
    print("Called from create(path)!!!")
end

-- Reads the file at path.
-- @return string or nil of EOF
-- If handle is not nil at the first call, open the file in *l mode, read the
-- first line and return it along a handle. If subsequent calls pass a handle,
-- the next line will be read until EOF is reached. Then, the handle will be
-- closed and nil be returned.
local function read(path, handle)
end

-- Remove path from the file system.
-- @return success: path
-- @return failure: nil
local function remove(path)
end

-- Write data to file at path.
-- @return success: path
-- @return nil
local function write(path, data)
end

return export{
    create = create,
    ls = ls,
    read = read,
    remove = remove,
    write = write
}
