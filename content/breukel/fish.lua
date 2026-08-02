FishAndChips.Fish {
	key = "employeel",
	atlas = "fac_breukel_fish",
	pos = {x = 1,y = 0},
	weight = 8,
	stats = {weight = {min = 0.05, max = 0.086}, length = {min = 1.4, max = 1.7}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"mult"},

	environments = {
		city_river = 10,
		styx = 5
	},
	config = {
		extra = {
			Overtime = 0.5,
		}
	},

	loc_vars = function(self, info_queue, card)
		return {vars = {
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			G.fac_Breukel.AddOverTime(card, card.ability.extra.Overtime)
			return {mult = G.fac_Breukel.GetOverTime()}
		end
	end,
}

FishAndChips.Fish {
	key = "ceo",
	atlas = "fac_breukel_fish",
	pos = {x = 2,y = 0},
	weight = 4,
	stats = {weight = {min = 0, max = 1}, length = {min = 0, max = 1}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"passive"},

	environments = {
		city_river = 10,
	},
	config = {
		extra = {
			Overtime = 1,
			extraOvertime = 0.5
		}
	},

	loc_vars = function(self, info_queue, card)
		return {vars = {
			card.ability.extra.extraOvertime,
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.other_unknown and context.other_unknown.ability.set == "fac_Fish" then
			G.fac_Breukel.AddOverTime(context.other_unknown, card.ability.extra.extraOvertime)
		end
	end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.fac_Breukel.MaxOverTime = 10
    end,

	on_catch = function(self, card)
		G.GAME.fac_Breukel.MaxOverTime = 20
	end,
    add_from_deck = function(self, card, from_debuff)
        G.GAME.fac_Breukel.MaxOverTime = 20
    end,
}

FishAndChips.Fish {
	key = "markerel",
	atlas = "fac_breukel_markerel",
	pos = {x = 0,y = 0},
	weight = 6,
	stats = {weight = {min = 0, max = 1}, length = {min = 0, max = 1}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"generation","usable"},

	environments = {
		city_river = 10,
		backroom = 2.5,
		pier = 1
	},
	config = {
		extra = {
			Overtime = 1
		}
	},

	loc_vars = function(self, info_queue, card)
		return {vars = {
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	use = function(self, card)
		add_tag({key = pseudorandom_element(G.P_TAGS, 'Markerel').key})
		if G.GAME.fac_Breukel.OverTime >= 8 then 
			add_tag({key = pseudorandom_element(G.P_TAGS, 'Markerel').key}) 
		end

		local Joker = pseudorandom_element(G.jokers.cards, 'Markerel Eternal')
		Joker:add_sticker('eternal', true)
		Joker:juice_up()

		G.fac_Breukel.AddOverTime(card, card.ability.extra.Overtime)
	end,
	can_use = function(self, card)
		if G.jokers and #G.jokers.cards > 0 then return true end
	end,

    on_catch = function(self, card)
        card.ability.skin = pseudorandom('Marker',0,7)
        card.children.center:set_sprite_pos{x = card.ability.skin, y = 0}
    end,
}

FishAndChips.Fish {
	key = "stockfish",
	atlas = "fac_breukel_fish",
	pos = {x = 0,y = 0},
	weight = 6,
	stats = {weight = {min = 0, max = 1}, length = {min = 0, max = 1}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"economy"},

	environments = {
		city_river = 10,
		backroom = 4,
		wormhole = 8
	},
	config = {
		extra = {
			Overtime = 1.5,
			Sand_dollars = 2
		}
	},

	loc_vars = function(self, info_queue, card)
		return {vars = {
			card.ability.extra.Sand_dollars/2,
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			G.fac_Breukel.AddOverTime(card, card.ability.extra.Overtime)

			local amount = pseudorandom('stockfish', 0, card.ability.extra.Sand_dollars)/2
			local Overtime, Max = G.fac_Breukel.GetOverTime()
			if pseudorandom('chessfish') < 0.25 + (Overtime/Max)/(4/3) then
				return {sand_dollars = amount}
			else
				return {sand_dollars = -amount}
			end
		end
	end,
}

FishAndChips.Fish {
	key = "codcument",
	atlas = "fac_breukel_fish",
	pos = {x = 0,y = 1},
	weight = 8,
	stats = {weight = {min = 0, max = 1}, length = {min = 0, max = 1}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"mult"},

	environments = {
		city_river = 10,
		backroom = 6
	},
	config = {
		extra = {
			Overtime = 1,
		}
	},

	loc_vars = function(self, info_queue, card)
		return {vars = {
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.fac_fish_caught then
			G.fac_Breukel.AddOverTime(card, card.ability.extra.Overtime)

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 2,
				func = function()
					local Overtime = G.fac_Breukel.GetOverTime()
					SMODS.destroy_cards({card},{immediate = true})
					local fish = SMODS.add_card({key = context.fish})
					fish.ability.stats = FishAndChips.create_fish_stats(fish.config.center)

					if Overtime == 10 and #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
						local fish = SMODS.add_card({key = context.fish})
						fish.ability.stats = FishAndChips.create_fish_stats(fish.config.center)					
					end
				return true end
			}))
		end
	end,
}