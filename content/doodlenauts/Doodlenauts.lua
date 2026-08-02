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
	atlas = 'DoodlenautsAvatar',
    pos = {x = 0, y = 0},
	colour = HEX('ff00ff'),
	fac_partner = 'Buckaroodle' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'Buckaroodle',
	atlas = 'DoodlenautsAvatar',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'F404'
})

-- Bottom Feeder
FishAndChips.Fish {
	key = 'bottomfeeder',
	atlas = 'DoodlenautsFish',
	pos = { x = 2, y = 1 },
	weight = 5, --common / uncommon
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'mult', 'rank', 'scaling', 'two', 'three', 'four', 'five' },
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
	weight = 5, --common
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'usable', 'chance', 'editions' },
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
	weight = 5, -- common
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'chips' },
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
	weight = 5, --common/uncommon
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'chips' },
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
	weight = 5, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'passive', 'enhancements' },
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
	weight = 5, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'xmult', 'joker' },
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
	weight = 5, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'suit', 'clubs' },
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
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for i = 1, #G.hand.cards do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('card1', percent)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    assert(SMODS.change_base(_card, card.ability.extra.suit))
                    return true
                end
            }))
        end
        for i = 1, #G.hand.cards do
            local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.cards[i]:flip()
                    play_sound('tarot2', percent, 0.6)
                    G.hand.cards[i]:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)
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
	weight = 5, --common/uncommon
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'economy', },
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
                card:juice_up(0.3, 0.5)
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
	if self.ability.extra and type(self.ability.extra) == 'table' and self.ability.extra.loanshark_current_debt ~= nil then
		if self.ability.extra.loanshark_current_debt > 0 then
			return false
		end
	end
	return can_sell_card_ref(self, context)
end

--Neon Tetra
FishAndChips.Fish {
	key = 'neontetra',
	atlas = 'DoodlenautsFish',
	pos = { x = 0, y = 2 },
	weight = 5, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'hand_type' , 'editions' },
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
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'fac_bigbasswheel')
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
	weight = 5, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'economy' , 'joker' , 'sell_value' },
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
	pos = { x = 0, y = 0 },
	weight = 5, --uncommon/rare
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'seals' },
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