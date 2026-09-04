local function calculate_all_round_dollars()
	local dollars = 0
	local sand_dollars = 0
	local idx = 0
	local blind_on_deck = {
		[0] = "Small",
		[1] = "Big",
		[2] = "Boss",
	}

	local old = G.GAME.blind_on_deck

	for k, v in pairs(G.GAME.round_resets.blind_choices) do
		local blind = G.P_BLINDS[v]

		G.GAME.blind_on_deck = blind_on_deck[idx] or "Boss"

		local FAC_CASHOUT_REWARD = { Small = 1, Big = 2, Boss = 3 }
		local sand_dollars_to_add = FAC_CASHOUT_REWARD[G.GAME.blind_on_deck] or FAC_CASHOUT_REWARD.Small

		if not blind then
			goto continue
		end

		-- Blind dollars
		dollars = dollars + blind.dollars
		-- Hand dollars
		dollars = dollars + G.GAME.current_round.hands_left * (G.GAME.modifiers.money_per_hand or 1)
		-- Discard dollars
		dollars = dollars + G.GAME.current_round.discards_left * (G.GAME.modifiers.money_per_discard or 0)
		-- Joker dollars
		for _, area in ipairs(SMODS.get_card_areas("jokers")) do
			for _, _card in ipairs(area.cards) do
				local ret, ret_opts = _card:calculate_dollar_bonus()
				ret_opts = ret_opts or {}
				if ret then
					dollars = dollars + ret
				end
			end
		end
		-- individual dollars
		for _, target in ipairs(SMODS.get_card_areas("individual", "calc_dollar_bonus")) do
			if type(target.object.calc_dollar_bonus) == "function" then
				local ret, ret_opts = target.object:calc_dollar_bonus()
				ret_opts = ret_opts or {}
				if ret then
					dollars = dollars + ret
				end
			end
		end
		-- Tags
		for i = 1, #G.GAME.tags do
			local ret = G.GAME.tags[i]:apply_to_run({ type = "eval" })
			if ret then
				dollars = dollars + ret.dollars
			end
		end
		-- Interest
		if G.GAME.dollars >= 5 and not G.GAME.modifiers.no_interest then
			dollars = dollars
				+ G.GAME.interest_amount * math.min(math.floor(G.GAME.dollars / 5), G.GAME.interest_cap / 5)
		end
		-- Sand dollars
		for _, area in ipairs(SMODS.get_card_areas('jokers')) do
			for _, _card in ipairs(area.cards) do
				local center = _card.config.center
				if type(center.calc_sand_dollar_bonus) == 'function' then
					local ret, ret_opts = center:calc_sand_dollar_bonus(_card)
					ret_opts = ret_opts or {}
					if ret then
						sand_dollars = sand_dollars + ret
					end
				end
			end
		end
		sand_dollars = sand_dollars + sand_dollars_to_add
		-- Misc dolyar
		SMODS.cashout_pitch = 0
		SMODS.cashout_index = 0
		SMODS.cashout_dollars = dollars
		SMODS.calculate_context({ modify_final_cashout = true, amount = dollars })
		dollars = SMODS.cashout_dollars

		::continue::

		idx = idx + 1
	end

	G.GAME.blind_on_deck = old
	G.GAME.current_round.dollars = dollars
	G.GAME.current_round.fac_sand_dollars = sand_dollars
end

local function recreate_all_blind_selects()
	local blind_on_deck = {
		small = "Small",
		big = "Big",
		boss = "Boss",
	}
	for k, v in pairs(G.blind_select_opts or {}) do
		local par = v.parent

		v:remove()
		G.blind_select_opts[k] = UIBox({
			T = { par.T.x, 0, 0, 0 },
			definition = {
				n = G.UIT.ROOT,
				config = { align = "cm", colour = G.C.CLEAR },
				nodes = {
					UIBox_dyn_container(
						{ create_UIBox_blind_choice(blind_on_deck[k]) },
						false,
						get_blind_main_colour(blind_on_deck[k]),
						mix_colours(G.C.BLACK, get_blind_main_colour(blind_on_deck[k]), 0.8)
					),
				},
			},
			config = {
				align = "bmi",
				offset = { x = 0, y = G.ROOM.T.y + 9 },
				major = par,
				xy_bond = "Weak",
			},
		})
		par.config.object = G.blind_select_opts[k]
		par.config.object:recalculate()
		G.blind_select_opts[k].parent = par
		G.blind_select_opts[k].alignment.offset.y = 0
	end
end

FishAndChips.Fish({
	key = "8f", -- 3 NEW
	weight = 1,
	cost = -3,
	environments = {
		calm_pond = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Ellen (Haya)" },
	attributes = {
		"usable", "economy",
	},
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = false,
	decision_min = math.huge,
	decision_max = math.huge,
	impulse_min = 0,
	impulse_max = 0,
	vel_limit = 0.01,
	atlas = "hayayaya_fih",
	pos = { x = 0, y = 1 },
	pixel_size = { w = 64, h = 64 },
	config = { immutable = { count = 0, max = 8 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.immutable.count, card.ability.immutable.max },
			key = self.key .. (card.ability.immutable.count >= card.ability.immutable.max and "_alt" or "_normal"),
		}
	end,
	flavour_vars = function(self, info_queue, card)
		return {
			key = self.key .. (card.ability.immutable.count >= card.ability.immutable.max and "_alt" or "_normal"),
		}
	end,
	stats = {
		length = { min = 0, max = 0 },
		weight = { min = 0, max = 0 },
	},
	badge_key = "k_fac_hayayaya_unknown",
	disable_visual_scaling = true, -- The stats are for show...
	can_use = function(self, card)
		return G.STATE == G.STATES.BLIND_SELECT and card.ability.immutable.count >= card.ability.immutable.max
	end,
	use = function(self, card)
		-- TODO sound
		HayayayaUtils.stop_music(true)

		card:highlight(false)

		play_sound("fac_hayayaya_rainer")

		-- TODO Honestly, do the fucking animation here where a black bar appears in the center like in firered
		-- That would be really cool.
		G.E_MANAGER:add_event(Event({
			delay = 0.5 * G.SPEEDFACTOR,
			trigger = "after",
			func = function()
				-- RAINER, abyss this motherfucker
				play_sound("fac_hayayaya_abyss")
				return true
			end,
		}))

		G.GAME.fac_rainer = 0

		G.E_MANAGER:add_event(Event({
			ease = "lerp",
			trigger = "ease",
			ref_table = G.GAME,
			ref_value = "fac_rainer",
			ease_to = 1,
			delay = 0.4 * G.SPEEDFACTOR,
		}))

		G.E_MANAGER:add_event(Event({
			delay = 5 * G.SPEEDFACTOR,
			trigger = "after",
			func = function()
				G.GAME.round_resets.blind_states.Boss = "Defeated"
				G.GAME.round_resets.blind_ante = G.GAME.round_resets.ante + 1
				G.GAME.round_resets.blind_tags.Small = get_next_tag_key()
				G.GAME.round_resets.blind_tags.Big = get_next_tag_key()
				reset_blinds()
				recreate_all_blind_selects()
				card.children.center.states.visible = false
				return true
			end,
		}))

		ease_ante(1)
		calculate_all_round_dollars()
		SMODS.money_from_cashout = true
		ease_dollars(G.GAME.current_round.dollars)
		ease_sand_dollars(G.GAME.current_round.fac_sand_dollars)
		G.GAME.current_round.fac_sand_dollars = 0
		SMODS.money_from_cashout = nil

		G.E_MANAGER:add_event(Event({
			ease = "lerp",
			trigger = "ease",
			ref_table = G.GAME,
			ref_value = "fac_rainer",
			ease_to = 0.0,
			delay = 0.4 * G.SPEEDFACTOR,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = G.SPEEDFACTOR,
			func = function()
				attention_text({
					text = "It is done.",
					align = "cm",
					major = card,
					-- pos = { x = card.T.x, y = card.T.y },
					backdrop_colour = G.C.FILTER,
					hold = 3 * G.SPEEDFACTOR,
					emboss = 0.05,
				})
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = G.SPEEDFACTOR * 3,
			func = function()
				card:remove()
				return true
			end,
		}))

		delay(0.5)
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and card.ability.immutable.count < card.ability.immutable.max and not context.blueprint and not context.retrigger_joker then
			card.ability.immutable.count = card.ability.immutable.count + 1
			return {
				message = string.format("%i/%i", card.ability.immutable.count, card.ability.immutable.max),
			}
		end
	end,
	on_catch = function(self, card)
		HayayayaUtils.stop_music()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.5 * G.SPEEDFACTOR,
			func = function()
				play_sound("fac_hayayaya_mistake")
				return true
			end,
		}))
		delay(2 * G.SPEEDFACTOR)
	end,
})

local old_draw = love.draw
function love.draw()
	old_draw()

	if G and G.GAME and G.GAME.fac_rainer then
		love.graphics.setColor(1.0, 1.0, 1.0, G.GAME.fac_rainer)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
end
