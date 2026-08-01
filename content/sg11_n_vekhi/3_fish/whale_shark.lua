SMODS.Atlas({
	key = "sg11_n_vekhi_whale_shark",
	path = "sg11_n_vekhi/whale_shark.png",
	px = 71 * 2,
	py = 95 * 2,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_whale_shark",
	atlas = "fac_sg11_n_vekhi_whale_shark",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = {},
	config = {
		extra = {
			xmult = 1,
			xmult_gain = 0.1,
		},
	},
	weight = 2,
	environments = {
		pier = 8,
		styx = 1,
	},
	display_size = {
		w = 71 * 1.75,
		h = 95 * 1.75,
	},
	-- pixel_size = {
	-- 	w = 71 * 2,
	-- 	h = 95 * 2,
	-- },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.destroying_card and context.cardarea == G.play and not context.blueprint then
			local id = context.destroying_card:get_id()
			if id == 2 or id == 3 or id == 4 or id == 5 then
				return {
					remove = true,
					func = function()
						G.E_MANAGER:add_event(Event({
							func = function()
								SMODS.scale_card(card, {
									ref_table = card.ability.extra,
									ref_value = "xmult",
									scalar_value = "xmult_gain",
									scaling_message = {
										message = localize("k_fac_nom_ex"),
										colour = G.C.FILTER,
									},
								})
								return true
							end,
						}))
					end,
				}
			end
		end
	end,
})
