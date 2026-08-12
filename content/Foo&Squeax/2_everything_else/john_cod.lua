FishAndChips.Fish{
	key = "fas_john_cod",
	weight = 5,
	environments = {
		city_river = 1,
		wormhole = 0.9,
		backroom = 0.2,
	},
	atlas = "fas_fish_general",
	pos = {x=1,y=0},
	ppu_coder = {"Foo54"},
	ppu_artist = {"squeax09"},
	config = {
		extra = {
			score = 40
		}
	},
	disable_visual_scaling = true,
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	attributes = {"usable", "score", "blind"},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.score}}
	end,
	can_use = function (self, card)
		return G.GAME.blind and G.GAME.blind.in_blind
	end,
	use = function(self, card)
		if not G.GAME.blind.boss then
			G.E_MANAGER:add_event(Event({
				blocking = false,
				func = function()
					if G.STATE == G.STATES.SELECTING_HAND then
						G.GAME.chips = G.GAME.blind.chips
						G.STATE = G.STATES.HAND_PLAYED
						G.STATE_COMPLETE = true
						end_round()
						return true
					end
				end
			}))
		else
			G.E_MANAGER:add_event(Event{
				blocking = false,
				func = function()
					G.GAME.chips = G.GAME.chips + G.GAME.blind.chips * card.ability.extra.score / 100
					play_sound("gong")
					return true
				end
			})
		end
	end,
}