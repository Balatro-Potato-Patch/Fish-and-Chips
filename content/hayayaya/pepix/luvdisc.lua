FishAndChips.Fish({
	key = "luvdisc",
	weight = 6,
	environments = {
		garden = 1,
		soup = 0.4,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"xmult",
		"suit",
		"hearts",
		"reset",
		"scaling",
	},
	atlas = "hayayaya_fih",
	pos = { x = 0, y = 2 },
	config = { extra = { xmult = 1.0, xmult_add = 0.1 } },
	stats = {
		length = { min = 0.9, max = 1.6 },
		weight = { min = 8, max = 12 },
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_add,
				card.ability.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit("Hearts") then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "xmult",
					scalar_value = "xmult_add",
				})
			elseif card.ability.extra.xmult > 1 then
				card.ability.extra.xmult = 1
				return {
					message = localize("k_reset"),
				}
			end
		end

		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})
