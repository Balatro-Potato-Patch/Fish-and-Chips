FishAndChips.Fish({
	key = "inferno",
	weight = 5,
	environments = {
		aquifer = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"chance",
	},
	atlas = "hayayaya_fih",
	pos = { x = 1, y = 1 },
	config = { extra = { num = 1, den = 4 } },
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
		if context.fac_end_fishing and not context.failed and not context.perfect then
			local bait = G.GAME.fac_active_bait
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
						FishAndChips.add_bait_to_inventory(bait, 1)
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
