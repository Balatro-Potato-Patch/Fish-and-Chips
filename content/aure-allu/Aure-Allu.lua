PotatoPatchUtils.Developer({
	name = 'Aure',
	atlas = 'aure-allu_cards',
	colour = G.C.ORANGE,
	fac_partner = 'AllUniversal'
})

PotatoPatchUtils.Developer({
	name = 'Alluniversal',
	atlas = 'aure-allu_cards',
	pos = {x = 1, y = 0},
	colour = G.C.GREY,
	fac_partner = 'Aure'
})

SMODS.Atlas({
	key = "aure-allu_cards",
	path = "aure-allu/cards.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "aure-allu_fish",
	path = "aure-allu/fishee.png",
	px = 71,
	py = 95,
})


--#region Fish

-- The Original     Starfish
FishAndChips.Fish {
	key = "the_original___starfish",
	atlas = "aure-allu_fish",
	pos = { x = 0, y = 0 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
	config = {
		extra = {
			sand_dollars = 2,
		},
        immutable = {
            star_odds = 2,
        }
	},
	environments = {
		pond = 10,
		pier = 10,
		city_river = 10,
		swamp = 10,
		volcano = 10,
		aquifer = 10,
		garden = 10,
		styx = 10,
		chocolate_river = 10,
		wormhole = 10,
		backroom = 10,
		soup = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		
	end,
}

-- Cheap Cheep
FishAndChips.Fish {
	key = "cheap_cheep",
	atlas = "aure-allu_fish",
	pos = { x = 1, y = 0 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
	config = {
		extra = {
			refund_sand_dollars = 2,
		},
        immutable = {
            refund_odds = 3,
        }
	},
	environments = {
		pier = 10,
		swamp = 5,
		city_river = 8,
		garden = 7,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		
	end,
}

-- Blooper
FishAndChips.Fish {
	key = "blooper",
	atlas = "aure-allu_fish",
	pos = { x = 2, y = 0 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
	config = {
		extra = {
			face_down_x_chips = 0.1,
		},
	},
	environments = {
		pier = 8,
		swamp = 8,
		city_river = 10,
		aquifer = 4,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		if context.stay_flipped and context.from_area == G.deck and context.to_area == G.hand and G.GAME.current_round.hands_played == 0 then
            return {
                stay_flipped = true
            }
        elseif context.joker_main then 
            local total = 1
            for _, pcard in ipairs(G.hand.cards) do
                if pcard.facing == "back" then
                    total = total + card.ability.extra.face_down_x_chips
                end
            end
            return {
                x_chips = total
            }
        end
	end,
}

-- Goldfish
FishAndChips.Fish {
	key = "goldfish",
	atlas = "aure-allu_fish",
	pos = { x = 3, y = 0 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
	config = {
		extra = {
			
		},
	},
	environments = {
		pond = 10,
		garden = 10,
		aquifer = 7,
		chocolate_river = 3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		
	end,
}

-- Moldfish
FishAndChips.Fish {
	key = "moldfish",
	atlas = "aure-allu_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
	config = {
		extra = {
			
		},
	},
	environments = {
		backroom = 10,
		city_river = 8,
		aquifer = 6,
		swamp = 6,
		styx = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		
	end,
}

-- Shrimp
FishAndChips.Fish {
	key = "shrimp",
	atlas = "aure-allu_fish",
	pos = { x = 0, y = 1 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
	config = {
		extra = {
			
		},
	},
	environments = {
		city_river = 10,
		pier = 10,
		backroom = 4,
		soup = 5,
		wormhole = 9, 
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		
	end,
}

-- Mult Mola
FishAndChips.Fish {
	key = "mult_mola",
	atlas = "aure-allu_fish",
	pos = { x = 1, y = 1 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "mult" },
	config = {
		extra = {
			mult_per_slot = 9
		},
	},
	environments = {
		pier = 10,
		city_river = 8,
		volcano = 3,
		aquifer = 6,
		wormhole = 2,
		soup = 1,
	},
	loc_vars = function(self, info_queue, card)
		local empty = G.fac_fish_area.card_limit - #G.fac_fish_area.cards
		return { vars = { SMODS.signed(card.ability.extra.mult_per_slot), SMODS.signed(empty * card.ability.extra.mult_per_slot) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local empty = G.fac_fish_area.card_limit - #G.fac_fish_area.cards
			return {
				mult = empty * card.ability.extra.mult_per_slot
			}
		end
	end,
}

-- Eel of Fortune
FishAndChips.Fish {
	key = "eel_of_fortune",
	atlas = "aure-allu_fish",
	pos = { x = 2, y = 1 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
	config = {
		extra = {
			
		},
	},
	environments = {
		pond = 3,
		pier = 5,
		volcano = 10,
		aquifer = 8,
		styx = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		
	end,
}

-- #endregion