FishAndChips.Fish {
	key = "csc_floundery",
	atlas = "csc_fish",
	pos = { x = 7, y = 10 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "passive" },
	config = {
		immutable = {
			slots = 1,
			diff = 0
		}
	},

	stats = {
		weight = {
			min = 0.5,
			max = 2.3
		},
		length = {
			min = 0.22,
			max = 0.60
		}
	},

    weight = 1,
	environments = {
		garden = 1,
		wormhole = 0.1
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.immutable.slots } }
	end,

	add_to_deck = function(self, card, from_debuff)
		card.ability.immutable.diff = G.jokers.config.card_limit - #G.jokers.cards
		
		G.fac_fish_area.config.card_limits.base = 10
	end,

	calculate = function(self, card, context)
		
	end,
}