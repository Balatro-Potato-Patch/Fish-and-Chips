SMODS.Atlas {
	key = 'bagels_european_perch',
	path = 'bagels/european_perch.png',
	px = 64,
	py = 55,
}

FishAndChips.Fish {
	key = 'bagels_european_perch',
	atlas = 'bagels_european_perch',
	soul_pos = { x = 1, y = 0 },
	display_size = { w = 64 * 1.33, h = 55 * 1.33 },
	ppu_coder = { 'BakersDozenBagels' },
	ppu_artist = { 'BakersDozenBagels' },
	weight = 10,
	environments = { swamp = 1, aquifer = 0.8, city_river = 0.1 },
	stats = { weight = { min = 1.7, max = 2.9 }, length = { min = 0.2, max = 0.6 } },
	attributes = { 'passive', 'boss_blind' },
	blueprint_compat = false,
	cost = 8,
	config = {
		extra = {
			skips = 1,
		},
	},
	loc_vars = function(_, _, card)
		return { vars = { card.ability.extra.skips } }
	end,
}

local raw_G_FUNCS_skip_blind = G.FUNCS.skip_blind
function G.FUNCS.skip_blind(e, ...)
	if G.GAME.blind_on_deck ~= 'Boss' then
		return raw_G_FUNCS_skip_blind(e, ...)
	end

	stop_use()
	G.CONTROLLER.locks.skip_blind = true
	G.E_MANAGER:add_event(Event {
		no_delete = true,
		trigger = 'after',
		blocking = false,
		blockable = false,
		delay = 2.5,
		timer = 'TOTAL',
		func = function()
			G.CONTROLLER.locks.skip_blind = nil
			return true
		end,
	})
	local _tag = e.UIBox:get_UIE_by_ID 'tag_container'
	G.GAME.skips = (G.GAME.skips or 0) + 1
	add_tag(_tag.config.ref_table)
	play_sound 'generic1'

	if not G.GAME.won and G.GAME.round_resets.ante >= G.GAME.win_ante then
		G.GAME.won = true
		if not G.GAME.win_notified then
			G.GAME.win_notified = true
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				blocking = false,
				blockable = false,
				func = function()
					win_game()
					G.GAME.won = true
					return true
				end,
			})
		end
	end

	G.GAME.voucher_restock = nil
	for _, v in pairs(G.GAME.hands) do
		v.played_this_ante = 0
	end
	if G.GAME.modifiers.set_eternal_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_eternal_ante) then
		for _, v in ipairs(G.jokers.cards) do
			v:set_eternal(true)
		end
	end
	if
		G.GAME.modifiers.set_joker_slots_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_joker_slots_ante)
	then
		G.jokers.config.card_limit = 0
	end
	delay(0.4)
	SMODS.ante_end = true
	ease_ante(1)
	SMODS.ante_end = nil
	delay(0.4)
	check_for_unlock { type = 'ante_up', ante = G.GAME.round_resets.ante + 1 }
	G.E_MANAGER:add_event(Event {
		trigger = 'before',
		delay = 0.3,
		func = function()
			G.GAME.current_round.voucher = SMODS.get_next_vouchers()
			for _, v in ipairs(G.playing_cards) do
				v.ability.played_this_ante = nil
				v.ability.discarded = nil
				v.ability.forced_selection = nil
			end
			G.blind_select.alignment.offset.y = G.ROOM.T.y + 36
			return true
		end,
	})

	G.E_MANAGER:add_event(Event {
		trigger = 'after',
		delay = 0.3,
		func = function()
			G.GAME.round_resets.blind_ante = G.GAME.round_resets.ante
			G.GAME.round_resets.blind_tags.Small = get_next_tag_key()
			G.GAME.round_resets.blind_tags.Big = get_next_tag_key()
			G.GAME.round_resets.blind_tags.Boss = get_next_tag_key()
			G.GAME.round_resets.blind_states.Boss = 'Defeated'
			reset_blinds()

			G.blind_select:remove()
			local old_prompt = G.blind_prompt_box
			G.blind_select = UIBox {
				definition = create_UIBox_blind_select(),
				config = { align = 'bmi', offset = { x = 0, y = G.ROOM.T.y + 36 }, major = G.hand, bond = 'Weak' },
			}
			G.blind_prompt_box:remove()
			G.blind_prompt_box = old_prompt
			G.blind_select.alignment.offset.y = 0.8 - (G.hand.T.y - G.jokers.T.y) + G.blind_select.T.h
			G.ROOM.jiggle = G.ROOM.jiggle + 3
			G.blind_select.alignment.offset.x = 0
			return true
		end,
	})

	G.E_MANAGER:add_event(Event {
		trigger = 'immediate',
		func = function()
			delay(0.3)
			SMODS.calculate_context { skip_blind = true }
			save_run()
			for i = 1, #G.GAME.tags do
				G.GAME.tags[i]:apply_to_run { type = 'immediate' }
			end
			for i = 1, #G.GAME.tags do
				if G.GAME.tags[i]:apply_to_run { type = 'new_blind_choice' } then
					break
				end
			end
			return true
		end,
	})

	local _, perch = next(SMODS.find_card 'fish_fac_bagels_european_perch')
	if
		type(perch) == 'table'
		and type(perch.ability) == 'table'
		and type(perch.ability.extra) == 'table'
		and type(perch.ability.extra.skips) == 'number'
	then
		perch.ability.extra.skips = perch.ability.extra.skips - 1
		if perch.ability.extra.skips <= 0 then
			perch:start_dissolve()
		end
	end
end

if Balatest then
	Balatest.TestPlay {
		name = 'bagels_european_perch_used',
		category = { 'bagels', 'bagels_european_perch' },

		execute = function()
			FishAndChips.Balatest_obtain_fish 'fish_fac_bagels_european_perch'
			Balatest.end_round()
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.exit_shop()
			Balatest.skip_blind 'tag_skip'
		end,
		assert = function()
			Balatest.assert_eq(G.GAME.round_resets.ante, 2)
			Balatest.assert_eq(#G.fac_fish_area.cards, 0)
			Balatest.assert_eq(G.GAME.blind_on_deck, 'Small')
			Balatest.assert_eq(G.GAME.round_resets.blind_states.Small, 'Select')
			Balatest.assert_eq(G.GAME.round_resets.blind_states.Big, 'Upcoming')
			Balatest.assert_eq(G.GAME.round_resets.blind_states.Boss, 'Upcoming')
			Balatest.assert_eq(G.STATE, G.STATES.BLIND_SELECT)
		end,
	}
	Balatest.TestPlay {
		name = 'bagels_european_perch_used_with_two',
		category = { 'bagels', 'bagels_european_perch' },

		execute = function()
			FishAndChips.Balatest_obtain_fish { 'fish_fac_bagels_european_perch', 'fish_fac_bagels_european_perch' }
			Balatest.end_round()
			Balatest.end_round()
			Balatest.cash_out()
			Balatest.exit_shop()
			Balatest.skip_blind 'tag_skip'
		end,
		assert = function()
			Balatest.assert_eq(G.GAME.round_resets.ante, 2)
			Balatest.assert_eq(#G.fac_fish_area.cards, 1)
			Balatest.assert_eq(G.GAME.blind_on_deck, 'Small')
			Balatest.assert_eq(G.GAME.round_resets.blind_states.Small, 'Select')
			Balatest.assert_eq(G.GAME.round_resets.blind_states.Big, 'Upcoming')
			Balatest.assert_eq(G.GAME.round_resets.blind_states.Boss, 'Upcoming')
			Balatest.assert_eq(G.STATE, G.STATES.BLIND_SELECT)
		end,
	}
end
