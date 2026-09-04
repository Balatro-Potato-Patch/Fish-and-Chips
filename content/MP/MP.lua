SMODS.Atlas({
	key = "fac_MPcards",
	path = "MP/MP.png",
	px = 71,
	py = 95,
})

PotatoPatchUtils.Developer({
	name = 'MP',
	atlas = 'fac_MPcards',
	colour = G.C.YELLOW,
	ignore_limits = false, -- USING THIS VALUE WILL RESULT IN YOUR SUBMISSION BEING REJECTED
})

local function fac_has_rank_pair(scoring_hand)
	if not scoring_hand then return false end
	local seen = {}
	for _, scored_card in ipairs(scoring_hand) do
		if scored_card and scored_card.get_id then
			local id = scored_card:get_id()
			seen[id] = (seen[id] or 0) + 1
			if seen[id] >= 2 then
				return true
			end
		end
	end
	return false
end

local function fac_count_low(scoring_hand)
	local count = 0
	if not scoring_hand then return count end
	for _, scored_card in ipairs(scoring_hand) do
		if scored_card and scored_card.get_id then
			local id = scored_card:get_id()
			if id >= 2 and id <= 5 then
				count = count + 1
			end
		end
	end
	return count
end

local function fac_count_suit(scoring_hand, suit)
	local count = 0
	if not scoring_hand then return count end
	for _, scored_card in ipairs(scoring_hand) do
		if scored_card then
			if scored_card.is_suit and scored_card:is_suit(suit) then
				count = count + 1
			elseif scored_card.base and scored_card.base.suit == suit then
				count = count + 1
			end
		end
	end
	return count
end

FishAndChips.Fish {
	key = 'letter_fish',
	atlas = 'fac_MPcards',
	pos = { x = 0, y = 0 },
	weight = 22,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'economy', "rank", "ace", },
	environments = {
		pier = 10,
		city_river = 4,
	},
	stats = {
		weight = {min = 0.05, max = 0.15},
		length = {min = 0.10, max = 0.20}
	},
	config = {
		extra = {
			sand_dollars = 1,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.sand_dollars } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local aces = 0
			for _, scored_card in ipairs(context.scoring_hand) do
				if scored_card and scored_card:get_id() == 14 then
					aces = aces + 1
				end
			end
			if aces > 0 then
				return { sand_dollars = aces * card.ability.extra.sand_dollars }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'luck_statue',
	atlas = 'fac_MPcards',
	pos = { x = 1, y = 0 },
	weight = 7,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { "chance", 'mult', "economy", "rank", "three", "seven", }, -- This is notably *not* quantum enhancements :pray: (mf)
	environments = {
		calm_pond = 6,
		pier = 3,
	},
	stats = {
		weight = {min = 2.0, max = 5.0},
		length = {min = 0.30, max = 0.50}
	},
	config = {
		extra = {
			mult = 4,
		}
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end

		if context.individual and context.cardarea == G.play then
			local id = context.other_card:get_id()
			if id == 3 or id == 7 then
				local effects = {}
				-- Mult chance
				if SMODS.pseudorandom_probability(context.other_card, "lucky_mult", 1, 5, "lucky_mult") then
					effects["mult"] = 20
					context.other_card.lucky_trigger = true
				end
				-- Money chance
				if SMODS.pseudorandom_probability(context.other_card, "lucky_money", 1, 15, "lucky_money") then
					effects["dollars"] = 20
					context.other_card.lucky_trigger = true
				end
				if context.other_card.lucky_trigger then
					return effects
				end
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'toxikarp',
	atlas = 'fac_MPcards',
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'xblindsize', "face", },
	environments = {
		styx = 5,
		volcano = 3,
	},
	stats = {
		weight = {min = 1.5, max = 3.5},
		length = {min = 0.40, max = 0.70}
	},
	config = {
		extra = {
			blinds = 1,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blinds } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local face_cards = 0
			for _, scored_card in ipairs(context.scoring_hand) do
				if scored_card and scored_card:is_face() then
					face_cards = face_cards + 1
				end
			end
			if face_cards > 0 then
				return { xblind_size = 1 - (card.ability.extra.blinds * 0.01 * face_cards) }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'size_2',
	atlas = 'fac_MPcards',
	pos = { x = 4, y = 0 },
	weight = 2,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'xmult', "rank", "two", },
	environments = {
		calm_pond = 3,
		pier = 1,
	},
	stats = {
		weight = {min = 0.2, max = 2},
		length = {min = 0.2, max = 2}
	},
	config = {
		extra = {
			x_mult = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			for _, scored_card in ipairs(context.scoring_hand) do
				if scored_card and scored_card:get_id() == 2 then
					return { x_mult = card.ability.extra.x_mult }
				end
			end
		end
	end,
}





FishAndChips.Fish {
	key = 'gezora',
	atlas = 'fac_MPcards',
	pos = { x = 6, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chance', "chips", },
	environments = {
		pier = 4,
		city_river = 2,
	},
	stats = {
		weight = {min = 30, max = 40},
		length = {min = 25000000, max = 30000000}
	},
	config = {
		extra = {
			num = 1,
			denom = 3,
			xchips = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
      	local num, denom = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, "fac_gezora")
		return { vars = { num, denom, card.ability.extra.xchips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			if SMODS.pseudorandom_probability(card, 'fac_gezora', card.ability.extra.num, card.ability.extra.denom) then
				return { xchips = card.ability.extra.xchips }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'crystal_serpent',
	atlas = 'fac_MPcards',
	pos = { x = 7, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'xblindsize', "suit", },
	environments = {
		volcano = 2,
		styx = 1,
	},
	stats = {
		weight = {min = 1.2, max = 2.5},
		length = {min = 0.60, max = 1.20}
	},
	config = {
		extra = {
			blinds = 3,
			requirement = 2
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blinds, card.ability.extra.requirement } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local best = 0
			local function search(card_index, used_suits, chosen_cards)
				if best >= card.ability.extra.requirement then return end
				if card_index > #context.scoring_hand then
					local count = 0
					for _ in pairs(used_suits) do
						count = count + 1
					end
					if count > best then
						best = count
					end
					return
				end

				local had_suit = false
				for k, v in pairs(SMODS.Suits) do
					if context.scoring_hand[card_index]:is_suit(k) then
						had_suit = true
						local suit_used = not not used_suits[k]
						used_suits[k] = true

						if not suit_used then
							chosen_cards[#chosen_cards + 1] = card_index
						end

						search(card_index + 1, used_suits, chosen_cards)

						if not suit_used then
							chosen_cards[#chosen_cards] = nil
							used_suits[k] = nil
						end
					end
				end
				if not had_suit then
					search(card_index + 1, used_suits, chosen_cards)
				end
			end
			search(1, {}, {})
			
			if best >= card.ability.extra.requirement then
				return { xblind_size = 1 - (card.ability.extra.blinds * 0.01) }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'reaver_fish',
	atlas = 'fac_MPcards',
	pos = { x = 9, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chips', "face", },
	environments = {
		pier = 3,
		swamp = 2,
	},
	stats = {
		weight = {min = 3.0, max = 8.0},
		length = {min = 0.50, max = 1.00}
	},
	config = {
		extra = {
			chips = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local face_count = 0
			for _, scored_card in ipairs(context.scoring_hand) do
				if scored_card and scored_card.get_id then
					local id = scored_card:get_id()
					if id >= 11 and id <= 13 then
						face_count = face_count + 1
					end
				end
			end
			if face_count > 0 then
				return { chips = face_count * card.ability.extra.chips }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'halibut_cannon',
	atlas = 'fac_MPcards',
	pos = { x = 5, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chance', 'retrigger' },
	environments = {
		pier = 4,
		city_river = 2,
	},
	stats = {
		weight = {min = 2.5, max = 6.0},
		length = {min = 0.45, max = 0.85}
	},
	config = {
		extra = {
			numerator = 1,
			numerator_increase = 1,
			denominator = 25,
			repetitions = 3,
			unique_fish = {}, -- Map of fish keys
		}
	},
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		local unique_fish = table_length(card.ability.extra.unique_fish)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator + (unique_fish * card.ability.extra.numerator_increase), card.ability.extra.denominator, "fac_MP_halibut")
		return { vars = { numerator, denominator, card.ability.extra.repetitions, card.ability.extra.numerator_increase } }
	end,
	calculate = function(self, card, context)
		if context.fac_fish_caught and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.unique_fish[context.fish] = true
		elseif context.repetition and context.cardarea == G.hand then
			local unique_fish = table_length(card.ability.extra.unique_fish)
			if SMODS.pseudorandom_probability(card, 'fac_halibut_cannon', card.ability.extra.numerator + (unique_fish * card.ability.extra.numerator_increase), card.ability.extra.denominator) then
				return {
					repetitions = card.ability.extra.repetitions,
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'trash_crab',
	atlas = 'fac_MPcards',
	pos = { x = 2, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chips', 'suit', "spades", "scaling", },
	environments = {
		pier = 4,
		swamp = 2,
	},
	stats = {
		weight = {min = 5, max = 10},
		length = {min = 100, max = 500}
	},
	config = {
		extra = {
			chips = 1,
			chips_mod = 1,
		}
	},
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chips_mod } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card and context.other_card:is_suit('Spades') and not context.end_of_round then
			local chip_cache = card.ability.extra.chips
			if not context.blueprint then
				SMODS.scale_card(card, {
					ref_value = "chips",
					scalar_value = "chips_mod",
				})
			end
			return {
				chips = chip_cache,
			}
		end
	end,
}

FishAndChips.Fish {
	key = 'primordial_wyrm',
	atlas = 'fac_MPcards',
	pos = { x = 8, y = 0 },
	weight = 0.5,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'xblindsize', "ante", },
	environments = {
		volcano = 3,
		styx = 2,
	},
	stats = {
		weight = {min = 50.0, max = 150.0},
		length = {min = 50000000, max = 100000000}
	},
	config = {
		extra = {
			blinds = 5,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blinds } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local ante = (G.GAME and G.GAME.round_resets and G.GAME.round_resets.ante) or 1
			local multiplier = 1 - (card.ability.extra.blinds * 0.01 * ante)
			if multiplier < 0.5 then multiplier = 0.5 end
			return { xblind_size = multiplier }
		end
	end,
}

--[[
FishAndChips.Fish {
	key = 'dreadnautilus',
	atlas = 'fac_MPcards',
	weight = 0.5,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'suits', 'mult' },
	environments = {
		city_river = 3,
		swamp = 2,
	},
	config = {
		extra = {
			x_mult = 1.5,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local clubs = fac_count_suit(context.scoring_hand, 'Clubs')
			if clubs > 0 then
				return { x_mult = card.ability.extra.x_mult }
			end
		end
	end,
}
]]
