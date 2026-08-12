FishAndChips.Fish({
	key = "boot",
	weight = 10,
	environments = {
		city_river = 1,
		pier = 0.75,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"discard",
		"scaling",
		"mult",
	},
	stats = {
		length = { min = 0.4, max = 0.4 },
		weight = { min = 0.2, max = 0.2 },
	},
	atlas = "hayayaya_fih",
	pos = { x = 4, y = 1 },
	pixel_size = { w = 71, h = 76 },
	badge_key = "k_fac_hayayaya_object",
	config = { extra = { mult = 0, mult_add = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_add,
				card.ability.extra.mult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.discard then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "mult",
				scalar_value = "mult_add",
			})
		end

		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
			}
		end
	end,
})
