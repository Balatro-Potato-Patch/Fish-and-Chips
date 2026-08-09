FishAndChips.Fish{
    key = "minty_kyriaki",
    atlas = "minty_fish",
    pos = {x=2, y=0},
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"Trauma Center devteam"},
    environments = { --Maximum 6
        styx = 10,
        backroom = 10,
        wormhole = 10,
        --[[
        calm_pond = 10,
        chocolate_river = 10,
        pier = 10,
        swamp = 10,
        aquifer = 10,
        volcano = 10,
        city_river = 10,
        soup = 10,
        garden = 10,
        --]]
    },
    attributes = {
        "xblindsize"
    },
    stats = {
        weight = { min = 0.02, max = 0.05},
        length = { min = 0.01, max = 0.02}
    },
    config = {
        extra = {
            xbs = 0.8
        }
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xbs
            }
        }
    end,
    calculate = function (self, card, context)
        if context.setting_blind or context.after then
            return {
                xblindsize = card.ability.extra.xbs,
                sound = "fac_minty_slash",
                message_card = G.GAME.blind
            }
        end

        if context.joker_type_destroyed and context.card == card then
            return {
                message = "Defeat",
                sound = "fac_minty_defeat"
            }
        end
    end
}