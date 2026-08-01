FishAndChips.Fish {
	key = "tss_bee",
	atlas = "tss_azfish",
	pos = { x = 0, y = 0 },
	pixel_size = { w = 71/122*88, h = 95/122*71 },
    display_size = { w = 88*.8, h = 71*.8 },
	weight = 1,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "passive" },
	environments = {
		calm_pond = 7,
		garden = 10
	}
}

FishAndChips.Fish {
	key = "tss_watrena",
	atlas = "tss_ellefish",
	pos = { x = 0, y = 0 },
	weight = 3,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "mult", "suit" },
	environments = {
		city_river = 10
	},
	config = { extra = { mult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") then
			fish:set_edition(poll_edition('fac_tss_watrena', nil, true, true))
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
		end
	end
}

FishAndChips.Fish {
	key = "tss_ferish",
	atlas = "tss_azfish",
	pos = { x = 1, y = 0 },
	pixel_size = { w = 71/122*98, h = 95/122*100 },
    display_size = { w = 98*.75, h = 100*.75 },
	weight = 3,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "mult", "suit" },
	environments = {
		city_river = 10
	},
	config = { extra = { mult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") then
			context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) +
				card.ability.extra.mult
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
		end
	end
}