-- 以下为固定写法
local Widget = require 'widgets/widget' -- 引入基类
local Text = require 'widgets/text'
local Image = require 'widgets/image'
local ImageButton = require 'widgets/imagebutton'
local ScrollableList = require 'widgets/scrollablelist'
local TEMPLATES = require "widgets/redux/templates"
local TrueScrollArea = require "widgets/truescrollarea"


local lol_wp_pedia_scrollablelist = require('core_lol_wp/widgets/lol_wp_pedia_scrollablelist')
local lol_wp_pedia_items_scroll = require('core_lol_wp/widgets/lol_wp_pedia_items_scroll')

local lol_wp_pedia_group_btn = require('core_lol_wp/widgets/lol_wp_pedia_group_btn')
local lol_wp_pedia_item_txt = require('core_lol_wp/widgets/lol_wp_pedia_item_txt')

local modid = 'lol_wp'
---@type lang_lol_wp_pedia
local lang = require('core_lol_wp/languages/lol_wp_pedia/'..TUNING['CONFIG_'..string.upper(modid)..'_LANG'])

local data = require('core_lol_wp/data/lol_wp_pedia')
local pedia_items = data.pedia_items
local pedia_items_order = data.pedia_items_order
local groups_order = data.groups_order
local group_spec = data.group_spec

local max_hud_scale_lol_wp = .75 -- 自适应缩放最大比
local pedia_bg_img_scale = .8 -- 百科背景图片缩放比

---comment
---@param xml_path string
---@return fun(tex_withext: string): widget_image # image实例
local function genImage(xml_path)
    return function (tex_withext)
        return Image(xml_path,tex_withext)
    end
end


local gen_image_quagmire_recipebook = genImage('images/lol_wp_pedia/quagmire_recipebook.xml')

---@class widget_lol_wp_pedia : widget_widget
---@field bg_root widget_widget # root widget
---@field groups widget_lol_wp_pedia_group_btn[] # 左侧边栏 便签分类
---@field bg widget_image # 百科背景
---@field scroll_page_member table<lol_wp_pedia_group,widget_imagebutton[]> # 滚动条成员(自动布局)
---@field scroll_list widget_scrollablelist # 滚动条
---@field items_root widget_widget # 图鉴容器
---@field items_bg widget_image # 图鉴容器背景
---@field items_avatar_slot_bg widget_image # 图鉴头像背景
---@field items_avatar widget_image # 图鉴头像
---@field items_txt widget_text # 图鉴信息显示  方案二(大杂烩)
---@field items_txt_width number # 图鉴信息SetRegionSize宽度
---@field scroll_area widget_truescrollarea # 滚动区域
---@field scissor_data table
---@field items_avatar_around_info_name widget_text # 图鉴头像周围信息: 名字
---@field items_avatar_around_info_inspect widget_text # 图鉴头像周围信息: 检视台词
local lol_wp_pedia = Class(Widget,
---@param self widget_lol_wp_pedia
function(self)
    Widget._ctor(self, 'lol_wp_pedia') -- 调用基类构造函数

    -- root
    self.bg_root = self:AddChild(Widget('bg_root'))
    self.bg_root:SetVAnchor(ANCHOR_MIDDLE)
    self.bg_root:SetHAnchor(ANCHOR_MIDDLE)
    self.bg_root:SetScaleMode(SCALEMODE_FIXEDPROPORTIONAL)
    self.bg_root:SetMaxPropUpscale(max_hud_scale_lol_wp)

    -- 组别
    ---@type nil|integer # 组别历史点击记录索引
    local groups_btn_history_index
    self.groups = {}
    for i,v in ipairs(groups_order) do
        self.groups[i] = self.bg_root:AddChild(lol_wp_pedia_group_btn(lang.lol_wp_pedia_group[v],group_spec[v].btn_color,function ()
            if groups_btn_history_index then
                self.groups[groups_btn_history_index]:OnClickOtherBtn()
            end
            groups_btn_history_index = i
            self:ScrollSwitchGroup(i)
        end))
        self.groups[i]:SetPosition(-538,180-i*50,0)
        self.groups[i]:SetScale(.5,.5,1)
        -- self.groups[i]:SetVAnchor(ANCHOR_MIDDLE)
        -- self.groups[i]:SetHAnchor(ANCHOR_MIDDLE)
    end

    -- 百科背景
    self.bg = self.bg_root:AddChild(gen_image_quagmire_recipebook('quagmire_recipe_menu_bg.tex'))
    self.bg:SetScale(pedia_bg_img_scale,pedia_bg_img_scale,1)

    -- 滚动条成员
    self.scroll_page_member = {}
    for _,v in ipairs(groups_order) do
        self.scroll_page_member[v] = {}
    end

    for _,v in ipairs(pedia_items_order) do
        local _type = pedia_items[v].group
        local _xml = pedia_items[v].xml or ('images/inventoryimages/'..v..'.xml')
        local _tex = pedia_items[v].tex or (v..'.tex')
        ---@type widget_imagebutton
        local member_bg = ImageButton('images/lol_wp_pedia/member_bg.xml','member_bg.tex','member_bg.tex','member_bg.tex','member_bg.tex','member_bg.tex')
        ---@type widget_image
        local member_slot_bg = member_bg:AddChild(Image('images/lol_wp_pedia/slot_with_outline.xml','slot_with_outline.tex'))
        ---@type widget_image
        local member_avatar = member_slot_bg:AddChild(Image(_xml,_tex))
        ---@type widget_text # 成员label
        local member_label = member_bg:AddChild(Text(BODYTEXTFONT,30,pedia_items[v].name))
        member_slot_bg:SetScale(.65,.65,1)
        member_slot_bg:SetPosition(-100-70/2,0,0)
        member_label:SetRegionSize(100+70,40)
        member_label:SetHAlign(ANCHOR_LEFT)
        local member_label_rgba = pedia_items[v].name_rgba
        if member_label_rgba then
            member_label:SetColour(unpack(member_label_rgba))
        end
        -- 滚动条成员点击后显示图鉴
        member_bg:SetOnClick(function()
            self:SwitchItem(v,_xml,_tex)
        end)

        table.insert(self.scroll_page_member[_type],member_bg)
    end

    -- 滚动条
    local SCROLLBAR_STYLE = {
        unique = 'lol_wp_pedia',
        atlas = "images/lol_wp_pedia/lol_wp_pedia_scrollablelist.xml",
        up = "up.tex",
        down = "down.tex",
        bar = "bar.tex",
        handle = "handle.tex",
        --~ scale = 0.4,
        scale = 0.5,
    }
    ---@type widget_scrollablelist
    self.scroll_list = self.bg_root:AddChild(lol_wp_pedia_scrollablelist(groups_order,200,450,50,10,nil,nil,nil,nil,nil,nil,nil,nil,SCROLLBAR_STYLE,self.scroll_page_member))
    self.scroll_list.scroll_bar_line:SetScale(.8,1,1)
    self.scroll_list:SetPosition(-120,0,0)


    -- 图鉴容器
    self.items_root = self.bg_root:AddChild(Widget('items_root'))
    self.items_root:SetPosition(200,0,0)
    -- 图鉴容器背景
    self.items_bg = self.items_root:AddChild(gen_image_quagmire_recipebook('quagmire_recipe_menu_block.tex'))
    self.items_bg:SetScale(.8,.7,1)
    -- 图像头像背景图
    self.items_avatar_slot_bg = self.items_root:AddChild(Image('images/lol_wp_pedia/slot_with_outline.xml','slot_with_outline.tex'))
    self.items_avatar_slot_bg:SetPosition(-100,180)
    self.items_avatar_slot_bg:Hide()
    -- 图鉴头像
    self.items_avatar = self.items_avatar_slot_bg:AddChild(Image())
    -- 图鉴头像附近信息显示
    -- name
    self.items_avatar_around_info_name = self.items_root:AddChild(Text(UIFONT,35,''))
    self.items_avatar_around_info_name:SetVAlign(ANCHOR_MIDDLE)
    self.items_avatar_around_info_name:SetHAlign(ANCHOR_LEFT)
    self.items_avatar_around_info_name:SetPosition(50,180+28)
    self.items_avatar_around_info_name:SetRegionSize(170,35)
    -- 检视台词
    self.items_avatar_around_info_inspect = self.items_root:AddChild(lol_wp_pedia_item_txt(BODYTEXTFONT,20,''))
    self.items_avatar_around_info_inspect:SetVAlign(ANCHOR_TOP)
    self.items_avatar_around_info_inspect:SetHAlign(ANCHOR_LEFT)
    self.items_avatar_around_info_inspect:SetPosition(50,180-40)
    self.items_avatar_around_info_inspect:SetRegionSize(170,100)

    -- 图鉴信息显示  方案二(大杂烩):

    local area_root =   self.items_root:AddChild(Widget("area_root")) -- TrueScrollArea root
    local sub_root = self.items_root:AddChild(Widget("text_root")) -- 子 root
    local width = 280 -- 实际 宽
    local height = 2000 -- 实际 高
    local max_visible_height = 330 -- 可视区域高
    local padding = 0 -- keep 0
    local height_per_scroll = 23 * 1 -- 每次滚动高度

    self.items_txt_width = width-20 -- 文本widget RegionSize 宽
    local items_txt_height = 2000 -- 文本widget RegionSize 高
    local items_txt_fontsize = 25 -- 文本字体大小
    self.items_txt = sub_root:AddChild(lol_wp_pedia_item_txt(BODYTEXTFONT,items_txt_fontsize,''))
    self.items_txt:SetHAlign(ANCHOR_LEFT)
    self.items_txt:SetVAlign(ANCHOR_TOP)
    self.items_txt:SetRegionSize(self.items_txt_width,items_txt_height) -- 设置文本区域大小

    local top = math.min(height, max_visible_height)/2 - padding

    self.scissor_data = {x = 0, y = -max_visible_height/2, width = width, height = max_visible_height}
    local context = {widget = sub_root, offset = {x = width/2, y = top-items_txt_height/2}, size = {w = width, height = height + padding} }
    local scrollbar = { scroll_per_click = height_per_scroll }

    self.scroll_area = area_root:AddChild(TrueScrollArea(context, self.scissor_data, scrollbar))
    self.scroll_area:SetPosition(-150,-50)
    self.scroll_area:Hide()
end)

---滚动框切换组别
---@param index integer
function lol_wp_pedia:ScrollSwitchGroup(index)
    -- self.scroll_list:SetList((self.scroll_page_member[groups_order[index]]))
    ---@diagnostic disable-next-line: param-type-mismatch
    self.scroll_list:SetList(nil,nil,nil,nil,index)
    self.scroll_list:Scroll(0,true)
end

---切换图鉴项目
---@param id string
---@param xml string
---@param tex string
function lol_wp_pedia:SwitchItem(id,xml,tex)
    -- 显示图鉴头像
    if not self.items_avatar_slot_bg.shown then
        self.items_avatar_slot_bg:Show()
    end
    -- 显示图鉴信息滚动区域
    if not self.scroll_area.shown then
        self.scroll_area:Show()
    end
    -- 更新图鉴头像
    self.items_avatar:SetTexture(xml,tex)
    -- 更新图鉴内容滚动框
    local fixed_content = LOLWP_S:limitMultiLineStringSingleLineMaxLen(pedia_items[id].info_instead or '',16)
    local num_lines = self.items_txt:SetMultilineTruncatedString(fixed_content,100, self.items_txt_width,nil,nil,false,16,'\n')
    if num_lines then
        local real_height = num_lines * 25
        self.scroll_area.scroll_pos_end = math.max(0,real_height - 330)
    end
    self.scroll_area:ResetScroll()


    -- 更新图鉴附近信息: 名字
    self.items_avatar_around_info_name:SetString(pedia_items[id].name)
    local items_avatar_around_info_name_rgba = pedia_items[id].name_rgba
    if items_avatar_around_info_name_rgba then -- 如果有颜色
        self.items_avatar_around_info_name:SetColour(unpack(items_avatar_around_info_name_rgba))
    else
        self.items_avatar_around_info_name:SetColour(1,1,1,1)
    end
    -- 更新图鉴附近信息: inspect
    local inspect_info = STRINGS.CHARACTERS.GENERIC.DESCRIBE[string.upper(id)] or ''
    inspect_info = LOLWP_S:limitMultiLineStringSingleLineMaxLen(inspect_info,14)
    self.items_avatar_around_info_inspect:SetMultilineTruncatedString(inspect_info,100, 170,nil,nil,false,16,'\n')
    
end

return lol_wp_pedia