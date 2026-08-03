SMODS.Atlas({
	key = "sg11_n_vekhi_yellowbin_tuna",
	path = "sg11_n_vekhi/yellowbin_tuna.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_yellowbin_tuna",
	atlas = "fac_sg11_n_vekhi_yellowbin_tuna",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = { "generation" },
	config = {
		extra = {
			history_size = 5,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { self.config.extra.history_size },
		}
	end,
	weight = 10,
	stats = {
		weight = { min = 1, max = 10 },
		length = { min = 1.2, max = 1.3 },
	},
	environments = {
		backroom = 3,
		city_river = 2,
	},
	calculate = function(self, card, context)
		if
			context.fac_end_fishing
			and not context.failed
			and context.treasure
			and #(G.GAME.fac_yellowbin_sold_centers or {}) > 0
		then
			G.E_MANAGER:add_event(Event({
				func = function()
					-- intented to check center's config, dont want to deal with value manip
					local min_index =
						math.max(1, #G.GAME.fac_yellowbin_sold_centers - self.config.extra.history_size + 1)
					local max_index = #G.GAME.fac_yellowbin_sold_centers

					local indexes_array = {}
					for i = min_index, max_index do
						table.insert(indexes_array, {
							index = i,
							center_key = G.GAME.fac_yellowbin_sold_centers[i],
						})
					end
					pseudoshuffle(indexes_array, "fac_yellowbin_tuna")

					while #indexes_array > 0 do
						local item = table.remove(indexes_array, 1)
						local target_center = G.P_CENTERS[item.center_key or ""]
						if target_center then
							local center_area = FishAndChips.get_area_for_center(target_center)
							if #center_area.cards < center_area.config.card_limit then
								SMODS.add_card({ key = target_center.key, area = center_area })
								table.remove(G.GAME.fac_yellowbin_sold_centers, item.index)
								SMODS.calculate_effect({ message = localize("k_fac_recycle_ex") }, card)
								return true
							end
						end
					end
					SMODS.calculate_effect({ message = localize("k_nope_ex"), colour = G.C.RED }, card)
					return true
				end,
			}))
		end
	end,
})
