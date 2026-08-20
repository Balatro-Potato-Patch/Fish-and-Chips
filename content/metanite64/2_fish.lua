-- TOTAL WEIGHT USED
-- 10 + 10 + 7 + 5 + 5 + 10 + 8 + 10 + 5 = 70

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
    stats = {
        weight = { min = 0.0005, max = 0.0015 },
        length = { min = 0.008, max = 0.016 }
    },
    attributes = { "chips", "scaling", "position", },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    config = {
        extra = {
            chips = 0,
            chip_gain = 2
        }
    },

    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chip_gain, card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { chips = card.ability.extra.chips }
        end

        if context.post_trigger and context.other_card.area == G.fac_fish_area and not context.blueprint then
            local fish = context.fac_use_fish or context.other_card
            local me_index = 0
            local you_index = 0
            for i, v in ipairs(G.fac_fish_area.cards) do
                if v == card then me_index = i end
                if v == fish then you_index = i end
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
    stats = {
        weight = { min = 0.02, max = 1 },
        length = { min = 0.01, max = 0.05 }
    },
    attributes = { "xmult", "chance", },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    config = {
        extra = {
            xmult = 1,
            xmult_gain = 1,
            denominator = 9
        }
    },

    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult, card.ability.extra.xmult - 1, card.ability.extra.denominator } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult }
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, "froggy_wander", card.ability.extra.xmult - 1, card.ability.extra.denominator, "fac_froggy_wander") then
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
    stats = {
        weight = { min = 0.8, max = 1.4 },
        length = { min = 0.20, max = 0.45 }
    },
    attributes = { "generation", "hand_type", "enhancements", "editions", "seals", },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    blueprint_compat = true,

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
    stats = {
        weight = { min = 18, max = 30 },
        length = { min = 1.3, max = 1.7 }
    },
    attributes = { "xmult", "fac_fish_slot", },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    config = {
        extra_slots_used = 1,
        extra = {
            xmult = 0.2
        }
    },

    blueprint_compat = true,

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
    key = "ankhovy",
    atlas = "meta_fish",
    pos = { x = 1, y = 1 },
    weight = 5,
    environments = {
        styx = 5,
        volcano = 5,
        backroom = 5,
        wormhole = 3
    },
    stats = {
        weight = { min = 0.025, max = 0.05 },
        length = { min = 0.02, max = 0.4 }
    },
    attributes = { "usable", "generation", "destroy_card" },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    draw = function(self, card, layer)
        local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[card.key] or {}
        if not (card.area and card.area.config and card.area.config.fac_compendium) or fish_data.times_caught and fish_data.times_caught > 0 then
            card.children.center:draw_shader("booster", nil, card.ARGS.send_to_shader)
        end
    end,

    can_use = function()
        return G.fac_fish_area and #G.fac_fish_area.cards > 1 and #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit
    end,

    use = function(self, card, area)
        local copyable_fish = {}
        local deletable_fish = {}
        for _, fish in ipairs(G.fac_fish_area.cards) do
            if fish ~= card then
                copyable_fish[#copyable_fish + 1] = fish
                if not SMODS.is_eternal(fish, true) then
                    deletable_fish[#deletable_fish + 1] = fish
                end
            end
        end

        local to_copy = pseudorandom_element(copyable_fish, "ankhovy_copy")
        local first_dissolve = nil
        G.E_MANAGER:add_event(Event {
            trigger = "before",
            delay = 0.75,
            func = function()
                for _, fish in ipairs(deletable_fish) do
                    if fish ~= to_copy then
                        fish:start_dissolve(nil, first_dissolve)
                        first_dissolve = true
                    end
                end
                return true
            end
        })
        G.E_MANAGER:add_event(Event {
            trigger = "before",
            delay = 0.4,
            func = function()
                local copied_fish = SMODS.copy_card(to_copy)
                copied_fish:start_materialize()
                return true
            end
        })
    end
}

FishAndChips.Fish {
    key = "arctic_gayling",
    atlas = "meta_fish",
    pos = { x = 2, y = 1 },
    weight = 10,
    environments = {
        city_river = 5,
        soup = 2,
        garden = 10
    },
    stats = {
        weight = { min = 2, max = 3.8 },
        length = { min = 0.4, max = 0.76 }
    },
    attributes = { "rank", "king", "queen", "enhancements", },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
    end,

    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.before then
            local queens = {}
            local kings = {}
            local yuri = false
            local yaoi = false
            for i, v in pairs(context.full_hand) do
                if v:get_id() == 12 then queens[#queens + 1] = v end
                if v:get_id() == 13 then kings[#kings + 1] = v end
            end
            if #queens >= 2 then
                yuri = true
                for i, v in ipairs(queens) do
                    v:set_ability("m_wild", nil, true)
                    G.E_MANAGER:add_event(Event {
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })
                end
            end
            if #kings >= 2 then
                yaoi = true
                for i, v in ipairs(kings) do
                    v:set_ability("m_wild", nil, true)
                    G.E_MANAGER:add_event(Event {
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })
                end
            end

            if yuri or yaoi then
                return {
                    message = localize("fac_gay" .. (yuri and "_yuri" or "") .. (yaoi and "_yaoi" or "")),
                    colour = G.C.PURPLE
                }
            end
        end
    end
}

FishAndChips.Fish {
    key = "pink_puffle",
    atlas = "meta_fish",
    pos = { x = 3, y = 1 },
    weight = 8,
    environments = {
        pier = 8,
        city_river = 8,
        garden = 4
    },
    stats = {
        weight = { min = 0.001, max = 0.01 },
        length = { min = 0.4, max = 0.6 }
    },
    attributes = { "passive" },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.fishing_profile then
            local fp = context.fishing_profile
            fp.treasure_gain = fp.treasure_gain * 3
            fp.vel_limit = fp.vel_limit * 2
            fp.decision_min = fp.decision_min / 2
        end
    end
}

local vanilla_suits_1 = {
    "Diamonds",
    "Clubs",
    "Hearts",
    "Spades"
}

local vanilla_suits_2 = SMODS.shallow_copy(vanilla_suits_1)
table.insert(vanilla_suits_2, false)

local vanilla_suits_pos = {
    Diamonds = 0,
    Clubs = 1,
    Hearts = 2,
    Spades = 3
}

FishAndChips.Fish {
    key = "vibrill",
    atlas = "meta_fish",
    pos = { x = 4, y = 0 },
    weight = 10,
    environments = {
        styx = 5,
        backroom = 5,
        wormhole = 10
    },
    stats = {
        weight = { min = 1.5, max = 3 },
        length = { min = 0.36, max = 0.38 }
    },
    attributes = {
        "score",
        "suit",
        "scaling",
        "reset"
    },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    config = { extra = {
        score = 1,
        score_scale = 5,
        suit_1 = "Spades",
        suit_2 = false,
        high_score = 1
    } },

    blueprint_compat = true,

    on_catch = function(self, card)
        card.ability.extra.suit_1 = pseudorandom_element(vanilla_suits_1, "vibrill_suit_1")
        repeat
            card.ability.extra.suit_2 = pseudorandom_element(vanilla_suits_2, "vibrill_suit_2")
        until card.ability.extra.suit_2 ~= card.ability.extra.suit_1
    end,

    loc_vars = function(self, info_queue, card)
        local var_and = ""
        local suit2 = ""
        if card.ability.extra.suit_2 then
            var_and = " and "
            suit2 = card.ability.extra.suit_2
        end
        local pos = {
            y = vanilla_suits_pos[card.ability.extra.suit_1],
            x = card.ability.extra.suit_2 and (vanilla_suits_pos[card.ability.extra.suit_2] + 1) or 0
        }
        return { vars = {
            card.ability.extra.suit_1,
            var_and,
            suit2,
            card.ability.extra.score,
            colours = {
                G.C.SUITS[card.ability.extra.suit_1],
                card.ability.extra.suit_2 and G.C.SUITS[card.ability.extra.suit_2] or G.C.UI.TEXT_DARK
            },
            elements = {
                { n = G.UIT.O, config = {
                    object = SMODS.create_sprite(0, 0, 0.5, 0.5, "fac_meta_obstacles", pos)
                } }
            }
        } }
    end,

    flavour_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.high_score } }
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local suit_1_success = false
            local suit_2_success = not card.ability.extra.suit_2
            for i, v in ipairs(context.scoring_hand) do
                suit_1_success = suit_1_success or v:is_suit(card.ability.extra.suit_1)
                suit_2_success = suit_2_success or v:is_suit(card.ability.extra.suit_2)
                if suit_1_success and suit_2_success then break end
            end
            if suit_1_success and suit_2_success then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "score",
                    scalar_value = "score_scale",
                    operation = "X",
                    no_message = true
                })
                card.ability.extra.high_score = math.max(card.ability.extra.high_score, card.ability.extra.score)
                return {
                    message = "Yippee!",
                    colour = G.C.BLACK
                }
            else
                card.ability.extra.score = 2
                return {
                    message = "Ouch!",
                    colour = G.C.BLACK
                }
            end
        end

        if context.joker_main then
            if not context.blueprint then
                card.ability.extra.suit_1 = pseudorandom_element(vanilla_suits_1, "vibrill_suit_1")
                repeat
                    card.ability.extra.suit_2 = pseudorandom_element(vanilla_suits_2, "vibrill_suit_2")
                until card.ability.extra.suit_2 ~= card.ability.extra.suit_1
            end
            return {
                score = card.ability.extra.score
            }
        end
    end
}
--]]

FishAndChips.Fish {
    key = "tsuchinoko",
    atlas = "meta_fish",
    pos = { x = 1, y = 0 },
    weight = 5,
    environments = {
        wormhole = 1
    },
    stats = {
        weight = { min = 50, max = 90 },
        length = { min = 0.3, max = 0.8 }
    },
    treasure = true,
    attributes = { "usable", "economy", },
    ppu_coder = { "metanite64" },
    ppu_artist = { "metanite64" },

    impulse_min = 0.01,
    impulse_max = 0.6,
    decision_min = 0.01,
    decision_max = 0.4,

    can_use = function() return true end,
    use = function(self, card, area)
        G.GAME.fac_meta.tsuchi_bonus = G.GAME.fac_meta.tsuchi_bonus + 1,
        SMODS.destroy_cards(card, {pinch_anim = true})
        SMODS.calculate_effect( {
            message = "Yum!",
            colour = FishAndChips.C.SAND_DOLLAR
        }, card)
    end,
    keep_on_use = function (self, card) -- this is just so it doesn't play the dissolve sound when used, the SMODS.destroy_cards call handles removing the card when used
        return true
    end
}
