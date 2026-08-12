local felli_colours = SMODS.Gradient {
    key = "felli",
    colours = {
        HEX("ff9a2e"),
        HEX("ff6bfd"),
    }
}

SMODS.Gradient {
    key = "ivy_orange",
    colours = {
        HEX("ff9a2e"),
        HEX("ff9a2e"),
    }
}

SMODS.Gradient {
    key = "may_pink",
    colours = {
        HEX("ff6bfd"),
        HEX("ff6bfd"),
    }
}

local marshii_colour = SMODS.Gradient {
    key = "marshii_colour",
    colours = {
        HEX("c8a8ff"),
        HEX("f2a8ff"),
    }
}

SMODS.Atlas {
    key = "ivy_may_credits",
    path = "marshii-ivy/ivy_may.png",
    px = 71,
    py = 95,
}

PotatoPatchUtils.Developer({
    name = "ivy",
    fac_partner = "fac_marshii",
    atlas = "fac_ivy_may_credits",
    colour = felli_colours,
    loc = true,
})

SMODS.Atlas {
    key = "marshii_credits",
    path = "marshii-ivy/marshii.png",
    px = 71,
    py = 95,
}

PotatoPatchUtils.Developer({
    name = "marshii",
    fac_partner = "fac_ivy",
    atlas = "fac_marshii_credits",
    pos = {x=0, y=0},
    colour = marshii_colour,
    loc = true,
})

local cuhook = Card.update -- i deeply apologize for hooking update you can put me on the stake and kill me if you want
function Card:update(...) --hey, marshii here below. #watdatmean. all I know is that it works
    cuhook(self, ...)
    if self.ppu_member and self.ppu_member.key == "fac_marshii" then
        self.children.center:set_sprite_pos({x=self.states.hover.is and 1 or 0, y=0})
    end
end

SMODS.Atlas {
    key = "ivy-tsnefish",
    path = "marshii-ivy/tsnefish.png",
    px = 95, -- intentional
    py = 71,
}

SMODS.Atlas {
    key = "marshii-chud-fishies",
    path = "marshii-ivy/chud_fucking_fish.png",
    px = 71,
    py = 95,
}

FishAndChips.Fish {
    key = "stencil",
    ppu_coder = { "ivy" },
    ppu_artist = { "marshii" }, --:chud:
    atlas = "marshii-chud-fishies",
    pos = { x = 0, y = 0 },
    weight = 10,
    environments = { -- i don't know if its allowed to have >1 environment with 1 so idk.
        wormhole = 1,
        backroom = 0.75,
    },
    stats = {
        weight = { min = 4 / 1000, max = 6 / 1000 },    --it's paper
        length = { min = 29.7 / 100, max = 29.7 / 100 } -- dimensions of a4 paper lol
    },
    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local limit, count = G.fac_fish_area and G.fac_fish_area.config.card_limit or 5,
            G.fac_fish_area and G.fac_fish_area.config.card_count or 0
        return {
            vars = {
                card.ability.extra.xmult,
                1 + card.ability.extra.xmult * (limit - count)
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = 1 +
                    card.ability.extra.xmult * (G.fac_fish_area.config.card_limit - G.fac_fish_area.config.card_count)
            }
        end
    end,
    attributes = { "joker_slot", "xmult" }
}

FishAndChips.Fish {
    key = "tsnefish", -- this [not equal] fish
    ppu_coder = { "ivy" },
    ppu_artist = { "ivy" },
    weight = 10,
    environments = { -- fis
        city_river = 1,
        wormhole = 0.2,
    },
    stats = {
        weight = { min = 4 / 10, max = 6 / 10 },          --it's canvas
        length = { min = 81.12 / 100, max = 81.12 / 100 } -- 81.12cm is the width of the original painting
    },
    config = { extra = { used = false } },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.used = false
        end
    end,
    can_use = function(self, card)
        local other_fish = false
        for _, fih in pairs(G.fac_fish_area.cards) do
            if fih.config.center.set == "fac_Fish" and fih ~= card then
                other_fish = true
            end
        end
        return not card.ability.extra.used and other_fish
    end,
    use = function(self, card)
        card.ability.extra.used = true
        local other_fish = {}
        for _, fih in pairs(G.fac_fish_area.cards) do
            if fih.config.center.set == "fac_Fish" and fih ~= card then
                table.insert(other_fish, fih)
            end
        end
        local not_a_fish = pseudorandom_element(other_fish, "ivy_fac_tsnefish")
        not_a_fish:set_ability(SMODS.poll_object { type = "Joker", seed = "ivy_fac_tsnefish_roll" })
        not_a_fish:juice_up()
    end,
    keep_on_use = function(self, card)
        return true
    end,
    attributes = {},
    atlas = "ivy-tsnefish",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 95, h = 71 },
    display_size = { w = 95, h = 71 },
    set_card_type_badge = function(self, card, badges)
        table.insert(badges, create_badge(localize("k_ivy_not_a_fish"), G.C.SET.fac_Fish))
    end,
    attributes = { "modify_card", "usable", "joker" }
}

FishAndChips.Fish {
    key = "thefuckingabstractone",
    ppu_coder = { "ivy" },
    ppu_artist = { "marshii" },
    atlas = "marshii-chud-fishies",
    pos = { x = 1, y = 0 },
    weight = 10,
    environments = { -- i
        city_river = 0.6,
        backroom = 1,
    },
    stats = {
        weight = { min = 1.2, max = 2.4 },
        length = { min = 0.7, max = 1.6 }
    },
    config = { extra = { mult = 0, scaleby = 1, hatred = -5 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.scaleby,
                -card.ability.extra.hatred,
                card.ability.extra.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing then
            if context.failed then
                SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "mult", scalar_value = "hatred" })
                card.ability.extra.mult = math.max(0, card.ability.extra.mult)
            else
                SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "mult", scalar_value = "scaleby" })
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    attributes = { "scaling", "mult" }
}

FishAndChips.Fish {
    key = "fishbone_dagger",
    ppu_coder = { "ivy" },
    ppu_artist = { "marshii" },
    atlas = "marshii-chud-fishies",
    pos = { x = 2, y = 0 },
    weight = 10,
    environments = { -- i
        swamp = 1.0,
        volcano = 0.7,
        aquifer = 0.7,
        styx = 0.4,
    },
    stats = {
        weight = { min = 1.2, max = 2.4 },
        length = { min = 0.7, max = 1.6 }
    },
    config = { extra = { chips = 0 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.chips
        }}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local fisharea = card.area
            local index = nil
            for i, ifish in ipairs(fisharea.cards) do
                if ifish == card then
                    index = i
                end
            end
            local sliced = fisharea.cards[index + 1]
            if (not sliced) or (SMODS.is_eternal(sliced)) or (sliced.getting_sliced) then
                return
            end

            -- thank you N' for vanillaremade so i could save 90 seconds writing this myself
            sliced.getting_sliced = true
            G.GAME.joker_buffer = G.GAME.joker_buffer - 1
            local new_chips = card.ability.extra.chips + sliced.sell_cost * 10
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.joker_buffer = 0
                    card.ability.extra.chips = new_chips
                    card:juice_up(0.8, 0.8)
                    sliced:start_dissolve({ G.C.CHIPS }, nil, 1.6)
                    play_sound('slice1', 0.96 + math.random() * 0.08)
                    return true
                end
            }))
            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { new_chips } },
                colour = G.C.CHIPS,
                no_juice = true
            }
        end

        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
    attributes = { "scaling", "chips", "destroy_card" }
}