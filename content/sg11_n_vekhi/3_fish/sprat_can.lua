SMODS.Sound({
	key = "sprat_can_opening",
	path = "sg11_n_vekhi/can_opening.ogg",
})

SMODS.Atlas({
	key = "sg11_n_vekhi_sprat_can",
	path = "sg11_n_vekhi/sprat_can.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_sprat_can",
	atlas = "fac_sg11_n_vekhi_sprat_can",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = {},
	config = {
		extra = {
			amount = 10,
		},
	},
	weight = 6,
	stats = {
		weight = { min = 1, max = 1 },
		length = { min = 1, max = 1 },
	},
	environments = {
		city_river = 3,
		pier = 1,
		calm_pond = 1,
		swamp = 1,
		soup = 2,
		chocolate_river = 2,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.fish_fac_sg11_n_vekhi_sprat
		return {
			vars = { card.ability.extra.amount },
		}
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card)
		play_sound("fac_sprat_can_opening")
		for i = 1, card.ability.extra.amount do
			SMODS.add_card({ key = "fish_fac_sg11_n_vekhi_sprat", area = G.fac_fish_area })
		end
	end,
})
