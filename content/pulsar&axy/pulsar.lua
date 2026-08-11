FishAndChips.Fish {
	key = "pa_pulsar",
	weight = 1,
	atlas = "pa_pulsarfish",
	pos = { x = 3, y = 3 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xchips", "xmult", "chips", "suit" },
	environments = {
		city_river = 1,
        wormhole = 0.2
	},
	stats = {
		length = {min = .312, max = .312},
		weight = {min = 140, max = 140}
	},
	blueprint_compat = true,
	config = {
		extra = {
			xchips = 1.5
		}
	},
	decision_min = 0.1,
	decision_max = 0.3,
	impulse_min = 0.8,
	impulse_max = 1.1,
	vel_limit = 0.79,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips } }
	end,
	flavour_vars = function(self, info_queue, card)
		return { vars = {
			elements = { SMODS.create_sprite(0, 0, 0.4, 0.4, "fac_pa_pulsarplead") }
		}}
	end,
	calculate = function(self, card, context)
        -- gives xchips for each club held in hand
        if context.individual and context.cardarea == G.hand and context.other_card:is_suit('Clubs') and not context.end_of_round then
            return {
                xchips = card.ability.extra.xchips
            }
        end
	end,
}