-- Lapis Catfish
FishAndChips.Fish {
    key = "lapis_catfish",
    atlas = "seabunny",
    pos = {x = 4, y = 0},
    config = {extra = {percent = 25, delta = 5, max = 100, num = 1, denom = 3}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {vars = {card.ability.extra.percent, card.ability.extra.delta, card.ability.extra.max}, key = self.key .. "_enchant"}
        end
        local num, denom = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, "fac_lapis_catfish")
        return {vars = {card.ability.extra.percent, card.ability.extra.delta, card.ability.extra.max, num, denom}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                message = localize("k_balanced"),
                colour = {0.8, 0.45, 0.85, 1},
                func = function()
                    local chips = SMODS.Scoring_Parameters.chips
					local mult = SMODS.Scoring_Parameters.mult
					local chip_mod = chips.current * card.ability.extra.percent / 200
					local mult_mod = mult.current * card.ability.extra.percent / 200
					chips.current = chips.current * (1 - card.ability.extra.percent / 200)
					chips:modify(mult_mod)
					mult.current = mult.current * (1 - card.ability.extra.percent / 200)
					mult:modify(chip_mod)
                    G.E_MANAGER:add_event(Event{func = function()
                        play_sound("gong", 0.94, 0.3)
                        play_sound("gong", 0.94 * 1.5, 0.2)
                        play_sound("tarot1", 1.5)
                        ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                        ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                        G.E_MANAGER:add_event(Event{trigger = "after", blockable = false, blocking = false, delay = 0.8, func = function()
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
                            ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                            return true end})
                        G.E_MANAGER:add_event(Event{trigger = "after", blockable = false, blocking = false, no_delete = true, delay = 1.3, func = function()
                            G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true end})
                        return true end})
                end
            }
        elseif not context.blueprint then
            if context.end_of_round and context.main_eval then
                SMODS.scale_card (card, {
                    ref_value = "percent",
                    scalar_value = "delta",
                    operation = card.ability.extra.enchant and "+" or "-",
                    message_key = card.ability.extra.enchant and "a_fac_seabunny_percent_plus" or "a_fac_seabunny_percent_minus"
                })
                if card.ability.extra.percent <= 0 then
                    SMODS.destroy_cards(card, {pinch_anim = true})
                    return {
                        message = localize("k_fac_seabunny_eroded"),
                        colour = G.C.BLUE
                    }
                end
                if card.ability.extra.percent >= card.ability.extra.max then
                    card.ability.extra.percent = card.ability.extra.max
                end
                return nil, true
            elseif context.selling_card and context.card.ability.set == "fac_Fish" and G.GAME.blind.in_blind and not card.ability.extra.enchant and SMODS.pseudorandom_probability(card, "fac_lapis_catfish", card.ability.extra.num, card.ability.extra.denom) then
                SEABUN.enchant(card)
            end
        end
    end,
    weight = 4,
    attributes = {"balance", "scaling", "chance", "on_sell",},
    environments = {
        pier = 20,
        aquifer = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 3, max = 5},
        length = {min = 0.7, max = 0.95}
    }
}
