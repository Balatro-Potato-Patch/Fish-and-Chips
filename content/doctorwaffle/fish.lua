-- TODO: port stuff to badge_key

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

SMODS.ObjectType({
    key = "fac_waffle_self_finsert_spawns",
    default = "fish_fac_waffle_magic_conch",
    cards = {
        fish_fac_waffle_magic_conch = true,
        fish_fac_waffle_percheo = true,
        fish_fac_waffle_dead_fish = true,
        fish_fac_waffle_squid_ink_cookie = true,
        fish_fac_waffle_mudskipper = true,
        fish_fac_waffle_double_dicefin = true,
        fish_fac_waffle_gossamer_worm = true,
        fish_fac_waffle_bonus_duck = true,
        fish_fac_waffle_onion_fish = true,
        fish_fac_waffle_finclair = true,
        fish_fac_waffle_worn_book = true,
        fish_fac_waffle_handchovies = true,
        fish_fac_waffle_unemployster = true,
        fish_fac_waffle_scaly_foot_snail = true,
        fish_fac_waffle_pyukumuku = true,
    }
})

-- Functions
local waffleFunctions = {}
do
    function waffleFunctions.flipFunctionCards(cards, applyFunc)
        stop_use()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                return true
            end
        }))
        for i = 1, #cards do
            local percent = math.max(1.15 - (i - 0.999) / (#cards - 0.998) * 0.3, 0)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    cards[i]:flip()
                    play_sound('card1', percent)
                    cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.15)
        for i = 1, #cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    applyFunc(cards[i])
                    return true
                end
            }))
        end
        delay(0.2)
        for i = 1, #cards do
            local percent = math.max(1.15 - (i - 0.999) / (#cards - 0.998) * 0.3, 0)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    cards[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
    end

    function waffleFunctions.getCardToRight(card)
        local cardToRight
        if card.area then
            for i = 1, #card.area.cards do
                if card.area.cards[i] == card then
                    cardToRight = card.area.cards[i + 1]
                end
            end
        end
        return cardToRight
    end

    function waffleFunctions.isCardInCollection(card)
        return card.area.config.collection
    end

    function waffleFunctions.addDucksToDeck(deck)
            local allCards = {}                                                  -- Initialize list of cards in deck

        for i = 1, #deck.cards do                                            -- Add cards in deck to allCards and reset their duck value
            deck.cards[i].ability.fac_extra = deck.cards[i].ability.fac_extra or {}
            deck.cards[i].ability.fac_extra.fac_waffle_duck = false
            allCards[#allCards + 1] = deck.cards[i]
        end

        local bonusDuckCards = {} -- Initialize list of cards to add ducks do

        local duckRatio = 0.3
        for _, fish in pairs(G.fac_fish_area.cards) do
            if fish.ability and fish.ability.extra and fish.ability.extra.duck_ratio then
                duckRatio = math.max(duckRatio, fish.ability.extra.duck_ratio)
            end
        end

        for i = 1, math.ceil(#allCards * duckRatio) do -- Remove cards from deck list as they are added to duck list (this ensures the same card doesn't get ducked twice)
            local chosenCardIndex = pseudorandom("fac_waffle_bonus_duck_choose", 1, #allCards)
            bonusDuckCards[#bonusDuckCards + 1] = allCards[chosenCardIndex]
            table.remove(allCards, chosenCardIndex)
        end

        for i = 1, #bonusDuckCards do -- Set duck variable to all cards
            bonusDuckCards[i].ability.fac_extra = bonusDuckCards[i].ability.fac_extra or {}
            bonusDuckCards[i].ability.fac_extra.fac_waffle_duck = true
        end
end

end

-- Bonus Duck sounds
local numDuckSounds = 7
for i = 1, 7 do
    SMODS.Sound {
        key = "fac_waffle_duck" .. i,
        path = "doctorwaffle/duck" .. i .. ".ogg",
        pitch = 1,
    }
end

-- Magic Conch
FishAndChips.Fish {
    key = "waffle_magic_conch",
    atlas = "waffle_fish",
    weight = 4,
    environments = {
        pier = 1,
        calm_pond = 0.6
    },
    pixel_size = { h = 77, w = 71 },
    blueprint_compat = false,
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    requires_jokers = true,
    stats = {
        weight = { min = 0.1, max = 0.11 },
        length = { min = 0.05, max = 0.051 }
    },
    config = { extra = {
        odds = 2,
        used_this_round = false
    } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)

        return {
            key = math.random() < 1 / 20 and "fish_fac_waffle_magic_conch_secret",
            vars = { num, den, ppu_bubbles = { card.ability.extra.used_this_round and "used" or "usable" } }
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
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_conch'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
    attributes = { "generation", "joker", "chance", "usable" }
}

-- Percheo
FishAndChips.Fish {
    key = "waffle_percheo",
    atlas = "waffle_fish",
    weight = 1,
    environments = {
        garden = 1,
    },
    cost = 10,
    stats = {
        weight = { min = 0.45, max = 0.6 },
        length = { min = 0.08, max = 0.12 }
    },
    requires_consumables = true,
    pos = { x = 1, y = 0 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return {}
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing and not context.failed and context.treasure then
            local new_card
            G.E_MANAGER:add_event(Event({
                func = function ()
                    local choose_set = pseudorandom_element({"Tarot", "Planet"}, "fac_waffle_percheo")
                    new_card = SMODS.create_card({set = choose_set, edition = 'e_negative'})
                    new_card.T.x = card.T.x - 0.5
                    new_card.T.y = card.T.y - 2.5
                    new_card.states.drag.can = false
                    new_card.states.hover.can = false
                    return true
                end
            }))
            delay(2)
            G.E_MANAGER:add_event(Event({
                func = function ()
                    G.consumeables:emplace(new_card)
                    return true
                end
            }))
        end
    end,
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_negative_consumable', set = 'Edition', config = { extra = 1 } }
    end,
    vel_limit = 0.7,
    impulse_min = 0.42,
    impulse_max = 0.48,
    decision_max = 0.24,
    decision_min = 0.1,
    treasure = true,
    attributes = { "generation", "consumable", }
}

-- Dead Fish
FishAndChips.Fish {
    key = "waffle_dead_fish",
    atlas = "waffle_fish",
    pos = { x = 2, y = 0 },
    stats = {
        weight = { min = 1.30, max = 4.50 },
        length = { min = 0.20, max = 0.45 }
    },
    environments = {
        styx = 1,
        wormhole = 0.5
    },
    weight = 4,
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
    attributes = { "economy", "destroy_card", "rank", "two", }
}

-- Squid Ink Cookie
FishAndChips.Fish {
    key = "waffle_squid_ink_cookie",
    atlas = "waffle_fish",
    pos = { x = 3, y = 0 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    pixel_size = { h = 83, w = 71 },
    cost = 5,
    environments = {
        chocolate_river = 1,
        pier = 0.75,
        soup = 0.6
    },
    stats = {
        weight = { min = 0.04, max = 0.041 },
        length = { min = 0.10, max = 0.101 }
    },
    flavour_vars = function()
        return { vars = { localize("fac_waffle_squid_ink"..math.random(1, 12)) } }
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.dollars,
                card.ability.extra.conv_amount,
                card.ability.extra.conv_amount > 1 and "s" or "",
                card.ability.extra.conv_suit,
                colours = { G.C.SUITS[card.ability.extra.conv_suit] },
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
    attributes = { "suit", "spades", "full_deck", "lose_economy", "modify_card" },
    pronouns = "they_them",
    vel_limit = 0.6,
    impulse_max = 0.75,
    impulse_min = 0.62,
    decision_min = 0.75,
    decision_max = 0.95,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_cookie'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
}

-- Mudskipper
FishAndChips.Fish {
    key = "fac_waffle_mudskipper",
    atlas = "waffle_fish",
    pos = { x = 4, y = 0 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    cost = 4,
    environments = {
        swamp = 1,
        calm_pond = 0.65,
        aquifer = 0.65,
    },
    stats = {
        weight = { min = 0.05, max = 0.09 },
        length = { min = 0.10, max = 0.30 }
    },
    config = { extra = {
        tag_created = false
    } },
    loc_vars = function (self, info_queue, card)
        return {vars = {ppu_bubbles = {card.ability.extra.tag_created and 'inactive' or 'active'}}}
    end,
    attributes = { "generation", "tag" }, -- Doesn't really generate cards per se, but this is really the only fitting bait attribute I can think of -- Tag generation *is* generation (mf)
    calculate = function(self, card, context)
        if context.fac_end_fishing and not context.failed and not card.ability.extra.tag_created then -- thanks eremel
            local tag_pool = get_current_pool('Tag')
            local selected_tag = pseudorandom_element(tag_pool, 'fac_waffle_mudskipper_tag')
            local it = 1
            while selected_tag == 'UNAVAILABLE' do
                it = it + 1
                selected_tag = pseudorandom_element(tag_pool, 'fac_waffle_mudskipper_tag_resample' .. it)
            end
            add_tag(Tag(selected_tag))
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.ability.extra.tag_created = true
                    return true
                end
            }))
            return {
                message = localize('k_fac_waffle_tag')
            }
        end
        if context.ending_fishing then
            card.ability.extra.tag_created = false
        end
    end,
    impulse_max = 0.45
}

-- Reginald The Teleporting Sea Urchin
-- Notes: I copy-pasted the code from button_callbacks which is not exactly good code practice but is functional
FishAndChips.Fish {
    key = "fac_waffle_reginald",
    atlas = "waffle_fish",
    pos = { x = 5, y = 0 },
    pixel_size = { h = 60, w = 71 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    cost = 5,
    blueprint_compat = false,
    environments = {
        backroom = 1,
        wormhole = 1,
    },
    stats = {
        weight = { min = 0.03, max = 0.45 },
        length = { min = 0.03, max = 0.12 }
    },
    attributes = { "passive" },
    calculate = function(self, card, context)
        if context.fac_end_fishing and not context.failed and not context.blueprint then
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
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_echinoderm'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
}

-- Double Dicefin
FishAndChips.Fish {
    key = "fac_waffle_double_dicefin",
    atlas = "waffle_fish",
    pos = { x = 6, y = 0 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    environments = {
        city_river = 1,
        garden = 0.8,
        backroom = 0.6
    },
    stats = {
        weight = { min = 0.2, max = 0.4 },
        length = { min = 0.16, max = 0.32 }
    },
    config = { extra = {
        boost = 2,
        active = false
    } },
    cost = 6,
    loc_vars = function(self, info_queue, card)
        local main_end
        if card.area == G.fac_fish_area then
            main_end = {
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
        end
        return {
            --main_end = main_end,
            vars = { card.ability.extra.boost, ppu_bubbles = {card.ability.extra.active and "active" or "inactive"} },

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
            if context.fac_end_fishing and context.perfect then
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
    attributes = { "mod_chance", "passive", "fac_perfect_catch", }
}

-- Gossamer Worm
FishAndChips.Fish {
    key = "waffle_gossamer_worm",
    atlas = "waffle_fish",
    pos = { x = 7, y = 0 },
    weight = 4,
    environments = {
        aquifer = 1,
        pier = 0.4
    },
    stats = {
        weight = { min = 0.005, max = 0.01 },
        length = { min = 0.10, max = 0.40 }
    },
    pixel_size = { h = 76, w = 71 },
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    blueprint_compat = true,
    attributes = { "fac_perfect_catch", "generation", "consumable", "spectral" },
    calculate = function(self, card, context)
        if context.fac_end_fishing and context.perfect and context.treasure then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'fac_waffle_gossamer_worm'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                }
            end
        end
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_invertebrate'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
}

-- Bonus Duck
-- Notes: duck value is stored in card.ability.fac_extra as card.ability.extra is wiped when changing card enhancement
-- I don't *think* this causes any issues? fingers crossed Lmao
FishAndChips.Fish {
    key = "waffle_bonus_duck",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    environments = {
        backroom = 1,
        styx = 1,
        city_river = 0.6
    },
    stats = {
        weight = { min = 0.2, max = 0.6 },
        length = { min = 0.16, max = 0.32 }
    },
    pixel_size = { h = 88, w = 71 },
    atlas = "waffle_fish",
    pos = { x = 8, y = 0 },
    weight = 4,
    cost = 6,
    config = { extra = {
        chips = 0,
        chips_per = 4,
        duck_ratio = 0.3
    },},
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.duck_ratio * 100,
                card.ability.extra.chips_per,
                card.ability.extra.chips
            }
        }
    end,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.fac_extra and context.other_card.ability.fac_extra.fac_waffle_duck and not context.blueprint then
            --print("bonus duck")
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips",
                scalar_value = "chips_per",
                no_message = true
            })
            return {
                message = localize('k_upgrade_ex'),
                message_card = card,
                sound = "fac_waffle_duck" .. math.random(1, numDuckSounds),
                volume = 0.38
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.setting_blind then
            --waffleFunctions.addDucksToDeck(G.deck) -- Seems redundant, but needed for Finclair copies to properly add to 60% of deck
        end
    end,
    attributes = { "chips", "scaling" },
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_duck'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
}
local shuffle_ref = CardArea.shuffle
function CardArea:shuffle(_seed)
    shuffle_ref(self, _seed)

    if self == G.deck and SMODS.find_card("fish_fac_waffle_bonus_duck") then -- idr if shuffle gets called on non-deck cardareas but better safe than sorry
        waffleFunctions.addDucksToDeck(self)
    end
end

-- Duck drawstep
SMODS.DrawStep {
    key = "fac_waffle_duck_drawstep",
    order = 21,
    func = function(card, layer)
        if next(SMODS.find_card("fish_fac_waffle_bonus_duck", true)) then -- Only draw ducks if Bonus Duck is held
            if not G.fac_waffle_duck_sprite then
                G.fac_waffle_duck_sprite = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H,
                    "fac_waffle_duck",
                    { x = 0, y = 0 }
                )
            end

            if card.ability.fac_extra and type(card.ability.fac_extra) == "table" and card.ability.fac_extra.fac_waffle_duck then
                G.fac_waffle_duck_sprite.role.draw_major = card
                G.fac_waffle_duck_sprite:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.fac_waffle_duck_sprite:draw_shader('booster', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end
    end,
    conditions = { facing = 'front' }
}
-- Duck atlas
SMODS.Atlas {
    key = "waffle_duck",
    path = "doctorwaffle/duck.png",
    px = 71,
    py = 95
}

-- Onion Fish
FishAndChips.Fish {
    key = "waffle_onion_fish",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    atlas = "waffle_fish",
    pos = { x = 9, y = 0 },
    weight = 4,
    cost = 5,
    environments = {
        soup = 1,
        swamp = 1
    },
    pixel_size = { h = 77, w = 71 },
    config = { extra = {
        cards_remaining = 8
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards_remaining } }
    end,
    stats = {
        weight = { min = 0.4, max = 1.6 },
        length = { min = 0.08, max = 0.24 }
    },
    calculate = function(self, card, context)
        if context.press_play then
            local affectedCards = {}
            for _, played_card in pairs(G.hand.highlighted) do
                if card.ability.extra.cards_remaining > 0 and not SMODS.has_no_rank(played_card) then
                    affectedCards[#affectedCards + 1] = played_card

                    if not context.blueprint then
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "cards_remaining",
                            operation = function(ref_table, ref_value, initial)
                                ref_table[ref_value] = initial - 1
                            end,
                            no_message = true
                        })
                    end
                end
            end
            waffleFunctions.flipFunctionCards(affectedCards, function(modify_card)
                SMODS.modify_rank(modify_card, -1)
            end)
            delay(0.875)
            if not context.blueprint then
                if card.ability.extra.cards_remaining > 0 then
                    return {
                        message = tostring(card.ability.extra.cards_remaining)
                    }
                end
            end
        end
        if context.after and not context.blueprint and card.ability.extra.cards_remaining <= 0 then
            SMODS.destroy_cards(card, nil, nil, true)
            return {
                message = localize("k_eaten_ex")
            }
        end
    end,
    attributes = { "rank", "food", "modify_card", }
}

-- THE MAGNIFICENT FINCLAIR
FishAndChips.Fish {
    key = "waffle_finclair",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    environments = {
        styx = 0.7,
        city_river = 1
    },
    pos = { x = 0, y = 1 },
    atlas = "waffle_fish",
    blueprint_compat = false,
    cost = 10,
    weight = 1,
    stats = {
        weight = { min = 1.30, max = 4.50 },
        length = { min = 0.20, max = 0.45 }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.scale } }
    end,
    config = {
        extra = {
            scale = 2
        }
    },
    calculate = function(self, card, context)
        if context.setting_blind then
            local fishToRight = waffleFunctions.getCardToRight(card)
            if fishToRight and fishToRight.config.center.key ~= "fish_fac_waffle_finclair" then
                local boost = card.ability.extra.scale
                local cardKey = card.config.center.key
                local stats = card.ability.stats
                local edition = card.edition
                local seal = card:get_seal()
                SMODS.copy_card(fishToRight, {
                    new_card = card
                })
                card.ability.extra = card.ability.extra or {}
                for i, v in pairs(card.ability.extra) do
                    if type(v) == "number" then
                        card.ability.extra[i] = v * boost
                    end
                end
                card.ability.extra.fac_waffle_finclair = {}
                card.ability.extra.fac_waffle_finclair.key = cardKey
                card.ability.extra.fac_waffle_finclair.stats = stats
                card.ability.extra.fac_waffle_finclair.edition = edition
                card.ability.extra.fac_waffle_finclair.seal = seal
                if not G.GAME.fac_fish_expanded then
                    card.T.scale = 0.7
                end
                return {
                    message = localize('k_fac_waffle_presto_ex'),
                    colour = G.C.PURPLE
                }
            end
        end
    end,
    attributes = { "copying", "position", },
    vel_limit = 0.7,
    impulse_min = 0.42,
    impulse_max = 0.48,
    decision_max = 0.24,
    decision_min = 0.1,
}
-- Finclair shader
SMODS.Shader {
    key = "finclair",
    path = "waffle/finclair.fs"
}
-- Finclair copy shader drawstep
SMODS.DrawStep {
    key = "fac_waffle_finclair_drawstep",
    order = 21,
    func = function(card, layer)
        if card.ability.extra and type(card.ability.extra) == "table" and card.ability.extra.fac_waffle_finclair then
            card.children.center:draw_shader('fac_finclair', nil, card.ARGS.send_to_shader)
        end
    end,
    conditions = { facing = 'front' }
}

-- Worn Book
FishAndChips.Fish {
    key = "waffle_worn_book",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    atlas = "waffle_fish",
    pos = { x = 1, y = 1 },
    environments = {
        city_river = 1,
        calm_pond = 0.6,
        pier = 0.6
    },
    pixel_size = { h = 58, w = 71 },
    weight = 4,
    stats = {
        weight = { min = 0.3, max = 0.6 },
        length = { min = 0.2, max = 0.25 },
    },
    config = {
        extra = {
            cards_created = 4
        },
        immutable = {
            rank = nil -- Randomly decided when fished up
        }
    },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        local rank, key
        do
            if card.ability.immutable.rank then
                rank = card.ability.immutable.rank
            else
                rank = "Ace"
            end
            if waffleFunctions.isCardInCollection(card) then
                key = "fish_fac_waffle_worn_book_collection"
            end
        end

        return {
            key = key,
            vars = {
                card.ability.extra.cards_created,
                localize(rank, 'ranks')
            }
        }
    end,
    on_catch = function(self, card) -- Determine rank when caught
        card.ability.immutable.rank = pseudorandom_element(SMODS.Ranks, 'fac_waffle_worn_book_rank').key
    end,
    add_to_deck = function(self, card, from_debuff) -- For adding via debug or other non-caught means
        if not card.ability.immutable.rank then
            card.ability.immutable.rank = pseudorandom_element(SMODS.Ranks, 'fac_waffle_worn_book_rank').key
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,
    use = function(self, card)
        for i = 1, card.ability.extra.cards_created do
            local options = get_current_pool("Enhanced")
            for i, v in pairs(options) do
                if v == "m_stone" then
                    table.remove(options, i)
                end
            end
            local enhancement = SMODS.poll_enhancement({ guaranteed = true, options = options })
            SMODS.add_card {
                set = "Base",
                key_append = "fac_waffle_worn_book_enhancement",
                rank = card.ability.immutable.rank,
                enhancement = enhancement
            }
        end
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_maybe_fish'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
    attributes = { "generation", "usable", "enhancements", },
    impulse_max = 0.18,
    vel_limit = 0.32
}

-- Handchovies
FishAndChips.Fish {
    key = "waffle_handchovies",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    atlas = "waffle_fish",
    pos = { x = 2, y = 1 },
    cost = 5,
    environments = {
        pier = 1,
        soup = 0.8,
    },
    stats = {
        weight = { min = 0.0175, max = 0.0350 },
        length = { min = 0.35, max = 1.40 }
    },
    config = {
        extra = {
            cards = 5,
            hands = 2
        }
    },
    attributes = { "hands", },
    pixel_size = { w = 67, h = 73 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.cards,
                card.ability.extra.hands,
                math.abs(card.ability.extra.hands) ~= 1 and "s" or ""
            }
        }
    end,
    calculate = function(self, card, context)
        if context.before and #context.scoring_hand == card.ability.extra.cards then
            ease_hands_played(card.ability.extra.hands)
            local message
            if math.abs(card.ability.extra.hands) == 1 then
                message = localize('k_fac_waffle_plus_hand')
            else
                message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } }
            end
            return {
                message = message,
                colour = G.C.BLUE
            }
        end
    end
}

-- Unemployster
FishAndChips.Fish {
    key = "waffle_unemployster",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    cost = 7,
    atlas = "waffle_fish",
    pos = { x = 3, y = 1 },
    pixel_size = { h = 72, w = 71 },
    environments = {
        city_river = 1,
        pier = 1
    },
    stats = {
        weight = { min = 0.10, max = 0.20 },
        length = { min = 0.08, max = 0.12 }
    },
    config = { extra = {
        xmult = 1,
        xmult_per_sand_dollar = 0.05
    } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_per_sand_dollar, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult ~= 1 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_mollusc'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
    attributes = { "xmult", "lose_economy", "scaling", },
}
-- Unemployster hook
local ease_sand_dollars_ref = ease_sand_dollars
function ease_sand_dollars(mod, instant)
    local unemploysters = SMODS.find_card("fish_fac_waffle_unemployster")
    if mod > 0 and unemploysters[1] then
        for _, oyster in pairs(unemploysters) do
            SMODS.scale_card(oyster, {
                ref_table = oyster.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_per_sand_dollar",
                operation = function(ref_table, ref_value, initial, change)
                    ref_table[ref_value] = initial + mod * change
                end,
                message_colour = G.C.RED,
                message = localize { type = 'variable', key = 'a_xmult', vars = { oyster.ability.extra.Xmult } }
            })
        end
    else
        return ease_sand_dollars_ref(mod, instant)
    end
end

-- Scaly-Foot Snail
FishAndChips.Fish {
    key = "waffle_scaly_foot_snail",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    cost = 6,
    stats = {
        weight = { min = 0.05, max = 0.15 },
        length = { min = 0.04, max = 0.06 }
    },
    atlas = "waffle_fish",
    pos = { x = 4, y = 1 },
    pixel_size = { w = 68, h = 58 },
    environments = {
        volcano = 1
    },
    config = { extra = {
        enhancement = "m_steel"
    } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.enhancement]
    end,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.hand_drawn and context.first_hand_drawn and G.GAME.blind and G.GAME.blind.boss and not G.GAME.fac_waffle_snail_activated then
            G.GAME.fac_waffle_snail_activated = true
            G.E_MANAGER:add_event(Event {
                func = function()
                    waffleFunctions.flipFunctionCards(context.hand_drawn, function(drawn_card)
                        drawn_card:set_ability(card.ability.extra.enhancement)
                    end)
                    G.E_MANAGER:add_event(Event {
                        trigger = "after",
                        delay = 1,
                        func = function()
                            SMODS.destroy_cards(card, { pinch_anim = true })
                            SMODS.calculate_effect({ message = localize('k_fac_waffle_steel_ex'), colour = G.C.RED },
                                card)
                            return true
                        end
                    })
                    return true
                end
            })
        end
    end,
    attributes = { "boss_blind", "enhancements", },
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_gastropod'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
}

-- Pyukumuku
FishAndChips.Fish {
    key = "waffle_pyukumuku",
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    weight = 4,
    atlas = "waffle_fish",
    pos = { x = 5, y = 1 },
    stats = {
        weight = { min = 0.9, max = 1.8 },
        length = { min = 0.25, max = 0.4 }
    },
    pixel_size = { w = 67, h = 86 },
    environments = {
        pier = 1
    },
    blueprint_compat = false,
    config = {
        extra = {
            chips_stored = 0,
            chips_per = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.chips_per, card.ability.extra.chips_stored }
        }
    end,
    calculate = function(self, card, context)
        if context.before and #context.full_hand == 1 then
            context.full_hand[1].ability.perma_bonus = (context.full_hand[1].ability.perma_bonus or 0) +
                card.ability.extra.chips_stored
            card.ability.extra.chips_stored = 0
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        end
        if context.individual and context.cardarea == G.play then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips_stored",
                scalar_value = "chips_per",
                no_message = true
            })
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    return true
                end
            }))
        end
    end,
    on_catch = function(self, card)
        if SMODS.pseudorandom_probability(card, "fac_waffle_pyukumuku_shiny", 1, 4096) or (G.GAME and G.GAME.fac_waffle_forced_shiny) then
            card.children.center:set_sprite_pos({ x = 6, y = 1 })
        end
    end,
    attributes = { "chips", "perma_bonus", "modify_card", "reset", },
    set_card_type_badge = function(self, card, badges)
        badges[#badges + 1] = create_badge(localize('k_fac_waffle_pokemon'),
            G.C.SECONDARY_SET.fac_Fish, G.C.WHITE,
            1.2)
    end,
}

-- Self-Finsert
FishAndChips.Fish {
    key = "waffle_self_finsert",
    atlas = "waffle_fish",
    environments = {
        chocolate_river = 1,
        garden = 0.6
    },
    pos = {x = 7, y = 1},
    weight = 4,
    pixel_size = {h = 69, w = 67},
    ppu_coder = { "waffle" },
    ppu_artist = { "waffle" },
    attributes = { "generation", "editions" },
    stats = {
        weight = {min = 61.0, max = 68.0},
        length = {min = 1.75, max = 1.82},
    },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        return {vars = {colours = {HEX('7A2E2E')}}}
    end,
    use = function (self, card)
        local edition = SMODS.poll_edition({guaranteed = true, no_negative = true})
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function ()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                card.ability.stats = nil
                local center = G.P_CENTERS[SMODS.poll_object({type = "fac_waffle_self_finsert_spawns"})]
                center.discovered = true
                card:set_ability(center)
                card:set_edition(edition)
                G:save_progress()
                if card.area == G.fac_fish_area then save_run() end
                return true
            end
        }))
        delay(0.6)
    end,
    keep_on_use = function ()
        return true
    end,
    can_use = function (self, card)
        local caught = G.FISHING and (card.area == G.FISHING.fac_fish_reward_area or card.area == G.FISHING.fac_treasure_reward_area)
        return card.area == G.fac_fish_area or caught or #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit
    end,
    pronouns = "they_them"
}
