-- Skyfish
FishAndChips.Fish {
    key = "skyfish",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {max = 1, shrink = 0.1}},
    blueprint_compat = false,
    decision_min = 0,
    decision_max = 0.24,
    disable_visual_scaling = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.max, 100 * card.ability.extra.shrink}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            local prev_l = card.ability.stats.length
            card.ability.stats.length = math.min(2 * card.ability.stats.length, card.ability.extra.max)
            return {
                message = localize{type = "variable", key = "a_cm", vars = {100 * (card.ability.stats.length - prev_l)}}
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
        G.E_MANAGER:add_event(Event {
            func = function()
                local bait = SMODS.create_card{key = "bait_fac_normal"}
                G.fac_temp_bait_area:emplace(bait)
                FishAndChips.add_bait_to_inventory(bait.config.center.key)
                return true end })
        delay(3.2)
        G.E_MANAGER:add_event(Event {
            func = function()
                G.fac_temp_bait_area.cards[1]:start_dissolve()
                return true end })
        delay(0.7)
        card.ability.stats.length = card.ability.stats.length - card.ability.extra.shrink
    end,
    can_use = function(self, card)
        return true
    end,
    keep_on_use = function(self, card)
        return card.ability.stats.length > card.ability.extra.shrink
    end,
    weight = 75,
    environments = {
        calm_pond = 20,
        pier = 20,
        swamp = 50,
        city_river = 10,
        backroom = 10,
    },
    attributes = {"economy", "usable", "generation"},
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 0, max = 0},
        length = {min = 0.1, max = 0.2}
    }
}