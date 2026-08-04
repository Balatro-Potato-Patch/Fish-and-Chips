PotatoPatchUtils.Developer({
	name = 'Sophie',
	atlas = 'fac_cards',
	colour = HEX('e6fafd'),
	fac_partner = 'gfs' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'gfs',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.YELLOW,
	fac_partner = 'Sophie'
})

SMODS.Atlas({
	key = "sophie_fish",
	path = "sophie/fish.png",
	px = 71,
	py = 95,
})

--#region Fish

FishAndChips.Fish {
	key = "human_fish",
	atlas = "sophie_fish",
	pos = { x = 0, y = 0 },
	weight = 10,
    stats = {
		weight = {min = 5, max = 12},
		length = {min = 0.25, max = 0.50}
	},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "chips", "face", "modify_card", "perma_bonus" },
	config = {
		extra = {
			chips = 1
		}
	},
	environments = {
		wormhole = 10,
		calm_pond = 0.5,
        garden = 0.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            local valid_cards = {}
            for _, card in ipairs(G.hand.cards) do
                if card:is_face() then
                    valid_cards[#valid_cards + 1] = card
                end
            end
            if #valid_cards > 0 then
                local _card = pseudorandom_element(valid_cards, pseudoseed('fac_sophie_human_fish'))
                _card.ability.perma_bonus = (_card.ability.perma_bonus or 0) + card.ability.extra.chips
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    card = _card,
                    focus = card
                }
            end
        end
	end,
}

FishAndChips.Fish {
	key = "fishing_fear_hat",
	atlas = "sophie_fish",
	pos = { x = 1, y = 0 },
	weight = 5,
    stats = {
		weight = {min = 5, max = 12},
		length = {min = 0.25, max = 0.50}
	},
	ppu_coder = { "Sophie" },
	ppu_artist = { "gfs" },
	attributes = { "generation", "spectral" },
	config = {
		extra = {
			odds = 5,
            odds_num = 1,
		}
	},
	environments = {
		pier = 1,
		swamp = 1,
        aquifer = 1,
        styx = 1,
	},
	loc_vars = function(self, info_queue, card)
        numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.odds_num, card.ability.extra.odds, 'fac_fish_sophie_fishing_fear_hat')
		return { vars = { numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and context.failed and SMODS.pseudorandom_probability(card, 'fac_fish_sophie_fishing_fear_hat', card.ability.extra.odds_num, card.ability.extra.odds, 'fac_fish_sophie_fishing_fear_hat') then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local card = SMODS.add_card { set = 'Spectral', key_append = 'fac_fish_sophie_fishing_fear_hat', area = G.play }
                        G.GAME.consumeable_buffer = 0
                        draw_card(G.play, G.consumeables, 1, 'up', true, card, nil, mute)
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                    remove = true
                }
            end
        end
	end,
}

--[[FishAndChips.Fish {
	key = "cod",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = { "Mack" },
	ppu_artist = { "GhostSalt" },
	attributes = { "chips" },
	config = {
		extra = {
			chips = 30
		}
	},
	environments = {
		pier = 10,
		city_river = 2.5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { chips = card.ability.extra.chips } end
	end,
}

FishAndChips.Fish {
	key = "bass",
	atlas = "fish",
	pos = { x = 2, y = 0 },
	weight = 10,
	ppu_coder = { "Mack" },
	ppu_artist = { "squeax09" },
	attributes = { "mult" },
	config = {
		extra = {
			mult = 4
		}
	},
	environments = {
		calm_pond = 10,
		city_river = 5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { mult = card.ability.extra.mult } end
	end,
}

SMODS.Atlas({
	key = "earthfish_lore",
	path = "mack/earthfish_lore.png",
	px = 513,
	py = 51,
})

FishAndChips.Fish {
	key = "earthfish",
	weight = 10,
	atlas = "fish",
	ppu_artist = { "DottyKitty" },
	pos = { x = 4, y = 0 },
	ppu_coder = { "Mack" },
	attributes = { "mult" },
	config = {
		extra = {
			money = 1,
			money_needed = 10
		}
	},
	environments = {
		wormhole = 1,
		pier = 0.1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.money, card.ability.extra.money_needed, elements = { SMODS.create_sprite(0, 0, 3.5, 3.5 * 51 / 513, "fac_earthfish_lore") } } }
	end,
	calculate = function(self, card, context)
		if context.modify_final_cashout then
			local money = math.max(0, math.floor(G.GAME.dollars / card.ability.extra.money_needed)) * card.ability.extra.money
			if money > 0 then
				return { sand_dollars = money }
			end
		end
	end,
}

FishAndChips.Fish {
	key = "steelhead",
	weight = 10,
	atlas = "fish",
	pos = { x = 4, y = 1 },
	ppu_artist = { "GhostSalt" },
	ppu_coder = { "Mack" },
	attributes = { "copying" },
	environments = {
		chocolate_river = 10
	},
	loc_vars = function(self, info_queue, card)
		if card.area and card.area == G.fac_fish_area then
			local other_fish
			for i = 2, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then other_fish = G.fac_fish_area.cards[i - 1] end
			end
			local compatible = other_fish and other_fish ~= card and other_fish.config.center.blueprint_compat
			local main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
							nodes = {
								{ n = G.UIT.T, config = { text = " " .. localize("k_" .. (compatible and "compatible" or "incompatible")) .. " ", colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
							}
						}
					}
				}
			}
			return { main_end = main_end }
		end
	end,
	calculate = function(self, card, context)
		local other_fish = nil
		for i = 2, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] == card then other_fish = G.fac_fish_area.cards[i - 1] end
		end
		return SMODS.blueprint_effect(card, other_fish, context)
	end,
}

FishAndChips.Fish {
	key = "swordine",
	atlas = "fish",
	weight = 10,
	ppu_coder = { "Mack" },
	ppu_artist = { "Gappie" },
	attributes = { "hands", "destroy_card" },
	environments = {
		volcano = 10
	},
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.first_hand_drawn then
			local eval = function() return G.GAME.current_round.hands_played == 0 end
			juice_card_until(card, eval, true)
		end

		if context.after and G.GAME.current_round.hands_played == 0 then
			G.E_MANAGER:add_event(Event({
				func = function()
					card:juice_up(0.8, 0.8)
					play_sound("slice1")
					return true;
				end
			}))
			SMODS.destroy_cards(context.scoring_hand[#context.scoring_hand])
		end
	end,
}

FishAndChips.Fish {
	key = "flailnder",
	atlas = "fish",
	pos = { x = 1, y = 0 },
	weight = 10,
	ppu_coder = { "Mack" },
	ppu_artist = { "Gappie" },
	attributes = { "boss_blind" },
	environments = {
		volcano = 10
	},
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.setting_blind and context.blind.boss and not G.GAME.blind.disabled then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.blind:disable()
					play_sound("timpani")
					delay(0.4)
					return true;
				end
			}))
			return {
				message = localize("ph_boss_disabled"),
				func = function()
					SMODS.destroy_cards(card, { pinch_anim = true })
				end
			}
		end
	end,
}

FishAndChips.Fish {
	key = "piranha",
	weight = 10,
	atlas = "fish",
	pos = { x = 2, y = 2 },
	ppu_artist = { "GhostSalt" },
	ppu_coder = { "Mack" },
	attributes = { "retrigger" },
	environments = {
		aquifer = 1,
		wormhole = 0.5
	},
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.repetition and context.other_card.played_this_ante then
			return {
				repetitions = 1
			}
		end
	end,
}

FishAndChips.Fish {
	key = "dogfish",
	weight = 10,
	atlas = "fish",
	pos = { x = 3, y = 1 },
	ppu_artist = { "GhostSalt" },
	ppu_coder = { "Mack" },
	attributes = { "usable", "generation" },
	environments = {
		swamp = 1,
		city_river = 0.25,
	},
	config = {
		extra = {
			bait = 2
		}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.bait } }
	end,
	use = function(self, card)
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
		delay(1)
		for i = 1, card.ability.extra.bait do
			G.E_MANAGER:add_event(Event {
				func = function()
					local card = SMODS.create_card { set = "fac_Bait" }
					G.fac_temp_bait_area:emplace(card)
					FishAndChips.add_bait_to_inventory(card.config.center.key)
					return true
				end
			})
			delay(0.2)
		end
		delay(3)
		for i = 1, card.ability.extra.bait do
			G.E_MANAGER:add_event(Event {
				func = function()
					G.fac_temp_bait_area.cards[1]:start_dissolve()
					return true
				end
			})
			delay(0.2)
		end
		delay(0.5)
		G.E_MANAGER:add_event(Event {
			func = function()
				G.fac_temp_bait_area:remove()
				card:start_dissolve()
				return true
			end
		})
	end,
	can_use = function(self, card)
		return true
	end
}

FishAndChips.Fish {
	key = "minnow",
	weight = 10,
	atlas = "fish",
	pos = { x = 0, y = 2 },
	ppu_artist = { "GhostSalt" },
	ppu_coder = { "Mack" },
	attributes = { "chance", "rank", "modify_card" },
	environments = {
		garden = 1,
		calm_pond = 0.1,
	},
	config = {
		extra = {
			num = 1,
			dem = 3,
			raise = 1
		}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "fac_minnow")
		return { vars = { num, dem, card.ability.extra.raise } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == "unscored" then
			if SMODS.pseudorandom_probability(card, "fac_minnow", card.ability.extra.num, card.ability.extra.dem) then
				---@type Card
				local _card = context.other_card
				assert(SMODS.modify_rank(_card, card.ability.extra.raise, true))
				return {
					message = localize("k_upgrade_ex"),
					func = function()
						G.E_MANAGER:add_event(Event {
							func = function()
								assert(SMODS.modify_rank(_card, 0))
								return true
							end
						})
					end
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = "poolfish",
	weight = 10,
	atlas = "fish",
	pos = { x = 3, y = 2 },
	ppu_coder = { "Mack" },
	attributes = { "passive", "scaling", "hand_level", "food" },
	environments = {
		backroom = 1
	},
	config = {
		extra = {
			levels = 4,
			dec = 1
		}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.levels, card.ability.extra.dec } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			SMODS.upgrade_poker_hands { level_up = -card.ability.extra.dec, instant = true }
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "levels",
				scalar_value = "dec",
				scalar_factor = -1,
			})
			if card.ability.extra.levels == 0 then
				SMODS.destroy_cards(card)
			end
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		SMODS.upgrade_poker_hands { level_up = card.ability.extra.levels, instant = true }
	end,
	remove_from_deck = function(self, card, from_debuff)
		SMODS.upgrade_poker_hands { level_up = -card.ability.extra.levels, instant = true }
	end
}

FishAndChips.Fish {
	key = "flounder",
	weight = 10,
	atlas = "fish",
	pos = { x = 1, y = 2 },
	ppu_artist = { "GhostSalt" },
	ppu_coder = { "Mack" },
	attributes = { "copying" },
	environments = {
		soup = 1,
		volcano = 0.5
	},
	blueprint_compat = true,
	calculate = function(self, card, context)
		if G.fac_fish_area.cards[#G.fac_fish_area.cards] ~= card then
			return SMODS.blueprint_effect(card, G.fac_fish_area.cards[#G.fac_fish_area.cards], context)
		end
	end,
}

FishAndChips.Fish {
	key = "clothesfish",
	weight = 10,
	atlas = "fish",
	pos = { x = 1, y = 1 },
	ppu_artist = { "GhostSalt" },
	ppu_coder = { "Mack" },
	attributes = { "hand_type", "xmult" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 2,
		},
		immutable = {
			hand = "Two Pair"
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, localize(card.ability.immutable.hand, "poker_hands"), "#" } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and next(context.poker_hands[card.ability.immutable.hand]) then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}

FishAndChips.Fish {
	key = "deathfish",
	weight = 10,
	atlas = "fish",
	pos = { x = 0, y = 1 },
	ppu_artist = { "GhostSalt" },
	ppu_coder = { "Mack" },
	attributes = { "modify_card", "usable" },
	environments = {
		swamp = 1,
		styx = 0.2
	},
	requires_hand = true,
	blueprint_compat = false,
	config = {
		extra = {
			modify = 2
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.modify } }
	end,
	can_use = function(self, card)
		return G.hand and #G.hand.highlighted == card.ability.extra.modify
	end,
	use = function(self, card)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
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
		delay(0.2)
		local rightmost = G.hand.highlighted[1]
		for i = 1, #G.hand.highlighted do
			if G.hand.highlighted[i].T.x > rightmost.T.x then
				rightmost = G.hand.highlighted[i]
			end
		end
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.1,
				func = function()
					if G.hand.highlighted[i] ~= rightmost then
						copy_card(rightmost, G.hand.highlighted[i])
					end
					return true
				end
			}))
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound('tarot2', percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				card:start_dissolve()
				return true
			end
		}))
		delay(0.5)
	end,
}

FishAndChips.Fish {
	key = "bonefish",
	weight = 10,
	atlas = "fish",
	pos = { x = 2, y = 1 },
	ppu_artist = { "squeax09" },
	ppu_coder = { "Mack" },
	attributes = { "prevents_death" },
	environments = {
		aquifer = 0.1,
		styx = 1
	},
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over and context.main_eval then
			if G.GAME.chips / G.GAME.blind.chips >= 0.25 then
				G.E_MANAGER:add_event(Event({
					func = function()
						G.hand_text_area.blind_chips:juice_up()
						G.hand_text_area.game_chips:juice_up()
						play_sound('tarot1')
						card:start_dissolve()
						return true
					end
				}))
				return {
					message = localize('k_saved_ex'),
					saved = 'ph_fac_bonefish',
					colour = G.C.RED
				}
			end
		end
	end,
}

FishAndChips.Fish {
	key = "milkfin",
	atlas = "fish",
	pos = { x = 4, y = 2 },
	weight = 10,
	ppu_coder = { "Mack" },
	ppu_artist = { "GhostSalt" },
	attributes = { "suits", "mult" },
	environments = {
		chocolate_river = 1
	},
	config = {
		extra = {
			mult = 6
		},
		immutable = {
			suit = "Spades"
		}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.immutable.suit, card.ability.extra.mult, colours = { G.ARGS.LOC_COLOURS[string.lower(card.ability.immutable.suit)] } } }
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.immutable.suit = pseudorandom_element(SMODS.Suits, "fac_milkfin").key
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			card.ability.immutable.suit = pseudorandom_element(SMODS.Suits, "fac_milkfin").key
		end
		if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:is_suit(card.ability.immutable.suit) then
			return {
				mult = card.ability.extra.mult
			}
		end
	end,
}]]

--#endregion
