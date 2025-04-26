---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'lol_wp'

local data,change = _require('core_'..modid..'/data/componentactions')

API.CA:main(data,change)