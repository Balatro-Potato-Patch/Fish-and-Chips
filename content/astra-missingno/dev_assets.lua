PotatoPatchUtils.Developer({
	name = 'theAstra',
	colour = G.C.PURPLE,
	fac_partner = 'MissingNumber'
})

PotatoPatchUtils.Developer({
	name = 'MissingNumber',
	colour = G.C.ORANGE,
	fac_partner = 'theAstra'
})

SMODS.Atlas({
	key = "astra-missingno-fish", -- Please include your name/team name in your atlas keys
	path = "astra-missingno/fish.png",
	px = 71,
	py = 95,
})

for i = 1, 3 do
	SMODS.Sound {
		key = 'am_shrimp_' .. i,
		path = 'astra-missingno/am_shrimp_' .. i .. '.ogg'
	}
end

SMODS.Sound {
	key = 'am_jerry_intro',
	path = 'astra-missingno/am_jerry_intro.ogg'
}

SMODS.Sound {
	key = 'am_jerry_chips',
	path = 'astra-missingno/am_jerry_chips.ogg'
}

SMODS.Sound {
	key = 'am_chomp',
	path = 'astra-missingno/am_chomp.ogg'
}
