SMODS.Atlas {
	key = 'bagels_a_for_effish',
	path = 'bagels/a_for_effish.png',
	px = 145,
	py = 156,
}
SMODS.Atlas {
	key = 'bagels_a_for_effish_extra',
	path = 'bagels/a_for_effish_extra.png',
	px = 145,
	py = 156,
}

SMODS.Sound {
	key = 'bagels_a_for_effish_a_1',
	path = 'bagels/a-for-effish-1.ogg',
}
SMODS.Sound {
	key = 'bagels_a_for_effish_a_2',
	path = 'bagels/a-for-effish-2.ogg',
}
SMODS.Sound {
	key = 'bagels_a_for_effish_a_3',
	path = 'bagels/a-for-effish-3.ogg',
}
SMODS.Sound {
	key = 'bagels_a_for_effish_a_4',
	path = 'bagels/a-for-effish-4.ogg',
}

function FishAndChips.handle_bagels_a_for_effish()
	if not next(SMODS.find_card 'fish_fac_bagels_a_for_effish') then
		return
	end

	local i = 1
	while i <= #G.hand.cards do
		local c = G.hand.cards[i]
		if c:get_id() == 14 then
			G.hand:remove_card(c)
			G.play:emplace(c)
			c.fac_bagels_a_for_effish = true
		else
			i = i + 1
		end
	end
end

FishAndChips.Fish {
	key = 'bagels_a_for_effish',
	atlas = 'bagels_a_for_effish',
	ppu_coder = { 'BakersDozenBagels' },
	ppu_artist = { 'BakersDozenBagels' },
	weight = 10,
	environments = { city_river = 1, aquifer = 1, chocolate_river = 0.5 },
	stats = { weight = { min = 0.09, max = 0.25 }, length = { min = 0.01, max = 0.14 } },
	attributes = { 'rank', 'passive' },
	flavour_vars = function()
		return {
			vars = { elements = { SMODS.create_sprite(0, 0, 0.2, 0.2 * 156 / 145, 'fac_bagels_a_for_effish_extra') } },
		}
	end,
	loc_vars = function()
		local el = {}
		for i = 1, 5 do
			el[i] = SMODS.create_sprite(0, 0, 0.2, 0.2 * 156 / 145, 'fac_bagels_a_for_effish_extra')
		end
		el[6] = SMODS.create_sprite(0, 0, 0.4, 0.4 * 156 / 145, 'fac_bagels_a_for_effish_extra')
		return { vars = { elements = el } }
	end,
	calculate = function(_, _, context)
		if context.modify_scoring_hand and context.other_card.fac_bagels_a_for_effish then
			return { add_to_hand = true }
		end
		if context.individual and context.other_card.fac_bagels_a_for_effish then
			context.other_card.fac_bagels_a_for_effish = nil
			return {
				message = localize 'k_fac_bagels_a',
				sound = 'fac_bagels_a_for_effish_a_' .. math.random(1, 4),
			}
		end
	end,
}

if Balatest then
	Balatest.TestPlay {
		name = 'bagels_a_for_effish_four',
		category = { 'bagels', 'bagels_a_for_effish' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_a_for_effish'
			Balatest.play_hand { '2' }
		end,
		assert = function()
			Balatest.assert_chips(7 + 44)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_a_for_effish_mult',
		category = { 'bagels', 'bagels_a_for_effish' },

		deck = {
			cards = { { r = '2', s = 'S', e = 'm_glass' }, { r = 'A', s = 'S', e = 'm_mult' }, { r = '3', s = 'S' } },
		},
		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_a_for_effish'
			Balatest.play_hand { 'm_glass' }
		end,
		assert = function()
			Balatest.assert_chips(18 * 6)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_a_for_effish_glass',
		category = { 'bagels', 'bagels_a_for_effish' },

		deck = {
			cards = { { r = '2', s = 'S', e = 'm_mult' }, { r = 'A', s = 'S', e = 'm_glass' }, { r = '2', s = 'S' } },
		},
		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_a_for_effish'
			Balatest.play_hand { 'm_mult' }
		end,
		assert = function()
			Balatest.assert_chips(18 * 10)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_a_for_effish_way_too_many',
		category = { 'bagels', 'bagels_a_for_effish' },

		deck = {
			cards = {
				{ r = '2', s = 'S' },
				{ r = '2', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
				{ r = 'A', s = 'S' },
			},
		},
		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_a_for_effish'
			Balatest.play_hand { '2' }
		end,
		assert = function()
			Balatest.assert_chips(117)
		end,
	}
end
