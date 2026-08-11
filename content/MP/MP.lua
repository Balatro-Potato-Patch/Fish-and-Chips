PotatoPatchUtils.Developer({
	name = 'Carrier4133 (MP)',
	atlas = 'fac_MPcards',
	colour = G.C.YELLOW,
	ignore_limits = false, -- USING THIS VALUE WILL RESULT IN YOUR SUBMISSION BEING REJECTED
	fac_partner = 'Snapper' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
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

FishAndChips.Fish {
	key = 'letter_fish',
	atlas = 'fac_placeholders',
	weight = 26,
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
	key = 'school_of_shiners',
	atlas = 'fac_placeholders',
	weight = 8,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chips', 'passive' },
	environments = {
		calm_pond = 8,
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
			local low_count = fac_count_low(context.scoring_hand)
			if low_count > 0 then
				return { chips = low_count * card.ability.extra.chips }
			end
		end
	end,
}

FishAndChips.Fish {
	key = 'mirrorcarp',
	atlas = 'fac_placeholders',
	weight = 10,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'copying', 'mult' },
	environments = {
		pier = 5,
		city_river = 3,
	},
	config = {
		extra = {
			mult = 2,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and fac_has_rank_pair(context.scoring_hand) then
			return { mult = card.ability.extra.mult }
		end
	end,
}

FishAndChips.Fish {
	key = 'stingray',
	atlas = 'fac_placeholders',
	weight = 10,
	ppu_coder = { 'MP' },
	ppu_artist = { 'MP' },
	attributes = { 'chance', 'defense' },
	environments = {
		pier = 4,
		swamp = 2,
		volcano = 1,
	},
	config = {
		extra = {
			x_chips = 1.1,
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_hand and not context.end_of_round then
			if fac_count_low(context.scoring_hand) >= 2 then
				return { x_chips = card.ability.extra.x_chips }
			end
		end
	end,
}
