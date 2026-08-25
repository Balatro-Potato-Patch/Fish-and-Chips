FishAndChips.Fish({
	key = "inferno",
	weight = 5,
	environments = {
		aquifer = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"chance", "generation", "fac_perfect_catch",
	},
	blueprint_compat = false,
	atlas = "hayayaya_fih",
	pos = { x = 1, y = 1 },
	config = { extra = { num = 1, den = 4, active_bait = nil } },
	stats = {
		length = { min = 1, max = 1 },
		weight = { min = 1, max = 1 },
	},
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "fac_inferno")
		return {
			vars = {
				num,
				den,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.fac_cast_rod and not context.blueprint then
			card.ability.extra.active_bait = G.GAME.fac_active_bait
		end
		if context.fac_end_fishing and not context.failed and card.ability.extra.active_bait and not context.blueprint then
			if
				SMODS.pseudorandom_probability(
					card,
					"fac_inferno_chance_" .. G.GAME.round_resets.ante,
					card.ability.extra.num,
					card.ability.extra.den,
					"fac_inferno"
				)
			then
				G.E_MANAGER:add_event(Event({
					func = function()
						-- Get rid of active bait when we dont need to
						if G.GAME.fac_active_bait and G.STATE ~= G.STATES.FAC_FISHING then
							G.GAME.fac_active_bait = nil
						end
						FishAndChips.add_bait_to_inventory(card.ability.extra.active_bait, 1)
						card.ability.extra.active_bait = nil
						SMODS.calculate_effect(
							{ message = localize("ph_facyou_hayayaya_returned"), instant = true },
							card
						)
						return true
					end,
				}))
			end
		end
	end,
})
