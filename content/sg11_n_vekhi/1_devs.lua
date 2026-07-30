SMODS.Atlas({
	key = "sg11_n_vekhi_credits",
	path = "sg11_n_vekhi/credits.png",
	px = 71,
	py = 95,
})

PotatoPatchUtils.Developer({
	name = "sleepyg11",
	atlas = "fac_sg11_n_vekhi_credits",
	pos = { x = 1, y = 0 },
	colour = G.C.CHIPS,
	fac_partner = "vevekhi",
	loc = "fac_sleepyg11",
	calculate = function(self, context)
		FishAndChips.QuantumFish.calculate(context)
	end,
})

PotatoPatchUtils.Developer({
	name = "vevekhi",
	atlas = "fac_sg11_n_vekhi_credits",
	pos = { x = 0, y = 0 },
	colour = G.C.MULT,
	fac_partner = "sleepyg11",
	loc = "fac_vevekhi",
})

-- FishAndChips.mod.optional_features = FishAndChips.mod.optional_features or {}
-- FishAndChips.mod.optional_features.post_trigger = true
