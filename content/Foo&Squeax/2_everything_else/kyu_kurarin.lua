FishAndChips.Fish{
	key = "fas_kyu_kurafin",
	weight = 5,
	environments = {
		calm_pond = 0.5,
		city_river = 0.5,
		garden = 1,
		styx = 0.1
	},
	ppu_coder = {"Foo54"},
	config = {
		extra = {
			chips = 0,
			gain = 7
		}
	},
	attributes = {"chips"},
	loc_vars = function(self, info_queue, card)
---@diagnostic disable-next-line: undefined-global
		if SynthB then SynthB.song_info(info_queue, card, "kyu_kurarin") end
		return {vars = {card.ability.extra.gain, card.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
		if context.fac_end_fishing then
			local retrigger = nil
			if context.missed_treasure then
				retrigger = true
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "chips",
					scalar_value = "gain"
				})
			end
			if context.failed then
				retrigger = true
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "chips",
					scalar_value = "gain"
				})
			end
			return nil, retrigger
		end
	end,
}