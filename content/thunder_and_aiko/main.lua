FishAndChips.Fish({
	key = "trojan_fish",
	weight = 10,
	environments = {
		aquifer = 1,
		backroom = 1,
		calm_pond = 1,
		chocolate_river = 1,
		city_river = 1,
		garden = 1,
		pier = 1,
		soup = 1,
		styx = 1,
		swamp = 1,
		volcano = 1,
		wormhole = 1,
	},
	attributes = { "copying", "chance" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	config = { extra = { odds = 6 } },
	loc_vars = function(self, info_queue, card)
		local main_end = nil
		if card.area and card.area == G.fac_fish_area then
			local other_fish
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then
					other_fish = G.fac_fish_area.cards[i + 1]
				end
			end
			local compatible = other_fish and other_fish ~= card and other_fish.config.center.blueprint_compat
			main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
									or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06,
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " "
											.. localize("k_" .. (compatible and "compatible" or "incompatible"))
											.. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
					},
				},
			}
		end
		local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return { main_end = main_end, vars = {
			n,
			d,
		} }
	end,
	calculate = function(self, card, context)
		local other_fish = nil
		for i = 1, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] == card then
				other_fish = G.fac_fish_area.cards[i + 1]
				break
			end
		end
		local ret = SMODS.blueprint_effect(card, other_fish, context)
		if ret then
			ret.colour = G.C.BLUE
		end
		if
			context.end_of_round
			and context.main_eval
			and not context.game_over
			and not context.blueprint
			and SMODS.pseudorandom_probability(card, "fac_trojan_fish", 1, card.ability.extra.odds)
		then
			SMODS.destroy_cards(card, nil, nil, true)
			SMODS.add_card({ set = "Joker" })
			return {
				message = localize("k_fac_boom_ex"),
				colour = G.C.RED,
			}
		end
		return ret
	end,
})

local function calc_moai_mult(card)
	local min_mult = card.ability.extra.min
	local max_mult = card.ability.extra.max

	local current_date = os.date("*t")
	local current_day = current_date.yday
	local current_year = current_date.year
	local target_day_1 = os.date("*t", os.time({ year = current_year, month = 4, day = 5 })).yday
	local target_day_2 = os.date("*t", os.time({ year = current_year + 1, month = 4, day = 5 })).yday
	local diff = math.min(math.abs(current_day - target_day_1), math.abs(current_day - target_day_2))
	local max_diff = 183
	local final_mult = min_mult + (diff / max_diff) * (max_mult - min_mult)
	return math.floor(final_mult * 100) / 100
end

FishAndChips.Fish({
	key = "moai_statue",
	weight = 5,
	environments = {
		pier = 1,
		calm_pond = 1,
	},
	attributes = { "xmult" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	config = { extra = { min = 1.5, max = 3 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.min,
				card.ability.extra.max,
				calc_moai_mult(card),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = calc_moai_mult(card),
			}
		end
	end,
	on_catch = function(self, card)
		delay(0.8 * G.SETTINGS.GAMESPEED)
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound("fac_moai_catch", nil, 0.8)
				return true
			end,
		}))
		delay(5.2 * G.SETTINGS.GAMESPEED)
	end,
})

local play_sound_hook = play_sound
function play_sound(sound_code, per, vol, ...)
	if
		sound_code == "multhit2"
		and G.STATE == G.STATES.HAND_PLAYED
		and next(SMODS.find_card("fish_fac_moai_statue"))
	then
		play_sound_hook("fac_bruh", per + 0.1, vol, ...)
	else
		play_sound_hook(sound_code, per, vol, ...)
	end
end

FishAndChips.Fish({
	key = "nft",
	weight = 5,
	environments = {
		wormhole = 1,
	},
	attributes = { "sell_value", "scaling", "economy", "mult" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	config = { extra = { min_mult = 1, min = -1, max = 2 } },
	loc_vars = function(self, info_queue, card)
		local sv = card.sell_cost
		local r_mults = {}
		for i = card.ability.extra.min, card.ability.extra.max do
			r_mults[#r_mults + 1] = SMODS.signed_dollars(i)
		end
		local loc_sv = localize("k_fac_nft_sell_value1") .. " "
		local main_start = {
			{
				n = G.UIT.O,
				config = {
					object = DynaText({
						string = {
							{ string = "rand()", colour = G.C.JOKER_GREY },
							{
								string = "#@"
									.. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11)
									.. (
										G.deck
											and G.deck.cards[1]
											and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1)
										or "D"
									),
								colour = FishAndChips.C.SAND_DOLLAR,
							},
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
							loc_sv,
						},
						colours = { G.C.UI.TEXT_DARK },
						pop_in_rate = 9999999,
						silent = true,
						random_element = true,
						pop_delay = 0.2011,
						scale = 0.32,
						min_cycle_time = 0,
					}),
				},
			},
			{
				n = G.UIT.O,
				config = {
					object = DynaText({
						string = r_mults,
						colours = { FishAndChips.C.SAND_DOLLAR },
						pop_in_rate = 9999999,
						silent = true,
						random_element = true,
						pop_delay = 0.5,
						scale = 0.32,
						min_cycle_time = 0,
						font = SMODS.Fonts["fac_sand_dollars"],
					}),
				},
			},
			{
				n = G.UIT.T,
				config = {
					text = " " .. localize("k_fac_nft_sell_value2"),
					colour = G.C.UI.TEXT_DARK,
					scale = 0.32,
				},
			},
		}
		return {
			vars = {
				card.ability.extra.min_mult,
				math.max(sv, card.ability.extra.min_mult),
			},
			main_start = main_start,
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult = math.max(card.sell_cost, card.ability.extra.min_mult),
			}
		end
		if context.after and not context.blueprint then
			local prefix = ""
			if card.ability.extra.crashed or pseudorandom("fac_nft_secret", 1, 8) == 1 then
				local val = pseudorandom_element({
					card.ability.extra.crashed
							and pseudorandom("fac_nft_secret", card.ability.extra.min, card.ability.extra.max)
						or -69420,
					21,
					0,
				}, "fac_nft_secret_value")
				if val == -69420 then
					card.ability.extra.crashed = true
				elseif card.ability.extra.crashed then
					card.ability.extra.crashed = nil
				end
				prefix = "=$"
				card.ability.extra_value = -math.max(1, math.floor(self.cost / 2)) + val
			else
				local change = pseudorandom("fac_nft_secret", card.ability.extra.min, card.ability.extra.max)
				if change >= 0 then
					prefix = "+$"
				else
					prefix = "-$"
				end
				-- idk how to use SMODS.scale_card here properly
				card.ability.extra_value = card.ability.extra_value
					+ pseudorandom("fac_nft_secret", card.ability.extra.min, card.ability.extra.max)
			end
			card:set_cost()
			return {
				message = prefix .. card.sell_cost,
				font = SMODS.Fonts["fac_sand_dollars"],
				colour = FishAndChips.C.SAND_DOLLAR,
			}
		end
	end,
})

FishAndChips.Fish({
	key = "soul_fysh",
	weight = 5,
	environments = {
		styx = 1,
		wormhole = 1,
	},
	attributes = { "xmult", "generation", "scaling", "usable" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	config = { extra = { xmult = 1, xmult_gain = 0.25, cards = 2, used = false } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.cards,
				card.ability.extra.xmult_gain,
				card.ability.extra.xmult,
				localize(card.ability.extra.used and "k_fac_was_used" or "k_fac_not_used"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if
			context.end_of_round
			and context.main_eval
			and not context.blueprint
			and not context.game_over
			and card.ability.extra.used
		then
			card.ability.extra.used = false
			local eval = function()
				return not card.ability.extra.used
			end
			juice_card_until(card, eval, true)
		end
	end,
	can_use = function(self, card)
		return not card.ability.extra.used
	end,
	add_to_deck = function(self, card, from_debuff)
		if not card.ability.extra.used then
			local eval = function()
				return not card.ability.extra.used
			end
			juice_card_until(card, eval, true)
		end
	end,
	use = function(self, card)
		card.ability.extra.used = true
		G.E_MANAGER:add_event(Event({
			func = function()
				local _first_dissolve = nil
				local new_cards = {}
				for _ = 1, card.ability.extra.cards do
					local _card = SMODS.add_card({
						set = "Enhanced",
						no_edition = true,
						area = G.deck,
						silent = _first_dissolve,
						key_append = "fac_soul_fysh",
					})
					new_cards[#new_cards + 1] = _card
				end
				SMODS.calculate_context({ playing_card_added = true, cards = new_cards })
				SMODS.scale_card(card, {
					ref_value = "xmult",
					scalar_value = "xmult_gain",
				})
				return true
			end,
		}))
	end,
	keep_on_use = function(self, card)
		return true
	end,
})

FishAndChips.Fish({
	key = "fish_flavored_fish",
	weight = 5,
	environments = {
		soup = 1,
	},
	attributes = { "generation" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	calculate = function(self, card, context)
		if context.fac_end_fishing and context.fish then
			local count = #G.fac_fish_area.cards
			if count + 1 + (G.GAME.fac_fish_buffer or 0) < G.fac_fish_area.config.card_limit then
				G.GAME.fac_fish_buffer = (G.GAME.fac_fish_buffer or 0) + 1
				G.E_MANAGER:add_event(Event({
					func = function()
						G.GAME.fac_fish_buffer = 0
						SMODS.add_card({ set = "fac_Fish" })
						return true
					end,
				}))
			end
		end
	end,
})

FishAndChips.Fish({
	key = "killer",
	weight = 5,
	environments = {
		swamp = 1,
		city_river = 1,
	},
	attributes = { "usable", "enhancements", "destroy_card" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	config = { extra = { charges = 0, facing = "right" } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
		return {
			vars = {
				card.ability.extra.charges,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint and not context.game_over then
			local index = 0
			for i, c in ipairs(G.fac_fish_area.cards) do
				if card == c then
					index = i
					break
				end
			end
			local index_to_check = index
			if card.ability.extra.facing == "right" then
				card.ability.extra.facing = "left"
				index_to_check = index_to_check + 1
			else
				card.ability.extra.facing = "right"
				index_to_check = index_to_check - 1
			end
			if
				G.fac_fish_area.cards[index_to_check]
				and not SMODS.is_eternal(G.fac_fish_area.cards[index_to_check], card)
			then
				card.ability.extra.charges = card.ability.extra.charges + 1
				SMODS.destroy_cards(G.fac_fish_area.cards[index_to_check])
			end
		end
	end,
	can_use = function(self, card)
		return card.ability.extra.charges > 0 and G.hand and #G.hand.highlighted == 1
	end,
	use = function(self, card)
		card.ability.extra.charges = card.ability.extra.charges - 1
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))
		for i = 1, #G.hand.highlighted do
			local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound("card1", percent)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end,
			}))
		end
		delay(0.2)
		for i = 1, #G.hand.highlighted do
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					G.hand.highlighted[i]:set_ability("m_glass")
					return true
				end,
			}))
		end
		for i = 1, #G.hand.highlighted do
			local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					G.hand.highlighted[i]:flip()
					play_sound("tarot2", percent, 0.6)
					G.hand.highlighted[i]:juice_up(0.3, 0.3)
					return true
				end,
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end,
		}))
		delay(0.5)
	end,
	keep_on_use = function(self, card)
		return true
	end,
	requires_hand = true,
})

FishAndChips.Fish({
	key = "growfish",
	weight = 5,
	environments = {
		garden = 1,
	},
	config = { extra = { chips = 1, chips_inc = 1 } },
	attributes = { "scaling", "chips" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_inc,
				card.ability.extra.chips,
			},
		}
	end,
	calculate = function(self, card, context) end,
})
