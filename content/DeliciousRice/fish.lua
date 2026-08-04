FishAndChips.Fish {
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_fringills",
	pos = { x = 0, y = 0 },
	attributes = { "xmult" },
	config = {
		extra = {
			xmult = 3
		}
	},

	weight = 10,
	environments = {
		pier = 10
	},
	stats = {
		weight = {min = 7, max = 11},
		length = {min = 0.3, max = 0.6}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {xmult = card.ability.extra.xmult}
        elseif context.after and G.GAME.current_round.hands_played == 0 then
            sendDebugMessage("instakill")
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    play_sound("fac_delrice_instakill")
                    SMODS.destroy_cards(card, nil, true)
                    return true
                end
            }))
        end
	end,
}