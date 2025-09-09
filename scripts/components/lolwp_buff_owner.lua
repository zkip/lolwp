--[[
	该组件集合了以下功能
		multi_timer
		buff_controller
		buff_owner
	用于替代原版中的 debuff 和 debuffable 等组件
	该组件的 buff 实现方案和原版中最大的不同之处在于一个 buff 对应的不是一个实体，
	而是多个 buff 对应一个 buff_owner，一个 buff_owner 对应了一个作用对象

	需要明确的一点是该组件中的 <buff> 表示任何持续的效果，不仅包含了正向的效果(增益)，
	还包括了负向的效果(减益)
--]]

local makeClassMemberSync = require("utils/class_member_syncer")
local utils_passive = require("utils/passive")
local genNetVarName = utils_passive.genNetVarName

local function get_buff_timeleft(buff)
	return buff.end_time - GetTime()
end

local function addBuff(self, buff_name, args, timeleft)
	local buff_owner_replica = self.inst.replica.lolwp_buff_owner_replica
	local Buff = require('buffs/' .. buff_name)
	local buff = Buff(args)

	local duration = math.max(0, args.duration - (timeleft or 0))

	rawset(buff, 'buff_owner', self)
	rawset(buff, 'name', buff_name)
	rawset(buff, 'end_time', GetTime() + duration)

	local inst = self.inst
	local buff_owner = self
	local tasks_timeleft = { }
	
	local has_expired = false
	local has_periodic_task = false
	-- 为了避免有时无法触发最后一次的问题
	local DoPeriodicTask = function (self, interval, fn)
		local task_timeleft = 0
		local task = nil
		task = inst:DoPeriodicTask(interval, function ()
			fn(self)

			task_timeleft = task_timeleft + interval
			if task_timeleft >= duration or has_expired then
				if buff.WhenEnd then buff:WhenEnd() end
				if task then task:Cancel() end
				buff_owner:RemoveBuff(buff)
			end
		end)
		has_periodic_task = true
	end

	rawset(buff, 'DoPeriodicTask', DoPeriodicTask)

	if buff.WhenSetup then buff:WhenSetup() end

	self.inst:DoTaskInTime(duration, function ()
		has_expired = true
		if not has_periodic_task then
			if buff.WhenEnd then buff:WhenEnd() end
			buff_owner:RemoveBuff(buff)
		end
	end)

	for dataname, data_setting in pairs(Buff.data or { }) do
		local init_value, type = unpack(data_setting)
		local net_var = buff_owner_replica:Netvar(type, buff_name, dataname)
		makeClassMemberSync(buff, dataname, init_value, net_var)
	end

	local buffs = self.buff_database[buff_name] or { }
	buffs[buff] = { args = args, buff = buff }
	self.buff_database[buff_name] = buffs

	return buff
end

---@class component_buff_owner
local lolwp_buff_owner = Class(function(self, inst)
    self.inst = inst
	-- { buff_name string: { Buff: { args: table, buff: Buff } } }
	self.buff_database = { }
end)

function lolwp_buff_owner:OnSave()
	--[[
		需要持久化的数据:
			生效中的 buff
				种类
				参数 duration, interval 等
				计时器状态 time_left
	--]]
	local save_data = { buff_data_list = { }, buff_signs = { } }
	-- 保存所有 Buff 的状态
	for buff_name, buffs in pairs(self.buff_database) do
		for buff, buff_data in pairs(buffs) do
			local data = { }
			for dataname, data_setting in pairs(buff.data or { }) do
				data[dataname] = buff[dataname]
			end
			local time_left = get_buff_timeleft(buff)
			table.insert(save_data.buff_data_list, data)
			table.insert(save_data.buff_signs, { name = buff_name, args = buff_data.args, time_left = time_left })
		end
	end

    return save_data
end

function lolwp_buff_owner:OnLoad(save_data)
	-- 恢复所有 Buff 的状态
	for index, buff_data in ipairs(save_data.buff_data_list) do
		local buff_sign = save_data.buff_signs[index]
		local buff = addBuff(self, buff_sign.name, buff_sign.args, buff_sign.time_left, buff_sign.has_periodic_task)

		for dataname, _ in pairs(buff_data or { }) do
			buff[dataname] = buff_data[dataname]
		end
	end
end

function lolwp_buff_owner:AddBuff(buff_name, args)
	addBuff(self, buff_name, args)
end

function lolwp_buff_owner:RemoveBuff(buff)
	local buffs = self.buff_database[buff.name] or { }
	buffs[buff] = nil
end

-- 处理当试图添加多个同名 buff 时的行为(忽略/覆盖/叠加/延长/重置)
function lolwp_buff_owner:Extends(...)

end

function lolwp_buff_owner:Trigger(timing, ...)
	for buff_name, data in pairs(self.buff_database) do
        for buff, buff_data in pairs(data) do
            if buff[timing] then
				buff[timing](buff, ...)
			end
        end
	end
end

return lolwp_buff_owner