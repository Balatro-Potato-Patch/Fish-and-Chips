SMODS.Atlas({
	key = "sg11_n_vekhi_transcendent",
	path = "sg11_n_vekhi/transcendent.png",
	px = 71,
	py = 95,
	atlas_table = "ANIMATION_ATLAS",
	frames = 14,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_transcendent",
	atlas = "fac_sg11_n_vekhi_transcendent",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = {},
	config = {},
	weight = 4,
	stats = {
		weight = { min = 1, max = 1 },
		length = { min = 1, max = 1 },
	},
	environments = {
		backroom = 1,
		wormhole = 1,
	},
	loc_vars = function(self, info_queue, card) end,
	calculate = function(self, card, context) end,
})
