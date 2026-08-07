-- Lapis Catfish
FishAndChips.Fish {
    key = "lapis_catfish",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {enchant = false, percent = 25, delta = 5, max = 100, num = 1, denom = 3}},
    blueprint_compat = true,
    badge_key = "k_fac_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {vars = {card.ability.extra.percent, card.ability.extra.delta, card.ability.extra.max}, key = self.key .. "_enchant"}
        end
        local num, denom = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, "fac_lapis_catfish")
        return {vars = {card.ability.extra.percent, card.ability.extra.delta, card.ability.extra.max, num, denom}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local coef = card.ability.extra.percent / 100
            local add = (mult + hand_chips) * coef / 2
            hand_chips = hand_chips * (1 - coef) + add
            mult = mult * (1 - coef) + add
            return {
                message = localize("k_balanced"),
                colour = {0.8, 0.45, 0.85, 1},
                func = function()
                    G.E_MANAGER:add_event(Event{func = function()
                        play_sound("gong", 0.94, 0.3)
                        play_sound("gong", 0.94 * 1.5, 0.2)
                        play_sound("tarot1", 1.5)
                        ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                        ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                        G.E_MANAGER:add_event(Event{trigger = "after", blockable = false, blocking = false, delay =  0.8, func = function()
                            ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
                            ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                            return true end})
                        G.E_MANAGER:add_event(Event{trigger = "after", blockable = false, blocking = false, no_delete = true, delay =  1.3, func = function()
                            G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true end})
                        return true end})
                end
            }
        elseif not context.blueprint then
            if context.end_of_round and context.main_eval then
                local mod
                if card.ability.extra.enchant then
                    mod = math.min(card.ability.extra.delta, card.ability.extra.max - card.ability.extra.percent)
                else
                    mod = -card.ability.extra.delta
                end
                card.ability.extra.percent = card.ability.extra.percent + mod
                if card.ability.extra.percent <= 0 then
                    SMODS.destroy_cards(card, {pinch_anim = true})
                    return {
                        message = localize("k_fac_eroded"),
                        colour = G.C.BLUE
                    }
                end
                return {
                    message = localize{type = "variable", key = mod < 0 and "a_percent" or "a_percent_plus", vars = {mod}}
                }
            elseif context.selling_card and context.card.ability.set == "fac_Fish" and G.GAME.blind.in_blind and not card.ability.extra.enchant and SMODS.pseudorandom_probability(card, "fac_lapis_catfish", card.ability.extra.num, card.ability.extra.denom) then
                SEABUN.enchant(card)
            end
        end
    end,
    weight = SEABUN.weight,
    attributes = {"mult", "chips"},
    environments = {
        -- TODO
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 0, max = 0}, -- TODO
        length = {min = 0, max = 0} -- TODO
    }
}