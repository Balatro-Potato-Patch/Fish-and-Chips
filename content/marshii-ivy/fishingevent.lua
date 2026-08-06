local ivy_coloured = SMODS.Gradient {
    key = "ivy_coloured",
    colours = {
        HEX("ff9a2e"),
        HEX("ff6bfd"),
    }
}

PotatoPatchUtils.Developer({
	name = "ivy",
	colour = ivy_coloured,
    partner = "marshii",
})

-- PotatoPatchUtils.Developer({
-- 	name = "marshii",
-- 	colour = ,
-- })

FishAndChips.Fish {
    key = "stencil",
    ppu_coder = {"ivy"},
    ppu_artist = {"marshii"},
    weight = 67,
    environments = { -- i don't know if its allowed to have >1 environment with 1 so idk.
        wormhole = 1,
        backroom = 0.75,
    },
    stats = {
        weight = {min = 4/1000, max = 6/1000}, --it's paper
        length = {min = 29.7/100, max = 29.7/100} -- dimensions of a4 paper lol
    },
    config = {extra = {xmult = 1}},
    loc_vars = function(self, info_queue, card)
        local limit,count = G.fac_fish_area and G.fac_fish_area.config.card_limit or 5, G.fac_fish_area and G.fac_fish_area.config.card_count or 0
        return {vars = {
            card.ability.extra.xmult,
            1 + card.ability.extra.xmult * (limit - count)
        }}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {xmult = 1 + card.ability.extra.xmult * (G.fac_fish_area.config.card_limit - G.fac_fish_area.config.card_count)}
        end
    end,
    attributes = {"joker_slot", "xmult"}
}