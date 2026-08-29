FishAndChips.Fish({
	key = "anglrifle",
	weight = 10,
	environments = {
		chocolate_river = 0.5,
		styx = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"destroy_card",
		"discard",
		"scaling",
		"chips",
	},
	perishable_compat = false,
	stats = {
		length = { min = 0.75, max = 1.3 },
		weight = { min = 0.5, max = 2 },
	},
	atlas = "hayayaya_fih",
	pos = { x = 3, y = 2 },
	config = { extra = { chips = 0, chips_add = 5 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_add,
				card.ability.extra.chips,
				card.ability.extra.done and localize("ph_facyou_hayayaya_inactive")
					or localize("ph_facyou_hayayaya_active"),
				ppu_bubbles = {
					card.ability.extra.done and "inactive" or "active",
				},
			},
		}
	end,
	calculate = function(self, card, context)
		if context.discard and G.GAME.current_round.discards_used <= 0 and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "chips",
				scalar_value = "chips_add",
			})
			return { remove = true }
		end

		if context.joker_main then
			return { chips = card.ability.extra.chips }
		end
	end,
})
