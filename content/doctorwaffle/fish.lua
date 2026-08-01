-- Atlas
SMODS.Atlas {
    key = "waffle_fish",
    path = "doctorwaffle/fish.png",
    px = 71,
    py = 95
}

-- Magic Conch sounds
SMODS.Sound {
    key = "fac_waffle_conch_yes",
    path = "doctorwaffle/conch_yes.ogg"
}
SMODS.Sound {
    key = "fac_waffle_conch_no",
    path = "doctorwaffle/conch_no.ogg"
}
SMODS.Sound {
    key = "fac_waffle_conch_i_dont_think_so",
    path = "doctorwaffle/conch_i_dont_think_so.ogg"
}
SMODS.Sound {
    key = "fac_waffle_conch_try_again",
    path = "doctorwaffle/conch_try_again.ogg"
}
SMODS.Sound {
    key = "fac_waffle_conch_nothing",
    path = "doctorwaffle/conch_nothing.ogg"
}

-- Magic Conch
FishAndChips.Fish {
    key = "waffle_magic_conch",
    atlas = "waffle_fish",
    weight = 10,
    environments = {
        pier = 1,
        calm_pond = 0.2
    },
    pixel_size = { h = 77 },
    blueprint_compat = false,
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    cost = 5,
    config = { extra = {
        odds = 2,
        used_this_round = false
    } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
        return {
            vars = { num, den }
        }
    end,
    can_use = function(self, card)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit and card.ability.extra.used_this_round == false
    end,
    use = function(self, card)
        -- Determine which card asks for food
        local askingCard = nil
        local eligibleFish = {}
        for _, fish in ipairs(G.fac_fish_area.cards) do
            if fish.config.center.key ~= "fish_fac_waffle_magic_conch" then
                eligibleFish[#eligibleFish + 1] = fish
            end
        end
        if #eligibleFish > 0 then
            askingCard = pseudorandom_element(eligibleFish, "fac_waffle_magic_conch_asker")
        elseif G.jokers and #G.jokers.cards > 0 then
            askingCard = pseudorandom_element(G.jokers.cards, "fac_waffle_magic_conch_asker")
        else
            askingCard = G.deck.cards[1] or pseudorandom_element(G.hand.cards, "fac_waffle_magic_conch_asker")
        end

        -- Determine if the conch says yes
        local askingSucceeded = SMODS.pseudorandom_probability(card, "fac_wafflemod_magic_conch_success", 1,
            card.ability.extra.odds)

        -- Conversation
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, 5 do
                    delay(0.12 * G.SETTINGS.GAMESPEED)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            askingCard:juice_up()
                            play_sound("voice" .. math.random(1, 11)) -- Voice samples used doesn't use pseudorandom but it's not relevant to gameplay so this shouldn't cause issues?
                            return true
                        end
                    }))
                end
                delay(0.52 * G.SETTINGS.GAMESPEED)
                if askingSucceeded then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card:juice_up()
                            play_sound("fac_waffle_conch_yes")
                            return true
                        end
                    }))
                else
                    local noFuncs = {

                        function()
                            card:juice_up()
                            play_sound("fac_waffle_conch_no")
                            delay(0.4 * G.SETTINGS.GAMESPEED)
                        end,

                        function()
                            card:juice_up()
                            play_sound("fac_waffle_conch_try_again")
                            delay(0.2 * G.SETTINGS.GAMESPEED)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card:juice_up()
                                    return true
                                end
                            }))
                            delay(0.42 * G.SETTINGS.GAMESPEED)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card:juice_up()
                                    return true
                                end
                            }))
                            delay(0.4 * G.SETTINGS.GAMESPEED)
                        end,

                        function()
                            card:juice_up()
                            play_sound("fac_waffle_conch_i_dont_think_so")
                            delay(0.12 * G.SETTINGS.GAMESPEED)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card:juice_up()
                                    return true
                                end
                            }))
                            delay(0.14 * G.SETTINGS.GAMESPEED)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card:juice_up()
                                    return true
                                end
                            }))
                            delay(0.2 * G.SETTINGS.GAMESPEED)
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    card:juice_up()
                                    return true
                                end
                            }))
                            delay(0.4 * G.SETTINGS.GAMESPEED)
                        end,

                    }


                    G.E_MANAGER:add_event(Event({
                        func = function()
                            -- Play a random "no" sound
                            pseudorandom_element(noFuncs, "fac_waffle_conch_which_no")() -- Pick a random "no" sound
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.E_MANAGER:add_event(Event({
                                        trigger = 'after',
                                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                                        blockable = false,
                                        blocking = false,
                                        func = function()
                                            play_sound('tarot2', 0.76, 0.4)
                                            return true
                                        end
                                    }))
                                    play_sound('tarot2', 1, 0.4)
                                    card:juice_up(0.3, 0.5)
                                    SMODS.calculate_effect({ message = localize('k_nope_ex'), colour = G.C.PURPLE }, card)
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                end
                card.ability.extra.used_this_round = true

                -- Create food joker on success
                if askingSucceeded then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.6 * G.SETTINGS.GAMESPEED,
                        func = function()
                            play_sound('timpani')
                            SMODS.add_card { set = "Joker", area = G.jokers, attributes = { 'food' }, key_append = "fac_wafflemod_conch_create" }
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                end

                return true
            end
        }))
    end,
    keep_on_use = function(self, card)
        return true
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.end_of_round and context.main_eval and not context.game_over and card.ability.extra.used_this_round then
                card.ability.extra.used_this_round = false
                card:juice_up()
                return {
                    message = localize('k_fac_waffle_ready_ex'),
                    colour = G.C.PURPLE
                }
            end
            if card.ability.extra.doingNothing and (context.press_play or context.discard or context.selling_card or context.using_consumeable) then
                card.ability.extra.doingNothing = nil
            end
            if context.setting_blind and context.blind.key == "bl_plant" then -- The Funniest And Dumbest Easter Egg Ever
                card.ability.extra.doingNothing = true
                local x, y = love.mouse.getPosition()
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 60 * G.SETTINGS.GAMESPEED,
                    blocking = false,
                    func = function()
                        --print("60 seconds have passed")
                        local newX, newY = love.mouse.getPosition()
                        if card and card.ability.extra.doingNothing and newX == x and newY == y and G.GAME and G.GAME.blind and G.GAME.blind.config.blind.key == "bl_plant" then
                            card.ability.extra.doingNothing = nil
                            if G.STATE == G.STATES.SELECTING_HAND then
                                play_sound("fac_waffle_conch_nothing")
                                card:juice_up()

                                delay(0.8 * G.SETTINGS.GAMESPEED)

                                G.GAME.chips = G.GAME.blind.chips
                                G.STATE = G.STATES.HAND_PLAYED
                                G.STATE_COMPLETE = true
                                end_round()
                            end
                        end
                        return true
                    end
                }))
            end
        end
    end,
    attributes = { "generation", "joker", "chance" }
}

-- Percheo
FishAndChips.Fish {
    key = "waffle_percheo",
    atlas = "waffle_fish",
    weight = 3,
    environments = {
        garden = 1,
    },
    cost = 10,
    pos = { x = 1, y = 0 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    calculate = function(self, card, context)
        if context.fac_end_fishing and context.treasure and G.consumeables.cards[1] then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local choose_consumable, _ = pseudorandom_element(G.consumeables.cards, 'fac_waffle_percheo')
                    local copy = SMODS.copy_card(choose_consumable)
                    copy:set_edition("e_negative", true)
                    return true
                end
            }))
            return { message = localize('k_duplicated_ex') }
        end
    end,
    vel_limit = 0.7,
    impulse_min = 0.42,
    impulse_max = 0.48,
    decision_max = 0.24,
    decision_min = 0.1,
    treasure = true,
    attributes = { "generation" }
}

-- Dead Fish
FishAndChips.Fish {
    key = "waffle_dead_fish",
    atlas = "waffle_fish",
    pos = { x = 2, y = 0 },
    environments = {
        styx = 1,
        backroom = 1
    },
    weight = 10,
    cost = 4,
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    config = { extra = {
        sand_dollars = 2
    } },
    blueprint_compat = false, -- i would like having compat be true here but trading card isn't compat for extra dosh (sadge)
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.sand_dollars
            }
        }
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card:get_id() == 2 and not context.blueprint then
            --context.other_card:remove()
            --SMODS.destroy_cards(context.other_card)
            return {
                remove = true,
                sand_dollars = card.ability.extra.sand_dollars
            }
        end
    end,
    attributes = { "economy", "destroy_card" }
}

-- Squid Ink Cookie
FishAndChips.Fish {
    key = "waffle_squid_ink_cookie",
    atlas = "waffle_fish",
    pos = { x = 3, y = 0 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 10,
    pixel_size = { h = 83 },
    cost = 4,
    environments = {
        chocolate_river = 1,
        soup = 0.8,
    },
    loc_vars = function(self, info_queue, card)
        local quotes = {
            "Hungry...",
            "Sorrow...",
            "Sob... sob...",
            "Don't know...",
            "Who... am...",
            "Sob sob...",
            "Shiny... things...",
            "Dark... lonely...",
            "Lost... everything...",
            "Haaah...",
            "Into... water...",
            "Remember... nothing..."
        }
        return {
            vars = {
                card.ability.extra.dollars,
                card.ability.extra.conv_amount,
                card.ability.extra.conv_amount > 1 and "s" or "",
                card.ability.extra.conv_suit,
                quotes[math.random(1, #quotes)],
                colours = { G.C.SUITS[card.ability.extra.conv_suit] }
            }
        }
    end,
    config = { extra = {
        conv_suit = "Spades",
        dollars = 1,
        conv_amount = 2,
    } },
    calculate = function(self, card, context)
        if context.before then
            for i = 1, card.ability.extra.conv_amount do
                local nonSpadesCards = {}
                for _, cardInDeck in pairs(G.deck.cards) do
                    if not cardInDeck:is_suit(card.ability.extra.conv_suit) then
                        nonSpadesCards[#nonSpadesCards + 1] = cardInDeck
                    end
                end
                if nonSpadesCards[1] then
                    local chosenCard = pseudorandom_element(nonSpadesCards, "fac_waffle_squid_ink_card")
                    SMODS.change_base(chosenCard, card.ability.extra.conv_suit)
                end
            end
            return {
                dollars = -card.ability.extra.dollars,
                colour = G.C.SUITS[card.ability.extra.conv_suit]
            }
        end
    end,
    attributes = { "suit" },
    pronouns = "they_them",
    vel_limit = 0.7,
    impulse_max = 0.8,
    impulse_min = 0.65,
    decision_min = 0.75,
    decision_max = 0.95
}

-- Mudskipper
FishAndChips.Fish {
    key = "fac_waffle_mudskipper",
    atlas = "waffle_fish",
    pos = { x = 4, y = 0 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 10,
    cost = 5,
    environments = {
        swamp = 1,
        calm_pond = 0.65,
    },
    attributes = { "passive" },
    calculate = function(self, card, context)
        if context.fac_end_fishing then -- thanks eremel
            local tag_pool = get_current_pool('Tag')
            local selected_tag = pseudorandom_element(tag_pool, 'fac_waffle_mudskipper_tag')
            local it = 1
            while selected_tag == 'UNAVAILABLE' do
                it = it + 1
                selected_tag = pseudorandom_element(tag_pool, 'fac_waffle_mudskipper_tag_resample' .. it)
            end
            add_tag(Tag(selected_tag, false, 'Small'))
            return {
                message = localize('k_fac_waffle_tag')
            }
        end
    end,
    impulse_max = 0.45
}

-- Reginald The Teleporting Sea Urchin
FishAndChips.Fish {
    key = "fac_waffle_reginald",
    atlas = "waffle_fish",
    pos = { x = 5, y = 0 },
    pixel_size = { h = 60 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 10,
    cost = 6,
    blueprint_compat = false,
    environments = {
        backroom = 1,
        wormhole = 1,
    },
    attributes = { "passive" },
    calculate = function(self, card, context)
        if context.fac_end_fishing and not context.blueprint then
            -- THIS IS ALL TEMPORARY UNTIL THE BUTTON CALLBACK IS NO LONGER HARDCODED
            -- COPYPASTING HARDCODED CODE IS STINKY AND BAD BUT I LIKE THIS FISH CONCEPT
            G.E_MANAGER:add_event(Event({
                blocking = false,
                func = function()
                    if G.FISHING_STATE == G.FISHING_STATES.LOBBY and not FishAndChips.in_tutorial then
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 1,
                            func = function()
                                FishAndChips:stop_ambience()
                                play_sound('other1')
                                local old_env = G.GAME.fac_fishing_environment
                                G.GAME.fac_fishing_environment = G.GAME.fac_next_environment or
                                    pseudorandom_element(FishAndChips.Environments, "fac_next_location", {
                                        in_pool = function(v, args)
                                            return v.key ~= G.GAME.fac_fishing_environment
                                        end
                                    }).key
                                SMODS.calculate_context { fac_environment_changed = G.GAME.fac_fishing_environment, old_environment = old_env, forced = G.GAME.fac_next_environment and true }
                                if G.GAME.fac_next_environment then G.GAME.fac_next_environment = nil end
                                G.FISHING_STATE = G.FISHING_STATES.MOVING
                                G.FISHING_STATE_COMPLETE = false
                                return true
                            end
                        }))
                        return true
                    else
                        return false
                    end
                end
            }))
        end
    end,
}

-- Double Dicefin
FishAndChips.Fish {
    key = "fac_waffle_double_dicefin",
    atlas = "waffle_fish",
    pos = {x = 6, y = 0},
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 10,
    environments = {
        city_river = 1,
        backroom = 0.6
    },
    config = { extra = {
        boost = 2,
        active = false
    } },
    cost = 6,
    loc_vars = function (self, info_queue, card)
         local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = card.ability.extra.active and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (card.ability.extra.active and 'active' or 'fac_waffle_inactive')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.9 } },
                            }
                        }
                    }
                }
            }
            return { 
                main_end = main_end,
                vars = {card.ability.extra.boost}
             }
    end,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.mod_probability and card.ability.extra.active then
                return {
                    numerator = context.numerator * card.ability.extra.boost
                }
            end
            if context.fac_end_fishing and context.perfect and not context.blueprint then
                if not card.ability.extra.active then
                    card.ability.extra.active = true
                    return {
                        message = localize('k_active_ex'),
                        colour = G.C.GREEN
                    }
                end
            end
            if context.end_of_round and context.main_eval and not context.game_over then
                card.ability.extra.active = false
            end
        end
    end,
    attributes = { "mod_chance", "passive" }
}

