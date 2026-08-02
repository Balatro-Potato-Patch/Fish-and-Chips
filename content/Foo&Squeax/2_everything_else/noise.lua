
FishAndChips.Fish {
	key = "fas_super_bo_noise",
	weight = 5,
	environments = {
		aquifer = 1,
		wormhole = 0.5,
	},
	ppu_coder = {"Foo54"},
	config = {
		extra = {
			xmult = 0.01
		}
	},
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	attributes = {"modify_card", "xmult"},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			context.other_card.ability.perma_x_mult = (context.other_card.ability.perma_x_mult or 0) + card.ability.extra.xmult
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
		end
	end
}