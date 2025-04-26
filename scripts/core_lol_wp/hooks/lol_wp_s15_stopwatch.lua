local function on_show_warp_marker(inst)
	if inst.components.positionalwarp then
		inst.components.positionalwarp:EnableMarker(true)
	end
end

local function on_hide_warp_marker(inst)
	if inst.components.positionalwarp then
		inst.components.positionalwarp:EnableMarker(false)
	end
end

local function DelayedWarpBackTalker(inst)
	-- if the player starts moving right away then we can skip this
	if inst.sg == nil or inst.sg:HasStateTag("idle") then 
		inst.components.talker:Say(GetString(inst, "ANNOUNCE_POCKETWATCH_RECALL"))
	end
end

local function OnWarpBack(inst, data)
	if inst.components.positionalwarp ~= nil then
		if data ~= nil and data.reset_warp then
			inst.components.positionalwarp:Reset()
			inst:DoTaskInTime(15 * FRAMES, DelayedWarpBackTalker)
		else
			inst.components.positionalwarp:GetHistoryPosition(true)
		end
	end
end

AddPlayerPostInit(function (inst)
    if not TheWorld.ismastersim then
        return inst
    end
    -- inst:AddComponent("lol_wp_player_footprint_traceback")
    if inst.components.positionalwarp == nil then
        inst:AddComponent("positionalwarp")
		inst.components.positionalwarp:SetWarpBackDist(TUNING.WANDA_WARP_DIST_NORMAL)
        inst:DoTaskInTime(0, function() inst.components.positionalwarp:SetMarker("pocketwatch_warp_marker") end)
        inst:ListenForEvent("show_warp_marker", on_show_warp_marker)
        inst:ListenForEvent("hide_warp_marker", on_hide_warp_marker)

        inst:ListenForEvent("onwarpback", OnWarpBack)

		-- local x,_,z = inst:GetPosition():Get()
		-- inst.sg.statemem.warpback_data = {dest_worldid = TheShard:GetShardId(), dest_x = x, dest_y = 0, dest_z = z, reset_warp = true}
		-- inst.sg.statemem.warpback = {dest_worldid = TheShard:GetShardId(), dest_x = x, dest_y = 0, dest_z = z, reset_warp = true}
    end

end)


local old_CAST_POCKETWATCH_fn = ACTIONS.CAST_POCKETWATCH.fn
ACTIONS.CAST_POCKETWATCH.fn = function(act,...)
    local res = old_CAST_POCKETWATCH_fn ~= nil and old_CAST_POCKETWATCH_fn(act,...) or nil

	if res ~= true then
		local caster = act.doer
		if act.invobject ~= nil and caster ~= nil and not caster:HasTag("pocketwatchcaster") and act.invobject.prefab == 'lol_wp_s15_stopwatch' then
			res = act.invobject.components.pocketwatch:CastSpell(caster, act.target, act:GetActionPoint())
		end
	end

	return res
end
