PotatoPatchUtils.Developer({
	name = 'AbelSketch',
	atlas = 'fac_sepa_devs',
	pos = {x = 0, y = 0},
	colour = G.C.BLACK,
	fac_partner = 'fac_DoggFly',
	joint_credits = 2,
	loc = true,

  click = function(self)
	local voice_sound = math.random(1, 15)
	local audio = math.random(1, 20)
	local voice = math.random(1, 7)

	if voice_sound >= 12 then
		self:juice_up(0.1 , 0.1)
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
	weight = 10, --testestest
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
		pier = 1
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
	weight = 9,
	ppu_coder = { "DoggFly" },
	ppu_artist = { "DoggFly" },
	attributes = { "retrigger", "destroy_card" },
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
		wormhole = 3,
		city_river = 1
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
	weight = 6,
	ppu_coder = { "DoggFly" },
	ppu_artist = { "DoggFly" },
	attributes = { "hands", "destruction" },
	config = {
		extra = {}
	},
	stats = {
		weight = {min = 0.1, max = 0.1},
		length = {min = 0.20 , max = 0.20}
	},
	environments = {
		city_river = 1
	},
	loc_vars = function(self, info_queue, card)
		return {}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if G.hand and G.hand.cards and #G.hand.cards > 0 then
				local rightmost = G.hand.cards[#G.hand.cards]
				if rightmost then
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound('tarot1')
							rightmost:juice_up(0.8, 0.8)
							SMODS.destroy_cards(rightmost)
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



-- Im gonna be honest, half of this wouldnt have been possible without Vanilla remade 
FishAndChips.Fish {
	key = "bombfish",
	atlas = pez,
	pos = { x = 0, y = 1 },
	weight = 4,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "hands", "economy", "generation" },
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
		city_river = 1,
		styx = 0.5,
		chocolate_river = 0.1
	},
	loc_vars = function(self, info_queue, card)
	        info_queue[#info_queue+1] = {key = "fac_sepa_Tarot_infovar", set = "Other"}
		return { vars = { card.ability.extra.defuse, card.ability.extra.goal, card.ability.extra.attempts, card.ability.extra.poker_hand, card.ability.extra.tarot_amount} }
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
					message = "-1 Attempt",
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
	attributes = { "hands", "economy", "generation" },
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
		city_river = 1,
		styx = 0.5,
		chocolate_river = 0.1
	},
	treasure = true,
	loc_vars = function(self, info_queue, card)
	        info_queue[#info_queue+1] = {key = "fac_sepa_Spectral_infovar", set = "Other"}
		return { vars = { card.ability.extra.defuse, card.ability.extra.goal, card.ability.extra.attempts, card.ability.extra.poker_hand, card.ability.extra.tarot_amount} } 
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
					message = "-1 Attempt",
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
	attributes = { "economy", "hands", "destroy_card" },
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
		pier = 1,
		styx = 0.5,
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
                        card.ability.extra.dollars = card.ability.extra.dollars + sliced_card.sell_cost
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
 
 	set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge("Halucination...?", G.C.RED, G.C.WHITE, 1 )
 	end,

}

FishAndChips.Fish {
	key = "devicehands",
	atlas = 'fac_sepa_darkner',
	pos = { x = 0, y = 0 },
	weight = 6,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "hands" },
	config = {
		extra = {
			
		}
	},
	stats = {
		weight = {min = 0.50, max = 0.65},
		length = {min = 0.10 , max = 0.20}
	},
	environments = {
		styx = 1,
		wormhole = 0.5,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
	end,
 
 	set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge("Darkner", G.C.BLACK, G.C.WHITE, 1 )
 	end,

}

FishAndChips.Fish {
	key = "catfish",
	atlas = 'fac_sepa_bagremove',
	pos = { x = 0, y = 0 },
	weight = 6,
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "hands" },
	config = {
		extra = {
			
		}
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0.12 , max = 0.22}
	},
	environments = {
		styx = 1,
		wormhole = 0.5,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
	end,
 
 	set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge("Smoke", G.C.BLACK, G.C.WHITE, 1 )
 	end,

}