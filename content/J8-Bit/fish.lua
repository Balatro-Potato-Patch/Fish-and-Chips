FishAndChips.Fish {
    key = "J8-Bit_money_mola_mola",
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 70, h = 87 },
    weight = 8,
    stats = {
        weight = {
            min = 127.0,
            max = 1000.0
        },
        length = {
            min = 1.8,
            max = 2.5,
        }
    },
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            suit = "Hearts",
            odds = 2,
            money = 1,
        }
    },
    environments = {
        pier = 8.0,
        city_river = 2.0,
        garden = 2.0
    },
    attributes = {
        "suit",
        "economy",
        "hearts",
        "chance"
    },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            'fac_J8-Bit_money_mola_mola')
        return {
            vars = {
                localize(card.ability.extra.suit or "Hearts", 'suits_singular'),
                numerator,
                denominator,
                card.ability.extra.money,
                colours = { G.C.SUITS[card.ability.extra.suit] }
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            if context.other_card:is_suit(card.ability.extra.suit) and
                SMODS.pseudorandom_probability(card, 'fac_J8-Bit_money_mola_mola', 1, card.ability.extra.odds) then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                    return {
                        dollars = card.ability.extra.money,
                        func = function() -- This is for timing purposes, it runs after the dollar manipulation
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.dollar_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_squishy",
    badge_key = "k_J8-Bit_fishbadge_mollusk",
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 0 },
    pixel_size = { w = 69, h = 81 },
    weight = 8,
    stats = {
        weight = {
            min = 0.5,
            max = 1.0
        },
        length = {
            min = 0.2,
            max = 0.5,
        }
    },
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            rank = "8",
            chips = 8,
            mult = 8
        }
    },
    environments = {
        calm_pond = 8.0,
        chocolate_river = 6.0,
        pier = 2.0,
        aquifer = 4.0,
        garden = 4.0
    },
    attributes = {
        "rank",
        "chips",
        "mult",
        "eight"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.rank or "8", 'ranks'),
                card.ability.extra.chips,
                card.ability.extra.mult,
            }
        }
    end,
    flavour_vars = function(self, info_queue, card)
        return {
            vars = {
                G.PROFILES[G.SETTINGS.profile].name or "Jimbo"
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == SMODS.Ranks[card.ability.extra.rank].id then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult
            }
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_boops_boops_all_6s",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 0 },
    pixel_size = { w = 64, h = 72 },
    weight = 6,
    stats = {
        weight = {
            min = 0.07,
            max = 0.2
        },
        length = {
            min = 0.2,
            max = 0.36,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    config = {
        extra = {
            hands_needed = 6,
            hands_counter = 0,
            odds_mult = 3
        }
    },
    environments = {
        calm_pond = 3.0,
        city_river = 6.0,
        aquifer = 3.0,
        garden = 2.0,
        backroom = 1.0
    },
    attributes = {
        "passive",
        "hands",
        "mod_chance"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hands_needed,
                card.ability.extra.hands_counter,
            }
        }
    end,
    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint and G.GAME.blind and G.GAME.blind.in_blind then
            if card.ability.extra.hands_counter >= card.ability.extra.hands_needed then
                return {
                    numerator = context.numerator * card.ability.extra.odds_mult
                }
            end
        end
        if context.setting_blind and not context.blueprint and G.GAME.blind and G.GAME.blind.in_blind then
            if card.ability.extra.hands_counter >= card.ability.extra.hands_needed then
                return {
                    message = localize("k_active_ex"),
                    colour = G.C.GREEN,
                    func = function()
                        local eval = function(card)
                            return card.ability.extra.hands_counter >= card.ability.extra.hands_needed and
                                not G.RESET_JIGGLES
                        end
                        juice_card_until(card, eval, true)
                        return true
                    end
                }
            end
        end
        if context.after and not context.blueprint then
            card.ability.extra.hands_counter = (card.ability.extra.hands_counter + 1) %
                (card.ability.extra.hands_needed + 1)
            if card.ability.extra.hands_counter >= card.ability.extra.hands_needed then
                return {
                    message = localize("k_active_ex"),
                    colour = G.C.GREEN,
                    func = function()
                        local eval = function(card)
                            return card.ability.extra.hands_counter >= card.ability.extra.hands_needed and
                                not G.RESET_JIGGLES
                        end
                        juice_card_until(card, eval, true)
                        return true
                    end
                }
            else
                return {
                    message = tostring(card.ability.extra.hands_counter) ..
                        "/" .. tostring(card.ability.extra.hands_needed),
                    colour = G.C.GREEN
                }
            end
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_hermit_crab",
    badge_key = "k_J8-Bit_fishbadge_crustacean",
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 0 },
    pixel_size = { w = 69, h = 73 },
    weight = 5,
    stats = {
        weight = {
            min = 0.5,
            max = 2.0
        },
        length = {
            min = 0.25,
            max = 0.5,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        extra = {
            money_mult = 2.0,
            money_max = 20
        }
    },
    environments = {
        garden = 5.0,
        pier = 5.0,
        backroom = 1.0,
        wormhole = 1.0,
    },
    attributes = {
        "usable",
        "economy"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.money_max
            }
        }
    end,
    can_use = function(self, card)
        return G.GAME.fac_sand_dollars > 0
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_sand_dollars(
                    math.max(0,
                        math.min(G.GAME.fac_sand_dollars * math.max(card.ability.extra.money_mult - 1.0, 1.0),
                            card.ability.extra.money_max)), true)
                return true
            end
        }))
        delay(0.6)
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_trunkstar",
    badge_key = "k_J8-Bit_fishbadge_mollusk",
    atlas = "fac_j8bit_fish",
    pos = { x = 4, y = 0 },
    pixel_size = { w = 71, h = 83 },
    weight = 5,
    stats = {
        weight = {
            min = 5.0,
            max = 10.0
        },
        length = {
            min = 0.75,
            max = 1.5,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    requires_consumeables = true,
    config = {
        extra = {
            card_type = "Planet",
        }
    },
    environments = {
        wormhole = 5.0
    },
    attributes = {
        "generation",
        "consumable",
        "planet",
        "space"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize("k_" .. string.lower(card.ability.extra.card_type)),
                colours = { G.C.SECONDARY_SET[card.ability.extra.card_type] or G.C.FILTER }
            }
        }
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing and context.failed then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                --[[
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                local w = (G.CARD_W + 0.1) * 2 - 0.1
                local h = G.CARD_H
                G.fac_temp_card_area = CardArea(
                    card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
                    w, h,
                    {
                        type = "joker",
                        card_limit = 1,
                        highlight_limit = 1,
                        highlighted_limit = 1,
                        align_buttons = true,
                        bg_colour = G.C.CLEAR,
                        fixed_limit = true,
                        no_card_count = true,
                    }
                )
                delay(1)
                G.E_MANAGER:add_event(Event {
                    func = function()
                        local new_card = SMODS.create_card {
                            set = card.ability.extra.card_type,
                            key_append = 'J8-Bit_trunkstar'
                        }
                        G.fac_temp_card_area:emplace(new_card)
                        SMODS.calculate_effect(
                            {
                                message = localize('k_plus_' .. string.lower(card.ability.extra.card_type)),
                                colour = G.C.SECONDARY_SET
                                    [card.ability.extra.card_type] or G.C.FILTER
                            },
                            context.blueprint_card or card)
                        return true
                    end
                })
                delay(3)
                G.E_MANAGER:add_event(Event {
                    func = function()
                        local new_card = G.fac_temp_card_area.cards[1]
                        table.remove(G.fac_temp_card_area.cards, 1)
                        G.consumeables:emplace(new_card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                })
                delay(0.5)
                G.E_MANAGER:add_event(Event {
                    func = function()
                        G.fac_temp_card_area:remove()
                        return true
                    end
                })
                return nil, true -- This is for Joker retrigger purposes
                ]] --
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card {
                                    set = card.ability.extra.card_type,
                                    key_append = 'J8-Bit_trunkstar'
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        SMODS.calculate_effect(
                            {
                                message = localize('k_plus_' .. string.lower(card.ability.extra.card_type)),
                                colour = G.C.SECONDARY_SET
                                    [card.ability.extra.card_type] or G.C.FILTER
                            },
                            context.blueprint_card or card)
                        return true
                    end
                }))
                return nil, true -- This is for Joker retrigger purposes
            end
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_fire_urchin",
    badge_key = "k_J8-Bit_fishbadge_echinoderm",
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 1 },
    pixel_size = { w = 71, h = 91 },
    weight = 4.5,
    stats = {
        weight = {
            min = 0.1,
            max = 0.5
        },
        length = {
            min = 0.25,
            max = 0.75,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            perma_mult = 2
        }
    },
    environments = {
        volcano = 4.5,
        soup = 3.0
    },
    attributes = {
        "mult",
        "perma_bonus",
        "modify_card",
        "discard"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.perma_mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.pre_discard and G.GAME.current_round.discards_used == 0 then
            for i = 1, #context.full_hand do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                SMODS.scale_card(context.full_hand[i],
                    {
                        ref_table = context.full_hand[i].ability,
                        ref_value = "perma_mult",
                        scalar_table = card.ability.extra,
                        scalar_value = "perma_mult",
                        message_colour = G.C.MULT
                    }
                )
            end
            return nil, true
        end
    end,
}

function is_last_rank_in_hand(self, poker_hand)
    local check_place = G.play.cards
    if next(select(3, G.FUNCS.get_poker_hand_info(check_place))[poker_hand]) then
        --print("this works!")
        local ranks = {}
        for i = 1, #check_place do
            local rank = check_place[i].base.value
            if ranks[rank] == nil then
                ranks[rank] = 1
            end
        end
        --print(ranks)
        local rank_order = {}
        for rank, _ in pairs(ranks) do
            table.insert(rank_order, rank)
        end
        --print(rank_order)
        return self.base.value == rank_order[#rank_order]
    end
    return false
end

local card_get_chip_bonus = Card.get_chip_bonus
function Card:get_chip_bonus()
    local amt = card_get_chip_bonus(self)
    local octos = SMODS.find_card("fish_fac_J8-Bit_nocto_octo")
    if #octos > 0 then
        if is_last_rank_in_hand(self, octos[1].ability.extra.poker_hand) then
            return amt - self.base.nominal
        end
    end
    return amt
end

local card_get_chip_mult = Card.get_chip_mult
function Card:get_chip_mult()
    local amt = card_get_chip_mult(self)
    local octos = SMODS.find_card("fish_fac_J8-Bit_nocto_octo")
    if #octos > 0 then
        if is_last_rank_in_hand(self, octos[1].ability.extra.poker_hand) then
            return amt + self.base.nominal
        end
    end
    return amt
end

FishAndChips.Fish {
    key = "J8-Bit_nocto_octo",
    badge_key = "k_J8-Bit_fishbadge_cephalopod",
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 1 },
    pixel_size = { w = 64, h = 84 },
    weight = 4.5,
    stats = {
        weight = {
            min = 10.0,
            max = 50.0
        },
        length = {
            min = 4.0,
            max = 8.0,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    config = {
        extra = {
            poker_hand = "Two Pair"
        }
    },
    environments = {
        chocolate_river = 1.5,
        pier = 3.0,
        soup = 4.5
    },
    attributes = {
        "mult",
        "hand_type"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.poker_hand, 'poker_hands')
            }
        }
    end
}

FishAndChips.Fish {
    key = "J8-Bit_boostorca",
    badge_key = "k_J8-Bit_fishbadge_mammal",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 1 },
    pixel_size = { w = 69, h = 94 },
    weight = 4,
    stats = {
        weight = {
            min = 3000.0,
            max = 10000.0
        },
        length = {
            min = 5.0,
            max = 10.0,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    config = {
        extra = {
            booster_pack_mod = 1,
            booster_size_mod = 1
        }
    },
    environments = {
        pier = 4,
    },
    attributes = {
        "passive",
        "generation",
        "booster",
        "shop",
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.booster_pack_mod,
                card.ability.extra.booster_size_mod
            }
        }
    end,
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) +
            card.ability.extra.booster_size_mod
        SMODS.change_booster_limit(card.ability.extra.booster_pack_mod)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) -
            card.ability.extra.booster_size_mod
        SMODS.change_booster_limit(-card.ability.extra.booster_pack_mod)
    end
}

FishAndChips.Fish {
    key = "J8-Bit_later_alligator",
    badge_key = "k_J8-Bit_fishbadge_reptile",
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 1 },
    weight = 4,
    stats = {
        weight = {
            min = 360.0,
            max = 450.0
        },
        length = {
            min = 4.0,
            max = 4.4,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        extra = {
            round_counter = 0,
            round_max = 3,
            tags = {
                "tag_d_six",
                "tag_coupon",
                "tag_voucher"
            }
        }
    },
    environments = {
        backroom = 2.0,
        wormhole = 2.0,
        swamp = 4.0
    },
    attributes = {
        "passive",
        "generation",
        "economy",
        "tag",
    },
    loc_vars = function(self, info_queue, card)
        local vars = {
            card.ability.extra.round_counter,
            card.ability.extra.round_max,
        }
        for i = 1, #card.ability.extra.tags do
            info_queue[#info_queue + 1] = { key = card.ability.extra.tags[i], set = 'Tag' }
            table.insert(vars, localize { type = 'name_text', set = 'Tag', key = card.ability.extra.tags[i] })
        end
        return {
            vars = vars
        }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            card.ability.extra.round_counter = card.ability.extra.round_counter + 1
            return {
                message = (card.ability.extra.round_counter < card.ability.extra.round_max) and
                    (card.ability.extra.round_counter .. '/' .. card.ability.extra.round_max) or
                    localize('k_active_ex'),
                colour = G.C.FILTER,
                func = function()
                    if card.ability.extra.round_counter >= card.ability.extra.round_max then
                        for i = 1, #card.ability.extra.tags do
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    play_sound("tarot1")
                                    add_tag(Tag(card.ability.extra.tags[i]))
                                    card:juice_up(0.3, 0.5)
                                    return true
                                end
                            }))
                            delay(0.5)
                        end
                        G.E_MANAGER:add_event(Event({
                            delay = 0.25,
                            func = function()
                                SMODS.destroy_cards(card, nil, nil, true)
                                return true
                            end
                        }))
                    end
                end
            }
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_mult_mahi_mahi",
    atlas = "fac_j8bit_fish",
    pos = { x = 4, y = 1 },
    pixel_size = { w = 65, h = 95 },
    weight = 4,
    stats = {
        weight = {
            min = 7.0,
            max = 13.0
        },
        length = {
            min = 0.9,
            max = 1.1,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            repetitions = 1,
            enhancement = "m_mult",
            flavor_card = G.P_CENTERS["c_empress"]
        }
    },
    environments = {
        wormhole = 1.0,
        garden = 4.0,
        pier = 2.0
    },
    attributes = {
        "mult",
        "retrigger",
        "enhancements"
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
        return {
            vars = {
                localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }) or "Mult Card",
                card.ability.extra.repetitions
            }
        }
    end,
    flavour_vars = function(self, info_queue, card)
        return {
            vars = {
                localize({
                    type = 'name_text',
                    set = card.ability.extra.flavor_card.set,
                    key = card.ability.extra.flavor_card.key
                }) or
                "The Empress",
                colours = {
                    G.C.SECONDARY_SET[card.ability.extra.flavor_card.set]
                }
            }
        }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, card.ability.extra.enhancement) then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_underhand",
    badge_key = "k_J8-Bit_fishbadge_question_marks",
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 2 },
    pixel_size = { w = 70, h = 95 },
    stats = {
        weight = {
            min = 0.0,
            max = 0.0
        },
        length = {
            min = 10.0,
            max = 100.0,
        }
    },
    weight = 4,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    config = {
        extra = {
            hands = 1,
            hand_size = -1
        }
    },
    environments = {
        styx = 4.0,
        backroom = 2.0
    },
    attributes = {
        "passive",
        "hands",
        "hand_size"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hands,
                math.abs(card.ability.extra.hand_size)
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.hands
        ease_hands_played(-card.ability.extra.hands)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
}

local shark_partner_sprites = {
    masc = { pos = { x = 4, y = 3 }, w = 60, h = 95 },
    femme = { pos = { x = 0, y = 4 }, w = 53, h = 87 },
    gnc = { pos = { x = 1, y = 4 }, w = 47, h = 87 },
}

local function set_shark_partner_sprite(card, gender_presentation, set_size)
    local sprite = shark_partner_sprites[gender_presentation] or shark_partner_sprites.gnc
    card.children.center:set_sprite_pos(sprite.pos)
    card.children.center.scale.x = sprite.w
    card.children.center.scale.y = sprite.h
    if set_size then
        card.T.w = G.CARD_W * (sprite.w / 71)
        card.T.h = G.CARD_H * (sprite.h / 95)
    end
end

FishAndChips.Fish {
    key = "J8-Bit_hot_gamer_shark_partner",
    atlas = "fac_j8bit_fish",
    pos = { x = 4, y = 3 },
    weight = 4,
    stats = {
        weight = {
            min = 90.0,
            max = 226.796
        },
        length = {
            min = 1.375,
            max = 2.286,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            gender_presentation = nil,
            bait = 2,
        }
    },
    treasure = true,
    environments = {

    },
    attributes = {
        "generation",
        "reroll"
    },
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.gender_presentation == "masc" then
            return {
                key = "fish_fac_J8-Bit_hot_gamer_shark_boyfriend",
                vars = {
                    card.ability.extra.bait
                }
            }
        elseif card.ability.extra.gender_presentation == "femme" then
            return {
                key = "fish_fac_J8-Bit_hot_gamer_shark_girlfriend",
                vars = {
                    card.ability.extra.bait
                }
            }
        else
            return {
                key = "fish_fac_J8-Bit_hot_gamer_shark_partner",
                vars = {
                    card.ability.extra.bait
                }
            }
        end
    end,
    flavour_vars = function(self, info_queue, card)
        if card.ability.extra.gender_presentation == "masc" then
            return {
                key = "fish_fac_J8-Bit_hot_gamer_shark_boyfriend",
            }
        elseif card.ability.extra.gender_presentation == "femme" then
            return {
                key = "fish_fac_J8-Bit_hot_gamer_shark_girlfriend",
            }
        else
            return {
                key = "fish_fac_J8-Bit_hot_gamer_shark_partner",
            }
        end
    end,
    calculate = function(self, card, context)
        if context.fac_environment_changed then
            FishAndChips.create_baits_from_card(card, card.ability.extra.bait)
            return {
                message = localize("k_J8-Bit_shark_waifu_quip"),
                colour = G.C.FAC_FISH
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.gender_presentation = pseudorandom_element({ "masc", "femme", "gnc" }, "J8-Bit gives you a shark waifu")
        set_shark_partner_sprite(card, card.ability.extra.gender_presentation, true)
    end,
    set_sprites = function(self, card, front)
        local extra = card.ability and card.ability.extra
        if extra and extra.gender_presentation then
            set_shark_partner_sprite(card, extra.gender_presentation)
        end
    end,
    load = function(self, card, card_table, other_card)
        local extra = card_table.ability and card_table.ability.extra
        set_shark_partner_sprite(card, extra and extra.gender_presentation, true)
    end
}

-- TODO: Dynatext appears in top left (mf)
FishAndChips.Fish {
    key = "J8-Bit_poppup",
    badge_key = "k_J8-Bit_fishbadge_darkner",
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 2 },
    pixel_size = { w = 71, h = 95 },
    weight = 3.5,
    stats = {
        weight = {
            min = 100.0,
            max = 200.0
        },
        length = {
            min = 1.875,
            max = 2.125,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    config = {
        extra = {
            fish_cocaine = 2.0,
            treasure_reward = 2.0
        }
    },
    environments = {
        city_river = 3.5,
        wormhole = 2.0
    },
    attributes = {
        "passive",
        "economy",
        "deltarune",
        "utdr",
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.fish_cocaine,
                card.ability.extra.treasure_reward,
                elements = {
                    fac_j8bit_poppup_sprite
                }
            }
        }
    end,
    flavour_vars = function(self, info_queue, card)
        local possible_popups = {fac_j8bit_trustmeimadolphin_sprite, "dyna"}
        local elem = possible_popups[math.random(#possible_popups)]
        if elem == "dyna" then
            local popup_quotes = {}
            for i = 1, 6 do
                table.insert(popup_quotes, localize("k_J8-Bit_poppup_quote_" .. tostring(i)))
            end
            elem = {
                n = G.UIT.O,
                config = {
                    object = DynaText({
                        string = popup_quotes,
                        colours = { G.C.JOKER_GREY },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.25,
                        min_cycle_time = 0
                    })
                }
            }
        end
        return {
            vars = {
                elements = {
                    elem,
                }
            }
        }
    end,
    calculate = function(self, card, context)
        if context.fishing_profile and not context.blueprint then
            context.fishing_profile.vel_limit = context.fishing_profile.vel_limit * card.ability.extra.fish_cocaine
            context.fishing_profile.impulse_min = context.fishing_profile.impulse_min * card.ability.extra.fish_cocaine
            context.fishing_profile.impulse_max = context.fishing_profile.impulse_max * card.ability.extra.fish_cocaine
            context.fishing_profile.decision_min = context.fishing_profile.decision_min / card.ability.extra
                .fish_cocaine
            context.fishing_profile.decision_max = math.max(context.fishing_profile.decision_min,
                context.fishing_profile.decision_max / card.ability.extra.fish_cocaine)
        end
        if context.fac_treasure_reward and not context.blueprint then
            context.fac_treasure_reward = context.fac_treasure_reward * card.ability.extra.treasure_reward
        end
    end
}

FishAndChips.Fish {
    key = "J8-Bit_spectral_sea_angel",
    badge_key = "k_J8-Bit_fishbadge_sea_slug",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 2 },
    pixel_size = { w = 66, h = 75 },
    weight = 3,
    stats = {
        weight = {
            min = 0.5,
            max = 1.0
        },
        length = {
            min = 0.25,
            max = 0.5,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    eternal_compat = false,
    environments = {
        backroom = 3.0,
        wormhole = 3.0,
        garden = 3.0
    },
    attributes = {
        "usable",
        "generation",
        "consumable",
        "spectral"
    },
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
    loc_vars = function(self, info_queue, card)
        -- This vanilla variable only checks for vanilla Tarots and Planets, you would have to keep track on your own for any custom consumables
        local angel_c = G.GAME.fac_j8bit_last_spectral and G.P_CENTERS[G.GAME.fac_j8bit_last_spectral] or nil
        local last_spectral = angel_c and localize { type = 'name_text', key = angel_c.key, set = angel_c.set } or
            localize('k_none')
        local colour = (not angel_c) and G.C.RED or G.C.SECONDARY_SET.Spectral

        if not (not angel_c) then
            info_queue[#info_queue + 1] = angel_c
        end

        local main_end = {
            {
                n = G.UIT.C,
                config = { align = "bm", padding = 0.02 },
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
                        nodes = {
                            { n = G.UIT.T, config = { text = ' ' .. last_spectral .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true } },
                        }
                    }
                }
            }
        }
        return { vars = { localize("k_spectral"), colours = { G.C.SECONDARY_SET.Spectral } }, main_end = main_end }
    end,
    use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    SMODS.add_card({ key = G.GAME.fac_j8bit_last_spectral })
                    card:juice_up(0.3, 0.5)
                end
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return G.GAME.fac_j8bit_last_spectral and #G.consumeables.cards < G.consumeables.config.card_limit
    end,
}

--[[
FishAndChips.Fish {
    key = "J8-Bit_boss_bass",
    atlas = "fac_j8bit_fish",
    pos = { x = 4, y = 2 },
    weight = 2,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            xmult = 1.5,
            fake_blind = nil
        }
    },
    environments = {
        calm_pond = 2.0,
        pier = 1.0,
        swamp = 1.0,
        styx = 1.5
    },
    attributes = {
        xmult,
        boss_blind,
    },
    loc_vars = function(self, info_queue, card)
        local main_end = nil
        if card.ability.extra.fake_blind and card.area then
            local blind_sprite = AnimatedSprite(0, 0, 0.5, 0.5, G.ANIMATION_ATLAS['blind_chips'],
                card.ability.extra.fake_blind.pos)
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "cm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "cm", colour = card.ability.extra.fake_blind.boss_colour or G.C.FILTER, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.O, config = { object = blind_sprite, draw_layer = 1, align = "cm" } },
                                { n = G.UIT.T, config = { text = ' ' .. localize { type = 'name_text', set = "Blind", key = card.ability.extra.fake_blind.key } .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9, align = "cm" } },
                            }
                        },
                    }
                }
            }
        end
        return {
            vars = {
                card.ability.extra.xmult,
                localize { type = 'name_text', set = "Blind", key = "bl_small" },
                localize { type = 'name_text', set = "Blind", key = "bl_big" },
                colours = {
                    G.P_BLINDS["bl_small"].boss_colour or G.C.FILTER,
                    G.P_BLINDS["bl_big"].boss_colour or G.C.FILTER,
                }
            },
            main_end = main_end
        }
    end,
    calculate = function(self, card, context)
        if not context.blueprint and (G.GAME.blind and G.GAME.blind:get_type() == "Small" or G.GAME.blind:get_type() == "Big") then
            -- find blind
            if context.setting_blind then
                local chosen_blind = pseudorandom_element(G.P_BLINDS, "J8-Bit_boss_bass")
                local it = 0
                while not chosen_blind.boss or chosen_blind.boss.showdown or chosen_blind == card.ability.extra.fake_blind do
                    chosen_blind = pseudorandom_element(G.P_BLINDS, "J8-Bit_boss_bass" .. tostring(it))
                    it = it + 1
                end
                --print("Boss Bass chose " .. localize { type = 'name_text', set = "Blind", key = chosen_blind.key })
                card.ability.extra.fake_blind = chosen_blind
                if card.ability.extra.fake_blind then
                    return {
                        message = localize { type = 'name_text', set = "Blind", key = card.ability.extra.fake_blind.key } ..
                            "!",
                        colour = card.ability.extra.fake_blind.boss_colour or G.C.FILTER
                    }
                end
            end
            -- reset blind
            if context.end_of_round and context.main_eval then

            end
        end
        -- normal xmult
        if context.individual and context.cardarea == G.play and context.other_card.debuff then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
}
]]

local get_all_fish_attributes = function()
    local attributes = {}
    if G.fac_fish_area and #G.fac_fish_area.cards > 0 then
        for fish_index, fish in ipairs(G.fac_fish_area.cards) do
            for attribute_index, attribute in ipairs(fish.config.center.attributes) do
                if G.FAC_ENVIRONMENTS[attribute] == nil then
                    attributes[attribute] = (attributes[attribute] or 0) + 1
                end
            end
        end
    end
    return attributes
end

FishAndChips.Fish {
    key = "J8-Bit_kaleidolotl",
    badge_key = "k_J8-Bit_fishbadge_amphibian",
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 2 },
    pixel_size = { w = 69, h = 87 },
    weight = 2,
    stats = {
        weight = {
            min = 0.5,
            max = 1.0
        },
        length = {
            min = 0.15,
            max = 0.5,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            xmult_inc = 0.1,
        }
    },
    environments = {
        garden = 2.0
    },
    attributes = {
        "xmult",
    },
    loc_vars = function(self, info_queue, card)
        -- attribute number
        local attributes = get_all_fish_attributes() or {}
        local attribute_list = {}
        for attribute, __ in pairs(attributes) do
            attribute_list[#attribute_list + 1] = attribute
        end
        local my_xmult = 1.0 + card.ability.extra.xmult_inc * #attribute_list
        if next(SMODS.find_card("fish_fac_mf_red_herring")) then
            attribute_list = {"all_attributes"}
        end
        -- main end
        local main_end = {}
        local columns = 4
        if card.area and (card.area == G.fac_fish_area) then
            for i = 0, math.floor(#attribute_list / columns) do
                local row = {
                    n = G.UIT.R,
                    config = { align = "bm", minh = 0.4, colour = G.C.CLEAR },
                    nodes = {
                        nodes
                    }
                }
                for j = i * columns + 1, math.min(i * columns + columns, #attribute_list) do
                    local name = localize('k_J8-Bit_attribute_' .. attribute_list[j])
                    if name == "ERROR" then
                        name = attribute_list[j]
                    end
                    local node = {
                        n = G.UIT.C,
                        config = { ref_table = card, align = "m", colour = FishAndChips.AttributeColorTable[attribute_list[j]] or G.C.UI.TEXT_DARK, r = 0.05, padding = 0.06 },
                        nodes = {
                            { n = G.UIT.T, config = { text = " " .. name .. " ", colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
                        }
                    }
                    table.insert(row.nodes, node)
                end
                table.insert(main_end, row)
            end
        end
        return {
            vars = {
                card.ability.extra.xmult_inc,
                my_xmult,
            },
            main_end = main_end
        }
    end,
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('fac_axo', nil, card.ARGS.send_to_shader)
            G.SHADERS['fac_axo']:send("extra_texture", FishAndChips.load_bearing_j8)
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local attributes = get_all_fish_attributes()
            local attribute_num = 0
            for _, __ in pairs(attributes) do
                attribute_num = attribute_num + 1
            end
            return {
                xmult = 1.0 + card.ability.extra.xmult_inc * attribute_num
            }
        end
    end,
}

local has_any_suit_ref = SMODS.has_any_suit
function SMODS.has_any_suit(card)
    local primarina = SMODS.find_card("fish_fac_J8-Bit_primarina")
    if #primarina > 0 then
        --print(card.base.value .. " " .. primarina[1].ability.extra.rank)
        if card:get_id() == SMODS.Ranks[primarina[1].ability.extra.rank].id then
            return true
        end
    end
    return has_any_suit_ref(card)
end

--[[
local is_suit_hook = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    local primarina = SMODS.find_card("Fish_fac_J8-Bit_primarina")
    if #primarina > 0 then
        if self.base.id == primarina[1].ability.extra.rank then
            return true
        end
    end
    return is_suit_hook(suit, bypass_debuff, flush_calc)
end
]]

FishAndChips.Fish {
    key = "J8-Bit_primarina",
    badge_key = "k_J8-Bit_fishbadge_pokemon",
    atlas = "fac_j8bit_fish",
    pos = { x = 4, y = 2 },
    pixel_size = { w = 70, h = 95 },
    weight = 2,
    stats = {
        weight = {
            min = 40.0,
            max = 100.0
        },
        length = {
            min = 1.5,
            max = 4.0,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    config = {
        extra = {
            rank = "Queen",
        }
    },
    environments = {
        calm_pond = 1.0,
        pier = 1.0,
        garden = 1.0,
        wormhole = 2.0
    },
    attributes = {
        "passive",
        "rank",
        "suit",
        "queen",
        -- "boss_blind",
        "debuff",
        "modify_card"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.rank, 'ranks'),
            }
        }
    end,
    flavour_vars = function(self, info_queue, card)
        return {
            vars = {
                localize({ type = 'name_text', key = card.config.center.key, set = card.config.center.set })[1] or
                "Primarina"
            }
        }
    end,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint and context.other_card:get_id() == SMODS.Ranks[card.ability.extra.rank].id then
            return {
                add_to_hand = true
            }
        end

        if context.debuff_card and context.debuff_card:get_id() == SMODS.Ranks[card.ability.extra.rank].id then
            return {
                prevent_debuff = true
            }
        end
    end,
    set_sprites = function(self, card, front)
        G.E_MANAGER:add_event(Event({
            func = function()
                if card.ability.extra.shiny == nil then
                    card.ability.extra.shiny = pseudorandom("J8-Bit_primarina_shiny", 1, 16) <= 1
                end
                if card.ability.extra.shiny then
                    card.children.center:set_sprite_pos({ x = 2, y = 4 })
                else
                    card.children.center:set_sprite_pos({ x = 4, y = 2 })
                end
                return true;
            end
        }))
    end
}

FishAndChips.Fish {
    key = "J8-Bit_toxic_seahorse",
    badge_key = "k_J8-Bit_fishbadge_reploid",
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 3 },
    pixel_size = { w = 70, h = 91 },
    weight = 1,
    stats = {
        weight = {
            min = 87.0,
            max = 87.0
        },
        length = {
            min = 3.5,
            max = 3.5,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    requires_hand = true,
    config = {
        extra = {
            cards_selectable = 2,
            can_destroy = true,
        }
    },
    environments = {
        wormhole = 1.0,
        styx = 0.1,
        pier = 0.1,
        city_river = 0.5
    },
    attributes = {
        "usable",
        "destroy_card",
        "generation",
        "tag",
        "editions",
    },
    loc_vars = function(self, info_queue, card)
        for i, edition in ipairs(G.P_CENTER_POOLS.Edition) do
            --print(edition.key)
            local tag_name = string.gsub(edition.key, "e_", "tag_")
            --print(tag_name)
            if G.P_TAGS[tag_name] then
                info_queue[#info_queue + 1] = { key = tag_name, set = 'Tag' }
            end
        end
        local main_end = nil
        if card.area and (card.area == G.fac_fish_area) then
            local disableable = G.GAME.blind and card.ability.extra.can_destroy
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = " " .. localize('k_J8-Bit_ts_' .. (disableable and 'active' or 'inactive')) .. " ", colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
                            }
                        }
                    }
                }
            }
        end
        return {
            vars = {
                card.ability.extra.cards_selectable,
                ppu_bubbles = {
                    card.ability.extra.can_destroy and "usable" or "used"
                }
            },
            main_end = main_end
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            return {
                message = localize("k_J8-Bit_ts_active"),
                colour = G.C.GREEN,
                func = function()
                    card.ability.extra.can_destroy = true
                    return true
                end
            }
        end
    end,
    can_use = function(self, card)
        return card.ability.extra.can_destroy and G.hand and #G.hand.highlighted > 0 and
            #G.hand.highlighted <= card.ability.extra.cards_selectable
    end,
    keep_on_use = function(self, card)
        return true
    end,
    use = function(self, card)
        SMODS.calculate_effect(
            {
                message = localize('k_J8-Bit_ts_attack'),
                colour = G.C.GREEN
            }, card)
        card.ability.extra.can_destroy = false
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i, playing_card in ipairs(G.hand.highlighted) do
            if playing_card.edition then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("tarot1")
                        add_tag(Tag(string.gsub(playing_card.edition.key, "e_", "tag_")))
                        playing_card:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                delay(0.5)
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                SMODS.destroy_cards(G.hand.highlighted)
                return true
            end
        }))
        delay(0.3)
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_left_shark",
    badge_key = "k_J8-Bit_fishbadge_person_in_a_suit",
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 3 },
    pixel_size = { w = 57, h = 89 },
    weight = 1,
    stats = {
        weight = {
            min = 90.0,
            max = 100.0
        },
        length = {
            min = 1.5,
            max = 2.0,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            money = 5,
            sand_dollars = 5,
        }
    },
    environments = {
        pier = 1.0,
        soup = 1.0,
        wormhole = 1.0,
    },
    attributes = {
        "economy",
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.money,
                card.ability.extra.sand_dollars,
            }
        }
    end,
    flavour_vars = function(self, info_queue, card)
        return {
            vars = {
                "#leftshark"
            }
        }
    end,
    calculate = function(self, card, context)
        if context.fac_fish_caught then
            local bait = G.P_CENTERS[G.GAME.fac_active_bait]
            --print(bait)
            if bait.target then
                --print(bait.target)
                local bait_matches = false
                local attributes = {}
                if type(bait.target) == "table" then
                    for i, attribute in ipairs(bait.target) do
                        table.insert(attributes, attribute)
                    end
                elseif type(bait.target) == "string" then
                    table.insert(attributes, bait.target)
                end
                if #attributes > 0 then
                    --print(attributes)
                    for i, attribute in ipairs(attributes) do
                        if context.fac_fish_caught:has_attribute(attribute) then
                            --print(attribute .. " is part of the bait!")
                            bait_matches = true
                            break
                        end
                    end
                end
                if not bait_matches then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
                    return {
                        sand_dollars = card.ability.extra.sand_dollars,
                        dollars = card.ability.extra.money,
                        func = function() -- This is for timing purposes, it runs after the dollar manipulation
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.dollar_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_sdmg",
    badge_key = "k_J8-Bit_fishbadge_ranged_weapon",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 3 },
    pixel_size = { w = 44, h = 93 },
    weight = 1,
    stats = {
        weight = {
            min = 8.6,
            max = 8.6
        },
        length = {
            min = 0.6,
            max = 0.6,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            repetitions = 1
        }
    },
    environments = {
        wormhole = 1.0
    },
    attributes = {
        "retrigger",
        "hand_type",
        "consumable",
        "planet",
        "space"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize("k_planet"),
                colours = {
                    G.C.SECONDARY_SET.Planet
                }
            }
        }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            local planets = 0
            for i, consumable in ipairs(G.consumeables.cards) do
                if consumable.ability.set == 'Planet' and consumable.ability.consumeable.hand_type == context.scoring_name then
                    planets = planets + 1
                end
            end
            if planets > 0 then
                return {
                    repetitions = card.ability.extra.repetitions * planets
                }
            end
        end
    end,
}

FishAndChips.Fish {
    key = "J8-Bit_red_herring",
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 3 },
    pixel_size = { w = 68, h = 94 },
    weight = 0.5,
    stats = {
        weight = {
            min = 0.85,
            max = 1.05
        },
        length = {
            min = 0.25,
            max = 0.46,
        }
    },
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        extra = {
            edition = "e_negative",
            did_copy = false
        }
    },
    environments = {
        styx = 1.0,
        pier = 1.0,
        aquifer = 1.0,
        city_river = 1.0,
        backroom = 1.0,
        wormhole = 1.0,
    },
    attributes = {
        "passive",
        "generation",
        "editions",
        "deltarune", -- Flavour text is a reference
        "utdr",
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_negative_generic', set = 'Edition', config = { extra = 1 } }
        return {
            vars = {
                localize({ type = 'name_text', key = "e_negative_generic", set = "Edition" })
            }
        }
    end,
    update = function(self, card, dt)
        if G.fac_fish_area and card.area == G.fac_fish_area and not card.ability.extra.did_copy then
            card.ability.extra.did_copy = true
            local fish = {}
            for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] ~= card then
                    fish[#fish + 1] = G.fac_fish_area.cards[i]
                end
            end
            if #fish > 0 then
                --print("we got fish")
                if G.fac_fish_area:has_space() then
                    local chosen_fish = pseudorandom_element(fish, 'fac_j8bit_red_herring')
                    G.E_MANAGER:add_event(Event({
                        delay = 0.5,
                        func = function()
                            local copied_fish = SMODS.copy_card(chosen_fish, {
                                area = G.fac_fish_area,
                                strip_edition = true
                            })
                            copied_fish:set_edition(card.ability.extra.edition)
                            return true
                        end
                    }))
                end
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.destroy_cards(card, nil, nil, true)
                    G:save_progress()
                    return true
                end
            }))
        end
    end
}
