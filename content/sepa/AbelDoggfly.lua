PotatoPatchUtils.Developer({
	name = 'AbelSketch',
	atlas = 'fac_sepa_devs',
	pos = {x = 1, y = 0},
	soul_pos = {x = 1, y = 1}, 
	colour = G.C.GRAY,
	fac_partner = 'DoggFly',
	loc = true,
})

PotatoPatchUtils.Developer({
	name = 'DoggFly',
	atlas = 'fac_sepa_devs',
	pos = {x = 0, y = 0},
	soul_pos = {x = 0, y = 1}, 
	colour = G.C.RED,-- Te recomendaria que lo cambies asi a un color de preferencia, agarre rojo nomas por que si
	fac_partner = 'AbelSketch',
	loc = true
})

SMODS.Atlas({
	key = "sepa_fish",
	path = "sepa/pezcaos.png",
	px = 71,
	py = 95,
})

local pez = 'sepa_fish'

FishAndChips.Fish {
	key = "clownfish",
	atlas = pez,
	pos = { x = 0, y = 0 },
	weight = 10, --testestest
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "DoggFly" },
	attributes = { "mult", "hands" },
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

-- Im gonna be honest, half of this wouldnt have been possible without Vanilla remade
FishAndChips.Fish {
	key = "bombfish",
	atlas = pez,
	pos = { x = 3, y = 0 },
	weight = 5, --testestest
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "AbelSketch" },
	attributes = { "hands", "economy", "generation" },
	config = {
		extra = {
			poker_hand = 'High Card',
			defuse = 0,
			goal = 3,
			attempts = 4,
			minplayed = false
		}
	},
	environments = {
		city_river = 1,
		styx = 0.5,
		chocolate_river = 0.1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.defuse, card.ability.extra.goal, card.ability.extra.attempts, card.ability.extra.poker_hand} }
	end,

    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand then
			card.ability.extra.defuse = card.ability.extra.defuse + 1
			card.ability.extra.minplayed = true

			if card.ability.extra.defuse == card.ability.extra.goal then
				for i = 1, math.min(2, G.consumeables.config.card_limit - #G.consumeables.cards) do
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
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
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


			local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
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
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'pezbombastico')
    end
}