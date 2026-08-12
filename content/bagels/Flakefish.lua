SMODS.Atlas {
	key = 'bagels_flakefish',
	path = 'bagels/flakefish.png',
	px = 118,
	py = 118,
}

FishAndChips.Fish {
	key = 'bagels_flakefish',
	atlas = 'bagels_flakefish',
	display_size = { w = 71 * 1.33, h = 71 * 1.33 },
	ppu_coder = { 'BakersDozenBagels' },
	ppu_artist = { 'BakersDozenBagels' },
	weight = 15,
	environments = { backroom = 0.7, styx = 1 },
	stats = { weight = { min = 0.006, max = 0.001 }, length = { min = 0.01, max = 0.03 } },
	attributes = { 'xmult' },
	config = {
		extra = {
			xmult = 2,
			last_mult = 0,
		},
	},
	loc_vars = function(_, _, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.last_mult } }
	end,
	calculate = function(_, card, context)
		if context.joker_main then
			if mult > card.ability.extra.last_mult then
				if not context.blueprint then
					card.ability.extra.last_mult = mult
				end
				return {
					xmult = card.ability.extra.xmult,
				}
			else
				if not context.blueprint then
					card.ability.extra.last_mult = 0
				end
				return {
					xmult = 0,
				}
			end
		end
	end,
}

if Balatest then
	Balatest.TestPlay {
		name = 'bagels_flakefish_initial',
		category = { 'bagels', 'bagels_flakefish' },

		execute = function()
			Balatest.play_hand { '2', '2', '2', '2' }
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_flakefish'
			Balatest.play_hand { '2' }
		end,
		assert = function()
			Balatest.assert_chips(7 * 2)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_flakefish_shrank',
		category = { 'bagels', 'bagels_flakefish' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_flakefish'
			Balatest.play_hand { '2', '2', '2', '2' }
			Balatest.next_round()
			Balatest.play_hand { '2' }
		end,
		assert = function()
			Balatest.assert_chips(0)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_flakefish_grew',
		category = { 'bagels', 'bagels_flakefish' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_flakefish'
			Balatest.play_hand { '2' }
			Balatest.next_round()
			Balatest.play_hand { '2', '2', '2', '2' }
		end,
		assert = function()
			Balatest.assert_chips(68 * 14)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_flakefish_shrank_twice',
		category = { 'bagels', 'bagels_flakefish' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_flakefish'
			Balatest.play_hand { '2', '2', '2', '2' }
			Balatest.next_round()
			Balatest.play_hand { '2', '2' }
			Balatest.play_hand { '2' }
		end,
		assert = function()
			Balatest.assert_chips(7 * 2)
		end,
	}
end
