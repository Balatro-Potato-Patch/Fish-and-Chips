PotatoPatchUtils.Developer({
	name = 'Carrier4133 (MP)',
	atlas = 'MP/fac_MPcards.png', --reused from Wormhole because I'm tired (credit art by SarcPot)
	pos = { x = 0, y = 0 }
	colour = G.C.BLACK,
	ignore_limits = false, -- USING THIS VALUE WILL RESULT IN YOUR SUBMISSION BEING REJECTED
})

local function fac_count_rank(scoring_hand, rank)
	local count = 0
	if not scoring_hand then return count end
	for _, scored_card in ipairs(scoring_hand) do
		if scored_card and scored_card.get_id and scored_card:get_id() == rank then
			count = count + 1
		end
	end
	return count
end

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

local function fac_count_unique_fish()
	local profile = G.PROFILES[G.SETTINGS.profile]
	local fish_data = profile and profile.fac_fishing and profile.fac_fishing.fish_data
	if not fish_data then return 0 end
	local unique = 0
	for _, data in pairs(fish_data) do
		if data and data.times_caught and data.times_caught > 0 then
			unique = unique + 1
		end
	end
	return unique
end

FishAndChips.Fish {
	key = 'letter_fish',
	atlas = 'fac_placeholders',
	pos = { x = 0, y = 0 },
	weight = 22,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'economy' },
	environments = {
		pier = 10,
		city_river = 4,
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
			local aces = fac_count_rank(context.scoring_hand, 14)
			if aces > 0 then
				return { sand_dollars = aces * card.ability.extra.sand_dollars }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'luck_statue',
	atlas = 'fac_placeholders',
	pos = { x = 1, y = 0 },
	weight = 7,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'probability' },
	environments = {
		calm_pond = 6,
		pier = 3,
	},
	config = {
		extra = {
			mult = 4,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local lucky_cards = fac_count_rank(context.scoring_hand, 3) + fac_count_rank(context.scoring_hand, 7)
			if lucky_cards > 0 then
				local function mark_lucky()
					for _, scored_card in ipairs(context.scoring_hand) do
						if scored_card and scored_card.get_id then
							local id = scored_card:get_id()
							if id == 3 or id == 7 then
								scored_card.lucky_trigger = true
								scored_card.lucky = true
								scored_card.ability = scored_card.ability or {}
								scored_card.ability.lucky = true
								scored_card._fac_temporary_lucky = true
							end
						end
					end
				end
				local function clear_lucky()
					for _, scored_card in ipairs(context.scoring_hand) do
						if scored_card and scored_card._fac_temporary_lucky then
							scored_card.lucky_trigger = nil
							scored_card.lucky = nil
							if scored_card.ability and scored_card.ability.lucky then
								scored_card.ability.lucky = nil
							end
							scored_card._fac_temporary_lucky = nil
						end
					end
				end
				return {
					func = mark_lucky,
					post = { source = card, func = clear_lucky }
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'toxikarp',
	atlas = 'fac_placeholders',
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chips' },
	environments = {
		styx = 5,
		volcano = 3,
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
				if scored_card and scored_card.get_id and scored_card:get_id() >= 11 and scored_card:get_id() <= 13 then
					face_cards = face_cards + 1
				end
			end
			if face_cards > 0 then
				return { xblind_size = 1 - card.ability.extra.blinds * 0.01 * face_cards }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'size_2',
	atlas = 'fac_placeholders',
	pos = { x = 4, y = 0 },
	weight = 2,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'mult' },
	environments = {
		calm_pond = 3,
		pier = 1,
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
			local twos = fac_count_rank(context.scoring_hand, 2)
			if twos > 0 then
				return { x_mult = card.ability.extra.x_mult }
			end
		end
	end,
}





FishAndChips.Fish {
	key = 'gezora',
	atlas = 'fac_placeholders',
	pos = { x = 6, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chance' },
	environments = {
		pier = 4,
		city_river = 2,
	},
	config = {
		extra = {
			chance = 3,
			chips = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chance, card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.repetition and not context.mod_probability and not context.fix_probability then
			if SMODS.pseudorandom_probability(card, 'fac_gezora', 1, card.ability.extra.chance) then
				return { chips = card.ability.extra.chips }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'crystal_serpent',
	atlas = 'fac_placeholders',
	pos = { x = 7, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'blind' },
	environments = {
		volcano = 2,
		styx = 1,
	},
	config = {
		extra = {
			blinds = 3,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blinds } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand then
			local unique_suits = {}
			for _, scored_card in ipairs(context.scoring_hand) do
				if scored_card then
					local suit = scored_card.base and scored_card.base.suit
					if suit then
						unique_suits[suit] = true
					end
				end
			end
			local suit_count = 0
			for _ in pairs(unique_suits) do suit_count = suit_count + 1 end
			if suit_count >= 2 then
				return { xblind_size = 1 - card.ability.extra.blinds * 0.01 }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'reaver_fish',
	atlas = 'fac_placeholders',
	pos = { x = 9, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chips' },
	environments = {
		pier = 3,
		swamp = 2,
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
	atlas = 'fac_placeholders',
	pos = { x = 5, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chance', 'retrigger' },
	environments = {
		pier = 4,
		city_river = 2,
	},
	config = {
		extra = {
			numerator = 1,
			denominator = 25,
			retriggers = 10,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.numerator, card.ability.extra.denominator, card.ability.extra.retriggers } }
	end,
	calculate = function(self, card, context)
		local unique_fish = fac_count_unique_fish()
		if context.mod_probability or context.fix_probability then
			return {
				numerator = card.ability.extra.numerator + unique_fish,
				denominator = card.ability.extra.denominator,
			}
		end
		if context.individual and context.cardarea == G.hand and not context.repetition and not context.mod_probability and not context.fix_probability then
			local numerator = card.ability.extra.numerator + unique_fish
			if SMODS.pseudorandom_probability(card, 'fac_halibut_cannon', numerator, card.ability.extra.denominator) then
				return {
					repetitions = card.ability.extra.retriggers + unique_fish,
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'trash_crab',
	atlas = 'fac_placeholders',
	pos = { x = 2, y = 0 },
	weight = 1,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chips', 'suits' },
	environments = {
		pier = 4,
		swamp = 2,
	},
	config = {
		extra = {
			chips = 1,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and context.other_card and context.other_card:is_suit('Spades') then
			local next_bonus = (card._trash_crab_spade_bonus or 0) + 1
			return {
				pre_func = function()
					card._trash_crab_spade_bonus = next_bonus
				end,
				chips = next_bonus * card.ability.extra.chips,
			}
		end
	end,
}

FishAndChips.Fish {
	key = 'primordial_wyrm',
	atlas = 'fac_placeholders',
	pos = { x = 8, y = 0 },
	weight = 0.5,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'boss_blind' },
	environments = {
		volcano = 3,
		styx = 2,
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
			local multiplier = 1 - card.ability.extra.blinds * 0.01 * math.min(ante, 10)
			if multiplier < 0.5 then multiplier = 0.5 end
			return { xblind_size = multiplier }
		end
	end,
}

-- FishAndChips.Fish {
	key = 'dreadnautilus',
	atlas = 'fac_placeholders',
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
-- }


