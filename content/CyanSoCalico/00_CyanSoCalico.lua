SMODS.Atlas({
	key = "csc_fish",
	path = "CyanSoCalico/fish.png",
	px = 71,
	py = 95,
})

local loc_colours = {
	CSC = "7AC7AC",
	MLM1 = "078D70",
	MLM2 = "98E8C1",
	MLM3 = "FFFFFF",
	MLM4 = "7BADE2",
	MLM5 = "3D1A78"
}

for k, v in pairs(loc_colours) do
	G.ARGS.LOC_COLOURS["fac_csc_"..k] = HEX(v)
	G.C["fac_csc_"..k] = HEX(v)
end

PotatoPatchUtils.Developer({
	name = 'CyanSoCalico',
	atlas = 'fac_csc_fish',
	pos = { x = 1, y = 3 },
	colour = G.C.CyanSoCalico,
	loc = true
})
--[[
FishAndChips.Fish {
	key = "csc_key",
	atlas = "csc_fish",
	pos = { x = -, y = - },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "-" },
	config = {
		extra = {
			- = -
		}
	},

	stats = {
		weight = {
			min = -,
			max = -
		},
		length = {
			min = -,
			max = -
		}
	},

    weight = -,
	environments = {
		- = -,
		- = -
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,

	calculate = function(self, card, context)
		-
	end,
}
]]