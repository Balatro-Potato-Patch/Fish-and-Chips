SMODS.Atlas({
	key = "sg11_n_vekhi_diamond_fish",
	path = "sg11_n_vekhi/diamond_fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish({
	key = "sg11_n_vekhi_diamond_fish",
	atlas = "fac_sg11_n_vekhi_diamond_fish",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = {},
	config = {
		extra = {
			dollars = 5,
		},
	},
	weight = 4,
	stats = {
		weight = { min = 1, max = 1 },
		length = { min = 1, max = 1 },
	},
	environments = {
		volcano = 5,
		aquifer = 5,
		calm_pond = 2,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		return {
			vars = { card.ability.extra.dollars },
		}
	end,
	calculate = function(self, card, context)
		if context.after then
			local shattered_count = 0
			local survived_count = 0
			for k, v in pairs(context.scoring_hand) do
				if SMODS.has_enhancement(v, "m_glass") then
					if v.shattered then
						shattered_count = shattered_count + 1
					else
						survived_count = survived_count + 1
					end
				end
			end
			if survived_count > 0 then
				return {
					dollars = card.ability.extra.dollars,
				}
			end
		end
	end,
})
