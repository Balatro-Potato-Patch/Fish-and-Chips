FishAndChips.Fish {
	key = "csc_basculegion",
	atlas = "csc_fish",
	pos = { x = 0, y = 12 },
	
	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "chips" },
	config = {
		extra = {
			chips_mod = 50,
            chips = 0
		}
	},

	stats = {
		weight = {
			min = 70.4,
			max = 158.4
		},
		length = {
			min = 2.4,
			max = 3.6
		}
	},

    weight = 5,
	environments = {
		styx = 5,
		wormhole = 1
	},

    perishable_compat = false,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_mod, card.ability.extra.chips } }
	end,

	calculate = function(self, card, context)
        --[[
		if context.remove_playing_cards and context.removed then
            return {
                effect = true,
                func = function()
                    for i = 1, #context.removed do
                        SMODS.scale_card(card, {
                            ref_value = "chips",
                            scalar_value = "chips_mod",
                            message_colour = G.C.CHIPS,
                            no_message = i ~= #context.removed and true
                        })
                    end
                end
            }
        end
        ]]
        if 
    --        (context.fac_use_fish and not context.kept_on_use)
    --    or
            (context.joker_type_destroyed and context.card and context.card.ability and context.card.ability.set == "fac_Fish")
        and not context.blueprint then
            return {
                effect = true,
                func = function()
                    SMODS.scale_card(card, {
                        ref_value = "chips",
                        scalar_value = "chips_mod",
                        message_colour = G.C.CHIPS,
                    })
                end
            }
        end
        if context.joker_main and card.ability.extra.chips ~= 0 then
            return {
                chips = card.ability.extra.chips,
                card = context.blueprint and context.blueprint_card or card
            }
        end
	end,
}