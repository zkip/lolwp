---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'lol_wp'

local data = _require('core_'..modid..'/data/changeactionsg')

API.CHANGEACTIONSG:main(data)