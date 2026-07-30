FishAndChips.Fish({
	key = "sg11_n_vekhi_soul_cannon",
	-- atlas = "fish",
	-- pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = {},
	config = {
		extra = {
			sacrifice = 2,
		},
	},
	weight = 3,
	environments = {
		styx = 75,
		aquifer = 25,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.sacrifice },
		}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and context.game_over
			and G.fac_fish_area
			and G.fac_fish_area.config.card_limits.base >= card.ability.extra.sacrifice
		then
			local target_amount = card.ability.extra.sacrifice
			local potential_cards = {}
			for _, c in ipairs(SMODS.shallow_copy(card.area.cards)) do
				if not (c == card or SMODS.is_eternal(c)) then
					table.insert(potential_cards, c)
				end
			end
			if #potential_cards >= target_amount then
				local cards_to_destory = {}
				while #cards_to_destory < target_amount do
					local loser = pseudorandom_element(potential_cards, "pac_soul_cannon_activation")
					if loser then
						table.insert(cards_to_destory, loser)
					else
						break
					end
				end
				if #cards_to_destory >= target_amount then
					return {
						saved = "k_pac_soul_cannon_trigger",
						func = function()
							SMODS.destroy_cards(cards_to_destory)
							G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base
								- target_amount
						end,
					}
				end
			end
		end
	end,
})
