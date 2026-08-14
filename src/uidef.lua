function G.UIDEF.fac_fishing()
	return {
		n = G.UIT.ROOT,
		config = {
			minw = G.ROOM_ATTACH.T.w,
			minh = G.ROOM_ATTACH.T.h,
			r = 0.1,
			emboss = 0.05,
			colour = G.C.BLACK,
			padding = 0.1,
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.O,
				config = {
					id = "fac_background",
					object = SMODS.create_sprite(
						0,
						0,
						G.ROOM_ATTACH.T.w,
						G.ROOM_ATTACH.T.h,
						FishAndChips.get_environment().background_atlas,
						FishAndChips.get_environment().background_pos
					),
				},
			},
		},
	}
end

function G.UIDEF.fac_fishing_status(index)
	local ref_value = "status_text_" .. index
	G.FAC_FISH_GAME = G.FAC_FISH_GAME or {}
	G.FAC_FISH_GAME[ref_value] = G.FAC_FISH_GAME[ref_value] or ""
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = {
					id = "fac_fishing_status_bg_" .. index,
					align = "cm",
					colour = { G.C.BLACK[1], G.C.BLACK[2], G.C.BLACK[3], 0.65 },
					r = 0.1,
					padding = 0.08,
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							id = "fac_fishing_status_text_" .. index,
							ref_table = G.FAC_FISH_GAME,
							ref_value = ref_value,
							colour = G.C.UI.TEXT_LIGHT,
							scale = 0.4,
							shadow = true,
						},
					},
				},
			},
		},
	}
end


local FAC_FISHING_BUTTON_IDS = {
	"fac_btn_toggle_fishing",
	"fac_btn_go_fish",
	"fac_btn_reroll_location",
	"fac_btn_open_bait_shop",
}

function FishAndChips.set_fishing_buttons_active(active)
	if not G.FISHING or not G.FISHING.fishing_buttons then
		return
	end
	for _, id in ipairs(FAC_FISHING_BUTTON_IDS) do
		local node = G.FISHING.fishing_buttons:get_UIE_by_ID(id)
		if node then
			if active then
				node.config.button = node.config.fac_button_key or node.config.button
			else
				node.config.fac_button_key = node.config.fac_button_key or node.config.button
				node.config.button = nil
			end
		end
	end
end

function FishAndChips.show_fishing_buttons()
	G.NOT_SAFE_TO_PRESS_BUTTONS = false
	ease_value(FishAndChips.C.FISHING_BUTTONS_BG, 4, 0.65 - FishAndChips.C.FISHING_BUTTONS_BG[4], nil, "REAL", true, 0.3)
	ease_value(FishAndChips.C.FISHING_BUTTONS_ACTIVE, 4, 0.65 - FishAndChips.C.FISHING_BUTTONS_ACTIVE[4], nil, "REAL", true, 0.3)
	ease_value(FishAndChips.C.FISHING_BUTTONS_TEXT, 4, 1 - FishAndChips.C.FISHING_BUTTONS_TEXT[4], nil, "REAL", true, 0.3)
	FishAndChips.set_fishing_buttons_active(true)
end

function FishAndChips.fade_fishing_buttons()
	G.NOT_SAFE_TO_PRESS_BUTTONS = true
	ease_value(FishAndChips.C.FISHING_BUTTONS_BG, 4, -0.65 - FishAndChips.C.FISHING_BUTTONS_BG[4], nil, "REAL", true, 0.3)
	ease_value(FishAndChips.C.FISHING_BUTTONS_ACTIVE, 4, -0.65 - FishAndChips.C.FISHING_BUTTONS_ACTIVE[4], nil, "REAL", true, 0.3)
	ease_value(FishAndChips.C.FISHING_BUTTONS_TEXT, 4, -1 - FishAndChips.C.FISHING_BUTTONS_TEXT[4], nil, "REAL", true, 0.3)
	FishAndChips.set_fishing_buttons_active(false)
end

function FishAndChips.safe_to_press_buttons()
	-- local fish_expanded = G.GAME and G.GAME.fac_fish_expanded
	local in_fishing_state = G.STATE == G.STATES.FAC_FISHING
	return not ((in_fishing_state and G.NOT_SAFE_TO_PRESS_BUTTONS)) or G.OVERLAY_MENU
end

function FishAndChips.update_bait_counter(major)
	if G.FISHING then
		if G.FISHING.fishing_bait_count then
			G.FISHING.fishing_bait_count:remove()
		end
		G.FISHING.fishing_bait_count = UIBox({
			definition = G.UIDEF.fac_bait_count(),
			config = {
				align = "br",
				offset = { x = -0.5, y = -0.5 },
				major = major,
				bond = "Weak",
				r_bond = "Weak",
				instance_type = "CARD"
			}
		})
		G.FISHING.fishing_bait_count.T.r = -0.3
	end
end

function FishAndChips.fishing_button(key, text, price)
	return
	{
		n = G.UIT.R,
		config = {
			minw = 3,
			minh = 1.5,
			r = 0.05,
			padding = 0.1,
			align = "cm",
			outline = 1,
			outline_colour = FishAndChips.C.FISHING_BUTTONS_BG,
			button_dist = 0.1,
			colour = FishAndChips.C.FISHING_BUTTONS_ACTIVE,
			button = "fac_" .. key,
			func = "fac_can_click_button",
			id = "fac_btn_" .. key,
			original_key = key
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{ n = G.UIT.T, config = { text = localize("b_fac_" .. text), scale = price and 0.4 or 0.5, colour = FishAndChips.C.FISHING_BUTTONS_TEXT } },
				}
			},
			price and {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{ n = G.UIT.T, config = { text = localize("$"), scale = 0.7, colour = FishAndChips.C.FISHING_BUTTONS_TEXT } },
					{ n = G.UIT.T, config = { ref_table = G.GAME, ref_value = 'fac_environment_reroll_cost', scale = 0.7, colour = FishAndChips.C.FISHING_BUTTONS_TEXT } },
				}
			},
		}
	}
end

function G.FUNCS.fac_can_click_button(e)
	if G.FUNCS['fac_can_' .. e.config.original_key](e) then
		e.config.button = 'fac_' .. e.config.original_key
		e.config.hover = true
		e.config.colour = FishAndChips.C.FISHING_BUTTONS_ACTIVE
	else
		e.config.button = nil
		e.config.hover = nil
		e.config.colour = FishAndChips.C.FISHING_BUTTONS_BG
	end
end

function G.UIDEF.fac_fishing_buttons()
	return {
		n = G.UIT.ROOT,
		config = {
			colour = G.C.CLEAR,
			padding = 0.1,
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.1,
					align = "cm",
				},
				nodes = {
					FishAndChips.fishing_button('toggle_fishing', 'next_round'),
					FishAndChips.fishing_button('go_fish', 'go_fish'),
					FishAndChips.fishing_button('open_bait_shop', 'bait_shop'),
					FishAndChips.fishing_button('reroll_location', 'reroll_location', true)
				},
			},
		},
	}
end

function G.FUNCS.fac_can_toggle_fishing(e)
	return G.FISHING_STATE == G.FISHING_STATES.LOBBY
end

function G.FUNCS.fac_can_go_fish(e)
	return G.FISHING_STATE == G.FISHING_STATES.LOBBY and G.GAME.fac_active_bait
end

function G.FUNCS.fac_can_open_bait_shop(e)
	return G.FISHING_STATE == G.FISHING_STATES.LOBBY
end

function G.FUNCS.fac_can_reroll_location(e)
	return G.FISHING_STATE == G.FISHING_STATES.LOBBY and (G.GAME.dollars - G.GAME.bankrupt_at) - G.GAME.fac_environment_reroll_cost >= 0
end

function G.UIDEF.fac_bait_inventory_button()
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR, align = "cm", padding = 0.1 },
		nodes = {
			{
				n = G.UIT.C,
				config = {
					minw = 1.5,
					minh = 0.5,
					r = 0.1,
					colour = { G.C.BLACK[1], G.C.BLACK[2], G.C.BLACK[3], 0.65 },
					padding = 0.1,
					align = "cm",
					button = "fac_open_bait_inventory",
					hover = true
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("k_fac_view_baits"),
									scale = 0.4,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						}
					},
				}
			},
		},
	}
end

function G.UIDEF.fac_bait_count()
	local t = {
		n = G.UIT.ROOT,
		config = { padding = 0.2, colour = G.C.CLEAR },
	}
	if G.GAME.fac_active_bait then
		t.nodes = { {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = 'X' .. FishAndChips.get_bait_inventory_item(G.GAME.fac_active_bait).amt,
						scale = 0.5,
						colour = G.C.UI.TEXT_LIGHT,
						hover = true,
						shadow = true
					},
				},
			},
		} }
	end
	return t
end

function G.UIDEF.fac_fishing_area_display()
	local t = {
		n = G.UIT.ROOT,
		config = {
			colour = G.C.CLEAR,
			padding = 0.1,
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.C,
				config = {
					padding = 0.1,
					align = "cm",
				},
				nodes = {
					{
						n = G.UIT.R,
						config = {
							minw = 6,
							minh = 1.5,
							r = 0.1,
							colour = { G.C.BLACK[1], G.C.BLACK[2], G.C.BLACK[3], 0.65 },
							padding = 0.1,
							align = "cm",
							id = 'environment_desc',
							button = 'open_compendium_to_env',
							button_dist = 0.05,
							hover = true
						},
						nodes = {
							{
								n = G.UIT.R,
								config = {
									align = 'cm',
									padding = 0.1,
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = localize({
												type = "name_text",
												set = "fac_Env",
												key = G.GAME.fac_fishing_environment,
											}),
											scale = 0.8,
											colour = G.C.UI.TEXT_LIGHT,
										},
									},
								}
							},
						},
					},
					{
						n = G.UIT.R,
						config = {
							minw = 6,
							minh = 0.8,
							r = 0.1,
							colour = { G.C.BLACK[1], G.C.BLACK[2], G.C.BLACK[3], 0.65 },
							padding = 0.1,
							align = "cm",
						},
						nodes = {
							{
								n = G.UIT.R,
								config = {
									align = "cm"
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = localize("$"),
											scale = 0.5,
											colour = FishAndChips.C.SAND_DOLLAR,
											font = SMODS.Fonts["fac_sand_dollars"],
										},
									},
									{
										n = G.UIT.T,
										config = {
											ref_table = G.GAME,
											ref_value = "fac_sand_dollars",
											scale = 0.5,
											colour = FishAndChips.C.SAND_DOLLAR,
										},
									},
									{
										n = G.UIT.T,
										config = {
											text = ", ",
											scale = 0.5,
											colour = G.C.UI.TEXT_LIGHT,
										},
									},
									{
										n = G.UIT.T,
										config = {
											text = localize("$"),
											scale = 0.5,
											colour = G.C.MONEY,
										},
									},
									{
										n = G.UIT.T,
										config = {
											ref_table = G.GAME,
											ref_value = "dollars",
											scale = 0.5,
											colour = G.C.MONEY,
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}

	local env_desc = {}

	localize({
		type = "descriptions",
		set = "fac_Env",
		key = G.GAME.fac_fishing_environment,
		nodes = env_desc,
		text_colour = G.C.UI.TEXT_LIGHT,
		fixed_scale = 0.35,
	})

	for _, node in pairs(env_desc) do
		t.nodes[1].nodes[1].nodes[#t.nodes[1].nodes[1].nodes + 1] = { n = G.UIT.R, config = { align = 'cm' }, nodes = node }
	end

	return t
end

function G.UIDEF.fac_fishing_bucket_bottom()
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.O,
				config = {
					object = SMODS.create_sprite(0, 0, G.CARD_W * 1.2, G.CARD_H * 1.2, "fac_bucket", { x = 2, y = 1 }),
				},
			},
		},
	}
end

function G.UIDEF.fac_fishing_bucket_top()
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.CLEAR, fac_ignore = true, button = "fac_open_fishing_menu", button_dist = 0 },
		nodes = {
			{
				n = G.UIT.O,
				config = {
					object = SMODS.create_sprite(0, 0, G.CARD_W * 1.2, G.CARD_H * 1.2, "fac_bucket", { x = 1, y = 1 }),
				},
			},
		},
	}
end

local function fac_cardarea_full_row(center)
	return {
		n = G.UIT.R,
		config = { align = "cm", colour = G.C.UI.BACKGROUND_WHITE, r = 0.2, padding = 0.2 },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("ph_fac_cardarea_full1"),
									colour = G.C.UI.TEXT_DARK,
									scale = 0.4,
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize { type = "variable", key = 'ph_fac_cardarea_full2', vars = { FishAndChips.get_card_display_name(center) } },
									colour = G.C.UI.TEXT_DARK,
									scale = 0.4,
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = localize("ph_fac_cardarea_full3"),
									colour = G.C.UI.TEXT_DARK,
									scale = 0.4,
								},
							},
						},
					},
				},
			},
		},
	}
end

function G.UIDEF.fac_fish_data(fish, show_full)
	local center = fish.config.center
	local locvars = center.loc_vars and center:loc_vars({}, fish) or {}
	local t = {
		n = G.UIT.ROOT,
		config = { emboss = 0.1, r = 0.2, padding = 0.2 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize({ type = "name_text", set = center.set, key = locvars.key or center.key, vars = locvars.vars or {} }),
							scale = 0.5,
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
		},
	}
	if show_full then
		t.nodes[#t.nodes + 1] = fac_cardarea_full_row(center)
	end
	return t
end

--- return the display name (Fish, Joker, Consumable) for a center
---@param center any
---@return "Fish"|"Joker"|"Consumable"|"whatevereth this thingeth is"
function FishAndChips.get_card_display_name(center)
	if center.set == "fac_Fish" then return "Fish" end
	if center.set == "Joker" then return "Joker" end
	if center.consumeable then return "Consumable" end
	return "whatevereth this thingeth is"
end

function G.UIDEF.fac_newly_discovered()
	return {
		n = G.UIT.ROOT,
		config = { emboss = 0.1, r = 0.2, padding = 0.2 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize('k_fac_new_fish_discovered_ex'),
							scale = 0.5,
							colour = FishAndChips.discovery_gradient,
						},
					},
				},
			},
		}
	}
end

function G.UIDEF.fac_catch_text()
	return {
		n = G.UIT.ROOT,
		config = { padding = 0.2, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", no_fill = true },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize('k_fac_catch_meter'),
							scale = 0.3,
							colour = {0.97, 0.76, 0.82, 1},
							text_outline = G.C.BLACK,
						},
					},
				},
			},
		}
	}
end

function G.UIDEF.fac_treasure_text()
	return {
		n = G.UIT.ROOT,
		config = { padding = 0.2, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", no_fill = true },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize('k_fac_treasure_meter'),
							scale = 0.3,
							colour = {0.98, 0.90, 0.62, 1},
							text_outline = G.C.BLACK,
						},
					},
				},
			},
		}
	}
end

function G.UIDEF.fac_perfect_catch()
	return {
		n = G.UIT.ROOT,
		config = { padding = 0.2, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", no_fill = true },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize('ph_fac_perfect_catch'),
							scale = 0.25,
							colour = G.C.GOLD,
							text_outline = G.C.BLACK,
							hover = true,
							shadow = true
						},
					},
				},
			},
		}
	}
end

function G.UIDEF.fac_treasure_catch()
	return {
		n = G.UIT.ROOT,
		config = { padding = 0.2, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", no_fill = true },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = localize('ph_fac_treasure_catch'),
							scale = 0.35,
							colour = FishAndChips.C.SAND_DOLLAR,
							text_outline = G.C.BLACK,
							hover = true,
							shadow = true
						},
					},
				},
			},
		}
	}
end

function G.UIDEF.fac_treasure_reward(amount, kind)
	local colour = kind == "dollars" and G.C.MONEY or FishAndChips.C.SAND_DOLLAR
	local icon_node
	if kind == "dollars" then
		icon_node = {
			n = G.UIT.T,
			config = { text = localize('$'), colour = colour, scale = 2.4, shadow = true },
		}
	else
		icon_node = {
			n = G.UIT.O,
			config = {
				object = DynaText({
					string = { localize('$') },
					font = SMODS.Fonts["fac_sand_dollars"],
					colour = colour,
					shadow = true,
					pop_in = 0,
					scale = 2.4,
					float = true,
				}),
			},
		}
	end
	return {
		n = G.UIT.ROOT,
		config = { padding = 0.2, colour = G.C.CLEAR },
		nodes = {
			{ n = G.UIT.R, config = { align = "cm", no_fill = true }, nodes = { icon_node } },
			{
				n = G.UIT.R,
				config = { align = "cm", no_fill = true },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = tostring(amount),
							colour = colour,
							scale = 1.1,
							shadow = true,
						},
					},
				},
			},
		}
	}
end

function G.FUNCS.fac_upgrade_bucket (e)
	ease_sand_dollars(-G.GAME.fac_bucket_price, true)
	G.GAME.fac_bucket_price = G.GAME.fac_bucket_price + 10
	G.fac_fish_area.config.card_limits.base = G.fac_fish_area.config.card_limits.base + 1
	G.GAME.fac_upgrade_text = localize{type = "variable", key = "ph_fac_upgrade_increase", vars = {G.fac_fish_area.config.card_limits.base, G.fac_fish_area.config.card_limits.base + 1}}
end

function G.FUNCS.fac_can_upgrade_bucket (e)
	if G.GAME.fac_sand_dollars >= G.GAME.fac_bucket_price then
		e.config.button = 'fac_upgrade_bucket'
		e.config.colour = G.C.ORANGE
	else
		e.config.button = nil
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
	end
end

function G.UIDEF.fac_bait_shop()
	if not G.GAME.fac_snapper_dialogue_opt then
		G.GAME.fac_no_of_shops_until_dialogue = (G.GAME.fac_no_of_shops_until_dialogue or 1) - 1
		if G.GAME.fac_no_of_shops_until_dialogue > 0 then G.GAME.fac_snapper_dialogue_opt = 1 end
	end
	local do_dialogue = not G.GAME.fac_snapper_dialogue_opt and G.GAME.fac_no_of_shops_until_dialogue <= 0
	if do_dialogue then
		G.GAME.fac_no_of_bait_shops = (G.GAME.fac_no_of_bait_shops or 0) + 1
		if G.GAME.fac_no_of_bait_shops > 6 then G.GAME.fac_no_of_bait_shops = 6 end
		G.GAME.fac_no_of_shops_until_dialogue = G.GAME.fac_no_of_bait_shops
		G.GAME.fac_snapper_dialogue_opt = math.random(3)

		if G.GAME.fac_no_of_bait_shops == 5 and G.GAME.fac_snapper_dialogue_opt == 1 then
			G.GAME.fac_is_snapper_wearing_suit = true
			check_for_unlock({type = 'fac_snapper_alt'})
		end
	end

	G.GAME.fac_snapper_shop_sprite = Sprite(0, 0, G.CARD_W * 1.5, G.CARD_H * 1.5, G.ASSET_ATLAS["fac_cards"],
		{ x = (G.GAME.fac_is_snapper_wearing_suit and 2 or 1), y = 0 })
	local sprite = G.GAME.fac_snapper_shop_sprite
	sprite.states.collide.can = false
	sprite.states.drag.can = false
	sprite.config.speech_bubble_align = { align = "tm", offset = { x = 0, y = -0.1 }, parent = sprite }

	local stocked_items = false
	for _, v in ipairs(G.GAME.fac_bait_shop_items) do
		if v.amt > 0 then stocked_items = true end
	end
	if not stocked_items then
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			timer = "REAL",
			blocking = false,
			func = function()
				sprite.children.intro_text = UIBox({
					definition = G.UIDEF.speech_bubble("fac_snapper_dialogue_empty_" .. math.random(3), { quip = true }),
					config = sprite.config.speech_bubble_align,
				})

				sprite:say_stuff(5)
				return true
			end
		}))
	elseif not G.PROFILES[G.SETTINGS.profile].fac_snapper_alt_said then
		G.PROFILES[G.SETTINGS.profile].fac_snapper_alt_said = true
		G:save_settings()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			timer = "REAL",
			blocking = false,
			func = function()
				sprite.children.intro_text = UIBox({
					definition = G.UIDEF.speech_bubble("fac_snapper_dialogue_1_alt", { quip = true }),
					config = sprite.config.speech_bubble_align,
				})

				sprite:say_stuff(5)
				return true
			end
		}))
	elseif do_dialogue then
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			timer = "REAL",
			blocking = false,
			func = function()
				sprite.children.intro_text = UIBox({
					definition = G.UIDEF.speech_bubble("fac_snapper_dialogue_" .. G.GAME.fac_no_of_bait_shops .. "_" .. G.GAME.fac_snapper_dialogue_opt, { quip = true }),
					config = sprite.config.speech_bubble_align,
				})

				sprite:say_stuff(5)
				return true
			end
		}))
	end

	function sprite:say_stuff(n)
		if n <= 0 then return end
		local new_said = math.random(6)
		while new_said == self.last_said do
			new_said = math.random(6)
		end
		self.last_said = new_said
		play_sound("fac_snapper_voice-0" .. new_said, (math.random() * 0.1) + 0.8, 0.5)
		self:juice_up(0.1, 0.1)
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			timer = "REAL",
			delay = 0.13,
			func = function()
				self:say_stuff(n - 1)
				return true
			end
		}))
	end

	return {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			minw = G.ROOM.T.w * 5,
			minh = G.ROOM.T.h * 5,
			padding = 0.1,
			r = 0.1,
			colour = { G.C.GREY[1], G.C.GREY[2], G.C.GREY[3], 0.7 },
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { r = 0.1, colour = G.C.JOKER_GREY, padding = 0.05, align = "cm" },
				nodes = {
					{
						n = G.UIT.C,
						config = { colour = G.C.L_BLACK, r = 0.1, padding = 0.2, align = "cm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.1 },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.T,
												config = {
													text = localize('ph_fac_shop_title'),
													scale = 0.8,
													colour = G.C.UI.TEXT_LIGHT,
												},
											},
										},
									},
									{
										n = G.UIT.R,
										config = { align = "cm", padding = 0.1 },
										nodes = {
											{
												n = G.UIT.C,
												config = { align = "cm", padding = 0.1 },
												nodes = {
													{
														n = G.UIT.R,
														nodes = {
															{
																n = G.UIT.O,
																config = {
																	object = sprite
																},
															},
														},
													},
													{
														n = G.UIT.R,
														config = {
															r = 0.1,
															emboss = 0.05,
															padding = 0.2,
															colour = G.C.BLACK,
															align = "cm",
														},
														nodes = {
															{
																n = G.UIT.O,
																config = {
																	object = DynaText({
																		string = {
																			{
																				prefix = localize("$"),
																				ref_table = G.GAME,
																				ref_value = "fac_sand_dollars",
																			},
																		},
																		colours = { FishAndChips.C.SAND_DOLLAR },
																		shadow = true,
																		silent = true,
																		bump = true,
																		pop_in = 0,
																		scale = 0.7,
																		font = SMODS.Fonts["fac_sand_dollars"],
																		spacing = 1.2,
																	}),
																},
															},
														},
													},
												},
											},
											{
												n = G.UIT.C,
												config = { padding = 0.1, align = "cm" },
												nodes = G.UIDEF.fac_bait_shop_item_rows(),
											},
											{n = G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.BLACK, emboss = 0.05}, nodes = {
												{n = G.UIT.R, config = {align = "cm"}, nodes = {
													{n = G.UIT.R, config = {align = "cm"}, nodes = {
														{n = G.UIT.O, config = {object = DynaText{
															string = localize("ph_fac_bucket_upgrade_1"),
															colours = { G.C.GOLD },
															shadow = true,
															silent = true,
															bump = true,
															pop_in = 0.2,
															scale = 0.6,
															spacing = 1.2,
														}}}
													}},
													{n = G.UIT.R, config = {align = "cm"}, nodes = {
														{n = G.UIT.O, config = {object = DynaText{
															string = localize("ph_fac_bucket_upgrade_2"),
															colours = { G.C.GOLD },
															shadow = true,
															silent = true,
															bump = true,
															pop_in = 0.2,
															scale = 0.6,
															spacing = 1.2,
														}}}
													}}
												}},
												{n = G.UIT.R, config = {align = "cm", r = 0.2, tooltip = {
														title = localize("ph_fac_upgrade"),
														text = {{ref_table = G.GAME, ref_value = "fac_upgrade_text"}}
													}}, nodes = {
													{n = G.UIT.O, config = {object = SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, "fac_upgrade_bucket")}}
												}},
												{n = G.UIT.R, config = {align = "cm", colour = G.C.ORANGE, r = 0.3, emboss = 0.1, button = "fac_upgrade_bucket", func = "fac_can_upgrade_bucket", padding = 0.2}, nodes = {
													{n = G.UIT.O, config = {object = DynaText{
														string = {
															{
																prefix = localize("$"),
																ref_table = G.GAME,
																ref_value = "fac_bucket_price"
															}
														},
														colours = { G.C.UI.TEXT_LIGHT },
														shadow = true,
														silent = true,
														bump = true,
														pop_in = 0.2,
														scale = 0.7,
														spacing = 1.2,
														font = SMODS.Fonts["fac_sand_dollars"],
													}}}
												}}
											}}
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = {
									id = "overlay_menu_back_button",
									align = "cm",
									minw = 2.5,
									padding = 0.1,
									r = 0.1,
									hover = true,
									colour = G.C.ORANGE,
									button = "exit_overlay_menu",
									shadow = true,
									focus_args = { nav = "wide", button = "b" },
								},
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm", padding = 0, no_fill = true },
										nodes = {
											{
												n = G.UIT.T,
												config = {
													text = localize("b_back"),
													scale = 0.5,
													colour = G.C.UI.TEXT_LIGHT,
													shadow = true,
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
end

function G.FUNCS.fac_open_bait_shop(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.fac_bait_shop(),
		config = {},
	})
end

local can_buy_hook = G.FUNCS.can_buy
function G.FUNCS.can_buy(e, ...)
	local card = e.config.ref_table
	if card.config.center.set == "fac_Bait" then
		if (e.config.ref_table.cost > G.GAME.fac_sand_dollars) and (e.config.ref_table.cost > 0) then
			e.config.colour = G.C.UI.BACKGROUND_INACTIVE
			e.config.button = nil
		else
			e.config.colour = G.C.ORANGE
			e.config.button = "buy_from_shop"
		end
		if e.config.ref_parent and e.config.ref_parent.children.buy_and_use then
			if e.config.ref_parent.children.buy_and_use.states.visible then
				e.UIBox.alignment.offset.y = -0.6
			else
				e.UIBox.alignment.offset.y = 0
			end
		end
	else
		return can_buy_hook(e, ...)
	end
end

local buy_from_shop_hook = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e, ...)
	local c = e.config.ref_table
	if c and c:is(Card) and c.config.center.set == "fac_Bait" then
		ease_sand_dollars(-c.cost, true)
		FishAndChips.add_bait_to_inventory(c.config.center_key)
		FishAndChips.remove_bait_from_shop(c.config.center_key)
		SMODS.calculate_context { fac_buy_bait = c.config.center }
		c:start_dissolve(nil, nil, 0.3)

		local stocked_items = false
		for _, v in ipairs(G.GAME.fac_bait_shop_items) do
			if v.amt > 0 then stocked_items = true end
		end
		if not stocked_items then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				timer = "REAL",
				blocking = false,
				func = function()
					G.GAME.fac_snapper_shop_sprite.children.intro_text = UIBox({
						definition = G.UIDEF.speech_bubble("fac_snapper_dialogue_cleared_" .. math.random(3), { quip = true }),
						config = G.GAME.fac_snapper_shop_sprite.config.speech_bubble_align,
					})

					G.GAME.fac_snapper_shop_sprite:say_stuff(5)
					return true
				end
			}))
		end
	else
		buy_from_shop_hook(e, ...)
	end
end

function G.UIDEF.fac_create_shop_entry(key)
	local amt = (FishAndChips.get_bait_shop_item(key) or {}).amt or 0
	local area = CardArea(0, 0, G.CARD_W + 0.1, G.CARD_H, {
		card_limit = 1,
		type = "joker",
		highlight_limit = 1,
		highlighted_limit = 1,
		align_buttons = true,
		no_card_count = true,
	})
	for _ = 1, amt do
		local c = SMODS.add_card({ key = key, area = area })
		c.children.buy_button = UIBox({
			definition = {
				n = G.UIT.ROOT,
				config = {
					ref_table = c,
					minw = 1.1,
					maxw = 1.3,
					padding = 0.1,
					align = "bm",
					colour = G.C.GOLD,
					shadow = true,
					r = 0.08,
					minh = 0.94,
					func = "can_buy",
					one_press = true,
					button = "buy_from_shop",
					hover = true,
				},
				nodes = {
					{ n = G.UIT.T, config = { text = localize("b_buy"), colour = G.C.WHITE, scale = 0.5 } },
				},
			},
			config = {
				align = "bm",
				offset = { x = 0, y = -0.3 },
				major = c,
				bond = "Weak",
				parent = c,
			},
		})
	end
	return {
		n = G.UIT.C,
		config = {
			padding = 0.1,
			colour = G.C.CLEAR,
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					colour = lighten(G.C.BLACK, 0.1),
					r = 0.1,
					emboss = 0.05,
					padding = 0.03,
					minh = 0.6,
				},
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = DynaText({
								string = {
									{ prefix = localize("$"), ref_table = G.P_CENTERS[key], ref_value = "cost" },
								},
								colours = { FishAndChips.C.SAND_DOLLAR },
								shadow = true,
								silent = true,
								bump = true,
								pop_in = 0,
								scale = 0.5,
								font = SMODS.Fonts["fac_sand_dollars"],
								spacing = 1.2,
							}),
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{
						n = G.UIT.R,
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "X",
									scale = 0.4,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
							{
								n = G.UIT.T,
								config = {
									ref_table = setmetatable({}, {
										__index = function(_, k)
											return (FishAndChips.get_bait_shop_item(key) or {}).amt or 0
										end,
									}),
									ref_value = "nope",
									scale = 0.4,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
				},
			},
			{
				n = G.UIT.R,
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = area,
						},
					},
				},
			},
		},
	}
end

function G.UIDEF.fac_bait_shop_item_rows()
	local w = 1 + (G.CARD_W + 0.1) * 3
	local cols = {}
	for _, b in ipairs(G.GAME.fac_bait_shop_items) do
		cols[#cols + 1] = G.UIDEF.fac_create_shop_entry(b.key)
	end
	local items = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = {
				colour = G.C.CLEAR,
				padding = 0.1,
				align = "cl",
				minw = w,
			},
			nodes = cols,
		},
		config = { instance_type = "CARD" },
	})
	local box = nil
	if items.T.w > w then
		box = SMODS.UIScrollBox({
			content = {
				definition = {
					n = G.UIT.ROOT,
					config = { align = "cm", colour = G.C.CLEAR },
					nodes = {
						{
							n = G.UIT.O,
							config = { object = items },
						},
					},
				},
				config = { align = "cm" },
			},
			overflow = {
				node_config = {
					maxw = w,
					no_overflow = "h",
				},
			},
			sync_mode = "progress",
		})
	end
	local ret = {
		{
			n = G.UIT.R,
			config = { colour = G.C.BLACK, emboss = 0.05, r = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = box or items } },
			},
		},
	}
	if box then
		local bar = SMODS.GUI.scrollbar({
			horizontal = true,
			w = w,
			h = 0.2,
			colour = FishAndChips.C.SAND_DOLLAR,
			bg_colour = { 0, 0, 0, 0.15 },
			scroll_collision_obj = box,
			scroll_mult = 1.6,
		})
		bar.config.align = "cm"
		ret[#ret + 1] = { n = G.UIT.R, config = { minh = 0.1 } }
		ret[#ret + 1] = bar
	end
	return ret
end

function G.FUNCS.fac_can_set_active(e)
	if e.config.key == G.GAME.fac_active_bait then
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	else
		e.config.colour = G.C.FILTER
		e.config.button = "fac_set_active_bait"
	end
end

function G.FUNCS.fac_set_active_bait(e)
	G.GAME.fac_active_bait = e.config.key

	G.PROFILES[G.SETTINGS.profile].fac_fishing.bait_data[e.config.key] = G.PROFILES[G.SETTINGS.profile].fac_fishing.bait_data[e.config.key] or {
        fish_caught = 0,
		fish_lost = 0,
		perfect_catch = 0,
		treasure = 0
    }

	if G.fac_bait_area.cards[1] then
		G.fac_bait_area.cards[1]:remove()
	end

	if G.FISHING and G.FISHING.fishing_bait_count then
		G.FISHING.fishing_bait_count:remove()
	end

	local bait = SMODS.add_card({ key = e.config.key, area = G.fac_bait_area, skip_materialize = true })

	if G.FISHING then FishAndChips.update_bait_counter(bait) end
end

function G.UIDEF.fac_create_inventory_entry(key)
	local amt = (FishAndChips.get_bait_inventory_item(key) or {}).amt or 0
	local area = CardArea(0, 0, G.CARD_W + 0.1, G.CARD_H, {
		card_limit = 1,
		type = "joker",
		highlight_limit = 0,
		highlighted_limit = 0,
		align_buttons = true,
		no_card_count = true,
	})
	for _ = 1, amt do
		local c = SMODS.add_card({ key = key, area = area })
	end
	return {
		n = G.UIT.C,
		config = {
			padding = 0.1,
			colour = G.C.CLEAR,
			align = "cm",
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					colour = G.C.FILTER,
					r = 0.1,
					emboss = 0.05,
					padding = 0.03,
					minh = 0.6,
					key = key,
					func = "fac_can_set_active",
					button = "fac_set_active_bait",
					shadow = true,
					hover = true,
				},
				nodes = {
					{
						n = G.UIT.T,
						config = {
							scale = 0.4,
							text = localize("k_fac_equip_bait"),
							colour = G.C.UI.TEXT_LIGHT,
						},
					},
				},
			},
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1 },
				nodes = {
					{
						n = G.UIT.R,
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = "X",
									scale = 0.4,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
							{
								n = G.UIT.T,
								config = {
									ref_table = setmetatable({}, {
										__index = function(_, k)
											return (FishAndChips.get_bait_inventory_item(key) or {}).amt or 0
										end,
									}),
									ref_value = "nope",
									scale = 0.4,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
				},
			},
			{
				n = G.UIT.R,
				nodes = {
					{
						n = G.UIT.O,
						config = {
							object = area,
						},
					},
				},
			},
		},
	}
end

function G.UIDEF.fac_bait_inventory_item_rows()
	local w = 1 + (G.CARD_W + 0.1) * 3
	local cols = {}
	for _, b in ipairs(G.GAME.fac_bait_inventory) do
		cols[#cols + 1] = G.UIDEF.fac_create_inventory_entry(b.key)
	end
	if not next(cols) then
		cols[#cols + 1] = {
			n = G.UIT.C,
			config = {
				minw = w - 0.2,
				align = "cm",
				minh = G.CARD_H + 0.2,
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						scale = 0.4,
						colour = G.C.UI.TEXT_LIGHT,
						text = localize("k_fac_no_baits")
					}
				}
			}
		}
	end
	local items = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = {
				colour = G.C.CLEAR,
				padding = 0.1,
				align = "cl",
				minw = w,
			},
			nodes = cols,
		},
		config = { instance_type = "CARD" },
	})
	local box = nil
	if items.T.w > w then
		box = SMODS.UIScrollBox({
			content = {
				definition = {
					n = G.UIT.ROOT,
					config = { align = "cm", colour = G.C.CLEAR },
					nodes = {
						{
							n = G.UIT.O,
							config = { object = items },
						},
					},
				},
				config = { align = "cm" },
			},
			overflow = {
				node_config = {
					maxw = w,
					no_overflow = "h",
				},
			},
			sync_mode = "progress",
		})
	end
	local ret = {
		{
			n = G.UIT.R,
			config = { colour = G.C.BLACK, emboss = 0.05, r = 0.1 },
			nodes = {
				{ n = G.UIT.O, config = { object = box or items } },
			},
		},
	}
	if box then
		local bar = SMODS.GUI.scrollbar({
			horizontal = true,
			w = w,
			h = 0.2,
			colour = FishAndChips.C.SAND_DOLLAR,
			bg_colour = { 0, 0, 0, 0.15 },
			scroll_collision_obj = box,
			scroll_mult = 1.6,
		})
		bar.config.align = "cm"
		ret[#ret + 1] = { n = G.UIT.R, config = { minh = 0.1 } }
		ret[#ret + 1] = bar
	end
	return ret
end

function G.UIDEF.fac_bait_inventory()
	return {
		n = G.UIT.ROOT,
		config = {
			align = "cm",
			minw = G.ROOM.T.w * 5,
			minh = G.ROOM.T.h * 5,
			padding = 0.1,
			r = 0.1,
			colour = { G.C.GREY[1], G.C.GREY[2], G.C.GREY[3], 0.7 },
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { r = 0.1, colour = G.C.JOKER_GREY, padding = 0.05, align = "cm" },
				nodes = {
					{
						n = G.UIT.C,
						config = { colour = G.C.L_BLACK, r = 0.1, padding = 0.2, align = "cm" },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.1 },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.T,
												config = {
													text = "Bait Inventory",
													scale = 0.8,
													colour = G.C.UI.TEXT_LIGHT,
												},
											},
										},
									},
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.C,
												config = { padding = 0.1, align = "cm" },
												nodes = G.UIDEF.fac_bait_inventory_item_rows(),
											},
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = {
									id = "overlay_menu_back_button",
									align = "cm",
									minw = 2.5,
									padding = 0.1,
									r = 0.1,
									hover = true,
									colour = G.C.ORANGE,
									button = "exit_overlay_menu",
									shadow = true,
									focus_args = { nav = "wide", button = "b" },
								},
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm", padding = 0, no_fill = true },
										nodes = {
											{
												n = G.UIT.T,
												config = {
													text = localize("b_back"),
													scale = 0.5,
													colour = G.C.UI.TEXT_LIGHT,
													shadow = true,
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
end

function G.FUNCS.fac_open_bait_inventory(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = G.UIDEF.fac_bait_inventory(),
		config = {},
	})
end

local add_to_highlighted_hook = CardArea.add_to_highlighted
function CardArea:add_to_highlighted(card, silent, ...)
	if self.config.highlighted_limit <= 0 then
		return
	end
	add_to_highlighted_hook(self, card, silent, ...)
end

FishAndChips.show_ui = true
function FishAndChips.hide_ui()
	FishAndChips.show_ui = not FishAndChips.show_ui
	local uis = {
		G.FISHING.fishing_bait_inventory,
		G.FISHING.fishing_buttons,
		G.FISHING.fishing_area_display,
		G.fac_fishing_bucket_bottom,
		G.fac_fishing_bucket_top,
		G.FISHING.fishing_bait_count,
		G.FISHING.jimbo,
		G.fac_rod_area,
		G.fac_bait_area
	}
	for _, ui in ipairs(uis) do
		ui.states.visible = FishAndChips.show_ui
	end
end
