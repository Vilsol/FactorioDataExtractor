require 'lfs'
local json = require('cjson')

function string.ends(s, e)
    return e == '' or s:sub(-e:len()) == e
end

local old_require = require

function requireAll(path)
    local current = lfs.currentdir()
    lfs.chdir(path)
    for f in lfs.dir(".") do
        if f:ends(".lua") then
            require(f:sub(0, -5))
        end
    end
    lfs.chdir(current)
end

function require(modname)
    print("Requiring: " .. modname)
    return old_require(modname)
end

defines = {
    difficulty_settings = {
        recipe_difficulty = {
            normal = "normal",
            expensive = "expensive"
        },
        technology_difficulty = {
            normal = "normal",
            expensive = "expensive"
        }
    },
    direction = {
        north = 0,
        east = 2,
        south = 4,
        west = 6
    }
}

game = {
    tick = 0
}

local root = lfs.currentdir()

requireAll("factorio/data/core/lualib")

data.raw["gui-style"] = {
    default = {}
}

lfs.chdir("./factorio/data/core")
require("data")

lfs.chdir(root)
lfs.chdir("./factorio/data/base")
dofile("data.lua")
dofile("data-updates.lua")

lfs.chdir(root)

data.extend = nil

file = io.open("data.json", "w+")
io.output(file)
io.write(json.encode(data))
io.close(file)

local toKeep = {
    "ammo-turret",
    "loader",
    "offshore-pump",
    "logistic-container",
    "curved-rail",
    "rocket-silo-rocket",
    "container",
    "mining-drill",
    "wall",
    "generator",
    "boiler",
    "programmable-speaker",
    "rail-signal",
    "arithmetic-combinator",
    "train-stop",
    "land-mine",
    "splitter",
    "beacon",
    "accumulator",
    "inserter",
    "lamp",
    "power-switch",
    "assembling-machine",
    "straight-rail",
    "rail-chain-signal",
    "heat-pipe",
    "rocket-silo",
    "reactor",
    "fluid-turret",
    "solar-panel",
    "electric-turret",
    "electric-energy-interface",
    "constant-combinator",
    "decider-combinator",
    "furnace",
    "pipe-to-ground",
    "tile",
    "electric-pole",
    "pump",
    "lab",
    "gate",
    "roboport",
    "pipe",
    "rocket-silo-rocket-shadow",
    "radar",
    "underground-belt",
    "transport-belt"
}

local clean = {}

for _, d in pairs(toKeep) do
    clean[d] = data.raw[d]
end

function toRemove(key, val)
    if type(key) == "string" then
        if key:ends("_sound")
                or key:ends("_box")
                or key:ends("_trigger")
                or key:ends("_animation")
                or key:ends("_animations")
                or key:ends("_animation_shift")
                or key:ends("_light")
                or key:ends("_parameters")
                or key:ends("_health")
                or key:ends("_speed")
                or key:ends("_power")
                or key:ends("animation_speed_coefficient")
                or key:ends("animation_movement_cooldown")
                or key:ends("animation_left")
                or key:ends("animation_right")
                or key:ends("animation_up")
                or key:ends("animation_down")
                or key == "minable"
                or key == "resistances"
                or key == "corpse"
                or key == "icon"
                or key == "flags"
                or key == "energy_source"
                or key == "autoplace"
                or key == "map_color"
                or key == "speed"
                or key == "animation"
                or key == "animations"
                or key == "burner"
                or key == "heat_buffer"
                or key == "big-ship-wreck-1"
                or key == "big-ship-wreck-2"
                or key == "big-ship-wreck-3"
                or key == "module_specification"
                or key == "allowed_effects"
                or key == "hr_version"
                or key == "animation_shadow"
                or key == "instruments"
                or key == "action"
                or val == true then
            return true
        end
    end

    return false
end

function cleanup(tbl)
    for key, val in pairs(tbl) do
        if toRemove(key, val) then
            tbl[key] = nil
        else
            if type(tbl[key]) == "table" then
                cleanup(tbl[key])
            end
        end
    end
end

cleanup(clean)

file = io.open("clean.json", "w+")
io.output(file)
io.write(json.encode(clean))
io.close(file)