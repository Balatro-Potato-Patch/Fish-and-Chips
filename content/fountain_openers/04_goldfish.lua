FishAndChips.Fish {
	key = "fo_goldfish",
	atlas = "fo_fish",
	pos = { x = 2, y = 0 },
    pixel_size = { w = 59, h = 95 },
	weight = 3,
    blueprint_compat = false,
    eternal_compat = false,
    disable_visual_scaling = true,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_grahkon" },
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
		weight = {min = 1.87, max = 1.87 + 0.00001},
		length = {min = 0.276225, max = 0.276225 + 0.00001}
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