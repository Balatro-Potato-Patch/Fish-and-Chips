FishAndChips.Fish{
	key = "fas_luka",
	weight = 5,
	ppu_coder = {"Foo54"},
	stats = {
		length = {min = 2.54 * 12 / 100, max = 2.54 * 14 / 100},
		weight = {min = 0.001, max = 50}
	},
	environments = {
		pier = 1
	},
	config = {
		extra = {
			num = 1,
			dem = 3
		}
	},
	disable_visual_scaling = true,
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "fac_fas_luka")
		return {vars = {num, dem}}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.individual and context.cardarea == G.hand then
			if context.other_card:get_id() == 8 then
				if SMODS.pseudorandom_probability(card, "fac_fas_luka", card.ability.extra.num, card.ability.extra.dem) then
					return {
						message_card = context.other_card,
						message = "+1 Bait",
						func = function ()
							G.E_MANAGER:add_event(Event{
								func = function()
									FishAndChips.add_bait_to_inventory(SMODS.poll_object{type = "fac_Bait"})
									return true
								end
							})
							return true
						end
					}
				end
			end
		end
	end,
}