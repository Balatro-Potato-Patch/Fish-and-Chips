FishAndChips.Fish {
	key = "tss_chesh",
	atlas = "tss_fish",
	pos = { x = 0, y = 0 },
	weight = 5,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "xmult", "destroy_card" },
	config = { extra = { xmult = 1, xmult_mod = .25, odds = 2 } },
	environments = {
		backroom = 5,
		wormhole = 2
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_tss_chesh")
		return { vars = { num, dem, card.ability.extra.xmult_mod, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and not context.failed and SMODS.pseudorandom_probability(card,"fcc_tss_chesh",1,card.ability.extra.odds) then
			local f = G.FISHING.fac_fish_reward_area.cards[1]

			f.tss_cheshed = true
			
			card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
			
			f.states.click.can = false -- Apparently it should be like this already but they forgot. Will remove once that is patched :p
			
			G.E_MANAGER:add_event(Event({func=function()
				card.area:remove_card(card)
				G.FISHING.fac_fish_reward_area:emplace(card)
				play_sound("whoosh")
				card.T.w = card.T.w*1.3
				card.T.h = card.T.h*1.3
			return true end}))
			
			G.E_MANAGER:add_event(Event({trigger = "after", delay = .65, func=function()
				card:juice_up()
				SMODS.calculate_effect({message = localize("fac_tss_chesh_giggle_"..pseudorandom("fac_tss_chesh_giggle",1,4)), colour = G.C.PURPLE, instant = true}, card)
			return true end}))

			for i = 1, 5, 1 do
				G.E_MANAGER:add_event(Event({trigger = "after", delay = .65, func=function()
					card:juice_up()
					f:juice_up()
					play_sound("fac_tss_eat"..pseudorandom("fac_tss_chesh_eat_sfx",1,3))
				return true end}))
			end

			G.E_MANAGER:add_event(Event({trigger = "after", delay = .65, func=function()
				f:juice_up()
				SMODS.destroy_cards(f)
				f:start_dissolve({HEX("917bad")})
			return true end}))

			G.E_MANAGER:add_event(Event({func=function()
				card.area:remove_card(card)
				G.fac_fish_area:emplace(card)
				play_sound("fac_tss_burp")
				card.T.w = card.T.w/1.3
				card.T.h = card.T.h/1.3
			return true end}))

		end

		if context.joker_main and card.ability.extra.xmult ~= 1 then return { xmult = card.ability.extra.xmult } end
	end
}

local emplace_hook = CardArea.emplace
function CardArea:emplace(card)
	if card.tss_cheshed then return end
	emplace_hook(self,card)
end

FishAndChips.Fish {
	key = "tss_resident",
	atlas = "tss_fish",
	pos = { x = 0, y = 0 },
	weight = 13,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "mult" },
	config = { extra = { mult = 0, mult_mod = 2 } },
	environments = {
		city_river = 1,
		backroom = 4
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
			
			return { message = localize("k_upgrade_ex") }
		end

		if context.joker_main then return { mult = card.ability.extra.mult } end
	end
}

FishAndChips.Fish {
	key = "tss_caviar",
	atlas = "tss_fish",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "economy" },
	config = { extra = { mod = 1 } },
	environments = {
		city_river = 3,
		soup = 5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mod } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.mod
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = G.C.SAND_DOLLAR
			}
		end
	end
}