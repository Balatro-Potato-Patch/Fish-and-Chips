FishAndChips.Fish {
	key = "csc_chi_yu",
	atlas = "csc_fish",
	pos = { x = 3, y = 7 },

	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { "xblindsize" },
	config = {
		extra = {
			blind_multiplier = 0.75
		}
	},

	stats = {
		weight = {
			min = 3.136,
			max = 7.056
		},
		length = {
			min = 0.32,
			max = 0.48
		}
	},

    weight = 1,
	environments = {
		aquifer = 1,
		styx = 1,
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blind_multiplier } }
	end,

	calculate = function(self, card, context)
		if context.setting_blind then return {
            x_blind_size = card.ability.extra.blind_multiplier,
            func = function()
                card:juice_up()
            end,
			card = context.blueprint and context.blueprint_card or card
        } end
	end,
    add_to_deck = function(self, card, from_debuff)
        if G.GAME.blind.in_blind then
            SMODS.mod_blind_size({ mult = card.ability.extra.blind_multiplier, card = card, effect = {} })
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if G.GAME.blind.in_blind then
            SMODS.mod_blind_size({ mult = 1/card.ability.extra.blind_multiplier, card = card, effect = {} })
        end
    end,
}
