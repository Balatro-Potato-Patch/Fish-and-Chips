PotatoPatchUtils.Developer({
	name = 'Moby Nick',
	atlas = 'fac_cards',
	colour = HEX("d0d0d0"),
	ignore_limits = true,
	fac_partner = 'JoFIN'
})

PotatoPatchUtils.Developer({
	name = 'JoFIN',
	atlas = 'fac_cards',
	pos = { x = 1, y = 0 },
	colour = HEX("FCB3EA"),
	ignore_limits = true,
	fac_partner = 'Moby Nick'
})

SMODS.Atlas({
	key = "w_d_seuss_fish",
	path = "w_d_seuss/fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "one",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "JoFIN" },
	ppu_artist = { "JoFIN" },
	attributes = { "mult, ace, rank" },
	config = {
		extra = {
			mult = 1
		}
	},
	environments = {
		calm_pond = 5,
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

FishAndChips.Fish {
	key = "two",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 0 },
	weight = 8,
	ppu_coder = { "JoFIN" },
	ppu_artist = { "JoFIN" },
	attributes = { "mult, two, rank" },
	config = {
		extra = {
			mult = 2
		}
	},
	environments = {
		calm_pond = 5,
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

FishAndChips.Fish {
	key = "red",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 0 },
	weight = 7,
	ppu_coder = { "Moby Nick" },
	ppu_artist = { "Moby Nick" },
	attributes = { "chips", "mult", "balance", "score" },
	config = {
		extra = {
		}
	},
	environments = {
		calm_pond = 5,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { 
			vars = {
				next(SMODS.find_card('fish_fac_blue', true)) and "Purple" or "and the Reversal",
				next(SMODS.find_card('fish_fac_blue', true)) and "Balances" or "Converts total scored",
				next(SMODS.find_card('fish_fac_blue', true)) and "and" or "to",
			} 
		}
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step then
			if next(SMODS.find_card('fish_fac_blue', true)) then
			else
				return { chips = -hand_chips + 1, mult = hand_chips }
			end
		end
    end
}

FishAndChips.Fish {
	key = "blue",
	atlas = "w_d_seuss_fish",
	pos = { x = 3, y = 0 },
	weight = 7,
	ppu_coder = { "Moby Nick" },
	ppu_artist = { "Moby Nick" },
	attributes = { "chips", "mult", "balance", "score" },
	config = {
		extra = {
		}
	},
	environments = {
		calm_pond = 5,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { 
			vars = {
				next(SMODS.find_card('fish_fac_red', true)) and "Hollow" or "Take the Amplified",
				next(SMODS.find_card('fish_fac_red', true)) and "Balances" or "Converts total scored",
				next(SMODS.find_card('fish_fac_red', true)) and "and" or "to",
			} 
		}
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step then
			if next(SMODS.find_card('fish_fac_red', true)) then
				return { balance = true }
			else
				return { chips = mult, mult = -mult + 1 }
			end
		end
    end
}

FishAndChips.Fish {
	key = "pear",
	atlas = "w_d_seuss_fish",
	pos = { x = 4, y = 0 },
	weight = 4,
	ppu_coder = { "Moby Nick" },
	ppu_artist = { "Moby Nick" },
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

		if context.fish then
			return {
				level_up = card.ability.extra.levels,
				level_up_hand = "Pair",
				message = localize('k_level_up_ex'),
				colour = HEX("FCB3EA")
			}
		end
		if context.failed then
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

loc_colour('red')
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
	pos = { x = 0, y = 1 },
	weight = 6,
	ppu_coder = { "Moby Nick" },
	ppu_artist = { "Moby Nick" },
	attributes = { "generation" },
	config = {
		extra = {
			f1 = true,
			bait = 1
		}
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

FishAndChips.Fish {
	key = "forgotten",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 1 },
	weight = 1,
	ppu_coder = { "Moby Nick" },
	ppu_artist = { "Moby Nick" },
	attributes = { },
	config = {
		extra = {
		}
	},
	environments = {
		wormhole = 5,
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
	end
}