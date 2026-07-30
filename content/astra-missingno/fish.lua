FishAndChips.Fish {
    key = "am_jerry",
    atlas = "astra-missingno-fish",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 71, h = 72 },
    weight = 10,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
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
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('fac_am_jerry_chips')
                    return true;
                end
            }))
            return {
                chips = G.SETTINGS.SOUND.music_volume * stg.factor
            }
        end
    end,
    on_catch = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('fac_am_jerry_intro')
                return true;
            end
        }))
    end
}

FishAndChips.Fish {
    key = "am_king",
    atlas = "astra-missingno-fish",
    pos = { x = 1, y = 0 },
    weight = 3,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
    attributes = { "xmult", "rank", "king" },
    config = {
        extra = {
            xmult = 1.5
        }
    },
    environments = {
        calm_pond = 3,
        garden = 3
    },
    loc_vars = function(self, info_queue, card)
        local stg = card.ability.extra
        return { vars = { stg.xmult, colours = { HEX('789d8e'), HEX('9e9f9d') } } }
    end,
    calculate = function(self, card, context)
        local stg = card.ability.extra

        if context.individual and context.area == 'unscoring' and context.other_card:get_id() == 13 then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                }
            else
                return {
                    x_mult = stg.xmult,
                }
            end
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
    ppu_artist = { "MissingNumber" },
    attributes = { "generation" },
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
    weight = 10,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
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
    ppu_artist = { "MissingNumber" },
    attributes = { "retrigger" },
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

        if context.repetitio and context.cardarea == G.play and not tonumber(localize(context.other_card.base.value, 'ranks')) then
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
    ppu_artist = { "MissingNumber" },
    attributes = { "usable", "economy" },
    blueprint_compat = false,
    requires_hand = true,
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
    weight = 10,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
    attributes = { "economy", "destroy_card", "rank", "diamonds" },
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
    ppu_artist = { "MissingNumber" },
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
    ppu_artist = { "MissingNumber" },
    attributes = { "boss_blind" },
    blueprint_compat = false,
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
    weight = 8,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
    attributes = { "destroy_cards", "xmult" },
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

        return { vars = { stg.xmult, stg.gain }}
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
                        message = localize{type='variable',key='a_xmult',vars={ stg.xmult + (stg.gain * #cards_to_destroy)}},
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
