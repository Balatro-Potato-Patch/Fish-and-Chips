SMODS.Atlas({
	key = "tjedits", -- buttlas
	path = "tjetsu/ennasumifull.png",
	px = 600,
	py = 900
})

SMODS.Atlas({
	key = "tje_fish", -- buttlas
	path = "tjetsu/tjetsufish.png",
	px = 71,
	py = 95,
})

PotatoPatchUtils.Developer({
	name = 'Tjetsu',
	colour = G.C.PURPLE,
	atlas = "fac_tjedits",
	loc = true
})

SMODS.Gradient{
    key = "tje_rainbow",
    colours = {
        HEX('F61F31'),
        HEX('F66E1F'),
        HEX('F6C71F'),
        HEX('59F61F'),
        HEX('1FA3F6'),
        HEX('AE1FF6')
    }
}
G.ARGS.LOC_COLOURS.fac_tje_rainbow = SMODS.Gradients.fac_tje_rainbow

local function round(num, places)
    local mult = 10 ^ (places or 0)
    return math.floor(num * mult + 0.5) / mult
end

--#region Fish

FishAndChips.Fish { -- Candy Blossom Cod
	key = "tje_cbc",
	atlas = "tje_fish",
	pos = { x = 0, y = 0 },
	blueprint_compat = false,
	weight = 15,
	stats = {weight = {min = 5, max = 20}, length = {min = 1.8, max = 2}},
	ppu_coder = { "Tjetsu" },
	ppu_artist = { "Tjetsu" },
	attributes = { "sell_value", "passive", },
	environments = {
		chocolate_river = 15
	},
	config = {
		extra = {mutation = "???", weight = "?.??", worth = "?", mut_worth = "?"}
	},
	loc_vars = function(self, info_queue, card)
		if card.ability.extra.mutation == "Gold" then
			return {key = 'fish_fac_tje_cbc_gold', vars = { card.ability.extra.mutation, card.ability.extra.weight, card.ability.extra.worth,card.ability.extra.mut_worth}}
		elseif card.ability.extra.mutation == "Rainbow" then
			return {key = 'fish_fac_tje_cbc_rainbow', vars = { card.ability.extra.mutation, card.ability.extra.weight, card.ability.extra.worth,card.ability.extra.mut_worth}}
		else
			return {key = 'fish_fac_tje_cbc', vars = { card.ability.extra.mutation, card.ability.extra.weight, card.ability.extra.worth}}
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		local function pseudorandomdecimal(key, minimum, maximum)
			return minimum + (maximum - minimum) * pseudorandom(key)
		end
		-- Gamba for Weight
		local tiers = {
			{odds = 1/3.5,   key = "CBC1"},
			{odds = 1/4.5, key = "CBC2"},
			{odds = 1/5.5, key = "CBC3"},
		}

		local rangesw = {
			{0.1, 7,  0.5, 5},
			{1,   8,  2.5, 9},
			{5,   15, 6,   23},
			{15,  20, 8,   20},
		}

		local rangesl = {
			{0.5, 1.1, 0.425, 0.9},
			{0.9, 2.1, 0.6, 1.8},
			{1.6, 0.98, 2.3, 1.2},
			{1.34, 2, 4, 6}

		}

		local tier = 1

		for _, t in ipairs(tiers) do
			if pseudorandom(t.key) < t.odds then
				tier = tier + 1
			else
				break
			end
		end

		local r = rangesw[tier]
		local l = rangesl[tier]

		card.ability.stats.weight = round(pseudorandomdecimal("CBC_WEIGHT_A", r[1], r[2]) * pseudorandomdecimal("CBC_WEIGHT_B", r[3], r[4]), 2)
		card.ability.stats.length = round(pseudorandomdecimal("CBC_LENGTH_A", l[1], l[2]) * pseudorandomdecimal("CBC_LENGTH_B", l[3], l[4]), 2)
		-- Find Mutation
		local mutations = {
			{ name = "Gold",    mult = 1.75, odds = 1/8 },
			{ name = "Rainbow", mult = 3, odds = 1/15 }
		}

		card.ability.extra.mutation = "None"
		local mutmult = 0
		for _, mutation in ipairs(mutations) do
			if pseudorandom("CBC_MUTATION_" .. mutation.name) < mutation.odds then
				card.ability.extra.mutation = mutation.name
				mutmult = mutation.mult
				break
			end
		end
		card.ability.extra.worth = math.ceil((card.ability.stats.weight/(2+(card.ability.stats.weight/10))*(1+card.ability.stats.length)))
		card.ability.extra.mut_worth = (math.ceil((((card.ability.stats.weight/(2+(card.ability.stats.weight/10))*(1+card.ability.stats.length))))*mutmult))-math.ceil((((card.ability.stats.weight/(2+(card.ability.stats.weight/10))*(1+card.ability.stats.length)))))
		if card.ability.extra.mutation ~= "None" then
			card.sell_cost = card.ability.extra.worth+card.ability.extra.mut_worth
		else
			card.sell_cost = card.ability.extra.worth
		end
	end,
}

FishAndChips.Fish { -- Ineffa
	key = "tje_ineffa",
	atlas = "tje_fish",
	pos = { x = 1, y = 0 },
	stats = {weight = {min = 80, max = 80}, length = {min = 0.75, max = 0.43}},
	weight = 15,
	ppu_coder = { "Tjetsu" },
	ppu_artist = { "Tjetsu" },
	attributes = { "retrigger", "fac_perfect_catch" },
	environments = {
		volcano = 11,
		wormhole = 6
	},
	config = {
		extra = {re = 1, pscale = 1, ucount = 3}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.re, card.ability.extra.pscale, card.ability.extra.ucount, ppu_bubbles = {card.ability.extra.ucount > 0 and 'active' or 'inactive'}}}
	end,

	calculate = function(self, card, context)
		if context.perfect and context.fac_end_fishing and not context.blueprint then
		    SMODS.scale_card ( card, {
				ref_table = card.ability.extra,
				ref_value = "ucount",
				scalar_value = "pscale",
				scaling_message = {
					message = localize {
						type = "variable",
						key = "a_remaining",
						vars = { card.ability.extra.ucount + card.ability.extra.pscale }
					}
				}
			})
			return nil, true
		end
		if context.repetition and context.cardarea == G.play and card.ability.extra.ucount > 0 then
			return {
                repetitions = card.ability.extra.re,
                card = card
            }
		end
		if context.after and card.ability.extra.ucount > 0 and not context.blueprint then
			card.ability.extra.ucount = card.ability.extra.ucount-1
			return {
				message = localize {
					type = "variable",
					key = "a_remaining",
					vars = { card.ability.extra.ucount }
				},
				card = card
            }
		end
	end,

}

FishAndChips.Fish { --Sans
	key = "tje_sans",
	atlas = "tje_fish",
	pos = { x = 2, y = 0 },
	stats = {weight = {min = 1, max = 1}, length = {min = 1, max = 1}},
	weight = 15,
	ppu_coder = { "Tjetsu" },
	ppu_artist = { "Tjetsu" },
	attributes = { "chips", "scaling", "rank", "ace", "reset", "undertale", "deltarune", "utdr", },
	environments = {
		styx = 13,
		wormhole = 5
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.defaultchips, card.ability.extra.scorechips, card.ability.extra.chipfailscale, card.ability.extra.chipscale}}
	end,
	config = {
		extra = {defaultchips = 1, scorechips = 1, chipfailscale = 4, chipscale=1, flag=true, count=0}
	},
	calculate = function(self, card, context)
		if context.setting_blind then
			card.ability.extra.flag = true
		end
		if context.failed and context.fac_end_fishing then
			SMODS.scale_card (card, {
				ref_table = card.ability.extra,
				ref_value = "chipscale",
				scalar_value = "chipfailscale",
			})
			return nil, true
		end
		if context.hand_drawn then
			for i, v in ipairs(context.hand_drawn) do
				if context.hand_drawn[i]:get_id() == 14 then
				    SMODS.scale_card (card, {
						ref_table = card.ability.extra,
						ref_value = "scorechips",
						scalar_value = "chipscale",
					})
				end
			end
			return nil, true
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.scorechips
			}
		end
		if context.end_of_round and card.ability.extra.flag == true then
			card.ability.extra.flag = false
			SMODS.reset_card (card, {
			    ref_table = card.ability.extra,
				ref_value = "scorechips",
				reset_value = card.ability.extra.defaultchips,
			})
		end
	end
}

-- Furina was scrapped, sorry...


--#endregion
