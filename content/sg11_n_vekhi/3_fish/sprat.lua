SMODS.Atlas({
	key = "sg11_n_vekhi_sprat",
	path = "sg11_n_vekhi/sprat.png",
	px = 36,
	py = 48,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_sprat",
	atlas = "fac_sg11_n_vekhi_sprat",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = { "chips", "economy" },
	config = {
		extra = {
			chips = 10,
			dollars = 1,
		},
	},
	weight = 4,
	stats = {
		weight = { min = 0.003, max = 0.012 },
		length = { min = 0.06, max = 0.14 },
	},
	display_size = { w = 36, h = 48 },
	environments = {
		calm_pond = 1,
		pier = 1,
		garden = 1,
		swamp = 1,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { SMODS.signed(card.ability.extra.chips), card.ability.extra.dollars },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.dollars
	end,
})
