FishAndChips.Fish {
	key = "fo_goldfish",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 3,
    blueprint_compat = false,
    eternal_compat = false,
	ppu_coder = { "Alexi" },
	ppu_artist = { "Grahkon" },
	attributes = { "economy" },
	config = {
        extra = {
            amt = 5,
            dec = 1,
        }
	},
	environments = {
		wormhole = 1,
	},
    -- placeholder values
    stats = {
		weight = {min = 1, max = 1 + 0.00001},
		length = {min = 0.02, max = 0.02 + 0.00001}
	},
    loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.amt,
            card.ability.extra.dec,
        }}
	end,
	calculate = function(self, card, context)
        if context.starting_shop then
            if card.ability.extra.amt - card.ability.extra.dec <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "amt",
                    scalar_value = "dec",
                    scalar_factor = -1,
                    scaling_message = {
                        message = "-$" .. card.ability.extra.dec,
                        colour = FishAndChips.C.SAND_DOLLAR,
                        font = "fac_sand_dollars",
                    }
                })
            end
        end

        if context.modify_final_cashout then
			return { sand_dollars = card.ability.extra.amt }
		end
    end,
}