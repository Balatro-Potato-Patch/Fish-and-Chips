PotatoPatchUtils.Developer({
	name = 'Nick',
	loc = true,
	colour = HEX("d0d0d0"),
	fac_partner = 'fac_Jolyne'
})

PotatoPatchUtils.Developer({
	name = 'Jolyne',
	loc = true,
	colour = HEX("FCB3EA"),
	fac_partner = 'fac_Nick'
})

SMODS.Atlas({
	key = "w_d_seuss_fish",
	path = "w_d_seuss/fish.png",
	px = 71,
	py = 95,
})

-- One Fish

FishAndChips.Fish {
	key = "one",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "Jolyne" },
	ppu_artist = { "Jolyne" },
	attributes = { "mult, ace, rank" },
	config = {
		extra = {
			mult = 1
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = {min = 0.50, max = 1.41},
		length = {min = 0.15, max = 0.30}
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
	attributes = { "mult, two, rank" },
	config = {
		extra = {
			mult = 2
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = {min = 1.00, max = 2.82},
		length = {min = 0.30, max = 0.60}
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
	attributes = { "chips", "mult", "balance", "score" },
	config = {
		extra = {
			value = 10
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = {min = 1.36, max = 6.81},
		length = {min = 0.46, max = 1.02}
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
			return { chips = -hand_chips + value, mult = hand_chips * (card.ability.extra.value/100) }
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
	attributes = { "chips", "mult", "balance", "score" },
	config = {
		extra = {
			value = 50
		}
	},
	environments = {
		calm_pond = 5,
	},
	stats = {
		weight = {min = 1.36, max = 6.80},
		length = {min = 0.30, max = 0.61}
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
			return { chips = mult * (card.ability.extra.value/100), mult = -mult + value }
		end
    end
}

-- Old Fish

SMODS.Attribute {
    key = 'deltarune'
}

SMODS.Sound{
    key = "gerson_laugh",
    path = "w_d_seuss/gerson_laugh.ogg",
}

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
		weight = {min = 0.90, max = 1.80},
		length = {min = 1.70, max = 1.80}
	},
	blueprint_compat = false,
	treasure = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
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
                	SMODS.add_card({key = deltarune_fish, area = G.fac_fish_area})
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

G.ARGS.LOC_COLOURS['inscryption_blue'] = HEX("01eaff")
G.ARGS.LOC_COLOURS['jolyne'] = HEX("FCB3EA")

FishAndChips.Fish {
	key = "bad",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 1 },
	weight = 1,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "xblindsize" },
	config = {
		extra = {
			blind = 1.5
		}
	},
	environments = {
		wormhole = 5,
	},
	stats = {
		weight = {min = 0.50, max = 5.00},
		length = {min = 1.00, max = 2.00}
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

local nosell_hook = Card.can_sell_card -- Thank you Hyperfixation Priceless
function Card:can_sell_card(context)
    nosell_hook(self, context)
	if self.config.center.key == 'fish_fac_bad' then
		return false
    else
		return true
	end
end

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
	mf_rotate_by = 3 * math.pi / 2,
	environments = {
		garden = 5,
	},
	stats = {
		weight = {min = 79.00, max = 85.00},
		length = {min = 1.82, max = 1.94}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.rounds_total, card.ability.extra.rounds, card.ability.extra.rounds == 0 and "Active" or "Not Active"} }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if card.ability.extra.rounds <= 0 then
				card.ability.extra.rounds = card.ability.extra.rounds_total
				return {
					message = localize('k_lost'),
				}
			else
				card.ability.extra.rounds = card.ability.extra.rounds - 1
				local eval = function(card) return card.ability.extra.rounds == 0 and not card.REMOVED end
                juice_card_until(card, eval, true)
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

local card_draw = Card.draw -- Thank you MoreFluff Rotarot
function Card:draw(layer, ...)
	if self.config and self.config.center and self.config.center.key == 'fish_fac_darwin' then
		self.VT.r = self.VT.r + ( 3 * math.pi / 2 )
		for k, v in pairs(self.children) do
			v.VT.r = v.VT.r + ( 3 * math.pi / 2 )
		end
	end

	card_draw(self, layer, ...)

	if self.config and self.config.center and self.config.center.key == 'fish_fac_darwin' then
		self.VT.r = self.VT.r - ( 3 * math.pi / 2 )
		for k, v in pairs(self.children) do
			v.VT.r = v.VT.r - ( 3 * math.pi / 2 )
		end
	end
end

-- Pear Fish

FishAndChips.Fish {
	key = "pear",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 1 },
	weight = 4,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { "hand_type, food" },
	config = {
		extra = {
			pear = 5,
			pear_total = 5,
			levels = 1
		}
	},
	environments = {
		pier = 4,
		soup = 1,
	},
	stats = {
		weight = {min = 0.16, max = 0.18},
		length = {min = 0.05, max = 0.10}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.pear_total, card.ability.extra.pear, card.ability.extra.levels } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and not context.blueprint then
			if card.ability.extra.pear - 1 <= 0 then
				SMODS.destroy_cards(card, nil, nil, true)
				return {
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
	attributes = { "mult", "chips", "destroy_card", "sell_value", "scaling", "usable" },
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
		weight = {min = 136.08, max = 181.44},
		length = {min = 2.08, max = 2.18}
	},
	requires_hand = true,
	blueprint_compat = false,
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
						card.ability.extra.mult = card.ability.extra.mult + fish_sliced.sell_cost * 2
                        card:juice_up(0.8, 0.8)
						play_sound('slice1', 0.96 + math.random() * 0.08)
                        fish_sliced:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))
            end
			card.ability.extra.attack = "Cleave"
			SMODS.calculate_effect({message = localize('k_dismantle'), colour = G.C.MULT}, card)
		elseif card.ability.extra.attack == "Cleave" then
			G.E_MANAGER:add_event(Event({
				func = function()
					card.ability.extra.chips = card.ability.extra.chips + G.hand.highlighted[1].base.id * 3
					card:juice_up(0.8, 0.8)
					play_sound('slice1', 0.96 + math.random() * 0.08)
					SMODS.destroy_cards(G.hand.highlighted)
					return true
				end
			}))
			card.ability.extra.attack = "Dismantle"
			SMODS.calculate_effect({message = localize('k_cleave'), colour = G.C.CHIPS}, card)
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
		return card.ability.extra.attack == "Dismantle" and fish_sliced or card.ability.extra.attack == "Cleave" and G.hand and #G.hand.highlighted == 1
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
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = {min = 79.00, max = 84.00},
		length = {min = 1.80, max = 2.10}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
	end
}

-- Lord X-ray (Lord X)

SMODS.Atlas({
	key = "i_miss_the_quiet",
	path = "w_d_seuss/i_miss_the_quiet.png",
	px = 128,
	py = 72,
})

FishAndChips.Fish {
	key = "lordx",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 2 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = {min = 33.53, max = 34.93},
		length = {min = 0.98, max = 1.01}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_i_miss_the_quiet") } } }
	end,
	calculate = function(self, card, context)
	end
}

-- Marlin (Majin)

SMODS.Atlas({
	key = "sinister",
	path = "w_d_seuss/sinister.png",
	px = 128,
	py = 72,
})

FishAndChips.Fish {
	key = "majin",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 2 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = {min = 33.53, max = 34.93},
		length = {min = 0.98, max = 1.01}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_sinister") } } }
	end,
	calculate = function(self, card, context)
	end
}

-- Red-Herring (Redglove)

SMODS.Atlas({
	key = "red_handed",
	path = "w_d_seuss/red_handed.png",
	px = 128,
	py = 72,
})

FishAndChips.Fish {
	key = "redglove",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 2 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = {min = 33.53, max = 34.93},
		length = {min = 2.24, max = 2.51}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_red_handed") } } }
	end,
	calculate = function(self, card, context)
	end
}

-- Flounder (Faker)

SMODS.Atlas({
	key = "st_solis",
	path = "w_d_seuss/st_solis.png",
	px = 128,
	py = 72,
})

FishAndChips.Fish {
	key = "faker",
	atlas = "w_d_seuss_fish",
	pos = { x = 3, y = 2 },
	weight = 2,
	ppu_coder = { "Nick" },
	ppu_artist = { "Nick" },
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
		styx = 5,
	},
	stats = {
		weight = {min = 33.53, max = 34.93},
		length = {min = 0.98, max = 1.01}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { elements = { SMODS.create_sprite(0, 0, 3.5, 128 / 71, "fac_st_solis") } } }
	end,
	calculate = function(self, card, context)
	end
}


-- Spalmon

G.ARGS.LOC_COLOURS['spalmon_pink'] = HEX("ffaec9")
G.ARGS.LOC_COLOURS['spalmon_gold'] = HEX("fff200")

SMODS.Sound{
    key = "spamtonf1",
    path = "w_d_seuss/spamtonf1.ogg",
}

local keypress = love.keypressed
function love.keypressed(key)
    if key == "f1" then
        if G and G.jokers and G.jokers.cards and not G.SETTINGS.paused then
            SMODS.calculate_context({ key_press_f1 = true })
        end
    end
    return (keypress(key))
end

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
		weight = {min = 13.61, max = 22.68},
		length = {min = 1.57, max = 1.63}
	},
	environments = {
		wormhole = 5,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
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
	},
	stats = {
		weight = {min = 0.89, max = 1.12},
		length = {min = 0.46, max = 0.81}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.price } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing then
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.price
            card:set_cost()
            return {
                message = localize('k_val_up'),
                colour = FishAndChips.C.SAND_DOLLAR
            }
		end
	end
}