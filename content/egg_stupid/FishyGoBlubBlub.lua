

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

	weight = 5,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	treasure = true, -- Our only treasure :)
	blueprint_compat = false,

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

	weight = 5,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },
	attributes = { "retrigger" },
	config = {
		extra = {
			money = 0
		}
	},
	stats = {
		weight = {min = 1, max = 10000.},
		length = {min = 1., max = 10000.}
	},
	environments = {
		backroom = 10,
		swamp = 1.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	calculate = function(self, card, context)
		if context.ending_shop and not context.blueprint then
			-- Set muhnee to 0
			local muhnee = G.GAME.dollars
			ease_dollars(-muhnee)
		end
		if context.repetition and context.other_card.area == G.play then
			return {
				repetitions = 1
			}
		end
	end,
}

FishAndChips.Fish {
	key = "segg_root_fish",
	atlas = "segg_fishies",
	pos = { x = 1, y = 0 },

	weight = 5,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	attributes = { "xmult" },
	config = {
		extra = {
			dollars = 1,
			xmult_mod = 0.1,
			xmult = 1,
		}
	},
	stats = {
		weight = {min = 0.5, max = 15},
		length = {min = 0.5, max = 10}
	},
	environments = {
		swamp = 5,
		aquifer = 1.0,
		backroom = 0.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars,  } }
	end,
	calculate = function(self, card, context)
		
        if context.setting_blind and not context.blueprint then
			local xmult_gained = 0
			for _, joker in pairs(G.jokers) do
				if joker.set_cost and joker.sell_cost > 0 then
					joker.ability.extra_value = (joker.ability.extra_value or 0) - card.ability.extra.dollars
                    joker:set_cost()

					xmult_gained = xmult_gained + card.ability.extra.xmult_mod
				end
			end

			if xmult_gained > 0 then
				card.ability.extra.xmult = card.ability.extra.xmult + xmult_gained

				return {
					message = localize('k_upgrade_ex'),
                	colour = G.C.MULT,
				}
			end
		end

		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
}

--#endregion

