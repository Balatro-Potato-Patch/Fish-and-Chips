SMODS.Atlas({
	key = "hayayaya_babel",
	path = "hayayaya/babel.png",
	px = 80,
	py = 80,
})

FishAndChips.Fish({
	key = "tower",
	weight = 5,
	environments = {
		garden = 0.6,
		chocolate_river = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = { "xmult", "suit", },
	atlas = "hayayaya_babel",
	pos = { x = 0, y = 0 },
	stats = {
		length = { min = 1, max = 1 },
		weight = { min = 1, max = 1 },
	},
	pixel_size = { w = 80, h = 80 },
	display_size = { w = 80, h = 80 },
	badge_key = "k_fac_hayayaya_object",
	config = { extra = { xmult = 1 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local xmult = 0
			local suits = {}
			for _, c in ipairs(context.scoring_hand) do
				-- Cards with any suit qualify for this as well
				if (not suits[c.base.suit]) or SMODS.has_any_suit(c) then
					xmult = xmult + 1
					suits[c.base.suit] = true
				end
			end
			return {
				xmult = math.max(1, xmult),
			}
		end
	end,
})
