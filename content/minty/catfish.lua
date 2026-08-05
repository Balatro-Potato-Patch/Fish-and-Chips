FishAndChips.Fish{
    key = "minty_catfish",
    --[[
    atlas = "minty_fish",
    pos = {x=20, y=0},
    --]]
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"?"},
    environments = { --Maximum 6
        calm_pond = 10,
        city_river = 10,
        chocolate_river = 1,
        soup = 1,
        --[[
        styx = 10,
        pier = 10,
        swamp = 10,
        aquifer = 10,
        volcano = 10,
        garden = 10,
        backroom = 10,
        wormhole = 10,
        --]]
    },
    attributes = {
        "passive", "mod_chance"
    },
    stats = {
        weight = { min = 0.9, max = 18.3}, --In kilograms
        length = { min = 0.3, max = 2}, --In meters
    },
    config = {
        extra = {
            oddshelp = 2
        },
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.oddshelp,
                math.max(5 - card.ability.extra.oddshelp, 1)
            }
        }
    end,
    calculate = function (self, card, context)
        if context.mod_probability then
            return {
                denominator = math.max(context.denominator - card.ability.extra.oddshelp, 1)
            }
        end
    end,
}