-- Skyfish
FishAndChips.Fish {
    key = "skyfish",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {max = 1, shrink = 0.1}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_uma",
    decision_min = 0,
    decision_max = 0.24,
    disable_visual_scaling = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.max, 100 * card.ability.extra.shrink}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local prev_l = card.ability.stats.length
            card.ability.stats.length = math.min(2 * card.ability.stats.length, card.ability.extra.max)
            return {
                message = localize{type = "variable", key = "a_fac_seabunny_cm", vars = {100 * (card.ability.stats.length - prev_l)}}
            }
        end
    end,
    use = function(self, card, area)
        local w = (G.CARD_W + 0.1) * 2 - 0.1
		local h = G.CARD_H
		G.fac_temp_bait_area = CardArea(
			card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
			w, h, {
				type = "joker",
				card_limit = 1,
				highlight_limit = 1,
				highlighted_limit = 1,
				align_buttons = true,
				bg_colour = G.C.CLEAR,
				fixed_limit = true,
				no_card_count = true,
			}
		)
		delay(1)
        G.E_MANAGER:add_event(Event{func = function()
            local bait = SMODS.create_card{key = "bait_fac_normal"}
            G.fac_temp_bait_area:emplace(bait)
            FishAndChips.add_bait_to_inventory(bait.config.center.key)
            return true end})
        delay(2)
        G.E_MANAGER:add_event(Event{func = function()
            G.fac_temp_bait_area.cards[1]:start_dissolve()
            return true end})
        delay(0.7)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.fac_temp_bait_area:remove()
                return true
            end
        }))
        card.ability.stats.length = card.ability.stats.length - card.ability.extra.shrink
    end,
    can_use = function(self, card)
        return true
    end,
    keep_on_use = function(self, card)
        return card.ability.stats.length >= 2 * card.ability.extra.shrink
    end,
    weight = 4,
    attributes = {"usable", "generation"},
    environments = {
        calm_pond = 20,
        swamp = 50,
        backroom = 10,
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 0, max = 0},
        length = {min = 0.1, max = 0.2}
    },
    draw = function(self, card, layer)
        if card.ability.stats then
            for i = 2, 10 do
                local key = "segment" .. i
                if card.children[key] then
                    if card.ability.stats.length * 10 < i then
                        card.children[key]:remove()
                        card.children[key] = nil
                    elseif not card._fac_bucketed then
                        local x = (1 - i) * card.T.w * 31 / 71
                        card.children[key]:draw_shader("dissolve", 0, nil, nil, card.children.center, card.VT.scale * (1 - 0.2 * card.shadow_height) - 1, nil, x - card.shadow_parrallax.x * card.shadow_height, -card.shadow_parrallax.y * card.shadow_height)
                        card.children[key]:draw_shader("dissolve", nil, nil, nil, card.children.center, card.VT.scale - 1, nil, x)
                    end
                elseif card.ability.stats.length * 10 >= i then
                    card.children[key] = SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, card.children.center.atlas, card.children.center.sprite_pos)
                    card.children[key].states.hover = card.states.hover
                    card.children[key].states.click = card.states.click
                    card.children[key].states.drag = card.states.drag
                    card.children[key].states.collide.can = true
                    card.children[key].custom_draw = true
                end
            end
        end
    end
}
