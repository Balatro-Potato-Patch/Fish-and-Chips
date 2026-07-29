PotatoPatchUtils.Developer({
	name = "Ben",
	atlas = "fac_bencredits",
	colour = G.C.CHIPS,
	ignore_limits = false,
	soul_pos = { x = 0, y = 1 }
})

SMODS.Atlas({
	key = "bencredits",
	path = "ben/credits.png",
	px = 71,
	py = 95,
})

--Fish

SMODS.Atlas({
	key = "benfish",
	path = "ben/fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "cassius",
	atlas = "fac_benfish",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "Ben" },
	ppu_artist = { "Ben" },
	attributes = { "chips" },
	config = {
		extra = {
			chips = 30
		}
	},
	environments = {
		calm_pond = 0,
		city_river = 0,
		swamp = 0,
		volcano = 0,
		aquifer = 0,
		styx = 0,
		chocolate_river = 0,
		pier = 0,
		soup = 0,
		garden = 0,
		wormhole = 0,
		backroom = 0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then 
			return { 
				chips = card.ability.extra.chips 
			}
		end
	end,
}