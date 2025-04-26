local db = TUNING.MOD_LOL_WP.HUBRIS

---@class components
---@field lol_wp_s14_hubris_skill_reputation component_lol_wp_s14_hubris_skill_reputation # 狂妄 被动：【盛名】 <br> 每击杀一个boss生物会叠加一层被动，

local function on_val(self, value)
    self.inst.replica.lol_wp_s14_hubris_skill_reputation:SetVal(value)
end

---@class component_lol_wp_s14_hubris_skill_reputation
---@field inst ent
---@field val integer # 层数 有最大值
local lol_wp_s14_hubris_skill_reputation = Class(
---@param self component_lol_wp_s14_hubris_skill_reputation
---@param inst ent
function(self, inst)
    self.inst = inst
    self.val = 0
end,
nil,
{
    val = on_val,
})

function lol_wp_s14_hubris_skill_reputation:OnSave()
    return {
        val = self.val
    }
end

function lol_wp_s14_hubris_skill_reputation:OnLoad(data)
    self.val = data.val or 0
end

---comment
---@param val integer
function lol_wp_s14_hubris_skill_reputation:DoDelta(val)
    if not self:IsMax() then
        if not db.SKILL_REPUTATION.MAXSTACK then
            self.val = math.max(0,self.val + val)
        else
            if (self.val + val) >= db.SKILL_REPUTATION.MAXSTACK then
                self.val = db.SKILL_REPUTATION.MAXSTACK
            else
                self.val = math.max(0,self.val + val)
            end
        end
    end
end

function lol_wp_s14_hubris_skill_reputation:IsMax()
    if not db.SKILL_REPUTATION.MAXSTACK then
        return false
    else
        return self.val >= db.SKILL_REPUTATION.MAXSTACK
    end
end

---获取层数
---@return integer
---@nodiscard
function lol_wp_s14_hubris_skill_reputation:GetStack()
    return self.val
end

---计算攻击力加成
---@return number
---@nodiscard
function lol_wp_s14_hubris_skill_reputation:CalcAtkDmg()
    return db.SKILL_REPUTATION.DMG_PER_STACK * self.val
end

return lol_wp_s14_hubris_skill_reputation