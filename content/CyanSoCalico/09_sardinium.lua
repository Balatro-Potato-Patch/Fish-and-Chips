FishAndChips.Fish {
	key = "csc_sardinium",
	atlas = "csc_fish",
	pos = { x = 7, y = 2 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "hand_level", "usable" },

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
	
	treasure = true,
	requires_hand = true,

	can_use = function(self, card)
		return G and G.hand and G.hand.highlighted and #G.hand.highlighted > 0
	end,

	use = function(self, card, area)
		SMODS.upgrade_poker_hands{hands = G.FUNCS.get_poker_hand_info(G.hand.highlighted), from = card}
	end
}