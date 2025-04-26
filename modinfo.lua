---@diagnostic disable: lowercase-global, undefined-global, trailing-space
-- 本地化
local op={{'A',97},{'B',98},{'C',99},{'D',100},{'E',101},{'F',102},{'G',103},{'H',104},{'I',105},{'J',106},{'K',107},{'L',108},{'M',109},{'N',110},{'O',111},{'P',112},{'Q',113},{'R',114},{'S',115},{'T',116},{'U',117},{'V',118},{'W',119},{'X',120},{'Y',121},{'Z',122},{'0',48},{'1',49},{'2',50},{'3',51},{'4',52},{'5',53},{'6',54},{'7',55},{'8',56},{'9',57}}
local modid = 'lol_wp'
local LANGS = {
    ['zh'] = {
        name = '英雄联盟武器',
        description = [[目前更新武器：
战士武器：
多兰之刃，萃取，黑曜石锋刃，铁刺鞭，提亚马特，耀光，斯塔缇克电刃，鬼索的狂暴之刃，黑色切割者，破败王者之刃，魔宗，岚切，三相之力，神圣分离者，焚天，无尽之刃，狂妄，炼金朋克链锯剑，收集者，渴血战斧，饮血剑，挺进破坏者，魔切，星蚀，海妖杀手
坦克装备：
多兰之盾，棘刺背心，荆棘之甲，凛冬之临，日炎圣盾，心之钢，巨型九头蛇，破舰者，狂徒铠甲，霸王血铠，末日寒冬
法术武器：
多兰之戒，增幅典籍，黑暗封印，女神之泪，遗失的章节，爆裂魔杖，无用大棒，纳什之牙，破碎王后之冕，瑞莱的冰晶节杖，大天使之杖，中娅沙漏，卢登的回声，巫妖之祸，峡谷制造者，恶魔之拥，灭世者的死亡之帽，梅贾的窃魂卷，炽天使之拥，兰德里的折磨
辅助装备：
生命药水，复用型药水，秒表，腐败药水，戒备眼石，警觉眼石，引路者
]],
        config = {
            -- {'设置的id','设置的名称','聚焦时显示的提示',默认值,{
            --     {选项一,值},
            --     {选项二,值}
            -- }},
            -- {'语言'},
            -- {modid..'_lang','语言','语言','cn',{
            --     {'简体中文','cn'},
            --     {'English','en'}
            -- }},
            {'装备强度配置'},
            -- {modid..'_dmgmult','伤害倍率','调整伤害倍率',1,{
            --     {'0.5倍',0.5},
            --     {'1倍',1},
            --     {'2倍',2}
            -- }}
            {'bloodaxe_health','渴血战斧吸血','渴血战斧吸血',3,{
                {'-3',-3},
                {'3',3},
                {'5',5},
                {'8',8},
            }},
            {'lol_wp_s14_hubris_skill_reputation_limit','狂妄被动上限','狂妄被动上限',20,{
                {'20',20},
                {'40',40},
                {'无限',false},
            }},
            {'tears_limit','女神泪上限','女神泪上限',300,{
                {'300',300},
                {'500',500},
                {'700',700},
            }},
            {'darkseel_limit','杀人戒上限','杀人戒上限',20,{
                {'10',10},
                {'20',20},
                {'40',40},
                {'无限',65534}
            }},
            {'mejai_limit','杀人书上限','杀人书上限',40,{
                {'20',20},
                {'40',40},
                {'60',60},
                {'无限',65534}
            }},
            {'lol_wp_eyestone_item_effect_half','眼石物品伤害削减','眼石中的护符额外伤害削减倍率',.5,{
                {'-50%',.5},
                {'-20%',.8},
                {'关闭',1},
            }},
            {'not_little_items_durability','大件装备耐久','大件装备耐久',1,{
                {'减半',.5},
                {'正常',1},
                {'2倍',2},
                {'无限',3}
            }},
            {'little_items_durability','小件装备耐久','小件装备耐久',1,{
                {'减半',.5},
                {'正常',1},
                {'2倍',2},
                -- {'无限',3}
            }},
            {'could_repair','武器是否可修复','武器是否可修复',1,{
                {'可修复',1},
                {'仅小件',2},
                {'仅大件',3},
                {'不可修复',4}
            }},
            {'个人偏好配置'},
            {'gallopbreakermusic','破舰者音乐','开启手持破舰者音乐',true,{
                {'开',true},
                {'关',false},
            }},
            {'lol_wp_bgm_whenequip','武器bgm','武器bgm',true,{
                {'开',true},
                {'关',false},
            }},

            {'eclipse_laser_destory_everything','星蚀破坏力','弱：只能破坏岩石树木\n强：斩断一切',1,{
                {'弱',1},
                {'强',2},
            }},


            {'key_lol_wp_s15_zhonya_freeze','中娅沙漏 凝滞','中娅沙漏 凝滞按键',118,op},
            {'collector_drop_gold','收集者是否爆金币','收集者是否爆金币',true,{
                {'是',true},
                {'否',false},
            }},
            {'sunfire_aura','日炎灼烧光环','日炎灼烧光环',true,{
                {'开',true},
                {'关',false},
            }},




            {'心之钢配置'},
            {'limit_lol_heartsteel_new','层数限制','是关限制层数',40,{
                {'400',40},
                {'600',60},
                {'800',80},
                {'1000',100},
                {'无上限',false}
            }},
            {'limit_lol_heartsteel_transform_scale','体型上限','不改变/40%/无限',1,{
                {'无',0},
                {'40%',1},
                {'无限',2},
            }},
            {'limit_lol_heartsteel_equipslot','栏位','栏位',1,{
                {'项链',1},
                {'身体',2},
            }},
            {'limit_lol_heartsteel_blueprint_dropby','蓝图掉落','蓝图掉落',2,{
                {'普通克劳斯',1},
                {'狂暴克劳斯',2},
            }},
        }
    },
    ['en'] = {
        name = 'LOL ITEMS',
        description = '',
        config = {
            -- {'LANGUAGE'},
            -- {modid..'_lang','language','choose language','en',{
            --     {'简体中文','cn'},
            --     {'English','en'}
            -- }},
            {'FUNCTIONS'},
            -- {modid..'_dmgmult','Damage Mult','Damage Mult Settings',{
            --     {'x0.5',0.5},
            --     {'x1',1},
            --     {'x2',2}
            -- }}
            {'bloodaxe_health','bloodaxe drain','bloodaxe drain',3,{
                {'-3',-3},
                {'3',3},
                {'5',5},
                {'8',8},
            }},
            {'lol_wp_s14_hubris_skill_reputation_limit','Hubris Limit','Hubris Limit',20,{
                {'20',20},
                {'40',40},
                {'No Limit',false},
            }},
            {'tears_limit','tears of godness limit','tears of godness limit',300,{
                {'300',300},
                {'500',500},
                {'700',700},
            }},
            {'darkseel_limit','DarkSeel Limit','DarkSeel Limit',20,{
                {'10',10},
                {'20',20},
                {'40',40},
                {'NoLimit',65534}
            }},
            {'mejai_limit','Mejai Limit','Mejai Limit',40,{
                {'20',20},
                {'40',40},
                {'60',60},
                {'NoLimit',65534}
            }},
            {'lol_wp_eyestone_item_effect_half','Item In EyeStone HalfEffect','Item In EyeStone HalfEffect',.5,{
                {'-50%',.5},
                {'-20%',.8},
                {'No',1},
            }},
            {'not_little_items_durability','Big Item Durability','Big Item Durability',1,{
                {'x.5',.5},
                {'x1',1},
                {'x2',2},
                {'NoLimit',3}
            }},
            {'little_items_durability','Little Item Durability','Little Item Durability',1,{
                {'x.5',.5},
                {'x1',1},
                {'x2',2},
                -- {'无限',3}
            }},
            {'could_repair','Allow Repair','Allow Repair',1,{
                {'Allow',1},
                {'Little Items Only',2},
                {'Big Items Only',3},
                {'Not Allow',4}
            }},
            {'Custom'},
            {'gallopbreakermusic','Hullbreaker bgm','Enable this and you will hear the music of Hullbreaker',true,{
                {'Off',true},
                {'On',false},
            }},
            {'lol_wp_bgm_whenequip','weapon BGM','weapon BGM',true,{
                {'Off',true},
                {'On',false},
            }},

            {'eclipse_laser_destory_everything','Eclipse Laser Destory Power','Low：Only rocks and trees\nHigh：Destory Everything',1,{
                {'low',1},
                {'high',2},
            }},


            {'key_lol_wp_s15_zhonya_freeze','Zhonya Freeze','Zhonya Freeze Key Config',118,op},
            {'collector_drop_gold','Collector Drop Coin','Collector Drop Coin',true,{
                {'yes',true},
                {'no',false},
            }},
            {'sunfire_aura','sunfire burn aura','sunfire burn aura',true,{
                {'on',true},
                {'off',false},
            }},




            {'HeartSteel Config'},
            {'limit_lol_heartsteel_new','Limit the number of Heartsteel layers','Limit the number of Heartsteel layers',40,{
                {'400',40},
                {'600',60},
                {'800',80},
                {'1000',100},
                {'无上限',false}
            }},
            {'limit_lol_heartsteel_transform_scale','Heartsteel change the size of the Player','No Change/40%/Infinite',1,{
                {'No Change',0},
                {'40%',1},
                {'Infinite',2},
            }},
            {'limit_lol_heartsteel_equipslot','equipslot','equipslot',1,{
                {'necklace',1},
                {'body',2},
            }},
            {'limit_lol_heartsteel_blueprint_dropby','blueprint itemdrop','blueprint itemdrop',2,{
                {'klaus',1},
                {'rampage klaus',2},
            }},
        }
    }
}

-- 决定当前用的语言
local cur = (locale == 'zh' or locale == 'zhr') and 'zh' or 'en'

-- mod相关信息
version = '9.5.2'
author = '艾趣44，LAN，zzzzzzzs，醨，HPMY，C'
forumthread = ''
api_version = 10
priority = 0 -- 加载优先级，越低加载越晚，默认为0

dst_compatible = true -- 联机版适配性
dont_starve_compatible = false -- 单机版适配性
reign_of_giants_compatible = false -- 单机版：巨人国适配性
all_clients_require_mod = true -- 服务端/所有端模组
-- server_only_mod = true -- 仅服务端模组
-- client_only_mod = true -- 仅客户端模组
server_filter_tags = {} -- 创意工坊模组分类标签
icon_atlas = 'modicon.xml' -- 图集
icon = 'modicon.tex' -- 图标

-- 以下自动配置
name = LANGS[cur].name
description = version..'\n'..LANGS[cur].description

-- local op = {
--     {description='A', data = 97},
--     {description='B', data = 98},
--     {description='C', data = 99},
--     {description='D', data = 100},
--     {description='E', data = 101},
--     {description='F', data = 102},
--     {description='G', data = 103},
--     {description='H', data = 104},
--     {description='I', data = 105},
--     {description='J', data = 106},
--     {description='K', data = 107},
--     {description='L', data = 108},
--     {description='M', data = 109},
--     {description='N', data = 110},
--     {description='O', data = 111},
--     {description='P', data = 112},
--     {description='Q', data = 113},
--     {description='R', data = 114},
--     {description='S', data = 115},
--     {description='T', data = 116},
--     {description='U', data = 117},
--     {description='V', data = 118},
--     {description='W', data = 119},
--     {description='X', data = 120},
--     {description='Y', data = 121},
--     {description='Z', data = 122},

--     {description='0', data = 48},
--     {description='1', data = 49},
--     {description='2', data = 50},
--     {description='3', data = 51},
--     {description='4', data = 52},
--     {description='5', data = 53},
--     {description='6', data = 54},
--     {description='7', data = 55},
--     {description='8', data = 56},
--     {description='9', data = 57},
-- }

local config = LANGS[cur].config or {}
local _configuration_options = {}
for i = 1, #config do
    local options = {}
    if config[i][5] then
        for k = 1, #config[i][5] do
            options[k] = {description = config[i][5][k][1], data = config[i][5][k][2]}
        end
    end
    _configuration_options[i] = {
        name = config[i][1],
        label = config[i][2],
        hover = config[i][3] or '',
        default = config[i][4] or false,
        options = #options>0 and options or {{description = "", data = false}},
    }
end

configuration_options = _configuration_options