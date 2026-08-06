SMODS.Shader{
  key = "ui_image",
  path = "core/ui_image.fs",
  send_vars = function(element, extra)
    local atlas = SMODS.Atlases[element.config.atlas]
    local pixel_size = element.config.pixel_size
    local pos = element.config.pos and {element.config.pos.x, element.config.pos.y} or {0, 0}
    if pixel_size then
        pos[1] = pos[1] * (atlas.px / pixel_size.w)
        pos[2] = pos[2] * (atlas.py / pixel_size.h)
    end
    return {
      mask = atlas.image,
      atlas_dim = {(pixel_size and pixel_size.w or atlas.px)/atlas.image:getWidth(), (pixel_size and pixel_size.h or atlas.py)/atlas.image:getHeight()},
      atlas_pos = pos
    }
  end
}

SMODS.Font({
	key = "collection",
    path = "collection_5.ttf",
    FONTSCALE = 0.09,
    squish = 0.75,
    TEXT_HEIGHT_SCALE = 0.75,
    TEXT_OFFSET = {x = 0, y = -50}
})

SMODS.Atlas({
    key = 'book',
    path = 'core/compendium_cover.png',
    px = 143,
    py = 200
})

SMODS.Atlas({
    key = 'bookmark',
    path = 'core/compendium_bookmark.png',
    px = 39, py = 29
})

SMODS.Atlas({
    key = 'icons',
    path = 'core/compendium_icons.png',
    px = 24, py = 24
})

SMODS.Atlas({
    key = 'open_page',
    path = 'core/compendium_contents.png',
    px = 277, py = 200
})

SMODS.Atlas({
    key = 'comp_locations',
    path = 'core/compendium_locations.png',
    px = 293, py = 174
})

SMODS.Atlas({
    key = 'arrows',
    path = 'core/arrows.png',
    px = 40, py = 32
})

SMODS.Atlas({
    key = 'achievements',
    path = 'core/achievements.png',
    px = 66, py = 66
})

FishAndChips.Compendium = {}

local function wrapText(text, maxChars)
    local wrappedText = {""}
    local curr_line = 1
    local currentLineLength = 0

    for word in text:gmatch("%S+") do
        if currentLineLength + #word <= maxChars then
            wrappedText[curr_line] = wrappedText[curr_line] .. word .. ' '
            currentLineLength = currentLineLength + #word + 1
        else
            wrappedText[curr_line] = string.sub(wrappedText[curr_line], 0, -2)
            curr_line = curr_line + 1
            wrappedText[curr_line] = ""
            wrappedText[curr_line] = wrappedText[curr_line] .. word .. ' '
            currentLineLength = #word + 1
        end
    end

    wrappedText[curr_line] = string.sub(wrappedText[curr_line], 0, -2)
    return wrappedText
end

G.FUNCS.compendium_nav_button = function(e)
    play_sound("fac_flip_page")
    local back_func = G.OVERLAY_MENU:get_UIE_by_ID("overlay_menu_back_button").config.button
    SMODS.save_mod_config(FishAndChips.mod)
    if e.config.type == 'condensed_fish_page' or e.config.type == 'extended_fish_page' then
        e.config.type = FishAndChips.mod.config.condensed_fish and 'condensed_fish_page' or 'extended_fish_page'
    end
    G.OVERLAY_MENU:remove()

    G.OVERLAY_MENU = UIBox{
        definition = FishAndChips.Compendium.page({type = e.config.type, left = e.config.change or 1, right = (e.config.change or 1) + 1}),
        config =  {align = "cm", offset = {x=0,y=0}, major = G.ROOM_ATTACH, bond = 'Weak'}
    }
    G.OVERLAY_MENU:get_UIE_by_ID("overlay_menu_back_button").config.button = back_func
end

G.FUNCS.fac_return_to_mods = function(e)
    play_sound("fac_book_close")
    G.FUNCS.mods_button(e)
end

G.FUNCS.fac_reset_all_progress = function(e)
    if e.config.colour == G.C.RED then
        e.config.colour = FishAndChips.C.COMPENDIUM_COLOUR
        FishAndChips.Compendium.reset_warning = localize('ph_fac_reset_all')
        G.PROFILES[G.SETTINGS.profile].fac_fishing = {
            career_fish_caught = 0,
            career_perfect_catch = 0,
            career_treasure_caught = 0,
            career_lines_snapped = 0,
            career_sand_dollars = 0,
            career_fish_sold = 0,
            environments_fished = {},
            baits_used = {},
            fish_data = {},
            rod_data = {},
            bait_data = {},
        }
        for _, type in ipairs({'fac_Fish', 'fac_Rod', 'fac_Bait'}) do
            for _, obj in ipairs(G.P_CENTER_POOLS[type]) do
                obj.discovered = false
                obj.unlocked = type ~= 'fac_Rod'
                G.P_CENTERS[obj.key].discovered = false
                G.P_CENTERS[obj.key].unlocked = type ~= 'fac_Rod'
            end
        end
        G.P_CENTER_POOLS.fac_Rod[1].discovered = true
        G.P_CENTER_POOLS.fac_Rod[1].unlocked = true
        G.P_CENTERS[G.P_CENTER_POOLS.fac_Rod[1].key].discovered = true
        G.P_CENTERS[G.P_CENTER_POOLS.fac_Rod[1].key].unlocked = true
        G.P_CENTER_POOLS.fac_Bait[1].discovered = true
        G.P_CENTERS[G.P_CENTER_POOLS.fac_Bait[1].key].discovered = true

        for _, ach in ipairs(FishAndChips.Compendium.get_achievements()) do
            ach.earned = false
            G.SETTINGS.ACHIEVEMENTS_EARNED[ach.key] = nil
        end

        G.PROFILES[G.SETTINGS.profile].fac_tutorial_seen = nil

        G:save_progress()
        remove_save()
        love.filesystem.remove(G.SETTINGS.profile..'/'..'meta.jkr')
        convert_save_to_meta()
        G.SAVE_MANAGER.channel:push({
            type = 'save_progress',
            save_progress = G.ARGS.save_progress
        })
        G.FILE_HANDLER.progress = true
        G.FILE_HANDLER.force = true
        return
    end
    e.config.colour = G.C.RED
    FishAndChips.Compendium.reset_warning = localize('ph_fac_are_you_sure')
    return
end

function G.FUNCS.fac_can_reset_progress(e)
	if G.STAGE ~= G.STAGES.RUN then
		e.config.button = 'fac_reset_all_progress'
		e.config.hover = true
	else
		e.config.button = nil
		e.config.hover = nil
	end
end

local uiehover = UIElement.hover
function UIElement:hover() 
    if self.config and self.config.fac_tooltip then
        self.config.h_popup = FishAndChips.Compendium.tooltip(self.config.fac_tooltip)
        self.config.h_popup_config = {align="cr", offset = {x=0.2,y=0}, parent = self}
    end
    uiehover(self)
end

function FishAndChips.Compendium.tooltip(tooltip)
    local t = {n=G.UIT.ROOT, config = {align = "cm", colour = HEX('764634'), r=0.05, padding = 0.05}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.05, colour = adjust_alpha(G.C.WHITE, 0.8)}, nodes={
            -- text goes here
        }}
    }}

    for i = 1, #tooltip.text do
        local r = {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.T, config={text = localize('ph_fac_'..tooltip.text[i]), colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection, scale = 0.5}}
        }}
        table.insert(t.nodes[1].nodes, r)
    end

    return t
end

function FishAndChips.Compendium.bookmark(destination, colour, icon_pos)
    return {n=G.UIT.R, nodes = {
        {n = G.UIT.R, config = {minh = 0.18}},
        {n = G.UIT.R, config = {shader = 'fac_ui_image', atlas = 'fac_bookmark', hover = true, fac_tooltip = {text = {destination}}, button = 'compendium_nav_button', type = destination, button_dist = 0,
          change = 1, minw = 1, minh = 0.75, colour = colour or G.C.GREEN, align = 'cm'}, nodes = {
            {n=G.UIT.O, config = {object = SMODS.create_sprite(0,0,0.45,0.45,'fac_icons', icon_pos or {x=0,y=0})}}
        }},
    }}
end

function FishAndChips.Compendium.all_bookmarks()
    return {n=G.UIT.C, nodes = {
        {n=G.UIT.R, config = {minh = 0.5}},
        FishAndChips.Compendium.bookmark(FishAndChips.mod.config.condensed_fish and 'condensed_fish_page' or 'extended_fish_page', FishAndChips.mod.badge_colour),
        FishAndChips.Compendium.bookmark('rod_page', G.C.RED, {x=1, y=0}),
        FishAndChips.Compendium.bookmark('bait_page', G.C.BLUE, {x=2, y=0}),
        FishAndChips.Compendium.bookmark('environment_page', G.C.GREEN, {x=3, y=0}),
        FishAndChips.Compendium.bookmark('achievement_page', G.C.GOLD, {x=4, y=0}),
        FishAndChips.Compendium.bookmark('credits_page', G.C.PURPLE, {x=5, y=0}),
        FishAndChips.Compendium.bookmark('config_page', G.C.L_BLACK, {x=6, y=0}),
    }}
end

function FishAndChips.Compendium.nav_button(page_number, left, type, padding)
    return {n=G.UIT.R, config = {align = left and 'cl' or 'cr', minw = 5.2,}, nodes = {
        {n=G.UIT.R, config = {minw = 1, minh = padding or 0.5}},
        {n=G.UIT.R, config = {minw = 1, minh = 0.8, r = 0.1, change = left and page_number-2 or page_number+1, hover = true, button_dist = 0,
            type = type, button = 'compendium_nav_button', colour = adjust_alpha(lighten(HEX('764634'), 0.6), 0.4), shader = 'fac_ui_image', atlas = 'fac_arrows', pos = {x = left and 0 or 1, y = 0}}}
    }}
end

function FishAndChips.Compendium.back_button()
    return {n=G.UIT.R, config={align='cm'}, nodes={
        {n=G.UIT.R, config = {colour = G.C.ORANGE, minw = 2, minh = 1, outline = 1, r=0.1, id='overlay_menu_back_button', align = 'cm', padding = 0.1, hover=true, button ='fac_return_to_mods'}, nodes = {
            {n=G.UIT.T, config = {text = localize('b_fac_back_button'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT}}
        }}
    }}
end

function FishAndChips.Compendium.cover()
    return {n=G.UIT.ROOT, config = {align = "cm", minw = G.ROOM.T.w*5, minh = G.ROOM.T.h*5,padding = 0.1, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
        {n=G.UIT.R, config = {padding = -0.14}, nodes = {
            {n=G.UIT.C, config={minw = 1}},
            {n = G.UIT.C, config = {shader = 'fac_ui_image', atlas = 'fac_book', colour = G.C.WHITE, minw = 2.85*2.5, minh = 10, align = 'tm'}, nodes = {}},
            FishAndChips.Compendium.all_bookmarks()
        }},
        {n=G.UIT.R, config = {minh = 0.5}},
        FishAndChips.Compendium.back_button()
    }}
end

function FishAndChips.Compendium.page_title(key, page_number)
    return {n = G.UIT.R, config = {align = 'cm', minw = 5.2, padding = 0.1}, nodes = page_number == 1 and {
        {n=G.UIT.R, config = {padding = -0.1, underline = FishAndChips.C.COMPENDIUM_COLOUR, underline_scale = 0.04}, nodes = {
            {n=G.UIT.T, config = {text = localize('ph_fac_'..key), font = SMODS.Fonts.fac_collection, colour = FishAndChips.C.COMPENDIUM_TEXT, scale = 0.8}}
        }},
    } or {}}
end

function FishAndChips.Compendium.page(page)
    return {n=G.UIT.ROOT, config = {align = "cm", minw = G.ROOM.T.w*5, minh = G.ROOM.T.h*5,padding = 0.1, r = 0.1, colour = {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0.7}}, nodes={
        {n=G.UIT.R, config = {minh = 0.6}},
        {n=G.UIT.R, config = {padding = -0.85}, nodes = {
            {n=G.UIT.C, config={minw = 1}},
            {n = G.UIT.C, config = {shader = 'fac_ui_image', atlas = 'fac_open_page', colour = G.C.WHITE, minw = 5.56*2.5, minh = 10, align = 'tl'}, nodes = {
                {n=G.UIT.R, config = {minh = 0.2}}, -- spacer
                {n=G.UIT.R, config = {align = 'tl', minh = 9.3}, nodes = {
                    {n=G.UIT.C, config = {minw = 1.2, minh = 9.3}}, -- spacer
                    FishAndChips.Compendium[page.type](page.left, true),
                    {n=G.UIT.C, config = {minw = 0.7, minh = 9.3}}, -- spacer
                    FishAndChips.Compendium[page.type](page.right),
                }}
            }},
            FishAndChips.Compendium.all_bookmarks()
        }},
        {n=G.UIT.R, config = {minh = 0.9}},
        FishAndChips.Compendium.back_button()
    }}
end

-- Hook to stop tilt on compendium fish
local ds = Sprite.draw_shader
function Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    if self.role.major and self.role.major.area and self.role.major.area.config.fac_compendium then _no_tilt = true end
    ds(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
end

function FishAndChips.Compendium.compendium_area(amount, dim)
    amount = amount or 1
    dim = dim or {(8*amount)/4 * 71/95, 2}
    local adjust = amount > 1 and 2*G.CARD_W/G.CARD_H
    print(adjust)
    local area = CardArea(0, 0, dim[1], dim[2], {type = 'voucher', fac_compendium = true})
    area.align_cards = function(self)
        for k, card in ipairs(self.cards) do
            card.states.drag.can = false
            if not card.states.drag.is then
                card.T.x = self.T.x + 0.5*(self.T.w - (adjust or card.T.w)) + (amount > 1 and ((k-2) * ((adjust and (card.T.w + adjust)/2 or card.T.w)) * 1.2) or 0)
                card.T.y = self.T.y + 0.5*(self.T.h - card.T.h)
            end
        end
    end
    return area
end

function FishAndChips.Compendium.compendium_card(fish, area, scale)
    scale = scale or 2/G.CARD_H
    local compendium_card = SMODS.create_card({key = fish.key, area = area, scale = {w=scale, h=scale}})
    if compendium_card.T.w > scale * G.CARD_W or compendium_card.T.h > scale * G.CARD_H then
        local adjust = math.min(scale*G.CARD_W/compendium_card.T.w, scale*G.CARD_H/compendium_card.T.h)
        compendium_card.T.h = compendium_card.T.h * adjust
        compendium_card.T.w = compendium_card.T.w * adjust
    end
    compendium_card.no_shadow = true
    local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[fish.key] or {}
    local should_silhouette = fish.set == 'fac_Fish' and not (fish_data.times_caught and fish_data.times_caught > 0) or (fish.set == 'fac_Rod' or fish.set == 'fac_Bait') and not fish.discovered
    if should_silhouette then compendium_card.ignore_base_shader = {compendium = true} end 
    compendium_card.hover = function(self) 
        self.ability_UIBox_table = self:generate_UIBox_ability_table()
        self.config.h_popup = G.UIDEF.card_h_popup(self)
        self.config.h_popup_config = self:align_h_popup()
        play_sound('paper1', math.random() * 0.2 + 0.9, 0.35)

        Node.hover(self)
    end
    return compendium_card
end

function FishAndChips.Compendium.extended_fish_entry(fish, left)
    if not fish then
        return nil
    end

    local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[fish.key] or {
        first_catch = '',
        rod = '',
        times_caught = '',
        record_weight = '',
        record_length = ''
    }

    local fish_caught = type(fish_data.times_caught) == 'number' and (fish_data.times_caught > 0)

    local fish_name = fish_caught and localize({type = 'name_text', key = fish.key, set = 'fac_Fish'}) or localize('ph_fac_unknown_item')
    if string.len(fish_name) > 25 then fish_name = string.sub(fish_name, 1, 21) .. '...' end
    local caught = localize('ph_fac_first_caught')..(fish_caught and fish_data.first_catch or '')
    local rod = fish_caught and localize('ph_fac_with_rod')..localize({key = fish_data.rod, set = 'fac_Rod', type = 'name_text'}) or ' '
    local count = localize('ph_fac_times_caught')..(fish_caught and fish_data.times_caught or '')
    local record_weight = fish_caught and localize('ph_fac_record_weight')..FishAndChips.format_measurement(fish_data.record_weight or nil, 'weight', fish.stats.units) or ' '
    local record_length = fish_caught and localize('ph_fac_record_length')..FishAndChips.format_measurement(fish_data.record_length or nil, 'length', fish.stats.units) or ' '

    local text = {n=G.UIT.R, config = {align = left and 'cl' or 'cr', padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = 'cl', padding = 0.03, minw = 3.2}, nodes = {
            {n=G.UIT.R, nodes = {
                {n=G.UIT.R, config = {underline = FishAndChips.C.COMPENDIUM_COLOUR, underline_scale = 0.04, padding = -0.08}, nodes = {
                    {n=G.UIT.T, config = {text = fish_name, scale = 0.5, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}
                }}    
            }},
            {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = caught, scale = 0.4, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}}},
            {n=G.UIT.R, config = {align = 'cr', minw = 3}, nodes = {{n=G.UIT.T, config = {text = rod, scale = 0.4, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}}},
            {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = count, scale = 0.4, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}}},
            {n=G.UIT.R, nodes = {{n=G.UIT.O, config={object = DynaText({string = record_weight, colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.3, silent = true})}}}},
            {n=G.UIT.R, nodes = {{n=G.UIT.O, config={object = DynaText({string = record_length, colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.3, silent = true})}}}},
        }}
    }}
    
    local temp_area = FishAndChips.Compendium.compendium_area(nil, {2.25 * 71/95, 2.25})
    local compendium_card = FishAndChips.Compendium.compendium_card(fish, temp_area, 0.85)
    temp_area:emplace(compendium_card)
    table.insert(text.nodes, left and 1 or 2, {n=G.UIT.C, config = {align = 'cm'}, nodes = {{n=G.UIT.O, config={object=temp_area}}}})
    
    return text
end

function FishAndChips.Compendium.extended_fish_page(page_number, left)
    local fish_per_page = 3
    local start_index = (page_number-1)*fish_per_page
    local pool = SMODS.collection_pool(G.P_CENTER_POOLS.fac_Fish)

    local page = {n=G.UIT.C, config = {minh = 9.3, align = 'tm', minw = 5.4, padding = 0.1}, nodes = {
        FishAndChips.Compendium.page_title('extended_fish_page', page_number),
        {n=G.UIT.R, config = {align = 'tm', minh = 8, id = 'fac_compendium_extended_fish_page'}, nodes = {
            -- fish added here
        }}
    }}

    local last_page = start_index >= #pool
    for i = 1, fish_per_page do
        table.insert(page.nodes[2].nodes, FishAndChips.Compendium.extended_fish_entry(pool[start_index + i], i%2 == 1))
        if start_index + i >= #pool then last_page = true; break end
    end

    if page_number > 1 and (not last_page or left) then
        table.insert(page.nodes, FishAndChips.Compendium.nav_button(page_number, left, 'extended_fish_page', 0.1))
    end

    return page
end

function FishAndChips.Compendium.condensed_fish_page(page_number, left)
    local fish_per_page = 12
    local start_index = (page_number-1)*fish_per_page
    local pool = SMODS.collection_pool(G.P_CENTER_POOLS.fac_Fish)
    local rows = 4
    local fish_per_row = fish_per_page/rows

    local page = {n=G.UIT.C, config = {minw = 5.4, minh = 9.3, align = 'cm'}, nodes = {
        FishAndChips.Compendium.page_title('condensed_fish_page', page_number),
        {n=G.UIT.R, config = {align = 'tm', padding = -0.1}, nodes = {
        }}
    }}

    local last_page = start_index >= #pool
    for i=1, rows do
        local temp_area = FishAndChips.Compendium.compendium_area(fish_per_row)

        for j=1, fish_per_row do
            if last_page then break end
            local index = start_index + j + ((i-1) * fish_per_row)
            local compendium_card = FishAndChips.Compendium.compendium_card(pool[index], temp_area)
            temp_area:emplace(compendium_card)
            if index >= #pool then last_page = true; break end
        end
        table.insert(page.nodes[2].nodes, {n=G.UIT.R, config = {align = i%2 == 1 and 'cl' or 'cr', minw = 5, padding = 0.1}, nodes = {
            {n=G.UIT.O, config={object=temp_area}}    
        }})
    end

    if page_number > 1 and (not last_page or left) then
        table.insert(page.nodes, FishAndChips.Compendium.nav_button(page_number, left, 'condensed_fish_page'))
    end

    return page
end

G.FUNCS.open_compendium_to_env = function(e)
    play_sound("fac_flip_page")

    local page_to_turn = FishAndChips.Environments[G.GAME.fac_fishing_environment].order
    page_to_turn = page_to_turn%2 == 0 and page_to_turn - 1 or page_to_turn
    G.OVERLAY_MENU = UIBox{
        definition = FishAndChips.Compendium.page({type = 'environment_page', left = page_to_turn, right = page_to_turn + 1}),
        config =  {align = "cm", offset = {x=0,y=0}, major = G.ROOM_ATTACH, bond = 'Weak'}
    }
    G.OVERLAY_MENU:get_UIE_by_ID("overlay_menu_back_button").config.button = 'exit_overlay_menu'
end

function FishAndChips.Compendium.environment_page(page_number, left)
    local environment_key = FishAndChips.Environment.obj_buffer[page_number]
    local environment = FishAndChips.Environments[environment_key]

    -- TODO: Fix artist
    local page = {n=G.UIT.C, config = {minw = 5.4, minh = 9.3, align = 'tm', padding = 0.1}, nodes = {
        FishAndChips.Compendium.page_title('environment_page', page_number),
        {n=G.UIT.R, config = {align = 'tm', padding = 0}, nodes = {
            {n=G.UIT.R, config = {align = 'tm', colour = G.C.WHITE, minw = 4.2}, nodes = {
                {n = G.UIT.R, config = {shader = 'fac_ui_image', atlas = 'fac_comp_locations', pos = environment.background_pos, colour = G.C.WHITE, minw = 293/73.25, minh = 174/73.25, align = 'tl'}, nodes = {}},
                {n=G.UIT.R, config = {minh = 1, colour = G.C.WHITE, align = 'br', padding = 0.1}, nodes = {
                    {n=G.UIT.R, config = {align = 'cr'}, nodes = {
                        {n=G.UIT.T, config = {text = localize({key = environment_key, set = 'fac_Env', type = 'name_text'}), scale = 0.5, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}
                    }},
                    {n=G.UIT.R, config = {align = 'tr'}, nodes = {
                        {n=G.UIT.T, config = {text = localize('ph_fac_by')..environment.ppu_artist[1], scale = 0.35, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}
                    }},
                }}
            }},
        }},
        {n=G.UIT.R, config = {align = 'tm', minh = 3, minw = 4.8}, nodes = {
            {n=G.UIT.R, config = {align = 'tl', minh = 4.5, minw = 4.8}, nodes = {

            }}
        }}
    }}

    local fish_pool = {}
    for _, k in ipairs(SMODS.get_attribute_pool(environment_key)) do
        if not SMODS.hide_from_collection(G.P_CENTERS[k]) then
            table.insert(fish_pool, G.P_CENTERS[k])
        end
    end

    local rows = 7
    local fish_per_row = 9

    local last_page = false
    for i=1, rows do
        local row = {n=G.UIT.R, config = {align = 'cl', padding = 0.05}, nodes = {}}
        for j = 1, fish_per_row do
            if last_page then break end
            local index = j + ((i-1)*fish_per_row)
            local fish = fish_pool[index]
            local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[fish.key] or {}
            local fish_caught = fish_data.times_caught and fish_data.times_caught > 0
            local atlas = SMODS.get_atlas(fish.atlas)
            
            table.insert(row.nodes, {n=G.UIT.C, config = {align = 'cm'}, nodes = {{n=G.UIT.R, config = {align = 'cm', shader = 'fac_ui_image', atlas = fish.atlas, pos = fish.pos, pixel_size = fish.pixel_size, colour = fish_caught and G.C.WHITE or FishAndChips.C.COMPENDIUM_COLOUR, minh = 0.45 * (fish.pixel_size and fish.pixel_size.h/fish.pixel_size.w or atlas.py/atlas.px), minw = 0.45}}}})
            if index >= #fish_pool then last_page = true end
        end
        table.insert(page.nodes[3].nodes[1].nodes, row)
        if final then break end
    end

    if page_number > 1 and page_number < #FishAndChips.Environment.obj_buffer then
        table.insert(page.nodes, FishAndChips.Compendium.nav_button(page_number, left, 'environment_page', 0.05))
    end

    return page
end

function FishAndChips.Compendium.toggle(args)
    args = args or {}
    args.active_colour = FishAndChips.C.COMPENDIUM_COLOUR
    args.inactive_colour = G.C.CLEAR
    args.scale = 0.8
    args.ref_table = args.ref_table or FishAndChips.mod.config

    local check = Sprite(0,0,0.5*args.scale,0.5*args.scale,G.ASSET_ATLAS["icons"], {x=1, y=0})
    check.states.drag.can = false
    check.states.visible = false
    return {n=G.UIT.R, config = { align = "cl"}, nodes = {
        {n=G.UIT.C, config = { align = "cl", minw = 4.2}, nodes = {
            {n=G.UIT.T, config = { text = localize(args.text_key), scale = 0.4, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}},
        }},
        {n=G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
            {n=G.UIT.C, config={align = "cm", padding = 0.1, r = 0.1, colour = G.C.CLEAR, focus_args = {funnel_from = true}}, nodes={
                {n=G.UIT.C, config={align = "cl", }, nodes={
                    {n=G.UIT.C, config={align = "cm", r = 0.1}, nodes={
                        {n=G.UIT.C, config={align = "cm", r = 0.1, padding = 0.03, minw = 0.4*args.scale, minh = 0.4*args.scale, outline_colour = FishAndChips.C.COMPENDIUM_TEXT, outline = 1.2*args.scale, ref_table = args,
                          colour = args.inactive_colour, button = 'toggle_button', button_dist = 0.2, hover = true, toggle_callback = args.callback, func = 'toggle', focus_args = {funnel_to = true}}, nodes={
                            {n=G.UIT.O, config={object = check}},
                        }},
                    }}
                }},
            }}
        }},
    }}
end

function FishAndChips.Compendium.bait_entry(bait, left)
    if not bait then return end
    local rod_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.bait_data[bait.key] or {
        fish_caught = 0,
		fish_lost = 0,
		perfect_catch = 0,
		treasure = 0
    }

    local bait_name, caught = {localize('ph_fac_unknown_item'), ''}, ' '

    if bait.discovered then
        bait_name = {}
        for i in string.gmatch(localize({type = 'name_text', key = bait.key, set = 'fac_Bait'}), "%S+") do
            bait_name[#bait_name+1] = i
        end
        caught = localize('ph_fac_caught')..rod_data.fish_caught
    end
    

    local text = {n=G.UIT.C, config = {align = 'bm', padding = 0.04, minw = 1.6}, nodes = {
        {n=G.UIT.R, config = {align = 'cm'}, nodes = {
            {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                {n=G.UIT.R, config = {underline = FishAndChips.C.COMPENDIUM_COLOUR, underline_scale = 0.05, padding = -0.08, align = 'cm'}, nodes = {
                    {n=G.UIT.O, config={object = DynaText({string = bait_name[1], colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 1.4, pop_in_rate = 0, scale = 0.4, silent = true})}},
                }},
            }},
            {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                {n=G.UIT.R, config = {underline = FishAndChips.C.COMPENDIUM_COLOUR, underline_scale = 0.05, padding = -0.08, align = 'cm'}, nodes = {
                    {n=G.UIT.O, config={object = DynaText({string = bait_name[2] or '', colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 1.4, pop_in_rate = 0, scale = 0.4, silent = true})}},
                }}  
            }}, 
        }},
        {n=G.UIT.R, config = {align = 'cm',}, nodes = {
            {n=G.UIT.O, config={object = DynaText({string = caught, colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 1.4, pop_in_rate = 0, scale = 0.3, silent = true})}},
        }}
    }}
    
    local temp_area = FishAndChips.Compendium.compendium_area(1, {1.5 * 71/95, 1.5})
    local bait_card = FishAndChips.Compendium.compendium_card(bait, temp_area, 1.5/G.CARD_H)
    temp_area:emplace(bait_card)
    table.insert(text.nodes, 2, {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.O, config={object=temp_area}}}})
    
    return text
end

function FishAndChips.Compendium.bait_page(page_number, left)
   
    local page = {n=G.UIT.C, config = {minw = 5.2, minh = 9.3, align = 'tm', padding = 0.1}, nodes = {
        FishAndChips.Compendium.page_title('bait_page', page_number),
    }}

    local bait_per_page = 9
    local rows = 3
    local bait_per_row = bait_per_page/rows
    local start_index = (page_number - 1) * bait_per_page

    local last_page = start_index >= #G.P_CENTER_POOLS.fac_Bait
    for i=1, rows do
        local row = {n=G.UIT.R, config = {align = 'tm', minh = 7.8/3, minw = 5, padding = 0.1}, nodes = {}}
        for j=1, bait_per_row do
            if last_page then break end
            local index = start_index + (i-1)*bait_per_row + j
            table.insert(row.nodes, FishAndChips.Compendium.bait_entry(G.P_CENTER_POOLS.fac_Bait[index]))
            if index >= #G.P_CENTER_POOLS.fac_Bait then last_page = true; break end
        end
        table.insert(page.nodes, row)
        if last_page then break end
    end

    if page_number > 1 and (not last_page or left) then
        table.insert(page.nodes, FishAndChips.Compendium.nav_button(page_number, left, 'bait_page'))
    end

    return page
end

function FishAndChips.Compendium.rod_entry(rod, left)
    local rod_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.rod_data[rod.key] or {
        treasure = 0,
        fish_caught = 0,
        fish_lost = 0,
        perfect_catch = 0
    }

    local rod_name, caught, lost, rate, treasure, perfect = localize('ph_fac_unknown_item'), '', '', '', '', ''

    if rod.discovered then
        rod_name = localize({type = 'name_text', key = rod.key, set = 'fac_Rod'})
        caught = localize('ph_fac_caught')..rod_data.fish_caught
        lost = localize('ph_fac_lost')..rod_data.fish_lost
        rate = math.max(rod_data.fish_caught, rod_data.fish_lost) > 0 and localize('ph_fac_rate')..string.format("%.2f%%", rod_data.fish_caught/(rod_data.fish_caught + rod_data.fish_lost)*100) or ' '
        treasure = localize('ph_fac_treasure')..rod_data.treasure
        perfect = localize('ph_fac_perfect')..rod_data.perfect_catch
    end
    

    local text = {n=G.UIT.R, config = {align = left and 'cl' or 'cr', padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = 'cl', padding = 0.04, minw = 3.4}, nodes = {
            {n=G.UIT.R, nodes = {
                {n=G.UIT.R, config = {underline = FishAndChips.C.COMPENDIUM_COLOUR, underline_scale = 0.04, padding = -0.08}, nodes = {
                    {n=G.UIT.T, config = {text = rod_name, scale = 0.5, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}
                }}    
            }},
            {n=G.UIT.R, config = {align = 'cl',}, nodes = {
                {n=G.UIT.O, config={object = DynaText({string = caught .. '  ' .. lost, colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.4, silent = true})}},
            }},
            {n=G.UIT.R, config = {align = 'cr', minw = 2.4, padding = -0.08}, nodes = {
                {n=G.UIT.T, config = {text = rate, scale = 0.25, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}},
                {n=G.UIT.R, config = {minw = 0.4}}
            }},
            {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = perfect, scale = 0.35, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}}},
            {n=G.UIT.R, nodes = {{n=G.UIT.T, config = {text = treasure, scale = 0.35, colour = FishAndChips.C.COMPENDIUM_TEXT, font = SMODS.Fonts.fac_collection}}}},
        }}
    }}
    
    local temp_area = FishAndChips.Compendium.compendium_area()
    local rod_card = FishAndChips.Compendium.compendium_card(rod, temp_area)
    temp_area:emplace(rod_card)
    table.insert(text.nodes, left and 1 or 2, {n=G.UIT.C, nodes = {{n=G.UIT.O, config={object=temp_area}}}})
    
    return text
end

function FishAndChips.Compendium.rod_page(page_number, left)  
    local page = {n=G.UIT.C, config = {minw = 5.2, minh = 9.3, align = 'tm', padding = 0.1}, nodes = {
        FishAndChips.Compendium.page_title('rod_page', page_number),
        {n=G.UIT.R, config = {align = 'tm', minh = 3, minw = 5, padding = -0.1}, nodes = {
            -- rods here
        }}
    }}

    local rods_per_page = 4
    local start_index = (page_number - 1) * rods_per_page
    local last_page = start_index >= #G.P_CENTER_POOLS.fac_Rod
    for i=1, rods_per_page do
        table.insert(page.nodes[2].nodes, FishAndChips.Compendium.rod_entry(G.P_CENTER_POOLS.fac_Rod[i + start_index], i%2 == 1))
        if i + start_index >= #G.P_CENTER_POOLS.fac_Rod then last_page = true; break end
    end

    if page_number > 1 and (not last_page or left) then
        table.insert(page.nodes, FishAndChips.Compendium.nav_button(page_number, left, 'rod_page', 0.2))
    end

    return page
end

function FishAndChips.Compendium.achievement(achievement, left)
    if not achievement then return nil end

    local text = {n=G.UIT.R, config = {align = left and 'cl' or 'cr', padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {align = 'cl', padding = -0.04, minw = 3.4}, nodes = {
            {n=G.UIT.R, nodes = {
                {n=G.UIT.O, config={object = DynaText({string = localize(achievement.key, 'achievement_names'), colours = {FishAndChips.C.COMPENDIUM_COLOUR}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.5, silent = true})}}
            }},
        }},
    }}

    local desc = wrapText(localize(achievement.key, 'achievement_descriptions'), 24)
    for _, line in ipairs(desc) do
        if _ > 2 then break end
        table.insert(text.nodes[1].nodes, {n=G.UIT.R, config = {align = 'cl'}, nodes = {
            {n=G.UIT.R, config = {strikethrough = achievement.earned and FishAndChips.C.COMPENDIUM_COLOUR, strikethrough_scale = 0.05, padding = -0.03}, nodes = {
                {n=G.UIT.O, config={object = DynaText({string = line, colours = {FishAndChips.C.COMPENDIUM_COLOUR}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.35, silent = true})}}
            }}
        }})
    end

    if not achievement.earned and achievement.display_progress then
        local progress = achievement:display_progress()
        table.insert(text.nodes[1].nodes, {n=G.UIT.R, config = {align = 'cr', minw = 3.2}, nodes = {
            {n=G.UIT.O, config={object = DynaText({string = progress, colours = {FishAndChips.C.COMPENDIUM_COLOUR}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.35, silent = true})}}
            }})
    end
    
    table.insert(text.nodes, left and 1 or 2, {n = G.UIT.C, config = {align = 'cm'}, nodes = {
        {n=G.UIT.R, config = {shader = 'fac_ui_image', atlas = 'fac_achievements', pos = {x= achievement.earned and 1 or 0, y = 0}, colour = achievement.earned and G.C.WHITE or FishAndChips.C.COMPENDIUM_COLOUR, minw = 1.4, minh = 1.4}}
    }})
    table.insert(text.nodes, 2, {n = G.UIT.C, config = {align = 'cm', min=0.2}, nodes = {}})
    
    return text
end

function FishAndChips.Compendium.get_achievements()
    fetch_achievements()
    local achievements_pool = {}
    local achievement_original_order = {}
    for k, v in pairs(SMODS.Achievement.obj_buffer) do
        local ach = SMODS.Achievements[v]
        if ach then 
            if ach.mod and ach.mod.id == FishAndChips.mod.id then achievements_pool[#achievements_pool+1] = ach end
        end
    end

    local achievement_tab = {}
    for k, v in ipairs(achievements_pool) do
        achievement_original_order[v.key] = #achievement_tab
        achievement_tab[#achievement_tab+1] = v
    end
    table.sort(achievement_tab, function(a, b) if a.order and b.order then return (a.order or 1) < (b.order or 1) else return achievement_original_order[a.key] < achievement_original_order[b.key] end end)
    
    return achievement_tab
end
    
function FishAndChips.Compendium.achievement_page(page_number, left)  
    local page = {n=G.UIT.C, config = {minw = 5.4, minh = 9.3, align = 'tm', padding = 0.1}, nodes = {
        FishAndChips.Compendium.page_title('achievement_page', page_number),
        {n=G.UIT.R, config = {align = 'tm', minh = 8, minw = 4.6}, nodes = {

        }}
    }}

    local achievements_per_page = 5
    local start_index = (page_number - 1) * achievements_per_page
    local achi_pool = FishAndChips.Compendium.get_achievements()

    local last_page = start_index >= #achi_pool
    for i = 1, achievements_per_page do
        table.insert(page.nodes[2].nodes, FishAndChips.Compendium.achievement(achi_pool[start_index + i], i%2 == (left and 0 or 1)))
        if start_index + i >= #achi_pool then last_page = true; break end
    end

    if page_number > 1 and (not last_page or left) then
        table.insert(page.nodes, FishAndChips.Compendium.nav_button(page_number, left, 'achievement_page', 0.2))
    end

    return page
end

function Node:hover() 
    if self.config and self.config.h_popup then
        if not self.children.h_popup then 
            self.config.h_popup_config.instance_type = 'POPUP'
            self.children.h_popup = UIBox{
                definition = self.config.h_popup,
                config = self.config.h_popup_config,
            }
            self.children.h_popup.states.collide.can = false
            self.children.h_popup.states.drag.can = true
        end
    end
    if self.config and self.config.h_popup_2 then
        if not self.children.h_popup_2 then 
            self.config.h_popup_2_config.instance_type = 'POPUP'
            self.children.h_popup_2 = UIBox{
                definition = self.config.h_popup_2,
                config = self.config.h_popup_2_config,
            }
            self.children.h_popup_2.states.collide.can = false
            self.children.h_popup_2.states.drag.can = true
        end
    end
end

local old_stop = Node.stop_hover
function Node:stop_hover()
    old_stop(self)
    if self.children.h_popup_2 then
        self.children.h_popup_2:remove()
        self.children.h_popup_2 = nil
    end
end

SMODS.draw_ignore_keys.h_popup_2 = true

function FishAndChips.Compendium.dev_card(dev)
    if not dev then return nil end
    local partner = dev.joint_credits and PotatoPatchUtils.Developers[dev.fac_partner]
    
    local temp_area = FishAndChips.Compendium.compendium_area(1, dev.joint_credits and {0.2 + 4 * 71/95, 2})
    local dev_card = Card(0, 0, (dev.joint_credits and 2 or 1) * G.CARD_W / 1.25, G.CARD_H / 1.25, nil, G.P_CENTERS.c_base)
    dev_card.children.center:remove()
    dev_card.children.center = SMODS.create_sprite(dev_card.T.x, dev_card.T.y, dev_card.T.w, dev_card.T.h, dev.atlas or "Joker", dev.pos or {x = 0, y = 0})
    dev_card.children.center.states.hover = dev_card.states.hover
    dev_card.children.center.states.click = dev_card.states.click
    dev_card.children.center.states.drag = dev_card.states.drag
    dev_card.children.center.states.collide.can = true
    dev_card.children.center:set_role({major = dev_card, role_type = 'Glued', draw_major = dev_card})

    -- Check for dev_card soul
    if dev.soul_pos then
        dev_card.children.ppu_floating_sprite = SMODS.create_sprite(dev_card.T.x, dev_card.T.y, dev_card.T.w, dev_card.T.h, dev.atlas or "Joker", dev.soul_pos)
        dev_card.children.ppu_floating_sprite.role.draw_major = dev_card
        dev_card.children.ppu_floating_sprite.states.hover.can = false
        dev_card.children.ppu_floating_sprite.states.click.can = false
    end

    dev_card.no_shadow = true

    dev_card.ppu_member = dev
    dev_card.click = function(self)
        if not dev.click and not (partner and partner.click) then
            return Card.click(dev_card)
        end
        if dev.click then
            dev.click(dev_card)
        end
        if partner and partner.click then
            partner.click(dev_card)
        end
    end

    dev_card.align_h_popup = function(self, dir)
        local focused_ui = self.children.focused_ui and true or false
        local popup_direction = dir or self.config.h_popup_dir or (self.T.y < G.CARD_H*0.8) and 'bm' or 'tm'
        local sign = 1
        return {
            major = self.children.focused_ui or self,
            parent = self,
            xy_bond = 'Strong',
            r_bond = 'Weak',
            wh_bond = 'Weak',
            offset = {
                x = popup_direction ~= 'cl' and popup_direction ~= 'cr' and 0 or
                    focused_ui and sign*-0.05 or
                    (self.ability.consumeable and 0.0) or
                    (self.ability.set == 'Voucher' and 0.0) or
                    sign*-0.05,
                y = focused_ui and (
                            popup_direction == 'tm' and (self.area and self.area == G.hand and -0.08 or-0.15) or
                            popup_direction == 'bm' and 0.12 or
                            0
                        ) or
                    popup_direction == 'tm' and -0.13 or
                    popup_direction == 'bm' and 0.1 or
                    0
            },
            type = popup_direction,
        }

    end

    -- Create tooltip
    dev_card.hover = function(self)
        local create_tooltip = function(dev)
            local info_nodes = {n = G.UIT.R, config = { align = "cm", padding = 0, colour = G.C.CLEAR }, nodes = {
                {n = G.UIT.C, config = { align = "cm", padding = 0.2 }, nodes = {}},
            }}
            local text = dev.loc and G.localization.descriptions.PotatoPatch[dev.loc].text_parsed or nil
            local loc_vars = dev.loc_vars and dev:loc_vars() or {}
            loc_vars.text_colour = loc_vars.text_colour or G.C.UI.TEXT_LIGHT
            loc_vars.font = loc_vars.font or SMODS.Fonts.fac_collection
            if text then
                if not text[1][1][1] then text = {text} end
                for _, box in ipairs(text) do
                    local node = {n=G.UIT.R, config = {colour = G.C.L_BLACK, r=0.1, padding = 0.15, align = 'cm', shadow = true}, nodes = {}}
                    for _, v in ipairs(box) do
                        table.insert(node.nodes, {n=G.UIT.R, config={align='cm'}, nodes = SMODS.localize_box(v, loc_vars)})
                    end
                    info_nodes.nodes[1].nodes[#info_nodes.nodes[1].nodes + 1] = {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.C, config = {align = 'cm', colour = G.C.WHITE, r=0.1, padding = 0.025}, nodes = {node}}}}
                end
            end
            return info_nodes
        end
        self:juice_up(0.05, 0.03)
        play_sound('paper1', math.random() * 0.2 + 0.9, 0.35)
        dev_card.config.h_popup = create_tooltip(dev)
        dev_card.config.h_popup_dir = partner and 'cl'
        dev_card.config.h_popup_config = dev_card:align_h_popup()
        if partner then
            dev_card.config.h_popup_2 = create_tooltip(partner)
            dev_card.config.h_popup_2_dir = 'cr'
            dev_card.config.h_popup_2_config = dev_card:align_h_popup('cr')
        end
        Moveable.hover(self)
    end

    local name = {{}}
    if dev.always_use_dynatext or dev.text_effect or dev.shaders or dev.colours then
        name[1] = {n=G.UIT.O, config = {align = 'bm', object = DynaText({
            string = dev.loc and localize({type = 'name_text', key = dev.loc, set = 'PotatoPatch'}) or dev.name or 'ERROR',
            colours = dev.colours or { dev.colour or FishAndChips.C.COMPENDIUM_TEXT }, scale = 0.47,
            text_effect = dev.text_effect or nil, shaders = dev.shaders or nil,
            silent = true, shadow = false, y_offset = -0.6, font = SMODS.Fonts.fac_collection, maxw = 1.45
        })}}
    else
        localize({ type = 'name', set = 'PotatoPatch', key = dev.loc, nodes = name[1], scale = 0.8, maxw = 1.45, font = SMODS.Fonts.fac_collection, text_colour = dev.colour or FishAndChips.C.COMPENDIUM_TEXT, stylize = true, no_shadow = true, no_pop_in = true, no_bump = true, no_silent = true, no_spacing = true})
        name[1] = name[1][1] and name[1][1][1] or {n=G.UIT.O, config={align = 'bm', object = DynaText({string = dev.name, colours = {dev.colour or FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 1.45, pop_in_rate = 0, scale = 0.4, silent = true})}}
        name[1].config.align = 'bm'
    end

    if partner then
        name[2] = {n=G.UIT.O, config = {align = 'bm', object = DynaText({
                string = ' & ',
                colours = {FishAndChips.C.COMPENDIUM_TEXT}, scale = 0.7,
                silent = true, shadow = false, y_offset = -0.6, font = SMODS.Fonts.fac_collection, maxw = 0.3
            })}}
        if partner.always_use_dynatext or partner.text_effect or partner.shaders or partner.colours then
            name[3] = {n=G.UIT.O, config = {align = 'bm', object = DynaText({
                string = partner.loc and localize({type = 'name_text', key = partner.loc, set = 'PotatoPatch'}) or dev.name or 'ERROR',
                colours = partner.colours or { partner.colour or FishAndChips.C.COMPENDIUM_TEXT }, scale = 0.47,
                text_effect = partner.text_effect or nil, shaders = partner.shaders or nil,
                silent = true, shadow = false, y_offset = -0.6, font = SMODS.Fonts.fac_collection, maxw = 1.45
            })}}
        else
            name[3] = {}
            localize({ type = 'name', set = 'PotatoPatch', key = partner.loc, nodes = name[3], scale = 0.8, maxw = 1.45, font = SMODS.Fonts.fac_collection, text_colour = partner.colour or FishAndChips.C.COMPENDIUM_TEXT, stylize = true, no_shadow = true, no_pop_in = true, no_bump = true, no_silent = true, no_spacing = true})
            name[3] = name[3][1] and name[3][1][1] or {n=G.UIT.O, config={align = 'bm', object = DynaText({string = partner.name, colours = {partner.colour or FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 1.45, pop_in_rate = 0, scale = 0.4, silent = true})}}
            name[3].config.align = 'bm'
        end
    end
    for i, node in ipairs(name) do
        name[i] = {n=G.UIT.C, config = {align = 'cm'}, nodes = {node}}
    end

    temp_area:emplace(dev_card)

    if dev.modify_card then dev.modify_card(dev_card) end
    if partner and partner.modify_card then partner.modify_card(dev_card) end

    return {n=G.UIT.C, config = {align = 'bm', padding = 0.1}, nodes = {
        {n=G.UIT.R, config = {align = 'bm'}, nodes = name},
        {n=G.UIT.R, config = {align = 'cm'}, nodes = {{n=G.UIT.O, config={object=temp_area}}}},
    }}
end

local holding_partners = {}
local partner_buffer = 0
function FishAndChips.Compendium.credits_page(page_number, left)
    local page = {n=G.UIT.C, config = {minw = 5.4, minh = 9.3, align = 'tm', padding = 0.1}, nodes = {
        FishAndChips.Compendium.page_title(page_number == 1 and 'credits_page' or 'credits_page_2', 1),
        {n=G.UIT.R, config = {align = 'tm', minh = 7, minw = 5}, nodes = {}}
    }}

    if page_number > 1 then
        local mod_devs = {}
        for _, key in ipairs(PotatoPatchUtils.Developer.obj_buffer) do
            local dev = PotatoPatchUtils.Developers[key]
            if dev.mod_id == FishAndChips.mod.id and not dev.ignore_limits then
                table.insert(mod_devs, dev)
            end
        end
        local max = #mod_devs

        local devs_per_page = 6
        local start_index = (page_number - 2) * devs_per_page
        local rows = 2
        local devs_per_row = devs_per_page/rows
        
        if not next(holding_partners) or holding_partners[1] > start_index then
            holding_partners = {}
            partner_buffer = 0
            if start_index > max then return {n=G.UIT.C, config = {minw = 5.4, minh = 9.3, align = 'tm', padding = 0.1}, nodes = {}} end
            if mod_devs[start_index] and mod_devs[start_index].fac_partner then
                holding_partners[#holding_partners+1] = start_index
                local it = 1
                while mod_devs[start_index + it] and mod_devs[start_index + it].fac_partner do
                    holding_partners[#holding_partners+1] = start_index + it
                    it = it + 1
                end
                it = 2
                local offset = 0
                while mod_devs[start_index - it] and mod_devs[start_index - it].fac_partner do
                    if offset < 4 then
                        table.insert(holding_partners, 1, start_index - it + 1)
                        table.insert(holding_partners, 1, start_index - it)
                    end
                    offset = offset + 2
                    it = it + 2
                end
                if #holding_partners%2 == 1 then holding_partners = {} else partner_buffer = #holding_partners/2 - 1 end
            end

        end
        local last_page = false
        for i=1, rows do
            local row = {n=G.UIT.R, config = {align = 'bm', minh = 6.8/2, minw = 5}, nodes = {}}
            local j=1
            while j <= devs_per_row do
                if last_page then break end
                local index = start_index + (i-1)*devs_per_row + j
                if j == devs_per_row then
                    if next(holding_partners) then
                        index = index + #holding_partners
                        partner_buffer = partner_buffer - 1
                    end
                    while mod_devs[index] and mod_devs[index].fac_partner do
                        holding_partners[#holding_partners+1] = index
                        index = index + 1
                    end
                    if partner_buffer == 0 and next(holding_partners) then partner_buffer = #holding_partners/2 - 1 end
                else
                    if next(holding_partners) then index = holding_partners[1] end
                end
                table.insert(row.nodes, FishAndChips.Compendium.dev_card(mod_devs[index]))
                if mod_devs[index] and mod_devs[index].joint_credits then
                    j = j + 1
                elseif mod_devs[index] and mod_devs[index].fac_partner then
                    table.insert(row.nodes, FishAndChips.Compendium.dev_card(mod_devs[index + 1]))
                    j = j + 1
                end
                if next(holding_partners) and index == holding_partners[1] then
                    table.remove(holding_partners, 1)
                    table.remove(holding_partners, 1)
                    index = start_index + (i-1)*devs_per_row + j
                end
                if start_index + (i-1)*devs_per_row + j >= max then last_page = true; break end
                j = j + 1
            end
            table.insert(page.nodes[2].nodes, row)
            if last_page then break end
        end

        
    if page_number > 1 and (not last_page or left) then
        table.insert(page.nodes, FishAndChips.Compendium.nav_button(page_number, left, 'credits_page', 0.4))
    end

        return page
        
    end

    local modNodes = {}

    modNodes[#modNodes + 1] = {}
    local loc_vars = {
        background_colour = G.C.CLEAR,
        text_colour = FishAndChips.C.COMPENDIUM_TEXT,
        scale = 1.25,
        vars = {}
    }
    localize { type = 'descriptions', key = 'fac_credits', set = 'Other', nodes = modNodes[#modNodes], font = SMODS.Fonts.fac_collection, vars = loc_vars.vars, scale = loc_vars.scale, text_colour = loc_vars.text_colour }
    modNodes[#modNodes] = desc_from_rows(modNodes[#modNodes])
    modNodes[#modNodes].config.colour = loc_vars.background_colour
    page.nodes[2].nodes = modNodes
    
    return page
end

FishAndChips.mod.config_tab = true

function FishAndChips.Compendium.config_page(page_number, left)
    if page_number > 1 then return end -- TODO: add artwork to page 2
    FishAndChips.Compendium.reset_warning = G.STAGE ~= G.STAGES.RUN and localize('ph_fac_reset_all') or localize('ph_fac_cannot_reset')
    
    local page = {n=G.UIT.C, config = {minw = 5.4, minh = 9.3, align = 'tm', padding = 0.1}, nodes = {
        FishAndChips.Compendium.page_title('config_page', page_number),
        {n=G.UIT.R, config = {minh = 0.4}},
        {n=G.UIT.R, config = {align = 'tm', minh = 3, minw = 5}, nodes = {
            FishAndChips.Compendium.toggle {text_key = 'b_fac_ambience_toggle', ref_value = "ambience", callback = G.FUNCS.fac_toggle_ambience},
            FishAndChips.Compendium.toggle {text_key = 'b_fac_menu_toggle', ref_value = "menu"},
            FishAndChips.Compendium.toggle {text_key = 'b_fac_condensed_fish', ref_value = "condensed_fish"},
            FishAndChips.Compendium.toggle {text_key = 'b_fac_flavour_text', ref_value = "disable_flavour"},
            FishAndChips.Compendium.toggle {text_key = 'b_fac_flashing_lights', ref_value = "disable_flashing"},
            FishAndChips.Compendium.toggle {text_key = 'b_fac_fish_scaling', ref_value = "disable_fish_scaling"},
            FishAndChips.Compendium.toggle {text_key = 'b_fac_performance_mode', ref_value = "performance_mode"},
        }},
        {n=G.UIT.R, config = {align = 'cm', minh = 2}, nodes = {
            {n=G.UIT.R, config = {align = 'cm', colour = FishAndChips.C.COMPENDIUM_COLOUR, r = 0.1, hover = true, button = 'fac_reset_all_progress', func = 'fac_can_reset_progress', minw = 3.2, minh = 0.8, padding = 0.05}, nodes = {
                {n=G.UIT.T, config = {ref_table = FishAndChips.Compendium, ref_value = 'reset_warning', font = SMODS.Fonts.fac_collection, colour = FishAndChips.C.COMPENDIUM_TEXT, scale = 0.5}}
            }}
        }}
    }}

    return page
end



local modBox = create_UIBox_mods
function create_UIBox_mods(args)
    if G.ACTIVE_MOD_UI.id == 'FishAndChips' then
        return FishAndChips.Compendium.cover()
    end
    return modBox(args)
end