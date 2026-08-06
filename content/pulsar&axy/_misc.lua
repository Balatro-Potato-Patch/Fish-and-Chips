--#region Misc
PotatoPatchUtils.Developer({
	name = 'Pulsar',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	fac_partner = 'fac_Axy' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'Axy',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.YELLOW,
	fac_partner = 'fac_Pulsar'
})

SMODS.Atlas({
	key = "pa_pulsarfish", -- Please include your name/team name in your atlas keys
	path = "pulsar&axy/feesh.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "pa_doorfish", -- Please include your name/team name in your atlas keys
	path = "pulsar&axy/doorpopup.png",
	px = 71,
	py = 95,
})

SMODS.Sound {
	key = "pa_wiinormal",
	path = "pulsar&axy/wiiplayfishingnormal.ogg"
}
SMODS.Sound {
	key = "pa_wiibonus",
	path = "pulsar&axy/wiiplayfishingbonus.ogg"
}

--#endregion
