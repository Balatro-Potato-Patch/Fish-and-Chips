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
        if context.mod_probability and not context.blueprint then
            if card.ability.extra.hands_counter >= card.ability.extra.hands_needed then
                return {
                    numerator = context.numerator * card.ability.extra.odds_mult
                }
            end
        end
        if context.after and not context.blueprint then
            if card.ability.extra.hands_counter >= card.ability.extra.hands_needed then
                return {
                    message = localize("k_active_ex"),
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
    key = "J8-Bit_nocto_octo",
    atlas = "fac_j8bit_fish",
    pos = { x = 1, y = 1 },
    weight = 4.5,
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
    key = "J8-Bit_boostorca",
    atlas = "fac_j8bit_fish",
    pos = { x = 2, y = 1 },
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
