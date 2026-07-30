FishAndChips.Fish {
    key = "blamperer_perfish",
    atlas = "fitch",
    pos = { x = 1, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "economy"
    },
    config = {
        extra = {
            best_streak = 0,
            current_streak = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                math.max(0, 2 * card.ability.extra.best_streak - 1),
                card.ability.extra.best_streak
            }
        }
    end,
    cost = 4,
    weight = 3,
    environments = {
        pier = 10,
        garden = 5
    },
    calculate = function(self, card, context)
        if context.fac_end_fishing then
            if not context.failed then
                if G.FAC_FISH_GAME.perfect then
                    local msg_colour = G.C.BLUE
                    card.ability.extra.current_streak = card.ability.extra.current_streak + 1
                    if card.ability.extra.current_streak > card.ability.extra.best_streak then
                        card.ability.extra.best_streak = card.ability.extra.current_streak
                        msg_colour = G.C.GOLD
                    end
                    return {
                        message = localize {
                            type = "variable",
                            key = "a_fac_blamperer_str_gain",
                            vars = { card.ability.extra.current_streak }
                        },
                        colour = msg_colour
                    }
                elseif card.ability.extra.current_streak > 0 then
                    card.ability.extra.current_streak = 0
                    return {
                        message = localize("k_fac_blamperer_str_broke"),
                        colour = G.C.RED
                    }
                end
            else
                card.ability.extra.current_streak = 0
                return {
                    message = localize("k_fac_blamperer_str_broke"),
                    colour = G.C.RED
                }
            end
        end

        if context.ending_fishing and card.ability.extra.best_streak > 0 then
            return { dollars = math.max(0, 2 * card.ability.extra.best_streak - 1) }
        end
    end
}
