

PotatoPatchUtils.Developer({
	name = 'stupid',
	atlas = 'fac_segg_credits',
	pos = {x = 1, y = 0},
	colour = G.C.BLUE,
	fac_partner = 'fac_egg_node',

	calculate = function (self, context)
		if context.setting_blind and G.GAME.fac_plasmium_infection then
			local mod = fac_get_plasmium_blind_mod()
			if mod > 1e300 then
				return {
					blindsize = mod
				}
			end
			return {
				xblindsize = mod
			}
		end
	end
})

PotatoPatchUtils.Developer({
	name = 'egg_node',
	atlas = 'fac_segg_credits',
	pos = {x = 0, y = 0},
	colour = G.C.MONEY,
	fac_partner = 'fac_stupid'
})

SMODS.Atlas({
	key = "segg_credits",
	path = "egg_stupid/credits.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "segg_fishies",
	path = "egg_stupid/fishies.png",
	px = 71,
	py = 95,
})

-- Credits: Team Cherry
SMODS.Sound {
	key = 'segg_void',
	path = 'egg_stupid/void_tick_damage.ogg',
}

SMODS.Sound {
	key = 'segg_flea_1',
	path = 'egg_stupid/Flea_bark_01.ogg',
}
SMODS.Sound {
	key = 'segg_flea_2',
	path = 'egg_stupid/Flea_bark_02.ogg',
}
SMODS.Sound {
	key = 'segg_flea_3',
	path = 'egg_stupid/Flea_bark_03.ogg',
}
SMODS.Sound {
	key = 'segg_flea_4',
	path = 'egg_stupid/Flea_bark_04.ogg',
}
SMODS.Sound {
	key = 'segg_flea_5',
	path = 'egg_stupid/Flea_bark_07.ogg',
}

SMODS.Sound {
	key = 'segg_big_flea_1',
	path = 'egg_stupid/Giant_Flea_howl_short_01.ogg',
}
SMODS.Sound {
	key = 'segg_big_flea_2',
	path = 'egg_stupid/Giant_Flea_howl_short_02.ogg',
}
SMODS.Sound {
	key = 'segg_big_flea_3',
	path = 'egg_stupid/Giant_Flea_howl_short_03.ogg',
}

SMODS.ScreenShader {
	key = "segg_infection",
	path = "egg_stupid/infection.fs",
	order = 0,
	should_apply = function (self)
		return G.GAME and G.GAME.fac_plasmium_infection and G.GAME.fac_plasmium_infection > 1
	end,
	send_vars = function(self)
		return {
			time = G.TIMERS.REAL,
			infection = G.GAME.fac_plasmium_infection,
		}
	end,
}



--#region utility

local function fly_away(card)
	
	local start = copy_table(card.T)

	local time_start = G.TIMERS.REAL

	card.states.drag.is = true

	G.E_MANAGER:add_event(Event {
		blocking = false,
		blockable = false,
		func = function ()
			local time_passed = G.TIMERS.REAL - time_start
			if card.removed or time_passed > 2 then
				return true
			end

			card.T.x = start.x - (time_passed * 10 - 0.5)
			card.T.y = start.y - (time_passed * 10 - 0.5) ^ 2
			return false
	end })
end

function fac_awoo(card, yuge)
	if yuge then
		math.randomseed(os.time())
		local name = "fac_segg_big_flea_"..math.random(1, 3)

		play_sound(name)
	else
		math.randomseed(os.time())
		local name = "fac_segg_flea_"..math.random(1, 5)
	
		play_sound(name)
	end

	fly_away(card)
end


function fac_fleash_treasure(beeg)
	local consumables = { }

	if beeg then
		consumables[1] = {"Spectral", 30}
		consumables[2] = {"Tarot", 60}
		consumables[3] = {"Planet", 10}
	else
		consumables[1] = {"Spectral", 5}
		consumables[2] = {"Tarot", 60}
		consumables[3] = {"Planet", 35}
	end

	local get_type = function ()
		local random_type = pseudorandom("fac_segg_fleash"..(beeg and "_huge" or ""), 1, 100)
		local w = 0

		for _, t in ipairs(consumables) do
			w = w + t[2]

			if random_type < w then
				return t[1]
			end
		end

		return consumables[#consumables][1]
	end

	local empty_slots = G.consumeables.config.card_limit - #G.consumeables.cards + G.GAME.consumeable_buffer

	for _ = 1, empty_slots do
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

		local t = get_type()
		SMODS.add_card({set = t, key_append = 'fac_segg_fleash_'..t})
	end

	G.E_MANAGER:add_event(Event {
		func = function ()
			G.GAME.consumeable_buffer = 0
			return true
	end })
end

function fac_get_plasmium_blind_mod(single)
	if G.GAME.fac_plasmium_infection > 10 then
		return 1
	end
	if G.GAME.fac_plasmium_infection == 10 then
		-- blind size is now always inf

		return 1e308
	elseif G.GAME.fac_plasmium_infection > 1 then
		if single then
			return (0.9 + 0.1 * G.GAME.fac_plasmium_infection)
		else
			local total_mod = 1

			for _ = 2, G.GAME.fac_plasmium_infection do
				total_mod = total_mod * (0.9 + 0.1 * G.GAME.fac_plasmium_infection)
			end

			print(total_mod)

			return total_mod
		end
	end

	return 1
end

-- ease_dollars with custom colour and sfx
function fac_ease_dollars_void(mod)
    local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
    mod = mod or 0
    local text = '+'..localize('$')
    local col = G.C.BLACK
    if mod < 0 then
        text = '-'..localize('$')
    else
      inc_career_stat('c_dollars_earned', mod)
    end
    --Ease from current chips to the new number of chips
    G.GAME.dollars = G.GAME.dollars + mod
    check_and_set_high_score('most_money', G.GAME.dollars)
    check_for_unlock({type = 'money'})
    dollar_UI.config.object:update()
    G.HUD:recalculate()
    --Popup text next to the chips in UI showing number of chips gained/lost
    attention_text({
      text = text..tostring(math.abs(mod)),
      scale = 0.8, 
      hold = 0.7,
      cover = dollar_UI.parent,
      cover_colour = col,
      align = 'cm',
      })
    --Play a chip sound
    play_sound('fac_segg_void')
end

--#endregion



--#region fishies

-- Pale oil flask
-- Make random joker editioned
FishAndChips.Fish {
	key = "segg_pale_oil",
	atlas = "segg_fishies",
	pos = { x = 0, y = 0 },

	weight = 5,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	treasure = true, -- Our only treasure :)
	blueprint_compat = false,

	attributes = { "usable", "function" },
	config = {
	},
	stats = {
		weight = {min = 0.1, max = 0.4},
		length = {min = 0.1, max = 0.4}
	},
	environments = {
		pier = 1.5,
		aquifer = 1.5,
	},
	loc_vars = function(self, info_queue, card)
	end,

	use = function(self, card)
		local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)

        local eligible_card = pseudorandom_element(editionless_jokers, 'egg_stupid_pale_oil')
        local edition = SMODS.poll_edition {
			key = "egg_stupid_pale_oil_e",
			guaranteed = true,
			no_negative = true,
		}

        eligible_card:set_edition(edition, true)
	end,
	can_use = function(self, card)
		-- Apparently is a utility method huh
        return next(SMODS.Edition:get_edition_cards(G.jokers, true))
	end
}

-- Void Fish 
-- Retriggers all played cards but lose money
FishAndChips.Fish {
	key = "segg_void_fish",
	atlas = "segg_fishies",
	pos = { x = 1, y = 0 },

	weight = 5,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },
	attributes = { "retrigger" },
	config = {
		extra = {
			money = 0
		}
	},
	stats = {
		weight = {min = 1, max = 10000.},
		length = {min = 1., max = 10000.}
	},
	environments = {
		backroom = 10,
		styx = 1.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money } }
	end,
	calculate = function(self, card, context)
		if context.ending_shop and not context.blueprint then

			-- Set muhnee to 0
			local muhnee = G.GAME.dollars

			-- Only update if money isn't zero
			if abs(muhnee) > 0.001 then
				G.custom_ed_colour = G.C.BLACK
				fac_ease_dollars_void(-muhnee)
	
				card:juice_up()
		
				return {
					message = localize('b_fac_segg_void_fish'),
					colour = G.C.BLACK
				}
			end

		end
		if context.repetition and context.other_card.area == G.play then
			return {
				repetitions = 1
			}
		end
	end,
}

-- Rootfish
-- Saps sell value from other jokers, gains Xmult for it
FishAndChips.Fish {
	key = "segg_root_fish",
	atlas = "segg_fishies",
	pos = { x = 2, y = 0 },

	weight = 5,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	attributes = { "xmult" },
	config = {
		extra = {
			dollars = 1,
			xmult_mod = 0.1,
			xmult = 1,
		}
	},
	stats = {
		weight = {min = 0.5, max = 15},
		length = {min = 0.5, max = 10}
	},
	environments = {
		swamp = 3,
		backroom = 0.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollars, card.ability.extra.xmult_mod, card.ability.extra.xmult, } }
	end,
	calculate = function(self, card, context)
		
        if context.setting_blind and not context.blueprint then
			local xmult_gained = 0
			for _, joker in pairs(G.jokers.cards) do
				if joker.set_cost and joker.sell_cost > 1 then
					joker.ability.extra_value = (joker.ability.extra_value or 0) - card.ability.extra.dollars
                    joker:set_cost()

					xmult_gained = xmult_gained + card.ability.extra.xmult_mod
				end
			end

			if xmult_gained > 0 then
				card.ability.extra.xmult = card.ability.extra.xmult + xmult_gained

				return {
					message = localize('k_upgrade_ex'),
                	colour = G.C.MULT,
				}
			end
		end

		if context.final_scoring_step then
			return { xmult = card.ability.extra.xmult }
		end
	end,
}


-- Plasmium Phial
-- Use to add +3 hands this round
-- side-effect/infection: increase blind size (after first use).
-- after using for 5+ times, blinds become unbeatable (?)

FishAndChips.Fish {
	key = "segg_plasmium_phial",
	atlas = "segg_fishies",
	pos = { x = 3, y = 0 },

	weight = 10,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	blueprint_compat = false,
	attributes = { "usable", "function" },

	config = {
		extra = {
			hands = 3,
			blind_mod = 0.1,
		}
	},
	stats = {
		weight = {min = 0.3, max = 1.},
		length = {min = 0.2, max = 0.4}
	},
	environments = {
		pier = 2.,
		city_river = 5.0
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hands,  } }
	end,

	use = function(self, card)
		ease_hands_played(card.ability.extra.hands)

		G.GAME.fac_plasmium_infection = (G.GAME.fac_plasmium_infection or 0) + 1

		if G.GAME.fac_plasmium_infection > 1 then

			local mod = fac_get_plasmium_blind_mod(true)
			if mod > 1e300 then
				-- set to near inf to avoid crashes with inf blind size
				SMODS.calculate_effect({
					blindsize = 1e308
				}, card)
			else
				SMODS.calculate_effect({
					xblindsize = mod
				}, card)
			end
		end
	end,
	can_use = function(self, card)
        return G.STATE == G.STATES.SELECTING_HAND
	end
}


-- Fleash (Awoo!)
-- goes “awoo” and it’s gone (gives sand dollart)
-- could also spawn random consumable (must have room) (small chance for spectrals also)
FishAndChips.Fish {
	key = "segg_fleash",
	atlas = "segg_fishies",
	pos = { x = 4, y = 0 },

	weight = 10,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	blueprint_compat = false,
	attributes = { "usable", "function" },

	config = {
	},
	stats = {
		weight = {min = 0.3, max = 1.},
		length = {min = 0.2, max = 0.4}
	},
	environments = {
		pier = 1.,
		swamp = 1.,
		aquifer = 1.,
		city_river = 1.0
	},
	loc_vars = function(self, info_queue, card)
	end,

	use = function(self, card)
		fac_awoo(card)

		card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('b_fac_segg_chips_awoo'), colour = G.C.MONEY})

		G.E_MANAGER:add_event(Event {
			func = function ()
				fac_fleash_treasure()
				return true
		end })
	end,
	can_use = function(self, card)
		return true
	end
}

FishAndChips.Fish {
	key = "segg_huge_fleash",
	atlas = "segg_fishies",
	pos = { x = 0, y = 1 },

	weight = 3,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	blueprint_compat = false,
	attributes = { "usable", "function" },

	config = {
	},
	stats = {
		weight = {min = 1.5, max = 10.},
		length = {min = 1., max = 4}
	},
	environments = {
		pier = 1.,
		swamp = 1.,
		aquifer = 1.,
		city_river = 1.0
	},
	loc_vars = function(self, info_queue, card)
	end,

	use = function(self, card)
		fac_awoo(card, true)

		card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('b_fac_segg_chips_awoo'), colour = G.C.MONEY})

		G.E_MANAGER:add_event(Event {
			func = function ()
				fac_fleash_treasure(true)
				return true
		end })
	end,
	can_use = function(self, card)
		return true
	end
}


-- Lost Lay's
-- (+100 chips, -20 chips at end of round. u can never eat just one chip)
FishAndChips.Fish {
	key = "segg_lost_lays",
	atlas = "segg_fishies",
	pos = { x = 1, y = 1 },

	weight = 10,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	attributes = { "chips", "food" },
	config = {
		extra = {
			chips = 100,
			chips_mod = 20,
		}
	},
	stats = {
		weight = {min = 0.05, max = 0.2},
		length = {min = 0.2, max = 0.5}
	},
	environments = {
		city_river = 3,
		pier = 2
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chips_mod, } }
	end,
	calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chips_mod

			if card.ability.extra.chips <= 0 then
				-- bye bye
				return {
					message = localize('b_fac_segg_chips_gone'),
                	colour = G.C.BLUE,
				}
			else
				-- yum yum
				return {
					message = localize('b_fac_segg_chips_down'),
                	colour = G.C.BLUE,
				}
			end
		end

		if context.joker_main then
			return { chips = card.ability.extra.chips }
		end
	end,
}


-- Courier's Rasher
--  <- soup fish
-- +1 hands size for every discard remaining (strong that's why is rare)
FishAndChips.Fish {
	key = "segg_couriers_rasher",
	atlas = "segg_fishies",
	pos = { x = 2, y = 1 },

	weight = 2,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	blueprint_compat = false,
	attributes = { "passive", "food", "hand_size" },
	config = {
		extra = {
			hand_size = 1,
			discards_cache = 0,
		}
	},
	stats = {
		weight = {min = 1., max = 4.},
		length = {min = 0.5, max = 1.5}
	},
	environments = {
		soup = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.hand_size } }
	end,

	
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and (card.config.center.discovered or card.bypass_discovery_center) then
            if G.GAME.current_round.discards_left > 0 or G.OVERLAY_MENU then
                card.children.center:set_sprite_pos({ x = 2, y = 1 })
            else
                card.children.center:set_sprite_pos({ x = 3, y = 1 })
            end
        end
    end,

	update = function (self, card)
		if card.ability.extra.in_deck and card.ability.extra.discards_cache ~= G.GAME.current_round.discards_left then
			G.hand:change_size(-math.floor(card.ability.extra.discards_cache * card.ability.extra.hand_size))
			G.hand:change_size(math.floor(G.GAME.current_round.discards_left * card.ability.extra.hand_size))

			card.ability.extra.discards_cache = G.GAME.current_round.discards_left
		end
	end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.in_deck = true
    end,

}


-- Yumama
-- Use to add 3 randomly enhanced cards with the rank of 1 selected card to your hand
FishAndChips.Fish {
	key = "segg_yumama",
	atlas = "segg_fishies",
	pos = { x = 4, y = 1 },

	weight = 15,

	ppu_coder = { "stupid" },
	ppu_artist = { "egg_node" },

	requires_hand = true,
	blueprint_compat = false,
	attributes = { "usable", "function", "generation" },

    config = { max_highlighted = 1, extra = { cards = 3 } },
	stats = {
		weight = {min = 0.5, max = 10.},
		length = {min = 0.2, max = 4.}
	},
	environments = {
		pier = 2.,
	},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards, card.ability.max_highlighted } }
    end,

	use = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function()

				local enh_pool = {}
                for _, enhancement_center in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                    if enhancement_center.key ~= 'm_stone' and not enhancement_center.overrides_base_rank then
                        enh_pool[#enh_pool + 1] = enhancement_center.key
                    end
                end

				local cards = {}

				-- Support multiple highlighted for crossmod nonsense
				for _, target in ipairs(G.hand.highlighted) do
					
					local rank_name = target.config.card.value
					if rank_name then
						print("adding cards: "..card.ability.extra.cards)
						for _ = 1, card.ability.extra.cards do
							local enhancement = SMODS.poll_enhancement { guaranteed = true, options = enh_pool, key = "segg_yumama_enh" }
							cards[#cards + 1] = SMODS.add_card { set = "Base", rank = rank_name, enhancement = enhancement, key_append = "segg_yumama_card" }
						end

					end
				end

				SMODS.calculate_context({ playing_card_added = true, cards = cards })
                return true
            end
        }))
        delay(0.3)
	end,

    can_use = function(self, card)
        return G.hand and #G.hand.highlighted <= card.ability.max_highlighted and #G.hand.highlighted > 0
    end
}



--#endregion

