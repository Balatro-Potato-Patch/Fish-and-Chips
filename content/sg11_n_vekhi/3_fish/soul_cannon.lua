SMODS.Atlas({
	key = "sg11_n_vekhi_soul_cannon",
	path = "sg11_n_vekhi/soul_cannon.png",
	px = 71,
	py = 95,
})

local initialize_soul_cannon_sequence = function(cannon, cards_to_destroy)
	local area = cannon.area

	for _, card in ipairs(cards_to_destroy) do
		card.area:remove_card(card)
		G.play:emplace(card)
	end
	area:remove_card(cannon)
	G.play:emplace(cannon)

	cannon.pac_cannon_rescaled = true

	local explode_time = 1.3 * (math.sqrt(G.SETTINGS.GAMESPEED))

	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1,
		func = function()
			return true
		end,
	}))
	for _, card in ipairs(cards_to_destroy) do
		G.E_MANAGER:add_event(Event({
			func = function()
				card:explode()
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = explode_time,
			func = function()
				cannon:juice_up()
				cannon:hard_set_T(nil, nil, cannon.T.w * 1.125, cannon.T.h * 1.125)
				return true
			end,
		}))
	end
	for i = 1, 5 do
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.75,
			func = function()
				cannon:juice_up()
				cannon:hard_set_T(nil, nil, cannon.T.w * 1.125, cannon.T.h * 1.125)
				return true
			end,
		}))
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 2,
		func = function()
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.25,
		func = function()
			G.GAME.blind:juice_up(1)
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		func = function()
			G.play:remove_card(cannon)
			area:emplace(cannon)
			return true
		end,
	}))
end

FishAndChips.Fish({
	key = "sg11_n_vekhi_soul_cannon",
	atlas = "fac_sg11_n_vekhi_soul_cannon",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = {},
	config = {
		extra = {
			sacrifice = 2,
		},
	},
	weight = 3,
	stats = {
		weight = { min = 1, max = 1 },
		length = { min = 1, max = 1 },
	},
	environments = {
		styx = 3,
		aquifer = 1,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.sacrifice },
		}
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and context.game_over
			and G.fac_fish_area
			and G.fac_fish_area.config.card_limits.base >= card.ability.extra.sacrifice
		then
			local target_amount = card.ability.extra.sacrifice
			local potential_cards = {}
			for _, c in ipairs(SMODS.shallow_copy(card.area.cards)) do
				if not (c == card or SMODS.is_eternal(c)) then
					table.insert(potential_cards, c)
				end
			end
			if #potential_cards >= target_amount then
				local cards_to_destory = {}
				while #cards_to_destory < target_amount do
					local loser = pseudorandom_element(potential_cards, "pac_soul_cannon_activation")
					if loser then
						table.insert(cards_to_destory, loser)
					else
						break
					end
				end
				if #cards_to_destory >= target_amount then
					initialize_soul_cannon_sequence(card, cards_to_destory)
					return {
						saved = "k_pac_soul_cannon_trigger",
						func = function()
							SMODS.destroy_cards(cards_to_destory)
							G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base
								- target_amount
						end,
					}
				end
			end
		end
		if context.starting_shop and card.pac_cannon_rescaled then
			local scale_factor = math.pow(1.125, 7)
			card:hard_set_T(nil, nil, card.T.w / scale_factor, card.T.h / scale_factor)
			card:juice_up()
			card.pac_cannon_rescaled = nil
		end
	end,
	update = function(self, card, dt)
		if G.GAME then
			local atlas_x = card.children.center.sprite_pos.x
			if G.GAME.current_round.hands_left <= 1 then
				if atlas_x ~= 1 then
					card.children.center:set_sprite_pos({ x = 1, y = 0 })
				end
			else
				if atlas_x ~= 0 then
					card.children.center:set_sprite_pos({ x = 0, y = 0 })
				end
			end
		end
	end,
})
