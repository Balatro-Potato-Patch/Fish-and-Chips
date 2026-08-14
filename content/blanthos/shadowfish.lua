SMODS.Sound {
	key = "sax1",
	path = 'blanthos/snd_shadowman_sax_1.wav',
	volume = 0.8
}


SMODS.Sound {
	key = "sax2",
	path = 'blanthos/snd_shadowman_sax_2.wav',
	volume = 0.8
}


SMODS.Sound {
	key = "sax3",
	path = 'blanthos/snd_shadowman_sax_3.wav',
	volume = 0.8
}


SMODS.Sound {
	key = "sax4",
	path = 'blanthos/snd_shadowman_sax_long.wav',
	volume = 0.8
}

local function reroll_shadowfish_attributes(card)
	local attributes = {}
		for aterboot, _ in pairs(card.ability.valid_attributes) do
			attributes[#attributes + 1] = aterboot
		end
		card.ability.attributes.attrone = pseudorandom_element(attributes, 'fac_shadowfish')
		card.ability.attributes.attrtwo = pseudorandom_element(attributes, 'fac_shadowfish')
		card.ability.attributes.attrthree = pseudorandom_element(attributes, 'fac_shadowfish')

		local _poker_hands = {}
		for handname, _ in pairs(G.GAME.hands) do
			if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
				_poker_hands[#_poker_hands + 1] = handname
			end
		end
		card.ability.extra.hand_level_one = pseudorandom_element(_poker_hands, 'fac_shadowfish')
		card.ability.extra.hand_level_two = pseudorandom_element(_poker_hands, 'fac_shadowfish')
		card.ability.extra.hand_level_three = pseudorandom_element(_poker_hands, 'fac_shadowfish')
		card.attributes = { card.ability.attributes.attrone, card.ability.attributes.attrtwo, card.ability.attributes.attrthree }
end


--#region Fish


FishAndChips.Fish {
	key = "shadowfish",
	atlas = "blanthos_hunter_fish",
	pos = { x = 2, y = 0 },
	weight = 15,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "Hunter" },
	config = {
		extra = {
			mult = 4,
			chips = 30,
			xmult = 1.5,
			economy = 1,
			retrigger = 1,
			hand_level_one = "HighCard",
			hand_level_two = "HighCard",
			hand_level_three = "HighCard"
		},
		valid_attributes = {
			mult = "mult",
			chips = "chips",
			economy = "economy",
			xmult = "xmult",
			retrigger = "retrigger",
			hand_level = "hand_level",
			usable = "usable",
			generation = "generation"
		},
		attributes = {
			attrone = "mult",
			attrtwo = "chips",
			attrthree = "economy"
		}
	},
	loc_vars = function(self, info_queue, center)
		info_queue[#info_queue + 1] = { set = 'fac_Fish', key = center.ability.attributes.attrone, vars = { "First", center.ability.extra.hand_level_one } }
		info_queue[#info_queue + 1] = { set = 'fac_Fish', key = center.ability.attributes.attrtwo, vars = { "Second", center.ability.extra.hand_level_two } }
		info_queue[#info_queue + 1] = { set = 'fac_Fish', key = center.ability.attributes.attrthree, vars = { "Third", center.ability.extra.hand_level_three } }
	end,
	environments = {
		city_river = 1,
		garden = 0.1
	},
	stats = {
		weight = { min = 0.5, max = 0.5 },
		length = { min = 0.62, max = 0.62 }
	},

	keep_on_use = function() return true end,

	can_use = function(self, card)
		return card.ability.attributes.attrone == "usable" or card.ability.attributes.attrtwo == "usable" or
		card.ability.attributes.attrthree == "usable"
	end,

	use = function(self, card)
		if card.ability.attributes.attrone == "usable" then
			play_sound("fac_sax1")
		end
		if card.ability.attributes.attrtwo == "usable" then
			play_sound("fac_sax2")
		end
		if card.ability.attributes.attrthree == "usable" then
			play_sound("fac_sax3")
		end

		card:juice_up(0.3, 0.5)
		reroll_shadowfish_attributes(card)
	end,


	calculate = function(self, card, context)
		if context.joker_main then
			if card.ability.attributes.attrone == "mult" then
				SMODS.calculate_effect({ mult = card.ability.extra.mult }, card)
			end
			if card.ability.attributes.attrone == "chips" then
				SMODS.calculate_effect({ chips = card.ability.extra.chips }, card)
			end
			if card.ability.attributes.attrone == "xmult" then
				SMODS.calculate_effect({ xmult = card.ability.extra.xmult }, card)
			end

			if card.ability.attributes.attrtwo == "mult" then
				SMODS.calculate_effect({ mult = card.ability.extra.mult }, card)
			end
			if card.ability.attributes.attrtwo == "chips" then
				SMODS.calculate_effect({ chips = card.ability.extra.chips }, card)
			end
			if card.ability.attributes.attrtwo == "xmult" then
				SMODS.calculate_effect({ xmult = card.ability.extra.xmult }, card)
			end

			if card.ability.attributes.attrthree == "mult" then
				SMODS.calculate_effect({ mult = card.ability.extra.mult }, card)
			end
			if card.ability.attributes.attrthree == "chips" then
				SMODS.calculate_effect({ chips = card.ability.extra.chips }, card)
			end
			if card.ability.attributes.attrthree == "xmult" then
				SMODS.calculate_effect({ xmult = card.ability.extra.xmult }, card)
			end
		end

		if context.selling_card then
			if card.ability.attributes.attrone == "economy" then
				SMODS.calculate_effect({ dollars = card.ability.extra.economy }, card)
			end
			if card.ability.attributes.attrtwo == "economy" then
				SMODS.calculate_effect({ dollars = card.ability.extra.economy }, card)
			end
			if card.ability.attributes.attrthree == "economy" then
				SMODS.calculate_effect({ dollars = card.ability.extra.economy }, card)
			end
		end

		if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
			if card.ability.attributes.attrone == "retrigger" then
				return {
					repetitions = card.ability.extra.retrigger }
			end
		end
		if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[2] then
			if card.ability.attributes.attrtwo == "retrigger" then
				return {
					repetitions = card.ability.extra.retrigger }
			end
		end
		if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[3] then
			if card.ability.attributes.attrthree == "retrigger" then
				return {
					repetitions = card.ability.extra.retrigger }
			end
		end


		if context.end_of_round and context.main_eval then
			if card.ability.attributes.attrone == "hand_level" then
				SMODS.calculate_effect({ level_up = true, level_up_hand = card.ability.extra.hand_level_one }, card)
			end
			if card.ability.attributes.attrtwo == "hand_level" then
				SMODS.calculate_effect({ level_up = true, level_up_hand = card.ability.extra.hand_level_two }, card)
			end
			if card.ability.attributes.attrthree == "hand_level" then
				SMODS.calculate_effect({ level_up = true, level_up_hand = card.ability.extra.hand_level_three }, card)
			end
		end


		if context.skip_blind then
			if card.ability.attributes.attrone == "generation" then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Consumeables',
							key_append = 'fac_shadowfish'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
			end
			if card.ability.attributes.attrtwo == "generation" then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Consumeables',
							key_append = 'fac_shadowfish'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
			end
			if card.ability.attributes.attrthree == "generation" then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				G.E_MANAGER:add_event(Event({
					func = (function()
						SMODS.add_card {
							set = 'Consumeables',
							key_append = 'fac_shadowfish'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end)
				}))
			end
		end
	end,


	set_ability = function(self, card, initial, delay_sprites)
		reroll_shadowfish_attributes(card)
	end

}
--#endregion
