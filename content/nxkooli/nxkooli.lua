--[[
SMODS.Atlas({
	key = "fac_nxkooli",
	path = "nxkooli/credits.png",
	px = 71,
	py = 95,
})
]]
PotatoPatchUtils.Developer({
	name = 'Nxkoo',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.PURPLE,
	fac_partner = 'LasagnaFelidae'
})
PotatoPatchUtils.Developer({
	name = 'LasagnaFelidae',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.FILTER,
	fac_partner = 'Nxkoo'
})


--#region Fish

--inscryption
local nxkooli_pick = function(pool, roll)
	if type(pool) == "table" then
		roll = roll or pseudorandom(pseudoseed('poolroll'))
		local total = 0
		
		for _, v in ipairs(pool) do
			local w = v.weight or v[2] or 1
			total = total + w
		end
		
		local _roll = roll * total
		local w_sum = 0
		
		for _, v in ipairs(pool) do
			local w = v.weight or v[2] or 1
			w_sum = w_sum + w
			if _roll <= w_sum then
				return v.key or v[1]
			end
		end
	elseif pool then
		error("pool is not a table ({key, weight}")
	else
		error("pool is nil")
	end
end

local nxkooli_ins_fishTable = {
	{key = "nxkooli_ins_good_fish",   				weight = 8},
	{key = "m_feli_fag_gold_t2",   	weight = 1},
	{key = "m_feli_fag_gold_t3",   	weight = 0.02},
	{key = "m_feli_fag_gold_t4",   	weight = 0.001}
}

FishAndChips.Fish {
	key = "nxkooli_ins_good_fish",
	atlas = "fish",
	pos = { x = 2, y = 0 },
	weight = 1,
	cost = 4,
	ppu_coder = { "LasagnaFelidae" },
	ppu_artist = { "LasagnaFelidae" },
	attributes = { "chips", "mult", "xblind", "boss_blind" },
	config = {
		extra = {
			chips = 2,
			mult = 2,
			xblind = 0.9
		}
	},
	environments = {
		calm_pond = 1,
		wormhole = 10
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.xblind } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { chips = card.ability.extra.chips, mult = card.ability.extra.mult } end
		if context.setting_blind and context.blind ~= "Small" and context.blind ~= "Big" then return {xblind = card.ability.extra.xblind} end
	end,
}

FishAndChips.Fish {
	key = "nxkooli_ins_bad_fish",
	atlas = "fish",
	cost = 2,
	pos = { x = 2, y = 0 },
	weight = 5,
	ppu_coder = { "LasagnaFelidae" },
	ppu_artist = { "LasagnaFelidae" },
	attributes = { "mult","sucks ass" },
	config = {
		extra = {
			mult = 1
		}
	},
	environments = {
		calm_pond = 1,
		wormhole = 10
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { mult = card.ability.extra.mult } end
	end,
}

FishAndChips.Fish {
	key = "nxkooli_ins_more_fish",
	atlas = "fish",
	pos = { x = 2, y = 0 },
	weight = 4,
	cost = 2,
	ppu_coder = { "LasagnaFelidae" },
	ppu_artist = { "LasagnaFelidae" },
	attributes = { "generation", "mult" },
	config = {
		extra = {
			mult = 1
		}
	},
	environments = {
		calm_pond = 5,
		wormhole = 10
	},
	remove_from_deck = function(self, card, from_debuff)
		local key = nxkooli_pick(nxkooli_ins_fishTable,pseudorandom(pseudoseed("nxkooli_ins_more_fish")))
		SMODS.create_card({
			key = key,
			area = fac_fish_area,
			no_edition = true,
		})
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then 
			return { 
				mult = card.ability.extra.mult 
			} 
		end
	end,
}
--end inscryption
--garfield phone
FishAndChips.Fish {
	key = "nxkooli_ins_more_fish",
	atlas = "fish",
	pos = { x = 2, y = 0 },
	weight = 5,
	cost = 5,
	ppu_coder = { " " },
	ppu_artist = { "LasagnaFelidae" },
	attributes = { "generation", "mult" },
	config = {
		extra = {

		}
	},
	environments = {
		city_river = 5,
		pier = 10
	},

	loc_vars = function(self, info_queue, card)
		return { vars = { 

		 } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then 
			return { 

		 	} 
		end
	end,
}


--end garfield phone
--pronoun palace





--end pronoun palace


--#endregion
