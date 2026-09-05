local lake_scale = FishAndChips.mod.config.shrink_sprites and 0.3 or 0.5
local function do_you_have_jokers()
	local areas = SMODS.get_card_areas("jokers")
	-- TARGET: add other areas jokers can be in (for jokers like false vacuum decay from entropy)

	for _, area in ipairs(areas) do
		for _, card in ipairs(area.cards) do
			if
				card
				and card:is(Card)
				and card.config.center.set == "Joker"
			then return true end
		end
	end
end

FishAndChips.Fish {
	key = "fo_lake",
	atlas = "fo_lake",
	pos = { x = 0, y = 0 },
	weight = 1,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_alexi" },
	attributes = { "retrigger", "joker", },
	blueprint_compat = true,
	config = {
		extra = {
			retriggers = 3
		},
	},
	display_size = { w = 321 * lake_scale, h = 347 * lake_scale },
    pixel_size = { w = 321, h = 347 },

	decision_min = 0.18,
	decision_max = 0.4,
	impulse_min = 0.18,
	impulse_max = 0.38,
	colour = HEX("1fffbb"),

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
        if
			context.retrigger_joker_check
			and not context.retrigger_joker
			and not do_you_have_jokers()
			and context.other_card
			and context.other_card:is(Card)
			and context.other_card.config.center.set == "fac_Fish"
		then
			return {
				repetitions = card.ability.extra.retriggers
			}
		end
	end,
	badge_key = 'k_fac_fo_hydra'
}
