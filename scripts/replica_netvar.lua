
local item_database = require("item_database")
local utils_passive = require("utils/passive")
local genNetVarName = utils_passive.genNetVarName

local ReplicaNetvar = Class(function(self, inst, event_prefix)
    self.inst = inst
	self.event_prefix = event_prefix
	self.data = { }
end)

function ReplicaNetvar:GetData(kind_name, dataname)
	local identity, event_name = genNetVarName(self.event_prefix, kind_name, dataname)
	
	if self.data[identity] then
		return self.data[identity]:value()
	end
end

function ReplicaNetvar:ListenOnDataDirty(kind_name, dataname, fn, immediately)
	local identity, event_name = genNetVarName(self.event_prefix, kind_name, dataname)

	local event_map = self.__lolwp_event_map or { }
	self.__lolwp_event_map = event_map

	local event_fn = function (inst)
		fn(inst, self:GetData(kind_name, dataname))
	end

	event_map[fn] = event_fn

	if immediately then event_fn(self.inst) end

	self.inst:ListenForEvent(event_name, event_fn)
end

function ReplicaNetvar:RemoveDataDirtyCallback(kind_name, dataname, fn)
	local identity, event_name = genNetVarName(self.event_prefix, kind_name, dataname)

	local event_map = self.__lolwp_event_map or { }
	local event_fn = event_map[fn]

	if event_fn then self.inst:RemoveEventCallback(event_name, event_fn) end
end

function ReplicaNetvar:Netvar(netvar_type, kind_name, dataname)
	assert(_G['net_'..netvar_type] ~= nil)
	local identity, event_name = genNetVarName(self.event_prefix, kind_name, dataname)

	if not self.data[identity] then
		self.data[identity] = _G['net_'..netvar_type](self.inst.GUID, identity, event_name)
	end

	return self.data[identity]
end

return ReplicaNetvar