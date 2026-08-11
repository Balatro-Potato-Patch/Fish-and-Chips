FishAndChips.Fish {
    key = "blamperer_clout",
    atlas = "blamperer_fitch",
    pos = { x = 5, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "economy", "fac_perfect_catch"
    },
    config = {
        extra = {
            -- BALANCE:
            -- Original idea was 2X [2-8 -> 4-16]
            -- 2.5X [2-8 -> 5-20]
            -- 1.5X [2-8 -> 3-12]
            -- Pick based on perceived difficulty of perfect catch + treasure
            multiplier = 2.5
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.multiplier }
        }
    end,
    stats = {
        weight = { min = 2.7, max = 18.8 },
        length = { min = 0.3, max = 1.11 },
    },
    weight = 5,
    environments = {
        city_river = 5,
        wormhole = 10
    },
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.fac_treasure_reward_type and G.FAC_FISH_GAME.perfect and not context.blueprint then
            return { modify = math.floor(context.fac_treasure_reward * card.ability.extra.multiplier) }
        end
    end
}
