local thunderedge_gradient = SMODS.Gradient({
	key = "thunderedge_gradient",
	colours = {
		HEX("89C41B"),
		HEX("C5CC41"),
	},
	cycle = 1.5,
})

PotatoPatchUtils.Developer({
	name = "ThunderEdge",
	atlas = "fac_cards",
	colour = thunderedge_gradient,
	fac_partner = "Aikoyori", -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = "Aikoyori",
	atlas = "fac_cards",
	pos = { x = 1, y = 0 },
	colour = G.C.YELLOW,
	fac_partner = "ThunderEdge",
})
