PotatoPatchUtils.Developer({
	name = 'AbelSketch',
	atlas = 'fac_sepa_devs',
	pos = {x = 0, y = 0},
	colour = G.C.BLACK,
	fac_partner = 'fac_DoggFly',
	joint_credits = 2,
	loc = true,

  click = function(self)
	local voice_sound = pseudorandom('bwa', 1, 20)
	local audio = pseudorandom('bwa',1, 20)
	local voice = pseudorandom('bwa',1, 7)

	if voice_sound >= 17 then
		self:juice_up()
		play_sound('fac_credits_voices_' .. voice)
	else
		self:juice_up(0.1 , 0.1)
		play_sound('fac_credits_audio_' .. audio)
	end
  end

})

PotatoPatchUtils.Developer({
	name = 'DoggFly',
	atlas = 'fac_sepa_devs',
	pos = {x = 0, y = 0},
	colour = G.C.PURPLE,
	fac_partner = 'fac_AbelSketch',
	joint_credits = 2,
	loc = true
})

local pez = 'sepa_fish'

SMODS.Atlas({
	key = "sepa_fish",
	path = "sepa/pezcaos.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "clownfish",
	atlas = pez,
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "DoggFly" },
	attributes = { "mult", "hands" },
	stats = {
		weight = {min = 0.20, max = 0.32},
		length = {min = 0.10 , max = 0.20}
	},
	config = {
		extra = {
			mult = 10
		}
	},
	environments = {
		pier = 10
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.hands_played == 0 then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
}

FishAndChips.Fish {
	key = "blinky",
	atlas = pez,
	pos = { x = 1, y = 0 },
	weight = 10,
	ppu_coder = { "DoggFly" },
	ppu_artist = { "DoggFly" },
	attributes = { "retrigger", "destroy_card", "chance", "hands", },
	config = {
		extra = {
			odds = 3
		}
	},
		stats = {
		weight = {min = 0.20, max = 0.32},
		length = {min = 0.10 , max = 0.20}
	},

	environments = {
		wormhole = 10,
		city_river = 0.1
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_blinky_shatter")
		return { vars = { num, dem } }
	end,
	calculate = function(self, card, context)

		if context.repetition and context.cardarea == G.play
			and G.GAME.current_round.hands_played == 0 then
			return { repetitions = 1 }
		end
		if context.individual and context.cardarea == G.play
			and G.GAME.current_round.hands_played == 0 then
			if SMODS.pseudorandom_probability(
				card, "fac_blinky_shatter_" .. tostring(context.other_card),
				1, card.ability.extra.odds
			) then
				context.other_card.fac_blinky_doomed = true
			end
		end
		if context.after and not context.blueprint then
			local doomed = {}
			for _, c in ipairs(G.play.cards) do
				if c.fac_blinky_doomed then
					doomed[#doomed + 1] = c
				end
			end
			if #doomed > 0 then
				for _, c in ipairs(doomed) do
					c:juice_up(0.8, 0.8)
					SMODS.destroy_cards(c)
				end
				return {
					message = "Splash!",
					colour = G.C.BLUE
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = "freds_leg",
	atlas = pez,
	pos = { x = 2, y = 0 },
	weight = 8,
	ppu_coder = { "DoggFly" },
	ppu_artist = { "DoggFly" },
	attributes = { "hands", "destroy_card", "position", },
	config = {
		extra = {}
	},
	stats = {
		weight = {min = 0.1, max = 0.1},
		length = {min = 0.20 , max = 0.20}
	},
	environments = {
		city_river = 8,
		pier = 4
	},
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if G.hand and G.hand.cards and #G.hand.cards > 0 then
				local rightmost = G.hand.cards[#G.hand.cards]
				if rightmost then
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound('tarot1')
							rightmost:juice_up(0.8, 0.8)
							SMODS.destroy_cards(rightmost, {immediate = true})
							return true
						end
					}))
					return {
						message = "MY LEG!",
						colour = G.C.RED
					}
				end
			end
		end
	end,
}

FishAndChips.Fish {
	key = "friendfish",
	atlas = pez,
	pos = { x = 3, y = 0 },
	weight = 8,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "DoggFly" },
	attributes = { 'economy', "fac_fish_slot", "deltarune", "utdr", },
	stats = {
		weight = {min = 10, max = 12},
		length = {min = 1.2 , max = 1.4}
	},
	config = {
        extra = {
            mula = 0
        }
	},
	environments = {
		wormhole = 8
	},

    loc_vars = function(self, info_queue, card)
        return {vars = {(((G.fac_fish_area and G.fac_fish_area.config.card_limit or 0) - #(G.fac_fish_area and (G.fac_fish_area and G.fac_fish_area.cards or {}) or {}))) * 2}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
            card.ability.extra.mula = (((G.fac_fish_area.config.card_limit) - #(G.fac_fish_area.cards))) * 2
            return true
        end
    end,
    calc_dollar_bonus = function(self, card)
        return card.ability.extra.mula
    end,

 	set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('k_fac_sepa_darkner'), G.C.BLACK, G.C.WHITE, 1 )
 	end,
}

FishAndChips.Fish {
	key = "bunnyslug",
	atlas = pez,
	pos = { x = 4, y = 0 },
	weight = 8,
	ppu_coder = { "DoggFly" },
	ppu_artist = { "DoggFly" },
	attributes = { "mult" },
	config = {
		extra = {
			mult = 4
		}
	},
    stats = {
        weight = {min = 0.001, max = 0.005},
        length = {min = 0.007, max = 0.025}
	},
	environments = {
		calm_pond = 10,
		pier = 5,
		wormhole = 0.1
	},
	loc_vars = function(self, info_queue, card)
		local bucket_fish_count = 0
		if G.fac_fish_area and G.fac_fish_area.cards then
			for _, c in ipairs(G.fac_fish_area.cards) do
				if c ~= card then
					bucket_fish_count = bucket_fish_count + 1
				end
			end
		end
		return { vars = { card.ability.extra.mult, card.ability.extra.mult * bucket_fish_count } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local bucket_fish_count = 0
			if G.fac_fish_area and G.fac_fish_area.cards then
				for _, c in ipairs(G.fac_fish_area.cards) do
					if c ~= card then
						bucket_fish_count = bucket_fish_count + 1
					end
				end
			end
			if bucket_fish_count > 0 then
				return {
					mult = card.ability.extra.mult * bucket_fish_count
				}
			end
		end
	end,
}


-- Im gonna be honest, half of this wouldnt have been possible without Vanilla remade
FishAndChips.Fish {
	key = "bombfish",
	atlas = pez,
	pos = { x = 0, y = 1 },
	weight = 4,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "lose_economy", "generation", "tarot", "hand_type", "hands", "reset" },
	config = {
		extra = {
			poker_hand = 'High Card',
			tarot_amount = 2,
			defuse = 0,
			goal = 3,
			attempts = 5,
			minplayed = false
		}
	},
	stats = {
		weight = {min = 10, max = 12},
		length = {min = 0.25 , max = 0.25}
	},
	environments = {
		city_river = 4,
		styx = 2,
		chocolate_river = 0.4
	},
	loc_vars = function(self, info_queue, card)
	        info_queue[#info_queue+1] = {key = "fac_sepa_Tarot_infovar", set = "Other"}
		return { vars = { card.ability.extra.defuse, card.ability.extra.goal, card.ability.extra.attempts, localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.tarot_amount} }
	end,

    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand then
			card.ability.extra.defuse = card.ability.extra.defuse + 1
			card.ability.extra.minplayed = true

			if card.ability.extra.defuse == card.ability.extra.goal then

				for i = 1, math.min(card.ability.extra.tarot_amount, G.consumeables.config.card_limit - #G.consumeables.cards) do
            		G.E_MANAGER:add_event(Event({
                		trigger = 'after',
                		delay = 0.4,
                		func = function()
                    		if G.consumeables.config.card_limit > #G.consumeables.cards then
                        		play_sound('timpani')
                        		SMODS.add_card({set = 'fac_sepa_goodtarots'})
                        		card:juice_up()
                    		end
                    	return true
                	end
            		}))
        		end

				SMODS.destroy_cards(card)
			end

			local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand or  'Straight Flush' then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')

            return {
                message = (card.ability.extra.defuse.. "/" ..card.ability.extra.goal),
				colour = G.C.RED
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then

			if card.ability.extra.minplayed == false then
				card.ability.extra.attempts = card.ability.extra.attempts - 1

					if card.ability.extra.attempts <= 0 then
    			        SMODS.destroy_cards(card)
 						G.E_MANAGER:add_event(Event({
            			trigger = 'after',
 			           	delay = 0.4,
      			      	func = function()
 			               	play_sound('fac_ultrakill-explosion')
  			              	if G.GAME.dollars ~= 0 then
		                    	ease_dollars(-G.GAME.dollars, true)
		                	end
                		return true
            			end
        				}))
					end

				local _poker_hands = {}
            	for handname, _ in pairs(G.GAME.hands) do
                	if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand or  'Straight Flush' then
                    	_poker_hands[#_poker_hands + 1] = handname
                	end
            	end
            	card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')

				return {
					message = localize('k_fac_sepa_minus_attempt'),
					colour = G.C.RED
				}
			end


			local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand or  'Straight Flush' then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')

			card.ability.extra.minplayed = false

            return {
				message = localize('k_reset')
            }
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand or  'Straight Flush' then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')
    end
}

FishAndChips.Fish {
	key = "icbf",
	atlas = pez,
	pos = { x = 1, y = 1 },
	weight = 2,
	impulse_min = 0.5,
	impulse_max = 1,
	vel_limit = 1.5,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "lose_economy", "generation", "spectral", "hand_type", "hands", "reset" },
	config = {
		extra = {
			poker_hand = 'Pair',
			tarot_amount = 2,
			defuse = 0,
			goal = 6,
			attempts = 10,
		}
	},
	stats = {
		weight = {min = 15, max = 20},
		length = {min = 0.45 , max = 0.45}
	},
	environments = {
		city_river = 2,
		styx = 1,
		chocolate_river = 0.2
	},
	treasure = true,
	loc_vars = function(self, info_queue, card)
	        info_queue[#info_queue+1] = {key = "fac_sepa_Spectral_infovar", set = "Other"}
		return { vars = { card.ability.extra.defuse, card.ability.extra.goal, card.ability.extra.attempts, localize(card.ability.extra.poker_hand, 'poker_hands'), card.ability.extra.tarot_amount} }
	end,

    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand then
			card.ability.extra.defuse = card.ability.extra.defuse + 1

			if card.ability.extra.defuse == card.ability.extra.goal then
				for i = 1, math.min(card.ability.extra.tarot_amount, G.consumeables.config.card_limit - #G.consumeables.cards) do
            		G.E_MANAGER:add_event(Event({
                		trigger = 'after',
                		delay = 0.4,
                		func = function()
                    		if G.consumeables.config.card_limit > #G.consumeables.cards then
                        		play_sound('timpani')
                        		SMODS.add_card({set = 'fac_sepa_goodspec'})
                        		card:juice_up()
                    		end
                    	return true
                	end
            		}))
        		end

				SMODS.destroy_cards(card)
			end

			local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')

            return {
                message = (card.ability.extra.defuse.. "/" ..card.ability.extra.goal),
				colour = G.C.GOLD
            }
        end

        if context.before and context.scoring_name ~= card.ability.extra.poker_hand then
				card.ability.extra.attempts = card.ability.extra.attempts - 1

					if card.ability.extra.attempts <= 0 then
    			        SMODS.destroy_cards(card)
 						G.E_MANAGER:add_event(Event({
            			trigger = 'after',
 			           	delay = 0.4,
      			      	func = function()
 			               	play_sound('fac_ultrakill-explosion')
  			              	if G.GAME.dollars ~= 0 then
		                    	ease_dollars(-15, true)
		                	end
                		return true
            			end
        				}))
					end

				local _poker_hands = {}
            	for handname, _ in pairs(G.GAME.hands) do
                	if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    	_poker_hands[#_poker_hands + 1] = handname
                	end
            	end
            	card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')

				return {
					message = localize('k_fac_sepa_minus_attempt'),
					colour = G.C.RED
				}
			end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand or  'High Card' then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')
    end
}


FishAndChips.Fish {
	key = "lies",
	atlas = pez,
	pos = { x = 2, y = 1 },
	weight = 8,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "economy", "destroy_card", "position", "sell_value", "scaling", },
	config = {
		extra = {
			dollars = 0
		}
	},
	stats = {
		weight = {min = 0.20, max = 0.32},
		length = {min = 0.10 , max = 0.20}
	},
	environments = {
		pier = 8,
		styx = 4,
		city_river = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars } }
	end,

	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] == card then
                    my_pos = i
                    break
                end
            end
            if my_pos and G.fac_fish_area.cards[my_pos - 1] and not SMODS.is_eternal(G.fac_fish_area.cards[my_pos - 1], card) and not G.fac_fish_area.cards[my_pos - 1].getting_sliced then
                local sliced_card = G.fac_fish_area.cards[my_pos - 1]
                sliced_card.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.scale_card (card, {
							ref_table = card.ability.extra,
                            ref_value = "dollars",
                            scalar_table = sliced_card,
                            scalar_value = "sell_cost",
                            no_message = true
                        })
                        card:juice_up(0.3, 0.3)
                        sliced_card:start_dissolve({ HEX("57ecab") }, nil, 2)
                        play_sound('slice1')
                        return true
                    end
                }))
                return {
                    message = "...",
                    colour = G.C.RED,
                    no_juice = true,
                }
            end
        end
	end,

    calc_dollar_bonus = function(self, card)
        return card.ability.extra.dollars
    end,

	badge_key = 'k_fac_sepa_hallucination'

}

FishAndChips.Fish {
	key = "devicehands",
	atlas = 'fac_sepa_darkner',
	pos = { x = 0, y = 0 },
	weight = 6,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "xmult", "scaling", "hands", "deltarune", "utdr", },
	config = {
		extra = {
        	xmult = 1,
        	gain = 0.05,
			h_plays = -1
		}
	},
	stats = {
		weight = {min = 10, max = 12},
		length = {min = 1.2 , max = 1.4}
	},
	environments = {
		styx = 6,
		wormhole = 3,
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.gain, -card.ability.extra.h_plays  } }
	end,

	calculate = function(self, card, context)
		if context.before then
            SMODS.scale_card(card, {
    		    ref_table = card.ability.extra,
    		    ref_value = "xmult",
    		    scalar_value = "gain",
		    })
		end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
	end,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.h_plays
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.h_plays
    end,

 	set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('k_fac_sepa_darkner'), G.C.BLACK, G.C.WHITE, 1 )
 	end,

}

FishAndChips.Fish {
	key = "bagrehumo",
	atlas = 'fac_sepa_bagremove',
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "hands", "chance", "hand_level", "hand_type", },
	config = {
		extra = {
            odds = 2,
		}
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0.12 , max = 0.22}
	},
	environments = {
		styx = 6,
		wormhole = 3,
	},

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'fish_fac_bagrehumo')
        return {vars = {new_numerator, new_denominator}}
    end,

	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval then
            if true then
                if SMODS.pseudorandom_probability(card, 'randoseed', 1, card.ability.extra.odds, 'fish_fac_bagrehumo') then
                    local hand, tally = nil, 0
                        for _, handname in ipairs(G.handlist) do
                            if SMODS.is_poker_hand_visible(handname) and G.GAME.hands[handname].played > tally then
                                hand = handname
                                tally = G.GAME.hands[handname].played
                        end
                    end
                    return {
                        level_up_hand(card, hand, false, 1),
                    }
                end
            end
        end
	end,

 	set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge(localize('k_fac_sepa_smoke'), G.C.BLACK, G.C.WHITE, 1 )
 	end,

}
