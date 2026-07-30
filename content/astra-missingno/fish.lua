FishAndChips.Fish {
    key = "am_jerry",
    atlas = "astra-missingno-fish",
    pos = { x = 0, y = 0 },
    pixel_size = { w = 71, h = 72 },
    weight = 10,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
    attributes = { "" },
    config = {

    },
    environments = {
        pier = 10,
        wormhole = 5
    },
    loc_vars = function(self, info_queue, card)

    end,
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
        calm_pond = 3
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
        pier = 5
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
        table.insert(loc_ctypes, ')$*^%@@@$%%')
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

        if context.before then
            if stg.hand then
                if context.scoring_name == stg.hand then
                    stg.times = stg.times + 1
                    SMODS.calculate_effect({ message = stg.times .. '!', colour = G.C.ATTENTION, sound = 'fac_am_shrimp_' .. stg.times, pitch = 1 },card)
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
                    SMODS.calculate_effect({ message = localize('k_reset'), colour = G.C.RED },card)
                    SMODS.calculate_effect({ message = stg.times .. '!', colour = G.C.ATTENTION, sound = 'fac_am_shrimp_' .. stg.times, pitch = 1 },card)
                end
            else
                stg.times = 1
                stg.hand = context.scoring_name
                SMODS.calculate_effect({ message = stg.times .. '!', colour = G.C.ATTENTION, sound = 'fac_am_shrimp_' .. stg.times, pitch = 1 },card)
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
    weight = 10,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
    attributes = { "" },
    config = {

    },
    environments = {
        pier = 10
    },
    loc_vars = function(self, info_queue, card)

    end,
}

FishAndChips.Fish {
    key = "am_starcatcher",
    atlas = "astra-missingno-fish",
    pos = { x = 1, y = 1 },
    pixel_size = { w = 63, h = 74 },
    weight = 10,
    ppu_coder = { "theAstra" },
    ppu_artist = { "MissingNumber" },
    attributes = { "" },
    config = {

    },
    environments = {
        pier = 10,
        wormhole = 5
    },
    loc_vars = function(self, info_queue, card)

    end,
}
