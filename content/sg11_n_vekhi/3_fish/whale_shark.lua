SMODS.Atlas({
	key = "sg11_n_vekhi_whale_shark",
	path = "sg11_n_vekhi/nautilus.png",
	px = 71,
	py = 95,
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
	weight = 10,
	environments = {
		pier = 4,
	},
	display_size = {
		w = 71 * 1.5,
		h = 95 * 1.5,
	},
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
									message_key = "k_fac_nom_ex",
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
