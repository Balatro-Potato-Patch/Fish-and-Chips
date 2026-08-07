function FishAndChips.crimsonseraphim.parse_string(text)
    for i, v in pairs(text) do
        if type(v) == "table" then
            FishAndChips.crimsonseraphim.parse_string(v)
        else
            text[i] = loc_parse_string(v)
        end
    end
end

-- i love stealing from my mod and shit :3
function FishAndChips.crimsonseraphim.create_vtext(vtext, AUT, nodes, vars, lines, num)
    local localize_args = {
        AUT = AUT,
        nodes = nodes,

        vars = vars
    }
    -- taken from localize; adds the multibox
    localize_args.AUT.multi_box = localize_args.AUT.multi_box or {}
    local i = num + 1 -- fucking janky ass method
    G.AUT = AUT
    for j, line in ipairs(lines) do
        local final_line = SMODS.localize_box(line, localize_args)
        if i == 1 or next(AUT.info) then
            nodes[#nodes+1] = final_line -- Sends main box to AUT.main
            if not next(AUT.info) then nodes.main_box_flag = true end
        elseif not next(AUT.info) then 
            nodes.main_box_flag = true
            AUT.multi_box[i-1] = AUT.multi_box[i-1] or {}
            AUT.multi_box[i-1][#AUT.multi_box[i-1]+1] = final_line
        end
        if not next(AUT.info) and vars.box_colours then AUT.box_colours[i] = vars.box_colours and vars.box_colours[i] or G.C.UI.BACKGROUND_WHITE end
    end
end

function FishAndChips.crimsonseraphim.create_nodes_from_loc(string, n)
    local vtext = string
    vtext = type(vtext) == "string" and {vtext} or vtext
    FishAndChips.crimsonseraphim.parse_string(vtext)
    local nodes = {}
    for i, v in pairs(vtext) do
        nodes[#nodes+1] = {n = n, config = { align = "cm", padding = 0.05 }, nodes = SMODS.localize_box(v, {})}
    end
    return nodes
end

function FishAndChips.crimsonseraphim.generate_ui_multiboxes(args2)
    return function(center, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local num = full_UI_table.multi_box and #full_UI_table.multi_box + 1 or 1
        for i, args in pairs(args2) do
            if not args.func or args:func(card) then
                local keys = type(args.key) == "table" and args.key or {args.key}
                for _, k in pairs(keys) do
                    local vars = args.loc_vars and (args:loc_vars({}, card) or {}).vars or {}
                    local lines = SMODS.shallow_copy(G.localization.misc.v_dictionary_parsed[k] or {})
                    local vtext = localize{ type = "variable", key = k, vars = vars } -- the var doesn't matter here
                    FishAndChips.crimsonseraphim.create_vtext(vtext, full_UI_table, desc_nodes, vars, lines, num)
                    if args.seperate_boxes then
                        num = num + 1
                    end
                end
                local texts = type(args.localized_text) == "table" and args.localized_text or {args.localized_text}
                for _, k in pairs(texts) do
                    local vars = args.loc_vars and (args:loc_vars({}, card) or {}).vars or {}
                    local vtext = type(k) == "string" and {k} or k or {}
                    FishAndChips.crimsonseraphim.parse_string(vtext)
                    FishAndChips.crimsonseraphim.create_vtext(nil, full_UI_table, desc_nodes, vars, vtext, num)
                    if args.seperate_boxes then
                        num = num + 1
                    end
                end
                if not args.seperate_boxes then
                    num = num + 1
                end
            end
        end
    end
end

function FishAndChips.crimsonseraphim.advance_center(center)
    local cards = {}
    for i, v in pairs(G.P_CENTERS) do
        if v.ppu_artist and v.ppu_artist[1] == "crimsonseraphim" and v.set == "fac_Fish" then
            cards[#cards+1] = v
        end
    end
    for i, v in pairs(cards) do
        if v.key == center.key then
            return cards[i+1] or cards[1] or v
        end
    end
    return center
end

function FishAndChips.crimsonseraphim.draw_letter(letter, self)
    local real_pop_in = self.config.min_cycle_time == 0 and 1 or letter.pop_in
    local _shadow_norm = self.ARGS.draw_shadow_norm
    _shadow_norm.x, _shadow_norm.y = 
        self.shadow_parrallax.x/math.sqrt(self.shadow_parrallax.y*self.shadow_parrallax.y + self.shadow_parrallax.x*self.shadow_parrallax.x)*self.font.FONTSCALE/G.TILESIZE,
        self.shadow_parrallax.y/math.sqrt(self.shadow_parrallax.y*self.shadow_parrallax.y + self.shadow_parrallax.x*self.shadow_parrallax.x)*self.font.FONTSCALE/G.TILESIZE
    love.graphics.draw(
        letter.letter,
        0.5*(letter.dims.x - letter.offset.x)*self.font.FONTSCALE/G.TILESIZE + _shadow_norm.x,
        0.5*(letter.dims.y - letter.offset.y)*self.font.FONTSCALE/G.TILESIZE + _shadow_norm.y, 
        letter.r or 0,
        real_pop_in*letter.scale*self.scale*self.font.FONTSCALE/G.TILESIZE,
        real_pop_in*letter.scale*self.scale*self.font.FONTSCALE/G.TILESIZE,
        0.5*letter.dims.x/(self.scale),
        0.5*letter.dims.y/(self.scale)
    )
end

function Card:transmute(seed, center)
    local result = center
    local s = {
        w = self.T.w / self.original_T.w,
        h = self.T.h / self.original_T.h
    }
    if not center then
        local valid = {}
        for attribute, _ in pairs(self.config.center.attributes or {}) do
            if type(attribute) ~= "number" and not FishAndChips.Environments[attribute] then
                valid[#valid+1] = attribute
            end
        end
        result = G.P_CENTERS[SMODS.poll_object{type = "fac_Fish", attributes = valid, union = true}]
    end
    self.children.center.aeonfish_transmute = {
        realtime_start = G.TIMERS.REAL,
        image = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, result.atlas, result.pos),
        center = result
    }
    self.states.hover.can = false
    play_sound("fac_crimsonseraphim_shimmer")
    -- G.E_MANAGER:add_event(Event{
    --     blocking = false,
    --     func = function()
    --         if G.TIMERS.REAL - self.children.center.aeonfish_transmute.realtime_start > 0.6 then
    --             self:set_ability(self.children.center.aeonfish_transmute.center)
    --             self.children.center.aeonfish_transmute = nil
    --             self.states.hover.can = true
    --             self.T.w = self.T.w * s.w
    --             self.T.h = self.T.h * s.h
    --             return true
    --         end
    --     end
    -- })
    G.E_MANAGER:add_event(Event{
        blocking = false,
        func = function()
            if self.children.center.aeonfish_transmute and math.abs((G.TIMERS.REAL - self.children.center.aeonfish_transmute.realtime_start) - 0.2) < 0.01 then
                self:juice_up(0.6, 0.7)
                return true
            end
        end
    })
end

function FishAndChips.crimsonseraphim.calculate_fish_seal(card, context)
    if card.fish_seal and FishAndChips.crimsonseraphim.fish_seals[card.fish_seal] and FishAndChips.crimsonseraphim.fish_seals[card.fish_seal].calculate then
        return FishAndChips.crimsonseraphim.fish_seals[card.fish_seal].calculate(card, context)
    end
end

function Card:set_fish_seal(_seal, silent, immediate)
    local fish_seals = FishAndChips.crimsonseraphim.fish_seals
    self.seal = nil
    if _seal then
        self.fish_seal = _seal
        self.ability.fish_seal = {}
        self.ability.fish_seal.key = _seal
        for k, v in pairs(fish_seals[_seal] and fish_seals[_seal].config or G.P_SEALS[_seal].config or {}) do
            if type(v) == 'table' then
                self.ability.fish_seal[k] = copy_table(v)
            else
                self.ability.fish_seal[k] = v
            end
        end
        
        self.ability.delay_seal = not silent
    
        G.CONTROLLER.locks.seal = true
        local sound = (fish_seals[_seal] and fish_seals[_seal].sound or G.P_SEALS[_seal].sound) or {sound = 'gold_seal', per = 1.2, vol = 0.4}
        if immediate then 
            self:juice_up(0.3, 0.3)
            self.ability.delay_seal = false
            play_sound(sound.sound, sound.per, sound.vol)
            G.CONTROLLER.locks.seal = false
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                func = function()
                    self:juice_up(0.3, 0.3)
                    self.ability.delay_seal = false
                    play_sound(sound.sound, sound.per, sound.vol)
                return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.CONTROLLER.locks.seal = false
                return true
                end
            }))
        end
        if type(fish_seals[_seal] and fish_seals[_seal].on_apply) == "function" then
            fish_seals[_seal]:on_apply(self)
        end
    end
    self:set_cost()
end

function Card:jokered_forge() 
    self.ability.crimsonseraphim_forged = pseudorandom_element({
        "fac_crimsonseraphim_forged_mult",
        "fac_crimsonseraphim_forged_chips",
        "fac_crimsonseraphim_forged_money",
        "fac_crimsonseraphim_forged_sand",
    })

    self:juice_up()
    play_sound("fac_crimsonseraphim_forge")
end

function FishAndChips.crimsonseraphim.create_forge_text(cfg)
    if not cfg.crimsonseraphim_forged then return end
    local text = G.localization.descriptions.Other[cfg.crimsonseraphim_forged].text or {}
    if #text == 0 then return end
    return text
end

local forge_effects = {
    fac_crimsonseraphim_forged_mult = function(c, context)
        if context.main_scoring then
            return {mult = 4}
        end
    end,
    fac_crimsonseraphim_forged_chips = function(c, context)
        if context.main_scoring then
            return {chips = 15}
        end
    end,
    fac_crimsonseraphim_forged_money = function(c, context)
        if context.setting_blind then
            return {dollars  = 4}
        end
    end,
    fac_crimsonseraphim_forged_sand = function(c, context)
        if context.fac_end_fishing and context.fish then
            return {sand_dollars = 1}
        end
    end,
}

function FishAndChips.crimsonseraphim.calculate_forged_joker(card, context)
    if card.ability.crimsonseraphim_forged and forge_effects[card.ability.crimsonseraphim_forged] then
        return forge_effects[card.ability.crimsonseraphim_forged](card, context)
    end
end

function FishAndChips.crimsonseraphim.draw_reticle(x, y, size)
    love.graphics.setColor({G.C.RED[1], G.C.RED[2], G.C.RED[3], G.GAME.REVOLVER_RETICLE_ALPHA or 1})
    local w = love.graphics.getLineWidth()
    love.graphics.setLineWidth(2)
    x = x - 2.5
    y = y + 1.5
    love.graphics.ellipse("line", x, y, size, size)
    love.graphics.ellipse("fill", x - size, y, size * 0.5, size * 0.2)
    love.graphics.ellipse("fill", x + size, y, size * 0.5, size * 0.2)

    love.graphics.ellipse("fill", x, y - size, size * 0.2, size * 0.5)
    love.graphics.ellipse("fill", x, y + size, size * 0.2, size * 0.5)
    love.graphics.setLineWidth(w)
    if (G.GAME.REVOLVER_RETICLE_ALPHA or 1) <= 0 then G.GAME.REVOLVER_RETICLE_ALPHA = nil end
end

function FishAndChips.crimsonseraphim.get_dummy(center, area, self)
    local abil = copy_table(center.config) or {}
    abil.consumeable = copy_table(abil)
    abil.name = center.name or center.key
    abil.set = "Joker"
    abil.t_mult = abil.t_mult or 0
    abil.t_chips = abil.t_chips or 0
    abil.x_mult = abil.x_mult or abil.Xmult or 1
    abil.extra_value = abil.extra_value or 0
    abil.d_size = abil.d_size or 0
    abil.mult = abil.mult or 0
    abil.effect = center.effect
    abil.h_size = abil.h_size or 0
    local eligible_editionless_jokers = {}
    for i, v in pairs(G.jokers and G.jokers.cards or {}) do
        if not v.edition then
            eligible_editionless_jokers[#eligible_editionless_jokers+1] = v
        end
    end
    local tbl = {
        ability = abil,
        config = {
            center = center,
            center_key = center.key
        },
        juice_up = function(_, ...)
            return self:juice_up(...)
        end,
        start_dissolve = function(_, ...)
            return self:start_dissolve(...)
        end,
        remove = function(_, ...)
            return self:remove(...)
        end,
        flip = function(_, ...)
            return self:flip(...)
        end,
        use_consumeable = function(self, ...)
            self.bypass_echo = true
            local ret = Card.use_consumeable(self, ...)
            self.bypass_echo = nil
        end,
        can_use_consumeable = function(self, ...)
            return Card.can_use_consumeable(self, ...)
        end,
        calculate_joker = function(self, ...)
            return Card.calculate_joker(self, ...)
        end,
        can_calculate = function(self, ...)
            return Card.can_calculate(self, ...)
        end,
        original_card = self,
        area = area,
        added_to_deck = added_to_deck,
        cost = self.cost,
        sell_cost = self.sell_cost,
        eligible_strength_jokers = eligible_editionless_jokers,
        eligible_editionless_jokers = eligible_editionless_jokers,
        T = self.T,
        VT = self.VT
    }
    for i, v in pairs(self) do
        if type(v) == "function" and i ~= "flip_side" then
            tbl[i] = function(_, ...)
                return v(self, ...)
            end
        end
    end
    return tbl
end

local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    local effects = calculate_joker_ref(self, context)
    local ret = FishAndChips.crimsonseraphim.calculate_forged_joker(self, context)
    if ret then
        effects = SMODS.merge_effects({effects or {}, ret})
    end
    
    local ret = FishAndChips.crimsonseraphim.calculate_fish_seal(self, context)
    if ret then
        effects = SMODS.merge_effects({effects or {}, ret})
    end

    if context.joker_main then
        if self.ability.crimsonseraphim_starblighted then
            effects = SMODS.merge_effects({effects or {}, {
                mult = -self.ability.crimsonseraphim_starblighted_mult
            }})
            self.ability.crimsonseraphim_starblighted_mult = self.ability.crimsonseraphim_starblighted_mult + 0.5 
        end
    end
    if context.starting_shop and self.ability.crimsonseraphim_temporary then
        SMODS.destroy_cards(self, true, true)
    end
    return effects
end

local generate_ui_ref = SMODS.Center.generate_ui
function SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local cfg = card and card.ability or self.config
    if card and card.ability.crimsonseraphim_starblighted then
        info_queue[#info_queue+1] = {set = "Other", key = "crimsonseraphim_starblighted", vars = {card.ability.crimsonseraphim_starblighted_mult, 0.5}}
    end
    if card and card.ability.crimsonseraphim_temporary then
        info_queue[#info_queue+1] = {set = "Other", key = "crimsonseraphim_temporary"}
    end
    return generate_ui_ref(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function _G.create_UIBox_crimsonseraphim_cursedfish()
    G.your_cursefish_areas = {
        CardArea(
        0, 0,
        G.CARD_W,
        G.CARD_H, 
        {card_limit = 1, type = 'play', highlight_limit = 0, negative_info = 'joker'}),
        CardArea(
        0, 0,
        G.CARD_W,
        G.CARD_H, 
        {card_limit = 1, type = 'play', highlight_limit = 0, negative_info = 'joker'}),
        CardArea(
        0, 0,
        G.CARD_W,
        G.CARD_H, 
        {card_limit = 1, type = 'play', highlight_limit = 0, negative_info = 'joker'})
    }
    for i = 1, 3 do
        SMODS.add_card{set = "fac_Fish", area = G.your_cursefish_areas[i]}
    end
    return create_UIBox_generic_options({
        contents = {
            {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", padding = 0.1, colour = G.C.GREEN}, nodes={
                    {n=G.UIT.C, config={align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 6}, nodes={
                        {n=G.UIT.O, config={object = G.your_cursefish_areas[1]}},
                    }},
                    {n=G.UIT.C, config={ref_table = G.your_cursefish_areas[2].cards[1], func = "can_obtain_cursefish", button = "sell_card", align = "cm", padding = 0.1, colour = G.C.TRANPARENT}, nodes={
                        {n=G.UIT.T, config={text = localize("k_obtain_cursefish"), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                    }},
                    {n=G.UIT.C, config={ref_table = G.your_cursefish_areas[2].cards[1], func = "can_banish_cursefish", button = "sell_card", align = "cm", padding = 0.1, colour = G.C.TRANPARENT}, nodes={
                        {n=G.UIT.T, config={text = localize("k_banish_cursefish"), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                    }}
                }},
                {n=G.UIT.R, config={align = "cm", padding = 0.1, colour = G.C.GREEN}, nodes={
                    {n=G.UIT.C, config={align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 6}, nodes={
                        {n=G.UIT.O, config={object = G.your_cursefish_areas[2]}},
                    }},
                    {n=G.UIT.C, config={ref_table = G.your_cursefish_areas[2].cards[1], func = "can_obtain_cursefish", button = "sell_card", align = "cm", padding = 0.1, colour = G.C.TRANPARENT}, nodes={
                        {n=G.UIT.T, config={text = localize("k_obtain_cursefish"), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                    }},
                    {n=G.UIT.C, config={ref_table = G.your_cursefish_areas[2].cards[1], func = "can_banish_cursefish", button = "sell_card", align = "cm", padding = 0.1, colour = G.C.TRANPARENT}, nodes={
                        {n=G.UIT.T, config={text = localize("k_banish_cursefish"), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                    }}
                }},
                {n=G.UIT.R, config={align = "cm", padding = 0.1, colour = G.C.GREEN}, nodes={
                    {n=G.UIT.C, config={align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 6}, nodes={
                        {n=G.UIT.O, config={object = G.your_cursefish_areas[3]}},
                    }},
                    {n=G.UIT.C, config={ref_table = G.your_cursefish_areas[3].cards[1], func = "can_obtain_cursefish", button = "sell_card", align = "cm", padding = 0.1, colour = G.C.TRANPARENT}, nodes={
                        {n=G.UIT.T, config={text = localize("k_obtain_cursefish"), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                    }},
                    {n=G.UIT.C, config={ref_table = G.your_cursefish_areas[3].cards[1], func = "can_banish_cursefish", button = "sell_card", align = "cm", padding = 0.1, colour = G.C.TRANPARENT}, nodes={
                        {n=G.UIT.T, config={text = localize("k_banish_cursefish"), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                    }}
                }}
            }}
        }
    })
end

G.FUNCS.can_obtain_cursefish = function(e)
    e.config.colour = G.C.BLACK
    e.config.button = "obtain_cursefish"
end
--
G.FUNCS.obtain_cursefish = function(e)
    local card = e.config.ref_table
    if #G.fac_fish_area.cards + (1 + card.ability.extra_slots_used) <= G.fac_fish_area.config.card_limit + card.ability.card_limit then
        card.area:remove_card(card)
        G.fac_fish_area:emplace(card)
        card:add_to_deck()
        G.FUNCS.exit_overlay_menu()
    else    
        alert_no_space(card, G.fac_fish_area)
    end
end

G.FUNCS.can_banish_cursefish = function(e)
    e.config.colour = G.C.BLACK
    e.config.button = "banish_cursefish"
end
--
G.FUNCS.banish_cursefish = function(e)
    local card = e.config.ref_table
    G.GAME.banned_keys[card.config.center_key] = true
    card:start_dissolve()
    G.E_MANAGER:add_event(Event{
        trigger = "after",
        delay = 1,
        func = function()
            G.FUNCS.exit_overlay_menu()
            return true
        end
    })
end

function FishAndChips.crimsonseraphim.count_developers()
    local d = {}
    local tot = 0
    if not G.fac_fish_area then return 1 end
    for i, v in pairs(G.fac_fish_area.cards) do
        if v.config.center.ppu_artist then
            for i, v in pairs(type(v.config.center.ppu_artist) == "string" and {v.config.center.ppu_artist} or v.config.center.ppu_artist) do
                d[v] = true
            end
        end
        if v.config.center.ppu_coder then
            for i, v in pairs(type(v.config.center.ppu_coder) == "string" and {v.config.center.ppu_coder} or v.config.center.ppu_coder) do
                d[v] = true
            end
        end
    end
    for i, v in pairs(d) do
        tot = tot + 1
    end
    return tot > 0 and tot or 1
end

function FishAndChips.crimsonseraphim.swoon()
    FishAndChips.crimsonseraphim.vol = G.SETTINGS.SOUND.music_volume
    G.SETTINGS.SOUND.music_volume = 0
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        blocking = false,
        func = (function()
            G.swoon = 60 * G.SETTINGS.GAMESPEED
            play_sound("fac_crimsonseraphim_swoon", 1, 1)
            return true
        end),
    }))
end

function FishAndChips.crimsonseraphim.draw_sprite(sprite, card, args)
    local edition = card.edition
    args = args or {}
    sprite:draw_shader("dissolve", unpack(args))
    if edition and G.P_CENTERS[edition.key].shader then
        args[2] = args[2] or card.ARGS.send_to_shader
        sprite:draw_shader(G.P_CENTERS[edition.key].shader, unpack(args))
        if edition.negative then
            sprite:draw_shader("negative_shine", unpack(args)) 
        end
    end
end