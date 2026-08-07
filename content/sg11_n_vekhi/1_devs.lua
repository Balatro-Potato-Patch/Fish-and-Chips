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
	fac_partner = "fac_vevekhi",
	loc = "fac_sleepyg11",
	calculate = function(self, context)
		FishAndChips.QuantumFish.calculate(context)

		if context.selling_card and not context.blueprint then
			G.GAME.fac_yellowbin_sold_centers = G.GAME.fac_yellowbin_sold_centers or {}
			table.insert(G.GAME.fac_yellowbin_sold_centers, context.card.config.center.key)
			if #G.GAME.fac_yellowbin_sold_centers > 50 then
				table.remove(G.GAME.fac_yellowbin_sold_centers, 1)
			end
		end
	end,
})

PotatoPatchUtils.Developer({
	name = "vevekhi",
	atlas = "fac_sg11_n_vekhi_credits",
	pos = { x = 0, y = 0 },
	colour = G.C.MULT,
	fac_partner = "fac_sleepyg11",
	loc = "fac_vevekhi",
})
