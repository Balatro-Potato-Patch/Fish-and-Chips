FishAndChips.Fish{
	key = "fas_kawkaw",
	weight = 10,
	environments = {
		calm_pond = 1,
		garden = 0.75
	},
	ppu_coder = {"Foo54"},
	config = {
		extra = {
			xmult = 5,
			call = 0.5
		},
		immutable = {
			timer = 20,
			limit = 100
		}
	},
	attributes = {"xmult"},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.xmult, card.ability.extra.call}}
	end,
}