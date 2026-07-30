PotatoPatchUtils.Developer({
	name = 'Aure',
	atlas = 'fac_aure-allu_cards',
	colour = G.C.ORANGE,
	fac_partner = 'AllUniversal'
})

PotatoPatchUtils.Developer({
	name = 'AllUniversal',
	atlas = 'fac_aure-allu_cards',
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


zero_signed = function (value, infix)
	local v = value ~= 0 and SMODS.signed(value) or "+0"
	return string.sub(v, 1, 1) .. (infix or "") .. string.sub(v, 2)
end


filter_list = function (t, exclude_map)
	local out = {}
	exclude_map = exclude_map or {}
	for i, elem in ipairs(t) do
		if not exclude_map[elem] then table.insert(out, elem) end
	end
	return out
end

function table_find(t, value)
	if not type(t) == "table" then return end
	for k, v in pairs(t) do
		if v == value then return k end
	end
	return nil
end

function table_get_subfield(_table, key_string_or_keys)
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
		calm_pond = 10,
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
		calm_pond = 10,
		garden = 9,
		aquifer = 3,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
		
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

local ease_round_ref = ease_round
function ease_round(...)
	ease_round_ref(...)
	for _, area in ipairs({G.jokers, G.consumeables, G.fac_fish_area}) do
		for _, card in ipairs(area.cards) do
			card.ability.rounds_held = card.ability.rounds_held and card.ability.rounds_held + 1 or 1
		end
	end
end

FishAndChips.Fish {
	key = "moldfish",
	atlas = "aure-allu_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "mult" },
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
	key = "shrimp",
	atlas = "aure-allu_fish",
	pos = { x = 0, y = 1 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "mult" },
	config = {
		extra = {
			mult_gain = 4,
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
		if context.before and not context.blueprint then
            local same_slot = false
			for _, slot in ipairs(card.ability.immutable.last_slots) do
				if slot == table_find(G.fac_fish_area.cards, card) then
					same_slot = true; break
				end
			end
			if #card.ability.immutable.last_slots >= card.ability.immutable.last_slots_max then table.remove(card.ability.immutable.last_slots, 1) end
			table.insert(card.ability.immutable.last_slots, card.rank)
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
	key = "eel_of_fortune",
	atlas = "aure-allu_fish",
	pos = { x = 2, y = 1 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = {  },
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
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_foil
		info_queue[#info_queue+1] = G.P_CENTERS.e_holo
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
		local numerator_eel, denominator_eel = SMODS.get_probability_vars(card, 1, card.ability.extra.eel_odds, "fac_aure-allu_eel_of_fortune")
		return { vars = { numerator_eel, denominator_eel } }
	end,
	use = function (self, card)
		-- Thanks https://github.com/nh6574/VanillaRemade/blob/main/src/tarots.lua Wheel of Fortune
		if SMODS.pseudorandom_probability(card, 'fac_aure-allu_eel_of_fortune', 1, card.ability.extra.eel_odds) then
            local editionless_fishee = SMODS.Edition:get_edition_cards({cards = filter_list(G.fac_fish_area.cards, {[card] = true})}, true)
            local eligible_card = pseudorandom_element(editionless_fishee, 'fac_aure-allu_eel_of_fortune')
            local edition = SMODS.poll_edition { key = "fac_aure-allu_eel_of_fortune", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
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
	key = "gouramichel",
	atlas = "aure-allu_fish",
	pos = { x = 3, y = 1 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "chips" },
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
		local numerator_michel, denominator_michel = SMODS.get_probability_vars(card, 1, card.ability.extra.michel_odds, "fac_aure-allu_gouramichel")
		return { vars = { zero_signed(card.ability.extra.chips), numerator_michel, denominator_michel } }
	end,
	calculate = function(self, card, context)
		-- Thanks once more, Vanillaremade !!
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'fac_aure-allu_gouramichel', 1, card.ability.extra.michel_odds) then
                SMODS.destroy_cards(card, nil, nil, true)
                G.GAME.pool_flags.fac_aure_allu_gouramichel = true
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
        return not G.GAME.pool_flags.fac_aure_allu_gouramichel
    end
}

-- Cavenfish
FishAndChips.Fish {
	key = "cavenfish",
	atlas = "aure-allu_fish",
	pos = { x = 4, y = 1 },
	weight = 1,
	ppu_coder = { "AllUniversal" },
	ppu_artist = { "AllUniversal" },
	attributes = { "x_chips" },
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
		local numerator_cavenfish, denominator_cavenfish = SMODS.get_probability_vars(card, 1, card.ability.extra.cavenfish_odds, "fac_aure-allu_cavenfish")
		return { vars = { card.ability.extra.x_chips, numerator_cavenfish, denominator_cavenfish } }
	end,
	calculate = function(self, card, context)
		-- Thanks once more, Vanillaremade !!
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if SMODS.pseudorandom_probability(card, 'fac_aure-allu_cavenfish', 1, card.ability.extra.cavenfish_odds) then
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
        return G.GAME.pool_flags.fac_aure_allu_gouramichel
    end
}

-- #endregion