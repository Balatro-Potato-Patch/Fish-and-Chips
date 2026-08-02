local csc = Card.sell_card
function Card:sell_card()
    if self.ability.set ~= 'fac_Fish' then
        csc(self)
    else
        G.CONTROLLER.locks.selling_card = true
        stop_use()
        local area = self.area
        G.CONTROLLER:save_cardarea_focus('fac_fish_area')

        if self.children.use_button then self.children.use_button:remove(); self.children.use_button = nil end
        if self.children.select_button then self.children.select_button:remove(); self.children.select_button = nil end
        if self.children.sell_button then self.children.sell_button:remove(); self.children.sell_button = nil end
        
        local eval, post = eval_card(self, {selling_self = true})
        local effects = {eval}
        for _,v in ipairs(post) do effects[#effects+1] = v end
        if eval.retriggers then
            for rt = 1, #eval.retriggers do
                local rt_eval, rt_post = eval_card(self, { selling_self = true, retrigger_joker = true})
                if next(rt_eval) then
                    table.insert(effects, {eval.retriggers[rt]})
                    table.insert(effects, rt_eval)
                    for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                end
            end
        end
        SMODS.trigger_effects(effects, self)

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function()
            play_sound('coin2')
            self:juice_up(0.3, 0.4)
            return true
        end}))
        delay(0.2)
        G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
            ease_sand_dollars(self.sell_cost)
            self:start_dissolve({FishAndChips.C.SAND_DOLLAR})
            delay(0.3)
            G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_sold = G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_sold + 1
            check_for_unlock({type = 'fac_fish_sold'})

            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.3, blocking = false,
            func = function()
                G.E_MANAGER:add_event(Event({trigger = 'immediate',
                func = function()
                    G.E_MANAGER:add_event(Event({trigger = 'immediate',
                    func = function()
                        G.CONTROLLER.locks.selling_card = nil
                        G.CONTROLLER:recall_cardarea_focus('fac_fish_area')
                        if G.GAME.fac_fish_expanded and not G.fac_fish_area.cards[1] then
                            G.FUNCS.fac_open_fishing_menu()
                        end
                        return true
                    end}))
                    return true
                end}))
                return true
            end}))
            return true
        end}))
    end
end

function ease_sand_dollars(mod, instant)
    local function _mod(mod)
        local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
        mod = mod or 0
        local text = '+' .. localize('$')
        local col = FishAndChips.C.SAND_DOLLAR
        if mod < 0 then
            text = '-' .. localize('$')
            col = G.C.RED
        end
        --Ease from current chips to the new number of chips
        G.GAME.fac_sand_dollars = G.GAME.fac_sand_dollars + mod
        if mod > 0 then
            G.PROFILES[G.SETTINGS.profile].fac_fishing.career_sand_dollars = G.PROFILES[G.SETTINGS.profile].fac_fishing.career_sand_dollars + mod
        end
        check_for_unlock({type = 'fac_sand_dollars'})
        dollar_UI.config.object:update()
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        attention_text({
            text = text .. tostring(math.abs(mod)),
            scale = 0.8,
            hold = 0.7,
            cover = dollar_UI.parent,
            cover_colour = col,
            align = 'cm',
            font = SMODS.Fonts["fac_sand_dollars"]
        })
        --Play a chip sound
        play_sound('coin1')
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                _mod(mod)
                return true
            end
        }))
    end
end

SMODS.Font({
    key = "sand_dollars",
    path = "sand_dollars.ttf",
    FONTSCALE = 0.09,
    TEXT_OFFSET = { x = 0, y = 12 }
})

local use_and_sell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ret = use_and_sell(card)
    if card.ability.set == 'fac_Fish' then
        local sell = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card', handy_insta_action = 'sell'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
                    }},
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.55, shadow = true, font = SMODS.Fonts["fac_sand_dollars"]}},
                        {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
                    }}
                }}
            }},
        }}
        local use = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cm",padding = 0.1, r=0.08, minw = 1.25, minh = 0.8, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = 'fac_use_fish', func = "fac_can_use_fish", handy_insta_action = 'use'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "cm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = localize("b_use"), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                    }},
                }},
            }},
        }}
        ret = {
            n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                    {n=G.UIT.R, config={align = 'cl'}, nodes={
                        sell
                    }},
                    card.config.center.use and {n=G.UIT.R, config={align = 'cl'}, nodes={
                        use
                    }},
                }},
            }}
        end
        return ret
    end

    local can_sell_card = G.FUNCS.can_sell_card
    G.FUNCS.can_sell_card = function(e)
        can_sell_card(e)
        if e.config.ref_table.ability.set == 'fac_Fish' and e.config.ref_table:can_sell_card() then
            e.config.colour = FishAndChips.C.SAND_DOLLAR
            e.config.fac_ignore = true
            e.config.button = 'sell_card'
        else
            if G.hide_areas_again then
                e.config.fac_ignore = true
            else
                e.config.fac_ignore = nil
            end
        end
    end

    table.insert(SMODS.other_calculation_keys, 'sand_dollars')

    function add_round_eval_sand_dollars(config)
    local config = config or {}
    local width = G.round_eval.T.w - 0.51
    local num_dollars = config.sand_dollars or 1
    local scale = 0.9
    
    if not G.round_eval.divider_added then
    G.E_MANAGER:add_event(Event({
        trigger = 'after',delay = 0.25,
        func = function() 
            local spacer = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {'......................................'}, colours = {G.C.WHITE},shadow = true, float = true, y_offset = -30, scale = 0.45, spacing = 13.5, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
            }}
            G.round_eval:add_child(spacer,G.round_eval:get_UIE_by_ID('bonus_round_eval'))
            return true
        end
    }))
  end
    delay(0.6)
    G.round_eval.divider_added = true

    delay(0.2)

        G.E_MANAGER:add_event(Event({
            trigger = 'before',delay = 0.5,
            func = function()
                --Add the far left text and context first:
                local left_text = {}
                if config.name == 'sand_dollars' then
                  table.insert(left_text, {n=G.UIT.T, config={text = config.sand_dollars, font = config.font, scale = 0.8*scale, colour = FishAndChips.C.SAND_DOLLAR, shadow = true, juice = true}})
                  table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {" "..localize('k_fac_sand_dollar_cashout')}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
                elseif string.find(config.name, 'joker') then
                  table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = localize{type = 'name_text', set = config.card.config.center.set, key = config.card.config.center.key}, colours = {G.C.FILTER}, shadow = true, pop_in = 0, scale = 0.6*scale, silent = true})}})
                elseif string.find(config.name, 'tag') then
                    local blind_sprite = Sprite(0, 0, 0.7,0.7, G.ASSET_ATLAS[config.atlas], copy_table(config.pos))
                    blind_sprite:define_draw_steps({
                        {shader = 'dissolve', shadow_height = 0.05},
                        {shader = 'dissolve'}
                    })
                    blind_sprite:juice_up()
                    table.insert(left_text, {n=G.UIT.O, config={w=0.7,h=0.7 , object = blind_sprite, hover = true, can_collide = false}})
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {config.condition}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})    
                end
                    local full_row = {n=G.UIT.R, config={align = "cm", minw = 5}, nodes={
                    {n=G.UIT.C, config={padding = 0.05, minw = width*0.55, minh = 0.61, align = "cl"}, nodes=left_text},
                    {n=G.UIT.C, config={padding = 0.05,minw = width*0.45, align = "cr"}, nodes={{n=G.UIT.C, config={align = "cm", id = 'dollar_'..config.name},nodes={}}}}
                }}

                G.round_eval:add_child(full_row,G.round_eval:get_UIE_by_ID('bonus_round_eval'))
                play_sound('cancel', config.pitch or 1)
                play_sound('highlight1',( 1.5*config.pitch) or 1, 0.2)
                if config.card and config.card.juice_up then config.card:juice_up(0.7, 0.46) end
                return true
            end
        }))
        local dollar_row = 0
        if num_dollars > 60 then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',delay = 0.38,
                func = function()
                    G.round_eval:add_child(
                            {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..config.name}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = {localize('$')..num_dollars}, font = SMODS.Fonts["fac_sand_dollars"], colour = FishAndChips.C.SAND_DOLLAR, shadow = true, pop_in = 0, scale = 0.65, float = true})}}
                            }},
                            G.round_eval:get_UIE_by_ID('dollar_'..config.name))

                    play_sound('coin3', 0.9+0.2*math.random(), 0.7)
                    play_sound('coin6', 1.3, 0.8)
                    return true
                end
            }))
        else
            for i = 1, num_dollars or 1 do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',delay = 0.18 - ((num_dollars > 20 and 0.13) or (num_dollars > 9 and 0.1) or 0),
                    func = function()
                        if i%30 == 1 then 
                            G.round_eval:add_child(
                                {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..config.name}, nodes={}},
                                G.round_eval:get_UIE_by_ID('dollar_'..config.name))
                                dollar_row = dollar_row+1
                        end

                        local r = {n=G.UIT.T, config={text = localize('$'), font = SMODS.Fonts["fac_sand_dollars"], colour = FishAndChips.C.SAND_DOLLAR, scale = ((num_dollars > 20 and 0.28) or (num_dollars > 9 and 0.43) or 0.58), shadow = true, hover = true, can_collide = false, juice = true}}
                        play_sound('coin3', 0.9+0.2*math.random(), 0.7 - (num_dollars > 20 and 0.2 or 0))
                        
                        if config.name == 'blind1' then 
                            G.GAME.current_round.dollars_to_be_earned = G.GAME.current_round.dollars_to_be_earned:sub(2)
                        end

                        G.round_eval:add_child(r,G.round_eval:get_UIE_by_ID('dollar_row_'..(dollar_row)..'_'..config.name))
                        G.VIBRATION = G.VIBRATION + 0.4
                        return true
                    end
                }))
            end
        end

      G.GAME.current_round.fac_sand_dollars = G.GAME.current_round.fac_sand_dollars + config.sand_dollars

end
