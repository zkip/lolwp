--- alt shift 右键宣告

---@type table<string, fun(inst:ent)>
local items = {
    lol_wp_s7_tearsofgoddess = function (inst)
        ---@diagnostic disable-next-line: undefined-field
        if inst.replica.lol_wp_s7_tearsofgoddess then
            ---@diagnostic disable-next-line: undefined-field
            local num = inst.replica.lol_wp_s7_tearsofgoddess:GetVal()
            TheNet:Say(STRINGS.MOD_LOL_WP.ANNOUCE_TEARS..tostring(num))
        end
    end,
    lol_heartsteel = function (inst)
        ---@diagnostic disable-next-line: undefined-field
        if inst.replica.lol_heartsteel_num then
            ---@diagnostic disable-next-line: undefined-field
            local num = inst.replica.lol_heartsteel_num:GetNum()
            TheNet:Say(STRINGS.MOD_LOL_WP.ANNOUCE_HEART_STEEL..num*10)
        end
    end,
    lol_wp_s11_darkseal = function (inst)
        if inst.replica.lol_wp_s11_darkseal_num then
            local num = inst.replica.lol_wp_s11_darkseal_num:GetVal()
            TheNet:Say(STRINGS.MOD_LOL_WP.ANNOUCE_DARK_SEAL..num)
        end
    end,
    lol_wp_s11_mejaisoulstealer = function (inst)
        if inst.replica.lol_wp_s11_mejaisoulstealer_num then
            local num = inst.replica.lol_wp_s11_mejaisoulstealer_num:GetVal()
            TheNet:Say(STRINGS.MOD_LOL_WP.ANNOUCE_MEJAI_SOUL_STEALER..num)
        end
    end,
    lol_wp_s14_hubris = function (inst)
        if inst.replica.lol_wp_s14_hubris_skill_reputation then
            local num = inst.replica.lol_wp_s14_hubris_skill_reputation:GetVal()
            TheNet:Say(STRINGS.MOD_LOL_WP.ANNOUCE_HUBRIS..num)
        end
    end
}


local function tryAnnounce(slot)
    ---@type ent
    local item = slot.tile.item
    if item and item.replica then
        local prefab = item.prefab
        local fn = prefab and items[prefab]
        if fn then
            fn(item)
        end
    end
end

local function couldAnnouce(slot)
    ---@type ent
    local item = slot.tile.item
    local prefab = item and item.prefab
    if prefab and items[prefab] then
        return true
    end
    return false
end

for _,classname in pairs({"invslot", "equipslot"}) do
	local SlotClass = require("widgets/"..classname)
	local SlotClass_OnControl = SlotClass.OnControl
	function SlotClass:OnControl(control, down, ...)
		if down and control == CONTROL_ACCEPT
			-- and TheInput:IsControlPressed(CONTROL_FORCE_INSPECT)
			-- and TheInput:IsControlPressed(CONTROL_FORCE_TRADE)
            -- and TheInput:IsKeyDown(KEY_SHIFT)
            and TheInput:IsKeyDown(KEY_ALT)
			and self.tile and couldAnnouce(self) then -- ignore empty slots
			tryAnnounce(self)
        -- else
        --     return SlotClass_OnControl(self, control, down, ...)
		end
        return SlotClass_OnControl(self, control, down, ...)
	end
end
