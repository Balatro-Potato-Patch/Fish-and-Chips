FishAndChips.Fish {
	key = "pa_videogame",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 5, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xmult" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	stats = {
		length = { min = 0.0120, max = 0.0120},  --based on ordinary cd
		weight = { min = 0.02, max = 0.02}
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