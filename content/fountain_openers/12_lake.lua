FishAndChips.Fish {
	key = "fo_lake",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 1,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_alexi" },
	attributes = { "emult", "scaling" },
	config = {
		extra = {
			xmult = 1,
            xmult_mod = 0.5
		},
	},
    cost = 9,
	environments = {
		city_river = 1,
        backroom = 0.1,
        calm_pond = 0.01,
	},
	stats = {
		weight = {min = 500, max = 500.01},
		length = {min = 7.2, max = 7.21},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod } }
	end,
	calculate = function(self, card, context)
        if context.joker_main then
            return {
                emult = card.ability.extra.emult
            }
        end

        if (context.selling_card or context.joker_type_destroyed) and context.card:is_rarity("Rare") then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "emult",
                scalar_value = "emult_mod"
            })
        end
	end,
}