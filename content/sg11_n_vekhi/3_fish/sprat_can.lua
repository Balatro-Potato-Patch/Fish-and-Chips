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

SMODS.Atlas({
	key = "sg11_n_vekhi_sprat_can_lore",
	path = "sg11_n_vekhi/sprats_unite.png",
	px = 316,
	py = 353,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_sprat_can",
	atlas = "fac_sg11_n_vekhi_sprat_can",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = { "usable" },
	config = {
		extra = {
			amount = 6,
		},
	},
	weight = 6,
	stats = {
		weight = { min = 0.2, max = 0.3 },
		length = { min = 0.09, max = 0.11 },
	},
	environments = {
		city_river = 3,
		pier = 1,
		calm_pond = 1,
		swamp = 1,
		soup = 2,
		chocolate_river = 2,
	},
	flavour_vars = function(self, info_queue, card)
		return {
			vars = {
				elements = { SMODS.create_sprite(0, 0, 2, 2 / 316 * 353, "fac_sg11_n_vekhi_sprat_can_lore") },
			},
		}
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.fish_fac_sg11_n_vekhi_sprat
		return {
			vars = {
				card.ability.extra.amount,
			},
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
	button_key = "b_open",
})
