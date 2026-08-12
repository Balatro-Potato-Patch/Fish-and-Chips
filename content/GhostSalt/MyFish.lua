local fac_ghostsalt_common_weight = 5

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

SMODS.Sound({
	key = "finvestor",
	path = "GhostSalt/fac_finvestor.ogg"
})

SMODS.Sound({
	key = "fishwav_fish",
	path = "GhostSalt/fac_fishwav_fish.ogg"
})

SMODS.Sound({
	key = "eelongtea",
	path = "GhostSalt/fac_eelongtea.ogg"
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

SMODS.Shader {
	key = "fac_mez",
	path = "GhostSalt/fac_mez.fs"
}

FishAndChips.Fish {
	key = "ghostsalt_ghostfish",
	atlas = "GhostSaltMyFish",
	pos = { x = 0, y = 0 },
	draw = function(self, card, layer)
		if self.discovered or card.params.bypass_discovery_center then
			card.children.center:draw_shader("booster", nil, card.ARGS.send_to_shader)
		end
	end,
	vel_limit = 0.6,
	impulse_min = 0.2,
	impulse_max = 0.4,
	decision_min = 0.3,
	decision_max = 0.6,
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0, max = 0 }, length = { min = 0.50, max = 1.00 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "modify_card" },
	environments = {
		styx = 10,
		swamp = 5,
		backroom = 2
	},
	blueprint_compat = true,
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
				delay = 0.40,
				func = function()
					play_sound("fac_ghostfish_1", 0.90 + (math.random() / 5), 0.4);
					card:juice_up()
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					selected_tarot:flip(); play_sound("card1"); selected_tarot:juice_up(0.30, 0.3); return true
				end
			}))
			delay(0.2)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.10,
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
					delay = 0.60,
					func = function()
						selected_tarot:juice_up()
						play_sound("cancel", 1.20 + (math.random() / 5), 0.5)
						return true
					end
				}))
			end
			local delay_time = math.random(0.50, 1)
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				timer = "REAL",
				delay = delay_time,
				func = function()
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				timer = "REAL",
				delay = 0.4,
				func = function()
					selected_tarot:flip(); play_sound("fac_ghostfish_2", 0.90 + (math.random() / 5), 0.4); selected_tarot:juice_up(0.30, 0.3);
					card:juice_up()
					selected_tarot.fac_ghostsalt_ghostfish_claimed = false
					return true
				end
			}))
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
	config = { extra = { max_triggers = 10, current_triggers = 0 } },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0.40, max = 0.60 }, length = { min = 0.20, max = 0.50 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "generation" },
	environments = {
		wormhole = 10,
		soup = 5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.max_triggers } }
	end,
	vel_limit = 0.3,
	impulse_min = 10,
	impulse_max = 12,
	decision_min = 0.6,
	decision_max = 0.8,
	requires_consumables = true,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if ((context.fac_use_fish and context.fac_use_fish ~= card) or
				context.selling_card and context.card.ability.set == "fac_Fish" and context.card ~= card)
			and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
			and card.ability.extra.current_triggers < card.ability.extra.max_triggers then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			if not context.blueprint then
				card.ability.extra.current_triggers = card.ability.extra.current_triggers + 1
			end
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

		if context.end_of_round and not context.individual and not context.repetition and not context.game_over and not context.blueprint then
			card.ability.extra.current_triggers = 0
		end
	end,
	pronouns = "fac_ghostsalt_xe_xem"
}

FishAndChips.Fish {
	key = "ghostsalt_tapcod",
	atlas = "GhostSaltMyFish",
	pos = { x = 2, y = 0 },
	weight = 4,
	stats = { weight = { min = 1.30, max = 4.00 }, length = { min = 0.20, max = 0.45 } },
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
		local tile = SMODS.create_sprite(0, 0, 2.50, 2.50 * (67 / 61), "fac_GhostSaltTapCodeTable", { x = 0, y = 0 })
		local n = {
			n = G.UIT.C,
			config = { align = "cm" },
			nodes = { { n = G.UIT.O, config = { object = tile } } },
		}
		info_queue[#info_queue + 1] = { key = "fac_ghostsalt_tap_code", set = "Other", vars = { elements = {} } }
		info_queue[#info_queue + 1] = { key = "fac_ghostsalt_tap_code_table", set = "Other", vars = { elements = { n } } }
		return { vars = { ppu_bubbles = { card.ability.fac_ghostsalt_tap_cod_used and "inactive" or "active" } } }
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
	card:juice_up(0.30, 0.3)
	card.ability.fac_ghostsalt_no_of_cod_taps = (card.ability.fac_ghostsalt_no_of_cod_taps or 0) + 1
	local prev = card.ability.fac_ghostsalt_no_of_cod_taps

	if card.children.use_button then
		card.children.use_button:remove()
		card.children.use_button = UIBox {
			definition = G.UIDEF.fac_ghostsalt_input_submit_ref(card),
			config = { align = "cr", offset = { x = -0.40, y = 0 }, parent = card }
		}
	end
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		timer = "REAL",
		delay = 0.80,
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
						config = { align = "cr", offset = { x = -0.40, y = 0 }, parent = card }
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
				config = { align = "cr", offset = { x = -0.40, y = 0 }, parent = card }
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
			delay = is_silly and 1.30 or 3,
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
			config = { align = "cr", offset = { x = -0.40, y = 0 }, parent = self }
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
					config = { align = "cr", offset = { x = -0.40, y = 0 }, parent = self }
				}
			else
				self.children.use_button = UIBox {
					definition = G.UIDEF.fac_ghostsalt_input_submit_ref(self),
					config = { align = "cr", offset = { x = -0.40, y = 0 }, parent = self }
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
					config = { ref_table = card, align = "cr", padding = 0.10, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = "sell_card", func = "can_sell_card" },
					nodes = {
						{ n = G.UIT.B, config = { w = 0.10, h = 0.60 } },
						{
							n = G.UIT.C,
							config = { align = "tm" },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm", maxw = 1.25 },
									nodes = {
										{ n = G.UIT.T, config = { text = localize("b_sell"), colour = G.C.UI.TEXT_LIGHT, scale = 0.40, shadow = true } }
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
					config = { ref_table = card, align = "cm", padding = 0.10, r = 0.08, minw = 1.25, minh = 0.80, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = "fac_ghostsalt_tapcod", func = "fac_can_ghostsalt_tapcod" },
					nodes = {
						{ n = G.UIT.B, config = { w = 0.10, h = 0.60 } },
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
				config = { ref_table = card, align = "cr", padding = 0.10, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = "fac_ghostsalt_tapcod_submit", func = "fac_can_ghostsalt_tapcod_submit" },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.10, h = 0.60 } },
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
				config = { ref_table = card, align = "cm", padding = 0.10, r = 0.08, minw = 1.25, minh = 0.80, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, fac_ignore = true, button = "fac_ghostsalt_tapcod", func = "fac_can_ghostsalt_tapcod" },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.10, h = 0.60 } },
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
				config = { ref_table = card, align = "cr", padding = 0.10, r = 0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = "sell_card", func = "can_sell_card" },
				nodes = {
					{ n = G.UIT.B, config = { w = 0.10, h = 0.60 } },
					{
						n = G.UIT.C,
						config = { align = "tm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", maxw = 1.25 },
								nodes = {
									{ n = G.UIT.T, config = { text = localize("b_sell"), colour = G.C.UI.TEXT_LIGHT, scale = 0.40, shadow = true } }
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
	stats = { weight = { min = 0.01, max = 0.01 }, length = { min = 0.40, max = 1.00 } },
	weight = fac_ghostsalt_common_weight,
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "xmult" },
	environments = {
		styx = 10,
		city_river = 8,
		backroom = 4
	},
	vel_limit = 0.2,
	impulse_min = 0,
	impulse_max = 0.1,
	decision_min = 1,
	decision_max = 1.2,
	blueprint_compat = true,
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
	stats = { weight = { min = 1.00, max = 2.00 }, length = { min = 0.15, max = 0.30 } },
	weight = fac_ghostsalt_common_weight,
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
				delay = 0.20,
				func = function()
					_card:flip()
					play_sound("card1", 1)
					_card:juice_up(0.30, 0.3)
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.50,
				func = function()
					_card:change_suit("Clubs")
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				delay = 0.20,
				func = function()
					_card:flip()
					play_sound("tarot2", 1)
					_card:juice_up(0.30, 0.3)
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
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0, max = 0 }, length = { min = 0.20, max = 0.45 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "xmult" },
	environments = {
		styx = 10,
		wormhole = 5
	},
	vel_limit = 0.5,
	impulse_min = 0.2,
	impulse_max = 0.4,
	decision_min = 0.4,
	decision_max = 0.5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	blueprint_compat = true,
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
	config = { extra = { xmult = 1.50 } },
	weight = 1,
	stats = { weight = { min = 1450, max = 1550 }, length = { min = 5.00, max = 6.00 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "xmult" },
	environments = {
		pier = 1,
		city_river = 1,
		garden = 1,
		chocolate_river = 1
	},
	vel_limit = 0.8,
	impulse_min = 0.4,
	impulse_max = 0.5,
	decision_min = 0.8,
	decision_max = 1.3,
	blueprint_compat = true,
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
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 1.00, max = 2.00 }, length = { min = 0.50, max = 0.60 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "economy" },
	environments = {
		garden = 10,
		calm_pond = 3,
		pier = 2,
	},
	vel_limit = 0.3,
	impulse_min = 0.1,
	impulse_max = 0.2,
	decision_min = 0.3,
	decision_max = 0.4,
	blueprint_compat = true,
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

FishAndChips.Fish {
	key = "ghostsalt_finvestor",
	atlas = "GhostSaltMyFish",
	pos = { x = 0, y = 2 },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0.10, max = 0.20 }, length = { min = 3.00, max = 4.00 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "economy", "usable" },
	environments = {
		city_river = 10,
		volcano = 2,
	},
	vel_limit = 0.8,
	impulse_min = 0.8,
	impulse_max = 1,
	decision_min = 0.5,
	decision_max = 0.7,
	blueprint_compat = false,
	use = function(self, card)
		G.E_MANAGER:add_event(Event {
			trigger = "before",
			delay = 0.6,
			func = function()
				card:juice_up()
				ease_dollars(G.GAME.fac_sand_dollars)
				ease_sand_dollars(-G.GAME.fac_sand_dollars)
				play_sound("fac_finvestor", 1, 0.8)
				return true
			end
		})
	end,
	can_use = function(self, card)
		return G.GAME.fac_sand_dollars > 0
	end,
	pronouns = "he_him"
}

FishAndChips.Fish {
	key = "ghostsalt_kitkatla",
	atlas = "GhostSaltMyFish",
	pos = { x = 1, y = 2 },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0.02, max = 0.02 }, length = { min = 0.1, max = 0.1 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "modify_card", "usable" },
	environments = {
		chocolate_river = 10
	},
	vel_limit = 0.35,
	impulse_min = 0.2,
	impulse_max = 0.4,
	decision_min = 0.2,
	decision_max = 0.4,
	blueprint_compat = false,
	requires_hand = true,
	use = function(self, card)
		local _card = G.hand.highlighted[1]
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				_card:flip()
				play_sound("card1")
				_card:juice_up(0.3, 0.3)
				return true
			end
		}))
		delay(0.2)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				local function find_rank(id)
					for k, v in pairs(SMODS.Ranks) do
						if v.id == id then return k end
					end
				end
				local new_rank = _card:get_id()
				if new_rank == 14 then new_rank = 1 end
				new_rank = new_rank * 2
				if new_rank <= 13 then
					if new_rank == 1 then new_rank = 14 end -- this will never happen lol
					assert(SMODS.change_base(_card, nil, find_rank(new_rank)))
				else
					for i = 1, #G.hand.cards do
						if G.hand.cards[i] == _card then
							local dos = SMODS.copy_card(_card)
							dos.rank = (_card.rank or 0) + 0.5
							table.sort(_card.area.cards, function(a, b) return a.rank < b.rank end)
							_card.area:align_cards()

							assert(SMODS.change_base(_card, nil, "King"))
							local rank_b = new_rank - 13
							if rank_b == 1 then rank_b = 14 end
							assert(SMODS.change_base(dos, nil, find_rank(rank_b)))

							dos.visible = nil
							dos:start_materialize()
							break
						end
					end
				end
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.15,
			func = function()
				_card:flip()
				play_sound("tarot2", 1, 0.6)
				_card:juice_up(0.3, 0.3)
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return #G.hand.highlighted == 1
	end,
	pronouns = "they_them"
}

FishAndChips.Fish {
	key = "ghostsalt_troweltrout",
	atlas = "GhostSaltMyFish",
	pos = { x = 2, y = 2 },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0.80, max = 1.20 }, length = { min = 0.40, max = 0.60 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "economy", "usable" },
	environments = {
		volcano = 10,
		garden = 8,
		soup = 4
	},
	vel_limit = 0.15,
	impulse_min = 0.1,
	impulse_max = 0.3,
	decision_min = 0.5,
	decision_max = 0.8,
	blueprint_compat = false,
	requires_hand = true,
	use = function(self, card)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				local money = G.hand.highlighted[1].base.nominal + G.hand.highlighted[2].base.nominal
				play_sound("timpani")
				ease_dollars(money)
				card_eval_status_text(card, "extra", nil, nil, nil, { message = "$" .. money, colour = G.C.MONEY })
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all()
				return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return #G.hand.highlighted == 2 and G.hand.highlighted[1]:is_suit("Spades") and G.hand.highlighted[2]:is_suit("Spades")
	end,
	pronouns = "they_them"
}

FishAndChips.Fish {
	key = "ghostsalt_swimmingribbon",
	atlas = "GhostSaltMyFish",
	pos = { x = 3, y = 2 },
	config = { extra = { set_chips = 100, given_chips = 20 } },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0.02, max = 0.03 }, length = { min = 2.00, max = 3.00 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "chips" },
	environments = {
		calm_pond = 10,
		styx = 5,
		swamp = 2
	},
	vel_limit = 0.25,
	impulse_min = 0.4,
	impulse_max = 0.6,
	decision_min = 0.6,
	decision_max = 0.8,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.set_chips, card.ability.extra.given_chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			hand_chips = mod_chips(card.ability.extra.set_chips)
			update_hand_text({ delay = 0 }, { chips = hand_chips })
			return { message = "=" .. card.ability.extra.set_chips, colour = G.C.CHIPS, card = card }
		end

		if context.other_main and context.other_main.ability.set == "fac_Fish" and context.other_main ~= card then
			return { chips = card.ability.extra.given_chips }
		end
	end,
	pronouns = "he_they"
}

FishAndChips.Fish {
	key = "ghostsalt_skipper",
	atlas = "GhostSaltMyFish",
	pos = { x = 0, y = 3 },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 30.00, max = 40.00 }, length = { min = 0.80, max = 1.20 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "passive" },
	environments = {
		pier = 10,
		city_river = 10,
		swamp = 5
	},
	vel_limit = 0.7,
	impulse_min = 1,
	impulse_max = 1,
	decision_min = 0.5,
	decision_max = 0.5,
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.skip_blind and not G.fac_skipper_skipping and not context.blueprint then
			G.fac_skipper_skipping = true
			stop_use()

			local amt = pseudorandom("fac_bait_gen" .. G.GAME.round_resets.ante, 2, 5)
			for _ = 1, amt do
				FishAndChips.add_bait_to_shop(SMODS.poll_object({ type = "fac_Bait", append = "fac_bait_shop" }))
			end
			FishAndChips.add_bait_to_shop("bait_fac_normal", pseudorandom("fac_guaranteed_normal_bait" .. G.GAME.round_resets.ante, 1, 3))
			FishAndChips.clean_up_bait_shop()
			local function fac_sort_bait_shop(bait1, bait2)
				if bait1.key == "bait_fac_normal" then
					return true
				elseif bait2.key == "bait_fac_normal" then
					return false
				end
				return bait1.amt > bait2.amt
			end
			table.sort(G.GAME.fac_bait_shop_items, fac_sort_bait_shop)

			if G.blind_select then
				G.GAME.facing_blind = true
				G.blind_prompt_box:get_UIE_by_ID("prompt_dynatext1").config.object.pop_delay = 0
				G.blind_prompt_box:get_UIE_by_ID("prompt_dynatext1").config.object:pop_out(5)
				G.blind_prompt_box:get_UIE_by_ID("prompt_dynatext2").config.object.pop_delay = 0
				G.blind_prompt_box:get_UIE_by_ID("prompt_dynatext2").config.object:pop_out(5)

				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.2,
					func = function()
						G.fac_skipper_skipping = false
						G.blind_prompt_box.alignment.offset.y = -10
						G.blind_select.alignment.offset.y = 40
						G.blind_select.alignment.offset.x = 0
						return true
					end
				}))
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						G.blind_select:remove()
						G.blind_prompt_box:remove()
						G.blind_select = nil
						delay(0.2)
						return true
					end
				}))
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.5,
					func = function()
						G.STATE_COMPLETE = false
						G.GAME.fishing = true
						G.STATE = G.STATES.FAC_FISHING
						G.CONTROLLER.locks.toggle_shop = nil
						return true
					end
				}))
			end
		end
	end,
	pronouns = "he_him"
}

FishAndChips.Fish {
	key = "ghostsalt_mezepheles",
	atlas = "GhostSaltMyFish",
	pos = { x = 1, y = 3 },
	draw = function(self, card, layer)
		if self.discovered or card.params.bypass_discovery_center then
			card.children.center:draw_shader("fac_mez", nil, card.ARGS.send_to_shader)
		end
	end,
	config = { extra = { word = "blah", xmult = 2 } },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0.03, max = 0.05 }, length = { min = 0.20, max = 1.00 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "xmult" },
	environments = {
		styx = 10,
		swamp = 8,
		backroom = 5,
		city_river = 2,
	},
	vel_limit = 0.5,
	impulse_min = 0.1,
	impulse_max = 0.2,
	decision_min = 0.3,
	decision_max = 0.4,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.word, card.ability.extra.xmult } }
	end,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.other_main and context.other_main.ability.set == "fac_Fish" and context.other_main.config.center.key ~= "fish_fac_ghostsalt_mezepheles" then
			local words = fac_ghostsalt_mezepheles_wordify_fish(context.other_main.config.center.key)
			for _, word in ipairs(words) do
				if word == card.ability.extra.word then
					return { xmult = card.ability.extra.xmult }
				end
			end
		end
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.extra.word = pseudorandom_element(G.fac_ghostsalt_mezepheles_words, "fac_ghostsalt_mezepheles_word")
	end,
	pronouns = "it_its"
}

function fac_ghostsalt_mezepheles_wordify_fish(key)
	if key == "fish_fac_ghostsalt_mezepheles" then return {} end
	local loc_target = G.localization.descriptions["fac_Fish"][key]
	local final_line = ""
	local multibox = not loc_target.text_parsed[1][1].strings
	if loc_target then
		for _, total in ipairs(multibox and loc_target.text_parsed or { [1] = loc_target.text_parsed }) do
			for _, lines in ipairs(total) do
				local assembled_string = ""
				for _, part in ipairs(lines) do
					for _, subpart in ipairs(part.strings) do
						if type(subpart) == "string" then
							assembled_string = assembled_string .. subpart
						end
					end
				end
				if final_line ~= "" then
					final_line = final_line .. " " .. assembled_string
				else
					final_line = assembled_string
				end
			end
		end
	end

	local words = {}
	local current_word = ""
	local alphabet = "abcdefdghijklmnopqrstuvwxyz"
	for i = 1, #final_line do
		local c = string.gsub(string.lower(final_line:sub(i, i)), "%p", "%%%1")
		if c == " " and current_word ~= "" then
			words[#words + 1] = current_word
			current_word = ""
		elseif c ~= " " then
			if string.find(alphabet, c) then
				current_word = current_word .. c
			end
		end
	end
	if current_word ~= "" then
		words[#words + 1] = current_word
	end
	return words
end

function fac_ghostsalt_mezepheles_find_doable_words(min_fish, max_fish)
	local word_counts = {}
	local no_of_fish = 0
	for k, v in pairs(G.P_CENTERS) do
		if v.set == "fac_Fish" then
			no_of_fish = no_of_fish + 1
			local individual_counted = {}
			local words = fac_ghostsalt_mezepheles_wordify_fish(k)
			for _, word in ipairs(words) do
				-- Eliminate anything shorter than 3 letters, to make things interesting (and also to eliminate the X in X2 Mult).
				-- Also eliminate words appearing twice in the same ability text.
				if #word >= 3 and not individual_counted[word] then
					word_counts[word] = (word_counts[word] or 0) + 1
					individual_counted[word] = true
				end
			end
		end
	end

	local doable_words = {}
	for word, count in pairs(word_counts) do
		if (not min_fish or count >= (min_fish * no_of_fish)) and (not max_fish or count <= (max_fish * no_of_fish)) then
			doable_words[#doable_words + 1] = word
		end
	end
	return doable_words
end

G.fac_ghostsalt_mezepheles_min = 0.1
G.fac_ghostsalt_mezepheles_max = 0.2

local main_menu_ref = Game.main_menu
Game.main_menu = function(change_context)
	local ret = main_menu_ref(change_context)

	fac_ghostsalt_mezepheles_recalc_wordlist()

	return ret
end

function fac_ghostsalt_mezepheles_recalc_wordlist()
	G.fac_ghostsalt_mezepheles_words = fac_ghostsalt_mezepheles_find_doable_words(G.fac_ghostsalt_mezepheles_min, G.fac_ghostsalt_mezepheles_max)
end

FishAndChips.Fish {
	key = "ghostsalt_fishwav",
	atlas = "GhostSaltMyFish",
	pos = { x = 2, y = 3 },
	config = { extra = { discards = 2, money = 3 } },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0, max = 0 }, length = { min = 0.01, max = 0.05 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "generation" },
	environments = {
		wormhole = 10
	},
	vel_limit = 0.9,
	impulse_min = 0.1,
	impulse_max = 0.1,
	decision_min = 0.1,
	decision_max = 0.1,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.discards, card.ability.extra.money } }
	end,
	blueprint_compat = true,
	calculate = function(self, card, context)
		if context.pre_discard and #context.full_hand == card.ability.extra.discards then
			return { dollars = card.ability.extra.money }
		end
	end,
	pronouns = "it_its"
}

local play_sound_ref = play_sound
function play_sound(sound_code, per, vol)
	local new_sound_code = sound_code
	local new_per = per or 1
	local new_vol = vol or 1
	if next(SMODS.find_card("fish_fac_ghostsalt_fishwav")) then
		local appropriate_sounds = {
			"button",
			"cancel",
			"card1",
			"card3",
			"cardFan2",
			"cardSlide1",
			"cardSlide2",
			"chips1",
			"chips2",
			"coin1",
			"coin2",
			"coin3",
			"coin4",
			"coin5",
			"coin6",
			"coin7",
			"crumple1",
			"crumple2",
			"crumple3",
			"crumple4",
			"crumple5",
			"explosion_buildup1",
			"explosion_release1",
			"foil1",
			"foil2",
			"generic1",
			"glass1",
			"glass2",
			"glass3",
			"glass4",
			"glass5",
			"glass6",
			"gold_seal",
			"gong",
			"highlight1",
			"highlight2",
			"holo1",
			"multhit1",
			"multhit2",
			"negative",
			"other1",
			"paper1",
			"polychrome1",
			"slice1",
			"tarot1",
			"tarot2",
			"timpani",
			"whoosh",
			"whoosh1",
			"whoosh2",
			"win",
			"fac_fishwav_fish"
		}
		for _, sound in ipairs(appropriate_sounds) do
			if sound == new_sound_code then
				local times = 0
				while sound == new_sound_code and times < 10 do
					new_sound_code = appropriate_sounds[math.random(#appropriate_sounds)]
					times = times + 1
					if times == 10 then new_sound_code = "fac_fishwav_fish" end
				end
				if sound_code == "paper1" and per and not vol then -- Fixes one specific instance of this sound (Cash Out screen) being too loud.
					new_vol = new_vol * 0.4
				end
				if new_sound_code ~= "fac_fishwav_fish" then
					new_per = new_per * ((math.random() / 2) + 0.75)
					new_vol = new_vol * 0.5
				else
					new_per = 1
					new_vol = 0.4
				end
				break
			end
		end
	end
	return play_sound_ref(new_sound_code, new_per, new_vol)
end

FishAndChips.Fish {
	key = "ghostsalt_eelongtea",
	atlas = "GhostSaltMyFish",
	pos = { x = 3, y = 3 },
	weight = fac_ghostsalt_common_weight,
	stats = { weight = { min = 0.50, max = 0.70 }, length = { min = 0.40, max = 0.60 } },
	ppu_coder = { "GhostSalt" },
	ppu_artist = { "GhostSalt" },
	attributes = { "modify_card", "destroy_card" },
	environments = {
		chocolate_river = 10,
		soup = 10,
		styx = 5
	},
	vel_limit = 0.4,
	impulse_min = 0,
	impulse_max = 0.4,
	decision_min = 0.2,
	decision_max = 0.7,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS.Gold
		info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
		return {}
	end,
	blueprint_compat = false,
	requires_hand = true,
	use = function(self, card)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("tarot1")
				card:juice_up(0.3, 0.5)
				return true
			end
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
				end
			}))
		end
		delay(0.2)
		local gc_card = math.ceil(pseudorandom(pseudoseed("ghostsalt_eelong_gc")) * 3)
		local lu_card
		local de_card
		if pseudorandom(pseudoseed("ghostsalt_eelong_lu")) > 0.5 then
			lu_card = (gc_card % 3) + 1
			de_card = ((gc_card + 1) % 3) + 1
		else
			lu_card = ((gc_card + 1) % 3) + 1
			de_card = (gc_card % 3) + 1
		end
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.3,
			func = function()
				G.hand.highlighted[gc_card]:set_seal("Gold", nil, true)
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.3,
			func = function()
				G.hand.highlighted[lu_card]:set_ability("m_lucky", nil, true)
				G.hand.highlighted[lu_card]:juice_up()
				play_sound("fac_eelongtea", 1, 0.75)
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.3,
			func = function()
				G.hand.highlighted[de_card]:start_dissolve()
				return true
			end
		}))
		local flip_cards = { G.hand.highlighted[gc_card], G.hand.highlighted[lu_card] }
		for i = 1, #flip_cards do
			local percent = 0.85 + (i - 0.999) / (#flip_cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					flip_cards[i]:flip(); play_sound("tarot2", percent, 0.6); flip_cards[i]:juice_up(0.3, 0.3); return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				G.hand:unhighlight_all(); return true
			end
		}))
		delay(0.5)
	end,
	can_use = function(self, card)
		return #G.hand.highlighted == 3
	end,
	pronouns = "she_her"
}
