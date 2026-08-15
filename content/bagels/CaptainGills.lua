SMODS.Atlas {
	key = 'bagels_captain_gills',
	path = 'bagels/captain_gills.png',
	px = 71,
	py = 95,
}

FishAndChips.Fish {
	key = 'bagels_captain_gills',
	atlas = 'bagels_captain_gills',
	ppu_coder = { 'BakersDozenBagels' },
	ppu_artist = { 'BakersDozenBagels' },
	weight = 10,
	environments = { wormhole = 1, volcano = 0.5 },
	stats = { weight = { min = 0.3, max = 20 }, length = { min = 0.05, max = 1.2 } },
	attributes = { 'generation', 'joker' },
	blueprint_compat = false,
	eternal_compat = false,
	loc_vars = function(_, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		info_queue[#info_queue + 1] = G.P_CENTERS.j_space
		return {
			vars = {
				localize { type = 'name_text', key = 'city_river', set = 'fac_Env' },
				localize { type = 'name_text', key = 'e_negative', set = 'Edition' },
				localize { type = 'name_text', key = 'j_space', set = 'Joker' },
			},
		}
	end,
	button_key = 'k_fac_bagels_release',
	can_use = function()
		return FishAndChips.get_environment().key == 'city_river'
	end,
	use = function(_, card)
		G.E_MANAGER:add_event(Event {
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound 'timpani'
				SMODS.add_card { key = 'j_space', edition = 'e_negative' }
				card:juice_up(0.3, 0.5)
				return true
			end,
		})
		delay(0.6)
	end,
}

if Balatest then
	Balatest.TestPlay {
		name = 'bagels_captain_gills_calm_pond',
		category = { 'bagels', 'bagels_captain_gills' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_captain_gills'
		end,
		assert = function()
			Balatest.assert(not G.P_CENTERS.fish_fac_bagels_captain_gills:can_use(G.fac_fish_area.cards[1]))
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_captain_gills_quest_finished',
		category = { 'bagels', 'bagels_captain_gills' },

		execute = function()
			Balatest.end_round()
			Balatest.cash_out()
			FishAndChips.Balatest_go_fishing()
			FishAndChips.Balatest_catch_fish { fish = 'fish_fac_bagels_captain_gills' }
			FishAndChips.Balatest_reroll_environment 'city_river'
		end,
		assert = function()
			Balatest.assert(G.P_CENTERS.fish_fac_bagels_captain_gills:can_use(G.fac_fish_area.cards[1]))
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_captain_gills_used',
		category = { 'bagels', 'bagels_captain_gills' },

		execute = function()
			Balatest.end_round()
			Balatest.cash_out()
			FishAndChips.Balatest_go_fishing()
			FishAndChips.Balatest_catch_fish { fish = 'fish_fac_bagels_captain_gills' }
			FishAndChips.Balatest_reroll_environment 'city_river'
			Balatest.use(function()
				return G.fac_fish_area.cards[1]
			end)
			Balatest.wait()
		end,
		assert = function()
			Balatest.assert_eq(#G.fac_fish_area.cards, 0)
			Balatest.assert_eq(#G.jokers.cards, 1)
			Balatest.assert_eq(G.jokers.cards[1].config.center.key, 'j_space')
			Balatest.assert_eq(G.jokers.cards[1].edition.key, 'e_negative')
		end,
	}
end
