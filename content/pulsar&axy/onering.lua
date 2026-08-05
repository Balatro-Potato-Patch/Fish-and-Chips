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
		styx = 0.3,
		city_river = 0.3,
		chocolate_river = 0.3
	},
	stats = {
		length = { min = 0.0197, max = 0.0197 },  --based on average gold ring
		weight = { min = 0.008, max = 0.008 }
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
		if G.fac_fish_area then
			for _, fish in ipairs(G.fac_fish_area.cards) do
				if fish.config.center.key == self.key then
					dupeCount = dupeCount + 1
				end
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
		if not from_debuff then
			card.ability.extra.rounds_elapsed = 0
		end
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