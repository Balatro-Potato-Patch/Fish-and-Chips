SMODS.Sound({
	key = "ghostfish_1",
	path = "GhostSalt/fac_ghostfish_1.ogg"
})

SMODS.Sound({
	key = "ghostfish_2",
	path = "GhostSalt/fac_ghostfish_2.ogg"
})

SMODS.Sound({
	key = "tapcod_confirm_a",
	path = "GhostSalt/fac_tapcod_confirm_a.ogg"
})

SMODS.Sound({
	key = "tapcod_confirm_b",
	path = "GhostSalt/fac_tapcod_confirm_b.ogg"
})

SMODS.Sound({
	key = "tapcod_do",
	path = "GhostSalt/fac_tapcod_do.ogg"
})

SMODS.Sound({
	key = "tapcod_fail",
	path = "GhostSalt/fac_tapcod_fail.ogg"
})

SMODS.Sound({
	key = "tapcod_no",
	path = "GhostSalt/fac_tapcod_no.ogg"
})

SMODS.Font({
	key = "speakerbox",
	path = "speakerbox.ttf",
	FONTSCALE = 0.07,
	TEXT_HEIGHT_SCALE = 1.1
})

SMODS.Font({
	key = "special_elite",
	path = "special_elite.ttf",
	FONTSCALE = 0.08
})

SMODS.Atlas({
	key = "GhostSaltMyFish",
	path = "GhostSalt/MyFish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "GhostSaltTapCodeTable",
	path = "GhostSalt/TapCodeTable.png",
	px = 61,
	py = 67,
})

FishAndChips.Fish {
	key = "ghostsalt_ghostfish",
	atlas = "GhostSaltMyFish",
	pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "modify_card" },
	environments = {
		styx = 10,
		swamp = 5,
		backroom = 2
	},
	calculate = function(self, card, context)
		if context.ending_shop and G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer) < 1 then
			local candidates = {}
			for _, v in ipairs(G.consumeables.cards) do
				if v and v.config.center.set ~= "Tarot" then
					return
				elseif not v.fac_ghostsalt_ghostfish_claimed then
					candidates[#candidates + 1] = v
				end
			end
			if not next(candidates) then return end

			local selected_tarot = pseudorandom_element(candidates, "fac_ghostsalt_ghostfish")
			selected_tarot.fac_ghostsalt_ghostfish_claimed = true

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.4,
				func = function()
					play_sound("fac_ghostfish_1", 0.9 + (math.random() / 5), 0.4)
					card:juice_up()
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					selected_tarot:flip(); play_sound("card1"); selected_tarot:juice_up(0.3, 0.3); return true
				end
			}))
			delay(0.2)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					selected_tarot:set_ability(SMODS.poll_object { type = "Spectral" } or "c_incantation")
					return true
				end
			}))
			local times = math.random(3) + 1
			for i = 1, times do
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					timer = "REAL",
					delay = 0.6,
					func = function()
						selected_tarot:juice_up()
						play_sound("cancel", 1.2 + (math.random() / 5), 0.5)
						return true
					end
				}))
			end
			local delay_time = math.random(0.5, 1)
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				timer = "REAL",
				delay = delay_time,
				func = function()
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					selected_tarot:flip(); play_sound("fac_ghostfish_2", 0.9 + (math.random() / 5), 0.4); selected_tarot:juice_up(0.3, 0.3)
					card:juice_up()
					selected_tarot.fac_ghostsalt_ghostfish_claimed = false
					return true
				end
			}))
			delay(0.6)
		end
	end,
	pronouns = "she_her"
}

if next(SMODS.find_mod("cardpronouns")) then
	CardPronouns.Pronoun {
		colour = G.C.SECONDARY_SET.Planet,
		text_colour = G.C.WHITE,
		pronoun_table = { "Xe", "Xem" },
		in_pool = function() return false end,
		key = "fac_ghostsalt_xe_xem"
	}
	CardPronouns.classifications["neutral"].pronouns[#CardPronouns.classifications["neutral"].pronouns] = "fac_ghostsalt_xe_xem"
end

FishAndChips.Fish {
	key = "ghostsalt_gleebleglub",
	atlas = "GhostSaltMyFish",
	pos = { x = 1, y = 0 },
	weight = 10,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = {},
	environments = {
		wormhole = 10,
		soup = 5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {} }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable ~= card and context.consumeable.config.center.set == "fac_Fish"
			and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.add_card { set = "Planet", key_append = "fac_ghostsalt_gleebleglub" }
					G.GAME.consumeable_buffer = 0
					return true
				end
			}))
			return {
				message = localize { type = "variable", key = "a_planet", vars = { 1 } },
				colour = G.C.SECONDARY_SET.Planet
			}
		end
	end,
	pronouns = "fac_ghostsalt_xe_xem"
}

FishAndChips.Fish {
	key = "ghostsalt_tapcod",
	atlas = "GhostSaltMyFish",
	pos = { x = 2, y = 0 },
	weight = 4,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "generation" },
	environments = {
		city_river = 10,
		aquifer = 4,
		pier = 3
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		local tile = SMODS.create_sprite(0, 0, 2.5, 2.5 * (67 / 61), "fac_GhostSaltTapCodeTable", { x = 0, y = 0 })
		local n = {
			n = G.UIT.C,
			config = { align = "cm" },
			nodes = { { n = G.UIT.O, config = { object = tile } } }
		}
		info_queue[#info_queue + 1] = { key = "fac_ghostsalt_tap_code", set = "Other", vars = { elements = {} } }
		info_queue[#info_queue + 1] = { key = "fac_ghostsalt_tap_code_table", set = "Other", vars = { elements = { n } } }
		return { vars = { card.ability.fac_ghostsalt_tap_cod_used and localize("k_fac_ghostsalt_tapcod_inactive") or localize("k_fac_ghostsalt_tapcod_active") } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.invididual and not context.repetition and not context.game_over and not context.blueprint then
			local old = card.ability.fac_ghostsalt_tap_cod_used
			card.ability.fac_ghostsalt_tap_cod_used = false
			if old then return { message = localize("k_fac_ghostsalt_tapcod_reactive") } end
		end
	end,
	can_sell = function(self, card, context)
		return not card.ability.fac_ghostsalt_no_of_cod_taps and not card.ability.fac_ghostsalt_tap_cod_inputs
	end,
	pronouns = "he_him"
}

function fac_ghostsalt_translate_tap_cod(tap)
	local a, b = tap[1], tap[2]
	if a > 5 or a < 1 or b > 5 or b < 1 then return "?" end
	local table = {
		{ "A", "B", "C", "D", "E" },
		{ "F", "G", "H", "I", "J" },
		{ "L", "M", "N", "O", "P" },
		{ "Q", "R", "S", "T", "U" },
		{ "V", "W", "X", "Y", "Z" }
	}
	return table[a][b]
end

function fac_ghostsalt_clean_name(code)
	local upper = string.upper(code)
	local alphabet = "ABCDEFGHIJLMNOPQRSTUVWXYZ"
	local output_name = ""
	for c in upper:gmatch "." do
		if c == "K" then
			output_name = output_name .. "C"
		else
			for i = 1, #alphabet do
				if c == alphabet:sub(i, i) then
					output_name = output_name .. c
					i = #alphabet
				end
			end
		end
	end
	return output_name
end

function fac_ghostsalt_stringify_tap_cod(inputs)
	if not inputs then return "..." end
	local output_string = ""
	for _, v in ipairs(inputs) do
		if #v == 2 then
			output_string = output_string .. fac_ghostsalt_translate_tap_cod(v)
		end
	end
	if output_string == "" then return "..." end
	return output_string
end

function fac_ghostsalt_find_consumables_matching(name, soul_allowed)
	local candidates = {}
	for k, v in pairs(G.P_CENTERS) do
		if v.consumeable and (soul_allowed or not v.hidden) and fac_ghostsalt_clean_name(localize { type = "name_text", set = v.set, key = k }) == name then
			candidates[#candidates + 1] = k
		end
	end
	if not next(candidates) then return nil else return candidates end
end

G.FUNCS.fac_ghostsalt_tapcod = function(e)
	local card = e.config.ref_table
	card:juice_up(0.3, 0.3)
	card.ability.fac_ghostsalt_no_of_cod_taps = (card.ability.fac_ghostsalt_no_of_cod_taps or 0) + 1
	local prev = card.ability.fac_ghostsalt_no_of_cod_taps

	if card.children.use_button then
		card.children.use_button:remove()
		card.children.use_button = UIBox {
			definition = G.UIDEF.fac_ghostsalt_input_submit_ref(card),
			config = { align = "cr", offset = { x = -0.4, y = 0 }, parent = card }
		}
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		timer = "REAL",
		delay = 0.8,
		blocking = false,
		blockable = false,
		func = function()
			if card.ability.fac_ghostsalt_no_of_cod_taps == prev then
				card.ability.fac_ghostsalt_tap_cod_inputs = card.ability.fac_ghostsalt_tap_cod_inputs or {}
				if #(card.ability.fac_ghostsalt_tap_cod_inputs[#card.ability.fac_ghostsalt_tap_cod_inputs] or {}) == 1 then
					card.ability.fac_ghostsalt_tap_cod_inputs[#card.ability.fac_ghostsalt_tap_cod_inputs][2] = card.ability.fac_ghostsalt_no_of_cod_taps
					play_sound("fac_tapcod_confirm_b")
					card_eval_status_text(card, "extra", nil, nil, nil,
						{ message = fac_ghostsalt_translate_tap_cod(card.ability.fac_ghostsalt_tap_cod_inputs[#card.ability.fac_ghostsalt_tap_cod_inputs]), colour = G.C.BLUE })
				else
					card.ability.fac_ghostsalt_tap_cod_inputs[#card.ability.fac_ghostsalt_tap_cod_inputs + 1] = { card.ability.fac_ghostsalt_no_of_cod_taps }
					play_sound("fac_tapcod_confirm_a")
					card_eval_status_text(card, "extra", nil, nil, nil, { message = card.ability.fac_ghostsalt_no_of_cod_taps .. "", colour = G.C.FILTER })
				end
				card.ability.fac_ghostsalt_no_of_cod_taps = nil

				if card.children.use_button then
					card.children.use_button:remove()
					card.children.use_button = UIBox {
						definition = G.UIDEF.fac_ghostsalt_input_submit_ref(card),
						config = { align = "cr", offset = { x = -0.4, y = 0 }, parent = card }
					}
				end
			end
			return true
		end
	}))
end

G.FUNCS.fac_can_ghostsalt_tapcod = function(e)
	e.config.colour = G.C.BLUE
	e.config.button = "fac_ghostsalt_tapcod"
end

G.FUNCS.fac_ghostsalt_tapcod_submit = function(e)
	local card = e.config.ref_table
	card:juice_up()
	local candidates = fac_ghostsalt_find_consumables_matching(fac_ghostsalt_stringify_tap_cod(e.config.ref_table.ability.fac_ghostsalt_tap_cod_inputs))
	if candidates and next(candidates) then
		card.ability.fac_ghostsalt_tap_cod_used = true
		card.ability.fac_ghostsalt_no_of_cod_taps = nil
		card.ability.fac_ghostsalt_tap_cod_inputs = nil
		if card.children.use_button then
			card.children.use_button:remove()
			card.children.use_button = UIBox {
				definition = G.UIDEF.fac_ghostsalt_only_sell_ref(card),
				config = { align = "cr", offset = { x = -0.4, y = 0 }, parent = card }
			}
		end
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound("fac_tapcod_do", 1, 0.5)
				card:juice_up()
				local key = pseudorandom_element(candidates, "ghostsalt_tapcod" .. G.GAME.round_resets.ante)
				SMODS.add_card { key = key }
				card_eval_status_text(card, "extra", nil, nil, nil, { message = "+" .. localize { type = "name_text", set = G.P_CENTERS[key].set, key = key }, colour = G.C.GREEN })
				return true
			end
		}))
	else
		stop_use()
		set_consumeable_usage(card)
		local is_silly = fac_ghostsalt_find_consumables_matching(fac_ghostsalt_stringify_tap_cod(e.config.ref_table.ability.fac_ghostsalt_tap_cod_inputs), true)
		if is_silly then
			play_sound("fac_tapcod_no", 1, 0.7)
		else
			play_sound("fac_tapcod_fail", 1, 0.7)
		end
		card_eval_status_text(card, "extra", nil, nil, nil, { message = "???", colour = G.C.RED })
		card.getting_sliced = true
		if card.children.use_button then
			card.children.use_button:remove()
		end
		G.E_MANAGER:add_event(Event({
			timer = "REAL",
			trigger = "after",
			delay = is_silly and 1.3 or 3,
			func = function()
				card:start_dissolve()
				return true
			end
		}))
	end
end

local fac_ghostsalt_can_tapcod_submit_thingy_haha = function(card)
	if (G.play and #G.play.cards > 0) or
		(G.CONTROLLER.locked) or
		(G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
	then
		return false
	end
	local candidates = fac_ghostsalt_find_consumables_matching(fac_ghostsalt_stringify_tap_cod(card.ability.fac_ghostsalt_tap_cod_inputs))
	if #G.consumeables.cards + G.GAME.consumeable_buffer >= G.consumeables.config.card_limit and candidates then return false end
	if (G.SETTINGS.tutorial_complete or G.GAME.pseudorandom.seed ~= "TUTORIAL" or G.GAME.round_resets.ante > 1) and
		card.area and
		card.area.config.type == "joker" then
		return not card.ability.fac_ghostsalt_no_of_cod_taps and card.ability.fac_ghostsalt_tap_cod_inputs and next(card.ability.fac_ghostsalt_tap_cod_inputs)
			and #(card.ability.fac_ghostsalt_tap_cod_inputs[#card.ability.fac_ghostsalt_tap_cod_inputs]) == 2
	end
	return false
end

G.FUNCS.fac_can_ghostsalt_tapcod_submit = function(e)
	if fac_ghostsalt_can_tapcod_submit_thingy_haha(e.config.ref_table) then
		e.config.colour = fac_ghostsalt_find_consumables_matching(fac_ghostsalt_stringify_tap_cod(e.config.ref_table.ability.fac_ghostsalt_tap_cod_inputs)) and G.C.GREEN or G.C.RED
		e.config.button = "fac_ghostsalt_tapcod_submit"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

--[[
self.children.use_button = UIBox {
			definition = G.UIDEF.use_and_sell_buttons(self),
			config = { align = "cr", offset = { x = -0.4, y = 0 }, parent = self }
		}
]]


local fac_card_highlight = Card.highlight
function Card:highlight(is_higlighted)
	self.highlighted = is_higlighted
	if self.config.center.key == "fish_fac_ghostsalt_tapcod" and self.area and self.area == G.fac_fish_area and self.highlighted
		and (self.ability.fac_ghostsalt_no_of_cod_taps or self.ability.fac_ghostsalt_tap_cod_inputs) then
		if not self.getting_sliced then
			if self.ability.fac_ghostsalt_tap_cod_used then
				self.children.use_button = UIBox {
					definition = G.UIDEF.fac_ghostsalt_only_sell_ref(self),
					config = { align = "cr", offset = { x = -0.4, y = 0 }, parent = self }
				}
			else
				self.children.use_button = UIBox {
					definition = G.UIDEF.fac_ghostsalt_input_submit_ref(self),
					config = { align = "cr", offset = { x = -0.4, y = 0 }, parent = self }
				}
			end
		end
	else
		return fac_card_highlight(self, is_higlighted)
	end
end

local use_and_sell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	local ret = use_and_sell(card)
	if card.config.center.key == "fish_fac_ghostsalt_tapcod" and not card.ability.fac_ghostsalt_tap_cod_used then
		local sell = {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = { ref_table = card, align = "cr", padding = 0.1, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = "sell_card", func = "can_sell_card" },
					nodes = {
						{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
						{
							n = G.UIT.C,
							config = { align = "tm" },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm", maxw = 1.25 },
									nodes = {
										{ n = G.UIT.T, config = { text = localize("b_sell"), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true } }
									}
								},
								{
									n = G.UIT.R,
									config = { align = "cm" },
									nodes = {
										{ n = G.UIT.T, config = { text = localize("$"), colour = G.C.WHITE, scale = 0.55, shadow = true, font = SMODS.Fonts["fac_sand_dollars"] } },
										{ n = G.UIT.T, config = { ref_table = card, ref_value = "sell_cost_label", colour = G.C.WHITE, scale = 0.55, shadow = true } }
									}
								}
							}
						}
					}
				},
			}
		}
		local input = {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = { ref_table = card, align = "cm", padding = 0.1, r = 0.08, minw = 1.25, minh = 0.8, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = "fac_ghostsalt_tapcod", func = "fac_can_ghostsalt_tapcod" },
					nodes = {
						{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
						{
							n = G.UIT.C,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm", maxw = 1.25 },
									nodes = {
										{ n = G.UIT.T, config = { text = localize("b_input"), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
									}
								},
							}
						},
					}
				},
			}
		}
		ret = {
			n = G.UIT.ROOT,
			config = { padding = 0, colour = G.C.CLEAR },
			nodes = {
				{
					n = G.UIT.C,
					config = { padding = 0.15, align = "cl" },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cl" },
							nodes = {
								sell
							}
						},
						{
							n = G.UIT.R,
							config = { align = "cl" },
							nodes = {
								input
							}
						},
					}
				},
			}
		}
	end
	return ret
end

function G.UIDEF.fac_ghostsalt_input_submit_ref(card)
	local submit = {
		n = G.UIT.C,
		config = { align = "cr" },
		nodes = {
			{
				n = G.UIT.C,
				config = { ref_table = card, align = "cr", padding = 0.1, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = "fac_ghostsalt_tapcod_submit", func = "fac_can_ghostsalt_tapcod_submit" },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
					{
						n = G.UIT.C,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm" },
								nodes = {
									{ n = G.UIT.T, config = { text = fac_ghostsalt_stringify_tap_cod(card.ability.fac_ghostsalt_tap_cod_inputs), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
								}
							},
						}
					},
				}
			},
		}
	}
	local input = {
		n = G.UIT.C,
		config = { align = "cr" },
		nodes = {
			{
				n = G.UIT.C,
				config = { ref_table = card, align = "cm", padding = 0.1, r = 0.08, minw = 1.25, minh = 0.8, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = "fac_ghostsalt_tapcod", func = "fac_can_ghostsalt_tapcod" },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
					{
						n = G.UIT.C,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", maxw = 1.25 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize("b_input"), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
								}
							},
						}
					},
				}
			},
		}
	}
	return {
		n = G.UIT.ROOT,
		config = { padding = 0, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { padding = 0.15, align = "cl" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cl" },
						nodes = { submit }
					},
					{
						n = G.UIT.R,
						config = { align = "cl" },
						nodes = { input }
					},
				}
			},
		}
	}
end

function G.UIDEF.fac_ghostsalt_only_sell_ref(card)
	local sell = {
		n = G.UIT.C,
		config = { align = "cr" },
		nodes = {
			{
				n = G.UIT.C,
				config = { ref_table = card, align = "cr", padding = 0.1, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = "sell_card", func = "can_sell_card" },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
					{
						n = G.UIT.C,
						config = { align = "tm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", maxw = 1.25 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize("b_sell"), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true } }
								}
							},
							{
								n = G.UIT.R,
								config = { align = "cm" },
								nodes = {
									{ n = G.UIT.T, config = { text = localize("$"), colour = G.C.WHITE, scale = 0.55, shadow = true, font = SMODS.Fonts["fac_sand_dollars"] } },
									{ n = G.UIT.T, config = { ref_table = card, ref_value = "sell_cost_label", colour = G.C.WHITE, scale = 0.55, shadow = true } }
								}
							}
						}
					}
				}
			},
		}
	}
	return {
		n = G.UIT.ROOT,
		config = { padding = 0, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.C,
				config = { padding = 0.15, align = "cl" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cl" },
						nodes = { sell }
					}
				}
			}
		}
	}
end

FishAndChips.Fish {
	key = "ghostsalt_chalkoutline",
	atlas = "GhostSaltMyFish",
	pos = { x = 3, y = 0 },
	weight = 10,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "xmult" },
	environments = {
		styx = 10,
		city_river = 8,
		backroom = 4
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { G.fac_fish_area and math.max(1, (G.fac_fish_area.config.card_limit - #G.fac_fish_area.cards) + #SMODS.find_card("fish_fac_ghostsalt_chalkoutline", true)) or 1 } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return { xmult = math.max(1, (G.fac_fish_area.config.card_limit - #G.fac_fish_area.cards) + #SMODS.find_card("fish_fac_ghostsalt_chalkoutline", true)) }
		end
	end,
	pronouns = "they_them"
}

FishAndChips.Fish {
	key = "ghostsalt_halfmoon",
	atlas = "GhostSaltMyFish",
	pos = { x = 0, y = 1 },
	weight = 10,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "modify_card" },
	environments = {
		calm_pond = 10,
		garden = 10,
		styx = 2
	},
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.before and next(context.scoring_hand) and not context.blueprint then
			local _card = context.scoring_hand[1]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					card:juice_up()
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					_card:flip()
					play_sound("card1", 1)
					_card:juice_up(0.3, 0.3)
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.5,
				func = function()
					_card:change_suit("Clubs")
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				delay = 0.2,
				func = function()
					_card:flip()
					play_sound("tarot2", 1)
					_card:juice_up(0.3, 0.3)
					return true
				end
			}))
			return { message = localize("Clubs", "suits_plural"), colour = G.C.SUITS["Clubs"] }
		end
	end,
	pronouns = "she_they"
}

FishAndChips.Fish {
	key = "ghostsalt_boobass",
	atlas = "GhostSaltMyFish",
	pos = { x = 1, y = 1 },
	config = { extra = { xmult = 2 } },
	weight = 10,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "xmult" },
	environments = {
		styx = 10,
		wormhole = 5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local face
			local number
			for _, v in ipairs(context.scoring_hand) do
				if v and not SMODS.has_no_rank(v) then
					if v:is_face() then
						face = true
					else
						number = true
					end
				end
				if face and number then return { xmult = card.ability.extra.xmult } end
			end
		end
	end,
	pronouns = "they_them"
}

FishAndChips.Fish {
	key = "ghostsalt_whitewhale",
	atlas = "GhostSaltMyFish",
	pos = { x = 2, y = 1 },
	config = { extra = { xmult = 1.5 } },
	weight = 1,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "xmult" },
	environments = {
		pier = 1,
		city_river = 1,
		garden = 1,
		chocolate_river = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.other_joker and context.other_joker:is_rarity("Rare") then
			return { xmult = card.ability.extra.xmult }
		end
	end,
	pronouns = "any_all"
}

FishAndChips.Fish {
	key = "ghostsalt_babyloosha",
	atlas = "GhostSaltMyFish",
	pos = { x = 3, y = 1 },
	config = { extra = { sand_dollars = 1 } },
	weight = 10,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "economy" },
	environments = {
		garden = 10,
		calm_pond = 3,
		pier = 2,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.sand_dollars } }
	end,
	calculate = function(self, card, context)
		if context.reroll_shop then
			return { sand_dollars = card.ability.extra.sand_dollars }
		end
	end,
	pronouns = "she_her"
}
