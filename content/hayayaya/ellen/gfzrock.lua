FishAndChips.Fish({
	key = "gfzrock",
	weight = 4,
	environments = {
		backroom = 1,
		chocolate_river = 0.2,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Ellen (Haya)" },
	attributes = {},
	atlas = "hayayaya_fih",
	pos = { x = 1, y = 2 },
	stats = {
		length = { min = 1, max = 1 },
		weight = { min = 1, max = 1 },
	},
	pixel_size = { w = 64, h = 64 },
	badge_key = "k_fac_maybe_fish",
	config = { extra = { xmult = 5, dollar_req = 0 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.dollar_req },
		}
	end,
	calculate = function(self, card, context)
		if (G.GAME.dollars + (G.GAME.dollar_buffer or 0)) == card.ability.extra.dollar_req and context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})
