PotatoPatchUtils.Developer({
	name = 'FireIce',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.PURPLE,
	fac_partner = 'Willow',
    team = 'ViolentViolets',
	calculate = function(self, context)
		if context.end_of_round and context.main_eval then
			for k, v in ipairs(G.fac_fish_area.cards) do
				SMODS.debuff_card(v, false, 'sunlight')
				return {
					message = "Awake!",
					colour = G.C.ATTENTION
				}
			end
        end
	end
})
PotatoPatchUtils.Developer({
	name = 'Willow',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'FireIce',
    team = 'ViolentViolets'
})