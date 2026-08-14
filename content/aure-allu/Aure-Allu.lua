local tiger2
SMODS.Atlas {
	key = "aure_tiger2",
	path = "aure-allu/tiger2.png",
	px = 36,
	py = 36,
	inject = function(...)
		SMODS.Atlas.inject(...)
		tiger2 = SMODS.create_sprite(0, 0, 0.5, 0.5, "fac_aure_tiger2")
	end
}
local fishee2
SMODS.Atlas {
	key = "allu_fishee2",
	path = "aure-allu/fishee2.png",
	px = 36,
	py = 36,
	inject = function(...)
		SMODS.Atlas.inject(...)
		fishee2 = SMODS.create_sprite(0, 0, 0.5, 0.5, "fac_allu_fishee2")
	end
}

PotatoPatchUtils.Developer({
	name = 'Aure',
	atlas = 'fac_aureallu_cards',
	colour = G.C.ORANGE,
	fac_partner = 'fac_AllUniversal',
	loc = true,
	loc_vars = function(self, info_queue, card) 
		return {vars = { elements = { tiger2 }}}
	end,
})

PotatoPatchUtils.Developer({
	name = 'AllUniversal',
	atlas = 'fac_aureallu_cards',
	pos = {x = 1, y = 0},
	colour = G.C.GREY,
	fac_partner = 'fac_Aure',
	loc = true,
	loc_vars = function(self, info_queue, card) 
		return {vars = { elements = { fishee2 }}}
	end,
})

SMODS.Atlas({
	key = "aureallu_cards",
	path = "aure-allu/cards.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "aureallu_fish",
	path = "aure-allu/fishee.png",
	px = 71,
	py = 95,
})


SMODS.Gradient {
	key = "allu_bl_wh_g",
	colours = {
		HEX("000000"),
		HEX("FFFFFF"),
	},
	cycle = 9.14,
	inject = function (self, i)
		SMODS.Gradient.inject(self, i)
		PotatoPatchUtils.Developers.fac_AllUniversal.colour = self
	end
}

SMODS.Gradient {
	key = "allu_fire_g",
	colours = {
		HEX("FF6F00"),
		HEX("FF4400"),
		HEX("FF6F00"),
		HEX("FF684D"),
		HEX("FFC2B8"),
		HEX("FFE8E8"),
		HEX("FAA97A"),
		HEX("F5A536"),
		HEX("F5C836"),
		HEX("FF4400"),
	},
	cycle = 5,
}

local zero_signed = function (value, infix)
	local v = value ~= 0 and SMODS.signed(value) or "+0"
	return string.sub(v, 1, 1) .. (infix or "") .. string.sub(v, 2)
end


local filter_list = function (t, exclude_map)
	local out = {}
	exclude_map = exclude_map or {}
	for i, elem in ipairs(t) do
		if not exclude_map[elem] then table.insert(out, elem) end
	end
	return out
end

local function table_find(t, value)
	if not type(t) == "table" then return end
	for k, v in pairs(t) do
		if v == value then return k end
	end
	return nil
end

local function table_get_subfield(_table, key_string_or_keys)
    if type(_table) ~= "table" then sendWarnMessage("table_get_subfield called with invalid table argument", "utils"); return end 
    if type(key_string_or_keys) ~= "string" and type(key_string_or_keys) ~= "table" then sendWarnMessage(string.format("table_get_subfield called with invalid key_string '%s'.", key_string_or_keys), "utils"); return end
    local _t = _table
    if type(key_string_or_keys) == "string" then
        for field in string.gmatch(key_string_or_keys, "[^.]+") do
            _t = _t[field]
            if not _t then return end
        end
    else 
        for _, field in ipairs(key_string_or_keys) do
            _t = _t[field]
            if not _t then return end
        end
    end
    return _t
end


--#region Fish

-- The Original     Starfish
local function get_most_played_pokerhand()
	local _handname, _played, _order = 'High Card', -1, 100
	for k, v in pairs(G.GAME.hands) do
		if v.played > _played or (v.played == _played and _order > v.order) then 
			_played = v.played
			_handname = k
		end
	end
	return _handname
end

local starwalker_col = HEX("fef200")
FishAndChips.Fish {
	key = "aureallu_the_original___starfish",
	atlas = "aureallu_fish",
	pos = { x = 0, y = 0 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "space", "hand_level" },
	stats = {weight = {min = 12, max = 25}, length = {min = 1.4, max = 1.6}},
	blueprint_compat = false,
	config = {
		extra = {
			hand_levels = 2,
		}
	},
	environments = {
		calm_pond = 10,
		pier = 10,
		city_river = 10,
		-- swamp = 10,
		volcano = 10,
		-- aquifer = 10,
		garden = 10,
		-- styx = 10,
		-- chocolate_river = 10,
		wormhole = 10,
		-- backroom = 10,
		-- soup = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { zero_signed(card.ability.extra.hand_levels), get_most_played_pokerhand(), colours = { starwalker_col }} }
	end,
	use = function (self, card)
		SMODS.smart_level_up_hand(card, get_most_played_pokerhand(), nil, card.ability.extra.hand_levels)
	end,
	can_use = function (self, card)
		return true
	end,
	on_catch = function (self, card)
		G.E_MANAGER:add_event(Event({
			func = function ()
				attention_text({
					text = localize('k_aureallu_starfish_1'),
					scale = 1.1,
					hold = 0.7 * G.SETTINGS.GAMESPEED,
					major = card,
					backdrop_colour = starwalker_col,
					align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
						'tm' or 'cm',
					offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
					noisy = true
				})
				return true
			end
		}))
		delay(0.7 * G.SETTINGS.GAMESPEED)
		G.E_MANAGER:add_event(Event({
			func = function ()
				attention_text({
					text = localize('k_aureallu_starfish_2'),
					scale = 1.1,
					hold = 0.7 * G.SETTINGS.GAMESPEED,
					major = card,
					backdrop_colour = FishAndChips.C.FISH,
					align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
						'tm' or 'cm',
					offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
					noisy = true
				})
				return true
			end
		}))
		delay(0.7 * G.SETTINGS.GAMESPEED)
		G.E_MANAGER:add_event(Event({
			func = function ()
				attention_text({
					text = localize('k_aureallu_starfish_3'),
					scale = 1.1,
					hold = 0.7 * G.SETTINGS.GAMESPEED, 
					major = card,
					backdrop_colour = starwalker_col,
					align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
						'tm' or 'cm',
					offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
					noisy = true
				})
				return true
			end
		}))
		delay(0.3 * G.SETTINGS.GAMESPEED)
	end
}

-- Cheap Cheep
FishAndChips.Fish {
	key = "aureallu_cheap_cheep",
	atlas = "aureallu_fish",
	pos = { x = 1, y = 0 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "chance", "economy" },
	stats = {weight = {min = 7, max = 140}, length = {min = 0.8, max = 4.5}},
	blueprint_compat = false,
	config = {
		extra = {
			refund_sand_dollars = 2,
			refund_odds = 3,
		},
	},
	environments = {
		pier = 10,
		swamp = 5,
		city_river = 8,
		garden = 7,
	},
	loc_vars = function(self, info_queue, card)
		local numerator_cheap, denominator_cheap = SMODS.get_probability_vars(card, 1, card.ability.extra.refund_odds, "fac_aureallu_cheap_cheep")
		return { vars = { numerator_cheap, denominator_cheap, card.ability.extra.refund_sand_dollars } }
	end,
	calculate = function(self, card, context)
		if context.fac_buy_bait and not context.blueprint_card and SMODS.pseudorandom_probability(card, "fac_aureallu_cheap_cheep", 1, card.ability.extra.refund_odds) then
			return {
				sand_dollars = card.ability.extra.refund_sand_dollars
			}
		end
		return nil, true
	end,
}

-- Blooper
FishAndChips.Fish {
	key = "aureallu_blooper",
	atlas = "aureallu_fish",
	pos = { x = 2, y = 0 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "xchips", "face_down" },
	stats = {weight = {min = 6, max = 17}, length = {min = 0.9, max = 1.5}},
	blueprint_compat = true,
	config = {
		extra = {
			face_down_x_chips = 0.2,
		},
	},
	environments = {
		pier = 8,
		swamp = 8,
		city_river = 10,
		aquifer = 4,
	},
	loc_vars = function(self, info_queue, card)
		local total = 1
		if G.hand then
			for _, pcard in ipairs(G.hand.cards) do
				if pcard.facing == "back" then
					total = total + card.ability.extra.face_down_x_chips
				end
			end
		end
		return { vars = { card.ability.extra.face_down_x_chips, total } }
	end,
	calculate = function(self, card, context)
		if context.stay_flipped and not context.blueprint_card and context.from_area == G.deck and context.to_area == G.hand and G.GAME.current_round.hands_played == 0 then
            return {
                stay_flipped = true,
            }
		elseif context.first_hand_drawn and not context.blueprint_card then
			return {
				message = localize("k_aurall_blooper"),
				colour = G.C.BLACK
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
	key = "aureallu_goldfish",
	atlas = "aureallu_fish",
	pos = { x = 3, y = 0 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "passive", "economy" },
	stats = {weight = {min = 0.4, max = 0.9}, length = {min = 0.05, max = 0.12}},
	blueprint_compat = false,
	config = {
		extra = {
			sand_dollars_gain = 3
		},
	},
	environments = {
		calm_pond = 10,
		garden = 9,
		aquifer = 3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.sand_dollars_gain } }
	end,
	calculate = function(self, card, context)
		if context.ending_fishing and not context.blueprint_card then
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.sand_dollars_gain
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = FishAndChips.C.SAND_DOLLAR
			}
		end
	end,
}

-- Moldfish
local function get_average_property(cards, property)
	if #cards <= 0 then return 0 end
	local total = 0
	for i, card in ipairs(cards) do
		total = total + (table_get_subfield(card, property) or 0)
	end
	return total / #cards
end

local end_round_ref = end_round
function end_round(...)
	end_round_ref(...)
	for _, area in ipairs({G.jokers, G.consumeables, G.fac_fish_area}) do
		for _, card in ipairs(area.cards) do
			card.ability.rounds_held = card.ability.rounds_held and card.ability.rounds_held + 1 or 1
		end
	end
end

FishAndChips.Fish {
	key = "aureallu_moldfish",
	atlas = "aureallu_fish",
	pos = { x = 4, y = 0 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "mult", "scaling" },
	stats = {weight = {min = 0.3, max = 0.8}, length = {min = 0.04, max = 0.11}},
	blueprint_compat = true,
	config = {
		extra = {
			mult_per_average_round = 9
		},
	},
	environments = {
		backroom = 10,
		city_river = 8,
		aquifer = 6,
		swamp = 6,
	},
	loc_vars = function(self, info_queue, card)
		local average = G.fac_fish_area and get_average_property(G.fac_fish_area.cards, "ability.rounds_held") or 0
		return { vars = { zero_signed(card.ability.extra.mult_per_average_round), zero_signed(math.floor(card.ability.extra.mult_per_average_round * average)) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
                mult = math.floor(card.ability.extra.mult_per_average_round * get_average_property(G.fac_fish_area.cards, "ability.rounds_held"))
            }
		end
	end,
}

-- Shrimp
FishAndChips.Fish {
	key = "aureallu_shrimp",
	atlas = "aureallu_fish",
	pos = { x = 0, y = 1 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "mult", "scaling", "position", },
	stats = {weight = {min = 0.04, max = 0.20}, length = {min = 0.06, max = 0.09}},
	blueprint_compat = true,
	config = {
		extra = {
			mult_gain = 1,
			total_mult = 0,
		},
		immutable = {
			last_slots = {},
			last_slots_max = 2,
		}
	},
	environments = {
		city_river = 10,
		pier = 10,
		backroom = 4,
		soup = 5,
		wormhole = 9, 
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { zero_signed(card.ability.extra.mult_gain), card.ability.immutable.last_slots_max, zero_signed(card.ability.extra.total_mult) } }
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint_card then
            local same_slot = false
			local slot = table_find(G.fac_fish_area.cards, card)
			for _, prev_slot in ipairs(card.ability.immutable.last_slots) do
				if prev_slot == slot then
					same_slot = true; break
				end
			end
			if #card.ability.immutable.last_slots >= card.ability.immutable.last_slots_max then table.remove(card.ability.immutable.last_slots, 1) end
			table.insert(card.ability.immutable.last_slots, slot)
            if same_slot then
                local last_mult = card.ability.extra.total_mult
                card.ability.extra.total_mult = 0
                if last_mult > 0 then
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                card.ability.extra.total_mult = card.ability.extra.total_mult + card.ability.extra.mult_gain
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.total_mult
            }
        end
	end,
}

-- Mult Mola
FishAndChips.Fish {
	key = "aureallu_mult_mola",
	atlas = "aureallu_fish",
	pos = { x = 1, y = 1 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "mult" },
	stats = {weight = {min = 0.5, max = 60}, length = {min = 0.07, max = 2.3}},
	blueprint_compat = true,
	config = {
		extra = {
			mult_per_slot = 9
		},
	},
	environments = {
		pier = 10,
		city_river = 8,
		volcano = 3,
		wormhole = 2,
		soup = 1,
	},
	loc_vars = function(self, info_queue, card)
		local empty = G.fac_fish_area and G.fac_fish_area.config.card_limits.base - #G.fac_fish_area.cards or 0
		return { vars = { zero_signed(card.ability.extra.mult_per_slot), zero_signed(empty * card.ability.extra.mult_per_slot) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local empty = G.fac_fish_area.config.card_limits.base - #G.fac_fish_area.cards
			return {
				mult = empty * card.ability.extra.mult_per_slot
			}
		end
	end,
}

-- Eel of Fortune
FishAndChips.Fish {
	key = "aureallu_eel_of_fortune",
	atlas = "aureallu_fish",
	pos = { x = 2, y = 1 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "chance", "modify_card" },
	stats = {weight = {min = 0.5, max = 9.9}, length = {min = 0.5, max = 3.4}},
	blueprint_compat = false,
	config = {
		extra = {
			eel_odds = 4
		},
	},
	environments = {
		pier = 5,
		volcano = 10,
		aquifer = 8,
		swamp = 8,
		styx = 3,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_foil
		info_queue[#info_queue+1] = G.P_CENTERS.e_holo
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
		local numerator_eel, denominator_eel = SMODS.get_probability_vars(card, 1, card.ability.extra.eel_odds, "fac_aureallu_eel_of_fortune")
		return { vars = { numerator_eel, denominator_eel } }
	end,
	use = function (self, card)
		-- Thanks https://github.com/nh6574/VanillaRemade/blob/main/src/tarots.lua Wheel of Fortune
		if SMODS.pseudorandom_probability(card, 'fac_aureallu_eel_of_fortune', 1, card.ability.extra.eel_odds) then
            local editionless_fishee = SMODS.Edition:get_edition_cards({cards = filter_list(G.fac_fish_area.cards, {[card] = true})}, true)
            local eligible_card = pseudorandom_element(editionless_fishee, 'fac_aureallu_eel_of_fortune')
            local edition = SMODS.poll_edition { key = "fac_aureallu_eel_of_fortune", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
            eligible_card:set_edition(edition, true)
            check_for_unlock({ type = 'have_edition' })
        else
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = FishAndChips.C.FAC_PRIMARY,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
	end,
	can_use = function (self, card)
		return next(SMODS.Edition:get_edition_cards({cards = filter_list(G.fac_fish_area.cards, {[card] = true})}, true))
	end
}

-- Gouramichel
FishAndChips.Fish {
	key = "aureallu_gouramichel",
	atlas = "aureallu_fish",
	pos = { x = 3, y = 1 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "chips", "chance", "food"  },
	stats = {weight = {min = 0.3, max = 0.9}, length = {min = 0.067, max = 0.15}},
	blueprint_compat = true,
	config = {
		extra = {
			chips = 61,
			michel_odds = 5
		},
	},
	environments = {
		aquifer = 8,
		chocolate_river = 7,
		soup = 10,
	},
	loc_vars = function(self, info_queue, card)
		local numerator_michel, denominator_michel = SMODS.get_probability_vars(card, 1, card.ability.extra.michel_odds, "fac_aureallu_gouramichel")
		return { vars = { zero_signed(card.ability.extra.chips), numerator_michel, denominator_michel } }
	end,
	calculate = function(self, card, context)
		-- Thanks once more, Vanillaremade !!
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint_card then
            if SMODS.pseudorandom_probability(card, 'fac_aureallu_gouramichel', 1, card.ability.extra.michel_odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.fac_aureallu_gouramichel = true
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
		elseif context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
	end,
	in_pool = function(self, args)
        return not G.GAME.pool_flags.fac_aureallu_gouramichel
    end
}

-- Cavenfish
FishAndChips.Fish {
	key = "aureallu_cavenfish",
	atlas = "aureallu_fish",
	pos = { x = 4, y = 1 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "xchips", "chance", "food" },
	stats = {weight = {min = 0.4, max = 1.0}, length = {min = 0.07, max = 0.2}},
	blueprint_compat = true,
	config = {
		extra = {
			x_chips = 3,
			cavenfish_odds = 914
		},
	},
	environments = {
		aquifer = 8,
		chocolate_river = 7,
		soup = 10,
		wormhole = 4,
	},
	loc_vars = function(self, info_queue, card)
		local numerator_cavenfish, denominator_cavenfish = SMODS.get_probability_vars(card, 1, card.ability.extra.cavenfish_odds, "fac_aureallu_cavenfish")
		return { vars = { card.ability.extra.x_chips, numerator_cavenfish, denominator_cavenfish } }
	end,
	calculate = function(self, card, context)
		-- Thanks once more, Vanillaremade !!
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint_card then
            if SMODS.pseudorandom_probability(card, 'fac_aureallu_cavenfish', 1, card.ability.extra.cavenfish_odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
		elseif context.joker_main then
			return {
				x_chips = card.ability.extra.x_chips
			}
		end
	end,
	in_pool = function(self, args)
        return G.GAME.pool_flags.fac_aureallu_gouramichel
    end
}

-- Hammerjaw
FishAndChips.Fish {
	key = "aureallu_hammerjaw",
	atlas = "aureallu_fish",
	pos = { x = 0, y = 2 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "destroy_card" },
	stats = {weight = {min = 0.5, max = 2.0}, length = {min = 0.09, max = 0.14}},
	blueprint_compat = false,
	requires_hand = true,
	config = {
		extra = {
			max_cards = 4
		},
	},
	environments = {
		pier = 5,
		city_river = 8,
		volcano = 10,
		aquifer = 6,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_cards } }
	end,
	use = function (self, card)
		--Thanks https://github.com/nh6574/VanillaRemade/blob/main/src/tarots.lua The Hanged Man
		local number = #G.hand.highlighted
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.1, 
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.1, 
			func = function()
				SMODS.destroy_cards(G.hand.highlighted, {immediate = true})
				return true
			end
		}))
        delay(0.1)
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.5, 
			func = function()
				local count = G.hand.config.card_limit - #G.hand.cards + number
				if count <= 0 then return end
				for i=1, count do
					local percent = 1.15 - (i - 0.999) / (count - 0.998) * 0.3
					G.E_MANAGER:add_event(Event({
						trigger = "after", 
						delay = 0.2, 
						func = function()
							play_sound('card1', percent)
							G.hand:draw_card_from(G.deck, false, false)
							return true
						end
					}))
				end
				return true
			end
		}))
	end,
	can_use = function (self, card)
		return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_cards
	end
}

-- Blue Garden Gnome
FishAndChips.Fish {
	key = "aureallu_blue_garden_gnome",
	atlas = "aureallu_fish",
	pos = { x = 1, y = 2 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "passive", "economy" },
	stats = {weight = {min = 1.2, max = 1.3}, length = {min = 0.24, max = 0.27}},
	treasure = true,
	blueprint_compat = false,
	config = {
		extra = {
			x_treasure = 1.5
		},
	},
	environments = {
		garden = 10,
		city_river = 2,
		styx = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_treasure } }
	end,
	calculate = function(self, card, context)
		if context.fishing_profile then
			context.fishing_profile.treasure_gain = context.fishing_profile.treasure_gain * card.ability.extra.x_treasure
		elseif context.fac_treasure_reward then
			context.fac_treasure_reward = math.floor(context.fac_treasure_reward * card.ability.extra.x_treasure)
		end
	end,
}

-- Bat Ray
FishAndChips.Fish {
	key = "aureallu_bat_ray",
	atlas = "aureallu_fish",
	pos = { x = 2, y = 2 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "face_down" },
	stats = {weight = {min = 0.8, max = 3}, length = {min = 0.13, max = 0.33}},
	blueprint_compat = false,
	requires_hand = true,
	config = {
		extra = {
			max_cards = 5,
			max_uses = 2,
			remaining_uses = 2,
		},
	},
	environments = {
		city_river = 9,
		volcano = 6,
		aquifer = 10,
		backroom = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_cards, card.ability.extra.remaining_uses, card.ability.extra.max_uses } }
	end,
	calculate = function (self, card, context)
		if context.end_of_round and not context.game_over and context.main_eval then
			local before = card.ability.extra.remaining_uses
			card.ability.extra.remaining_uses = card.ability.extra.max_uses
			if before < card.ability.extra.max_uses then
				return {
					message = localize("k_reset"),
					colour = G.C.IMPORTANT
				}
			end
		end
	end,
	use = function (self, card)
		--Thanks https://github.com/nh6574/VanillaRemade/blob/main/src/tarots.lua The Hanged Man
		card.ability.extra.remaining_uses = card.ability.extra.remaining_uses - 1
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.1, 
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
		end
	end,
	keep_on_use = function (self, card)
		return true
	end,
	can_use = function (self, card)
		return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_cards and card.ability.extra.remaining_uses > 0
	end
}

-- Cowfish
local use_and_sell_ref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	use_and_sell_card = card
	local ret = use_and_sell_ref(card)
	use_and_sell_card = nil
	return ret
end

local localize_ref = localize
function localize(args, ...)
	if args == "b_use" and use_and_sell_card then
		args = ((use_and_sell_card.config or {}).center or {}).use_button_loc_key or args
	end
	local ret = localize_ref(args, ...)
	return ret
end

FishAndChips.Fish {
	key = "aureallu_cowfish",
	atlas = "aureallu_fish",
	pos = { x = 3, y = 2 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "spectral", "generation" },
	stats = {weight = {min = 0.9, max = 1.4}, length = {min = 0.08, max = 0.25}},
	blueprint_compat = false,
	config = {
		extra = {
			rounds_total = 0,
			rounds_needed = 2,
		},
	},
	environments = {
		garden = 5,
		chocolate_river = 10,
		wormhole = 2,
		soup = 8,
	},
	use_button_loc_key = "k_aureallu_milk_button",
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.rounds_total, card.ability.extra.rounds_needed } }
	end,
	calculate = function (self, card, context)
		if context.end_of_round and not context.game_over and context.main_eval then
			card.ability.extra.rounds_total = card.ability.extra.rounds_total + 1
			if card.ability.extra.rounds_total >= card.ability.extra.rounds_needed then
				juice_card_until(card, function ()
					return card.ability.extra.rounds_total >= card.ability.extra.rounds_needed and not G.RESET_JIGGLES
				end)
			end
			return {
				message = (card.ability.extra.rounds_total < card.ability.extra.rounds_needed) and (card.ability.extra.rounds_total..'/'..card.ability.extra.rounds_needed) or localize('k_active_ex'),
				colour = FishAndChips.C.FISH
			}
		end
	end,
	use = function (self, card)
		card.ability.extra.rounds_total = 0
		G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.1, 
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		G.E_MANAGER:add_event(Event({
			func = (function()
				SMODS.add_card({set = 'Spectral'})
				G.GAME.consumeable_buffer = 0
				return true
			end)
		}))
	end,
	keep_on_use = function (self, card)
		return true
	end,
	can_use = function (self, card)
		return G.consumeables and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and card.ability.extra.rounds_total >= card.ability.extra.rounds_needed
	end
}

-- Soldierfish
FishAndChips.Fish {
	key = "aureallu_soldierfish",
	atlas = "aureallu_fish",
	pos = { x = 4, y = 2 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable" },
	stats = {weight = {min = 1.0, max = 2.5}, length = {min = 0.2, max = 0.7}},
	blueprint_compat = false,
	requires_hand = true,
	config = {
		extra = {
			extra_draw = 2,
			cost = 4,
			cost_increase = 3,
		},
	},
	environments = {
		pier = 2,
		styx = 10,
		wormhole = 4,
		backroom = 7,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.extra_draw, card.ability.extra.cost + (card.ability.used_this_round and card.ability.extra.cost_increase or 0), card.ability.extra.cost_increase } }
	end,
	calculate = function (self, card, context)
		if context.end_of_round and not context.game_over and context.main_eval then
			card.ability.used_this_round = nil
		end
	end,
	use = function (self, card)
		local was_used = card.ability.used_this_round
		card.ability.used_this_round = true
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.1, 
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				if was_used then
					card.ability.extra.cost = card.ability.extra.cost + card.ability.extra.cost_increase
				end
				ease_dollars(-card.ability.extra.cost)
				return true
			end
		}))
		delay(0.1)
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.5, 
			func = function()
				local count = math.max(G.hand.config.card_limit - #G.hand.cards, 0) + card.ability.extra.extra_draw
				for i=1, count do
					local percent = 1.15 - (i - 0.999) / (count - 0.998) * 0.3
					G.E_MANAGER:add_event(Event({
						trigger = "after", 
						delay = 0.2, 
						func = function()
							play_sound('card1', percent)
							G.hand:draw_card_from(G.deck, false, false)
							return true
						end
					}))
				end
				return true
			end
		}))
	end,
	keep_on_use = function (self, card)
		return true
	end,
	can_use = function (self, card)
		return G.hand and #G.hand.cards > 0 and #G.deck.cards > 0 and G.GAME.dollars >= card.ability.extra.cost + (card.ability.used_this_round and card.ability.extra.cost_increase or 0)
	end
}

-- Unicorn Fish
FishAndChips.Fish {
	key = "aureallu_unicorn_fish",
	atlas = "aureallu_fish",
	pos = { x = 0, y = 3 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "tag", "chance" },
	stats = {weight = {min = 0.9, max = 2.7}, length = {min = 0.1, max = 0.4}},
	blueprint_compat = false,
	config = {
		extra = {
			tag_odds = 2
		},
	},
	environments = {
		calm_pond = 4,
		garden = 8,
		chocolate_river = 10,
		wormhole = 3,
		backroom = 2,
		soup = 5,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_TAGS.tag_rare
		local numerator_unicorn, denominator_unicorn = SMODS.get_probability_vars(card, 1, card.ability.extra.tag_odds, "fac_aureallu_unicorn_fish")
		return { vars = { numerator_unicorn, denominator_unicorn } }
	end,
	use = function (self, card)
		if SMODS.pseudorandom_probability(card, "fac_aureallu_unicorn_fish", 1, card.ability.extra.tag_odds) then
			G.E_MANAGER:add_event(Event({
				trigger = "after", 
				delay = 0.1, 
				func = function()
					play_sound('tarot1')
					card:juice_up(0.3, 0.5)
					add_tag({key="tag_rare"})
					play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
					play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
					attention_text({
						text = localize('k_aureallu_unicorn'),
						scale = 1.3,
						hold = 1.4,
						major = card,
						backdrop_colour = HEX("fca6e9"),
						align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
							'tm' or 'cm',
						offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
						silent = true
					})
					return true
				end
			}))
		else
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					attention_text({
						text = localize('k_nope_ex'),
						scale = 1.3,
						hold = 1.4,
						major = card,
						backdrop_colour = FishAndChips.C.FAC_PRIMARY,
						align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
							'tm' or 'cm',
						offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
						silent = true
					})
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.06 * G.SETTINGS.GAMESPEED,
						blockable = false,
						blocking = false,
						func = function()
							play_sound('tarot2', 0.76, 0.4)
							return true
						end
					}))
					play_sound('tarot2', 1, 0.4)
					card:juice_up(0.3, 0.5)
					return true
				end
			}))
		end
	end,
	can_use = function (self, card)
		return true
	end
}

-- Clownfish
FishAndChips.Fish {
	key = "aureallu_clownfish",
	atlas = "aureallu_fish",
	pos = { x = 1, y = 3 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "copy", "position", },
	stats = {weight = {min = 0.06, max = 0.4}, length = {min = 0.05, max = 0.12}},
	config = {
		extra = {
			
		},
	},
	environments = {
		city_river = 10,
		styx = 7,
		wormhole = 7,
		backroom = 9,
	},
	loc_vars = function(self, info_queue, card)
		-- Everyone say it with me: Thanks Vanillaremade!
		if card.area and card.area == G.fac_fish_area then
            local joker
            for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] == card then joker = G.jokers.cards[i] end
            end
            local compatible = joker and joker ~= card and joker.config.center.blueprint_compat
            local main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(FishAndChips.C.FISH, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
	end,
	calculate = function(self, card, context)
		local joker = nil
        for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] == card then joker = G.jokers.cards[i] end
            end
        local ret = SMODS.blueprint_effect(card, joker, context)
        if ret then
            ret.colour = FishAndChips.C.FISH
        end
        return ret
	end,
}

-- Pirate Perch
FishAndChips.Fish {
	key = "aureallu_pirate_perch",
	atlas = "aureallu_fish",
	pos = { x = 2, y = 3 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "chips" },
	stats = {weight = {min = 1, max = 3}, length = {min = 0.15, max = 0.45}},
	blueprint_compat = true,
	config = {
		extra = {
			chips_per_sand_dollar = 5
		},
	},
	environments = {
		pier = 10,
		volcano = 8,
		styx = 3,
		wormhole = 2,
		backroom = 4,
	},
	loc_vars = function(self, info_queue, card)
		local sell_cost = 0
		if G.fac_fish_area then
			for i, fishee in ipairs(G.fac_fish_area.cards) do
				if fishee ~= card then
					sell_cost = sell_cost + fishee.sell_cost
				end
			end
		end
		return { vars = { zero_signed(card.ability.extra.chips_per_sand_dollar), zero_signed(sell_cost * card.ability.extra.chips_per_sand_dollar) } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local sell_cost = 0
			for i, fishee in ipairs(G.fac_fish_area.cards) do
				if fishee ~= card then
					sell_cost = sell_cost + fishee.sell_cost
				end
			end
			return {
				chips = sell_cost * card.ability.extra.chips_per_sand_dollar
			}
		end
	end,
}

-- Cookiecutter Shark
FishAndChips.Fish {
	key = "aureallu_cookiecutter_shark",
	atlas = "aureallu_fish",
	pos = { x = 3, y = 3 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "chance",  "tag", "destroy_card" },
	stats = {weight = {min = 0.1, max = 1}, length = {min = 0.1, max = 0.4}},
	blueprint_compat = true,
	config = {
		extra = {
			lucky_d6_odds = 6
		},
	},
	environments = {
		city_river = 5,
		chocolate_river = 10,
		soup = 2,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_TAGS.tag_d_six
		local numerator_cookie, denominator_cookie = SMODS.get_probability_vars(card, 1, card.ability.extra.lucky_d6_odds, "fac_aureallu_cookiecutter_shark")
		return { vars = { numerator_cookie, denominator_cookie } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.end_of_round and context.cardarea == G.hand and SMODS.has_enhancement(context.other_card, "m_lucky") then
			if SMODS.pseudorandom_probability(card, "fac_aureallu_cookiecutter_shark", 1, card.ability.extra.lucky_d6_odds) then
				local pcard = context.other_card
				G.E_MANAGER:add_event(Event({
					trigger = 'before',
                	delay = 0.0,
					func = function ()
						SMODS.destroy_cards(pcard, {immediate = true, pinch_anim = true})
						play_sound('tarot1')
						add_tag({key = "tag_d_six"})
						play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
						play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
						return true
					end
				}))
				return {
					message = localize('k_aureallu_cookiecutter'),
					colour = G.C.GREEN,
				}
			end
			return nil, true
		end
	end,
}

-- Chimaera
local kernel_max = 100
function get_pixel_distance(shader_data, x, y, width, height, green)
	local distance = 0
	while distance < math.min(kernel_max, math.max(width, height)) do
		distance = distance + 1
		-- Min/max X
		for y_d=math.max(y-distance, 0), math.min(y+distance, height-1), 1 do
			for _, x_d in ipairs({math.max(x-distance, 0), math.min(x+distance, width-1)}) do
				local _, g, b = shader_data:getPixel(x_d, y_d)
				if green and b > 0.0 or (not green and g > 0.0) then
					goto skip
				end
			end
		end
		-- Min/max Y (clamped within only new pixels)
		for x_d=math.max(x-distance+1, 0), math.min(x+distance-1, width-1), 1 do
			for _, y_d in ipairs({math.max(y-distance, 0), math.min(y+distance, height-1)}) do
				local _, g, b = shader_data:getPixel(x_d, y_d)
				if green and b > 0.0 or (not green and g > 0.0) then
					goto skip
				end
			end
		end
	end
	::skip::
	return distance
end

local function get_center_atlas_pos(center)
	local a_state = center.sprite_args and (center.sprite_args.default_state and (center.sprite_args.states or {})[center.sprite_args.defautlt_state]) or {}
	local pos = {
		x = (a_state.start_pos or (center.sprite_args and center.sprite_args.start_pos) or center.pos or {}).x or 0,
		y = (a_state.start_pos or (center.sprite_args and center.sprite_args.start_pos) or center.pos or {}).y or 0,
	}
	return pos
end

local pixel_distance_store_factor = 50
function set_chimaera_morph_data(card, old_center, new_center, morph_time)
	card.fac_aureallu_chimaera_morph_data = {}
	local scale = G.SETTINGS.GRAPHICS.texture_scaling
	
	local old_atlas = SMODS.get_atlas(old_center.atlas)
	local old_data = old_atlas.image_data
    local old_px = (old_center.pixel_size or {}).w or (old_center.display_size or {}).w or old_atlas.px
	local old_py = (old_center.pixel_size or {}).h or (old_center.display_size or {}).h or old_atlas.py
	local old_pos = get_center_atlas_pos(old_center)
	local old_offset = {
		x = old_atlas.px * old_pos.x * scale,
		y = old_atlas.py * old_pos.y * scale,
	}
	local new_atlas = SMODS.get_atlas(new_center.atlas)
	local new_data = new_atlas.image_data
    local new_px = (new_center.pixel_size or {}).w or (new_center.display_size or {}).w or new_atlas.px
	local new_py = (new_center.pixel_size or {}).h or (new_center.display_size or {}).h or new_atlas.py
	local new_pos = get_center_atlas_pos(new_center)
	local new_offset = {
		x = new_atlas.px * new_pos.x * scale,
		y = new_atlas.py * new_pos.y * scale,
	}

	local rel_px = math.max(old_px, new_px)
	local rel_py = math.max(old_py, new_py)
	local shader_data = love.image.newImageData(rel_px, rel_py)

	shader_data:mapPixel(function (x, y, r, g, b, a)
		r, g, b, a = 0, 0, 0, 0
		local real_old_x, real_old_y = math.floor(-(rel_px - old_px)/2 + x)*scale, math.floor(-(rel_py - old_py)/2 + y)*scale
		local real_new_x, real_new_y = math.floor(-(rel_px - new_px)/2 + x)*scale, math.floor(-(rel_py - new_py)/2 + y)*scale
		if real_old_x > 0 and real_old_x < old_px * scale and real_old_y > 0 and real_old_y < old_py * scale then
			local _, _, _, old_a = old_data:getPixel(real_old_x + old_offset.x, real_old_y + old_offset.y)
			g, a = old_a, old_a
		end
		if real_new_x > 0 and real_new_x < new_px * scale and real_new_y > 0 and real_new_y < new_py * scale then
			local _, _, _, new_a = new_data:getPixel(real_new_x + new_offset.x, real_new_y + new_offset.y)
			b, a = new_a, math.max(new_a, a)
		end
		return r, g, b, a
	end)
	-- shader_data:encode("png", "chimaera_morph_1.png")

	local max_distance_old = 1
	local max_distance_new = 1
	shader_data:mapPixel(function (x, y, r, g, b, a)
		if a > 0.0 then
			if g <= 0.0 and b <= 0.0 or g > 0.0 and b > 0.0 then
				r = 1.0 -- fade = 0.5
			else 
				local distance = get_pixel_distance(shader_data, x, y, rel_px, rel_py, g > 0.0)
				if g > 0.0 then
					g = distance / pixel_distance_store_factor
					max_distance_old = math.max(max_distance_old, distance)
				else
					b = distance / pixel_distance_store_factor
					max_distance_new = math.max(max_distance_new, distance)
				end
			end
		end
		return r, g, b, a
	end)
	-- shader_data:encode("png", "chimaera_morph_2.png")

	shader_data:mapPixel(function (x, y, r, g, b, a)
		if a > 0.0 and not (g <= 0.0 and b <= 0.0 or g > 0.0 and b > 0.0) then
			if g > 0.0 then
				g = 1.0 - (g * pixel_distance_store_factor) / max_distance_old
			else
				b = (b * pixel_distance_store_factor) / max_distance_new
			end
		end
		return r, g, b, a
	end)
	-- shader_data:encode("png", "chimaera_morph_3.png")
	card.fac_aureallu_chimaera_morph_data.mask = love.graphics.newImage(shader_data)
	card.fac_aureallu_chimaera_morph_data.start_time = G.TIMERS.REAL
	card.fac_aureallu_chimaera_morph_data.morph_time = morph_time or 2.0
	card.fac_aureallu_chimaera_morph_data.texture_sizes = {old_px, old_py, new_px, new_py}
	card.ignore_shadow.chimaera_morph = true
end

function remove_chimaera_morph_data(card)
	card.fac_aureallu_chimaera_morph_data = nil
	if card.children.chimaera_old_center then
		card.children.chimaera_old_center:remove()
		card.children.chimaera_old_center = nil
	end
	card.ignore_shadow.chimaera_morph = nil
end

SMODS.clean_up_children_ignore.chimaera_old_center = true
SMODS.draw_ignore_keys.chimaera_old_center = true
function morph_fish_into(card, new_center, time)
	local old_center = card.config.center
	card.children.chimaera_old_center = card.children.center
	card.children.chimaera_old_center.green = true
	local w, h = card.children.chimaera_old_center.T.w, card.children.chimaera_old_center.T.h
	card.children.chimaera_old_center.T = {
		x = card.children.chimaera_old_center.T.x,
		y = card.children.chimaera_old_center.T.y,
		w = w,
		h = h,
		r = card.children.chimaera_old_center.T.r,
		scale = card.children.chimaera_old_center.T.scale,
	}
	card.children.center = nil
	card:set_ability(new_center)
	local new_w, new_h = card.children.center.T.w, card.children.center.T.h 
	card.children.chimaera_old_center:set_role({major = card, role_type = 'Minor', draw_major = card, xy_bond = "Strong", wh_bond = "Weak", r_bond = "Strong", scale_bond = "Strong", offset = {x=(new_w-w)/2.0,y=(new_h-h)/2.0}})
	card.children.chimaera_old_center.T.r = 0
	card.children.chimaera_old_center.VT.r = 0
	set_chimaera_morph_data(card, old_center, new_center, time)
end

SMODS.Sound {
	key = "aureallu_chimaera_morph",
	path = "aure-allu/chimaera-morph.ogg",
}

SMODS.Shader {
	key = "aureallu_chimaera",
    path = "aure-allu/chimaera.fs",
    send_vars = function (sprite, card)
        if not card.fac_aureallu_chimaera_morph_data then return end
		local morph_time = (G.TIMERS.REAL - card.fac_aureallu_chimaera_morph_data.start_time) / (card.fac_aureallu_chimaera_morph_data.morph_time)
        return {
			texture_sizes = card.fac_aureallu_chimaera_morph_data.texture_sizes, -- old, new
            morph_mask = card.fac_aureallu_chimaera_morph_data.mask,
			morph_progress = morph_time,
			green = sprite.green or false,
        }
    end
}

SMODS.DrawStep {
	key = "aureallu_chimaera",
	order = -11,
	func = function(self, layer)
		if self.fac_aureallu_chimaera_morph_data then
			local morph_time = (G.TIMERS.REAL - self.fac_aureallu_chimaera_morph_data.start_time) / (self.fac_aureallu_chimaera_morph_data.morph_time)
			if morph_time > 1.1 then
				remove_chimaera_morph_data(self)
				return
			end
			--Draw the shadows
			self.ignore_shadow.chimaera_morph = nil
			if not self.no_shadow and G.SETTINGS.GRAPHICS.shadows == 'On' and((self.ability.effect ~= 'Glass Card' and not self.greyed and self:should_draw_shadow() ) and ((self.area and self.area ~= G.discard and self.area.config.type ~= 'deck') or not self.area or self.states.drag.is)) then
				self.shadow_height = 0*(0.08 + 0.4*math.sqrt(self.velocity.x^2)) + ((((self.highlighted and self.area == G.play) or self.states.drag.is) and 0.35) or (self.area and self.area.config.type == 'title_2') and 0.04 or 0.1)
				self.children.center:draw_shader('fac_aureallu_chimaera', self.shadow_height)
				self.children.chimaera_old_center:draw_shader('fac_aureallu_chimaera', self.shadow_height)
				
			end
			self.ignore_shadow.chimaera_morph = true

			self.children.center:draw_shader("fac_aureallu_chimaera")
			self.children.chimaera_old_center:draw_shader("fac_aureallu_chimaera")
		end
    end,
    conditions = { vortex = false, facing = 'front' },
}

local draw_step_edition_func_ref = SMODS.DrawSteps.edition.func 
function SMODS.DrawSteps.edition.func(self, layer)
	if not self.fac_aureallu_chimaera_morph_data then
		return draw_step_edition_func_ref(self, layer)
	end
end
local draw_step_center_func_ref = SMODS.DrawSteps.center.func
function SMODS.DrawSteps.center.func(self, layer)
	if not self.fac_aureallu_chimaera_morph_data then
		return draw_step_center_func_ref(self, layer)
	end
end

FishAndChips.Fish {
	key = "aureallu_chimaera",
	atlas = "aureallu_fish",
	pos = { x = 4, y = 3 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "passive", "usable" },
	stats = {weight = {min = 0.25, max = 30}, length = {min = 0.1, max = 1.5}},
	blueprint_compat = false,
	config = {
		extra = {
			active = false
		},
	},
	environments = {
		swamp = 5,
		aquifer = 10,
		styx = 9,
		backroom = 6,
	},
	loc_vars = function(self, info_queue, card)
		local active = {
			n = G.UIT.C,
			config = { align = "bm", minh = 0.4 },
			nodes = {
				{
					n = G.UIT.C,
					config = { ref_table = card, align = "m", colour = card.ability.extra.active and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
					nodes = {
						{ n = G.UIT.T, config = { text = card.ability.extra.active and localize("k_aureallu_chimaera_active") or localize('k_aureallu_chimaera_inactive'), colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
					}
				}
			}
		}
		local fish = {
			n = G.UIT.C,
			config = { align = "bm", minh = 0.4 },
			nodes = {
				{
					n = G.UIT.C,
					config = { ref_table = card, align = "m", colour = G.GAME.fac_last_used_fish and G.GAME.fac_last_used_fish ~= "fish_fac_chimaera" and mix_colours(FishAndChips.C.FISH, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.BLACK, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
					nodes = {
						{ n = G.UIT.T, config = { text = G.GAME.fac_last_used_fish and localize{type = 'name_text', key = G.GAME.fac_last_used_fish, set = "fac_Fish"} or localize('k_none'), colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
					}
				}
			}
		}
		local main_end = {
			{
				n = G.UIT.R,
				config = { align = "bm", minh = 0.4 },
				nodes = {
					active,
					fish,
				}
			},
		}
		return { main_end = main_end }
	end,
	calculate = function(self, card, context)
		if not card.ability.extra.active and context.before and next(context.poker_hands["Flush"]) and next(context.poker_hands["Pair"]) then
			local has_wild = false
			for i, pcard in ipairs(context.full_hand) do
				if SMODS.has_enhancement(pcard, "m_wild") then has_wild = true; break end
			end
			if has_wild then
				card.ability.extra.active = true
				return {
					message = localize("k_active_ex"),
					colour = FishAndChips.C.FISH,
				}
			end
		end
	end,
	use = function (self, card)
		if G.GAME.fac_last_used_fish and G.GAME.fac_last_used_fish ~= "fish_fac_chimaera" then
			local new_center = G.P_CENTERS[G.GAME.fac_last_used_fish]
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.3,
				func = function ()
					play_sound("fac_aureallu_chimaera_morph", 1.0, 1.75)
					morph_fish_into(card, new_center, 1.7)
					return true
				end
			}))
			delay(1.6*G.SETTINGS.GAMESPEED)
		-- else 
		-- 	SMODS.calculate_effect({
		-- 		message = localize("k_aureallu_chimaera_confoozed"),
		-- 		colour = G.C.BLACK,
		-- 	}, card)
		end
	end,
	keep_on_use = function (self, card)
		return true
	end,
	can_use = function (self, card)
		return card.ability.extra.active and G.GAME.fac_last_used_fish and G.GAME.fac_last_used_fish ~= "fish_fac_chimaera"
	end
}

-- Guppies
FishAndChips.Fish {
	key = "aureallu_guppies",
	atlas = "aureallu_fish",
	pos = { x = 0, y = 4 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "chips", "chance" },
	stats = {weight = {min = 0.03, max = 0.1}, length = {min = 0.04, max = 0.12}},
	blueprint_compat = true,
	config = {
		extra = {
			chips_per_fish = 33,
			chips_odds = 3,
		},
	},
	environments = {
		volcano = 5,
		wormhole = 10,
	},
	loc_vars = function(self, info_queue, card)
		local numerator_guppies, denominator_guppies = SMODS.get_probability_vars(card, 1, card.ability.extra.chips_odds, "fac_aureallu_guppies")
		return { vars = { numerator_guppies, denominator_guppies, zero_signed(card.ability.extra.chips_per_fish) } }
	end,
	calculate = function(self, card, context)
		if context.other_unknown and context.other_unknown.ability.set == "fac_Fish" then
			if SMODS.pseudorandom_probability(card, "fac_aureallu_guppies", 1, card.ability.extra.chips_odds) then
				return {
					chips = card.ability.extra.chips_per_fish
				}
			end
			return nil, true
		end
	end,
}

-- Neunauge
FishAndChips.Fish {
	key = "aureallu_neunauge",
	atlas = "aureallu_fish",
	pos = { x = 1, y = 4 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "retrigger", },
	stats = {weight = {min = 0.5, max = 2.43}, length = {min = 0.15, max = 0.5}},
	blueprint_compat = true,
	config = {
		extra = {
			
		},
	},
	environments = {
		calm_pond = 4,
		city_river = 8,
		swamp = 10,
		aquifer = 10,
		soup = 2,
	},
	loc_vars = function(self, info_queue, card)
		local tally = 0
		if G.deck then
			for _, pcard in ipairs(G.deck.cards) do
				if pcard:get_id() == 9 then
					tally = tally + 1
				end
			end
		end
		return { vars = { tally } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.other_card:get_id() == 9 then
			local tally = 0
			for _, pcard in ipairs(G.deck.cards) do
				if pcard:get_id() == 9 then
					tally = tally + 1
				end
			end
			if tally <= 9 then
				return {
					repetitions = 1
				}
			end
		end
	end,
}

-- Old World Knifefish
FishAndChips.Fish {
	key = "aureallu_old_world_knifefish",
	atlas = "aureallu_fish",
	pos = { x = 2, y = 4 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "destroy_card", "economy", "usable", "position", },
	stats = {weight = {min = 0.2, max = 0.7}, length = {min = 0.07, max = 0.16}},
	blueprint_compat = false,
	requires_jokers = true,
	config = {
		extra = {
			x_sell_cost = 2,
			max_uses = 2,
			remaining_uses = 2,
		},
	},
	environments = {
		pier = 5,
		city_river = 5,
		volcano = 10,
		styx = 7,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_sell_cost, card.ability.extra.remaining_uses, card.ability.extra.max_uses } }
	end,
	calculate = function (self, card, context)
		if context.end_of_round and not context.game_over and context.main_eval then
			local before = card.ability.extra.remaining_uses
			card.ability.extra.remaining_uses = card.ability.extra.max_uses
			if before < card.ability.extra.max_uses then
				return {
					message = localize("k_reset"),
					colour = G.C.IMPORTANT
				}
			end
		end
	end,
	use = function (self, card)
		card.ability.extra.remaining_uses = card.ability.extra.remaining_uses - 1
		local own_i, joker
		for i, fishee in ipairs(G.fac_fish_area.cards) do
			if fishee == card then own_i = i; break end
		end
		joker = G.jokers.cards[own_i]
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.1, 
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				ease_dollars(joker.sell_cost * card.ability.extra.x_sell_cost)
				SMODS.destroy_cards(joker, {immediate = true})
				return true
			end
		}))
		
	end,
	keep_on_use = function (self, card)
		return true
	end,
	can_use = function (self, card)
		local own_i, joker
		if G.fac_fish_area then
			for i, fishee in ipairs(G.fac_fish_area.cards) do
				if fishee == card then own_i = i; break end
			end
		end
		joker = G.jokers and G.jokers.cards[own_i]
		return own_i and joker and not SMODS.is_eternal(joker) and card.ability.extra.remaining_uses > 0
	end
}

-- Thrasher Shark
--[[ --This sound file is missing
SMODS.Sound {
	key = "aureallu_trasher",
	path = "aure-allu/thrasher.ogg"
}
]]

FishAndChips.Fish {
	key = "aureallu_thrasher_shark",
	atlas = "aureallu_fish",
	pos = { x = 3, y = 4 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "modify_card", "rank", "position", "economy" },
	stats = {weight = {min = 25, max = 500}, length = {min = 1.3, max = 6.1}},
	blueprint_compat = true,
	config = {
		extra = {
			reduce_rank = 1,
			dollar_cost = 1,
			sand_dollar_cost = 1,
		},
	},
	environments = {
		pier = 10,
		city_river = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.reduce_rank, card.ability.extra.dollar_cost, card.ability.extra.sand_dollar_cost } }
	end,
	calculate = function (self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
			local other_card = context.other_card
			G.E_MANAGER:add_event(Event({
				func = function ()
					SMODS.modify_rank(other_card, -card.ability.extra.reduce_rank)
					-- play_sound("fac_aureallu_trasher")
					-- ease_dollars(-card.ability.extra.dollar_cost, true)
					-- ease_sand_dollars(-card.ability.extra.sand_dollar_cost, true)
					card.ability.extra_value = card.ability.extra_value + card.ability.extra.sand_dollar_cost
					card:set_cost()
					return true
				end
			}))
			return {
				dollars = -card.ability.extra.dollar_cost,
				sand_dollars = -card.ability.extra.sand_dollar_cost,
				message = localize("k_aureallu_trasher"),
				colour = G.C.GREY
			}
		end
	end,
}

-- Blahaj
local blahaj_suits_map = {
	Hearts = "Clubs",
	Diamonds = "Spades",
	Clubs = "Hearts",
	Spades = "Diamonds"
}
FishAndChips.Fish {
	key = "aureallu_blahaj",
	atlas = "aureallu_fish",
	pos = { x = 4, y = 4 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "suits", "modify_card" },
	stats = {weight = {min = 0.55, max = 1}, length = {min = 0.6, max = 3}},
	blueprint_compat = false,
	requires_hand = true,
	config = {
		extra = {
			max_cards = 4,
			max_uses = 1,
			remaining_uses = 1,
		},
	},
	environments = {
		city_river = 9,
		volcano = 6,
		aquifer = 10,
		backroom = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_cards, card.ability.extra.remaining_uses, card.ability.extra.max_uses } }
	end,
	calculate = function (self, card, context)
		if context.end_of_round and not context.game_over and context.main_eval then
			local before = card.ability.extra.remaining_uses
			card.ability.extra.remaining_uses = card.ability.extra.max_uses
			if before < card.ability.extra.max_uses then
				return {
					message = localize("k_reset"),
					colour = G.C.IMPORTANT
				}
			end
		end
	end,
	use = function (self, card)
		card.ability.extra.remaining_uses = card.ability.extra.remaining_uses - 1
        G.E_MANAGER:add_event(Event({
			trigger = "after", 
			delay = 0.1, 
			func = function()
				play_sound('tarot1')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    return true
                end
            }))
		end
        delay(0.4)
		for _, pcard in ipairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
					SMODS.change_base(pcard, blahaj_suits_map[pcard.base.suit] or "Hearts")
					pcard:juice_up(0.3, 0.3)
                    return true
                end
            }))
		end
        delay(0.4)
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip()
                    play_sound('card1', percent)
                    return true
                end
            }))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
	end,
	keep_on_use = function (self, card)
		return true
	end,
	can_use = function (self, card)
		return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_cards and card.ability.extra.remaining_uses > 0
	end
}

-- Firefly Squid
FishAndChips.Fish {
	key = "aureallu_firefly_squid",
	atlas = "aureallu_fish",
	pos = { x = 0, y = 5 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "generation", },
	stats = {weight = {min = 0.1, max = 0.7}, length = {min = 0.05, max = 0.1}},
	blueprint_compat = true,
	config = {
		extra = {
		},
	},
	environments = {
		pier = 10,
		styx = 6,
		wormhole = 3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function (self, card, context)
		if context.after and SMODS.last_hand_oneshot and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			if G.GAME.blind:is_type("Boss") then
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.add_card {
							set = 'Spectral',
							key_append = 'fac_aureallu_firefly'
						}
						G.GAME.consumeable_buffer = 0
						return true
					end
				}))
				return {
					message = localize('k_plus_spectral'),
					colour = G.C.SECONDARY_SET.Spectral,
				}
			else
				G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = 'fac_aureallu_firefly'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                }))
                return {
                    message = localize('k_plus_tarot'),
                }
			end
		end
	end,
}

-- Vampire Squid
FishAndChips.Fish {
	key = "aureallu_vampire_squid",
	atlas = "aureallu_fish",
	pos = { x = 1, y = 5 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "xmult", },
	stats = {weight = {min = 0.1, max = 0.8}, length = {min = 0.07, max = 0.19}},
	blueprint_compat = true,
	config = {
		extra = {
			x_mult_gain = 0.5,
			x_mult_total = 1.0,
		},
	},
	environments = {
		city_river = 3,
		volcano = 5,
		aquifer = 10,
		styx = 7,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult_total } }
	end,
	calculate = function (self, card, context)
		if context.joker_type_destroyed and context.card ~= card and context.card.ability.set == "fac_Fish" and not context.blueprint_card then
			card.ability.extra.x_mult_total = card.ability.extra.x_mult_total + card.ability.extra.x_mult_gain
			return {
				message = localize("k_upgrade_ex"),
				colour = G.C.MULT
			}
		elseif context.joker_main then
			return {
				x_mult = card.ability.extra.x_mult_total
			}
		end
	end,
}

-- Mine Sweeper
SMODS.Sound {
	key = "aureallu_mine_boom",
	path = "aure-allu/mine-boom.ogg"
}

SMODS.Atlas {
	key = "aureallu_mine_boom",
	path = "aure-allu/mine-boom.png",
	px = 71,
	py = 95,
	atlas_table = "ANIMATION_ATLAS",
	frames = 9,
	fps = 14
}

SMODS.SpriteParticle {
	key = "aureallu_mine_boom",
	atlas = "aureallu_mine_boom",
	sound = {key = "fac_aureallu_mine_boom", vol = 1.3, per = 1.0},
	should_remove = function (self, sprite, card, args)
        return sprite.current_animation.current == sprite.current_animation.frames - 1
    end
}

FishAndChips.Fish {
	key = "aureallu_mine_sweepers",
	atlas = "aureallu_fish",
	pos = { x = 2, y = 5 },
	weight = 3,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "usable", "chance", "boss_blind", "destroy_card" },
	stats = {weight = {min = 0.001, max = 0.005}, length = {min = 0.02, max = 0.045}},
	blueprint_compat = false,
	config = {
		extra = {
			disable_odds = 2,
			boom_odds = 5,
			max_uses = 2,
			remaining_uses = 2,
		},
	},
	environments = {
		pier = 7,
		volcano = 10,
		backroom = 3,
	},
	loc_vars = function(self, info_queue, card)
		local numerator_disable, denominator_disable = SMODS.get_probability_vars(card, 1, card.ability.extra.disable_odds, "fac_aureallu_mine_disable")
		local numerator_boom, denominator_boom = SMODS.get_probability_vars(card, 1, card.ability.extra.boom_odds, "fac_aureallu_mine_boom")
		return { vars = { numerator_disable, denominator_disable, numerator_boom, denominator_boom, card.ability.extra.remaining_uses, card.ability.extra.max_uses } }
	end,
	calculate = function (self, card, context)
		if context.end_of_round and not context.game_over and context.main_eval then
			local before = card.ability.extra.remaining_uses
			card.ability.extra.remaining_uses = card.ability.extra.max_uses
			if before < card.ability.extra.max_uses then
				return {
					message = localize("k_reset"),
					colour = G.C.IMPORTANT
				}
			end
		end
	end,
	use = function (self, card)
		card.ability.extra.remaining_uses = card.ability.extra.remaining_uses - 1
		local success
		if SMODS.pseudorandom_probability(card, "fac_aureallu_mine_disable", 1, card.ability.extra.disable_odds) then
			success = true
		end
		if SMODS.pseudorandom_probability(card, "fac_aureallu_mine_boom", 1, card.ability.extra.boom_odds) then
			success = false
		end
		if success then
			G.E_MANAGER:add_event(Event({
				func = function()
                	G.GAME.blind:disable()
                	return true
            	end
			}))
			SMODS.calculate_effect({
				message_card = card,
				message = localize("k_aureallu_mine_disabled"),
				colour = FishAndChips.C.FISH
			})
			return
		elseif success == false then
			local own_i
			for i, fishee in ipairs(G.fac_fish_area.cards) do
				if fishee == card then own_i = i; break end
			end
			if own_i then
				local destroyees, left, right = {}, G.fac_fish_area.cards[own_i - 1], G.fac_fish_area.cards[own_i + 1]
				table.insert(destroyees, card)
				if left then table.insert(destroyees, left) end
				if right then table.insert(destroyees, right) end
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.spawn_sprite_particle("fac_aureallu_mine_boom", {card = card})
						delay(0.3 * G.SETTINGS.GAMESPEED)
						SMODS.destroy_cards(destroyees, {silent = true})
						return true
					end
				}))
			end
			return 
		end
		SMODS.calculate_effect({
			message_card = card,
			message = localize("k_aureallu_mine_nothing"),
			colour = G.C.GREY,
		})
	end,
	keep_on_use = function (self, card)
		return true
	end,
	can_use = function (self, card)
		return G.GAME.facing_blind and not G.GAME.blind.disabled and G.GAME.blind:is_type("Boss") and card.ability.extra.remaining_uses > 0
	end
}

-- Sleeper Shark
FishAndChips.Fish {
	key = "aureallu_sleeper_shark",
	atlas = "aureallu_fish",
	pos = { x = 3, y = 5 },
	weight = 2,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "passive", "economy" },
	stats = {weight = {min = 250, max = 888}, length = {min = 1.8, max = 4.4}},
	blueprint_compat = false,
	config = {
		extra = {
			sand_dollars_gain_cap = 5,
			x_sand_dollars = 1.5,
			x_sand_dollars_gain_cap = 25,
		},
	},
	environments = {
		calm_pond = 10,
		aquifer = 6,
		garden = 4,
		wormhole = 2,
		soup = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.sand_dollars_gain_cap, card.ability.extra.x_sand_dollars, card.ability.extra.x_sand_dollars_gain_cap } }
	end,
	calculate = function(self, card, context)
		if context.ending_fishing and not context.blueprint_card then
			local s_dollars = math.floor(math.min(G.GAME.fac_sand_dollars + (G.GAME.fac_sand_dollar_buffer or 0), card.ability.extra.sand_dollars_gain_cap * 2) / 2)
			G.GAME.fac_sand_dollar_buffer = G.GAME.fac_sand_dollar_buffer or 0 
			G.GAME.fac_sand_dollar_buffer = G.GAME.fac_sand_dollar_buffer - s_dollars
			G.E_MANAGER:add_event(Event{
				func = function ()
					ease_sand_dollars(-s_dollars, true)
					G.GAME.fac_sand_dollar_buffer = 0
					return true
				end
			})
			card.ability.extra_value = card.ability.extra_value + s_dollars
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = FishAndChips.C.SAND_DOLLAR
			}
		elseif context.after and G.GAME.blind:is_type("Boss") then
			local diff = card.sell_cost - card.ability.extra_value
			local new_val = math.floor(math.min(card.sell_cost * card.ability.extra.x_sand_dollars, card.sell_cost + card.ability.extra.x_sand_dollars_gain_cap))
			card.ability.extra_value = new_val - diff
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = FishAndChips.C.SAND_DOLLAR
			}
		end
	end,
}

-- Tiger Shark :tiger2:
FishAndChips.Fish {
	key = 'aureallu_tiger_shark',
	atlas = 'aureallu_fish',
	pos = {x = 4, y = 5},
	weight = 7,
	ppu_coder = {'Aure'},
	ppu_artist = {'Aure'},
	stats = {weight = {min = 0, max = 3000}, length = {min = 2.3, max = 5.2}},
	blueprint_compat = true,
	config = {
		mult_per_weight = 0.1,
		weight_step = 50,
	},
	environments = {
		swamp = 10,
		pier = 10,
		city_river = 7,
		chocolate_river = 5,
		wormhole = 5,
		calm_pond = 2,
	},
	attributes = { 'xmult', 'scaling', 'destroy_card' },
	add_to_deck = function(self, card)
		card.ability.stats.weight = 100
	end,
	loc_vars = function(self, info_queue, card)
		return {vars = { card.ability.mult_per_weight, card.ability.weight_step, 1+math.floor((card.ability.stats or { weight = 100}).weight/card.ability.weight_step)*card.ability.mult_per_weight }}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint then
			local my_pos = nil
            for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] == card then
                    my_pos = i
                    break
                end
            end
			if my_pos and G.fac_fish_area.cards[my_pos + 1] and not SMODS.is_eternal(G.fac_fish_area.cards[my_pos + 1]) then
				local sliced_card = G.fac_fish_area.cards[my_pos + 1]
				local weight = sliced_card.ability.stats.weight or 0
				SMODS.scale_card(card, {
					ref_table = card.ability.stats,
					ref_value = 'weight',
					scalar_table = { weight = weight },
					scalar_value = 'weight',
					no_message = true,
				})
				SMODS.destroy_cards(sliced_card)
				return {
					colour = G.C.FILTER,
					message = localize('k_eaten_ex')
				}
			end
		end
		if context.joker_main then
			return {
				xmult = 1 + math.floor(card.ability.stats.weight/card.ability.weight_step)*card.ability.mult_per_weight,
			}
		end
	end,
}
-- #endregion