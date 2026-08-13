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
	fac_partner = 'fac_Buckaroodle' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
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
	ppu_coder = { 'Buckaroodle'},
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
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.mult_gain,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local scoring_ranks = { 2 , 3 , 4 , 5 }
			local triggered = false
			for i, rank in ipairs(scoring_ranks) do
				if context.other_card:get_id() == scoring_ranks[i] then
					card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
					triggered = true
					break
				end
			end
			if triggered then
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.MULT,
					message_card = card
            	}
			end
		end
		if context.joker_main then
			return {
				mult = card.ability.extra.mult
			}
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
	ppu_coder = { 'Buckaroodle'},
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
	loc_vars = function(self, info_queue, card)
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
			local eligible_fish = {}
			for i, fish in ipairs(G.fac_fish_area.cards) do
				if not fish.edition and fish ~= card then
					eligible_fish[#eligible_fish+1] = fish
				end
			end
			local selected_fish = pseudorandom_element(eligible_fish, 'fac_bigbasswheel')
			local edition = SMODS.poll_edition { key = 'fac_bigbasswheel', guaranteed = true, no_negative = true, options = { 'e_foil', 'e_holo' } }
			selected_fish:set_edition(edition, true)
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
	ppu_coder = { 'Buckaroodle'},
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
	ppu_coder = { 'Buckaroodle'},
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'passive', 'enhancements' },
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
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    end,
}

-- Eyeless Fish
FishAndChips.Fish {
	key = 'eyelessfish',
	atlas = 'DoodlenautsFish',
	pos = { x = 4, y = 0 },
	pixel_size = { w = 55, h = 79 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
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
			if G.jokers then
				local joker_name = localize({ type = 'name_text', set = "Joker", key = context.other_joker.config.center.key })
				--print(joker_name)
				if string.find(joker_name, "[iI]") == nil then
					return {
						xmult = card.ability.extra.xmult
					}
				end
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'suit', 'clubs' },
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
			local _suit = pseudorandom_element(SMODS.Suits, 'fac_moonjelly')
			card.ability.extra.suit = _suit.key
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'economy', },
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
                return true
            end
        }))
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and card.ability.extra.loanshark_current_debt > 0 then
			card.ability.extra.loanshark_current_debt = card.ability.extra.loanshark_current_debt - card.ability.extra.payback_per_round
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

local can_sell_card_ref = Card.can_sell_card
function Card:can_sell_card(context)
	if self.ability.extra and type(self.ability.extra) == 'table' and ((self.ability.extra.loanshark_current_debt ~= nil and self.ability.extra.loanshark_current_debt > 0) or (self.ability.extra.leech ~= nil)) then -- prevents loanshark from being sold when still in debt
		return false
	end
	return can_sell_card_ref(self, context)
end

--Neon Tetra
FishAndChips.Fish {
	key = 'neontetra',
	atlas = 'DoodlenautsFish',
	pos = { x = 0, y = 2 },
	pixel_size = { w = 47, h = 19 },
	weight = 4, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'hand_type' , 'editions' },
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'economy' , 'joker' , 'sell_value' },
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
				SMODS.destroy_cards(card, nil, nil, true)
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'seals' },
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
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS['Gold']
		return {
			vars = {
				card.ability.extra.gold_seals
			}
		}
	end,
	calculate = function(self, card, context)
		if context.before then
			for i, playing_card in ipairs(context.scoring_hand) do
				if playing_card:get_seal() == nil and card.ability.extra.gold_seals > 0 then
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'xmult', 'reroll', 'scaling' },
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
			xmult_total = 1 + (xmult_total or 0)
		}
	},
	environments = {
		garden = 0.95,
		backroom = 0.05,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult_per_dollar,
				card.ability.extra.xmult_total,
			}
		}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop then
			card.ability.extra.xmult_total = card.ability.extra.xmult_total + (card.ability.extra.xmult_per_dollar * context.cost)
			return {
                message = localize('k_upgrade_ex'),
            }
		end
		if context.fac_environment_changed then
			card.ability.extra.xmult_total = card.ability.extra.xmult_total + (card.ability.extra.xmult_per_dollar * G.GAME.fac_environment_reroll_cost)
			return {
                message = localize('k_upgrade_ex'),
            }
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
	ppu_coder = { 'Buckaroodle'},
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
			nun = 1,
			denom = 6,
			inc_per_round = 2
		}
	},
	environments = {
		swamp = 0.6,
		calm_pond = 0.4,
	},
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
		if context.selling_self then
			if SMODS.pseudorandom_probability(card, 'fac_neontetra', card.ability.extra.num, card.ability.extra.denom) then
				local all_fish = G.P_CENTER_POOLS.fac_Fish
				local frogs = {}
				for _, fish in ipairs(all_fish) do
					local text = localize({ type = 'name_text', set = "fac_Fish", key = fish.key })
					if text:lower():find("frog", 1, true) then
						frogs[#frogs+1] = fish
					end
				end
				local random_frog = pseudorandom_element(frogs, 'fac_frogspawn')
				local random_frog_key = random_frog.key
				SMODS.add_card{ key = random_frog_key }
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
	ppu_coder = { 'Buckaroodle'},
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
					if SMODS.pseudorandom_probability(card, 'fac_fihnull', card.ability.extra.num, card.ability.extra.denom) and next(SMODS.get_enhancements(G.hand.cards[i])) == null then
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'usable', 'destroy_card', },
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
		if context.before then
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
	ppu_coder = { 'Buckaroodle'},
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
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		info_queue[#info_queue + 1] = G.P_SEALS['Purple']
		info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
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
	ppu_coder = { 'Buckaroodle'},
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
	ppu_coder = { 'Buckaroodle'},
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
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'rerolls', },
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
			rerolls = 3,
			free_rerolls_used_shop = 0,
			rerolls_this_ante = 0
		}
	},
	environments = {
		city_river = 1,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.rerolls,
				card.ability.extra.free_rerolls_used_shop,
				card.ability.extra.rerolls_this_ante
			}
		}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop and not context.blueprint then
			--card.ability.extra.has_rerolled = true
			card.ability.extra.rerolls_this_ante = card.ability.extra.rerolls_this_ante + 1
			if card.ability.extra.rerolls_this_ante <= 3 then
				card.ability.extra.free_rerolls_used_total = card.ability.extra.free_rerolls_used_total + 1
				card.ability.extra.free_rerolls_used_shop = card.ability.extra.free_rerolls_used_shop + 1
				--card.ability.extra.free_used = true
			end
		end
		if context.ending_shop then
			if --[[card.ability.extra.free_used == true and]] card.ability.extra.free_rerolls_used_shop > 0 then
				SMODS.change_free_rerolls(-card.ability.extra.free_rerolls_used_shop)
				card.ability.extra.free_rerolls_used_shop = 0
			end
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if context.beat_boss then
				SMODS.change_free_rerolls(card.ability.extra.rerolls)
				card.ability.extra.rerolls_this_ante = 0
				card.ability.extra.free_rerolls_used_total = 0
				--print(card.ability.extra.rerolls)
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.rerolls)
		print(card.ability.extra.rerolls)
    end,
    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.rerolls - card.ability.extra.free_rerolls_used_total) -- -free rerolls remaining
		print(card.ability.extra.rerolls)
    end
}

-- Live Ammunition
FishAndChips.Fish {
	key = 'liveammunition',
	atlas = 'DoodlenautsFish',
	pos = { x = 4, y = 3 },
	pixel_size = { w = 47, h = 63 },
	weight = 3, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'usable' },
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
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.percentage,
				card.ability.extra.uses
			}
		}
	end,
	use = function(self, card, area)
		G.GAME.blind.chips = math.floor(G.GAME.blind.chips - G.GAME.blind.chips * (card.ability.extra.percentage / 100))
		G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		card.ability.extra.uses = card.ability.extra.uses - 1
		if card.ability.extra.uses <= 0 then
			SMODS.destroy_cards(card, nil, nil, true)
		end
	end,
	can_use = function(self, card)
		return G.GAME.blind.in_blind
	end
}
