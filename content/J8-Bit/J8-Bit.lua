-- ## ATLASES ##

SMODS.Atlas({
    key = "j8bit_fish", -- Please include your name/team name in your atlas keys
    path = "J8-Bit/fish_temp.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "j8bit_credits", -- Please include your name/team name in your atlas keys
    path = "J8-Bit/credits_temp.png",
    px = 71,
    py = 95,
})

-- ## COLORS ##

loc_colour('red')
G.ARGS.LOC_COLOURS.j8bit_tumblr = HEX("36465d")
G.ARGS.LOC_COLOURS.j8bit_youtube = HEX("cc181e")
G.ARGS.LOC_COLOURS.j8bit_bluesky = HEX("01A5FF")
G.ARGS.LOC_COLOURS.j8bit_steam = HEX("171D25")

local j8_colors = {
    HEX("F1641F"),
    HEX("F1641F"),
    HEX("8306C1"),
    HEX("8306C1"),
}

SMODS.DynaTextEffect {
    key = "j8_text",
    func = function(dynatext, index, letter)
        local s = #j8_colors
        local o = index * -0.5
        local t = (G.TIMERS.REAL + o)
        letter.colour = mix_colours(
            j8_colors[((math.floor(t) + s + 1) % s) + 1],
            j8_colors[((math.floor(t) + s) % s) + 1],
            t % 1.0)
        letter.offset.y = math.sin(t * 2.0 + o) * 4
        letter.offset.x = math.cos(t * 1.0 + o) * 8
    end,
}

local rainbow_colors = {
    G.C.RED,
    G.C.FILTER,
    G.C.GOLD,
    G.C.BLUE,
    G.C.PURPLE,
}

SMODS.DynaTextEffect {
    key = "rainbow_text",
    func = function(dynatext, index, letter)
        local s = #rainbow_colors
        local o = index * -0.5
        local t = (G.TIMERS.REAL + o)
        letter.colour = mix_colours(
            rainbow_colors[((math.floor(t) + s + 1) % s) + 1],
            rainbow_colors[((math.floor(t) + s) % s) + 1],
            t % 1.0)
    end,
}

-- ## DEVELOPERS ##

PotatoPatchUtils.Developer({
    name = 'J8-Bit',
    atlas = 'fac_j8bit_credits',
    text_effect = "fac_j8_text",
    loc = "PotatoPatchDev_J8-Bit",
    pos = { x = 0, y = 0 },
    click = function(self)
        --play_sound('worm_lfc_j8_click',1.5-j8_click_count*0.1,2)
        self:juice_up()
        love.system.openURL("https://bsky.app/profile/j8-bit.bsky.social")
        love.system.openURL("https://www.youtube.com/@j8-bitforager842")
        love.system.openURL("https://aforager.tumblr.com")
        love.system.openURL("https://store.steampowered.com/app/4551740/CalvinChess/")
        love.system.openURL("https://balatromods.miraheze.org/wiki/Forager_Nonessentials")
    end
})

-- ## FISH ##

FishAndChips.Fish {
    key = "J8-Bit_money_mola_mola",
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 0 },
    weight = 8,
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
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
            'J8-Bit_money_mola_mola')
        return {
            vars = {
                localize(card.ability.extra.suit or "Heart", 'suits_singular'),
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
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 0 },
    weight = 8,
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
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.rank, 'ranks'),
                card.ability.extra.chips,
                card.ability.extra.mult,
                G.PROFILES[G.SETTINGS.profile].name or "Jimbo"
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            (context.other_card:get_id() == SMODS.Ranks[card.ability.extra.rank].id) then
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
    weight = 6,
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
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 0 },
    weight = 5,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = false,
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
    atlas = "fac_j8bit_fish",
    pos = { x = 4, y = 0 },
    weight = 5,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {
            card_type = "Planet",
        }
    },
    environments = {
        wormhole = 5.0
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
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 1 },
    weight = 4.5,
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
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 1 },
    weight = 4.5,
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
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                localize(card.ability.extra.poker_hand, 'poker_hands')
            }
        }
    end
}

-- NOTE TO FNC DEVS: THIS CODE IS FROM THE MULTIPLAYER MOD!! I'M NOT SURE IF THERE'S A BETTER WAY TO DO THIS SO PLEASE FEEL FREE TO REWRITE THIS TO BE BETTER AND NOT JUST BLATANT COPYING AND PASTING
-- source: https://github.com/Balatro-Multiplayer/BalatroMultiplayer/blob/dev/objects/decks/01_indigo.lua
-- (thank you)
local function check_joker_space(card)
    if card.config.center.set == "Joker" and card.edition and card.edition.negative then return true end
    local c = 0
    local un_c = G.jokers.config.card_limit
    for i, v in ipairs(G.jokers.cards) do
        if v.edition and v.edition.type == "negative" then
            un_c = un_c - 1
        elseif v.ability.eternal then
            c = c + 1
        else
            break
        end
    end
    return c < un_c
end

local function is_usable(card)
    local center = card.config.center
    local key = center.key
    if center.set == "Enhanced" or center.set == "Default" or center.set == "Planet" then
        return true
    elseif center.set == "Joker" then
        return check_joker_space(card)
    elseif center.set == "Tarot" then
        if key == "c_fool" then
            return G.GAME.last_tarot_planet and G.GAME.last_tarot_planet ~= "c_fool"
        elseif key == "c_judgement" then
            return check_joker_space(card)
        elseif key == "c_wheel_of_fortune" then
            if card.eligible_strength_jokers and next(card.eligible_strength_jokers) then return true end
            return false
        elseif card.ability.consumeable.max_highlighted then
            if #G.hand.cards >= (card.ability.consumeable.min_highlighted or 1) then return true end
            return false
        else
            return true
        end
    elseif center.set == "Spectral" then
        if
            key == "c_familiar"
            or key == "c_grim"
            or key == "c_incantation"
            or key == "c_immolate"
            or key == "c_sigil"
            or key == "c_ouija"
        then
            if #G.hand.cards > 1 then -- vanilla bug?
                return true
            end
            return false
        elseif key == "c_aura" then
            local bool = false
            for i, v in ipairs(G.hand.cards) do
                if not v.edition then
                    bool = true
                    break
                end
            end
            return bool
        elseif key == "c_ectoplasm" or key == "c_hex" then
            if card.eligible_editionless_jokers and next(card.eligible_editionless_jokers) then return true end
            return false
        elseif key == "c_wraith" or key == "c_soul" then
            return check_joker_space(card)
        elseif key == "c_ankh" then
            if G.jokers.cards[1] then return check_joker_space(card) end
            return false
        elseif card.ability.consumeable.max_highlighted then
            if #G.hand.cards >= (card.ability.consumeable.min_highlighted or 1) then return true end
            return false
        else
            return true
        end
    end
    return true -- hopefully no mod compat doesn't kill a run (it will)
end

local can_skip_booster_pack = G.FUNCS.can_skip_booster
G.FUNCS.can_skip_booster = function(e)
    if next(SMODS.find_card("fish_fac_J8-Bit_boostorca")) then
        local softlock = true
        for i, v in ipairs(G.pack_cards.cards) do
            if is_usable(v) then
                softlock = false
                break
            end
        end
        if not softlock then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
            return
        end
    end
    return can_skip_booster_pack(e)
end
-- END MULTIPLAYER COPYING AND PASTING

FishAndChips.Fish {
    key = "J8-Bit_boostorca",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 1 },
    weight = 4,
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
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.booster_pack_mod,
                card.ability.extra.booster_size_mod
            }
        }
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
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 1 },
    weight = 4,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
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
    weight = 4,
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
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
        return {
            vars = {
                localize({ type = 'name_text', set = "Enhanced", key = card.ability.extra.enhancement }) or "Mult Card",
                localize({
                    type = 'name_text',
                    set = card.ability.extra.flavor_card.set,
                    key = card.ability.extra
                        .flavor_card.key
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
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 2 },
    weight = 4,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
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

FishAndChips.Fish {
    key = "J8-Bit_hot_gamer_shark_partner",
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 2 },
    weight = 4,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    calculate = function(self, card, context)

    end,
}

FishAndChips.Fish {
    key = "J8-Bit_poppup",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 2 },
    weight = 3.5,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    calculate = function(self, card, context)

    end,
}

FishAndChips.Fish {
    key = "J8-Bit_spectral_sea_angel",
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 2 },
    weight = 3,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    can_use = function(self, card)

    end,
}


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

FishAndChips.Fish {
    key = "J8-Bit_primarina",
    atlas = "fac_j8bit_fish",
    pos = { x = 0, y = 3 },
    weight = 2,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    calculate = function(self, card, context)

    end,
}

FishAndChips.Fish {
    key = "J8-Bit_toxic_seahorse",
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 3 },
    weight = 1,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    can_use = function(self, card)

    end,
}

FishAndChips.Fish {
    key = "J8-Bit_left_shark",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 3 },
    weight = 1,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    calculate = function(self, card, context)

    end,
}

FishAndChips.Fish {
    key = "J8-Bit_sdmg",
    atlas = "fac_j8bit_fish",
    pos = { x = 3, y = 3 },
    weight = 1,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    calculate = function(self, card, context)

    end,
}

FishAndChips.Fish {
    key = "J8-Bit_red_herring",
    atlas = "fac_j8bit_fish",
    pos = { x = 4, y = 3 },
    weight = 0.5,
    cost = 4,
    ppu_coder = { "J8-Bit" },
    ppu_artist = { "J8-Bit" },
    blueprint_compat = true,
    config = {
        extra = {

        }
    },
    environments = {

    },
    loc_vars = function(self, info_queue, card)
        return {}
    end,
    calculate = function(self, card, context)

    end,
}
