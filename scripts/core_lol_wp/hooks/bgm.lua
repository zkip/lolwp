-- bgm 路径格式: {pack}/bgm/bgm_{prefab}
local modid = 'lol_wp'

---comment
---@param data table<string,_equip_bgm_data>
---@param key string
---@return string
---@nodiscard
local function genBGMpath(data,key)
    local _data = data[key]
    local name_pack = _data.pack
    local name_group = _data.group or 'bgm'
    local name = _data.name or ('bgm_'..key)
    return name_pack .. '/' .. name_group .. '/' .. name
end

if TUNING[string.upper('CONFIG_'..modid..'lol_wp_bgm_whenequip')] then

    ---@type table<string,_equip_bgm_data>
    local equips = require('core_'..modid..'/data/bgm')

    for equip,_ in pairs(equips) do
        AddPrefabPostInit(equip,function (inst)
            if not inst.SoundEmitter then
                inst.entity:AddSoundEmitter()
            end
            if not TheWorld.ismastersim then
                return inst
            end

            inst['bgm_'..equip] = true

            inst:AddComponent('lol_wp_bgm')

            if inst.components.equippable then
                local old_onequipfn = inst.components.equippable.onequipfn
                inst.components.equippable.onequipfn = function (inst,owner,...)
                    if inst.SoundEmitter then
                        local path = genBGMpath(equips,equip)
                        local volume = equips[equip].volume
                        if not inst['bgm_'..equip] then
                            volume = 0
                        end
                        inst.SoundEmitter:PlaySound(path,'bgm_' .. equip,volume)
                    end
                    return old_onequipfn ~= nil and old_onequipfn(inst,owner,...)
                end

                local old_onunequipfn = inst.components.equippable.onunequipfn
                inst.components.equippable.onunequipfn = function (inst,owner,...)
                    if inst.SoundEmitter then
                        inst.SoundEmitter:KillSound('bgm_' .. equip)
                    end
                    return old_onunequipfn ~= nil and old_onunequipfn(inst,owner,...)
                end
            end

            inst:ListenForEvent('serverpauseddirty',function ()
                if inst and inst.SoundEmitter then
                    if TheNet:IsServerPaused() then
                        inst.SoundEmitter:SetVolume('bgm_'..equip,0)
                    else
                        if inst['bgm_'..equip] then
                            inst.SoundEmitter:SetVolume('bgm_'..equip,equips[equip].volume)
                        end
                    end
                end
            end,TheWorld)

            local old_OnSave = inst.OnSave
            inst.OnSave = function (inst,data)
                local res = old_OnSave ~= nil and {old_OnSave(inst,data)} or {}
                data['bgm_'..equip] = inst['bgm_'..equip]
                return unpack(res)
            end
            local old_OnLoad = inst.OnLoad
            inst.OnLoad = function (inst,data)
                local res = old_OnLoad ~= nil and {old_OnLoad(inst,data)} or {}
                if data and data['bgm_'..equip] ~= nil then
                    inst['bgm_'..equip] = data['bgm_'..equip]
                end
                if inst.SoundEmitter then
                    if inst['bgm_'..equip] then
                        inst.SoundEmitter:SetVolume('bgm_'..equip,equips[equip].volume)
                    else
                        inst.SoundEmitter:SetVolume('bgm_'..equip,0)
                    end
                end

                return unpack(res)
            end

        end)
    end
end

