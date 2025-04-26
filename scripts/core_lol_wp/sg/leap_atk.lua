---@diagnostic disable: trailing-space, undefined-global
local LANCOORD = require('core_lol_wp/utils/coords')

local function timerestart(target)
    --时停恢复
    target.AnimState:Resume()
    target:RestartBrain()
    if target.Physics then
        target.Physics:SetActive(true)
    end
    if target.sg then
        target.sg:Start()
    end
end

local ENDFRAME = 13

local function leap_move_to_pos(inst,cur_frame)

    local self_x,_,self_z 
    local tar_x,_,tar_z
    

    self_x,_,self_z = inst:GetPosition():Get()
    if inst.lol_wp_divine_leap_target then
        tar_x,_,tar_z = inst.lol_wp_divine_leap_target:GetPosition():Get()
        inst.lol_wp_divine_leap_target_last_x = tar_x
        inst.lol_wp_divine_leap_target_last_z = tar_z
    else
        tar_x = inst.lol_wp_divine_leap_target_last_x
        tar_z = inst.lol_wp_divine_leap_target_last_z
    end

    if self_x and self_z and tar_x and tar_z then
        local dist = LANCOORD:calcDist(self_x,self_z,tar_x,tar_z,true)
        local n = dist/(ENDFRAME-cur_frame)
        local des_x,des_z = LANCOORD:findPointOnLine(self_x,self_z,tar_x,tar_z,dist,n)
        inst.Transform:SetPosition(des_x,0,des_z)
    end

    
end

local leap_timeline = {}

for i = 1,9 do
    table.insert(leap_timeline,TimeEvent(i*FRAMES,function(inst)
        leap_move_to_pos(inst,i)
        if i == 1 then
            inst.SoundEmitter:PlaySound('soundfx_lol_wp_divine/divine/wield_sword')
        end
    end))
end

table.insert(leap_timeline,TimeEvent(10*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .1, .1, 0, 0)

end))
table.insert(leap_timeline,TimeEvent(11*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .2, .2, 0, 0)
    
end))
table.insert(leap_timeline,TimeEvent(12*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .4, .4, 0, 0)
    
end))
table.insert(leap_timeline,TimeEvent(13*FRAMES,function(inst)
    inst.components.bloomer:PushBloom("helmsplitter", "shaders/anim.ksh", -2)
    inst.components.colouradder:PushColour("helmsplitter", 1, 1, 0, 0)
    inst.sg:RemoveStateTag("nointerrupt")
    ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .015, .5, inst, 20)

    inst.SoundEmitter:PlaySound('soundfx_lol_wp_divine/divine/hammer_smash')
    inst:PerformBufferedAction()
    -- local stage = 3
    -- inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/antlion/sfx/ground_break", { size = math.pow(stage / 3, 2) })
end))
table.insert(leap_timeline,TimeEvent(14*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .8, .8, 0, 0)
end))
table.insert(leap_timeline,TimeEvent(15*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .6, .6, 0, 0)
end))
table.insert(leap_timeline,TimeEvent(16*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .4, .4, 0, 0)
end))
table.insert(leap_timeline,TimeEvent(17*FRAMES,function(inst)
    inst.components.colouradder:PushColour("helmsplitter", .2, .2, 0, 0)
end))
table.insert(leap_timeline,TimeEvent(18*FRAMES,function(inst)
    inst.components.colouradder:PopColour("helmsplitter")
end))
table.insert(leap_timeline,TimeEvent(19*FRAMES,function(inst)
    inst.components.bloomer:PopBloom("helmsplitter")
end))

AddStategraphState("wilson", 
	State{
        name = "wisprain_helmsplitter",
        tags = { "helmsplitting", "doing", "nointerrupt", "nomorph", "pausepredict", "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst, target)
			if target == nil then
				if inst.bufferedaction ~= nil and inst.bufferedaction.target ~= nil and inst.bufferedaction.target:IsValid() then
					inst.sg.statemem.target = inst.bufferedaction.target
					inst.components.combat:SetTarget(inst.sg.statemem.target)
					target = inst.sg.statemem.target
				end
			end
			inst.components.health:SetInvincible(true)
			
            inst.components.locomotor:Stop()
            inst.Transform:SetEightFaced()
            inst.AnimState:PlayAnimation("atk_leap")
            -- inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")

            if target ~= nil and target:IsValid() then
                inst.sg.statemem.target = target
                inst:ForceFacePoint(target.Transform:GetWorldPosition())

                inst.lol_wp_divine_leap_target = target
            end

            

            inst.sg:SetTimeout(21 * FRAMES)

        end,

        timeline = leap_timeline,
        

        ontimeout = function(inst)
            inst.sg:GoToState("idle", true)
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
			---------------------------------------------
			-- 置空判定
			if inst.wisprain_parryhelmsplitter ~= nil and inst.wisprain_parryhelmsplitter then
				inst.wisprain_parryhelmsplitter = nil
			end
			timerestart(inst.sg.statemem.target)
			---------------------------------------------
			inst.components.health:SetInvincible(false)
			
            inst.components.combat:SetTarget(nil)
            inst.Transform:SetFourFaced()
            inst.components.bloomer:PopBloom("helmsplitter")
            inst.components.colouradder:PopColour("helmsplitter")
        end,
    }
)


AddStategraphState("wilson_client", State{
	name = 'wisprain_helmsplitter',
	tags = { "helmsplitting", "doing", "nointerrupt", "nomorph", "pausepredict", "attack", "notalking", "abouttoattack" },
	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.Transform:SetEightFaced()
		inst.AnimState:PlayAnimation("atk_leap")
		inst:PerformPreviewBufferedAction()
	end,
	timeline =
	{
		-- TimeEvent(12*FRAMES,function(inst)
            
            
        -- end)
	},
	onexit = function(inst)
		inst.Transform:SetFourFaced()
	end
})