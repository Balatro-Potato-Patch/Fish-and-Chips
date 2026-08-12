FishAndChips.Fish {
	key = "pa_goofball",
	weight = 4,
	atlas = "pa_pulsarfish",
	pos = { x = 2, y = 2 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Pulsar" },
	attributes = { "rank", "generation" },
	environments = {
		styx = 1 --none of the 12 areas are vaugely similar to the Dark Sanctuary, go with this i guess????
	},
    impulse_max = 0.9,
	stats = {
		length = { min = 2.5, max = 2.5},  --based on absolutely nothing, kept min and max the same because it's one specific guy
		weight = { min = 200, max = 200}
	},
    cost = 6,
	blueprint_compat = true,
	config = {
		extra = {
			odds = 4,
		}
	},
	loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'fac_pa_goofball')
        return {
            vars = {
                numerator,
                denominator
            }
        }
    end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 4 and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and SMODS.pseudorandom_probability(card, 'fac_pa_goofball', 1, card.ability.extra.odds) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'fac_pa_goofball'
                        }
                       G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                }
        end
	end
}