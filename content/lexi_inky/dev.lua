SMODS.Gradient({
	key = "l_i_lexi",
	colours = {
		HEX("ff75c9"),
		G.C.WHITE,
		G.C.ORANGE,
	},
	cycle = 2,
})

PotatoPatchUtils.Developer({
	name = "inky",
	--atlas = "",
	colour = HEX("189bcc"),
	fac_partner = "lexi",
	loc = true,
})

PotatoPatchUtils.Developer({
	name = "lexi",
	--atlas = "",
	colour = SMODS.Gradients["fac_l_i_lexi"],
	fac_partner = "inky",
	loc = true,
	click = function(self)
		love.system.openURL("https://triple6lexi.carrd.co/")
	end,
})

--[[SMODS.Atlas({
	key = "l_i_credits",
	path = "lexi_inky/credits.png",
	px = 71,
	py = 95,
})]]
