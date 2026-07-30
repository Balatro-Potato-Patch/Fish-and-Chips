PotatoPatchUtils.Developer({
	name = 'SLDTyp0',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	fac_partner = 'TigerThawk' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'TigerThawk',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.YELLOW,
	fac_partner = 'SLDTyp0'
})

SMODS.Atlas({
	key = "typ0", -- Please include your name/team name in your atlas keys
	path = "Typ0/fish.png",
	px = 71,
	py = 95,
})

--#region Fish

FishAndChips.Fish {
	key = "Whale",
	atlas = "typ0",
	pos = { x = 1, y = 1 },
	weight = 5,
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "TigerThawk" },
	attributes = { "retrigger" },
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
	pos = { x = 0, y = 0 },
	weight = 10,
	cost = 0,
	ppu_coder = { "SLDTyp0" },
	ppu_artist = { "SLDTyp0" },
	attributes = { "mult" },
	config = {
		extra = {
			mult = 1
		}
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
		return
	end,
}

--#endregion
