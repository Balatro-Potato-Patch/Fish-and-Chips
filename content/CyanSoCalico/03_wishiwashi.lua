FishAndChips.Fish {
	key = "csc_wishiwashi",
	atlas = "csc_fish",
	pos = { x = 2, y = 0 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "xmult" },
	config = {
		extra = {
			xmult = 1.1
		}
	},

	stats = {
		weight = {
			min = 0.192,
			max = 0.432
		},
		length = {
			min = 0.16,
			max = 0.24
		}
	},

    weight = 10,
	environments = {
		pier = 10,
		wormhole = 1
	},

	loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.xmult,
            G and G.fac_fish_area and G.fac_fish_area.cards and card.ability.extra.xmult^#G.fac_fish_area.cards or card.ability.extra.xmult
        } }
	end,

	calculate = function(self, card, context)
        if context.joker_main then
            return {
			-- Yes this is supposed to be an exponent. It's supposed to be 1.1^n, not 1+n0.1. It is in fact supposed to multiply X1.1 once per Fish owned
                xmult = card.ability.extra.xmult^#G.fac_fish_area.cards,
				card = context.blueprint and context.blueprint_card or card
            }
        end
	end,
}