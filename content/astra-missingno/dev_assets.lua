PotatoPatchUtils.Developer({
	name = 'theAstra',
	atlas = 'fac_astra-missingno-credits',
	pos = { x = 1, y = 0 },
	loc = true,
	colour = HEX('8710c7'),
	fac_partner = 'fac_MissingNo',
	click = function(self)
		play_sound('fac_am_astra_click')
		self:juice_up(0.1, 0.1)
	end
})

SMODS.Gradient({
	key = "am_missingno_rainbow",
	cycle = 1,
	colours = {
		HEX("FFB0B2"),
		HEX("FFD7B0"),
		HEX("FFFAB0"),
		HEX("BFFFB0"),
		HEX("B0FFED"),
		HEX("B0E7FF"),
		HEX("B0B0FF"),
		HEX("E0B0FF"),
	},
})

PotatoPatchUtils.Developer({
	name = 'MissingNo',
	atlas = 'fac_astra-missingno-credits',
	pos = { x = 0, y = 0 },
	loc = true,
	colour = SMODS.Gradients["fac_am_missingno_rainbow"],
	fac_partner = 'fac_theAstra',
	click = function(self)
		play_sound('generic1')
		love.system.openURL("https://www.youtube.com/@copykeys")
	end
})

SMODS.Atlas({
	key = "astra-missingno-fish",
	path = "astra-missingno/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "astra-missingno-credits",
	path = "astra-missingno/credits.png",
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
	path = 'astra-missingno/am_jerry_chips.ogg',
}

SMODS.Sound {
	key = 'am_chomp',
	path = 'astra-missingno/am_chomp.ogg'
}

SMODS.Sound {
	key = 'am_le_fishe',
	path = 'astra-missingno/am_le_fishe.ogg'
}

SMODS.Sound {
	key = 'am_le_fishe_death',
	path = 'astra-missingno/am_le_fishe_death.ogg'
}

SMODS.Sound {
	key = 'am_astra_click',
	path = 'astra-missingno/am_astra_click.ogg',
	volume = 1
}
