-- Developer

PotatoPatchUtils.Developer({
	name = 'Nick',
	loc = true,
	atlas = 'fac_w_d_seuss_credits',
	pos = { x = 0, y = 0 },
	colour = HEX("d0d0d0"),
	fac_partner = 'fac_Jolyne',
	joint_credits = 2,
})

PotatoPatchUtils.Developer({
	name = 'Jolyne',
	loc = true,
	colour = HEX("FCB3EA"),
	fac_partner = 'fac_Nick'
})

-- Atlas

SMODS.Atlas({ -- All Fish
	key = "w_d_seuss_fish",
	path = "w_d_seuss/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({ -- Credit Art
	key = "w_d_seuss_credits",
	path = "w_d_seuss/credits.png",
	px = 142,
	py = 95,
})

SMODS.Atlas({ -- Lord X
	key = "i_miss_the_quiet",
	path = "w_d_seuss/i_miss_the_quiet.png",
	px = 128,
	py = 72,
})

SMODS.Atlas({ -- Majin
	key = "sinister",
	path = "w_d_seuss/sinister.png",
	px = 128,
	py = 72,
})

SMODS.Atlas({ -- Redglove
	key = "red_handed",
	path = "w_d_seuss/red_handed.png",
	px = 128,
	py = 72,
})

SMODS.Atlas({ -- Faker
	key = "st_solis",
	path = "w_d_seuss/st_solis.png",
	px = 128,
	py = 72,
})

-- Attributes

SMODS.Attribute { -- Old
	key = 'deltarune'
}

-- Sounds

SMODS.Sound { -- Old
	key = "gerson_laugh",
	path = "w_d_seuss/gerson_laugh.ogg",
}

SMODS.Sound { -- Spalmon
	key = "spamtonf1",
	path = "w_d_seuss/spamtonf1.ogg",
}

SMODS.Sound { -- G_____
	key = "smile",
	path = "w_d_seuss/smile.ogg",
}

SMODS.Sound { -- 'Kay
	key = "swing",
	path = "w_d_seuss/swing.ogg",
}

SMODS.Sound { -- Actually
	key = "twister",
	path = "w_d_seuss/twister.ogg",
}

SMODS.Sound { -- Know
	key = "icetomb",
	path = "w_d_seuss/icetomb.ogg",
}

SMODS.Sound { -- Jack
	key = "calming",
	path = "w_d_seuss/calming.ogg",
}

SMODS.Sound { -- Great
	key = "mean_fellow",
	path = "w_d_seuss/mean_fellow.ogg",
}

-- Colours

G.ARGS.LOC_COLOURS['inscryption_blue'] = HEX("01eaff") -- Old
G.ARGS.LOC_COLOURS['jolyne'] = HEX("FCB3EA")           -- Hyperfixation
G.ARGS.LOC_COLOURS['incognito'] = HEX("d0d0d0")        -- Incognito
G.ARGS.LOC_COLOURS['spalmon_pink'] = HEX("ffaec9")     -- Spalmon
G.ARGS.LOC_COLOURS['spalmon_gold'] = HEX("fff200")     -- Spalmon

-- Fonts

SMODS.Font({
	key = "tiktoksans",
	path = "TikTokSans.ttf",
	FONTSCALE = 0.15,
	squish = 1,
	TEXT_HEIGHT_SCALE = 0.75,
	TEXT_OFFSET = { x = 0, y = -10 }
})

-- No Sell (Thank you Hyperfixation Priceless)

local nosell_hook = Card.can_sell_card -- Bad
function Card:can_sell_card(context)
	if self.config.center.key == 'fish_fac_bad' then
		return false
	else
		return nosell_hook(self, context)
	end
end

-- Press F1 (Thank you Incognito)

local keypress = love.keypressed -- Spalmon
function love.keypressed(key)
	if key == "f1" then
		if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
			SMODS.calculate_context({ key_press_f1 = true })
		end
	end
	return (keypress(key))
end

-- Rotate Degree (Thank you MoreFluff Rotarot)

local card_draw = Card.draw -- Darwin, Togore, 'Kay, Great, Gaster
function Card:draw(layer, ...)
	if self.config and self.config.center then
		if self.config.center.key == 'fish_fac_darwin' or self.config.center.key == 'fish_fac_togore' or self.config.center.key == 'fish_fac_kay' or self.config.center.key == 'fish_fac_great' then
			self.VT.r = self.VT.r + (3 * math.pi / 2)
			for k, v in pairs(self.children) do
				v.VT.r = v.VT.r + (3 * math.pi / 2)
			end
		elseif (self.config.center.key == 'fish_fac_gaster') then
			self.VT.r = self.VT.r + (1 * math.pi / 3)
			for k, v in pairs(self.children) do
				v.VT.r = v.VT.r + (1 * math.pi / 3)
			end
		end
	end

	card_draw(self, layer, ...)

	if self.config and self.config.center then
		if self.config.center.key == 'fish_fac_darwin' or self.config.center.key == 'fish_fac_togore' or self.config.center.key == 'fish_fac_kay' or self.config.center.key == 'fish_fac_great' then
			self.VT.r = self.VT.r - (3 * math.pi / 2)
			for k, v in pairs(self.children) do
				v.VT.r = v.VT.r - (3 * math.pi / 2)
			end
		elseif (self.config.center.key == 'fish_fac_gaster') then
			self.VT.r = self.VT.r - (1 * math.pi / 3)
			for k, v in pairs(self.children) do
				v.VT.r = v.VT.r - (1 * math.pi / 3)
			end
		end
	end
end

-- One Fish

FishAndChips.Fish {
	key = "one",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "Jolyne" },
	ppu_artist = { "Jolyne" },
	attributes = { "mult", "ace", "rank" },
	config = {
		extra = {
			mult = 1
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = { min = 0.50, max = 1.41 },
		length = { min = 0.15, max = 0.30 }
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play
			and context.other_card:get_id() == 14 then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
}

-- Two Fish

FishAndChips.Fish {
	key = "two",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 0 },
	weight = 8,
	ppu_coder = { "Jolyne" },
	ppu_artist = { "Jolyne" },
	attributes = { "mult", "two", "rank" },
	config = {
		extra = {
			mult = 2
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = { min = 1.00, max = 2.82 },
		length = { min = 0.30, max = 0.60 }
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play
			and context.other_card:get_id() == 2 then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
}

-- Red Fish

FishAndChips.Fish {
	key = "red",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 0 },
	weight = 7,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "chips", "mult", "balance", "hand_type", },
	config = {
		extra = {
			value = 10
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = { min = 1.36, max = 6.81 },
		length = { min = 0.46, max = 1.02 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.value
			}
		}
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step then
			local value = G.GAME.hands[G.GAME.last_hand_played].chips
			return { chips = -hand_chips + value, mult = hand_chips * (card.ability.extra.value / 100) }
		end
	end
}

-- Blue Fish

FishAndChips.Fish {
	key = "blue",
	atlas = "w_d_seuss_fish",
	pos = { x = 3, y = 0 },
	weight = 7,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "chips", "mult", "balance", "hand_type", },
	config = {
		extra = {
			value = 50
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = { min = 1.36, max = 6.80 },
		length = { min = 0.30, max = 0.61 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.value
			}
		}
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step then
			local value = G.GAME.hands[G.GAME.last_hand_played].mult
			return { chips = mult * (card.ability.extra.value / 100), mult = -mult + value }
		end
	end
}

-- Old Fish

FishAndChips.Fish {
	key = "old",
	atlas = "w_d_seuss_fish",
	pos = { x = 4, y = 0 },
	weight = 8,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "treasure", "usable", "generation", "deltarune" },
	config = {
		extra = {
		}
	},
	environments = {
		garden = 5,
	},
	stats = {
		weight = { min = 0.90, max = 1.80 },
		length = { min = 1.70, max = 1.80 }
	},
	blueprint_compat = false,
	treasure = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	use = function(self, card, area)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('fac_gerson_laugh')
				local cen_pool = {}
				for _, deltarune_fish_center in pairs(G.P_CENTER_POOLS["fac_Fish"]) do
					if deltarune_fish_center.attributes.deltarune and deltarune_fish_center.key ~= 'fish_fac_old' then
						cen_pool[#cen_pool + 1] = deltarune_fish_center
					end
				end
				local deltarune_fish = pseudorandom_element(cen_pool, 'gerson').key
				if deltarune_fish then
					SMODS.add_card({ key = deltarune_fish, area = G.fac_fish_area })
				end
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		delay(0.6)
	end,
	can_use = function(self, card)
		return G.fac_fish_area and #G.fac_fish_area.cards < G.fac_fish_area.config.card_limit
	end
}

-- Bad Fish

FishAndChips.Fish {
	key = "bad",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 1 },
	weight = 1,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "xblindsize", "destroy_card", },
	config = {
		extra = {
			blind = 1.5
		}
	},
	environments = {
		wormhole = 5,
	},
	stats = {
		weight = { min = 0.50, max = 5.00 },
		length = { min = 1.00, max = 2.00 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blind } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			return {
				xblindsize = card.ability.extra.blind
			}
		end
		if context.final_scoring_step then
			SMODS.destroy_cards(card, nil, nil, true)
			return {
				message = localize('k_extinct_ex'),
				colour = HEX("01eaff")
			}
		end
	end
}

-- Darwin

FishAndChips.Fish {
	key = "darwin",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 1 },
	weight = 1,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "xmult" },
	config = {
		extra = {
			xmult = 3,
			rounds = 5,
			rounds_total = 5
		}
	},
	environments = {
		garden = 5,
	},
	stats = {
		weight = { min = 79.00, max = 85.00 },
		length = { min = 1.82, max = 1.94 }
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.rounds_total, card.ability.extra.rounds, ppu_bubbles = { card.ability.extra.rounds == 0 and "active" or "inactive" } } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if card.ability.extra.rounds <= 0 then
			else
				card.ability.extra.rounds = card.ability.extra.rounds - 1
				return {
					message = localize('k_omw'),
				}
			end
		end
		if context.joker_main and card.ability.extra.rounds <= 0 then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}

-- Pear Fish

FishAndChips.Fish {
	key = "pear",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 1 },
	weight = 4,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "hand_type", "food", "hand_type", "destroy_card", },
	config = {
		extra = {
			pear = 5,
			pear_total = 5,
			levels = 1
		}
	},
	environments = {
		pier = 5,
		soup = 5,
	},
	eternal_compat = false,
	stats = {
		weight = { min = 0.16, max = 0.18 },
		length = { min = 0.05, max = 0.10 }
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.pear_total, card.ability.extra.pear, card.ability.extra.levels } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and not context.blueprint then
			if card.ability.extra.pear - 1 <= 0 then
				SMODS.destroy_cards(card, nil, nil, true)
				return {
					level_up = card.ability.extra.levels,
					level_up_hand = "Pair",
					message = localize('k_eaten_ex'),
					colour = G.C.NIC_TETO
				}
			else
				card.ability.extra.pear = card.ability.extra.pear - 1
			end
		end

		if context.fish and context.fac_end_fishing then
			return {
				level_up = card.ability.extra.levels,
				level_up_hand = "Pair",
				message = localize('k_level_up_ex'),
				colour = HEX("FCB3EA")
			}
		end
		if context.failed and context.fac_end_fishing then
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					attention_text({
						text = localize('k_nope_ex'),
						scale = 1.3,
						hold = 1.4,
						major = card,
						backdrop_colour = G.C.SECONDARY_SET.Tarot,
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
}

-- Sutuna, King of Sturgeons

FishAndChips.Fish {
	key = "sukuna",
	atlas = "w_d_seuss_fish",
	pos = { x = 3, y = 1 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "mult", "chips", "destroy_card", "sell_value", "scaling", "usable", "rank", },
	config = {
		extra = {
			attack = "Dismantle",
			mult = 0,
			chips = 0,
		}
	},
	environments = {
		volcano = 5,
	},
	stats = {
		weight = { min = 136.08, max = 181.44 },
		length = { min = 2.08, max = 2.18 }
	},
	requires_hand = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = 'w_d_seuss_dismantle', set = "Other" }
		info_queue[#info_queue + 1] = { key = 'w_d_seuss_cleave', set = "Other" }
		return { vars = { card.ability.extra.mult, card.ability.extra.chips, card.ability.extra.attack } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult,
				chips = card.ability.extra.chips
			}
		end
	end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card, area)
		if card.ability.extra.attack == "Dismantle" then
			local destructable_fish = {}
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] ~= card and not SMODS.is_eternal(G.fac_fish_area.cards[i], card) and not G.fac_fish_area.cards[i].getting_sliced then
					destructable_fish[#destructable_fish + 1] = G.fac_fish_area.cards[i]
				end
			end
			local fish_sliced = pseudorandom_element(destructable_fish, 'dismantle')
			if fish_sliced then
				fish_sliced.getting_sliced = true
				G.E_MANAGER:add_event(Event({
					func = function()
					    card.ability.extra.scalar_sell_cost = fish_sliced.sell_cost * 2
    					SMODS.scale_card (card, {
    					    ref_table = card.ability.extra,
    						ref_value = "mult",
    						scalar_value = "scalar_sell_cost",
    						no_message = true,
    					})
                        card.ability.extra.scalar_sell_cost = nil
						card:juice_up(0.8, 0.8)
						play_sound('slice1', 0.96 + math.random() * 0.08)
						fish_sliced:start_dissolve({ G.C.RED }, nil, 1.6)
						return true
					end
				}))
			end
			card.ability.extra.attack = "Cleave"
			SMODS.calculate_effect({ message = localize('k_cleave'), colour = G.C.CHIPS }, card)
		elseif card.ability.extra.attack == "Cleave" then
			G.E_MANAGER:add_event(Event({
				func = function()
                    card.ability.extra.scalar_rank = G.hand.highlighted[1].base.id * 3
   					SMODS.scale_card (card, {
   					    ref_table = card.ability.extra,
  						ref_value = "chips",
  						scalar_value = "scalar_rank",
  						no_message = true,
   					})
                    card.ability.extra.scalar_rank = nil
					card:juice_up(0.8, 0.8)
					play_sound('slice1', 0.96 + math.random() * 0.08)
					SMODS.destroy_cards(G.hand.highlighted)
					return true
				end
			}))
			card.ability.extra.attack = "Dismantle"
			SMODS.calculate_effect({ message = localize('k_dismantle'), colour = G.C.MULT }, card)
		end
	end,
	can_use = function(self, card)
		local destructable_fish = {}
		for i = 1, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] ~= card and not SMODS.is_eternal(G.fac_fish_area.cards[i], card) and not G.fac_fish_area.cards[i].getting_sliced then
				destructable_fish[#destructable_fish + 1] = G.fac_fish_area.cards[i]
			end
		end
		local fish_sliced = pseudorandom_element(destructable_fish, 'dismantle')
		return card.ability.extra.attack == "Dismantle" and fish_sliced or
			card.ability.extra.attack == "Cleave" and G.hand and #G.hand.highlighted == 1
	end
}

-- Troutoru GoFish

FishAndChips.Fish {
	key = "gojo",
	atlas = "w_d_seuss_fish",
	pos = { x = 4, y = 1 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "full_deck", "editions", "balance", "chance" },
	config = {
		extra = {
			attack = "Amplified"
		}
	},
	environments = {
		city_river = 5,
	},
	stats = {
		weight = { min = 79.00, max = 84.00 },
		length = { min = 1.80, max = 2.10 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		local full_deck = 0
		local negative = 0
		local polychrome = 0
		local amplified = 0
		local reversal = 0
		if G.playing_cards then
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card.edition and playing_card.edition.negative == true then negative = negative + 1 end
			end
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card.edition and playing_card.edition.polychrome == true then polychrome = polychrome + 1 end
			end
			full_deck = #G.playing_cards
			amplified = negative / full_deck
			reversal = polychrome / full_deck
		end
		info_queue[#info_queue + 1] = { key = 'w_d_seuss_amplified', set = "Other", vars = { G.playing_cards and math.floor(amplified * 100) or 0 } }
		info_queue[#info_queue + 1] = { key = 'w_d_seuss_reversal', set = "Other", vars = { G.playing_cards and math.floor(reversal * 100) or 0 } }
		return {
			vars = {
				card.ability.extra.attack == "Amplified" and math.floor(amplified * 100) or
				card.ability.extra.attack == "Reversal" and math.floor(reversal * 100),
				card.ability.extra.attack
			}
		}
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step then
			local amplified = 0
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card.edition and playing_card.edition.negative == true then amplified = amplified + 1 end
			end
			local reversal = 0
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card.edition and playing_card.edition.polychrome == true then reversal = reversal + 1 end
			end
			local full_deck = #G.playing_cards
			if card.ability.extra.attack == "Amplified" then
				if SMODS.pseudorandom_probability(card, "amplified", amplified, full_deck, "amplified", true) then
					return { balance = true }
				else
					return { message = localize('k_nope_ex'), colour = G.C.CHIPS }
				end
			elseif card.ability.extra.attack == "Reversal" then
				if SMODS.pseudorandom_probability(card, "reversal", reversal, full_deck, "reversal", true) then
					return { balance = true }
				else
					return { message = localize('k_nope_ex'), colour = G.C.MULT }
				end
			end
		end
		if context.end_of_round and context.game_over == false and context.main_eval then
			if card.ability.extra.attack == "Amplified" then
				card.ability.extra.attack = "Reversal"
				SMODS.calculate_effect({ message = localize('k_reversal'), colour = G.C.MULT }, card)
			elseif card.ability.extra.attack == "Reversal" then
				card.ability.extra.attack = "Amplified"
				SMODS.calculate_effect({ message = localize('k_amplified'), colour = G.C.CHIPS }, card)
			end
		end
	end,
}

-- Lord X-ray (Lord X)

FishAndChips.Fish {
	key = "lordx",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 2 },
	weight = 2,
	ppu_coder = { "Jolyne" },
	ppu_artist = { "Jolyne" },
	attributes = { "xmult" },
	config = {
		extra = {
			count = 1,
			xmult = 3
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = { min = 33.53, max = 34.93 },
		length = { min = 0.98, max = 1.01 }
	},
	flavour_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_i_miss_the_quiet") } } }
	end,
	loc_vars = function(self, info_queue, card)
		local alone = false
		if G.playing_cards and #G.fac_fish_area.cards == card.ability.extra.count and G.fac_fish_area.cards[1] == card then
			alone = true
		end
		return {
			vars = {
				card.ability.extra.xmult,
				ppu_bubbles = { alone == true and "active" or "inactive" }
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			if #G.fac_fish_area.cards == card.ability.extra.count and G.fac_fish_area.cards[1] == card then
				return {
					xmult = card.ability.extra.xmult
				}
			end
		end
	end
}

-- Marlin (Majin)

FishAndChips.Fish {
	key = "majin",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 2 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "usable", "generation", "rank" },
	config = {
		extra = {
			attempts = 0,
			amount = 5,
			colour = { G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE, G.C.UI.TEXT_INACTIVE },
			insert = { "#", "#", "#", "#", "#", "#" },
			code = {'4', '6', '1', '2', '2', '5'},
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = { min = 33.53, max = 34.93 },
		length = { min = 0.98, max = 1.01 }
	},
	requires_hand = true,
	blueprint_compat = false,
	flavour_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_sinister") } } }
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				colours = {
					card.ability.extra.colour[1], card.ability.extra.colour[2], card.ability.extra.colour[3], card.ability.extra.colour[4], card.ability.extra.colour[5], card.ability.extra.colour[6]
				},
				card.ability.extra.insert[1], card.ability.extra.insert[2], card.ability.extra.insert[3], card.ability.extra.insert[4], card.ability.extra.insert[5], card.ability.extra.insert[6],
				ppu_bubbles = { card.ability.extra.attempts == 6 and "usable" or "inactive" }
			}
		}
	end,
	calculate = function(self, card, context)
	end,
	keep_on_use = function(self, card)
		local verify = true
		if card.ability.extra.attempts == 6 then
			local correct = 0
			for i = 1, 6 do
				if card.ability.extra.insert[i] == card.ability.extra.code[i] then
					correct = correct + 1
				end
			end
			if correct == 6 then
				verify = false
			end
		end
		return verify
	end,
	use = function(self, card, area)
		if card.ability.extra.attempts < 6 then
			card.ability.extra.attempts = card.ability.extra.attempts + 1
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					play_sound('tarot2')
					local number = G.hand.highlighted[1].base.id
					if number == 10 then
						number = 0
					elseif number == 14 then
						number = 1
					end
					card.ability.extra.insert[card.ability.extra.attempts] = tostring(number)
					card.ability.extra.colour[card.ability.extra.attempts] = G.C.BLUE
					G.hand:unhighlight_all()
					return true
				end
			}))
			local eval = function(card) return card.ability.extra.attempts == 6 and not card.REMOVED end
			juice_card_until(card, eval, true)
		else
			local correct = 0
			for i = 1, 6 do
				if card.ability.extra.insert[i] == card.ability.extra.code[i] then
					correct = correct + 1
				end
			end
			if correct == 6 then
				for i = 1, card.ability.extra.amount do
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.4,
						func = function()
							SMODS.add_card({ set = 'Consumeables' })
							return true
						end
					}))
				end
				SMODS.calculate_effect({ message = localize('k_correct_ex') }, card)
			else
				card.ability.extra.attempts = 0
				for i = 1, 6 do
					card.ability.extra.insert[i] = "#"
					card.ability.extra.colour[i] = G.C.UI.TEXT_INACTIVE
				end
				SMODS.calculate_effect({ message = localize('k_failure_ex') }, card)
			end
		end
	end,
	can_use = function(self, card)
		local use = false
		if card.ability.extra.attempts < 6 then
			use = #G.hand.highlighted > 0 and #G.hand.highlighted <= 1 and not SMODS.Ranks[G.hand.highlighted[1].base.value].face and not SMODS.has_no_rank(G.hand.highlighted[1])
		else
			use = true
		end
		return G.hand and use
	end
}

-- Red-Herring (Redglove)

FishAndChips.Fish {
	key = "redglove",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 2 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "xmult" },
	config = {
		extra = {
			xmult = 3
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = { min = 33.53, max = 34.93 },
		length = { min = 2.24, max = 2.51 }
	},
	flavour_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_red_handed") } } }
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { ppu_bubbles = { next(SMODS.find_card("fish_fac_lordx")) and "active" or "inactive" } } }
	end,
	calculate = function(self, card, context)
		if next(SMODS.find_card("fish_fac_lordx")) and context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end
}

-- Flounder (Faker)

FishAndChips.Fish {
	key = "faker",
	atlas = "w_d_seuss_fish",
	pos = { x = 3, y = 2 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "economy", "lose_economy", "usable", },
	config = {
		extra = {
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = { min = 33.53, max = 34.93 },
		length = { min = 0.98, max = 1.01 }
	},
	flavour_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_st_solis") } } }
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	calculate = function(self, card, context)
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				local sand_dollar = G.GAME.fac_sand_dollars
				local dollar = G.GAME.dollars
				ease_dollars(-dollar + sand_dollar, true)
				ease_sand_dollars(-sand_dollar + dollar,true)
				return true
			end
		}))
		delay(0.2)
	end,
	can_use = function(self, card)
		return true
	end,
}

-- Spalmon

FishAndChips.Fish {
	key = "spalmon",
	atlas = "w_d_seuss_fish",
	pos = { x = 4, y = 2 },
	weight = 6,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "generation", "deltarune" },
	config = {
		extra = {
			f1 = true,
			bait = 1
		}
	},
	stats = {
		weight = { min = 13.61, max = 22.68 },
		length = { min = 1.57, max = 1.63 }
	},
	environments = {
		wormhole = 5,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { ppu_bubbles = { card.ability.extra.f1 == true and "active" or "inactive" } } }
	end,
	calculate = function(self, card, context)
		if context.key_press_f1 and card.ability.extra.f1 == true and G.STATE == G.STATES.FAC_FISHING then
			local w = (G.CARD_W + 0.1) * card.ability.extra.bait * 2 - 0.1
			local h = G.CARD_H
			G.fac_temp_bait_area = CardArea(
				card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
				w, h,
				{
					type = "joker",
					card_limit = card.ability.extra.bait,
					highlight_limit = 1,
					highlighted_limit = 1,
					align_buttons = true,
					bg_colour = G.C.CLEAR,
					fixed_limit = true,
					no_card_count = true,
				}
			)
			play_sound('fac_spamtonf1')
			for i = 1, card.ability.extra.bait do
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.4,
					func = function()
						card.ability.extra.f1 = false
						local bait = SMODS.add_card({ set = 'fac_Bait', area = G.fac_temp_bait_area })
						FishAndChips.add_bait_to_inventory(bait.config.center_key)
						card:juice_up(0.3, 0.5)
						return true
					end
				}))
			end
			delay(0.5)
			for i = 1, card.ability.extra.bait do
				G.E_MANAGER:add_event(Event {
					func = function()
						G.fac_temp_bait_area.cards[1]:start_dissolve()
						return true
					end
				})
			end
			delay(0.5)
			G.E_MANAGER:add_event(Event {
				func = function()
					G.fac_temp_bait_area:remove()
					return true
				end
			})
			return {
				message = localize('k_bigtrout'),
			}
		end
		if context.end_of_round and context.game_over == false and context.main_eval and card.ability.extra.f1 == false then
			card.ability.extra.f1 = true
			local eval = function(card) return card.ability.extra.f1 == true and not card.REMOVED end
			juice_card_until(card, eval, true)
			return {
				message = localize('k_hokimama'),
			}
		end
	end
}

-- Forgotten Fish

FishAndChips.Fish {
	key = "forgotten",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 3 },
	weight = 1,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "sell_value", "scaling", "economy", "deltarune" },
	config = {
		extra = {
			price = 1
		}
	},
	environments = {
		wormhole = 5,
		styx = 5,
	},
	stats = {
		weight = { min = 0.89, max = 1.12 },
		length = { min = 0.46, max = 0.81 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.price } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing then
    		SMODS.scale_card(self, {
                ref_table = self.ability,
                ref_value = "extra_value",
                scalar_value = "extra",
                scaling_message = {
                    message = localize('k_val_up'),
                    colour = G.C.MONEY
                }
            })
            card:set_cost()
            return nil, true
		end
	end
}

-- Topegore (Tope) (Togore)

FishAndChips.Fish {
	key = "togore",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 3 },
	weight = 1,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "mult", "deltarune", "position", },
	config = {
		extra = {
			mult = 5
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = { min = 43.91, max = 45.19 },
		length = { min = 1.21, max = 1.85 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		local place = 1
		local even = false
		local middle = false
		if G.playing_cards then
			if #G.fac_fish_area.cards % 2 == 0 then
				even = true
			end
			local place = math.ceil(#G.fac_fish_area.cards / 2)
			if (G.fac_fish_area.cards[place] == card or (G.fac_fish_area.cards[place + 1] == card and even)) and #G.fac_fish_area.cards > 2 then
				middle = true
			end
		end
		return { vars = { card.ability.extra.mult, ppu_bubbles = { middle == true and "active" or "inactive" } } }
	end,
	calculate = function(self, card, context)
		local even = false
		if #G.fac_fish_area.cards % 2 == 0 then
			even = true
		end
		local place = math.ceil(#G.fac_fish_area.cards / 2)
		if context.joker_main and (G.fac_fish_area.cards[place] == card or (G.fac_fish_area.cards[place + 1] == card and even)) and #G.fac_fish_area.cards > 2 then
			return {
				mult = card.ability.extra.mult
			}
		end
	end
}

-- Notably Not Green Basster (Bass) (Gaster)

FishAndChips.Fish {
	key = "gaster",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 3 },
	weight = 1,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "economy", "usable", "deltarune" },
	config = {
		extra = {
			dollar = 66
		}
	},
	environments = {
		wormhole = 5,
	},
	stats = {
		weight = { min = 88.39, max = 88.40 },
		length = { min = 66.00, max = 67.00 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollar } }
	end,
	calculate = function(self, card, context)
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('fac_smile')
				ease_sand_dollars(-G.GAME.fac_sand_dollars + card.ability.extra.dollar,true)
				return true
			end
		}))
		delay(0.2)
	end,
	can_use = function(self, card)
		return true
	end,
}

--  'Kai (Koi) ('Kay)

FishAndChips.Fish {
	key = "kay",
	atlas = "w_d_seuss_fish",
	pos = { x = 3, y = 3 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "destroy_card", "chance", "usable", "deltarune" },
	config = {
		extra = {
			max_highlighted = 3
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = { min = 4.50, max = 16.00 },
		length = { min = 0.60, max = 0.90 }
	},
	requires_hand = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_highlighted } }
	end,
	calculate = function(self, card, context)
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('fac_swing')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					if SMODS.pseudorandom_probability(card, "s_swing", 1, card.ability.extra.max_highlighted, "s_swing", true) then
						SMODS.destroy_cards(G.hand.highlighted[i])
					else
						local failure = G.hand.highlighted[i]
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.4,
							func = function()
								attention_text({
									text = localize('k_miss'),
									scale = 1.3,
									hold = 1.4,
									major = failure,
									backdrop_colour = G.C.SECONDARY_SET.Tarot,
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
								failure:juice_up(0.3, 0.5)
								return true
							end
						}))
					end
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				play_sound('fac_swing')
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.2)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted
	end
}

-- Macktually (Mackerel) (Actually)

FishAndChips.Fish {
	key = "actually",
	atlas = "w_d_seuss_fish",
	pos = { x = 4, y = 3 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "modify_card", "perma_bonus", "usable", "deltarune" },
	config = {
		extra = {
			max_highlighted = 4,
			total = 0
		}
	},
	environments = {
		city_river = 5,
	},
	stats = {
		weight = { min = 0.61, max = 4.52 },
		length = { min = 0.31, max = 0.71 }
	},
	requires_hand = true,
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_highlighted } }
	end,
	calculate = function(self, card, context)
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('fac_twister')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					card.ability.extra.total = card.ability.extra.total + G.hand.highlighted[i].base.id
					return true
				end
			}))
		end
		delay(0.2)
		local value = 0
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				card.ability.extra.total = math.floor(card.ability.extra.total / #G.hand.highlighted)
				if card.ability.extra.total == 14 then
					value = "Ace"
				elseif card.ability.extra.total == 13 then
					value = "King"
				elseif card.ability.extra.total == 12 then
					value = "Queen"
				elseif card.ability.extra.total == 11 then
					value = "Jack"
				else
					value = tostring(card.ability.extra.total)
				end
				return true
			end
		}))
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				func = function()
					assert(SMODS.change_base(G.hand.highlighted[i], nil, value))
					G.hand.highlighted[i]:juice_up(0.3, 0.5)
					G.hand.highlighted[i].ability.perma_bonus = -card.ability.extra.total
					return true
				end
			}))
		end
		delay(0.2)
	end,
	can_use = function(self, card)
		local no_face = true
		for i = 1, #G.hand.highlighted do
			if SMODS.has_no_rank(G.hand.highlighted[i]) then
				no_face = false
			end
		end
		return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.max_highlighted and no_face
	end
}

-- Minknow (Minnow) (Know)

FishAndChips.Fish {
	key = "know",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 4 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "modify_card", "enhancements", "usable", "deltarune" },
	config = {
		extra = {
			amount = 5,
			enhancement = 'm_glass'
		}
	},
	environments = {
		garden = 5,
	},
	stats = {
		weight = { min = 13.05, max = 45.12 },
		length = { min = 1.24, max = 1.82 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.amount, localize { type = 'name_text', set = 'Enhanced', key = card.ability.extra.enhancement } } }
	end,
	calculate = function(self, card, context)
	end,
	use = function(self, card, area, copier)
		local temp_hand = {}
		local glass_cards = {}

		for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
		table.sort(temp_hand,
			function(a, b)
				return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
			end
		)
		pseudoshuffle(temp_hand, 'fish_fac_know')
		for i = 1, card.ability.extra.amount do
			glass_cards[#glass_cards + 1] = temp_hand[i]
		end

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				play_sound('fac_icetomb')
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		delay(0.2)
		for i = 1, #glass_cards do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					temp_hand[i]:set_ability(card.ability.extra.enhancement)
					temp_hand[i]:juice_up(0.3, 0.5)
					SMODS.debuff_card(temp_hand[i], true, 'icetomb')
					return true
				end
			}))
		end
		delay(0.2)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 1
	end,
}

-- Jack (Jack) (Jack)

FishAndChips.Fish {
	key = "jack",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 4 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "score", "xblindsize", "usable", "deltarune" },
	config = {
		extra = {
			blind = 20
		}
	},
	environments = {
		backroom = 5,
	},
	stats = {
		weight = { min = 0.59, max = 80.12 },
		length = { min = 0.33, max = 1.93 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blind / 100 } }
	end,
	calculate = function(self, card, context)
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('fac_calming')
				local before = to_number(G.GAME.blind.chips)
				local reduce = math.floor(to_number(G.GAME.blind.chips) * ((100 - card.ability.extra.blind) / 100))
				G.GAME.blind.chips = reduce
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
				G.GAME.chips = G.GAME.chips - math.floor((before - reduce) / 2)
				SMODS.calculate_effect({ message = '-' .. math.floor((before - reduce) / 2) .. ' Score', colour = G.C.DYN_UI.DARK }, card)
				return true
			end
		}))
		delay(0.2)
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.SELECTING_HAND
	end,
}

-- Great (White) (Great White) (Great)

FishAndChips.Fish {
	key = "great",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 4 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Jolyne" },
	attributes = { "lose_economy", "xblindsize", "usable", "deltarune" },
	config = {
		extra = {
			blind = 50
		}
	},
	environments = {
		volcano = 5,
	},
	stats = {
		weight = { min = 522.81, max = 2268.12 },
		length = { min = 3.71, max = 6.32 }
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	calculate = function(self, card, context)
	end,
	use = function(self, card, area, copier)
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('fac_mean_fellow')
				local before = to_number(G.GAME.blind.chips)
				local reduce = math.floor(to_number(G.GAME.blind.chips) * ((100 - card.ability.extra.blind) / 100))
				G.GAME.blind.chips = reduce
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
				if G.GAME.fac_sand_dollars ~= 0 then
					ease_sand_dollars(-math.ceil(G.GAME.fac_sand_dollars/2),true)
				end
				return true
			end
		}))
		delay(0.2)
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.SELECTING_HAND
	end,
}
