SMODS.Atlas {
    key = "pi_cubed_credits",
    path = 'pi_cubed/credits.png',
    px = 71,
    py = 95
}

PotatoPatchUtils.Developer {
    name = 'pi_cubed',
    colour = HEX('e14159'),
    atlas = 'fac_pi_cubed_credits',
    pos = { x = 0, y = 0 },
    loc = true
}

SMODS.Atlas({
	key = "pi_cubed_fish",
	path = "pi_cubed/fish.png",
	px = 71,
	py = 95,
})

--#region Fish

-- Smaller Wrapped Fish
-- dev note for playtesters: i think this fish can create treasure fish.
-- this is not intended behaviour and i wouldn't mind if it was no longer able to
-- i think it's fine (ghostsalt)
FishAndChips.Fish {
	key = "pi_cubed_smallerwrappedfish",
	atlas = "pi_cubed_fish",
	pos = { x = 0, y = 2 },
    pixel_size = { w = 54, h = 61 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
    blueprint_compat = false,
    eternal_compat = false,
	weight = 10,
    environments = {
		wormhole = 4,
		calm_pond = 3,
        backroom = 1,
	},
    impulse_min = 0.05,
    impulse_max = 0.1,
    decision_min = 0.05,
    decision_max = 0.1,
    vel_limit = 0.2,
    stats = {
		weight = {min = 0.5, max = 10},
		length = {min = 0.05, max = 0.3}
	},
    attributes = { "rank", "two", "generation", "usable" },
	config = {
		extra = {
			req_cards = 8, count_cards = 8, amt_create = 3, card_art = nil
		}
	},
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.req_cards, card.ability.extra.count_cards, card.ability.extra.amt_create } }
    end,
    set_ability = function(self, card, inital, delay_sprites)
        if (card.config.center.discovered or card.bypass_discovery_center) then
            if not card.ability.extra.card_art then
                card.ability.extra.card_art = math.random(0,3)
            end
            card.children.center:set_sprite_pos({x = card.ability.extra.card_art, y = 2})
        end
    end,
    calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 and not context.blueprint then
            if card.ability.extra.count_cards > 1 then
                card.ability.extra.count_cards = card.ability.extra.count_cards - 1
                return {
                    message = tostring(card.ability.extra.count_cards),
                    message_card = card
                }
            elseif card.ability.extra.count_cards <= 1 then
                card.ability.extra.count_cards = 0
                return {
                    message = localize('k_active_ex'),
                    colour = G.C.GREEN,
                    message_card = card
                }
            end
        end
	end,
    can_use = function(self, card)
        return (card.ability.extra.count_cards <= 0) and G.fac_fish_area:has_space(0)
    end,
    use = function(self, card, area, copier)
        for i = 1, math.min(card.ability.extra.amt_create, G.fac_fish_area.config.card_limit - #G.fac_fish_area.cards + 1) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.fac_fish_area:has_space(0) then
                        play_sound('timpani')
                        local new_fish = SMODS.add_card({ set = 'fac_Fish', key_append = "smaller_wrapped_present" })
                        new_fish.ability.stats = {}
                        new_fish.ability.stats.l_prop = 0
                        new_fish.ability.stats.w_prop = 0
                        new_fish.ability.stats.length = G.P_CENTERS[new_fish.config.center_key].stats.length.min
                        new_fish.ability.stats.weight = G.P_CENTERS[new_fish.config.center_key].stats.weight.min
                        -- forcing stats on a fish doesn't seem to scale the sprite, so...
                        new_fish.T.h = new_fish.T.h * 0.7
                        new_fish.T.w = new_fish.T.w * 0.7
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,
}

-- Salmonid
FishAndChips.Fish {
	key = "pi_cubed_salmonid",
	atlas = "pi_cubed_fish",
	pos = { x = 1, y = 0 },
    pixel_size = { w = 68, h = 72 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
	weight = 10,
    environments = {
		pier = 4,
        volcano = 2,
        city_river = 1,
	},
    impulse_min = 0.25,
    impulse_max = 0.3,
    decision_min = 0.5,
    decision_max = 0.55,
    vel_limit = 0.3,
    stats = {
		weight = {min = 30, max = 70},
		length = {min = 0.3, max = 0.7}
	},
    attributes = { 'enhancements', 'modify_card' }, -- previously had "mult" and "chips" (mf)
    config = {
		extra = {
			min_cards = 5,
		}
	},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_mult
        info_queue[#info_queue+1] = G.P_CENTERS.m_bonus
        return { vars = { card.ability.extra.min_cards } }
	end,
    calculate = function(self, card, context)
        if context.before and #context.scoring_hand >= card.ability.extra.min_cards then
            local triggered_enhancement = nil
            local unenhanced_list = {}
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].config.center.key == 'c_base'
                and not context.scoring_hand[i].getting_enhanced then
                    unenhanced_list[#unenhanced_list+1] = context.scoring_hand[i]
                end
            end
            if #unenhanced_list >= 1 then
                triggered_enhancement = pseudorandom_element({'m_mult', 'm_bonus'}, 'salmonid')
                local random_card = pseudorandom_element(unenhanced_list, 'salmonid2')
                random_card.getting_enhanced = true
                random_card:set_ability(triggered_enhancement, nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        random_card:juice_up()
                        random_card.getting_enhanced = nil
                        return true
                    end
                }))
            end
            if triggered_enhancement == 'm_mult' then
                return {
                    message = localize('k_fac_pi_cubed_mult'),
                    colour = G.C.MULT,
                    message_card = card
                }
            elseif triggered_enhancement == 'm_bonus' then
                return {
                    message = localize('k_fac_pi_cubed_bonus'),
                    colour = G.C.CHIPS,
                    message_card = card
                }
            end
        end
    end
}

-- Squid?
FishAndChips.Fish {
	key = "pi_cubed_squid",
	atlas = "pi_cubed_fish",
	pos = { x = 2, y = 0 },
    pixel_size = { w = 53, h = 92 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
    blueprint_compat = false,
    eternal_compat = false,
	weight = 10,
    environments = {
		city_river = 4,
        aquifer = 2,
	},
    impulse_min = 0.12,
    impulse_max = 0.3,
    decision_min = 0.85,
    decision_max = 1,
    vel_limit = 0.52,
    stats = {
		weight = {min = 25, max = 60},
		length = {min = 0.5, max = 1.5}
	},
    attributes = { "modify_card", "suit", "usable" },
    requires_hand = true,
	config = {
		extra = {
			num_cards = 6,
		}
	},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        local suit = (G.GAME.current_round.fac_pi_cubed_squid_card or {}).suit or 'Spades'
        return { vars = { card.ability.extra.num_cards, localize(suit, 'suits_plural'), colours = { G.C.SUITS[suit] } } }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        G.hand:unhighlight_all()
        local saved_highlight = G.hand.config.highlighted_limit
        G.hand.config.highlighted_limit = card.ability.extra.num_cards
        local selected_cards = {}
        for i = 1, card.ability.extra.num_cards do
            local candidate_cards = {}
            local percent = 1 + (i - 1) * 0.05
            for k,v in ipairs(G.hand.cards) do
                if not v.squid_highlighted then
                    candidate_cards[#candidate_cards+1] = v
                end
            end
            if #candidate_cards >= 1 then
                local selected_card = pseudorandom_element(candidate_cards, 'squid')
                selected_card.squid_highlighted = true
                selected_cards[selected_card] = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand:add_to_highlighted(selected_card, true)
                        selected_card.squid_highlighted = nil
                        play_sound('card1', percent)
                        return true
                    end
                }))
                delay(0.1)
            end
        end
        delay(0.2)
        for i = 1, #G.hand.cards do
            if selected_cards[G.hand.cards[i]] then
                local percent = 1.15 - (i - 0.999) / (card.ability.extra.num_cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound('card1', percent)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
        end
        delay(0.2)
        for i = 1, #G.hand.cards do
            if selected_cards[G.hand.cards[i]] then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        SMODS.change_base(G.hand.cards[i], G.GAME.current_round.fac_pi_cubed_squid_card.suit)
                        return true
                    end
                }))
            end
        end
        for i = 1, #G.hand.cards do
            if selected_cards[G.hand.cards[i]] then
                local percent = 0.85 + (i - 0.999) / (card.ability.extra.num_cards - 0.998) * 0.3
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.15,
                    func = function()
                        G.hand.cards[i]:flip()
                        play_sound('tarot2', percent, 0.6)
                        G.hand.cards[i]:juice_up(0.3, 0.3)
                        return true
                    end
                }))
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                G.hand.config.highlighted_limit = saved_highlight
                return true
            end
        }))

        delay(0.5)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
}

local function reset_squid()
    G.GAME.current_round.fac_pi_cubed_squid_card = G.GAME.current_round.fac_pi_cubed_squid_card or { suit = 'Spades' }
    local squid_suits = {}
    for _, suit_key in ipairs({ 'Spades', 'Hearts', 'Clubs', 'Diamonds' }) do
        if suit_key ~= G.GAME.current_round.fac_pi_cubed_squid_card.suit then squid_suits[#squid_suits + 1] = suit_key end
    end
    local squid_card = pseudorandom_element(squid_suits, 'squid' .. G.GAME.round_resets.ante)
    G.GAME.current_round.fac_pi_cubed_squid_card.suit = squid_card
end

local reset_game_globals_ref = SMODS.current_mod.reset_game_globals
function SMODS.current_mod.reset_game_globals(run_start)
    reset_game_globals_ref(run_start)
    reset_squid()
end

-- Spiked Fish
FishAndChips.Fish {
	key = "pi_cubed_spikedfish",
	atlas = "pi_cubed_fish",
	pos = { x = 3, y = 0 },
    pixel_size = { w = 69, h = 72 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
    perishable_compat = false,
	weight = 10,
    environments = {
		styx = 4,
        wormhole = 2,
	},
    impulse_min = 0.05,
    impulse_max = 0.5,
    decision_min = 0.24,
    decision_max = 0.55,
    vel_limit = 0.5,
    stats = {
		weight = {min = 5, max = 200},
		length = {min = 0.1, max = 2}
	},
    attributes = { "x_mult", "scaling", "reset" },
	config = {
		extra = {
			xmult_mod = 0.2, xmult = 1
		}
	},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
		if context.fac_end_fishing and context.treasure and not context.blueprint then
            return {
                card = card,
                func = function()
                    SMODS.scale_card(card, {
                        ref_table = card.ability.extra,
                        ref_value = "xmult",
                        scalar_value = "xmult_mod",
                        scaling_message = {
                            message = localize('k_upgrade_ex'),
                        }
                    })
                end
            }
        end
        if context.fac_end_fishing and context.missed_treasure and not context.blueprint and card.ability.extra.xmult ~= 1 then
            local reset_xmult = -card.ability.extra.xmult + 1
			return {
				card = card,
				func = function()
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "xmult",
						scalar_table = { reset_xmult },
						scalar_value = 1,
						scaling_message = {
							message = localize('k_reset'),
							colour = G.C.RED
						}
					})
				end
			}
        end
        if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}

-- Mysterious Canfish
FishAndChips.Fish {
	key = "pi_cubed_mysteriouscanfish",
	atlas = "pi_cubed_fish",
	pos = { x = 0, y = 1 },
    pixel_size = { w = 56, h = 94 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
    blueprint_compat = false,
    eternal_compat = false,
	weight = 10,
    environments = {
		pier = 4,
		soup = 3,
	},
    impulse_min = 0.12,
    impulse_max = 0.3,
    decision_min = 0.01,
    decision_max = 0.01,
    vel_limit = 0.42,
    stats = {
		weight = {min = 0.6, max = 15},
		length = {min = 0.1, max = 2}
	},
    attributes = { "economy", "usable", "chance", "lose_economy", }, -- TODO: is an empty can a Food card?
	config = {
		extra = {
			odds = 10, eor_sand = 20, use_sand = 10, use_dollars = 20
		}
	},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'mysteriouscanfish')
        return { vars = { numerator, denominator, card.ability.extra.eor_sand, card.ability.extra.use_sand, card.ability.extra.use_dollars } }
    end,
    calc_sand_dollar_bonus = function(self, card)
        if SMODS.pseudorandom_probability(card, 'mysteriouscanfish', 1, card.ability.extra.odds) then
            return card.ability.extra.eor_sand
        end
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(-card.ability.extra.use_dollars, true)
                return true
            end
        }))
        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.5,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_sand_dollars(card.ability.extra.use_sand, true)
                return true
            end
        }))
        delay(0.5)
    end,
}

-- Intergalactic Drunkfish
FishAndChips.Fish {
	key = "pi_cubed_intergalacticdrunkfish",
	atlas = "pi_cubed_fish",
	pos = { x = 2, y = 1 },
    pixel_size = { w = 71, h = 95 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
	weight = 10,
    environments = {
		wormhole = 4,
		chocolate_river = 2,
	},
    impulse_min = 0.5,
    impulse_max = 0.5,
    decision_min = 1.5,
    decision_max = 3,
    vel_limit = 1,
    stats = {
		weight = {min = 5, max = 100},
		length = {min = 0.5, max = 5}
	},
    attributes = { "economy", "discard", "hand_type" },
	config = {
		extra = {
			dollars = 2, discard_mod = 1, poker_hand = 'High Card'
		}
	},
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.discard_mod, card.ability.extra.dollars, localize(card.ability.extra.poker_hand or 'High Card', 'poker_hands') } }
    end,
    calculate = function(self, card, context)
		if context.before and next(context.poker_hands[card.ability.extra.poker_hand]) then
            ease_discard(card.ability.extra.discard_mod)
            SMODS.calculate_effect({ message = localize { type = 'variable', key = 'a_discards', vars = { card.ability.extra.discard_mod } }, colour = G.C.RED, }, context.blueprint_card or card)
        end
        if context.individual and context.cardarea == G.play and
        next(context.poker_hands[card.ability.extra.poker_hand]) then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
            return {
                dollars = card.ability.extra.dollars,
            }
        end
        if context.after and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pi_cubed_intergalacticdrunkfish')
            SMODS.calculate_effect({ message = localize(card.ability.extra.poker_hand, 'poker_hands')}, card)
        end
	end,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pi_cubed_intergalacticdrunkfish')
    end
}

-- Yellow Tang (with a hat)
FishAndChips.Fish {
	key = "pi_cubed_yellowtangwithahat",
	atlas = "pi_cubed_fish",
	pos = { x = 1, y = 1 },
    pixel_size = { w = 69, h = 94 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
	weight = 10,
    environments = {
		wormhole = 4,
		garden = 2,
	},
    impulse_min = 0.2,
    impulse_max = 0.5,
    decision_min = 0.01,
    decision_max = 0.1,
    vel_limit = 0.5,
    stats = {
		weight = {min = 0.1, max = 0.2},
		length = {min = 0.15, max = 0.25}
	},
    attributes = { "suit", "diamonds", "retrigger", "seals" },
	config = {
		extra = {
			req_cards = 3, repetitions = 1,
		}
	},
    cost = 6,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.req_cards, card.ability.extra.retriggers } }
    end,
    calculate = function(self, card, context)
		if context.before then
            local diamond_count = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit('Diamonds') then
                    diamond_count = diamond_count + 1
                end
            end
            if diamond_count >= card.ability.extra.req_cards then
                local valid_list = {}
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_suit('Diamonds')
                    and not context.scoring_hand[i].seal
                    and not context.scoring_hand[i].yellowtanged then
                        valid_list[#valid_list+1] = context.scoring_hand[i]
                    end
                end
                if #valid_list >= 1 then
                    local random_card = pseudorandom_element(valid_list, 'yellowtang')
                    random_card.yellowtanged = true
                    random_card:set_seal(SMODS.poll_seal({type_key = 'yellowtang', guaranteed = true}), nil, false)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            random_card:juice_up()
                            random_card.yellowtanged = nil
                            return true
                        end
                    }))
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.SUITS["Diamonds"],
                        message_card = card,
                    }
                end
            end
        end

        if context.repetition and context.other_card:is_suit('Diamonds')
        and (context.other_card.seal or context.other_card.yellowtanged) then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
	end,
}

-- Golden Egg
FishAndChips.Fish {
	key = "pi_cubed_goldenegg",
	atlas = "pi_cubed_fish",
	pos = { x = 0, y = 0 },
    pixel_size = { w = 65, h = 65 },
	ppu_coder = { "pi_cubed" },
	ppu_artist = { "pi_cubed" },
    blueprint_compat = false,
    eternal_compat = false,
	weight = 5,
    environments = {
		pier = 4,
		city_river = 2,
	},
    treausre = true,
    impulse_min = 0.5,
    impulse_max = 0.8,
    decision_min = 0.05,
    decision_max = 0.4,
    vel_limit = 0.8,
    stats = {
		weight = {min = 10, max = 50},
		length = {min = 0.5, max = 0.8}
	},
    attributes = { "economy", "modify_card", "enhancements", "usable" },
    requires_hand = true,
	config = {
		extra = {
			dollars = 5,
            bonus_value = 5,
		}
	},
    cost = 20,
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
        return { vars = { card.ability.extra.dollars } }
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('card1', percent)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    _card:set_ability('m_gold', nil, false)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
}
