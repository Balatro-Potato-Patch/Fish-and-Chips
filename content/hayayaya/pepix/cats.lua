local cats = { fac_fish_cat1 = true, fac_fish_cat2 = true, fac_fish_cat3 = true }

FishAndChips.Fish({
	key = "cat1",
	weight = 3,
	environments = {
		volcano = 0.55,
		soup = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"scaling",
		"chips",
		"reset",
	},
	badge_key = "k_fac_hayayaya_catfish",
	atlas = "hayayaya_fih",
	pos = { x = 3, y = 0 },
	stats = {
		length = { min = 1.5, max = 3 },
		weight = { min = 1, max = 1.4 },
	},
	config = { extra = { chips = 0, chips_add = 10, forme_counter = 0, forme_max = 3 } },
	in_pool = function(self, args)
		for _, c in ipairs(G.fac_fish_area.cards) do
			if cats[c.config.center_key] then
				return false
			end
		end
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_add,
				card.ability.extra.chips,
				card.ability.extra.forme_counter,
				card.ability.extra.forme_max,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "chips",
				scalar_value = "chips_add",
			})
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end

		if context.after then
			card.ability.extra.chips = 0
			return {
				message = localize("k_reset"),
			}
		end

		if context.end_of_round and context.main_eval and not context.game_over then
			card.ability.extra.forme_counter = card.ability.extra.forme_counter + 1
			if card.ability.extra.forme_counter >= card.ability.extra.forme_max then
				card.ability.extra.forme_counter = 0
				card:set_ability(G.P_CENTERS["fish_fac_cat2"], false, true)
				return {
					message = localize("ph_facyou_hayayaya_evolved"),
				}
			end
			return {
				message = string.format("%i/%i", card.ability.extra.forme_counter, card.ability.extra.forme_max),
			}
		end
	end,
})

FishAndChips.Fish({
	key = "cat2",
	weight = 3,
	environments = {
		volcano = 0.55,
		soup = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"scaling",
		"chips",
		"reset",
	},
	stats = {
		length = { min = 2, max = 4 },
		weight = { min = 2, max = 2.4 },
	},
	badge_key = "k_fac_hayayaya_catfish",
	atlas = "hayayaya_fih",
	pos = { x = 2, y = 0 },
	config = { extra = { chips = 0, chips_add = 10, forme_counter = 0, forme_max = 3 } },
	in_pool = function(self, args)
		for _, c in ipairs(G.fac_fish_area.cards) do
			if cats[c.config.center_key] then
				return false
			end
		end
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_add,
				card.ability.extra.chips,
				card.ability.extra.forme_counter,
				card.ability.extra.forme_max,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "chips",
				scalar_value = "chips_add",
			})
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end

		if context.end_of_round and context.main_eval and not context.game_over then
			card.ability.extra.chips = 0
			card.ability.extra.forme_counter = card.ability.extra.forme_counter + 1
			if card.ability.extra.forme_counter >= card.ability.extra.forme_max then
				card.ability.extra.forme_counter = 0
				card:set_ability(G.P_CENTERS["fish_fac_cat3"], false, true)
				return {
					message = localize("ph_facyou_hayayaya_evolved"),
				}
			end
			return {
				message = localize("k_reset"),
				extra = {
					message = string.format("%i/%i", card.ability.extra.forme_counter, card.ability.extra.forme_max),
				},
			}
		end
	end,
})

FishAndChips.Fish({
	key = "cat3",
	weight = 3,
	environments = {
		volcano = 0.1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"scaling",
		"xchips",
		"reset",
	},
	atlas = "hayayaya_fih",
	pos = { x = 4, y = 0 },
	stats = {
		length = { min = 3, max = 4 },
		weight = { min = 3, max = 6.4 },
	},
	badge_key = "k_fac_hayayaya_catfish",
	config = { extra = { xchips = 1, xchips_add = 0.05 } },
	in_pool = function(self, args)
		for _, c in ipairs(G.fac_fish_area.cards) do
			if cats[c.config.center_key] then
				return false
			end
		end
		return true
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xchips_add,
				card.ability.extra.xchips,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "xchips",
				scalar_value = "xchips_add",
			})
		end

		if context.joker_main then
			return {
				xchips = card.ability.extra.xchips,
			}
		end

		if context.ante_end then
			card.ability.extra.xchips = 1
			return {
				message = localize("k_reset"),
			}
		end
	end,
})
