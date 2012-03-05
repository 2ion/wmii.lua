--[[
    wmiir abstraction layer
    Written by Jens Oliver John <jens.o.john.at.gmail.com>
    
    TODO: Currently, this is a wrapper around the wmiir command, and should be
    replaced by a real binding do libixp.
--]]

local export = require("export")

-- By default not set
local address = nil

local function popenbase(args)
    return "wmiir " .. (address and "-a " .. address or "") .. " "
end

local function spacelist(t)
    local s
    for k,v in ipairs(t) do
        s = s and s .. " " .. v or v
    end
    return s
end

-- Creates the element at path
local function create(path)
    local p = io.popen(spacelist{popenbase(), "create", path})
    p:close()
end

-- Lists path if it is a directory.
local function ls(path)
    local p = io.popen(spacelist{popenbase(), "ls", path})
    p:close()
end

-- Reads the file at path.
-- @return string or nil of EOF
-- If handle is not nil at the first call, open the file in *l mode, read the
-- first line and return it along a handle. If subsequent calls pass a handle,
-- the next line will be read until EOF is reached. Then, the handle will be
-- closed and nil be returned.
local function read(path, handle)
    local p = type(handle) == "userdata" and handle or io.popen(spacelist{popenbase(), "read", path})
    if handle then
        local line = p:read("*l")
        if line then
            return line, handle
        else
            p:close()
            return nil
        end
    else
        local file = p:read("*a")
        p:close()
        return file
    end
end

-- Remove path from the file system.
-- @return success: path
-- @return failure: nil
local function remove(path)
    local p = io.popen(spacelist{popenbase(), "remove", path})
    p:close()
end

-- Write data to file at path.
-- @return success: path
-- @return nil
local function write(path, data)
    local p = io.popen(spacelist{popenbase(), "write", path}, "w")
    p:write(data)
    p:close()
end

return export{
    -- functions
    create = create,
    ls = ls,
    read = read,
    remove = remove,
    write = write,
    popen = popen,
    spacelist = spacelist,
    popenbase = popenbase,
    -- variables
    address = address
}
