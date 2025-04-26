local db = TUNING.MOD_LOL_WP.STORMRAZOR

---@class components
---@field lol_wp_s18_stormrazor_tornado component_lol_wp_s18_stormrazor_tornado

-- local function on_val(self, value)
    -- self.inst.replica.lol_wp_s18_stormrazor_tornado:SetVal(value)
-- end

---@class component_lol_wp_s18_stormrazor_tornado
---@field inst ent
local lol_wp_s18_stormrazor_tornado = Class(

---@param self component_lol_wp_s18_stormrazor_tornado
---@param inst ent
function(self, inst)
    self.inst = inst
    -- self.val = 0
end,
nil,
{
    -- val = on_val,
})

-- function lol_wp_s18_stormrazor_tornado:OnSave()
--     return {
--         -- val = self.val
--     }
-- end

-- function lol_wp_s18_stormrazor_tornado:OnLoad(data)
--     -- self.val = data.val or 0
-- end

local function getspawnlocation(inst, target)
    local x1, y1, z1 = inst.Transform:GetWorldPosition()
    local x2, y2, z2 = target.Transform:GetWorldPosition()
    return x1 + .15 * (x2 - x1), 0, z1 + .15 * (z2 - z1)
end

local function spawntornado(staff, target, doer)
    local tornado = SpawnPrefab("lol_wp_s18_stormrazor_tornado_2", staff.linked_skinname, staff.skin_id)
    tornado.WINDSTAFF_CASTER = staff.components.inventoryitem.owner
    tornado.WINDSTAFF_CASTER_ISPLAYER = tornado.WINDSTAFF_CASTER ~= nil and tornado.WINDSTAFF_CASTER:HasTag("player")
    tornado.Transform:SetPosition(getspawnlocation(staff, target))
    tornado.components.knownlocations:RememberLocation("target", target:GetPosition())

    tornado._lol_wp_s18_stormrazor_tornado_belongs_to = doer

    if tornado.WINDSTAFF_CASTER_ISPLAYER then
        tornado.overridepkname = tornado.WINDSTAFF_CASTER:GetDisplayName()
        tornado.overridepkpet = true
    end

    -- staff.components.finiteuses:Use(1)
end

---comment
---@param wp ent
---@param doer ent
---@param target ent
---@return boolean
function lol_wp_s18_stormrazor_tornado:CastTornado(wp,doer,target)
    if wp.components.lol_wp_cd_itemtile and not wp.components.lol_wp_cd_itemtile:IsCD() then
        wp.components.lol_wp_cd_itemtile:ForceStartCD(db.SKILL_WIND_SLASH.CD)

        -- local pt = target:GetPosition()
        -- local tar_x,_,tar_z = pt:Get()

        -- local tornado = SpawnPrefab('lol_wp_s18_stormrazor_tornado')
        -- ---@cast tornado ent_lol_wp_s18_stormrazor_tornado
        -- tornado._lol_wp_s18_stormrazor_tornado_belongs_to = doer
        -- tornado._lol_wp_s18_stormrazor_tornado_weapon = wp
        -- tornado._lol_wp_s18_stormrazor_tornado_target_pos = pt

        -- tornado.Transform:SetPosition(doer:GetPosition():Get())



        spawntornado(wp,target, doer)



        return true

    end
    return false
end

return lol_wp_s18_stormrazor_tornado