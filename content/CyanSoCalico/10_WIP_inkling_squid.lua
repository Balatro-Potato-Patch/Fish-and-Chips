FishAndChips.Fish {
	key = "csc_inkling_squid",
	atlas = "csc_fish",
	pos = { x = 3, y = 15 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "chips" },
	config = {
		extra = {
			chips_mod = 10,
            chips = 0,
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
		return { vars = { card.ability.extra.chips_mod, card.ability.extra.hands[1], card.ability.extra.hands[2], card.ability.extra.chips } }
	end,

	calculate = function(self, card, context)
		if context.before and context.poker_hands and next(context.poker_hands) then
			for _, hand in pairs(card.ability.extra.hands) do
				if next(context.poker_hands[hand]) then
					return {
						message = card.ability.extra.chips ~= 0 and localize("k_reset"),
						func = function()
							card.ability.extra.chips = 0
						end
					}
				end
			end
			return {
				func = function()
					SMODS.scale_card(card, {
						ref_value = "chips",
						scalar_value = "chips_mod",
						message_colour = G.C.CHIPS
					})
				end
			}
		end
		if context.joker_main and card.ability.extra.chips ~= 0 then
			return {
				chips = card.ability.extra.chips
			}
		end
	end,
}