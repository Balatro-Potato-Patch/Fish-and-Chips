FishAndChips.Fish {
    key = "am_jerry",
    atlas = "astra-missingno-fish",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 71, h = 72 },
    weight = 9,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "chips" },
    config = {
        extra = {
            factor = 2
        }
    },
    environments = {
        pier = 10,
        wormhole = 5
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        return { vars = { stg.factor, G.SETTINGS.SOUND.music_volume * stg.factor } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.joker_main then
            local og_music_volume = G.SETTINGS.SOUND.music_volume

            G.E_MANAGER:add_event(Event({
                blocking = false,
                func = function()
                    G.SETTINGS.SOUND.music_volume = og_music_volume * 0.25
                    play_sound('fac_am_jerry_chips')
                    return true;
                end
            }))
            G.E_MANAGER:add_event(Event({
                blocking = false,
                delay = 1.5 * G.SPEEDFACTOR,
                trigger = 'after',
                func = function()
                    if G.SETTINGS.SOUND.music_volume >= og_music_volume then
                        G.SETTINGS.SOUND.music_volume = og_music_volume
                        G:save_settings()
                        return true
                    else
                        G.SETTINGS.SOUND.music_volume = G.SETTINGS.SOUND.music_volume + 1
                        return false
                    end
                end
            }))
            return {
                chips = G.SETTINGS.SOUND.music_volume * stg.factor
            }
        end
    end,
    on_catch = function(self, card)
        local og_music_volume = G.SETTINGS.SOUND.music_volume

        G.E_MANAGER:add_event(Event({
            blocking = false,
            func = function()
                G.SETTINGS.SOUND.music_volume = og_music_volume * 0.25
                play_sound('fac_am_jerry_intro')
                return true;
            end
        }))
        G.E_MANAGER:add_event(Event({
            blocking = false,
            delay = 3 * G.SPEEDFACTOR,
            trigger = 'after',
            func = function()
                if G.SETTINGS.SOUND.music_volume >= og_music_volume then
                    G.SETTINGS.SOUND.music_volume = og_music_volume
                    G:save_settings()
                    return true
                else
                    G.SETTINGS.SOUND.music_volume = G.SETTINGS.SOUND.music_volume + 1
                    return false
                end
            end
        }))
    end
}

FishAndChips.Fish {
    key = "am_king",
    atlas = "astra-missingno-fish",
    pos = { x = 1, y = 0 },
    weight = 1,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "xmult", "rank", "king" },
    impulse_min = 0.3,
    impulse_max = 0.6,
    vel_limit = 0.75,
    config = {
        extra = {
            xmult = 1,
            gain = 0.25
        }
    },
    environments = {
        calm_pond = 1,
        garden = 1
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        return { vars = { stg.xmult, stg.gain } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.individual and context.area == G.play and context.other_card:get_id() == 13 then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                }
            else
                SMODS.scale_card(card, {
                    ref_table = stg,
                    ref_value = "xmult",
                    scalar_value = "gain",
                })
            end
        end

        if context.joker_main then
            return {
                stg.xmult
            }
        end
    end,
}

local function AM_Missingno_Get_CTypes()
    local ctypes = {}
    for k, v in pairs(SMODS.ConsumableTypes) do
        table.insert(ctypes, v.key)
    end
    return ctypes
end

FishAndChips.Fish {
    key = "am_missingno",
    atlas = "astra-missingno-fish",
    pos = { x = 2, y = 0 },
    weight = 5,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "generation" },
    impulse_min = 0.5,
    impulse_max = 0.5,
    vel_limit = 0.3,
    decision_max = 0.24,
    config = {
        extra = {
            ctype = "Planet",
            uses = 0
        }
    },
    environments = {
        pier = 5,
        city_river = 5,
        backroom = 5,
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        local loc_ctypes = {}
        for k, v in pairs(AM_Missingno_Get_CTypes()) do
            if v == 'Spectral' then
                table.insert(loc_ctypes, localize('k_spectral'))
            else
                table.insert(loc_ctypes, localize(v:lower(), 'labels'))
            end
        end
        table.insert(loc_ctypes, '$@#%')
        table.insert(loc_ctypes, '$^&Q*()@')
        table.insert(loc_ctypes, 'ERROR')
        table.insert(loc_ctypes, ')$*^%@@@$%%')
        table.insert(loc_ctypes, '%&^$^#%$$^&')
        local loc_cards = ' ' .. localize('k_fac_am_card') .. ' '
        local colour = SMODS.ConsumableTypes[stg.ctype].secondary_colour
        return {
            main_end = {
                { n = G.UIT.O, config = { object = DynaText({ string = loc_ctypes, colours = { colour }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
                { n = G.UIT.T, config = { text = loc_cards, colour = G.C.JOKER_GREY, scale = 0.32 } },
            }
        }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.open_booster then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = SMODS.create_card({ set = stg.ctype, area = G.pack_cards })
                    _card.created_by_missingno = true
                    G.pack_cards:emplace(_card)
                    stg.uses = stg.uses + 1
                    stg.ctype = pseudorandom_element(AM_Missingno_Get_CTypes(), 'MissingnoCard' .. stg.uses)
                    return true;
                end
            }))
            return {
                message = stg.ctype == 'Spectral' and localize('k_spectral') or localize(stg.ctype:lower(), 'labels'),
                colour = SMODS.ConsumableTypes[stg.ctype].secondary_colour
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local stg = card.ability.extra
        stg.ctype = pseudorandom_element(AM_Missingno_Get_CTypes(), 'MissingnoCard' .. stg.uses)
    end
}

FishAndChips.Fish {
    key = "am_shrimp",
    atlas = "astra-missingno-fish",
    pos = { x = 3, y = 0 },
    weight = 9,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "mult", "scaling" },
    config = {
        extra = {
            mult = 0,
            gain = 10,
            times = 0,
            goal = 3,
            hand = nil
        }
    },
    environments = {
        pier = 10
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        local hand_name = stg.hand and localize(stg.hand, 'poker_hands') or localize('k_none')
        return { vars = { stg.mult, stg.gain, stg.goal, stg.times, hand_name } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.joker_main then
            return {
                mult = stg.mult
            }
        end

        if context.before and not context.blueprint then
            if stg.hand then
                if context.scoring_name == stg.hand then
                    stg.times = stg.times + 1
                    SMODS.calculate_effect(
                        { message = stg.times .. '!', colour = G.C.ATTENTION, sound = 'fac_am_shrimp_' .. stg.times, pitch = 1 },
                        card)
                    if stg.times == stg.goal then
                        stg.times = 0
                        SMODS.scale_card(card, {
                            ref_table = stg,
                            ref_value = "mult",
                            scalar_value = "gain",
                        })
                    end
                else
                    stg.times = 1
                    SMODS.calculate_effect({ message = localize('k_reset'), colour = G.C.RED }, card)
                    SMODS.calculate_effect(
                        { message = stg.times .. '!', colour = G.C.ATTENTION, sound = 'fac_am_shrimp_' .. stg.times, pitch = 1 },
                        card)
                end
            else
                stg.times = 1
                stg.hand = context.scoring_name
                SMODS.calculate_effect(
                    { message = stg.times .. '!', colour = G.C.ATTENTION, sound = 'fac_am_shrimp_' .. stg.times, pitch = 1 },
                    card)
            end
        end
    end,
}

FishAndChips.Fish {
    key = "am_ascii",
    atlas = "astra-missingno-fish",
    pos = { x = 4, y = 0 },
    pixel_size = { w = 55, h = 87 },
    weight = 5,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "retrigger" },
    decision_min = 0.5,
    decision_max = 0.75,
    impulse_min = 0.24,
    impulse_max = 0.6,
    config = {
        extra = {
            retriggers = 1
        }
    },
    environments = {
        wormhole = 5
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        return { vars = { stg.retriggers } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.repetition and context.cardarea == G.play and not tonumber(localize(context.other_card.base.value, 'ranks')) then
            return {
                repetitions = stg.retriggers
            }
        end
    end,
}

FishAndChips.Fish {
    key = "am_teabag",
    atlas = "astra-missingno-fish",
    pos = { x = 0, y = 1 },
    weight = 5,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "usable", "economy" },
    blueprint_compat = false,
    requires_hand = true,
    impulse_max = 0.12,
    decision_min = 1.5,
    decision_max = 1.5,
    config = {
        extra = {
            dollars = 1
        }
    },
    environments = {
        pier = 5,
        city_river = 5,
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra

        return { vars = { stg.dollars } }
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.highlighted == 1
    end,
    use = function(self, card)
        local stg = card.ability.extra
        local affected_card = G.hand.highlighted[1]

        affected_card.ability.perma_p_dollars = affected_card.ability.perma_p_dollars + stg.dollars
        affected_card:juice_up()
        play_sound('tarot1')
    end
}

FishAndChips.Fish {
    key = "am_starcatcher",
    atlas = "astra-missingno-fish",
    pos = { x = 1, y = 1 },
    pixel_size = { w = 63, h = 74 },
    weight = 9,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "economy", "destroy_card", "suit", "diamonds" },
    blueprint_compat = false,
    config = {
        extra = {
            dollars = 1
        }
    },
    environments = {
        pier = 10,
        aquifer = 7,
        wormhole = 5
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra

        return { vars = { stg.dollars } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.before then
            local cards_to_destroy = {}
            for k, v in pairs(context.scoring_hand) do
                if v:is_suit('Diamonds') then
                    table.insert(cards_to_destroy, v)
                end
            end
            if next(cards_to_destroy) then
                SMODS.destroy_cards(cards_to_destroy)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.8, 0.8)
                        return true;
                    end
                }))
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "extra_value",
                    scalar_table = stg,
                    scalar_value = "dollars",
                    scalar_factor = #cards_to_destroy,
                    scaling_message = {
                        message = localize('k_val_up'),
                        colour = FishAndChips.C.SAND_DOLLAR,
                        sound = 'fac_am_chomp',
                        pitch = 1
                    }
                })
                card:set_cost()
            end
        end
    end,
}

FishAndChips.Fish {
    key = "am_chameleon",
    atlas = "astra-missingno-fish",
    pos = { x = 3, y = 1 },
    weight = 5,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "copying" },
    environments = {
        wormhole = 5,
        city_river = 5,
        backroom = 5
    },
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.fac_fish_area then
            local other_joker
            if #G.jokers.cards % 2 == 1 then
                other_joker = G.jokers.cards[math.ceil(#G.jokers.cards / 2)]
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = " " .. localize("k_" .. (compatible and "compatible" or "incompatible")) .. " ", colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        local other_joker
        if #G.jokers.cards % 2 == 1 then
            other_joker = G.jokers.cards[math.ceil(#G.jokers.cards / 2)]
        end

        return SMODS.blueprint_effect(card, other_joker, context)
    end,
}

FishAndChips.Fish {
    key = "am_mola",
    atlas = "astra-missingno-fish",
    pos = { x = 4, y = 1 },
    pixel_size = { w = 68, h = 66 },
    weight = 7,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "boss_blind" },
    blueprint_compat = false,
    impulse_max = 0.2,
    decision_min = 0.6,
    decision_max = 1,
    vel_limit = 0.6,
    config = {
        extra = {
            prob = 1,
            odds = 3
        }
    },
    environments = {
        pier = 7
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        local num, den = SMODS.get_probability_vars(card, stg.prob, stg.odds, "fac_am_mola")
        return { vars = { num, den } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.ending_shop and SMODS.pseudorandom_probability(card, "fac_am_mola", stg.prob, stg.odds) then
            SMODS.destroy_cards(card, { pinch_anim = true })
        end

        if context.setting_blind and not card.getting_sliced and context.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:disable()
                            play_sound('timpani')
                            delay(0.4)
                            return true
                        end
                    }))
                    return true
                end
            }))
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
            return nil, true
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local stg = card.ability.extra

        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end
    end,
}

FishAndChips.Fish {
    key = "am_dopefish",
    atlas = "astra-missingno-fish",
    pos = { x = 0, y = 2 },
    pixel_size = { w = 61, h = 71 },
    weight = 7,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "destroy_cards", "xmult" },
    blueprint_compat = false,
    config = {
        extra = {
            xmult = 1,
            gain = 0.2
        }
    },
    environments = {
        wormhole = 8,
        aquifer = 8,
        swamp = 8
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra

        return { vars = { stg.xmult, stg.gain } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.setting_blind then
            local cards_to_destroy = {}

            for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] == card then
                    if i ~= 1 and not G.fac_fish_area.cards[i - 1].getting_sliced then
                        table.insert(cards_to_destroy, G.fac_fish_area.cards[i - 1])
                    end
                    if i ~= #G.fac_fish_area.cards and not G.fac_fish_area.cards[i + 1].getting_sliced then
                        table.insert(cards_to_destroy, G.fac_fish_area.cards[i + 1])
                    end
                end
            end

            if next(cards_to_destroy) then
                SMODS.destroy_cards(cards_to_destroy)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card:juice_up(0.8, 0.8)
                        return true;
                    end
                }))
                SMODS.scale_card(card, {
                    ref_table = stg,
                    ref_value = "xmult",
                    scalar_value = "gain",
                    scalar_factor = #cards_to_destroy,
                    scaling_message = {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { stg.xmult + (stg.gain * #cards_to_destroy) } },
                        colour = G.C.FILTER,
                        sound = 'fac_am_chomp',
                        pitch = 1,
                    }
                })
            end
        end

        if context.joker_main then
            return {
                xmult = stg.xmult
            }
        end
    end,
}

FishAndChips.Fish {
    key = "am_piscis",
    atlas = "astra-missingno-fish",
    pos = { x = 1, y = 2 },
    weight = 5,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "usable", "hand_level" },
    blueprint_compat = false,
    treasure = true,
    config = {
        extra = {
            levels = 2,
            last_hand = nil
        }
    },
    environments = {
        wormhole = 5,
        styx = 5
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra

        local hand = G.GAME.last_hand_played or 'High Card'

        return {
            vars = {
                stg.levels,
                G.GAME.hands[hand].level,
                localize(hand, 'poker_hands'),
                G.GAME.hands[hand].l_mult * stg.levels,
                G.GAME.hands[hand].l_chips * stg.levels,
                colours = {
                    (G.GAME.hands[hand].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[hand].level)])
                }
            }
        }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.before then
            stg.last_hand = context.scoring_name
        end
    end,
    can_use = function(self, card)
        return card.ability.extra.last_hand
    end,
    use = function(self, card)
        local stg = card.ability.extra

        SMODS.upgrade_poker_hands({ hands = G.GAME.last_hand_played, level_up = stg.levels, from = card })
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local stg = card.ability.extra

        stg.last_hand = G.GAME.last_hand_played or 'High Card'
    end
}

FishAndChips.Fish {
    key = "am_blubby",
    atlas = "astra-missingno-fish",
    pos = { x = 2, y = 1 },
    pixel_size = { w = 52, h = 54 },
    weight = 3,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "passive" },
    config = {
        extra = {
            rerolls = 0,
            percent = 100
        }
    },
    environments = {
        wormhole = 3,
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra

        return { vars = { stg.percent, stg.rerolls } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.starting_shop then
            SMODS.change_free_rerolls(stg.rerolls)
        end

        if context.ending_shop then
            SMODS.change_free_rerolls(-stg.rerolls)
            stg.rerolls = 0
        end

        if context.end_of_round and not context.individual and not context.repetition then
            stg.rerolls = math.floor((G.GAME.chips / G.GAME.blind.chips) / (stg.percent / 100))
            if stg.rerolls > 0 then
                return {
                    message = localize { type = 'variable', key = 'a_fac_am_rerolls', vars = { stg.rerolls } }
                }
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        local stg = card.ability.extra

        SMODS.change_free_rerolls(stg.rerolls)
    end,
    remove_from_deck = function(self, card, from_debuff)
        local stg = card.ability.extra

        SMODS.change_free_rerolls(-stg.rerolls)
    end,
}

FishAndChips.Fish {
    key = "am_chocolat",
    atlas = "astra-missingno-fish",
    pos = { x = 2, y = 2 },
    weight = 5,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNo" },
    attributes = { "passive", "food", "modify_card", "edition" },
    config = {
        extra = {
            times = 3,
        }
    },
    environments = {
        chocolate_river = 4,
        backroom = 2,
        soup = 2,
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra

        return { vars = { stg.times } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.fac_end_fishing and context.perfect then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local edition = SMODS.poll_edition({ guaranteed = true })
                    stg.times = stg.times - 1

                    SMODS.calculate_effect({
                        message = localize { type = 'variable', key = 'a_fac_am_blank_left', vars = { stg.times } },
                        sound = 'fac_am_le_fishe',
                    }, card)
                    
                    context.fish_obj:set_edition(edition)

                    if stg.times <= 0 then
                        G.E_MANAGER:add_event(Event({
                            delay = 0.4,
                            trigger = 'after',
                            func = function()
                                card.area:remove_card(card)
                                G.FISHING.fac_fish_reward_area:emplace(card)
                                play_sound('fac_am_le_fishe_death')
                                return true;
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    delay = 0.6,
                                    trigger = 'after',
                                    func = function()
                                        SMODS.destroy_cards(card, { pinch_anim = true })
                                        return true;
                                    end
                                }))
                                return true;
                            end
                        }))
                    end
                    return true;
                end
            }))
        end
    end,
}
