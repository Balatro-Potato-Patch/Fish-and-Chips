FishAndChips.Fish {
	key = "csc_inkling_squid",
	atlas = "csc_fish",
	pos = { x = 3, y = 15 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "mult" },
	config = {
		extra = {
			mult = 10,
            hands = {
                "Straight",
                "Flush"
            }
		}
	},

	stats = {
		weight = {
			min = 14,
			max = 26
		},
		length = {
			min = 1.2,
			max = 1.6
		}
	},

    weight = 10,
	environments = {
		backroom = 10,
        city_river = 4,
		wormhole = 1
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.hands[1], card.ability.extra.hands[2] } }
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			for _, hand in pairs(card.ability.extra.hands) do
				if next(context.poker_hands[hand]) then
					return
				end
			end
			return {
				mult = card.ability.extra.mult,
				card = context.blueprint and context.blueprint_card or card
			}
		end
	end,
}