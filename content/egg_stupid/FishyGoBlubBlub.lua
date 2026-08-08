

PotatoPatchUtils.Developer({
	name = 'stupid',
	atlas = 'fac_segg_credits',
	pos = {x = 1, y = 0},
	colour = G.C.BLUE,
	fac_partner = 'fac_egg_node',

	calculate = function (self, context)
		if context.setting_blind and G.GAME.fac_plasmium_infection then
			local mod = fac_get_plasmium_blind_mod()
			if mod > 1e300 then
				return {
					blindsize = mod
				}
			end
			return {
				xblindsize = mod
			}
		end
	end
})

PotatoPatchUtils.Developer({
	name = 'egg_node',
	atlas = 'fac_segg_credits',
	pos = {x = 0, y = 0},
	colour = G.C.MONEY,
	fac_partner = 'fac_stupid'
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

function fac_get_plasmium_blind_mod(single)
	if G.GAME.fac_plasmium_infection >= 10 then
		-- blind size is now always inf

		return 1e308
	elseif G.GAME.fac_plasmium_infection > 1 then
		if single then
			return (0.9 + 0.1 * G.GAME.fac_plasmium_infection)
		else
			local total_mod = 1

			for _ = 2, G.GAME.fac_plasmium_infection do
				total_mod = total_mod * (0.9 + 0.1 * G.GAME.fac_plasmium_infection)
			end

			print(total_mod)

			return total_mod
		end
	end

	return 1
end



--#endregion



--#region fishies

-- Pale oil flask
-- Make random joker editioned
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

-- Void Fish 
-- Retriggers all played cards but lose money
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
	
			return {
				message = localize('b_fac_segg_void_fish'),
				colour = G.C.BLACK
			}
		end
		if context.repetition and context.other_card.area == G.play then
			return {
				repetitions = 1
			}
		end
	end,
}

-- Rootfish
-- Saps sell value from other jokers, gains Xmult for it
FishAndChips.Fish {
	key = "segg_root_fish",
	atlas = "segg_fishies",
	pos = { x = 2, y = 0 },

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
		swamp = 3,
		backroom = 0.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars, card.ability.extra.xmult_mod, card.ability.extra.xmult, } }
	end,
	calculate = function(self, card, context)
		
        if context.setting_blind and not context.blueprint then
			local xmult_gained = 0
			for _, joker in pairs(G.jokers.cards) do
				if joker.set_cost and joker.sell_cost > 1 then
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

		if context.final_scoring_step then
			return { xmult = card.ability.extra.xmult }
		end
	end,
}


-- Plasmium Phial
-- Use to add +3 hands this round
-- side-effect/infection: increase blind size (after first use).
-- after using for 5+ times, blinds become unbeatable (?)

FishAndChips.Fish {
	key = "segg_plasmium_phial",
	atlas = "segg_fishies",
	pos = { x = 3, y = 0 },

	weight = 10,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	blueprint_compat = false,

	config = {
		extra = {
			hands = 3,
			blind_mod = 0.1,
		}
	},
	stats = {
		weight = {min = 0.3, max = 1.},
		length = {min = 0.2, max = 0.4}
	},
	environments = {
		pier = 2.,
		city_river = 5.0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands,  } }
	end,

	use = function(self, card)
		ease_hands_played(card.ability.extra.hands)

		G.GAME.fac_plasmium_infection = (G.GAME.fac_plasmium_infection or 0) + 1

		if G.GAME.fac_plasmium_infection > 1 then

			local mod = fac_get_plasmium_blind_mod(true)
			if mod > 1e300 then
				-- set to near inf to avoid crashes with inf blind size
				SMODS.calculate_effect({
					blindsize = 1e308
				}, card)
			else
				SMODS.calculate_effect({
					xblindsize = mod
				}, card)
			end
		end
	end,
	can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
	end
}


-- Fleash (Awoo!)
-- goes “awoo” and it’s gone (gives sand dollart)
-- could also spawn random consumable (must have room) (small chance for spectrals also)



-- Lost Lay's
-- (+80 chips, -20 chips at end of round. u can never eat just one chip)
FishAndChips.Fish {
	key = "segg_lost_lays",
	atlas = "segg_fishies",
	pos = { x = 1, y = 1 },

	weight = 15,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	attributes = { "chips" },
	config = {
		extra = {
			chips = 80,
			chips_mod = 20,
		}
	},
	stats = {
		weight = {min = 0.05, max = 0.2},
		length = {min = 0.2, max = 0.5}
	},
	environments = {
		city_river = 3,
		pier = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chips_mod, } }
	end,
	calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chips_mod

			if card.ability.extra.chips <= 0 then
				-- bye bye
				return {
					message = localize('b_fac_segg_chips_gone'),
                	colour = G.C.BLUE,
				}
			else
				-- yum yum
				return {
					message = localize('b_fac_segg_chips_down'),
                	colour = G.C.BLUE,
				}
			end
		end

		if context.joker_main then
			return { chips = card.ability.extra.chips }
		end
	end,
}


-- Courier's Rasher
-- +1 hands size for every discard remaining <- soup fish



-- Yumama
-- Use to add 3 randomly enhanced cards with the rank of 1 selected card to your hand




--#endregion

