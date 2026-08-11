local SECONDS_PER_MINUTE = 60
FishAndChips.Fish {
    key = "blamperer_timer",
    atlas = "blamperer_fitch",
    pos = { x = 2, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "economy"
    },
    config = {
        extra = {
            sandollars = 1,
            -- The average rod counts 4.25 seconds to catch a fish, discounting any effect of the fish's size
            -- since we're only counting time when the decay is active (e.g. progress is already above the decay threshold)
            -- (100% - 15%) / 20%/s = 4.25s
            -- This is good because it's not really *meant* to give 1 sand dollar per fish caught, you really gotta work for it.
            -- Fiberglass Rod takes about 7, but whatever.
            seconds = 5,
            time = 0
        },
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.sandollars,
                card.ability.extra.seconds,
                math.floor(SECONDS_PER_MINUTE / card.ability.extra.seconds)
            }
        }
    end,
    stats = {
        weight = { min = 0.018, max = 30.4 },
        length = { min = 0.1, max = 0.66 },
    },
    weight = 7,
    environments = {
        backroom = 11,
        aquifer = 7,
        city_river = 5
    },
    blueprint_compat = false,
    badge_key = "k_fac_maybe_fish",
    calculate = function(self, card, context)
        if context.fac_end_fishing and not context.blueprint then
            local reward = math.floor(math.min(SECONDS_PER_MINUTE, G.GAME.blamperer_hook_time) / card.ability.extra.seconds)
            if reward > 0 then
                return { sand_dollars = reward }
            end
        end
    end
}
