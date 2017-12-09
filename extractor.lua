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