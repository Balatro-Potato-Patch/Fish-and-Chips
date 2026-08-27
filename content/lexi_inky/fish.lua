SMODS.Atlas({
	key = "l_i_fish",
	path = "lexi_inky/fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish({
	key = "l_i_id",
	atlas = "l_i_fish",
	pos = { x = 0, y = 1 },
	weight = 3,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"economy",
	},
	environments = {
		city_river = 1,
		pier = 1,
		wormhole = 1,
	},
	cost = 4,
	config = {
		extra = {
			sand = 1,
		},
	},
	stats = {
		weight = { min = 0.003, max = 0.006 },
		length = { min = 0.08, max = 0.086 },
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sand,
			},
		}
	end,
	calc_sand_dollar_bonus = function(self, card)
		local econFish = 0
		for k, v in ipairs(G.fac_fish_area.cards) do
			if v:has_attribute("economy") then
				econFish = econFish + 1
			end
		end
		if econFish > 0 then
			return econFish * card.ability.extra.sand
		end
	end,
	badge_key = "k_fac_l_i_id",
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_feather",
	atlas = "l_i_fish",
	pos = { x = 1, y = 1 },
	weight = 3,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"suit", "modify_card",
	},
	environments = {
		styx = 1,
	},
	cost = 4,
	config = {
		extra = {},
	},
	stats = {
		weight = { min = 0, max = 0 },
		length = { min = 0.22, max = 0.27 },
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = { localize(card.ability.extra.suit or "Hearts", "suits_plural"),
        	colours = { G.C.SUITS[card.ability.extra.suit] } },
		}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			for k, v in ipairs(context.full_hand) do
				G.E_MANAGER:add_event(Event({
					func = function()
						v:juice_up()
						assert(SMODS.change_base(v, card.ability.extra.suit or "Hearts"))
						return true
					end,
				}))
			end
		end

		if context.end_of_round and context.main_eval and not context.game_over and not context.blueprint then
			local all_suits = {}
			for _, v in pairs(SMODS.Suits) do
				if (not v.in_pool or v:in_pool()) and card.ability.extra.suit ~= v.key then all_suits[#all_suits + 1] = v.key end
			end
			card.ability.extra.suit = pseudorandom_element(all_suits, "fish_fac_l_i_feather")
			return { message = localize("k_reset") }
		end
	end,
  	set_ability = function(self, card, initial, delay_sprites)
  		local all_suits = {}
		for _, v in pairs(SMODS.Suits) do
			if (not v.in_pool or v:in_pool()) and card.ability.extra.suit ~= v.key then all_suits[#all_suits + 1] = v.key end
		end
		card.ability.extra.suit = pseudorandom_element(all_suits, "fish_fac_l_i_feather")
  	end,
	badge_key = "k_fac_l_i_feather",
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_square",
	atlas = "l_i_fish",
	pos = { x = 0, y = 0 },
	weight = 9,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"economy",
		"rank",
		"four",
	},
	environments = {
		calm_pond = 1,
		garden = 1,
	},
	stats = {
		weight = { min = 4, max = 12 },
		length = { min = 0.6, max = 2.2 },
	},
	cost = 2,
	config = {
		extra = {
			sand = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sand,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 4 then
				return {
					sand_dollars = card.ability.extra.sand,
				}
			end
		end
	end,
	disable_fish_scaling = true,
})

SMODS.Atlas({
	key = "l_i_propal",
	path = "lexi_inky/propal_fisj.png",
	px = 71,
	py = 95,
})

local letters = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
}

local getRandWood = function()
	return pseudorandom_element(letters, "fac_l_i_wood")
end

local getRandPlastic = function()
	return pseudorandom_element(letters, "fac_l_i_plastic")
end

local letterIndex = {}
for k, v in pairs(letters) do
	letterIndex[v] = k - 1
end

FishAndChips.Fish({
	key = "l_i_wood",
	atlas = "l_i_propal",
	pos = { x = 0, y = 0 },
	weight = 7,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"rank", "ace", "three", "seven",
		"mult", "perma_bonus", "modify_card",
	},
	environments = {
		pier = 1,
		styx = 1,
		backroom = 1,
	},
	stats = {
		weight = { min = 0.005, max = 0.01 },
		length = { min = 0.003, max = 0.0055 },
	},
	cost = 4,
	config = {
		extra = {
			letter = "A",
			perm_mult = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.letter,
				card.ability.extra.perm_mult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if
				context.other_card:get_id() == 14
				or context.other_card:get_id() == 3
				or context.other_card:get_id() == 7
			then
				context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0)
					+ card.ability.extra.perm_mult
				local raWood = getRandWood()
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card.children.center:set_sprite_pos({ x = letterIndex[raWood], y = 0 })
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				card.ability.extra.letter = raWood
				return {
					message = localize("k_upgrade_ex"),
					colour = G.C.MULT,
				}
			end
		end
	end,
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_plastic",
	atlas = "l_i_propal",
	pos = { x = 0, y = 1 },
	weight = 7,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"rank", "four", "eight",
		"score",
	},
	environments = {
		pier = 1,
		styx = 1,
		wormhole = 1,
	},
	stats = {
		weight = { min = 0.005, max = 0.01 },
		length = { min = 0.003, max = 0.0055 },
	},
	cost = 4,
	config = {
		extra = {
			letter = "A",
			score = 100,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.letter,
				card.ability.extra.score,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 4 or context.other_card:get_id() == 8 then
				local raPlastic = getRandPlastic()
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card.children.center:set_sprite_pos({ x = letterIndex[raPlastic], y = 1 })
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				card.ability.extra.letter = raPlastic
				return {
					score = card.ability.extra.score,
				}
			end
		end
	end,
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_phish_bait",
	atlas = "l_i_fish",
	pos = { x = 2, y = 1 },
	weight = 7,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"xmult", "debuff", "position",
	},
	environments = {
		backroom = 1,
		city_river = 1,
	},
	stats = {
		weight = { min = 0, max = 1 },
		length = { min = 0, max = 1 },
	},
	cost = 4,
	config = {
		extra = {
			xmult = 3,
			caught = false,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
			},
			key = card.ability.extra.caught and "fish_fac_l_i_phish_bait_real" or nil,
		}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if not card.ability.extra.caught then
				card.ability.extra.caught = true
			end
			local pos
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then
					pos = i
					break
				end
			end
			local leftFish = G.fac_fish_area.cards[pos - 1]
			local rightFish = G.fac_fish_area.cards[pos + 1]
			for k, v in ipairs(G.fac_fish_area.cards) do
				SMODS.debuff_card(v, false, card.config.center.key.."_"..card.sort_id)
			end
			if leftFish then SMODS.debuff_card(leftFish, true, card.config.center.key.."_"..card.sort_id) end
			if rightFish then SMODS.debuff_card(rightFish, true, card.config.center.key.."_"..card.sort_id) end
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
	disable_fish_scaling = true,
	badge_key = "b_fac_bait",
})

FishAndChips.Fish({
	key = "l_i_yhsifishy",
	atlas = "l_i_fish",
	pos = { x = 1, y = 0 },
	weight = 8,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"rank", "economy",
	},
	environments = {
		aquifer = 1,
		pier = 1,
		calm_pond = 1,
	},
	stats = {
		weight = { min = 1, max = 2 },
		length = { min = 1, max = 2 },
	},
	cost = 4,
	config = {
		extra = {
			sand = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sand,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and #context.full_hand == 5 then
			if
				context.full_hand[1]:get_id() == context.full_hand[5]:get_id()
				and context.full_hand[2]:get_id() == context.full_hand[4]:get_id()
			then
				return {
					sand_dollars = card.ability.extra.sand,
				}
			end
		end
	end,
	disable_fish_scaling = true,
})

SMODS.Sound({
	key = "l_i_87",
	path = "lexi_inky/87.ogg",
})

FishAndChips.Fish({
	key = "l_i_freddy",
	atlas = "l_i_fish",
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"rank", "modify_card",
	},
	environments = {
		styx = 1,
		chocolate_river = 1,
		city_river = 1,
	},
	stats = {
		weight = { min = 170, max = 187 },
		length = { min = 1.987, max = 2.3 },
	},
	cost = 4,
	config = {
		extra = {},
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.initial_scoring_step and not context.blueprint then
			if #context.scoring_hand == 4 and #context.scoring_hand == #context.full_hand then
				assert(SMODS.change_base(context.scoring_hand[1], nil, "Ace"))
				context.scoring_hand[1]:juice_up()
				assert(SMODS.change_base(context.scoring_hand[2], nil, "9"))
				context.scoring_hand[2]:juice_up()
				assert(SMODS.change_base(context.scoring_hand[3], nil, "8"))
				context.scoring_hand[3]:juice_up()
				assert(SMODS.change_base(context.scoring_hand[4], nil, "7"))
				context.scoring_hand[4]:juice_up()
			end
		end
	end,
	on_catch = function(self, card)
		play_sound("fac_l_i_87")	-- no please no i beg of you don't play a sound with volume 2 (ghostsalt)
	end,
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_kevin",
	atlas = "l_i_fish",
	pos = { x = 3, y = 1 },
	weight = 9,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"xmult",
	},
	environments = {
		volcano = 1,
		city_river = 1,
		garden = 1,
	},
	stats = {
		weight = { min = 2.24, max = 2.33 },
		length = { min = 0.039, max = 0.046 },
	},
	cost = 4,
	config = {
		extra = {
			xmult = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if G.GAME.blind and G.GAME.blind.in_blind then
				if G.GAME.chips <= G.GAME.blind.chips / 4 then
					return {
						xmult = card.ability.extra.xmult,
					}
				end
			end
		end
	end,
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_fof",
	atlas = "l_i_fish",
	pos = { x = 2, y = 0 },
	pixel_size = {
		h = 45,
		w = 53,
	},
	display_size = {
		h = 45 * 1.33,
		w = 53 * 1.33,
	},
	weight = 8,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"discards",
		"usable",
		"food",
	},
	environments = {
		soup = 1,
		chocolate_river = 1,
		swamp = 1,
	},
	stats = {
		weight = { min = 0.13, max = 0.15 },
		length = { min = 0.1, max = 0.2 },
	},
	cost = 3.79,
	config = {
		extra = {
			discards = 2,
		},
	},
	blueprint_compat = false,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.discards,
			},
		}
	end,
	can_use = function(self, card)
		return G.GAME.blind and G.GAME.blind.in_blind
	end,
	use = function(self, card)
		ease_discard(card.ability.extra.discards)
	end,
	badge_key = "k_fac_l_i_burger",
	disable_fish_scaling = true,
	button_key = "b_fac_l_i_eat",
})

SMODS.Sound({
	key = "l_i_music",
	path = "lexi_inky/music.ogg",
	sync = false,
})

SMODS.Sound({
	key = "music_l_i",
	path = "lexi_inky/music.ogg",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(SMODS.find_card("fish_fac_l_i_fish_ost")) and 10000
	end,
})

FishAndChips.Fish({
	key = "l_i_fish_ost",
	atlas = "l_i_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	treasure = true,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"passive",
		"xmult",
		"economy",
	},
	disable_fish_scaling = true,
	environments = {
		swamp = 1,
		calm_pond = 1,
		backroom = 1,
	},
	stats = {
		weight = { min = 0.035, max = 0.055 },
		length = { min = 0.01, max = 0.015 },
	},
	cost = 10,
	config = {
		extra = {
			xmult = 4,
			dollars = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local key = self.key
        if FishAndChips.mod.config.family_friendly then
            key = key.."_ff"
        end
		return {
			key = key,
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.dollars,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
				dollars = card.ability.extra.dollars,
			}
		end
	end,
	badge_key = "k_fac_l_i_music",
})

FishAndChips.Fish({
	key = "l_i_fishsocks",
	atlas = "l_i_fish",
	pos = { x = 4, y = 1 },
	weight = 2,
	ppu_coder = {
		"sheila",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"generation",
	},
	environments = {
		backroom = 1,
		volcano = 1,
	},
	cost = 4,
	config = {
		extra = {
			type = "Pair",
		},
	},
	stats = {
		weight = { min = 0.04, max = 0.06 },
		length = { min = 0.018, max = 0.026 },
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return {
			vars = {
				localize(card.ability.extra.type, "poker_hands"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.scoring_name == "Pair" then
			if #G.fac_fish_area.cards < G.fac_fish_area.config.card_limits.total_slots then
				SMODS.add_card({
					set = "fac_Fish",
					edition = SMODS.poll_edition({
						key = "fac_l_i_fishsocks",
						guaranteed = true,
						no_negative = true,
					}),
				})
			end
		end
	end,
	disable_fish_scaling = true,
})
