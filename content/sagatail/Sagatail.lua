PotatoPatchUtils.Developer({
	name = 'HuyTheKiller',
    loc = true,
	atlas = 'fac_sagatail_selfinsert',
	colour = G.C.GREEN,
	calculate = function(self, context)
		if context.using_consumeable and not context.retrigger_joker then
			G.GAME.consumeable_usage_this_ante = G.GAME.consumeable_usage_this_ante or {}
			G.GAME.consumeable_usage_this_ante[context.consumeable.ability.set] = G.GAME.consumeable_usage_this_ante[context.consumeable.ability.set] or 0
			G.GAME.consumeable_usage_this_ante[context.consumeable.ability.set] = G.GAME.consumeable_usage_this_ante[context.consumeable.ability.set] + 1
		end
		if context.ante_change and context.ante_end and G.GAME.consumeable_usage_this_ante then
			for k, _ in pairs(G.GAME.consumeable_usage_this_ante) do
				G.GAME.consumeable_usage_this_ante[k] = 0
			end
		end
		if context.fac_end_fishing and context.fish == "fish_fac_sagatail_plastic_chair" then
			local chair = context.fish_obj
			if context.treasure or SMODS.pseudorandom_probability(chair, "plastic_chair_no_bait", 1, chair.ability.extra.odds, "plastic_chair") then
				local bait_key = G.GAME.fac_last_used_bait
				G.E_MANAGER:add_event(Event({
					func = function()
						FishAndChips.add_bait_to_inventory(bait_key)
						G.E_MANAGER:add_event(Event({
							func = function()
								if G.FISHING then FishAndChips.update_bait_counter(G.fac_bait_area.cards[1]) end
								return true
							end
						}))
						SMODS.calculate_effect({ message = localize('k_saved_ex'), colour = G.C.ATTENTION }, G.fac_bait_area.cards[1])
						return true
					end
				}))
			end
		end
		if context.fac_end_fishing then
			G.GAME.force_treasure_fish = nil
		end
	end,
	fac_partner = 'fac_HuyCorn'
})

PotatoPatchUtils.Developer({
	name = 'HuyCorn',
    loc = true,
	atlas = 'fac_sagatail_selfinsert',
	pos = {x = 1, y = 0},
	colour = HEX("3bc9cf"),
	fac_partner = 'fac_HuyTheKiller'
})

SMODS.Atlas({
	key = "sagatail_fish",
	path = "sagatail/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "sagatail_paper_crane",
	path = "sagatail/paper_crane.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "sagatail_selfinsert",
	path = "sagatail/selfinsert.png",
	px = 71,
	py = 95,
})

SMODS.Sound{
	key = "sagatail_hee_hee",
	path = "sagatail/hee_hee.ogg",
}

--#region Fish
FishAndChips.Fish {
	key = "sagatail_catfish",
	atlas = "sagatail_fish",
	pos = { x = 0, y = 0 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "retrigger", "fac_perfect_catch" },
	config = {
		extra = {
			active = false
		}
	},
	environments = {
		garden = 5,
		backroom = 10
	},
	stats = {
		weight = {min = 0.5, max = 1.4},
		length = {min = 0.26, max = 0.47}
	},
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                ppu_bubbles = {card.ability.extra.active and "active" or "inactive"},
            }
        }
	end,
	calculate = function(self, card, context)
		if context.fac_fish_caught then
			card.ability.extra.active = context.perfect
		end
		if context.repetition and context.cardarea == G.play and card.ability.extra.active then
			return {
				repetitions = 1
			}
		end
		if context.end_of_round and context.main_eval then
			card.ability.extra.active = false
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_gold_catfish",
	atlas = "sagatail_fish",
	pos = { x = 1, y = 0 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "mult" },
	config = {
		extra = {
			mult = 2,
            sand_dollars = 5,
		}
	},
	environments = {
		calm_pond = 5,
		backroom = 10
	},
	stats = {
		weight = {min = 0.3, max = 0.8},
		length = {min = 0.26, max = 0.47}
	},
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                card.ability.extra.mult,
                card.ability.extra.sand_dollars,
                card.ability.extra.mult*math.floor((G.GAME.fac_sand_dollars + (G.GAME.fac_sand_dollar_buffer or 0))/card.ability.extra.sand_dollars)
            }
        }
	end,
	calculate = function(self, card, context)
		if context.joker_main and math.floor((G.GAME.fac_sand_dollars + (G.GAME.fac_sand_dollar_buffer or 0))/card.ability.extra.sand_dollars) >= 1 then
            return { mult = card.ability.extra.mult*math.floor((G.GAME.fac_sand_dollars + (G.GAME.fac_sand_dollar_buffer or 0))/card.ability.extra.sand_dollars) }
        end
	end,
}

FishAndChips.Fish {
	key = "sagatail_koi_cat",
	atlas = "sagatail_fish",
	pos = { x = 2, y = 0 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "xmult", "suit" },
	config = {
		extra = {
			xmult = 2,
		}
	},
	environments = {
        swamp = 5,
        aquifer = 10,
        backroom = 10
	},
	stats = {
		weight = {min = 2, max = 8},
		length = {min = 0.6, max = 1}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            local suit_map, suit_count = {}, 0
            for _, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_suit(v) then
					if not SMODS.has_any_suit(v) or v.debuff then
						for _, suit in pairs(SMODS.Suits) do
							if v:is_suit(suit.key, true) then
								suit_map[suit_map[v.base.suit] and suit.key or v.base.suit] = true
							end
						end
					else
						suit_map.wild = true
					end
                end
            end
            for _, _ in pairs(suit_map) do suit_count = suit_count + 1 end
            if suit_count >= 2 then
                return { xmult = card.ability.extra.xmult }
            end
        end
	end,
}

FishAndChips.Fish {
	key = "sagatail_fishcat",
	atlas = "sagatail_fish",
	pos = { x = 3, y = 0 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "economy", "scaling", "sell_value", "hand_type", },
	config = {
		type = "Straight",
		extra = {
			sell_cost_gain = 2,
			consecutive_played = 0,
			max_played = 0,
		}
	},
	environments = {
        garden = 5,
        backroom = 10
	},
	stats = {
		weight = {min = 0.6, max = 1.5},
		length = {min = 0.4, max = 0.9}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sell_cost_gain,
				localize(card.ability.type, "poker_hands"),
				card.ability.extra.consecutive_played,
				card.ability.extra.max_played,
				colours = {
					card.ability.extra.consecutive_played == card.ability.extra.max_played and G.C.GREEN or G.C.UI.TEXT_INACTIVE,
					card.ability.extra.consecutive_played == card.ability.extra.max_played and G.C.GREEN or G.C.FILTER,
				}
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if context.scoring_name == card.ability.type then
				if card.ability.extra.consecutive_played == card.ability.extra.max_played then
					SMODS.scale_card(card, {
						ref_table = card.ability,
						ref_value = "extra_value",
						scalar_table = card.ability.extra,
						scalar_value = "sell_cost_gain",
						scaling_message = {
							message = localize('k_val_up'),
							colour = G.C.MONEY
						}
					})
					card:set_cost()
					if not context.retrigger_joker then
						card.ability.extra.consecutive_played = card.ability.extra.consecutive_played + 1
						card.ability.extra.max_played = card.ability.extra.max_played + 1
					end
				else
					if not context.retrigger_joker then
						card.ability.extra.consecutive_played = card.ability.extra.consecutive_played + 1
					end
				end
				return nil, true
			elseif card.ability.extra.consecutive_played > 0 then
				card.ability.extra.consecutive_played = 0
				return {
					message = localize('k_reset'),
					no_retrigger = true,
				}
			end
        end
	end,
}

FishAndChips.Fish {
	key = "sagatail_lava_catfish",
	atlas = "sagatail_fish",
	pos = { x = 4, y = 0 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "xmult", "destroy_card", "hands", },
	config = {
		extra = {
			xmult = 3,
		}
	},
	environments = {
        volcano = 10,
	},
	stats = {
		weight = {min = 1, max = 2.3},
		length = {min = 0.6, max = 0.97}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint and not context.retrigger_joker then
			local temp_hand = SMODS.shallow_copy(context.full_hand)
			local selected = nil
			if #temp_hand > 0 then
				table.sort(temp_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
				pseudoshuffle(temp_hand, pseudoseed("lava_catfish_select"))
				selected = temp_hand[1]
			end
			for i, v in ipairs(context.full_hand) do
				if selected == v then
					card.ability.extra.index = i
					break
				end
			end
        end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
		if context.destroy_card and context.destroy_card == context.full_hand[card.ability.extra.index or 0] then
			return {
				remove = true
			}
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_seraphish",
	atlas = "sagatail_fish",
	pos = { x = 0, y = 1 },
	weight = 1,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "xmult", "tarot", "reset" },
	config = {
		extra = {
			xmult = 5,
			tarots_used = 0,
			threshold = 10,
		}
	},
	environments = {
        garden = 5,
		wormhole = 10,
	},
	stats = {
		weight = {min = 8, max = 8},
		length = {min = 1.2, max = 1.2}
	},
	treasure = true,
	impulse_min = 0.33,
	impulse_max = 0.7,
	decision_min = 0.28,
	decision_max = 0.62,
	vel_limit = 0.7,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.extra.tarots_used = G.GAME.consumeable_usage_this_ante
		and G.GAME.consumeable_usage_this_ante["Tarot"] or card.ability.extra.tarots_used
	end,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.tarots_used,
				card.ability.extra.threshold,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == "Tarot"
		and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.tarots_used = card.ability.extra.tarots_used + 1
			return {
				message = card.ability.extra.tarots_used.."",
			}
		end
		if context.joker_main and card.ability.extra.tarots_used >= card.ability.extra.threshold then
			return {
				xmult = card.ability.extra.xmult
			}
		end
		if context.ante_change and context.ante_end then
			card.ability.extra.tarots_used = 0
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_plastic_chair",
	atlas = "sagatail_fish",
	pos = { x = 1, y = 1 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "chance", "passive" },
	badge_key = "k_fac_maybe_fish",
	config = {
		extra = {
			odds = 3,
		}
	},
	environments = {
        city_river = 8,
		swamp = 10,
	},
	stats = {
		weight = {min = 0.4, max = 0.4},
		length = {min = 0.8, max = 0.8}
	},
	vel_limit = 0.05,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "plastic_chair")
			}
		}
	end,
	update = function(self, card, dt)
		if not card.fac_custom_scale then
			card.fac_custom_scale = true
			card.T.scale = card.T.scale * 1.3
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and card.fac_custom_scale then
			card.fac_custom_scale = nil
			card.T.scale = card.T.scale / 1.3
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_vintage_cellphone",
	atlas = "sagatail_fish",
	pos = { x = 2, y = 1 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "retrigger", "rank", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten" },
	badge_key = "k_fac_maybe_fish",
	config = {
		extra = {
			rounds_left = 10,
		}
	},
	environments = {
        city_river = 10,
		swamp = 8,
	},
	stats = {
		weight = {min = 0.1, max = 0.1},
		length = {min = 0.1, max = 0.1}
	},
	vel_limit = 0.15,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.rounds_left } }
	end,
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			local id = context.other_card and context.other_card:get_id()
			if FishAndChips.is_numbered_rank(id) then
				return {
					repetitions = 1,
				}
			end
		end
		if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then
			if card.ability.extra.rounds_left - 1 <= 0 then
				SMODS.destroy_cards(card, {pinch_anim = true})
				return {
					message = localize('k_broken_ex'),
				}
			else
				card.ability.extra.rounds_left = card.ability.extra.rounds_left - 1
				return {
					message = card.ability.extra.rounds_left..'',
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_sunfish",
	atlas = "sagatail_fish",
	pos = { x = 3, y = 1 },
	weight = 1,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "xmult", "destroy_card", "usable" },
	config = {
		extra = {
			xmult = 2,
			charge = 3,
			active = false,
		}
	},
	environments = {
        wormhole = 10,
	},
	stats = {
		weight = {min = 365, max = 1200},
		length = {min = 2.6, max = 5}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
				ppu_bubbles = {card.ability.extra.active and "active" or "inactive"},
				colours = {
					card.ability.extra.charge >= 3 and G.C.GREEN or card.ability.extra.charge >= 1 and G.C.YELLOW or G.C.UI.TEXT_INACTIVE,
					card.ability.extra.charge >= 3 and G.C.GREEN or card.ability.extra.charge >= 2 and G.C.YELLOW or G.C.UI.TEXT_INACTIVE,
					card.ability.extra.charge >= 3 and G.C.GREEN or G.C.UI.TEXT_INACTIVE,
				}
			}
		}
	end,
	calculate = function(self, card, context)
		if card.ability.extra.active then
			if context.modify_scoring_hand then
				return {
					add_to_hand = true,
				}
			end
			if context.individual and context.cardarea == G.play then
				return {
					xmult = card.ability.extra.xmult,
				}
			end
			if context.destroy_card and context.cardarea == G.play then
				return {
					remove = true,
				}
			end
		end
		if context.end_of_round and context.main_eval
		and not context.blueprint and not context.retrigger_joker then
			card.ability.extra.active = false
			if card.ability.extra.charge < 3 then
				card.ability.extra.charge = card.ability.extra.charge + 1
				return {
					message = card.ability.extra.charge..'',
					colour = card.ability.extra.charge == 3 and G.C.GREEN or G.C.FILTER
				}
			end
		end
	end,
	can_use = function(self, card)
		return card.ability.extra.charge >= 3
	end,
	use = function(self, card)
		card.ability.extra.charge = card.ability.extra.charge - 3
		card.ability.extra.active = true
	end,
	keep_on_use = function(self, card)
		return true
	end,
}
FishAndChips.Fish {
	key = "sagatail_moonfish",
	atlas = "sagatail_fish",
	pos = { x = 4, y = 1 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "enhancements" },
	config = { extra = {  } },
	environments = {
        wormhole = 10,
	},
	stats = {
		weight = {min = 250, max = 750},
		length = {min = 1.5, max = 2}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if (context.hand_drawn or context.other_drawn) and not context.retrigger_joker then
			local stone = 0
			for _, v in ipairs(context.hand_drawn or {}) do
				if SMODS.has_enhancement(v, "m_stone") then
					stone = stone + 1
				end
			end
			for _, v in ipairs(context.other_drawn or {}) do
				if SMODS.has_enhancement(v, "m_stone") then
					stone = stone + 1
				end
			end
			if stone > 0 then
				SMODS.draw_cards(stone)
				if context.hand_drawn then
					G.E_MANAGER:add_event(Event({
					func = function()
						save_run()
						return true
					end}))
				end
				return nil, true
			end
		end
	end,
}
FishAndChips.Fish {
	key = "sagatail_jelly_catfish",
	atlas = "sagatail_fish",
	pos = { x = 0, y = 2 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "xmult", "economy", "mult", "chips", "suit", "hearts", "diamonds", "clubs", "spades", "hand_type" },
	config = {
		extra = {
			xmult = 1.5,
			sand_dollars = 2,
			mult = 10,
			chips = 80,
		}
	},
	environments = {
        pier = 5,
		backroom = 10,
	},
	stats = {
		weight = {min = 0.3, max = 0.6},
		length = {min = 0.5, max = 1.4}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.sand_dollars,
				card.ability.extra.mult,
				card.ability.extra.chips,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main and context.poker_hands["Flush"] then
			local suit_map, selected_suits = {}, {}
			for _, v in ipairs(context.scoring_hand) do
				if not SMODS.has_no_suit(v) then
					for _, suit in pairs(SMODS.Suits) do
						if v:is_suit(suit.key, true) then
							suit_map[SMODS.has_any_suit(v) and v.debuff and v.base.suit or suit.key] =
							(suit_map[SMODS.has_any_suit(v) and v.debuff and v.base.suit or suit.key] or 0) + 1
						end
					end
				end
			end
			for k, v in pairs(suit_map) do
				selected_suits[k] = v >= SMODS.four_fingers("flush")
			end
			return {
				xmult = selected_suits.Hearts and card.ability.extra.xmult,
				sand_dollars = selected_suits.Diamonds and card.ability.extra.sand_dollars,
				mult = selected_suits.Clubs and card.ability.extra.mult,
				chips = selected_suits.Spades and card.ability.extra.chips,
			}
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_michael_fishson",
	atlas = "sagatail_fish",
	pos = { x = 1, y = 2 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "retrigger", "king", "clubs" },
	config = {
		extra = {
			retriggers = 7,
			sfx_delay = 0,
		}
	},
	environments = {
        garden = 5,
		backroom = 10,
	},
	stats = {
		weight = {min = 1.4, max = 2.7},
		length = {min = 0.7, max = 1.3}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.retriggers } }
	end,
	calculate = function(self, card, context)
		if context.before then
			card.ability.extra.sfx_delay = 0
		end
		if context.individual and context.cardarea == G.play and not context.blueprint and not context.retrigger_joker then
			if #context.full_hand == 1 and context.other_card
			and context.other_card:is_suit("Clubs") and context.other_card:get_id() == 13 then
				return {
					message = card.ability.extra.sfx_delay > 0 and card.ability.extra.sfx_delay % 7 == 0 and localize("k_hee_hee_ex"),
					sound = card.ability.extra.sfx_delay > 0 and card.ability.extra.sfx_delay % 7 == 0 and "fac_sagatail_hee_hee",
					func = function()
						card.ability.extra.sfx_delay = card.ability.extra.sfx_delay + 1
						return true
					end,
				}
			end
		end
		if context.repetition and context.cardarea == G.play then
			if #context.full_hand == 1 and context.other_card
			and context.other_card:is_suit("Clubs") and context.other_card:get_id() == 13 then
				return {
					repetitions = card.ability.extra.retriggers,
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_paper_crane",
	atlas = "sagatail_paper_crane",
	pos = { x = 0, y = 0 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "mult", "xmult" },
	badge_key = "k_fac_maybe_fish",
	config = {
		extra = {
			mult = 1,
			xmult = 2,
			triggers = 0,
		}
	},
	environments = {
        garden = 10,
	},
	stats = {
		weight = {min = 0.05, max = 0.05},
		length = {min = 0.1, max = 0.1}
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.xmult,
				card.ability.extra.triggers,
			}
		}
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.extra.triggers = G.GAME.paper_crane_triggers or card.ability.extra.triggers
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				xmult = card.ability.extra.triggers >= 1000 and card.ability.extra.xmult,
				mult = card.ability.extra.triggers < 1000 and card.ability.extra.mult,
				func = function()
					if not context.blueprint then
						card.ability.extra.triggers = card.ability.extra.triggers + 1
						G.GAME.paper_crane_triggers = (G.GAME.paper_crane_triggers or 0) + 1
					end
					return true
				end
			}
		end
	end,
	update = function(self, card, dt)
		if card.ability.extra.triggers >= 1000 then
			card.children.center:set_sprite_pos{x = 1, y = 0}
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_fisher_fish",
	atlas = "sagatail_fish",
	pos = { x = 2, y = 2 },
	weight = 1,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "generation", "on_sell" },
	config = {
		extra = {
			active = true,
		}
	},
	environments = {
		calm_pond = 5,
        backroom = 10,
	},
	stats = {
		weight = {min = 0.6, max = 1.5},
		length = {min = 0.4, max = 0.9}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				ppu_bubbles = {card.ability.extra.active and "active" or "inactive"},
			}
		}
	end,
	calculate = function(self, card, context)
		if card.ability.extra.active and context.selling_card and context.card.ability.set == "fac_Fish" and context.card ~= card then
			local fish_rw, treasure_fish_rw, bucket =
			context.card.area == (G.FISHING or {}).fac_fish_reward_area,
			context.card.area == (G.FISHING or {}).fac_treasure_reward_area,
			context.card.area == G.fac_fish_area
			if context.card.area and (fish_rw or treasure_fish_rw or bucket) then
				if ((fish_rw or treasure_fish_rw) and #G.fac_fish_area.cards + (G.GAME.fac_fish_buffer or 0) < G.fac_fish_area.config.card_limit)
				or (bucket and #G.fac_fish_area.cards - (1 + context.card.ability.card_limit - context.card.ability.extra_slots_used) + (G.GAME.fac_fish_buffer or 0) < G.fac_fish_area.config.card_limit) then
					card.ability.extra.active = false
					G.GAME.fac_fish_buffer = (G.GAME.fac_fish_buffer or 0) + 1
					local fish_key = SMODS.poll_object{type = "fac_Fish", seed = "fisher_fish"}
					SMODS.add_card{key = fish_key, area = G.fac_fish_area}
					G.E_MANAGER:add_event(Event({
						func = function()
							G.GAME.fac_fish_buffer = 0
							SMODS.calculate_effect({message = localize('ph_thats_mine')}, card)
							return true
						end
					}))
					return nil, true
				end
			end
		end
		if context.ante_change and context.ante_end then
			card.ability.extra.active = true
		end
	end,
}

FishAndChips.Fish {
	key = "sagatail_starryfish",
	atlas = "sagatail_fish",
	pos = { x = 3, y = 2 },
	weight = 5,
	ppu_coder = { "HuyTheKiller" },
	ppu_artist = { "HuyCorn" },
	attributes = { "passive" },
	config = {
		extra = {
			cards_to_draw = 0,
		}
	},
	environments = {
		garden = 10,
        backroom = 10,
	},
	stats = {
		weight = {min = 2, max = 3.3},
		length = {min = 1, max = 1.5}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	calculate = function(self, card, context)
		if context.before then
			card.ability.extra.cards_to_draw = #context.full_hand - #context.scoring_hand
		end
		if context.hand_drawn and not context.retrigger_joker then
			if card.ability.extra.cards_to_draw > 0 then
				SMODS.draw_cards(card.ability.extra.cards_to_draw)
				card.ability.extra.cards_to_draw = 0
				G.E_MANAGER:add_event(Event({
				func = function()
					save_run()
					return true
				end}))
				return nil, true
			end
		end
	end,
}
--#endregion

--#region helper functions
function FishAndChips.is_numbered_rank(id)
	return id == 2 or id == 3 or id == 4 or id == 5
	or id == 6 or id == 7 or id == 8 or id == 9 or id == 10
end
--#endregion
