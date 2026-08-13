
SMODS.Atlas({
key = "fac_nxkooli_nxk",
path = "nxkooli/nikocredit.png",
px = 71,
py = 95,
})
SMODS.Atlas({
key = "fac_nxkooli_fel",
path = "nxkooli/felicredit.png",
px = 71,
py = 95,
})

PotatoPatchUtils.Developer({
	name = 'Nxkoo',
	atlas = 'fac_nxkooli_nxk',
	pos = {x = 0, y = 0},
	colour = G.C.UI.TEXT_INACTIVE,
	fac_partner = 'fac_LasagnaFelidae',
	loc = true
})

PotatoPatchUtils.Developer({
	name = 'LasagnaFelidae',
	atlas = 'fac_nxkooli_fel',
	pos = {x = 0, y = 0},
	colour = G.C.FILTER,
	fac_partner = 'fac_Nxkoo',
	loc = true
})

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
--[[

local nxkooli_ins_fishTable = {
{key = "fish_fac_nxkooli_ins_good_fish", weight = 1},
{key = "fish_fac_nxkooli_ins_bad_fish" , weight = 1},
{key = "fish_fac_nxkooli_ins_more_fish", weight = 4}
}

SMODS.Atlas({
	key = "fac_nxkooli_ins_fish",
	path = "nxkooli/ins_fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "nxkooli_ins_good_fish",
	atlas = "fac_nxkooli_ins_fish",
	pos = { x = 2, y = 0 },
	weight = 1,
	cost = 4,
	stats = {
		weight = {min = 0.30, max = 0.40},
		length = {min = 0.5, max = 0.5},
	},
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
	in_pool = function (self,args)
		if next(SMODS.find_card("nxkooli_ins_bad_fish")) and next(SMODS.find_card("nxkooli_ins_more_fish")) then
			return false
		end
		return true
	end,

	
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
	atlas = "fac_nxkooli_ins_fish",
	cost = 2,
	pos = { x = 1, y = 0 },
	weight = 1,
	stats = {
		weight = {min = 0.30, max = 0.40},
		length = {min = 0.5, max = 0.5},
	},
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
	
	add_to_deck = function(self, card, from_debuff)
		local half = math.floor(math.abs(G.GAME.fac_sand_dollars/2))
		ease_sand_dollars(-half)
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { mult = card.ability.extra.mult } end
	end,
}

FishAndChips.Fish {
	key = "nxkooli_ins_more_fish",
	atlas = "fac_nxkooli_ins_fish",
	pos = { x = 0, y = 0 },
	weight = 4,
	stats = {
		weight = {min = 0.30, max = 0.40},
		length = {min = 0.5, max = 0.5},
	},
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
		if G.fac_fish_area then
			local key = nxkooli_pick(nxkooli_ins_fishTable,pseudorandom(pseudoseed("nxkooli_ins_more_fish")))
					SMODS.add_card({
					key = key,
					area = G.fac_fish_area,
					no_edition = true,
					})
		end

		
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
SMODS.Atlas({
	key = "fac_nxkooli_garf_fish",
	path = "nxkooli/garf_fish.png",
	px = 71,
	py = 95,
})
--garfield phone
FishAndChips.Fish {
	key = "nxkooli_garfield_fish",
	atlas = "fac_nxkooli_garf_fish",
	pos = { x = 1, y = 0 },
	weight = 5,
	stats = {
		weight = {min = 3.8, max = 5.6},
		length = {min = 1, max = 1},
	},
	cost = 5,
	ppu_coder = { "LasagnaFelidae" },
	ppu_artist = { "LasagnaFelidae" },
	attributes = { "economy",},
	config = {
		extra = {
			sand_dollars = 1,
			sand_dollars_perf = 2,
		}
	},
	environments = {
		city_river = 5,
		chocolate_river = 10,
		soup = 10,
	},
	
	loc_vars = function(self, info_queue, card)
		return { vars = { 
			card.ability.extra.sand_dollars, card.ability.extra.sand_dollars_perf
		} }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing then 
			return { 
				sand_dollars = (context.perfect and card.ability.extra.sand_dollars_perf) or card.ability.extra.sand_dollars
			} 
		end
	end,
}

]]
--end garfield phone
--pronoun palace


local letters = {
	{key = "a", weight = 7.5},
	{key = "e", weight = 11.0},
	{key = "s", weight = 8.5},
	{key = "i", weight = 8.0},
	{key = "n", weight = 7.0},
	{key = "r", weight = 7.0},
	{key = "o", weight = 6.0},
	{key = "t", weight = 6.0},
	{key = "l", weight = 5.0},
	{key = "c", weight = 4.0},
	{key = "d", weight = 3.5},
	{key = "u", weight = 3.3},
	{key = "g", weight = 3.0},
	{key = "p", weight = 3.0},
	{key = "m", weight = 2.7},
	{key = "h", weight = 2.3},
	{key = "b", weight = 2.2},
	{key = "y", weight = 1.6},
	{key = "f", weight = 1.4},
	{key = "k", weight = 1.0},
	{key = "v", weight = 1.0},
	{key = "w", weight = 1.0},
	{key = "j", weight = 1.0},
	{key = "q", weight = 1.0},
	{key = "x", weight = 1.0},
	{key = "z", weight = 1.0},
	{key = "*", weight = 0.5}
}

local types = {
	{key = "wood", weight = 1.0,},
	{key = "plastic", weight = 1.0,},
	{key = "crit", weight = 0.5,},
	{key = "crit_plastic", weight = 0.5,},
}
local letter_value = {
	["a"] = {value = 1, x = 0},
	["e"] = {value = 1, x = 4},
	["s"] = {value = 1, x = 18},
	["i"] = {value = 1, x = 8},
	["n"] = {value = 1, x = 13},
	["r"] = {value = 1, x = 17},
	["o"] = {value = 1, x = 14},
	["t"] = {value = 1, x = 19},
	["l"] = {value = 1, x = 11},
	["c"] = {value = 1, x = 2},
	["d"] = {value = 1, x = 3},
	["u"] = {value = 1, x = 20},
	["g"] = {value = 1, x = 6},
	["p"] = {value = 2, x = 15},
	["m"] = {value = 2, x = 12},
	["h"] = {value = 2, x = 7},
	["b"] = {value = 2, x = 1},
	["y"] = {value = 2, x = 24},
	["f"] = {value = 2, x = 5},
	["k"] = {value = 3, x = 10},
	["v"] = {value = 3, x = 21},
	["w"] = {value = 3, x = 22},
	["j"] = {value = 3, x = 9},
	["q"] = {value = 3, x = 16},
	["x"] = {value = 3, x = 23},
	["z"] = {value = 3, x = 25},
	["*"] = {value = 1, x = 26},
}
local type_y = {
	["wood"] = 0,
	["plastic"] = 1,
	["crit"] = 2,
	["crit_plastic"] = 3,
}

SMODS.Atlas({
	key = "fac_nxkooli_pp_fish",
	path = "nxkooli/pp_fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "nxkooli_pp_tile",
	atlas = "fac_nxkooli_pp_fish",
	pos = { x = 26, y = 0 },
	weight = 75,
	stats = {
		weight = {min = 1, max = 2},
		length = {min = 0.6, max = 0.6},
	},
	cost = 5,
	ppu_coder = { "LasagnaFelidae", "Nxkoo" },
	ppu_artist = { "LasagnaFelidae", "Nxkoo" },
	attributes = { "mult", "chips", "xchips", "xmult" },
	config = {
		extra = {
			wood = 1,
			plastic = 10,
			xval = 0.1,
		},
		letter = "*",
		is_plastic = false,
		is_crit = false,
	},
	environments = {
		city_river = 5,
		wormhole = 5,
	},
	
	locCount = function(self, field)
		if not field then return "" end

		local text = ""
		
		if type(field) == "string" then
			text = text .. " " .. field
			return text
		end
		
		if type(field) ~= "table" then
			return ""
		end
		
		for _, line in ipairs(field) do
			if type(line) == "table" then
				for _, segment in ipairs(line) do
					if type(segment) == "string" then
						text = text .. " " .. segment
					end
				end
			elseif type(line) == "string" then
				text = text .. " " .. line
			end
		end
		return text
	end,
	wildcard = function(self, key)
		local localization = G.localization.descriptions["fac_Fish"] and G.localization.descriptions["fac_Fish"][key]
		if not localization then return "a" end
		
		local text = ""
		
		text = text .. self:locCount(localization.name)
		text = text .. self:locCount(localization.flavor or localization.flavour)
		
		if text == "" then return "a" end
		
		local ctext = text:gsub("[^%a]", ""):lower()
		
		local counts = {}
		for char in ctext:gmatch("%a") do
			counts[char] = (counts[char] or 0) + 1
		end
		
		local best_letter = "a"
		local best_count = 0
		
		for letter, count in pairs(counts) do
			if count > best_count then
				best_count = count
				best_letter = letter
			end
		end
		
		print(best_letter)
		return best_letter
	end,
	
	countLetters = function(self, key, letter)
		local localization = G.localization.descriptions["fac_Fish"] and G.localization.descriptions["fac_Fish"][key]
		if not localization then return 0 end
		
		local text = ""
		
		
		text = text .. self:locCount(localization.name)
		text = text .. self:locCount(localization.flavor or localization.flavour)
		
		
		
		if text == "" then return 0 end
		
		local ctext = text:gsub("[^%a]", ""):lower()
		
		
		local count = 0
		if letter == "*" then
			letter = self:wildcard(key)
		end
		for char in ctext:gmatch("%a") do
			if char == letter:lower() then
				count = count + 1
			end
		end
		
		return count
	end,
	
	load = function (self,card)
		local y = 0
		G.E_MANAGER:add_event(Event({
			func = function() 
				if card.ability.is_plastic then
					if card.ability.is_crit then
						y = type_y["crit_plastic"]
					else
						y = type_y["plastic"]
					end
				elseif card.ability.is_crit then
					y = type_y["crit"]
				else
					y = type_y["wood"]
				end
				card.children.center:set_sprite_pos({
					x = letter_value[card.ability.letter] and letter_value[card.ability.letter].x or 26,
					y = y,
				})
				return true 
			end
		}))
	end,
	
	loc_vars = function(self, info_queue, card)
		
		
		local color = card.ability.is_plastic and G.C.CHIPS or G.C.MULT
		local value = card.ability.is_plastic and card.ability.extra.plastic or card.ability.extra.wood
		local type = card.ability.is_plastic and "Chips" or "Mult"
		local _key = card.ability.is_crit and self.key.."_crit" or self.key
		local every = card.ability.letter == "*" and "most frequent" or "every"
		local every_letter = card.ability.letter == "*" and "letter" or ("\"" .. (card.ability.letter or "?") .. "\"")
		local material = card.ability.is_plastic and "Plastic " or "Wooden "
		local crit = card.ability.is_crit and "Crit " or ""
		local other_fish = nil
		if G.fac_fish_area then
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then other_fish = G.fac_fish_area.cards[i + 1] end
			end
		end
			
		if not other_fish or not other_fish.config or not other_fish.config.center or not other_fish.config.center.key then other_fish = nil end

		local count = other_fish and self:countLetters(other_fish.config.center.key, card.ability.letter) or 0
		local total_value = value * count
		local total_value_x = 1 + (card.ability.extra.xval * count)
		
		local ret = {}
		ret.key = _key
		ret.vars = {
			card.ability.letter, 
			letter_value[card.ability.letter].value or 1,
			value * (letter_value[card.ability.letter].value or 1),
			type,
			card.ability.extra.xval,
			every_letter,
			every,
			total_value, total_value_x,
			material,crit,
			
			colours = {color}
		}
		return ret
	end,
	calculate = function(self, card, context)
		if context.joker_main then 
			local ret = {}
			local letter = card.ability.letter
			local value = letter_value[letter].value or 1
			
			local is_plastic = card.ability.is_plastic
			local is_crit = card.ability.is_crit

			local other_fish = nil
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then other_fish = G.fac_fish_area.cards[i + 1] end
			end
			
			if not other_fish or not other_fish.config or not other_fish.config.center or not other_fish.config.center.key then return {} end
			
			
			fish_key = other_fish.config.center.key
			local count = self:countLetters(fish_key, letter)
			
			
			local base = is_plastic and card.ability.extra.plastic or card.ability.extra.wood
			
			local is_crit = card.ability.is_crit
			
			if is_plastic then
				ret.chips = base * count
			else
				ret.mult = base * count
			end
			
			if is_crit then
				if is_plastic then
					ret.xchips = 1 + (card.ability.extra.xval * count)
				else
					ret.xmult = 1 + (card.ability.extra.xval * count)
				end
			end
			
			return ret
		end
		
		if context.after then 
			G.E_MANAGER:add_event(Event({
			func = function() 
				local back = nxkooli_pick(types, pseudorandom(pseudoseed("nxkooli_pp_tile_after")))
				if back == "plastic" or back == "crit_plastic" then
					card.ability.is_plastic = true
				else
					card.ability.is_plastic = false
				end
				if back == "crit" or back == "crit_plastic" then
					card.ability.is_crit = true
				else
					card.ability.is_crit = false
				end
				local letter = nxkooli_pick(letters, pseudorandom(pseudoseed("nxkooli_pp_tile_after")))
				card.ability.letter = letter
				
				card.children.center:set_sprite_pos({
					x = letter_value[letter] and letter_value[letter].x or 26,
					y = type_y[back] and type_y[back] or 0,
				})
				return true 
				end
			}))
		end
		
		
		
	end,
	
}




--end pronoun palace


--#endregion
