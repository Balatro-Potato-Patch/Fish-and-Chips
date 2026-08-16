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
	card.ability.extra.attributes = {}
	card.ability.extra.attributes[1] = pseudorandom_element(card.ability.immutable.valid_attributes, 'fac_shadowfish')
	repeat
		card.ability.extra.attributes[2] = pseudorandom_element(card.ability.immutable.valid_attributes, 'fac_shadowfish')
	until card.ability.extra.attributes[2].key ~= card.ability.extra.attributes[1].key
	repeat
		card.ability.extra.attributes[3] = pseudorandom_element(card.ability.immutable.valid_attributes, 'fac_shadowfish')
	until card.ability.extra.attributes[3].key ~= card.ability.extra.attributes[1].key
		and card.ability.extra.attributes[3].key ~= card.ability.extra.attributes[2].key

	local _poker_hands = {}
	for handname, _ in pairs(G.GAME.hands) do
		if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
			_poker_hands[#_poker_hands + 1] = handname
		end
	end
	local hand
	for i = 1, #card.ability.extra.attributes do
		if card.ability.extra.attributes[i].key == "retrigger" then
			card.ability.extra.attributes[i].ix = i
		end

		if card.ability.extra.attributes[i].key == "hand_level" then
			hand = hand or pseudorandom_element(_poker_hands, 'fac_shadowfish_hand')
			card.ability.extra.attributes[i].hand = hand
		end
	end
	card.attributes = { card.ability.extra.attributes[1].key, card.ability.extra.attributes[2].key, card.ability.extra.attributes[3].key }
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
		immutable = {
			valid_attributes = {
				{ key = "mult",       main_val = 4 },
				{ key = "chips",      main_val = 30 },
				{ key = "economy",    economy = 1 },
				{ key = "xmult",      main_val = 1.5 },
				{ key = "retrigger",  repetitions = 1 },
				{ key = "hand_level", hand = "High Card" },
				{ key = "usable" },
				{ key = "generation" }
			}
		},
		extra = {}
	},
	-- TODO: Someone else please actually give this attributes (mf)
	-- I think that's been done? I don't know (ghostsalt)
	loc_vars = function(self, info_queue, card)
		if card.ability.extra.attributes then
			for _, v in ipairs(card.ability.extra.attributes) do
				info_queue[#info_queue + 1] = {
					set = 'Other',
					key = "fac_blanthos_shadowfish_" .. v.key,
					vars = {
						v.main_val or v.economy or v.repetitions
						or (v.hand and localize(v.hand, 'poker_hands')),
						v.ix
					}
				}
			end
		end
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
		return card.ability.extra.attributes[1].key == "usable" or card.ability.extra.attributes[2].key == "usable" or
			card.ability.extra.attributes[3].key == "usable"
	end,

	use = function(self, card)
		if card.ability.extra.attributes[1].key == "usable" then
			play_sound("fac_sax1")
		elseif card.ability.extra.attributes[2].key == "usable" then
			play_sound("fac_sax2")
		elseif card.ability.extra.attributes[3].key == "usable" then
			play_sound("fac_sax3")
		end

		card:juice_up(0.3, 0.5)
		reroll_shadowfish_attributes(card)
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			local ret = {}
			for _, v in ipairs(card.ability.extra.attributes) do
				if v.main_val then
					ret[v.key] = (ret[v.key] or 0) + v.main_val
				end
			end
			return ret
		end

		if context.selling_card and context.card ~= card then -- my blueprint shenanigans aren't working (ghostsalt)
			local ret = {}
			for _, v in ipairs(card.ability.extra.attributes) do
				if v.economy then
					ret.dollars = (ret.dollars or 0) + v.economy
				end
			end
			return ret
		end

		if context.repetition and context.cardarea == G.play then
			local ret = {}
			for _, v in ipairs(card.ability.extra.attributes) do
				if v.repetitions and context.scoring_hand[v.ix] == context.other_card then
					ret.repetitions = (ret.repetitions or 0) + v.repetitions
				end
			end
			if next(ret) then return ret end
		end


		if context.end_of_round and context.main_eval then
			local ret = {}
			for _, v in ipairs(card.ability.extra.attributes) do
				if v.hand then
					ret.level_up = (ret.level_up or 0) + 1
					ret.hand = v.hand
				end
			end
			if next(ret) then
				SMODS.upgrade_poker_hands { hands = ret.hand, level_up = ret.level_up, from = context.blueprint_card or card }
				return nil, true
			end
		end

		if context.skip_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			local consumables = 0
			for _, v in ipairs(card.ability.extra.attributes) do
				if v.key == "generation" then
					consumables = consumables + 1
				end
			end
			if consumables > 0 then
				consumables = math.min(consumables, G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer))
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + consumables
				for i = 1, consumables do
					G.E_MANAGER:add_event(Event({
						trigger = "before",
						delay = 0.4,
						func = function()
							SMODS.add_card {
								set = 'Consumeables',
								key_append = 'fac_shadowfish_consumable'
							}
							G.GAME.consumeable_buffer = 0
							return true
						end
					}))
				end
				return nil, true
			end
		end
	end,


	set_ability = function(self, card, initial, delay_sprites)
		reroll_shadowfish_attributes(card)
	end

}
--#endregion
