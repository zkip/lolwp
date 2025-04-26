---@diagnostic disable: lowercase-global, undefined-global, trailing-space

local modid = 'lol_wp'

---@type data_keyhandler[]
-- AI: 定义了一个数据表，包含技能信息
local data = {
    -- {
    --     namespace = 'lol_wp',
    --     skillid = 'test',
    --     type = 'down',
    --     key = 'KEY_H',
    --     skill_template_type = 'none',
    --     client_fn_before = function (player)
    --         local fx_len = 10
    --         local c_x,_,c_z = ConsoleWorldPosition():Get() 
    --         local fx = SpawnPrefab("spear_wathgrithr_lightning_lunge_fx") 
    --         fx.Transform:SetNoFaced()
    --         fx.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround) 
    --         fx.Transform:SetPosition(c_x,0,c_z) 
    --         local x,_,z = ThePlayer:GetPosition():Get() 

    --         local real_dist = LOLWP_C:calcDist(x,z,c_x,c_z,true)
    --         local fx_scale = real_dist/fx_len

    --         fx.AnimState:SetScale(fx_scale,0.5) 
    --         local res_x,res_z = 2*c_x - x, 2*c_z - z 
    --         fx:ForceFacePoint(res_x,0,res_z) 

    --     end
    -- }
    -- {
    --     namespace = 'lol_wp',
    --     skillid = 'testing',
    --     type = 'down',
    --     key = 'KEY_H',
    --     skill_template_type = 'none',
    --     client_fn_before = function (player)
    --         -- local c = c_select()
    --         -- if c then
    --         --     print(c.prefab)
    --         -- end
            

    --     end
    -- }
    {
        namespace = modid,
        skillid = 'lol_wp_s15_zhonya_freeze',
        type = 'down',
        key = TUNING[string.upper('CONFIG_'..modid..'key_lol_wp_s15_zhonya_freeze')],
        skill_template_type = 'normal_with_CD', -- 防止频繁发送rpc
        skill_template_normal_with_CD = {
            cd = TUNING.MOD_LOL_WP.ZHONYA.SKILL_FREEZE.CD,
        },
        fn = function (player, ...)
            -- 先找装备中的
            local success = false
            local equips, found = LOLWP_S:findEquipments(player, 'lol_wp_s15_zhonya')
            if found then
                for _, equip in ipairs(equips) do
                    if not equip:HasTag('lol_wp_s15_zhonya_iscd') and equip.components.lol_wp_s15_zhonya then
                        success = equip.components.lol_wp_s15_zhonya:DoAction(player)
                        break
                    end
                end
            end
            -- 再找眼石
            if not success then
                local equips_ineyestone = LOLWP_U:getEquipInEyeStone(player,'lol_wp_s15_zhonya')
                if equips_ineyestone then
                    if not equips_ineyestone:HasTag('lol_wp_s15_zhonya_iscd') and equips_ineyestone.components.lol_wp_s15_zhonya then
                        success = equips_ineyestone.components.lol_wp_s15_zhonya:DoAction(player)
                    end
                end
            end
        end, 
    }
}


return data
