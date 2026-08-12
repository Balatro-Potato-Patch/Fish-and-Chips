FishAndChips.Fish {
	key = "fo_lake",
	atlas = "fo_lake",
	pos = { x = 0, y = 0 },
	weight = 1,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_alexi" },
	attributes = { "retrigger" },
	blueprint_compat = true,
	config = {
		extra = {
			retriggers = 3
		},
	},
	display_size = { w = 321 * 0.5, h = 347 * 0.5 },
    pixel_size = { w = 321, h = 347 },

	decision_min = 0.18,
	decision_max = 0.4,
	impulse_min = 0.18,
	impulse_max = 0.38,

    cost = 9,
	environments = {
		city_river = 1,
        backroom = 1,
        calm_pond = 0.01,
	},
	stats = {
		weight = {min = 500, max = 500},
		length = {min = 7.2, max = 7.2},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.retriggers } }
	end,
	calculate = function(self, card, context)
        if context.retrigger_joker_check and #G.jokers.cards == 0 and context.other_card.area == G.fac_fish_area and not context.retrigger_joker then
			return {
				repetitions = card.ability.extra.retriggers
			}
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_fo_hydra"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
}