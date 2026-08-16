SMODS.Sound {
	key = "floundery_goodbye",
	path = "CyanSoCalico/floundery_goodbye.ogg"
}

SMODS.Sound {
	key = "floundery_nonono",
	path = "CyanSoCalico/floundery_nonono.ogg"
}

SMODS.Sound {
	key = "floundery_heyguys",
	path = "CyanSoCalico/floundery_heyguys.ogg"
}

SMODS.Sound {
	key = "floundery_explosion",
	path = "CyanSoCalico/floundery_explosion.ogg"
}

--[[

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
	pos = { x = 0, y = 1 },

	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "chips", "deltarune", "utdr", "joker", },
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

    weight = 5,
	environments = {
		garden = 5,
		swamp = 1,
		backroom = 0.5,
		wormhole = 0.1,
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips_mod*(math.max(0, (G.fac_fish_area and #G.fac_fish_area.cards or 0) - (G.jokers and #G.jokers.cards or 0))) } }
	end,

	add_to_deck = function(self,card, from_debuff)
		if not from_debuff then
			G.E_MANAGER:add_event(Event{
				blocking = false,
				no_delete = true,
				func = function()
					play_sound("fac_floundery_heyguys")
					return true
				end
			})
		end
	end,

	calculate = function(self, card, context)
		if context.joker_main and #G.fac_fish_area.cards - #G.jokers.cards > 0 then
			return {
				chips = card.ability.extra.chips_mod * (#G.fac_fish_area.cards - #G.jokers.cards),
				card = context.blueprint and context.blueprint_card or card
			}
		end
		if context.selling_self and not context.blueprint then
			play_sound("fac_floundery_goodbye")
		end
		if context.joker_type_destroyed and context.card == card and not context.blueprint then
			play_sound("fac_floundery_goodbye")
			play_sound("fac_floundery_explosion", nil, 0.3)
		end
	end,
}
