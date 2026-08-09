local ivy_coloured = SMODS.Gradient {
    key = "ivy_coloured",
    colours = {
        HEX("ff9a2e"),
        HEX("ff6bfd"),
    }
}

PotatoPatchUtils.Developer({
	name = "ivy",
    fac_partner = "fac_marshii",
    loc = true,
})

PotatoPatchUtils.Developer({
	name = "marshii",
    fac_partner = "fac_ivy",
})

FishAndChips.Fish {
    key = "stencil",
    ppu_coder = {"ivy"},
    ppu_artist = {"marshii"},
    weight = 10,
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

SMODS.Atlas {
    key = "ivy-tsnefish",
    path = "marshii-ivy/tsnefish.png",
    px = 95, -- intentional
    py = 71,
}

FishAndChips.Fish {
    key = "tsnefish", -- this [not equal] fish
    ppu_coder = {"ivy"},
    ppu_artist = {"ivy"},
    weight = 10,
    environments = { -- fis
        city_river = 1,
        wormhole = 0.2,
    },
    stats = {
        weight = {min = 4/10, max = 6/10}, --it's canvas
        length = {min = 81.12/100, max = 81.12/100} -- 81.12cm is the width of the original painting
    },
    config = {extra = {used = false}},
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.used = false
        end
    end,
    can_use = function(self, card)
        local other_fish = false
        for _,fih in pairs(G.fac_fish_area.cards) do
            if fih.config.center.set == "fac_Fish" and fih ~= card then
                other_fish = true
            end
        end
        return not card.ability.extra.used and other_fish
    end,
    use = function(self, card)
        card.ability.extra.used = true
        local other_fish = {}
        for _,fih in pairs(G.fac_fish_area.cards) do
            if fih.config.center.set == "fac_Fish" and fih ~= card then
                table.insert(other_fish, fih)
            end
        end
        local not_a_fish = pseudorandom_element(fih, "ivy_fac_tsnefish")
        not_a_fish:set_ability(SMODS.poll_object{type = "Joker", seed = "ivy_fac_tsnefish_roll"})
        not_a_fish:juice_up()
    end,
    attributes = {},
    atlas = "ivy-tsnefish",
    pos = {x = 0, y = 0},
    pixel_size = {w = 95, h = 71},
    display_size = {w = 95, h = 71},
    set_card_type_badge = function (self, card, badges)
        table.insert(badges, create_badge(localize("k_ivy_not_a_fish"), G.C.SET.fac_Fish))
    end
}