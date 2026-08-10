--#region Misc
PotatoPatchUtils.Developer({
	name = 'Pulsar',
	atlas = 'fac_pa_pulsarfish',
	pos = {x = 2, y = 3},
	colour = FishAndChips.C.FISH,            --fish!!!!!
	fac_partner = 'fac_Axy'
})

PotatoPatchUtils.Developer({
	name = 'Axy',
	atlas = 'fac_pa_pulsarfish',
	pos = {x = 4, y = 3},
	colour = HEX('418A83'),
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
