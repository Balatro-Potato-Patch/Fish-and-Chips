FishAndChips.Fish {
	key = "pa_heatshield",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "economy", "planet", "reroll", "consumable", },
	environments = {
		wormhole = 1,
		pier = 0.3
	},
	blueprint_compat = false,
	config = {
		extra = {
			rerolls = 0,
            reroll_gain = 1,
			original_cost = 0,
			cost_set = false
		}
	},
	stats = {
		length = { min = 0.278, max = 0.278},
		weight = { min = 0.2777, max = 0.2777}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reroll_gain, card.ability.extra.rerolls, } }
	end,
	calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Planet' and not context.blueprint then
            -- 1 Free Location Reroll
            -- sendDebugMessage(context.consumeable.ability.set .. " detected", "HeatshieldLogger")
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "rerolls",
                scalar_value = "reroll_gain"
            })
			return nil, true
        end

		if context.fac_environment_changed and not context.retrigger_joker and not context.blueprint then
			if card.ability.extra.rerolls > 0 then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "rerolls",
					scalar_value = "reroll_gain",
					operation = '-',
					no_message = true
				})
			end
		end
	end,
	add_to_deck = function (self, card, from_debuff)
		if not from_debuff then
			card.ability.extra.original_cost = G.GAME.fac_environment_reroll_cost
			card.ability.extra.cost_set = true
		end
	end,
	remove_from_deck = function (self, card, from_debuff)
		if not from_debuff and card.ability.extra.cost_set then
			G.GAME.fac_environment_reroll_cost = card.ability.extra.original_cost
			card.ability.extra.cost_set = false
		end
	end
}

local FishAndChips_fishing_button_ref = FishAndChips.fishing_button
function FishAndChips.fishing_button(key, text, price)
	if price then
		for k,v in pairs(G.fac_fish_area.cards) do
			if v.config.center.key == 'fish_fac_pa_heatshield' and v.ability.extra.cost_set == true then
				if v.ability.extra.rerolls > 0 then
					G.GAME.fac_environment_reroll_cost = 0
				elseif v.ability.extra.rerolls <= 0 then
					G.GAME.fac_environment_reroll_cost = v.ability.extra.original_cost
					v.ability.extra.cost_set = false
				end
			end
		end
	end
	return FishAndChips_fishing_button_ref(key, text, price)
end
