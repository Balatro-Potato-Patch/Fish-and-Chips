

PotatoPatchUtils.Developer({
	name = 'stupid',
	atlas = 'stupid_egg_credits',
	colour = G.C.BLUE,
	fac_partner = 'egg_node'
})

PotatoPatchUtils.Developer({
	name = 'egg_node',
	atlas = 'stupid_egg_credits',
	pos = {x = 1, y = 0},
	colour = G.C.MONEY,
	fac_partner = 'stupid'
})

SMODS.Atlas({
	key = "stupid_egg_credits",
	path = "egg_stupid/credits.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "stupid_egg_fishies",
	path = "egg_stupid/fishies.png",
	px = 71,
	py = 95,
})



--[[

Bait Attributes

"mult"
"chips"
"economy"
"xmult"
"retrigger"
"space"
"function"
"suit"
"passive"
"rank"
"copy"
"generation"
"boss"
"destroy"

]]

--#region fishies

FishAndChips.Fish {
	key = "stupid_egg_pale_oil",
	atlas = "stupid_egg_fishies",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },
    -- TODO
	attributes = { "chips" },
	config = {
        -- TODO
		extra = {
			chips = 30
		}
	},
	environments = {
        -- TODO
		pier = 10,
		city_river = 2.5
	},
	loc_vars = function(self, info_queue, card)
        -- TODO
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
        -- TODO
		if context.joker_main then return { chips = card.ability.extra.chips } end
	end,
}

FishAndChips.Fish {
	key = "stupid_egg_void_fish",
	atlas = "stupid_egg_fishies",
	pos = { x = 1, y = 0 },
	weight = 10,
	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },
    -- TODO
	attributes = { "chips" },
	config = {
        -- TODO
		extra = {
			chips = 30
		}
	},
	environments = {
        -- TODO
		pier = 10,
		city_river = 2.5
	},
	loc_vars = function(self, info_queue, card)
        -- TODO
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
        -- TODO
		if context.joker_main then return { chips = card.ability.extra.chips } end
	end,
}

FishAndChips.Fish {
	key = "stupid_egg_root_fish",
	atlas = "stupid_egg_fishies",
	pos = { x = 1, y = 0 },
	weight = 10,
	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },
    -- TODO
	attributes = { "chips" },
	config = {
        -- TODO
		extra = {
			chips = 30
		}
	},
	environments = {
        -- TODO
		pier = 10,
		city_river = 2.5
	},
	loc_vars = function(self, info_queue, card)
        -- TODO
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
        -- TODO
		if context.joker_main then return { chips = card.ability.extra.chips } end
	end,
}

--#endregion

