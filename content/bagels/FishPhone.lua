SMODS.Atlas {
	key = 'bagels_fish_phone',
	path = 'bagels/fish_phone.png',
	px = 71,
	py = 95,
}

SMODS.Sound {
	key = 'bagels_phone_add',
	path = 'bagels/phone-add.ogg',
}
SMODS.Sound {
	key = 'bagels_phone_remove',
	path = 'bagels/phone-remove.ogg',
}

FishAndChips.Fish {
	key = 'bagels_fish_phone',
	atlas = 'bagels_fish_phone',
	ppu_coder = { 'BakersDozenBagels', 'Emik' },
	ppu_artist = { 'Emik' },
	weight = 10,
	environments = { backroom = 1, pier = 1 },
	stats = { weight = { min = 0.9, max = 1.4 }, length = { min = 0.18, max = 0.3 } },
	attributes = { 'passive', 'destroy_card' },
	blueprint_compat = false,
	config = { extra = { slots = 4 } },
	loc_vars = function(_, _, card)
		return {
			vars = {
				card.ability.extra.slots,
			},
		}
	end,
	add_to_deck = function(_, card)
		play_sound 'fac_bagels_phone_add'
		G.E_MANAGER:add_event(Event {
			func = function()
				change_shop_size(card.ability.extra.slots)
				return true
			end,
		})
	end,
	remove_from_deck = function(_, card)
		play_sound 'fac_bagels_phone_remove'
		G.E_MANAGER:add_event(Event {
			func = function()
				change_shop_size(-card.ability.extra.slots)
				return true
			end,
		})
	end,
	calculate = function(_, _, context)
		if context.reroll_shop and not context.blueprint then
			local cards = {}
			for _, v in ipairs(G.jokers.cards) do
				cards[#cards + 1] = v
			end
			for _, v in ipairs(G.fac_fish_area.cards) do
				cards[#cards + 1] = v
			end
			local gone = pseudorandom_element(cards, 'fac_fish_bagels_fish_phone')
			play_sound 'fac_bagels_phone_remove'
			SMODS.destroy_cards { gone }
		end
	end,
}

if Balatest then
	Balatest.TestPlay {
		name = 'bagels_fish_phone_caught',
		category = { 'bagels', 'bagels_fish_phone' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_fish_phone'
			Balatest.end_round()
			Balatest.cash_out()
		end,
		assert = function()
			Balatest.assert_eq(#G.shop_jokers.cards, 6)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_fish_phone_sold',
		category = { 'bagels', 'bagels_fish_phone' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_fish_phone'
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.sell(function()
				return G.fac_fish_area.cards[1]
			end)
		end,
		assert = function()
			Balatest.assert_eq(#G.shop_jokers.cards, 2)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_fish_phone_reroll_joker',
		category = { 'bagels', 'bagels_fish_phone' },

		jokers = { 'j_joker' },
		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_fish_phone'
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.hook(_G, 'pseudorandom_element', function(orig, t, key, ...)
				if key == 'fac_fish_bagels_fish_phone' then
					return t[1]
				end
				return orig(t, key, ...)
			end)
			Balatest.reroll_shop()
		end,
		assert = function()
			Balatest.assert_eq(#G.jokers.cards, 0)
			Balatest.assert_eq(#G.fac_fish_area.cards, 1)
			Balatest.assert_eq(#G.shop_jokers.cards, 6)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_fish_phone_reroll_fish',
		category = { 'bagels', 'bagels_fish_phone' },

		jokers = { 'j_joker' },
		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_fish_phone'
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.hook(_G, 'pseudorandom_element', function(orig, t, key, ...)
				if key == 'fac_fish_bagels_fish_phone' then
					return t[2]
				end
				return orig(t, key, ...)
			end)
			Balatest.reroll_shop()
		end,
		assert = function()
			Balatest.assert_eq(#G.jokers.cards, 1)
			Balatest.assert_eq(#G.fac_fish_area.cards, 0)
			Balatest.assert_eq(#G.shop_jokers.cards, 2)
		end,
	}
end
