SMODS.Atlas({
    key = "sg11_n_vekhi_diamond_fish",
    path = "sg11_n_vekhi/diamond_fish.png",
    px = 71,
    py = 95,
})

FishAndChips.Fish({
    key = "sg11_n_vekhi_diamond_fish",
    atlas = "fac_sg11_n_vekhi_diamond_fish",
    pos = { x = 0, y = 0 },
    ppu_coder = { "sleepyg11" },
    ppu_artist = { "vevekhi" },
    attributes = {
        "enhancements",
        "economy",
    },
    config = {
        extra = {
            dollars = 5,
        },
    },
    treasure = true,
    weight = 11,
    stats = {
        weight = { min = 0.75, max = 1.2 },
        length = { min = 0.4, max = 0.6 },
    },
    environments = {
        volcano = 8,
        aquifer = 6,
        calm_pond = 2,
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
        return {
            vars = { card.ability.extra.dollars },
        }
    end,
    calculate = function(self, card, context)
        if context.after then
            for k, v in pairs(context.scoring_hand) do
                if SMODS.has_enhancement(v, "m_glass") and not v.shattered then
                    return {
                        dollars = card.ability.extra.dollars,
                    }
                end
            end
        end
    end,
})
