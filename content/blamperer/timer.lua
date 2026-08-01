FishAndChips.Fish {
    key = "blamperer_timer",
    atlas = "fitch",
    pos = { x = 2, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "economy"
    },
    config = {
        extra = {
            sandollars = 1,
            seconds = 5,
            time = 0
        },
        immutable = {
            maximum = 12
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sandollars, card.ability.extra.seconds, card.ability.immutable.maximum } }
    end,
    weight = 6,
    environments = {
        backroom = 11,
        aquifer = 7,
        city_river = 5
    },
    calculate = function(self, card, context)
        if context.fac_end_fishing then
            local reward = math.min(card.ability.immutable.maximum, math.floor(G.GAME.blamperer_hook_time / card.ability.extra.seconds))
            if reward > 0 then
                return { sand_dollars = reward }
            end
        end
    end
}
