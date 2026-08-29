FishAndChips.Fish {
	key = "csc_sardinium",
	atlas = "csc_fish",
	pos = { x = 2, y = 1 },

	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },
	badge_key = "k_fac_maybe_fish",

	attributes = { "hand_level", "usable", "hand_type", },
	config = {
		extra = {
			levels = 1
		}
	},

	stats = {
		weight = {
			min = 0.365,
			max = 0.620
		},
		length = {
			min = 0.15,
			max = 0.23
		}
	},

    weight = 8,
	environments = {
		styx = 8,
		wormhole = 1
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.levels } }
	end,

	blueprint_compat = false,
	eternal_compat = false,
	treasure = true,
	requires_hand = true,

	can_use = function(self, card)
		return G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0
	end,

	use = function(self, card, area)
		SMODS.upgrade_poker_hands{hands = G.FUNCS.get_poker_hand_info(G.hand.highlighted), from = card}
	end
}
