SMODS.Atlas({
	key = "DoodlenautsAvatar",
	path = "Doodlenauts/avatars.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "DoodlenautsFish",
	path = "Doodlenauts/fish.png",
	px = 71,
	py = 95,
})

PotatoPatchUtils.Developer({
	name = 'F404',
	atlas = 'fac_DoodlenautsAvatar',
    pos = {x = 0, y = 0},
	colour = HEX('ff00ff'),
	fac_partner = 'fac_Buckaroodle'
})

PotatoPatchUtils.Developer({
	name = 'Buckaroodle',
	atlas = 'fac_DoodlenautsAvatar',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'fac_F404'
})

-- Bottom Feeder
FishAndChips.Fish {
	key = 'bottomfeeder',
	atlas = 'DoodlenautsFish',
	pos = { x = 2, y = 1 },
	pixel_size = { w = 53, h = 75 },
	weight = 5, --common / uncommon
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'mult', 'rank', 'scaling', 'two', 'three', 'four', 'five' },
	stats = {
		weight = {
			min = 1.5,
			max = 4,
		},
		length = {
			min = 0.5,
			max = 2.5
		}
	},
	cost = 5,
	config = {
		extra = {
			mult = 0,
			mult_gain = 0.5,
		}
	},
	environments = {
		calm_pond = 0.4,
		pier = 0.4,
		swamp = 0.2,
	},
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.mult_gain,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			local scoring_ranks = { 2, 3, 4, 5 }
			for i, rank in ipairs(scoring_ranks) do
				if context.other_card:get_id() == scoring_ranks[i] then
					SMODS.scale_card(card, {
						ref_value = "mult",
						scalar_value = "mult_gain",
					})
					return nil, true
				end
			end
		end
		if context.joker_main then
			return { mult = card.ability.extra.mult }
		end
	end
}

-- Big Bass Wheel
FishAndChips.Fish {
	key = 'bigbasswheel',
	atlas = 'DoodlenautsFish',
	pos = { x = 1, y = 1 },
	pixel_size = { w = 57, h = 57 },
	weight = 5, --common
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'usable', 'chance', 'editions' },
	stats = {
		weight = {
			min = 0.8,
			max = 5,
		},
		length = {
			min = 1,
			max = 2
		}
	},
	cost = 3,
	config = {
		extra = {
			num = 1,
			denom = 3,
		}
	},
	environments = {
		calm_pond = 0.6,
		garden = 0.4
	},
	blueprint_compat = false,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
		info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'fac_bigbasswheel')
		return {
			vars = {
				numerator,
				denominator
			}
		}
	end,
	use = function(self, card, area)
		if SMODS.pseudorandom_probability(card, 'fac_bigbasswheel', card.ability.extra.num, card.ability.extra.denom) then
			G.E_MANAGER:add_event(Event({
                func = function()
					local eligible_fish = {}
					for i, fish in ipairs(G.fac_fish_area.cards) do
						if not fish.edition and fish ~= card then
							eligible_fish[#eligible_fish+1] = fish
						end
					end
					if next(eligible_fish) then
						local selected_fish = pseudorandom_element(eligible_fish, 'fac_bigbasswheelfish')
						local edition = SMODS.poll_edition { key = 'fac_bigbasswheeled', guaranteed = true, no_negative = true, options = { 'e_foil', 'e_holo' } }
						selected_fish:set_edition(edition, true)
					end
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
                        silent = true
                    })
                    play_sound('fac_line_snap', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
		end
	end,
	can_use = function(self, card)
		for i, fish in ipairs(G.fac_fish_area.cards) do
			if not fish.edition and fish ~= card then
				return true
			end
		end
    end
}

-- British Flag
FishAndChips.Fish {
	key = 'britishflag',
	atlas = 'DoodlenautsFish',
	pos = { x = 2, y = 0 },
	pixel_size = { w = 65, },
	weight = 6, -- common
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'chips' },
	stats = {
		weight = {
			min = 0.7,
			max = 0.7,
		},
		length = {
			min = 1,
			max = 1
		}
	},
	cost = 5,
	config = {
		extra = {
			chips_per_fish = 15,
		}
	},
	environments = {
		city_river = 0.5,
		wormhole = 0.25,
		pier = 0.25
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_per_fish,
				card.ability.extra.chips_per_fish * (G.fac_fish_area and #G.fac_fish_area.cards or 0)
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips_per_fish * #G.fac_fish_area.cards
			}
		end
	end
}

-- Bullfrog
FishAndChips.Fish {
	key = 'bullfrog',
	atlas = 'DoodlenautsFish',
	pos = { x = 0, y = 1 },
	pixel_size = { w = 51, h = 33 },
	weight = 6, --common/uncommon
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'chips' },
	stats = {
		weight = {
			min = 0.18,
			max = 0.5,
		},
		length = {
			min = 0.07,
			max = 0.15
		}
	},
	cost = 5,
	config = {
		extra = {
			chips_per_sanddollar = 8,
		}
	},
	environments = {
		swamp = 0.5,
		calm_pond = 0.3,
		garden = 0.2
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_per_sanddollar,
				card.ability.extra.chips_per_sanddollar * (G.GAME.fac_sand_dollars or 0)
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips_per_sanddollar * (G.GAME.fac_sand_dollars or 0)
			}
		end
	end
}

-- Lucky Catfish
FishAndChips.Fish {
	key = 'catfish',
	atlas = 'DoodlenautsFish',
	pos = { x = 1, y = 0 },
	pixel_size = { h = 53 },
	weight = 5, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'passive', 'enhancements', "mod_chance", },
	stats = {
		weight = {
			min = 0.9,
			max = 8.5,
		},
		length = {
			min = 0.3,
			max = 0.8
		}
	},
	cost = 7,
	environments = {
		calm_pond = 0.7,
		pier = 0.3
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    end,
	calculate = function(self, card, context)
		if context.mod_probability and (context.identifier == "lucky_mult" or context.identifier == "lucky_money") then
			return { numerator = 3 }
		end
	end
}

-- Eyeless Fish
FishAndChips.Fish {
	key = 'eyelessfish',
	atlas = 'DoodlenautsFish',
	pos = { x = 4, y = 0 },
	pixel_size = { w = 55, h = 79 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'xmult', 'joker' },
	stats = {
		weight = {
			min = 0.5,
			max = 1.4,
		},
		length = {
			min = 0.1,
			max = 0.9
		}
	},
	cost = 7,
	config = {
		extra = {
			xmult = 1.5,
		}
	},
	environments = {
		backroom = 0.5,
		aquifer = 0.2,
		styx = 0.3,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.other_joker then
			local joker_name = localize({ type = 'name_text', set = "Joker", key = context.other_joker.config.center.key })
			if not string.find(joker_name, "[iI]") then
				return {
					xmult = card.ability.extra.xmult
				}
			end
		end
	end
}

-- Moon Jelly
FishAndChips.Fish {
	key = 'moonjelly',
	atlas = 'DoodlenautsFish',
	pos = { x = 3, y = 0 },
	pixel_size = { w = 49, h = 47 },
	weight = 3, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'suit', "modify_card", "usable", },
	stats = {
		weight = {
			min = 0.2,
			max = 1.3,
		},
		length = {
			min = 0.3,
			max = 1.1
		}
	},
	cost = 4,
	config = {
		extra = {
			suit = 'Spades',
		}
	},
	environments = {
		pier = 1
	},
	blueprint_compat = false,
	requires_hand = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.suit,
				--localize(card.ability.extra.suit, 'suits_singular'),
				colours = {
					G.C.SUITS[card.ability.extra.suit]
				}
			}
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			local selectable_suits = {}
			for k, v in pairs(SMODS.Suits) do
				if k ~= card.ability.extra.suit then selectable_suits[#selectable_suits + 1] = k end
			end
			card.ability.extra.suit = pseudorandom_element(selectable_suits, 'fac_moonjelly')
			return {
                message = localize('k_reset')
            }
		end
	end,
	set_ability = function(self, card, initial, delay_sprites)
		local _suit = pseudorandom_element(SMODS.Suits, 'fac_moonjelly')
		card.ability.extra.suit = _suit.key
	end,
	use = function(self, card, area)
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.hand.cards[i]:flip()
			G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
				play_sound('tarot1', percent, 0.6)
                assert(SMODS.change_base(G.hand.cards[i], card.ability.extra.suit))
                G.hand.cards[i]:flip()
				G.hand.cards[i]:juice_up(0.3, 0.3)
				return true
            end
        	}))
        end
	end,
	can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,
}

-- Loan Shark
FishAndChips.Fish {
	key = 'loanshark',
	atlas = 'DoodlenautsFish',
	pos = { x = 3, y = 1 },
	pixel_size = { w = 47, h = 71 },
	weight = 3, --common/uncommon
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'economy', "lose_economy", "usable", },
	stats = {
		weight = {
			min = 13,
			max = 165,
		},
		length = {
			min = 1.5,
			max = 5.5
		}
	},
	cost = 6,
	config = {
		extra = {
			money_loaned = 20,
			payback_per_round = 4,
			loanshark_current_debt = 0
		}
	},
	environments = {
		pier = 0.7,
		volcano = 0.3,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money_loaned,
				card.ability.extra.payback_per_round,
				card.ability.extra.loanshark_current_debt,
			}
		}
	end,
	use = function(self, card, area)
		card.ability.extra.loanshark_current_debt = card.ability.extra.money_loaned
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.3)
                ease_dollars(card.ability.extra.money_loaned, true)
				card.ability.eternal = true
                return true
            end
        }))
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and card.ability.extra.loanshark_current_debt > 0 and not context.blueprint then
			card.ability.extra.loanshark_current_debt = card.ability.extra.loanshark_current_debt - card.ability.extra.payback_per_round
			if card.ability.extra.loanshark_current_debt <= 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						card.ability.eternal = nil
						return true
					end
				}))
			end
			return {
                dollars = -card.ability.extra.payback_per_round,
            }
		end
	end,
	can_use = function(self, card)
		return card.ability.extra.loanshark_current_debt <= 0
	end,
	keep_on_use = function(self, card)
		return true
	end
}

--Neon Tetra
FishAndChips.Fish {
	key = 'neontetra',
	atlas = 'DoodlenautsFish',
	pos = { x = 0, y = 2 },
	pixel_size = { w = 47, h = 19 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'hand_type' , 'editions' , "chance" , "modify_card" },
	stats = {
		weight = {
			min = 0.1,
			max = 0.4,
		},
		length = {
			min = 0.1,
			max = 0.3
		}
	},
	cost = 8,
	config = {
		extra = {
			num = 1,
			denom = 4,
		}
	},
	environments = {
		garden = 0.5,
		aquifer = 0.5
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'fac_neontetra')
		return {
			vars = {
				numerator,
				denominator
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.scoring_name == 'Four of a Kind' and context.other_card.edition ~= 'e_polychrome' then
				if SMODS.pseudorandom_probability(card, 'fac_neontetra', card.ability.extra.num, card.ability.extra.denom) then
					context.other_card:set_edition('e_polychrome', nil, nil, true)
				end
			end
		end
	end
}

-- Wanted Poster
FishAndChips.Fish {
	key = 'wantedposter',
	atlas = 'DoodlenautsFish',
	pos = { x = 0, y = 0 },
	pixel_size = { w = 53, h = 85 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'economy' , 'joker' , 'sell_value' , "rarity" , "on_sell" },
	stats = {
		weight = {
			min = 0.7,
			max = 0.9,
		},
		length = {
			min = 0.4,
			max = 1
		}
	},
	cost = 7,
	config = {
		extra = {
			bounty = 10,
			common_mult = 1,
			uncommon_mult = 2,
			rare_mult = 3,
			legendary_mult = 4,
		}
	},
	environments = {
		city_river = 0.5,
		pier = 0.5
	},
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.bounty,
				card.ability.extra.common_mult,
				card.ability.extra.uncommon_mult,
				card.ability.extra.rare_mult,
				card.ability.extra.legendary_mult
			}
		}
	end,
	calculate = function(self, card, context)
		if context.selling_card then
			local sell_mult = 0
			if context.card:is_rarity('Common') then
				sell_mult = card.ability.extra.common_mult
			elseif context.card:is_rarity('Uncommon') then
				sell_mult = card.ability.extra.uncommon_mult
			elseif context.card:is_rarity('Rare') then
				sell_mult = card.ability.extra.rare_mult
			elseif context.card:is_rarity('Legendary') then
				sell_mult = card.ability.extra.legendary_mult
			end
			if sell_mult > 0 then
				if not context.blueprint then
					SMODS.destroy_cards(card, nil, nil, true)
				end
				return {
					dollars = card.ability.extra.bounty * sell_mult
				}
			end
		end
	end
}

-- Goldfish Crackers
FishAndChips.Fish {
	key = 'goldfishcrackers',
	atlas = 'DoodlenautsFish',
	pos = { x = 3, y = 2 },
	pixel_size = { w = 33, h = 43 },
	weight = 2, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'seals', "modify_card", "food", },
	stats = {
		weight = {
			min = 0.2,
			max = 0.5,
		},
		length = {
			min = 0.3,
			max = 1
		}
	},
	cost = 6,
	config = {
		extra = {
			gold_seals = 10
		}
	},
	environments = {
		soup = 0.7,
		styx = 0.25,
		garden = 0.05
	},
	blueprint_compat = false,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS['Gold']
		return {
			vars = {
				card.ability.extra.gold_seals
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			for i, playing_card in ipairs(context.scoring_hand) do
				if not playing_card:get_seal() and card.ability.extra.gold_seals > 0 then
					playing_card:set_seal('Gold')
					card.ability.extra.gold_seals = card.ability.extra.gold_seals - 1
					if card.ability.extra.gold_seals <= 0 then
						SMODS.destroy_cards(card, nil, nil, true)
					end
				end
			end
		end
	end
}

-- Buckaroodlefish
FishAndChips.Fish {
	key = 'buckaroodlefish',
	atlas = 'DoodlenautsFish',
	pos = { x = 3, y = 3 },
	pixel_size = { w = 57, h = 81 },
	weight = 2, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'xmult', 'reroll', 'scaling', "shop", },
	stats = {
		weight = {
			min = 1,
			max = 77,
		},
		length = {
			min = 1,
			max = 77
		}
	},
	cost = 7,
	config = {
		extra = {
			xmult_per_dollar = 0.01,
			xmult_total = 1
		}
	},
	environments = {
		garden = 0.95,
		backroom = 0.05,
	},
	perishable_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_per_dollar,
				card.ability.extra.xmult_total,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop and not context.blueprint then
            SMODS.scale_card(card, {
                ref_value = "xmult_total",
                scalar_value = "xmult_per_dollar",
                scalar_factor = context.cost
            })
            return nil, true
		end
		if context.fac_environment_changed and not context.blueprint then
		    SMODS.scale_card(card, {
                ref_value = "xmult_total",
                scalar_value = "xmult_per_dollar",
                scalar_factor = G.GAME.fac_environment_reroll_cost
            })
            return nil, true
		end
		if context.joker_main then
            return {
                xmult = card.ability.extra.xmult_total
            }
        end
	end
}

-- Frogspawn
FishAndChips.Fish {
	key = 'frogspawn',
	atlas = 'DoodlenautsFish',
	pos = { x = 4, y = 1 },
	pixel_size = { w = 35, h = 33 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'food', 'sell_value', 'scaling', 'economy', 'generation' },
	stats = {
		weight = {
			min = 0.2,
			max = 0.4,
		},
		length = {
			min = 0.05,
			max = 0.1
		}
	},
	cost = 4,
	config = {
		extra = {
			num = 1,
			denom = 6,
			inc_per_round = 2
		}
	},
	environments = {
		swamp = 0.6,
		calm_pond = 0.4,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'fac_neontetra')
		return {
			vars = {
				numerator,
				denominator,
				card.ability.extra.inc_per_round,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.inc_per_round
            card:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY
            }
		end
		if context.selling_self and not context.blueprint then
			if SMODS.pseudorandom_probability(card, 'fac_neontetra', card.ability.extra.num, card.ability.extra.denom) then
				local all_fish = G.P_CENTER_POOLS.fac_Fish
				local frogs = {}
				for _, fish in ipairs(all_fish) do
					local text = localize({ type = 'name_text', set = "fac_Fish", key = fish.key })
					if text:lower():find("frog", 1, true) then
						frogs[#frogs+1] = fish
					end
				end
				if next(frogs) then
					local random_frog = pseudorandom_element(frogs, 'fac_frogspawn')
					local random_frog_key = random_frog.key
					SMODS.add_card{ key = random_frog_key }
				end
			end
		end
	end
}

-- FihNULL
FishAndChips.Fish {
	key = 'fihnull',
	atlas = 'DoodlenautsFish',
	pos = { x = 1, y = 2 },
	pixel_size = { w = 59, h = 61 },
	weight = 2, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'usable', 'suit', 'rank', 'economy', 'chance', 'enhancements', 'modify_card' },
	stats = {
		weight = {
			min = 1,
			max = 255,
		},
		length = {
			min = 1,
			max = 255
		}
	},
	cost = 4,
	config = {
		extra = {
			num = 1,
			denom = 2,
		}
	},
	environments = {
		wormhole = 0.50,
		backroom = 0.50,
	},
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'fac_fihnull')
		return {
			vars = {
				numerator,
				denominator
			}
		}
	end,
	use = function(self, card, area)
		for i = 1, #G.hand.cards do
			local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.hand.cards[i]:flip()
			--local prob_hit = false
			--if SMODS.pseudorandom_probability(card, 'fac_fihnull', card.ability.extra.num, card.ability.extra.denom) then
			--	prob_hit = true
			--end
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					play_sound('tarot1', percent, 0.6)
					G.hand.cards[i]:set_base(pseudorandom_element(G.P_CARDS, pseudoseed('fac_fihnull')))
					if SMODS.pseudorandom_probability(card, 'fac_fihnull', card.ability.extra.num, card.ability.extra.denom) and not next(SMODS.get_enhancements(G.hand.cards[i])) then
						local enhancement = SMODS.poll_enhancement{key = "fac_fihnull", guaranteed = true}
						G.hand.cards[i]:set_ability(enhancement)
					end
					G.hand.cards[i]:flip()
					G.hand.cards[i]:juice_up(0.3, 0.3)
				return true
				end
			}))
		end
	end,
	can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end,
}

-- Leech
FishAndChips.Fish {
	key = 'leech',
	atlas = 'DoodlenautsFish',
	pos = { x = 4, y = 2 },
	pixel_size = { w = 63, h = 25 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'usable', 'destroy_card', "lose_economy", },
	stats = {
		weight = {
			min = 0.4,
			max = 1,
		},
		length = {
			min = 0.1,
			max = 0.5
		}
	},
	cost = 0,
	config = {
		extra = {
			how_many_cards_to_destroy = 5,
			money_per_hand = 1,
			leech = true
		}
	},
	environments = {
		calm_pond = 0.6,
		swamp = 0.3,
		city_river = 0.1
	},
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.how_many_cards_to_destroy,
				card.ability.extra.money_per_hand,
				card.ability.extra.leech
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			return {
				dollars = -card.ability.extra.money_per_hand
			}
		end
	end,
	use = function(self, card, area)
		local destroyed_cards = {}
		local temp_hand = {}
		for _, playing_card in ipairs(G.hand.cards) do
			temp_hand[#temp_hand + 1] = playing_card
		end
		table.sort(temp_hand, function(a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end )
		pseudoshuffle(temp_hand, 'fac_leech')
		for i = 1, card.ability.extra.how_many_cards_to_destroy do destroyed_cards[#destroyed_cards + 1] = temp_hand[i] end
		SMODS.destroy_cards(destroyed_cards)
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 1
	end
}

-- Obsidian Starfish
FishAndChips.Fish {
	key = 'obsidianstarfish',
	atlas = 'DoodlenautsFish',
	pos = { x = 2, y = 2 },
	pixel_size = { w = 51, h = 39 },
	weight = 3, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'useable', 'generation', 'enhancements', 'seals' , 'edition', },
	treasure = true,
	stats = {
		weight = {
			min = 2,
			max = 60,
		},
		length = {
			min = 0.1,
			max = 1
		}
	},
	cost = 4,
	config = {
		extra = {
			how_many_stone_cards = 2,
		}
	},
	environments = {
		volcano = 1,
	},
	blueprint_compat = false,
	eternal_compat = false,
	requires_hand = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		info_queue[#info_queue + 1] = G.P_SEALS.Purple
		return {
			vars = {
				card.ability.extra.how_many_stone_cards,
			}
		}
	end,
	use = function(self, card, area)
		for i = 1, card.ability.extra.how_many_stone_cards do
			SMODS.add_card{
				set = 'Base',
				area = G.hand,
				enhancement = "m_stone",
				seal = 'Purple',
				edition = 'e_polychrome'
			}
		end
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.cards > 1
	end
}

-- Hermit Crab
FishAndChips.Fish {
	key = 'hermitcrab',
	atlas = 'DoodlenautsFish',
	pos = { x = 1, y = 3 },
	pixel_size = { w = 47, h = 63 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'usable', 'economy' },
	stats = {
		weight = {
			min = 0.1,
			max = 1.1,
		},
		length = {
			min = 0.01,
			max = 0.1
		}
	},
	cost = 3,
	config = {
		extra = {
			money_max = 15,
			sanddollar_max = 8,
		}
	},
	environments = {
		pier = 1,
	},
	blueprint_compat = false,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money_max,
				card.ability.extra.sanddollar_max
			}
		}
	end,
	use = function(self, card, area)
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                play_sound('timpani')
                card:juice_up(0.3, 0.5)
                ease_dollars(math.max(0, math.min(G.GAME.dollars, card.ability.extra.money_max)), true)
				ease_sand_dollars(math.max(0, math.min(G.GAME.fac_sand_dollars, card.ability.extra.sanddollar_max)), true)
                return true
            end
        }))
	end,
	can_use = function(self, card)
		return true
	end
}

-- Spicy Tuna
FishAndChips.Fish {
	key = 'spicytuna',
	atlas = 'DoodlenautsFish',
	pos = { x = 0, y = 3 },
	pixel_size = { w = 63, h = 87 },
	weight = 2, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'economy' },
	stats = {
		weight = {
			min = 0.9,
			max = 6.6,
		},
		length = {
			min = 1,
			max = 5
		}
	},
	cost = 0,
	config = {
		extra = {
			money = 7,
		}
	},
	environments = {
		soup = 0.35,
		volcano = 0.65,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money
			}
		}
	end,
	calculate = function(self, card, context)
		if context.after then
			if SMODS.last_hand_oneshot then
				return {
					dollars = card.ability.extra.money
				}
			end
		end
	end,
}

-- Old Tire
FishAndChips.Fish {
	key = 'oldtire',
	atlas = 'DoodlenautsFish',
	pos = { x = 2, y = 3 },
	pixel_size = { w = 35, h = 51 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'reroll', "reset", },
	stats = {
		weight = {
			min = 0.9,
			max = 2,
		},
		length = {
			min = 0.4,
			max = 0.4
		}
	},
	cost = 0,
	config = {
		extra = {
			freerolls = 3,
			cached_freerolls = 0,
			used_freerolls = 0
		}
	},
	environments = {
		city_river = 1,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.freerolls,
				card.ability.extra.freerolls - card.ability.extra.used_freerolls
			}
		}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop and not context.blueprint and card.ability.extra.used_freerolls < card.ability.extra.freerolls then
			for _, v in ipairs(G.fac_fish_area.cards) do	-- this is to allow multiple tires to work together (ghostsalt)
				if v.config.center.key == "fish_fac_oldtire" and v.ability.extra.i_rerolled then
					return
				end
			end
			card.ability.extra.i_rerolled = true

			card.ability.extra.used_freerolls = card.ability.extra.used_freerolls + 1
			card.ability.extra.cached_freerolls = card.ability.extra.cached_freerolls + 1
			
			G.E_MANAGER:add_event(Event({
                func = function()
					card.ability.extra.i_rerolled = nil
					return true
				end
			}))
		end

		if context.ending_shop and not context.blueprint then
			SMODS.change_free_rerolls(-card.ability.extra.cached_freerolls)
			card.ability.extra.cached_freerolls = 0
		end

		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if context.beat_boss then
				if card.ability.extra.used_freerolls > 0 then
					SMODS.change_free_rerolls(card.ability.extra.used_freerolls)
				end
				card.ability.extra.used_freerolls = 0
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.freerolls)
    end,
    remove_from_deck = function(self, card, from_debuff)
		if card.ability.extra.used_freerolls < card.ability.extra.freerolls or card.ability.extra.cached_freerolls > 0 then
        	SMODS.change_free_rerolls(-(card.ability.extra.freerolls - card.ability.extra.used_freerolls + card.ability.extra.cached_freerolls))
		end
    end
}

-- Live Ammunition
FishAndChips.Fish {
	key = 'liveammunition',
	atlas = 'DoodlenautsFish',
	pos = { x = 4, y = 3 },
	pixel_size = { w = 47, h = 63 },
	weight = 3, --uncommon/rare
	ppu_coder = { 'Buckaroodle' },
	ppu_artist = { 'F404' },
	attributes = { 'usable', "xblindsize", },
	stats = {
		weight = {
			min = 0.1,
			max = 0.3,
		},
		length = {
			min = 0.01,
			max = 0.11
		}
	},
	cost = 3,
	config = {
		extra = {
			percentage = 20,
			uses = 3
		}
	},
	environments = {
		city_river = 0.5,
		pier = 0.5,
	},
	blueprint_compat = false,
	eternal_compat = false,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.percentage,
				card.ability.extra.uses
			}
		}
	end,
	keep_on_use = function(self, card)
		return card.ability.extra.uses > 1
	end,
	use = function(self, card, area)
		G.GAME.blind.chips = math.floor(G.GAME.blind.chips - G.GAME.blind.chips * (card.ability.extra.percentage / 100))
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		card.ability.extra.uses = card.ability.extra.uses - 1
	end,
	can_use = function(self, card)
		return G.GAME.blind.in_blind
	end
}
