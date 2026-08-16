SMODS.Atlas {
	key = "SLDTyp0_art",
	path = "Typ0/Typ0.png",
	px = 71,
	py = 95,
}

SMODS.Atlas {
	key = "Tiger_art",
	path = "Typ0/tiger.png",
	px = 71,
	py = 95,
}


PotatoPatchUtils.Developer({
	name = 'SLDTyp0',
	atlas = 'fac_SLDTyp0_art',
	colour =  SMODS.Gradient{key = "Typ0", colours = {HEX('A4C2F4'), HEX('a4eaf4')},cycle = 8},
	fac_partner = 'fac_TigerThawk', -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
	loc = true
})

PotatoPatchUtils.Developer({
	name = 'TigerThawk',
	atlas = 'fac_Tiger_art',
	colour = SMODS.Gradient{key = "Typ02", colours = {HEX('A4C2F4'), HEX('a4eaf4')},cycle = 8},
	fac_partner = 'fac_SLDTyp0',
	loc = true
})

SMODS.Atlas({
	key = "typ0", -- Please include your name/team name in your atlas keys
	path = "Typ0/fish.png",
	px = 71,
	py = 95,
})

--from cryptid

if not userHasClicked then
    userHasClicked = function(x, y) end
end
if not userHasClickedBoss then
    userHasClickedBoss = function(x, y) end
end

local lcpref = Controller.L_cursor_press
function Controller:L_cursor_press(x, y)
    lcpref(self, x, y)
    if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
        SMODS.calculate_context({ cry_press = true })
        userHasClicked(x, y)
        userHasClickedBoss(x, y)
    end
end


--#region Fish

FishAndChips.Fish {
	key = "Whale",
	atlas = "typ0",
	pos = { x = 2, y = 0 },
	weight = 5,
	stats = {
        weight = {min = 44000, max = 50000}, --change this if its too heavy or too long. its currently just the average weight of a sperm whale cuz funni
        length = {min = 15, max = 20 }
    },
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "TigerThawk" },
	attributes = { "retrigger", "hands", "fac_fish_slot", },
	config = {
		card_limit = -1,
		extra = {
			chips = 30
		}
	},
	environments = {
		wormhole = 5,
	},

	vel_limit = 0.21,
	decision_max = 1,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play
        and G.GAME.current_round.hands_played == 0 then
            return {
                repetitions = 1,
                card = context.other_card
            }
        end
    end
}

FishAndChips.Fish {
	key = "ChudFish",
	atlas = "typ0",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "mult" },
	config = {
		extra = {
			mult = 1
		}
	},
	stats = {
        weight = {min = 0.07, max = 0.1},
        length = {min = 0.0254, max = 0.0762}
    },
	environments = {
		wormhole = 1,
		pier = 10,
		calm_pond = 10,
		aquifer = 2,
		city_river = 10,
		soup = 3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { mult = card.ability.extra.mult } end
	end,
}

FishAndChips.Fish {
	key = "CoolerFish",
	atlas = "typ0",
	pos = { x = 1, y = 0 },
	weight = 10,
	stats = {
        weight = {min = 0.07, max = 0.1},
        length = {min = 0.1524, max = 0.3048}
    },
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "xmult" },
	config = {
		extra = {
			mult = 4
		}
	},
	environments = {
		wormhole = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { xmult = card.ability.extra.mult } end
	end,
}


FishAndChips.Fish {
	key = "jojacola",
	atlas = "typ0",
	pos = { x = 0, y = 1 },
	weight = 10,
	cost = 0,
	stats = {
        weight = {min = 0.370, max = 0.385},
        length = {min =  0.123, max = 0.194}
    },
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "nothing", "food" },
	environments = {
		wormhole = 1,
		pier = 10,
		calm_pond = 10,
		aquifer = 2,
		city_river = 10,
		soup = 3,
	},
	calculate = function(self, card, context)
		return
	end,
}

FishAndChips.Fish {
	key = "MagnetFish",
	atlas = "typ0",
	pos = { x = 1, y = 1 },
	weight = 8,
	cost = 0,
	stats = {
        weight = {min = 2, max = 4},
        length = {min = 15, max = 25}
    },
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "economy", "fac_perfect_catch", },
	environments = {
		city_river = 10,
	},
	config = {
		extra = {
			dollarsmin = 3,
			dollarsmax = 6
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollarsmin, card.ability.extra.dollarsmax } }
	end,
	calculate = function(self, card, context)
		if context.perfect then return { dollars = pseudorandom('fac_magnetfish', card.ability.extra.dollarsmin, card.ability.extra.dollarsmax) } end
	end,
}

FishAndChips.Fish {
	key = "Gary",
	atlas = "typ0",
	pos = { x = 0, y = 2 },
	weight = 8,
	cost = 0,
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "xmult" },
	environments = {
		city_river = 10,
	},
	config = {
		extra = {
			xmult = 3
		}
	},
	stats = {
        weight = {min = 235, max = 305},
        length = {min = 6, max = 6.5}
    },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { xmult = card.ability.extra.xmult } end
	end,
}

FishAndChips.Fish {
	key = "Magikarp",
	atlas = "typ0",
	pos = { x = 2, y = 1 },
	weight = 8,
	cost = 0,
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "on_sell", },
	environments = {
		city_river = 10,
	},
	config = {
		extra = {
			gary_rounds = 0,
			total_rounds = 3
		}
	},
	stats = {
        weight = {min = 5, max = 10},
        length = {min = 0.5, max = 1}
    },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["fish_fac_Gary"]
		return { vars = { card.ability.extra.total_rounds, card.ability.extra.gary_rounds } }
	end,
	calculate = function(self, card, context)
		if context.selling_self and (card.ability.extra.gary_rounds >= card.ability.extra.total_rounds) and not context.blueprint then
			if #G.fac_fish_area.cards <= G.fac_fish_area.config.card_limit then
				local new_card = create_card('fac_Fish', G.fac_fish_area, nil, nil, nil, nil, 'fish_fac_Gary')
				new_card:add_to_deck()
				G.fac_fish_area:emplace(new_card)
				return { message = localize('k_duplicated_ex') }
			else
				return { message = localize('k_no_room_ex') }
			end
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra.gary_rounds = card.ability.extra.gary_rounds + 1
			if card.ability.extra.gary_rounds == card.ability.extra.total_rounds then
				local eval = function(card) return not card.REMOVED end
				juice_card_until(card, eval, true)
			end
			return {
				message = (card.ability.extra.gary_rounds < card.ability.extra.total_rounds) and
					(card.ability.extra.gary_rounds .. '/' .. card.ability.extra.total_rounds) or
					localize('k_active_ex'),
				colour = G.C.FILTER
			}
		end
	end,
}

SMODS.Sound({key = "Klaus_ass", path = "./Typ0/ass.ogg",})
SMODS.Sound({key = "Klaus_balls", path = "./Typ0/balls deep.ogg",})
SMODS.Sound({key = "Klaus_bitches", path = "./Typ0/Bitches.ogg",})
SMODS.Sound({key = "Klaus_getout", path = "./Typ0/Get Out.ogg",})
SMODS.Sound({key = "Klaus_later", path = "./Typ0/later.ogg",})
SMODS.Sound({key = "Klaus_help", path = "./Typ0/may i help you.ogg",})
SMODS.Sound({key = "Klaus_regards", path = "./Typ0/regards.ogg",})

FishAndChips.Fish {
	key = "Klaus",
	atlas = "typ0",
	pos = { x = 1, y = 2 },
	weight = 10,
	cost = 0,
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "mult", "face", },
	environments = {
		city_river = 10,
	},
	config = {
		extra = {
			mult = 10
		}
	},
	stats = {
        weight = {min = 0.1, max = 0.3},
        length = {min = 0.10, max = 0.20}
    },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.cry_press and card.states.hover.is then
			local roll = pseudorandom('fac_klaus_audio', 1, 7)
				local sounds = {
					'fac_Klaus_ass',
					'fac_Klaus_balls',
					'fac_Klaus_bitches',
					'fac_Klaus_getout',
					'fac_Klaus_later',
					'fac_Klaus_help',
					'fac_Klaus_regards',
				}
				local messages = { -- TODO: localize?
					"Sit Your Ass On The Ground!",
					"I want to be Balls Deep in Egg Salad!",
					"That's Right Bitches!",
					"Get Out!",
					"Happy To Take Look Later!",
					"May I Help You?",
					"Goofus Mcdoof? Sends his Regards!",
				}

                return {
                    sound = sounds[roll],
                    message = messages[roll]
                }
		end

        if context.joker_main then
            local has_face = false
            for _, played_card in ipairs(context.scoring_hand) do
                if played_card:is_face() then
                    has_face = true
                    break
                end
            end
            if not has_face then
				local roll = pseudorandom('fac_klaus_audio', 1, 7)
				local sounds = {
					'fac_Klaus_ass',
					'fac_Klaus_balls',
					'fac_Klaus_bitches',
					'fac_Klaus_getout',
					'fac_Klaus_later',
					'fac_Klaus_help',
					'fac_Klaus_regards',
				}
				local messages = {
					"Sit Your Ass On The Ground!",
					"I want to be Balls Deep in Egg Salad!",
					"That's Right Bitches!",
					"Get Out!",
					"Happy To Take Look Later!",
					"May I Help You?",
					"Goofus Mcdoof? Sends his Regards!",
				}

                return {
                    mult = card.ability.extra.mult,
                    sound = sounds[roll],
                    message = messages[roll]
                }
            end
        end
    end,
}

--#endregion
