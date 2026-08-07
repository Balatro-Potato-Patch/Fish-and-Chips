

PotatoPatchUtils.Developer({
	name = 'stupid',
	atlas = 'fac_segg_credits',
	pos = {x = 1, y = 0},
	colour = G.C.BLUE,
	fac_partner = 'egg_node'
})

PotatoPatchUtils.Developer({
	name = 'egg_node',
	atlas = 'fac_segg_credits',
	pos = {x = 0, y = 0},
	colour = G.C.MONEY,
	fac_partner = 'stupid'
})

SMODS.Atlas({
	key = "segg_credits",
	path = "egg_stupid/credits.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "segg_fishies",
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

--#region utility





--#endregion



--#region fishies

FishAndChips.Fish {
	key = "segg_pale_oil",
	atlas = "segg_fishies",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	treasure = true, -- Our only treasure :)

	attributes = { "usable", "function" },
	config = {
	},
	stats = {
		weight = {min = 0.1, max = 0.4},
		length = {min = 0.1, max = 0.4}
	},
	environments = {
		pier = 1.5,
		aquifer = 1.5,
		swamp = 2,
		city_river = 0.5
	},
	loc_vars = function(self, info_queue, card)
	end,

	use = function(self, card)
		local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)

        local eligible_card = pseudorandom_element(editionless_jokers, 'egg_stupid_pale_oil')
        local edition = SMODS.poll_edition {
			key = "egg_stupid_pale_oil_e",
			guaranteed = true,
			no_negative = true,
		}
        eligible_card:set_edition(edition, true)
	end,
	can_use = function(self, card)
		-- Apparently is a utility method huh
        return next(SMODS.Edition:get_edition_cards(G.jokers, true))
	end
}

FishAndChips.Fish {
	key = "segg_void_fish",
	atlas = "segg_fishies",
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
	stats = {
		weight = {min = 1, max = 10000.},
		length = {min = 1., max = 10000.}
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
	key = "segg_root_fish",
	atlas = "segg_fishies",
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
	stats = {
		weight = {min = 0.5, max = 15},
		length = {min = 0.5, max = 10}
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

