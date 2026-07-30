FishAndChips.Fish{
	key = "fas_chimera",
	config = {
		extra = {
			scaling = 0.401,
			xmult = 0.4,
			rate = 3,
		},
		immutable = {
			fish = "fish_fac_flounder"
		}
	},
	weight = 10,
	ppu_coder = {"Foo54"},
	environments = {
		soup = 1,
		wormhole = 1,
		backroom = 1,
	},
	attributes = {"scaling", "food", "xmult", "destroy_card"},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS[card.ability.immutable.fish]
		return {vars = {localize{type = "name_text", key = card.ability.immutable.fish, set = "fac_Fish"}, card.ability.extra.rate, card.ability.extra.scaling, card.ability.extra.xmult}}
	end,
}