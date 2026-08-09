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
			local gap = 0.2
			local length = 3
			local loops = math.ceil(length / gap)
			
			-- shoutout GhostSalt for helping me with this <3

			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("fac_delrice_instakill")
					return true
				end
			}))

			for i = 1, loops do
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					timer = "REAL",
					delay = gap,
					func = function()
						card:juice_up()
						return true
					end
				}))
			end

			G.E_MANAGER:add_event(Event({

				func = function()
					SMODS.destroy_cards(card, {destroy_func = Card.shatter})
					return true
				end
			}))
	end
	end,
}