FishAndChips.Fish {
    key = "blamperer_atlas",
    atlas = "fitch",
    pos = { x = 6, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "chips", "scaling"
    },
    config = {
        extra = {
            -- BALANCE: Adjust this. I think 10 chips per 5 dollars and possibly 1 bait is reasonable,
            -- but with the right economy and skill this can scale ridiculously fast. Could add a limit per round?
            chip_gain = 10,
            chips = 0,
            last_catch_environment = ""
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { SMODS.signed(card.ability.extra.chip_gain), SMODS.signed(card.ability.extra.chips) }
        }
    end,
    stats = {
        weight = { min = 0.45, max = 5.44 },
        length = { min = 0.27, max = 0.47 },
    },
    weight = 8,
    environments = {
        pier = 5,
        backroom = 5,
        swamp = 2
    },
    badge_key = "k_fac_blamperer_junk",
    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end

        if context.fac_end_fishing and not context.failed and not context.blueprint then
            local this_environment_key = FishAndChips.get_environment().key
            if this_environment_key ~= card.ability.extra.last_catch_environment then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "chips",
                    scalar_value = "chip_gain",
                    scaling_message = {
                        message = localize("k_upgrade_ex"),
                        colour = G.C.CHIPS
                    }
                })
                card.ability.extra.last_catch_environment = this_environment_key
            end
        end
    end
}
