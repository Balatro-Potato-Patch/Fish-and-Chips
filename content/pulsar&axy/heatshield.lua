FishAndChips.Fish {
	key = "pa_heatshield",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "economy", "planet" },
	environments = {
		wormhole = 1,
		pier = 0.3
	},
	blueprint_compat = false,
	config = {
		extra = {
			rerolls = 0,
            reroll_gain = 1
		}
	},
	stats = {
		length = { min = 0.278, max = 0.278},  --0.0278m , 277.77g based on starship heat tile measurements, not sure where density was from?
		weight = { min = 0.2777, max = 0.2777}
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