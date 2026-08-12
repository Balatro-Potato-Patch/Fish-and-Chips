SMODS.Sound {
	key = "floundery_goodbye",
	path = "CyanSoCalico/floundery_goodbye.wav"
}

--[[

SMODS.Sound {
	key = "floundery_nonono",
	path = "CyanSoCalico/floundery_nonono.wav"
}

local alert_func = alert_no_space
function alert_no_space(card, area)
	if area == G.jokers and next(SMODS.find_card("fish_fac_csc_floundery")) then
		local flounderies = {}
		for k, v in pairs(G.fac_fish_area.cards) do
			if v.config.center.key == "fish_fac_csc_floundery" and v.ability.immutable.extra_fish > 0 then
				flounderies[#flounderies+1] = v
			end 
		end
		for k, v in pairs(flounderies) do
			v:juice_up()
		end
		if next(flounderies) then
			play_sound('fac_floundery_nonono')
		end
	end
	return alert_func(card, area)
end

FishAndChips.Fish {
	key = "csc_floundery",
	atlas = "csc_fish",
	pos = { x = 7, y = 10 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "passive" },
	config = {
		immutable = {
			slots = 1,
			empty_jokers = 0,
			extra_fish = 0,
			joker_limit = 0,

		}
	},

	stats = {
		weight = {
			min = 0.5,
			max = 2.3
		},
		length = {
			min = 0.22,
			max = 0.60
		}
	},

    weight = 1,
	environments = {
		garden = 1,
		wormhole = 0.1
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.immutable.slots } }
	end,

	can_sell = function(self, card, context)
		return card.ability.immutable.extra_fish <= 1
	end,

	add_to_deck = function(self, card, from_debuff)
		if from_debuff then return nil end
		card.ability.immutable.empty_jokers = G.jokers.config.card_limit - #G.jokers.cards
		G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base + card.ability.immutable.empty_jokers
	end,
	remove_from_deck = function(self, card, from_debuff)
		if from_debuff then return nil end
		play_sound('fac_floundery_goodbye')
		G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers
	end,

	-- I'll be so fr. I dont know what to do for negatives and other modifiers that change card area limits
	-- At least this should be compatible with bucket upgrades and antimatter etc
	calculate = function(self, card, context)
		if context.card_added then
			if context.card.ability.set == "Joker" then
				card.ability.immutable.empty_jokers = card.ability.immutable.empty_jokers - 1
				G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base - 1
				card.ability.immutable.extra_fish = math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - #G.fac_fish_area.cards))
			elseif context.card.ability.set == "fac_Fish" then
				G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.immutable.extra_fish - math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - (#G.fac_fish_area.cards + 1)))
				card.ability.immutable.extra_fish = math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - (#G.fac_fish_area.cards + 1)))
			end
		end
		if context.selling_card or context.joker_type_destroyed then
			if context.card.ability.set == "Joker" then
				card.ability.immutable.empty_jokers = card.ability.immutable.empty_jokers + 1
				G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base + 1
				card.ability.immutable.extra_fish = math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - #G.fac_fish_area.cards))
			elseif context.card.ability.set == "fac_Fish" then
				G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.immutable.extra_fish - math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - (#G.fac_fish_area.cards - 1)))
				card.ability.immutable.extra_fish = math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - (#G.fac_fish_area.cards - 1)))
			end
		end
		if context.fac_use_fish and not context.kept_on_use then
			G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.immutable.extra_fish - math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - (#G.fac_fish_area.cards - 1)))
			card.ability.immutable.extra_fish = math.max(0, -((G.fac_fish_area.config.card_limits.base - card.ability.immutable.empty_jokers) - (#G.fac_fish_area.cards - 1)))
		end
	end,
}

]]

FishAndChips.Fish {
	key = "csc_floundery",
	atlas = "csc_fish",
	pos = { x = 7, y = 10 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "chips" },
	config = {
		extra = {
			chips_mod = 99,
		}
	},

	stats = {
		weight = {
			min = 0.5,
			max = 2.3
		},
		length = {
			min = 0.22,
			max = 0.60
		}
	},

    weight = 1,
	environments = {
		garden = 1,
		wormhole = 0.1
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips_mod*(math.max(0, (G.fac_fish_area and #G.fac_fish_area.cards or 0) - (G.jokers and #G.jokers.cards or 0))) } }
	end,
	
	calculate = function(self, card, context)
		if context.joker_main and #G.fac_fish_area.cards - #G.jokers.cards > 0 then
			return {
				chips = card.ability.extra.chips_mod * (#G.fac_fish_area.cards - #G.jokers.cards)
			}
		end
	end,
}