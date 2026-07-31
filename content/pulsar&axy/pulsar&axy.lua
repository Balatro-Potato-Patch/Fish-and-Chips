PotatoPatchUtils.Developer({
	name = 'Pulsar',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	fac_partner = 'Axy' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'Axy',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.YELLOW,
	fac_partner = 'Pulsar'
})

SMODS.Atlas({
	key = "pulsarfish", -- Please include your name/team name in your atlas keys
	path = "pulsar&axy/feesh.png",
	px = 71,
	py = 95,
})

--#region Fish

FishAndChips.Fish {
	key = "videogame",
	weight = 10,
	atlas = "pulsarfish",
	pos = { x = 5, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xmult" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 1,
            xmult_gain = 0.5
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult, } }
	end,
	calculate = function(self, card, context)
        if context.fac_end_fishing and context.perfect and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_gain"
            })
        end

		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}

FishAndChips.Fish {
	key = "heatshield",
	weight = 10,
	atlas = "pulsarfish",
	pos = { x = 1, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "economy" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = false,
	config = {
		extra = {
			rerolls = 0,
            reroll_gain = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reroll_gain, card.ability.extra.rerolls, } }
	end,
	calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
            -- 1 Free Location Reroll
            -- sendDebugMessage(context.consumeable.ability.set .. " detected", "HeatshieldLogger")
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rerolls",
                scalar_value = "reroll_gain"
            })
        end

		if card.ability.extra.rerolls > 0 and context.fac_environment_changed then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rerolls",
                scalar_value = "reroll_gain",
				operation = '-'
            })
			ease_dollars(5)
		end
	end,
}

FishAndChips.Fish {
	key = "onering",
	weight = 2,
	atlas = "pulsarfish",
	pos = { x = 3 , y = 1},
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "boss_blind", "scaling", "passive" },
	environments = {
		aquifer = 1,
		chocolate_river = 0.3,
		styx = 0.3,
		city_river = 0.3
	},
	loc_txt = {
		"potato"
	},
	blueprint_compat = false,
	config = {
		extra = {
			perma_h_xblind_size = 2,
			blindsize = 1,
			blindsize_increase = 1.15
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.perma_h_xblind_size, } }
	end,
	remove_from_deck = function(self, card, from_debuff)
		if FishAndChips.get_environment().key ~= 'volcano' then
			G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * card.ability.extra.perma_h_xblind_size
		else
			G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling / card.ability.extra.perma_h_xblind_size
		end
	end,
	calculate = function(self, card, context)
		-- disable all boss blinds
		-- blind size increases per round
		if context.end_of_round then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "blindsize",
                scalar_value = "blindsize_increase",
				operation = '*'
            })
		end
	end
}

--#endregion
