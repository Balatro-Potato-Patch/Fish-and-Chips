--#region Fish

FishAndChips.Fish {
	key = "cod",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = { "Mack" },
	ppu_artist = { "GhostSalt" },
	attributes = { "chips" },
	config = {
		extra = {
			chips = 30
		}
	},
	environments = {
		pier = 10,
		city_river = 2.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { chips = card.ability.extra.chips } end
	end,
}

--#endregion