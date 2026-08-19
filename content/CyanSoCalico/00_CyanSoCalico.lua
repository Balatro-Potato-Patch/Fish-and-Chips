SMODS.Atlas({
	key = "csc_fish",
	path = "CyanSoCalico/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "csc_suke",
	path = "CyanSoCalico/literally-just-suketoudara-because-he's-been-causing-sprite-bleed-issues.png",
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
	colour = G.C.fac_csc_CSC,
	loc = true,
	calculate = function(self, context)
		-- The Fish (saves after use, as without this, you could use it, savescum, then get it back) (ghostsalt)
		if context.fac_use_fish and context.fac_use_fish.config.center.key == "fish_fac_csc_the_fish" then
        	G.E_MANAGER:add_event(Event({
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							save_run()
							return true
						end
					}))
					return true
				end
			}))
		end
	end,
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