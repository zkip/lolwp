
local ReplicaNetvar = require("replica_netvar")
local item_database = require("item_database")
local utils_passive = require("utils/passive")
local genNetVarName = utils_passive.genNetVarName

local lolwp_buff_owner = Class(ReplicaNetvar, function(self, inst)
	ReplicaNetvar._ctor(self, inst, "buffs")
end)

function lolwp_buff_owner:AddBuff()
	
end

return lolwp_buff_owner