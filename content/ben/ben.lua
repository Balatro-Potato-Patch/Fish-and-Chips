PotatoPatchUtils.Developer({
	name = "Ben",
	atlas = "fac_bencredits",
	colour = G.C.CHIPS,
	ignore_limits = false,
	soul_pos = { x = 0, y = 1 },
	loc = true
})

SMODS.Atlas({
	key = "bencredits",
	path = "ben/credits.png",
	px = 71,
	py = 95,
})

--Fish

SMODS.Atlas({
	key = "benfish",
	path = "ben/fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	--Safe
	--Earn interest on your Sand Dollars
	key = "bensafe",
	atlas = "fac_benfish",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "Ben" },
	ppu_artist = { "Ben" },
	attributes = { "economy", "passive", },
	config = {
	},
	environments = {
		--calm_pond = 0,
		city_river = 10,
		--swamp = 0,
		--volcano = 0,
		--aquifer = 0,
		--styx = 0,
		--chocolate_river = 0,
		pier = 10--,
		--soup = 0,
		--garden = 0,
		--wormhole = 0,
		--backroom = 0
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.interest_amount, G.GAME.interest_amount * (G.GAME.interest_cap / 5) } }
	end,
	stats = {weight = {min = 2, max = 2}, length = {min = 0.3, max = 0.3}},
	calc_sand_dollar_bonus = function(self, card)
		local interest = math.min(math.floor(G.GAME.fac_sand_dollars / 5), G.GAME.interest_cap / 5)
		if interest > 0 then 
			return interest * G.GAME.interest_amount
		end
	end
}

FishAndChips.Fish {
	key = "benchameleon",
	atlas = "fac_benfish",
	pos = { x = 1, y = 0 },
	weight = 10,
	ppu_coder = { "Ben" },
	ppu_artist = { "Ben" },
	attributes = { "copying", "joker", "position", },
	config = {
		extra = {
			slot = 1
		}
	},
	environments = {
		calm_pond = 10,
		--city_river = 0,
		swamp = 10,
		--volcano = 0,
		--aquifer = 0,
		--styx = 0,
		--chocolate_river = 0,
		--pier = 0,
		--soup = 0,
		--garden = 0,
		--wormhole = 0,
		--backroom = 0
	},
	loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.fac_fish_area then
            local joker
            if card.ability.extra.slot > #G.jokers.cards then
				joker = false
			else
				joker = G.jokers.cards[card.ability.extra.slot]
			end
            local compatible = joker and joker.config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { vars = { card.ability.extra.slot }, main_end = main_end }
        end
		return { vars = { card.ability.extra.slot } }
    end,
	stats = {weight = {min = 0.0008, max = 0.002}, length = {min = 0.05, max = 0.08}},
	calculate = function(self, card, context)
		local ret
	        if card.ability.extra.slot <= #G.jokers.cards then  
			local joker = G.jokers.cards[card.ability.extra.slot]
			ret = SMODS.blueprint_effect(card, joker, context)
		end

		if context.end_of_round and context.main_eval then
			if #G.jokers.cards > 0 then
				local old_slot = card.ability.extra.slot
				repeat
					card.ability.extra.slot = pseudorandom("chameleon", 1, #G.jokers.cards)
				until card.ability.extra.slot ~= old_slot or #G.jokers.cards == 1
			else
				card.ability.extra.slot = 1
			end
		end

		if #G.jokers.cards < card.ability.extra.slot then
			if #G.jokers.cards > 0 then
				local old_slot = card.ability.extra.slot
				repeat
					card.ability.extra.slot = pseudorandom("chameleon", 1, #G.jokers.cards)
				until card.ability.extra.slot ~= old_slot
			else
				card.ability.extra.slot = 1
			end
		end
		
		return ret
	end,
	on_catch = function(self, card)
		card.ability.extra.slot = pseudorandom("chameleon", 1, #G.jokers.cards)
	end,
}

FishAndChips.Fish {
	key = "benyapping",
	atlas = "fac_benfish",
	pos = { x = 2, y = 0 },
	weight = 10,
	ppu_coder = { "Ben" },
	ppu_artist = { "Ben" },
	attributes = { "economy" },
	config = {
		extra = {
			calm_pond = false,
			city_river = false,
			swamp = false,
			volcano = false,
			aquifer = false,
			styx = false,
			chocolate_river = false,
			pier = false,
			soup = false,
			garden = false,
			wormhole = false,
			backroom = false,
			visited = 0
		}
	},
	environments = {
		calm_pond = 10,
		city_river = 10,
		swamp = 10,
		--volcano = 10,
		aquifer = 10,
		--styx = 10,
		--chocolate_river = 10,
		pier = 10,
		--soup = 10,
		garden = 10,
		--wormhole = 10,
		--backroom = 10
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.visited } }
	end,
	flavour_vars = function(self, info_queue, card)
		local environment = G.GAME.fac_fishing_environment
		if environment then
			return { key = "fish_fac_benyapping_"..environment }
		end
	end,
	stats = {weight = {min = 4.5, max = 16}, length = {min = 0.20, max = 0.35}},
	on_catch = function(self, card)
		local environment = G.GAME.fac_fishing_environment
		if card.ability.extra[environment] == false then
			card.ability.extra[environment] = true
			card.ability.extra.visited = card.ability.extra.visited + 1
		end
	end,
	calculate = function(self, card, context)
		if context.fac_environment_changed and not context.blueprint then
			local environment = G.GAME.fac_fishing_environment
			if card.ability.extra[environment] == false then
				card.ability.extra[environment] = true
				card.ability.extra.visited = card.ability.extra.visited + 1
			end
		end
	end,
	calc_sand_dollar_bonus = function(self, card)
		if card.ability.extra.visited > 0 then
			return card.ability.extra.visited
		end
	end
}

FishAndChips.Fish {
	key = "benseashell",
	atlas = "fac_benfish",
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = { "Ben" },
	ppu_artist = { "Ben" },
	attributes = {
		"xmult"
	},
	config = {
		extra = {
			xmult_per = 0.1,
			per_sand_dollars = 5
		}
	},
	environments = {
		--calm_pond = 0,
		--city_river = 0,
		--swamp = 0,
		--volcano = 0,
		--aquifer = 0,
		--styx = 0,
		--chocolate_river = 0,
		pier = 10,
		--soup = 0,
		--garden = 0,
		--wormhole = 0,
		--backroom = 0
	},
	loc_vars = function(self, info_queue, card)
		local scaled_sand_dollars = math.floor(G.GAME.fac_sand_dollars / card.ability.extra.per_sand_dollars)
		local xmult = 1 + scaled_sand_dollars * card.ability.extra.xmult_per
		return { vars = { card.ability.extra.xmult_per, card.ability.extra.per_sand_dollars, xmult } }
	end,
	stats = {weight = {min = 0.001, max = 0.01}, length = {min = 0.02, max = 0.08}},
	calculate = function(self, card, context)
		if context.joker_main then
			local scaled_sand_dollars = math.floor(G.GAME.fac_sand_dollars / card.ability.extra.per_sand_dollars)
			return { xmult = 1 + scaled_sand_dollars * card.ability.extra.xmult_per }
		end
	end,
}

FishAndChips.Fish {
	key = "benvoucher",
	atlas = "fac_benfish",
	pos = { x = 4, y = 0 },
	weight = 10,
	ppu_coder = { "Ben" },
	ppu_artist = { "Ben" },
	attributes = { "generation" },
	config = {
		extra = {

		}
	},
	environments = {
		--calm_pond = 10,
		--city_river = 10,
		--swamp = 10,
		volcano = 10,
		--aquifer = 10,
		styx = 10,
		chocolate_river = 10,
		--pier = 10,
		soup = 10,
		--garden = 10,
		wormhole = 10,
		backroom = 10
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	stats = {weight = {min = 0.001, max = 0.002}, length = {min = 0.1, max = 0.1}},
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			local key = pseudorandom_element(G.P_CENTER_POOLS["fac_Bait"], "benvoucher").key
			FishAndChips.add_bait_to_inventory(key, 1)
			return {
				message = '+1 ' .. localize { set = 'fac_Bait', key = key, type = 'name_text' }
			}
		end
	end,
}

--Template fish

--[[
FishAndChips.Fish {
	key = "ben",
	atlas = "fac_benfish",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "Ben" },
	ppu_artist = { "Ben" },
	attributes = { "" },
	config = {
		extra = {

		}
	},
	environments = {
		--calm_pond = 0,
		--city_river = 0,
		--swamp = 0,
		--volcano = 0,
		--aquifer = 0,
		--styx = 0,
		--chocolate_river = 0,
		--pier = 0,
		--soup = 0,
		--garden = 0,
		--wormhole = 0,
		--backroom = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	stats = {weight = {min = 0.0008, max = 0.002}, length = {min = 0.05, max = 0.08}},
	calculate = function(self, card, context)

	end,
}
--]]
