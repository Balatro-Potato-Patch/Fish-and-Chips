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

--#endregion
