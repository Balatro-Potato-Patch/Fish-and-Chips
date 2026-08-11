FishAndChips.Fish {
	key = "pa_blackhole",
	weight = 3,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 2 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Pulsar" },
	attributes = { "passive" }, --it shouldn't technically have any but i think you need one
	environments = {
		wormhole = 1
	},
	decision_min = 0.001,
	decision_max = 0.002,
	impulse_min = 0.51,
	impulse_max = 0.83,
	vel_limit = 0.84,
	stats = { --the mass comes from the black hole itself, but the length is from the reletavistic jets because the event horizon would be sand grain sized
		length = {min = 5e11, max = 1e12, units = { format = "au_format", scale = 1.49597e11, precision = 4}},  --0.5 to 2 terameters (for context, Saturn's orbital height is about 1.4Tm)
		weight = { min = 1e22, max = 1e23, units = { format = "yg_format", scale = 1e21, precision = 3}} -- 10 to 100 yottagrams (for context, the Moon is about 73 Yg)
	},
	blueprint_compat = false,
}