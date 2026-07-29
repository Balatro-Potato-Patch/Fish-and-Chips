local thunderedge_gradient = SMODS.Gradient({
	key = "thunderedge_gradient",
	colours = {
		HEX("89C41B"),
		HEX("C5CC41"),
	},
	cycle = 1.5,
})

PotatoPatchUtils.Developer({
	name = "thunderedge",
    loc = true,
	atlas = "fac_cards",
	colour = thunderedge_gradient,
	fac_partner = "aikoyori",
})

PotatoPatchUtils.Developer({
	name = "aikoyori",
    loc = true,
	atlas = "fac_cards",
	pos = { x = 1, y = 0 },
	colour = G.C.YELLOW,
	fac_partner = "thunderedge",
})
