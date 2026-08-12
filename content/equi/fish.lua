--yippee fish
FishAndChips.equi = {

}

SMODS.Atlas ({
    key = "equi_fish",
    path = "equi/fish.png",
    px = 71,
    py = 95
})

SMODS.Atlas ({
    key = "equi_credits",
    path = "equi/equicredits.png",
    px = 71,
    py = 95
})

PotatoPatchUtils.Developer {
    name = "Equi",
    atlas = "fac_equi_credits",
    pos = { x = 0, y = 0 },
    colour = G.C.BLUE,
    loc = true
}

--Mr Chips
FishAndChips.Fish {
    key = "mrchips",
    atlas = "equi_fish",
    pos = { x = 0, y = 0 },
    weight = 20,
    cost = 3,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "chips", "rank" },
    stats = {
        weight = { min = 0.75, max = 0.9 },
        length = { min = 0.55, max = 0.75 }
    },
    config = {
        extra = {
            chips = 1
        }
    },
    treasure = true,
    environments = {
        city_river = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.game_over then
            for i = 1, #G.hand.cards do
                G.hand.cards[i].ability.perma_bonus = (G.hand.cards[i].ability.perma_bonus or 0) + (math.max(card.ability.extra.chips * G.hand.cards[i]:get_id(), 0)) --whoops nearly made stone cards give -1000000 chips
            end
            return {
                message = localize("k_upgrade_ex")
            }
        end
    end
}

--Antarctic Krill
FishAndChips.Fish {
    key = "antarctickrill",
    atlas = "equi_fish",
    pos = { x = 1, y = 0 },
    display_size = { w = 67, h = 51 },
    pixel_size = { w = 67, h = 51 },
    weight = 10,
    cost = 5,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "generation" },
    stats = {
        weight = { min = 0.0016, max = 0.0025 },
        length = { min = 0.05, max = 0.07 }
    },
    config = {
        extra = {
            sand_dollar_req = 8 --note: 8 could be too few or too many, hard to judge the amount of sand dollars someone will have without knowing all the other fish
        }
    },
    environments = {
        styx = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sand_dollar_req } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            if G.GAME.fac_sand_dollars >= card.ability.extra.sand_dollar_req then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = "Joker",
                            rarity = "Common"
                        }
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                return {
                    message = localize("k_plus_joker"),
                    colour = G.C.BLUE
                }
            end
        end
    end
}

--Webfishing
FishAndChips.Fish {
    key = "webfishing",
    atlas = "equi_fish",
    pos = { x = 2, y = 0 },
    display_size = { w = 65, h = 72 },
    pixel_size = { w = 65, h = 72 },
    weight = 10,
    cost = 5,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "xmult", "passive" }, --passive definitely applies here right?
    stats = {
        weight = { min = 0.003, max = 0.004 },
        length = { min = 0.07, max = 0.11 }
    },
    config = {
        extra = {
            xmult = 3
        }
    },
    environments = {
        swamp = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if (context.hand_drawn or context.other_drawn) and not context.blueprint then
            local forced_count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_card.ability.forced_selection then
                    forced_count = forced_count + 1
                end
            end

            if forced_count < G.hand.config.highlighted_limit then
                G.hand:unhighlight_all()
                local unselected_cards = {}
                for _, playing_card in ipairs(G.hand.cards) do
                    if playing_card.highlighted == false then
                        table.insert(unselected_cards, playing_card)
                    end
                end

                local forced_card = pseudorandom_element(unselected_cards, "equi_webfishing")
                if not forced_card.ability.forced_selection then
                    forced_card.ability.forced_selection = true
                    G.hand:add_to_highlighted(forced_card)
                end
            end
        end
    end
}

--Fished For It Again Award
FishAndChips.Fish {
    key = "fishedforitagain",
    atlas = "equi_fish",
    pos = { x = 3, y = 0 },
    weight = 15,
    cost = 6,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "generation" },
    stats = {
        weight = { min = 0.15, max = 0.25 },
        length = { min = 0.08, max = 0.12 }
    },
    config = {
        extra = {
            bait_given = 1, current_fails = 0, required_fails = 4, max_per_round = 3, baits_this_round = 0
        }
    },
    environments = {
        wormhole = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.bait_given, card.ability.extra.current_fails, card.ability.extra.required_fails, card.ability.extra.max_per_round, card.ability.extra.baits_this_round } }
    end,

    calculate = function(self, card, context)
        if context.failed and card.ability.extra.baits_this_round < card.ability.extra.max_per_round then
            if not context.blueprint then
                card.ability.extra.current_fails = card.ability.extra.current_fails + 1
            end
            if card.ability.extra.current_fails == card.ability.extra.required_fails then
                if not context.blueprint then
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.0,
                        func = (function()
                            card.ability.extra.current_fails = 0
                            return true
                        end)}))
                end
                card.ability.extra.baits_this_round = card.ability.extra.baits_this_round + 1
                local bait_number = pseudorandom("equi_fishedforitagain", 2, #G.P_CENTER_POOLS.fac_Bait)
                local bait = G.P_CENTER_POOLS.fac_Bait[bait_number]
                FishAndChips.add_bait_to_inventory(bait.key, card.ability.extra.bait_given)
                return {
                    message = localize {
                        type = "variable",
                        key = "k_fac_equi_plus_bait",
                        vars = { card.ability.extra.bait_given } 
                    }
                }
            else
                return {
                    message =  card.ability.extra.current_fails .. "/" .. card.ability.extra.required_fails
                }
            end
        end

        if context.end_of_round and context.main_eval and not context.blueprint and not context.game_over then
            card.ability.extra.baits_this_round = 0
        end
    end
}

--Carptical Illusion
FishAndChips.Fish {
    key = "carpticalillusion",
    atlas = "equi_fish",
    pos = { x = 4, y = 0 },
    display_size = { w = 66, h = 46 },
    pixel_size = { w = 66, h = 46 },
    weight = 5,
    cost = 7,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "generation" },
    stats = {
        weight = { min = 0.0001, max = 0.0001 },
        length = { min = 99, max = 99 }
    },
    config = { 
        extra = { 
            chosen_bait = 2 
        } 
    },
    environments = {
        backroom = 1,
        wormhole = 0.25
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chosen_bait, localize{ set = "fac_Bait", type = "name_text", key = G.P_CENTER_POOLS.fac_Bait[card.ability.extra.chosen_bait].key } } }
    end,

    calculate = function(self, card, context)
        if context.fac_fish_hooked then
            if G.GAME.fac_active_bait == G.P_CENTER_POOLS.fac_Bait[card.ability.extra.chosen_bait].key then
                card.ability.extra.chosen_bait = pseudorandom("equi_carpticalillusion", 2, #G.P_CENTER_POOLS.fac_Bait)
                if (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = "before",
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card {
                                set = "Spectral"
                            }
                            return true
                        end)}))
                    return {
                        message = localize("k_plus_spectral"),
                        colour = G.C.SECONDARY_SET.Spectral
                    }
                else
                    return {
                        message = localize("k_fac_equi_no_room"),
                        colour = G.C.SECONDARY_SET.Spectral
                    }
                end
            end
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.chosen_bait = pseudorandom("equi_carpticalillusion", 2, #G.P_CENTER_POOLS.fac_Bait)
    end
}

--Mawray
fac_equi_get_longest_fish = function(fish)
    local max_length = 0
    local longest_fish = nil
    for k, v in pairs(fish) do
        if v.ability.stats.length ~= nil and v.ability.stats.length > max_length and v.config.center.key ~= "fish_fac_mawray" then
            max_length = v.ability.stats.length
            longest_fish = v
        end
    end
    return max_length, longest_fish
end

fac_equi_get_mawray_xmult = function()
    local max_length, _ = fac_equi_get_longest_fish(G.fac_fish_area.cards)
    local xmult = (3 * (math.log10(max_length + 0.5) + math.log10(2)) + 1)
    --note: would maybe be good if the player can know this formula in some way, but seems like too much to put into the description
    return xmult
end

FishAndChips.Fish {
    key = "mawray",
    atlas = "equi_fish",
    pos = { x = 5, y = 0 },
    display_size = { w = 62, h = 61 },
    pixel_size = { w = 62, h = 61 },
    weight = 5,
    cost = 6,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "xmult" },
    stats = {
        weight = { min = 15, max = 30 },
        length = { min = 2.5, max = 3.5 }
    },
    config = { 
        extra = { 
            xmult = 1
        } 
    },
    environments = {
        aquifer = 1,
        styx = 0.1,
        swamp = 0.1
    },
    loc_vars = function(self, info_queue, card)
        if G.fac_fish_area then
            card.ability.extra.xmult = fac_equi_get_mawray_xmult()
        else
            card.ability.extra.xmult = 1
        end
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

--Go Fish
FishAndChips.Fish {
    key = "gofish",
    atlas = "equi_fish",
    pos = { x = 6, y = 0 },
    display_size = { w = 61, h = 53 },
    pixel_size = { w = 61, h = 53 },
    weight = 5,
    cost = 6,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "xmult, rank, destroy_card" },
    stats = {
        weight = { min = 0.0015, max = 0.0025 },
        length = { min = 0.085, max = 0.095 }
    },
    config = { 
        extra = { 
            current_rank = "Ace",
            xmult = 1,
            xmult_gain = 0.1
        } 
    },
    environments = {
        calm_pond = 0.8,
        city_river = 1,
        garden = 0.8
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_rank, card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,

    flavour_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.current_rank } }
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.current_rank = pseudorandom_element(SMODS.Ranks, "equi_gofish").original_key
            return {
                message = localize {
                    type = "variable",
                    key = "k_fac_equi_go_fish_call",
                    vars = { card.ability.extra.current_rank }
                }
            }
        end

        if context.after and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            local rank_check = true
            for i = 1, #context.full_hand do
                if context.full_hand[i].base.value ~= card.ability.extra.current_rank then
                    rank_check = false
                end
            end

            if rank_check == true then
                for i = 1, #context.full_hand do
                    SMODS.destroy_cards(context.full_hand[i])
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                end
                return {
                    message = localize("k_fac_equi_go_fish_response")
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

FishAndChips.equi.mutekimaru_flavour = {
    --Wanted to have the DynaText actually cycle through these in order but that seems to require some cursed stuff
    cycles = {
        "Up Down Left Right B A",
        "Down Left Right B A Down",
        "Left Right B A Down Right",
        "Right B A Down Right A",
        "B A Down Right A A",
        "A Down Right A A B",
        "Down Right A A B Up",
        "Right A A B Up Left",
        "A A B Up Left Right",
        "A B Up Left Right Down",
        "B Up Left Right Down Down",
        "Up Left Right Down Down B",
        "Left Right Down Down B Right",
        "Right Down Down B Right B",
        "Down Down B Right B Up",
        "Down B Right B Up A",
        "B Right B Up A A",
        "Right B Up A A A",
        "B Up A A A Left",
        "Up A A A Left Down",
        "A A A Left Down Left",
        "A A Left Down Left Right",
        "A Left Down Left Right B",
        "Left Down Left Right B Up",
        "Down Left Right B Up Down",
        "Left Right B Up Down Down",
        "Right B Up Down Down B",
        "B Up Down Down B A",
        "Up Down Down B A Right",
        "Down Down B A Right Down",
        "Down B A Right Down Left",
        "B A Right Down Left Up",
        "A Right Down Left Up Up",
        "Right Down Left Up Up Down",
        "Down Left Up Up Down Left",
        "Left Up Up Down Left A",
        "Up Up Down Left A Right",
        "Up Down Left A Right Up",
        "Down Left A Right Up Down",
        "Left A Right Up Down Left",
        "A Right Up Down Left Right",
        "Right Up Down Left Right B",
    },
    current_cycle = 0
}

FishAndChips.equi.mutekimaru_desc = {
    target = {
        "leftmost", "rightmost"
    },
    other_target = {
        " Joker", " Fish", " Card"
    },
    score = {
        "+60 Chips", "+15 Mult", "X2 Mult"
    },
    cards = {
        "Tarot", "Planet"
    }
}

function FishAndChips.equi.update_mutekimaru_flavour()
    return DynaText({
        string = FishAndChips.equi.mutekimaru_flavour["cycles"],
        colours = { G.C.JOKER_GREY },
        pop_in_rate = 9999999,
        silent = true,
        random_element = true,
        pop_delay = 0.7,
        scale = 0.32,
        min_cycle_time = 0
    })
end

local leftright, target, reward, card_reward = ""

--Mutekimaru Channel
FishAndChips.Fish {
    key = "mutekimaruchannel",
    atlas = "equi_fish",
    pos = { x = 7, y = 0 },
    display_size = { w = 58, h = 47 },
    pixel_size = { w = 58, h = 47 },
    weight = 5,
    cost = 5,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "xmult, mult, chips, generation, hand_level" },
    stats = {
        weight = { min = 0.007, max = 0.009 },
        length = { min = 0.06, max = 0.08 }
    },
    config = { 
        extra = { 
            chips = 60,
            mult = 15,
            xmult = 2,
            cards = 1,
        } 
    },
    environments = {
        pier = 1,
        city_river = 1
    },
    loc_vars = function(self, info_queue, card)
        local main_start = {
            { n = G.UIT.R, config = { align = "cm", padding = 0.02 }, nodes = {
                { n = G.UIT.T, config = { text = "The ", colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                { n = G.UIT.O, config = { object = DynaText({
                    string = FishAndChips.equi.mutekimaru_desc["target"], 
                    colours = { G.C.UI.TEXT_DARK },
                    pop_in_rate = 9999999,
                    silent = true,
                    random_element = true,
                    pop_delay = 0.7,
                    scale = 0.32,
                    min_cycle_time = 0 })} },
                { n = G.UIT.O, config = { object = DynaText({
                    string = FishAndChips.equi.mutekimaru_desc["other_target"], 
                    colours = { G.C.IMPORTANT },
                    pop_in_rate = 9999999,
                    silent = true,
                    random_element = true,
                    pop_delay = 0.7,
                    scale = 0.32,
                    min_cycle_time = 0 })} },
                { n = G.UIT.T, config = { text = " gives ", colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
            } },
            { n = G.UIT.R, config = { align = "cm", padding = 0.02 }, nodes = {
                { n = G.UIT.O, config = { object = DynaText({
                    string = FishAndChips.equi.mutekimaru_desc["score"], 
                    colours = { G.C.CHIPS, G.C.MULT },
                    pop_in_rate = 9999999,
                    silent = true,
                    random_element = true,
                    pop_delay = 0.7,
                    scale = 0.32,
                    min_cycle_time = 0 })} },
                { n = G.UIT.T, config = { text = " and a ", colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
                { n = G.UIT.O, config = { object = DynaText({
                    string = FishAndChips.equi.mutekimaru_desc["cards"], 
                    colours = { G.C.SECONDARY_SET.Tarot, G.C.SECONDARY_SET.Planet },
                    pop_in_rate = 9999999,
                    silent = true,
                    random_element = true,
                    pop_delay = 0.7,
                    scale = 0.32,
                    min_cycle_time = 0 })} }
            } },
            { n = G.UIT.R, config = { align = "cm", padding = 0.02 }, nodes = {
                { n = G.UIT.T, config = { text = " card when scored", colour = G.C.UI.TEXT_DARK, scale = 0.32 } },
            } }
        }

        return { 
            vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xmult, card.ability.extra.cards },
            main_start = main_start
        }
    end,

    flavour_vars = function(self, info_queue, card)
        return {
            vars = { 
                elements = {
                    FishAndChips.equi.update_mutekimaru_flavour()
                }
            }
        }
    end,

    calculate = function(self, card, context)
        --this code is poop from a butt but i have more important things to do than making it better
        if context.press_play then
            leftright = pseudorandom_element({"left", "right"}, "equi_mutekimaruchannel")
            target = pseudorandom_element({"joker", "fish", "card"}, "equi_mutekimaruchannel")
            reward = pseudorandom_element({"chips", "mult", "xmult"}, "equi_mutekimaruchannel")
            card_reward = pseudorandom_element({"Tarot", "Planet"}, "equi_mutekimaruchannel")
        end

        if context.other_joker and target == "joker" then
            if (context.other_joker == G.jokers.cards[1] and leftright == "left") or
            (context.other_joker == G.jokers.cards[#G.jokers.cards] and leftright == "right") then
                if reward == "chips" then
                    SMODS.calculate_effect({chips = card.ability.extra.chips, message_card = context.other_joker}, context.blueprint_card or card)
                elseif reward == "mult" then
                    SMODS.calculate_effect({mult = card.ability.extra.mult, message_card = context.other_joker}, context.blueprint_card or card)
                elseif reward == "xmult" then
                    SMODS.calculate_effect({xmult = card.ability.extra.xmult, message_card = context.other_joker}, context.blueprint_card or card)
                end

                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = card_reward,
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    if card_reward == "Tarot" then
                        return {
                            message = localize("k_plus_tarot")
                        }
                    elseif card_reward == "Planet" then
                        return {
                            message = localize("k_plus_planet")
                        }
                    end
                end
            end
        end

        if context.other_main and context.other_main.ability.set == "fac_Fish" and target == "fish" then
            if (context.other_main == G.fac_fish_area.cards[1] and leftright == "left") or
            (context.other_main == G.fac_fish_area.cards[#G.fac_fish_area.cards] and leftright == "right") then
                if reward == "chips" then
                    SMODS.calculate_effect({chips = card.ability.extra.chips, message_card = card}, context.blueprint_card or card)
                elseif reward == "mult" then
                    SMODS.calculate_effect({mult = card.ability.extra.mult, message_card = card}, context.blueprint_card or card)
                elseif reward == "xmult" then
                    SMODS.calculate_effect({xmult = card.ability.extra.xmult, message_card = card}, context.blueprint_card or card)
                end

                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = card_reward,
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))

                    if card_reward == "Tarot" then
                        return {
                            message = localize("k_plus_tarot")
                        }
                    elseif card_reward == "Planet" then
                        return {
                            message = localize("k_plus_planet")
                        }
                    end
                end
            end
        end

        if context.individual and context.cardarea == G.play and target == "card" then
            if (context.other_card == context.scoring_hand[1] and leftright == "left") or
            (context.other_card == context.scoring_hand[#context.scoring_hand] and leftright == "right") then
                if reward == "chips" then
                    SMODS.calculate_effect({chips = card.ability.extra.chips, message_card = context.other_card}, context.blueprint_card or card)
                elseif reward == "mult" then
                    SMODS.calculate_effect({mult = card.ability.extra.mult, message_card = context.other_card}, context.blueprint_card or card)
                elseif reward == "xmult" then
                    SMODS.calculate_effect({xmult = card.ability.extra.xmult, message_card = context.other_card}, context.blueprint_card or card)
                end

                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = card_reward,
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    if card_reward == "Tarot" then
                        return {
                            message = localize("k_plus_tarot")
                        }
                    elseif card_reward == "Planet" then
                        return {
                            message = localize("k_plus_planet")
                        }
                    end
                end
            end
        end
    end
}