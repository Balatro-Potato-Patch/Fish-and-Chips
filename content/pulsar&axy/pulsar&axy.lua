PotatoPatchUtils.Developer({
	name = 'Pulsar',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	fac_partner = 'Axy' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'Axy',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.YELLOW,
	fac_partner = 'Pulsar'
})

SMODS.Atlas({
	key = "pa_pulsarfish", -- Please include your name/team name in your atlas keys
	path = "pulsar&axy/feesh.png",
	px = 71,
	py = 95,
})

SMODS.Sound {
	key = "pa_wiinormal",
	path = "pulsar&axy/wiiplayfishingnormal.ogg"
}
SMODS.Sound {
	key = "pa_wiibonus",
	path = "pulsar&axy/wiiplayfishingbonus"
}
--#region Fish

FishAndChips.Fish {
	key = "pa_videogame",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 5, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xmult" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 1,
            xmult_gain = 0.5
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult, } }
	end,
	calculate = function(self, card, context)
        if context.fac_end_fishing and context.perfect and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "xmult",
                scalar_value = "xmult_gain"
            })
        end

		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}

FishAndChips.Fish {
	key = "pa_heatshield",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "economy" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = false,
	config = {
		extra = {
			rerolls = 0,
            reroll_gain = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reroll_gain, card.ability.extra.rerolls, } }
	end,
	calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
            -- 1 Free Location Reroll
            -- sendDebugMessage(context.consumeable.ability.set .. " detected", "HeatshieldLogger")
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rerolls",
                scalar_value = "reroll_gain"
            })
        end

		if card.ability.extra.rerolls > 0 and context.fac_environment_changed then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rerolls",
                scalar_value = "reroll_gain",
				operation = '-'
            })
			ease_dollars(5)
		end
	end,
}

FishAndChips.Fish {
	key = "pa_onering",
	weight = 2,
	atlas = "pa_pulsarfish",
	pos = { x = 3 , y = 1},
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "boss_blind", "scaling", "passive" },
	environments = {
		aquifer = 1,
		chocolate_river = 0.3,
		styx = 0.3,
		city_river = 0.3
	},
	blueprint_compat = false,
	config = {
		extra = {
			perma_xblind_size = 2,
			blindsize_increase = 1.15,
			rounds_elapsed = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		local opposite = 1 / (card.ability.extra.perma_xblind_size or 1)

		local dupeCount = 0
		for _, fish in ipairs(G.fac_fish_area.cards) do
			if fish.config.center.key == self.key then
				dupeCount = dupeCount + 1
			end
		end
		local dupeCount = dupeCount > 7 and 7 or dupeCount -- stop at seven because six sevennn

		return { vars = {
			card.ability.extra.blindsize_increase,
			card.ability.extra.perma_xblind_size,
			opposite,
			G.GAME.starting_params.ante_scaling
		},
		key = (dupeCount > 0 and self.key .. "_" .. dupeCount) or self.key .. "_1"
	}
	end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
            G.GAME.blind:disable()
            play_sound('timpani')
            SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
        end
    end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.extra.rounds_elapsed = card.ability.extra.rounds_elapsed or 0
			card.ability.extra.blindsize_increase = (1 / card.ability.extra.blindsize_increase) ^ card.ability.extra.rounds_elapsed

			SMODS.scale_card(card, {
				ref_table = G.GAME.starting_params,
				ref_value = "ante_scaling",
				scalar_table = card.ability.extra,
				scalar_value = "blindsize_increase",
				operation = 'X',
				no_message = true
			})
		end
		
		if FishAndChips.get_environment().key == 'volcano' and not from_debuff then
			G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling / card.ability.extra.perma_xblind_size
		elseif not from_debuff then
			G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * card.ability.extra.perma_xblind_size
		end

		SMODS.calculate_effect({
			message = "Blind size: " .. G.GAME.starting_params.ante_scaling,
			color = G.C.BLIND
		}, card)
	end,
	calculate = function(self, card, context)
		-- disable all boss blinds, from vanillaremade's chicot
        if context.setting_blind and not context.blueprint and context.blind.boss then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:disable()
                            play_sound('timpani')
                            delay(0.4)
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                    return true
                end
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
		-- blind size increases per round
		if context.end_of_round and context.main_eval then
            SMODS.scale_card(card, {
                ref_table = G.GAME.starting_params,
                ref_value = "ante_scaling",
				scalar_table = card.ability.extra,
                scalar_value = "blindsize_increase",
				operation = 'X',
				no_message = true
            })
			card.ability.extra.rounds_elapsed = card.ability.extra.rounds_elapsed + 1
			SMODS.calculate_effect({
				message = "Blind size: " .. G.GAME.starting_params.ante_scaling,
				color = G.C.BLIND
			}, card)
		end
	end
}

FishAndChips.Fish {
	key = "pa_mysteryfish",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 6, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xmult" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 4,
			chosen_hand = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, } }
	end,
	calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
			card.ability.extra.chosen_hand = pseudorandom("pa_mysteryfish", 0, G.GAME.current_round.hands_left)
        end

		if context.joker_main and G.GAME.current_round.hands_left == card.ability.extra.chosen_hand then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}

FishAndChips.Fish {
	key = "pa_F",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 2, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "mult", "food" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = true,
	config = {
		extra = {
			mult = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		local letter_count = 0
		local charmap = {}
		for _, fish in ipairs(G.fac_fish_area.cards) do
			for letter in string.gmatch(localize({ type = 'name_text', set = "fac_Fish", key = fish.config.center.key }), '.') do
				if not charmap[letter] then
					charmap[letter] = true
					letter_count = letter_count + 1
				end
			end
		end

		return { vars = { card.ability.extra.mult, letter_count * card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
			card.ability.extra.chosen_hand = pseudorandom("pa_mysteryfish", 0, G.GAME.current_round.hands_left)
        end

		if context.joker_main then
			local letter_count = 0
			local charmap = {}
			for _, fish in ipairs(G.fac_fish_area.cards) do
				for letter in string.gmatch(localize({ type = 'name_text', set = "fac_Fish", key = fish.config.center.key }), '.') do
					if not charmap[letter] then
						charmap[letter] = true
						letter_count = letter_count + 1
					end
				end
			end

			return {
				mult = letter_count * card.ability.extra.mult
			}
		end
	end,
}

FishAndChips.Fish {
	key = "pa_fishingfish",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "usable" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = true,
	config = {
		extra = {
			toggle = 0,
			modifier = 1.2
		}
	},
	loc_vars = function(self, info_queue, card)
		local choice = card.ability.extra.toggle % 3
		local direction = "same"
		local magnitude = 1
		
		if choice == 0 then
			choice = "speed"
			direction = "slower"
			magnitude = round_number(1 / card.ability.extra.modifier, 2)
		elseif choice == 1 then
			choice = "movement distance"
			direction = "lower"
			magnitude = round_number(1 / card.ability.extra.modifier, 2)
		elseif choice == 2 then
			choice = "movement time"
			direction = "larger"
			magnitude = round_number(card.ability.extra.modifier, 2)
		end
		return { vars = { card.ability.extra.toggle, choice, direction, magnitude } }
	end,
	calculate = function(self, card, context)
        if context.fac_modify_fishing_profile then
			local profile = {}
			-- add effect based on toggle, effects are sweet spot larger, impulse less distance, less often
			local choice = card.ability.extra.toggle % 2
			if choice == 0 then
				profile = {vel_limit = fac_pick_profile().vel_limit / card.ability.extra.modifier}
			elseif choice == 1 then
				profile = {impulse_max = fac_pick_profile().impulse_max / card.ability.extra.modifier}
			elseif choice == 2 then
				profile = {decision_max = fac_pick_profile().decision_max * card.ability.extra.modifier}
			end

			FishAndchips.modify_fishing_profile(profile)
		end
	end,
	add_to_deck = function(self, card)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				card.children.center:set_sprite_pos({x = 0, y = (card.ability.extra.toggle % 3) + 1})
				return true
			end}))
	end,
	can_use = function(self, card)
		return true
	end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card)
		card.ability.extra.toggle = card.ability.extra.toggle + 1
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				card:juice_up(0.3, 0.5)
				card.children.center:set_sprite_pos({x = 0, y = (card.ability.extra.toggle % 3) + 1})
				return true
			end}))
	end
}

--#endregion
