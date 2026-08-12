SMODS.Atlas {
	key = 'bagels_credits',
	path = 'bagels/credits.png',
	px = 71,
	py = 95,
}

PotatoPatchUtils.Developer {
	name = 'Emik',
	atlas = 'fac_bagels_credits',
	loc = true,
	pos = { x = 0, y = 1 },
	soul_pos = { x = 1, y = 1 },
	colour = G.C.BLACK,
	fac_partner = 'fac_BakersDozenBagels',
}
PotatoPatchUtils.Developer {
	name = 'BakersDozenBagels',
	atlas = 'fac_bagels_credits',
	loc = true,
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	colour = HEX 'EDD198',
	fac_partner = 'fac_Emik',
}
