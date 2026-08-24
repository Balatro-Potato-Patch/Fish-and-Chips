FishAndChips.Fish {
	key = "pa_onering",
	weight = 2,
	atlas = "pa_pulsarfish",
	pos = { x = 3 , y = 1},
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "boss_blind", "scaling", "passive", "xblindsize", },
	treasure = true,
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
	cost = 4,
	blueprint_compat = false,
	config = {
		extra = {
			perma_xblind_size = 0.8,
			blindsize_increase = 1.15,
			total_x_blind_size = 1.0,
		}
	},
	loc_vars = function(self, info_queue, card)
		local text = self:count_duplicates()

		return { vars = {
			card.ability.extra.blindsize_increase,
			card.ability.extra.perma_xblind_size,
			card.ability.extra.total_x_blind_size,
			text
		},
	}
	end,
	flavour_vars = function(self, info_queue, card)
		local text = self:count_duplicates()
		return { vars = { text, string.lower(text) } }
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
			if FishAndChips.get_environment().key == 'volcano' then
				G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * card.ability.extra.perma_xblind_size
			end
		end
	end,
	calculate = function(self, card, context)
		-- disable all boss blinds, from vanillaremade's chicot
        if context.setting_blind and not context.blueprint then
			if context.blind.boss then
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
			end
            return {
				x_blind_size = card.ability.extra.total_x_blind_size
			}
        end
		-- blind size increases per round
		if context.end_of_round and context.main_eval then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "total_x_blind_size",
				scalar_table = card.ability.extra,
                scalar_value = "blindsize_increase",
				operation = 'X',
				no_message = true
            })
			return {
				message = "X"..card.ability.extra.total_x_blind_size,
				color = G.C.BLIND
			}
		end
	end,
	count_duplicates = function(self)
		local dupeCount = 0
		if G.fac_fish_area then
			for _, fish in ipairs(G.fac_fish_area.cards) do
				if fish.config.center.key == self.key then
					dupeCount = dupeCount + 1
				end
			end
		end

		local text = "one"
		if dupeCount == 1 then
			text = "one"
		elseif dupeCount == 2 then
			text = "two"
		elseif dupeCount == 3 then
			text = "three"
		elseif dupeCount == 4 then
			text = "four"
		elseif dupeCount == 5 then
			text = "five"
		elseif dupeCount == 6 then
			text = "six"
		elseif dupeCount == 7 then -- stop at seven because six sevennn
			text = "seven"
		end
		return localize("k_pulsaraxy_" .. text)
	end,
}
