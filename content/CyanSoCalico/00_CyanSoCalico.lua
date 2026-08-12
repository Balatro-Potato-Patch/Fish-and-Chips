SMODS.Atlas({
	key = "csc_fish",
	path = "CyanSoCalico/fish.png",
	px = 71,
	py = 95,
})

G.ARGS.LOC_COLOURS["CyanSoCalico"] = HEX("7AC7AC")
G.C["CyanSoCalico"] = HEX("7AC7AC")

PotatoPatchUtils.Developer({
	name = 'CyanSoCalico',
	atlas = 'fac_csc_fish',
	pos = { x = 5, y = 14 },
	colour = G.C.CyanSoCalico,
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