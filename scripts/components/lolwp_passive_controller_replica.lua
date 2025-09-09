--[[

	net_bool                1-bit boolean
	net_tinybyte            3-bit unsigned integer   [0..7]
	net_smallbyte           6-bit unsigned integer   [0..63]
	net_byte                8-bit unsigned integer   [0..255]
	net_shortint            16-bit signed integer    [-32767..32767]
	net_ushortint           16-bit unsigned integer  [0..65535]
	net_int                 32-bit signed integer    [-2147483647..2147483647]
	net_uint                32-bit unsigned integer  [0..4294967295]
	net_float               32-bit float
	net_hash                32-bit hash of the string assigned
	net_string              variable length string
	net_entity              entity instance
	net_bytearray           array of 8-bit unsigned integers (max size = 31)
	net_smallbytearray      array of 6-bit unsigned integers (max size = 31)

--]]

local ReplicaNetvar = require("replica_netvar")
local item_database = require("item_database")
local utils_passive = require("utils/passive")

local lolwp_passive_controller = Class(ReplicaNetvar, function(self, inst)
	ReplicaNetvar._ctor(self, inst, "passives")

	local item_data = item_database:get_by_prefab(inst.prefab)
	self:SetupPassives(item_data and item_data.passives or { })
end)

function lolwp_passive_controller:SetupPassives(passives)
	for passive_name, passive_args in pairs(passives) do
		local Passive = require("passives/" .. passive_name)

		for dataname, data_setting in pairs(Passive.data or { }) do
			local _, type = unpack(data_setting)
			self:Netvar(type, passive_name, dataname)
		end
	end
end

return lolwp_passive_controller