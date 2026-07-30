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
	path = "core/cards.png",
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
		
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		
	end,
}