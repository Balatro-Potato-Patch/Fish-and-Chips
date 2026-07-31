--[[FishAndChips.Fish {
	key = "fo_goldfish",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 3,
	ppu_coder = { "Alexi" },
	ppu_artist = { "Grahkon" },
	attributes = { "destroy_card", "hand_level", "usable" },
	config = {
        levels = 1,
	},
	environments = {
		wormhole = 1,
	},
	calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.mult - card.ability.extra.mult_loss <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.dollar_loss
                return {
                    message = localize{ type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_loss } },
                    colour = FishAndChips.C.SAND_DOLLAR
                }
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}]]