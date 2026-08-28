FishAndChips.Fish {
	key = "csc_luvdisc",
	atlas = "csc_fish",
	pos = { x = 1, y = 1 },
	badge_key = "k_fac_csc_pokemon",

	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "face", "hand_type", "generation", "consumable", "tarot", },
	config = {
		extra = {
			hand = "Pair",
			card = "c_lovers"
		}
	},

	stats = {
		weight = {
			min = 5.568,
			max = 12.528
		},
		length = {
			min = 0.48,
			max = 0.72
		}
	},

    weight = 10,
	environments = {
		pier = 10,
		city_river = 1,
		wormhole = 1
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.card]
		return { vars = {
			localize( card.ability.extra.hand, "poker_hands" ),
			localize{ type = 'name_text', key = card.ability.extra.card, set = G.P_CENTERS[card.ability.extra.card].set }
		} }
	end,

	calculate = function(self, card, context)
		if context.joker_main and context.scoring_name == card.ability.extra.hand and #G.consumeables.cards + (G.GAME.consumeable_buffer or 0) < G.consumeables.config.card_limit then
			local anynonface = false
			for k, v in pairs(context.poker_hands[card.ability.extra.hand][1]) do
				if not v:is_face() then
					anynonface = true
				end
			end
			if not anynonface then
				G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
				return {
					message = localize("k_plus_tarot"),
					colour = G.C.PURPLE,
					func = function()
						G.E_MANAGER:add_event(Event({func = function()
							SMODS.add_card{ key = card.ability.extra.card }
							G.GAME.consumeable_buffer = 0
							return true
						end }))
					end,
					card = context.blueprint and context.blueprint_card or card
				}
			end
		end
	end,
}
