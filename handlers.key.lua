-- wmii.lua
-- Key event handler

local wmiir = require("wmiir")
local export = require("export")

local modkey = "Mod4"

-- default keybindings
-- Keys and key sequences are divided into key groups, which can be
-- activated/deactivated by calling toggle_keygroup()
local keys = {

    "XF86" = {
        "XF86AudioLowerVolume"      = function() print() end,
        "XF86AudioRaiseVolume"      = function() print() end,
        "XF86AudioMute"             = function() print() end,
        "XF86Sleep"                 = function() print() end,
    },

}

local active_keygroups = {}

local function select_keygroup(group)
    if group then
        if keys[group] then
            return group
        else
            return nil
        end
    else
        return keys
    end
end

local function enable_keygroup(group)
    local t = select_keygroup(group)
    if not active_keygroups[t] then
         table.insert(active_keygroups, t)
         return t
    else
        return nil
end

local function disable_keygroup(group)
    local t = select_keygroup(group)
    if active_keygroups[t] then
        active_keygroups[t] = nil
    end
    return nil
end

local function Key(sequence)
end
