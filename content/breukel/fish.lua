FishAndChips.Fish {
	key = "enveloach",
	atlas = "fac_breukel_fish",
	pos = {x = 1,y = 2},
	weight = 5,
	stats = {weight = {min = 0.008, max = 0.011}, length = {min = 0.1, max = 0.12}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"economy"},

	environments = {
		city_river = 10,
		styx = 5
	},
	config = {
		extra = {
			dollars = 0,
			Overtime = 0.5,
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		return {vars = {
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.Overtime)
		end
		card.ability.extra.dollars = math.floor(G.fac_Breukel.GetOverTime())
	end,
	calc_dollar_bonus = function(self, card)
        if card.ability.extra.dollars > 0 then
            return card.ability.extra.dollars
        end
    end,
}

FishAndChips.Fish {
	key = "businesscarp",
	atlas = "fac_breukel_fish",
	pos = {x = 2,y = 2},
	weight = 5,
	stats = {weight = {min = 0.008, max = 0.011}, length = {min = 0.1, max = 0.12}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"economy", "chance",},

	environments = {
		city_river = 10,
		styx = 5
	},
	config = {
		extra = {
			Overtime = 1,
			Sand_dollars = 1,
			Base_num = 4,
			Denom = 20
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		local Num, Denom = SMODS.get_probability_vars(card, card.ability.extra.Base_num + G.fac_Breukel.GetOverTime(), card.ability.extra.Denom, 'fac_fish_businesscarp_rand')
		return { vars = { Num, Denom, card.ability.extra.Sand_dollars, card.ability.extra.Overtime, G.fac_Breukel.GetOverTime() }}
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.Overtime)
			local Sand_dollars = 0
			for i = 1, #G.fac_fish_area.cards do
				if SMODS.pseudorandom_probability(card, 'fac_fish_businesscarp_rand', card.ability.extra.Base_num + G.fac_Breukel.GetOverTime(), card.ability.extra.Denom) then
					Sand_dollars = Sand_dollars + 1
				end
			end
			return {sand_dollars = Sand_dollars * card.ability.extra.Sand_dollars}
		end
	end,
}

FishAndChips.Fish {
	key = "employeel",
	atlas = "fac_breukel_fish",
	pos = {x = 1,y = 0},
	weight = 5,
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
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		return {vars = {
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.Overtime)
			return {mult = G.fac_Breukel.GetOverTime()}
		end
	end,
}

FishAndChips.Fish {
	key = "plecoworker",
	atlas = "fac_breukel_fish",
	pos = {x = 1,y = 1},
	weight = 5,
	stats = {weight = {min = 0.2, max = 0.45}, length = {min = 0.075, max = 0.1}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"chips"},

	environments = {
		city_river = 10,
		styx = 5
	},
	config = {
		extra = {
			Overtime = 0.5,
			Times_chips = 5
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		return {vars = {
			card.ability.extra.Times_chips,
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.joker_main then
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.Overtime)
			return {chips = G.fac_Breukel.GetOverTime()*card.ability.extra.Times_chips}
		end
	end,
}

FishAndChips.Fish {
	key = "ceo",
	atlas = "fac_breukel_fish",
	pos = {x = 2,y = 0},
	weight = 4,
	stats = {weight = {min = 35, max = 145}, length = {min = 2.5, max = 3}},
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
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		return {vars = {
			card.ability.extra.extraOvertime,
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if (context.other_unknown and context.other_unknown.ability.set == "fac_Fish") or context.after then
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
	stats = {weight = {min = 0.009, max = 0.015}, length = {min = 0.13, max = 0.15}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"generation","usable","tag","modify_card",},

	environments = {
		city_river = 10,
		backroom = 2.5,
		pier = 1
	},
	blueprint_compat = false,
	eternal_compat = false,
	config = {
		extra = {
			Overtime = 1
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
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
	stats = {weight = {min = 0.3, max = 1.1}, length = {min = 0.3, max = 0.7}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"economy","lose_economy"},

	environments = {
		city_river = 10,
		backroom = 4,
		wormhole = 8
	},
	config = {
		extra = {
			Overtime = 1.5,
			Sand_dollars = 1,
			Base_num = 10,
			Denom = 40
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		local Num, Denom = SMODS.get_probability_vars(card, card.ability.extra.Base_num + (G.fac_Breukel.GetOverTime() * 3), card.ability.extra.Denom, 'fac_fish_stockfish_rand')
		return {vars = {
			card.ability.extra.Sand_dollars,
			Num, Denom,
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.Overtime)

			local amount = pseudorandom('stockfish', 0, card.ability.extra.Sand_dollars)
			local Overtime = G.fac_Breukel.GetOverTime()
			if amount == 0 then
				return nil, true
			elseif SMODS.pseudorandom_probability(card, 'fac_fish_stockfish_rand', card.ability.extra.Base_num + (Overtime * 3), card.ability.extra.Denom) then
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
	weight = 5,
	stats = {weight = {min = 5, max = 12}, length = {min = 0.6, max = 1.2}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"modify_card","generation",},

	environments = {
		city_river = 10,
		backroom = 6
	},
	config = {
		extra = {
			Overtime = 1,
			Copy_overtime = 10,
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		return {vars = {
			card.ability.extra.Copy_overtime,
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
		if context.fac_fish_caught then
			local Overtime = G.fac_Breukel.GetOverTime()
			G.fac_Breukel.AddOverTime(card, card.ability.extra.Overtime)
			if not context.blueprint then
			if Overtime == card.ability.extra.Copy_overtime and #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit then
				local fish = SMODS.add_card({key = context.fish})
				fish.ability.stats = FishAndChips.create_fish_stats(fish.config.center)
			end
			card:juice_up()
			card:set_ability(context.fish)
			card.ability.stats = FishAndChips.create_fish_stats(card.config.center)
			end
		end
	end,
}

FishAndChips.Fish {
	key = "pirinter",
	atlas = "fac_breukel_fish",
	pos = {x = 2,y = 1},
	weight = 5,
	stats = {weight = {min = 130, max = 150}, length = {min = 1, max = 1.2}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"destroy_card", "generation", "discard", "enhancements", "editions", "seals",},

	environments = {
		city_river = 10,
		wormhole = 5,
		volcano = 1
	},
	config = {
		extra = {
			Overtime = 1,
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		return {vars = {
			card.ability.extra.Overtime,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
        if context.discard and G.GAME.current_round.discards_used <= 0 and #context.full_hand == 1 then
			local Overtime = G.fac_Breukel.GetOverTime()
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.Overtime)
			local _card = context.full_hand[1]

			G.E_MANAGER:add_event(Event({
				func = function()
            		local card_copied = SMODS.copy_card(_card)

					if Overtime > 6 and pseudorandom("pirinterseal") < Overtime/10 then
						card_copied:set_seal(SMODS.poll_seal({guaranteed = true}))
					end

					if Overtime > 4 and pseudorandom("pirinteredition") < Overtime/15 then
						card_copied:set_edition(SMODS.poll_edition({guaranteed = true, no_negative = true}))
					end

					if Overtime > 2 then
						card_copied:set_ability(SMODS.poll_enhancement({guaranteed = true}))
					end
				return true end
			}))
			return {	
            	remove = true,
            	delay = 0.45
            }
		end
	end,
}

FishAndChips.Fish {
	key = "produck",
	atlas = "fac_breukel_fish",
	pos = {x = 0,y = 2},
	weight = 5,
	stats = {weight = {min = 0.009, max = 0.015}, length = {min = 0.13, max = 0.15}},
	ppu_coder = {"Breuhh"},
	ppu_artist = {"Comykel"},
	attributes = {"generation", "enhancements"},

	environments = {
		city_river = 10,
		calm_pond = 6,
		garden = 4
	},
	config = {
		extra = {
			Overtime = 0.5,
			OvertimeAlso = 1.5,
			OvertimeReq = 9
		}
	},

	loc_vars = function(self, info_queue, card)
		local _, Max = G.fac_Breukel.GetOverTime(); info_queue[#info_queue + 1] = { set = "Other", key = "fac_breukel_overtime", specific_vars = { Max } }
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		return {vars = {
			card.ability.extra.Overtime,
			card.ability.extra.OvertimeReq,
			card.ability.extra.OvertimeAlso,
			G.fac_Breukel.GetOverTime()
		}}
	end,

	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.Overtime)
		end

		if context.after then
			local Overtime = G.fac_Breukel.GetOverTime()
			G.fac_Breukel.AddOverTime(context.blueprint and context.blueprint_card or card, card.ability.extra.OvertimeAlso)

			G.E_MANAGER:add_event(Event({
				func = function()
					if Overtime > card.ability.extra.OvertimeReq then
						card:juice_up()
						for i,v in pairs(G.hand.cards) do
							v:set_ability("m_gold")
							v:juice_up()
						end
					end
				return true end
			}))

		end
	end,
}
