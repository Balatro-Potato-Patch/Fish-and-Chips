-- TOTAL WEIGHT USED
-- 10 + 10 + 7 + 5 + 5 = 37

FishAndChips.Fish {
    key = "yellow_pikman",
    atlas = "meta_fish",
    pos = { x = 0, y = 0 },
    weight = 10,
    environments = {
        swamp = 10,
        aquifer = 5,
        garden = 7,
        backroom = 2
    },
    attributes = { "chips" },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    config = {
        extra = {
            chips = 0,
            chip_gain = 5
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end

        if context.post_trigger and context.other_card.area == G.fac_fish_area then
            local me_index = 0
            local you_index = 0
            for i, v in ipairs(G.fac_fish_area.cards) do
                if v == card then me_index = i end
                if v == context.other_card then you_index = i end
            end
            if me_index > 0 and you_index > 0 and math.abs(me_index - you_index) == 1 then
                return { func = function()
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "chips",
                        scalar_value = "chip_gain",
                        message_key = "a_chips",
                        message_colour = G.C.CHIPS
                    })
                end }
            end
        end

        -- add trigger to scale when a fish is used here
    end
}

FishAndChips.Fish {
    key = "froggy",
    atlas = "meta_fish",
    pos = { x = 2, y = 0 },
    weight = 10,
    environments = {
        calm_pond = 10,
        pier = 5,
        swamp = 5,
        city_river = 5
    },
    attributes = { "xmult" },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    config = {
        extra = {
            xmult = 1,
            xmult_gain = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end

        if context.end_of_round and context.main_eval then
            if SMODS.pseudorandom_probability(card, "froggy_wander", card.ability.extra.xmult - 1, 9, "fac_froggy_wander") then
                SMODS.destroy_cards(card, { skip_anim = true })
                return {
                    message = localize("fac_froggy_croak"),
                    colour = G.C.GREEN
                }
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xmult",
                    scalar_value = "xmult_gain",
                    message_key = "a_xmult",
                    message_colour = G.C.MULT
                })
                return nil, true
            end
        end
    end
}

FishAndChips.Fish {
    key = "tripod",
    atlas = "meta_fish",
    pos = { x = 3, y = 0 },
    weight = 7,
    environments =  {
        styx = 7,
        pier = 7,
        aquifer = 7
    },
    attributes = { "generation" },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    calculate = function(self, card, context)
        if context.before and context.scoring_name == "Three of a Kind" then
            local to_copy = pseudorandom_element(context.scoring_hand, "tripod_select")
            local copy = SMODS.copy_card(to_copy, { area = G.hand })

            local edition = SMODS.poll_edition { key = "tripod_edition", no_negative = true, guaranteed = true }
            local enh = SMODS.poll_enhancement { key = "tripod_enh", guaranteed = true }
            local seal = SMODS.poll_seal { key = "tripod_seal", guaranteed = true }

            copy:set_ability(enh or "c_base")
            copy:set_edition(edition)
            copy:set_seal(seal)

            return {
                message = localize("k_copied_ex"),
                colour = FishAndChips.C.FISH
            }
        end
    end
}

-- ts rotates me
local card_draw_ref = Card.draw
Card.draw = function(card, layer, ...)
    if card.config and card.config.center and card.config.center.key == "fish_fac_ol_baron" then
        card.VT.r = card.VT.r + math.pi / 2
        for i, v in pairs(card.children) do
            v.VT.r = v.VT.r + math.pi / 2
        end
    end

    card_draw_ref(card, layer, ...)
    if card.config and card.config.center and card.config.center.key == "fish_fac_ol_baron" then
        card.VT.r = card.VT.r - math.pi / 2
        for i, v in pairs(card.children) do
            v.VT.r = v.VT.r - math.pi / 2
        end
    end
end

FishAndChips.Fish {
    key = "ol_baron",
    atlas = "meta_fish",
    pos = { x = 0, y = 1 },
    weight = 5,
    environments = {
        swamp = 2,
        aquifer = 5
    },
    attributes = { "xmult" },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    config = {
        extra_slots_used = 1,
        extra = {
            xmult = 0.2
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            return {
                xmult = 1 + (card.ability.extra.xmult * #context.scoring_hand)
            }
        end
    end
}
FishAndChips.Fish {
    key = "tsuchinoko",
    atlas = "meta_fish",
    pos = { x = 1, y = 0 },
    weight = 5,
    environments = {
        wormhole = 1
    },
    treasure = true,
    attributes = { "usable" },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    impulse_min = 0.01,
    impulse_max = 0.6,
    decision_min = 0.01,
    decision_max = 0.4,

    can_use = function() return true end,
    use = function(self, card, area)
        G.GAME.fac_meta.tsuchi_bonus = G.GAME.fac_meta.tsuchi_bonus + 1
        SMODS.calculate_effect( {
            message = "Yum!",
            colour = FishAndChips.C.SAND_DOLLAR
        }, card)
    end
}
