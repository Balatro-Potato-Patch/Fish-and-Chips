FishAndChips.Fish {
	key = "pa_mysteryfish",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 6, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xmult" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	stats = {
		length = {min = 1.5, max = 2.25},  --entirely vibes based
		weight = { min = 60, max = 120}
	},
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 4,
			chosen_hand = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, } }
	end,
	calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
			card.ability.extra.chosen_hand = pseudorandom("pa_mysteryfish", 0, G.GAME.current_round.hands_left - 1)
        end

		if context.joker_main and G.GAME.current_round.hands_left == card.ability.extra.chosen_hand then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
	on_catch = function(self, card)
		local is_perfect_catch = G.FAC_FISH_GAME.perfect    --it'd be nice if this could be delayed until around when the fish actually materializes
		if is_perfect_catch then                            --because the normal sound is rather short
			SMODS.calculate_effect{
				func = function()
					play_sound('fac_pa_wiibonus')
				end
			}
		else
			SMODS.calculate_effect{
				func = function()
					play_sound('fac_pa_wiinormal')
				end
			}
		end
	end,
}