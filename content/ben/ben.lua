PotatoPatchUtils.Developer({
	name = "Ben",
	atlas = "fac_bencredits",
	colour = G.C.CHIPS,
	ignore_limits = false,
	soul_pos = { x = 0, y = 1 }
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
	attributes = { "economy" },
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
	loc_vars = function(self, info_queue, card)
		return { vars = { G.GAME.interest_amount, G.GAME.interest_cap / 5 } }
	end,
	calculate = function(self, card, context)
		if context.modify_final_cashout then 
			interest = math.min(math.floor(G.GAME.fac_sand_dollars / 5), G.GAME.interest_cap / 5)
			if interest <= 0 then return end
			vars = {
				name = "joker",
				sand_dollars = interest,
				pitch = 1, --src/sand_dollars.lua 234 tries to do arithmetic on pitch (a nil value),
				card = card
			}
			add_round_eval_sand_dollars(vars)
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
	attributes = { "copying" },
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
	calculate = function(self, card, context)
		if context.joker_main then 
            if card.ability.extra.slot > #G.jokers.cards then return end
			joker = G.jokers.cards[card.ability.extra.slot]

			local ret = SMODS.blueprint_effect(card, joker, context)
			return ret
		end
		if context.end_of_round and context.main_eval then
			old_slot = card.ability.extra.slot
			repeat
				card.ability.extra.slot = pseudorandom("chameleon", 1, G.jokers.config.card_limit)
			until card.ability.extra.slot ~= old_slot
		end
	end,
	on_catch = function(self, card)
		card.ability.extra.slot = pseudorandom("chameleon", 1, G.jokers.config.card_limit)
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
		volcano = 10,
		aquifer = 10,
		styx = 10,
		chocolate_river = 10,
		pier = 10,
		soup = 10,
		garden = 10,
		wormhole = 10,
		backroom = 10
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.visited } }
	end,
	on_catch = function(self, card)
		environment = G.GAME.fac_fishing_environment
		if card.ability.extra[environment] == false then
			card.ability.extra[environment] = true
			card.ability.visited = card.ability.visited + 1
		end
	end,
	calculate = function(self, card, context)
		if context.fac_environment_changed then
			environment = G.GAME.fac_fishing_environment
			if card.ability.extra[environment] == false then
				card.ability.extra[environment] = true
				card.ability.visited = card.ability.visited + 1
			end
		end
		if context.modify_final_cashout then 
			interest = math.min(math.floor(G.GAME.fac_sand_dollars / 5), G.GAME.interest_cap / 5)
			if interest <= 0 then return end
			vars = {
				name = "joker",
				sand_dollars = interest,
				pitch = 1, --src/sand_dollars.lua 234 tries to do arithmetic on pitch (a nil value),
				card = card
			}
			add_round_eval_sand_dollars(vars)
		end
	end
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
	calculate = function(self, card, context)
		
	end,
}
--]]