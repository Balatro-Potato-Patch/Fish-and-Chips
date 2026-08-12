SMODS.Attribute {
    key = "Nil"
}


--#region Fish
--unless it is literally unplayable any jank in here is intended
--jank in other places is not intended tho probably fix that


FishAndChips.Fish {
	key = "mult_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil" }, 
		key = "mult"
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"mult", "Nil"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},

	calculate = function(self, card, context)
		if context.joker_main then 
return {mult = 4}
	end
end,
            
}

FishAndChips.Fish {
	key = "chips_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil" }, 
		key = "chips"
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"chips", "Nil"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},

	calculate = function(self, card, context)
		if context.joker_main then 
return {chips = 30}
	end
end,
            
}

FishAndChips.Fish {
	key = "xmult_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil" }, 
		key = "xmult", "Nil"
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"xmult"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},

	calculate = function(self, card, context)
		if context.joker_main then 
return {xmult = 1.5}
	end
end,
            
}

FishAndChips.Fish {
	key = "usable_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil" }, 
		key = "usable", "Nil"
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"usable"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},
	can_use = function(self, card)
			return true
	end,
	use = function(self, card)
                    play_sound("fac_sax4")
                    SMODS.add_card({ set = "fac_Fish", key = "fish_fac_shadowfish" })
                    card:juice_up(0.3, 0.5)
end,
            
}

FishAndChips.Fish {
	key = "economy_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil" },
		key = "economy", "Nil" 
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"economy"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},

	calculate = function(self, card, context)
		if context.selling_card then 
return {dollars = 1}
	end
end,
            
}

FishAndChips.Fish {
	key = "retrigger_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil" }, 
		key = "retrigger", "Nil"
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"retrigger"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},

	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[4] then
return{
repetitions = 1 }
end
end,
            
}

FishAndChips.Fish {
	key = "hand_level_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil", "Nil" }, 
		key = "hand_level", "Nil"
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"hand_level"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},

	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then 
return { level_up = true}
	end
end,
            
}

FishAndChips.Fish {
	key = "generation_dummy",
	atlas = "blanthos_hunter_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "" },
	loc_vars = function(self, info_queue, card)
		return { 
			vars = { "Nil" }, 
		key = "generation"
}
	end,
	environments = {
		backroom = 1
	},
	attributes = {
		"generation", "Nil"
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 0, max = 0}
	},

	calculate = function(self, card, context)
		if context.skip_blind then 
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Consumeables',
                            key_append = 'fac_shadowfish'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
end
end,
            
}
--#endregion