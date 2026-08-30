SMODS.Atlas {
	key = 'bagels_hookworm',
	path = 'bagels/hookworm.png',
	px = 71,
	py = 95,
}

FishAndChips.Fish {
	key = 'bagels_hookworm',
	atlas = 'bagels_hookworm',
	ppu_coder = { 'BakersDozenBagels' },
	ppu_artist = { 'BakersDozenBagels' },
	weight = 15,
	environments = { wormhole = 1, calm_pond = 0.5, garden = 0.5, soup = 0.1 },
	stats = { weight = { min = 0.007, max = 0.03 }, length = { min = 0.05, max = 0.14 } },
	attributes = { 'passive', 'generation', 'booster' },
	config = {
		extra = {
			bait = 1,
		},
	},
	loc_vars = function(_, _, card)
		return { vars = { card.ability.extra.bait } }
	end,
	calculate = function(_, card, context)
		if context.open_booster then
			FishAndChips.create_baits_from_card(card, card.ability.extra.bait)
			return {
				message = localize 'k_fac_bagels_plus_bait',
				colour = mix_colours(G.C.RED, G.C.WHITE, 0.5),
			}
		end
	end,
}

if Balatest then
	local function assert_bait(bait)
		local a = 0
		for _, v in pairs(G.GAME.fac_bait_inventory) do
			a = a + v.amt
		end
		Balatest.assert_eq(a, bait, 'Expected ' .. bait .. ' total bait, got ' .. a, 3)
	end

	Balatest.TestPlay {
		name = 'bagels_hookworm',
		category = { 'bagels', 'bagels_hookworm' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_hookworm'
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.open(function()
				return G.shop_booster.cards[1]
			end)
		end,
		assert = function()
			assert_bait(4)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_hookworm_twice',
		category = { 'bagels', 'bagels_hookworm' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_hookworm'
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.open(function()
				return G.shop_booster.cards[1]
			end)
			Balatest.skip_booster()
			Balatest.open(function()
				return G.shop_booster.cards[1]
			end)
		end,
		assert = function()
			assert_bait(5)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_hookworm_double',
		category = { 'bagels', 'bagels_hookworm' },

		execute = function()
			FishAndChips.Balatest_obtain_fish { 'fish_fac_bagels_hookworm', 'fish_fac_bagels_hookworm' }
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.open(function()
				return G.shop_booster.cards[1]
			end)
		end,
		assert = function()
			assert_bait(4)
		end,
	}
end
