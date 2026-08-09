FishAndChips.Fish{
	key = "fas_tsundere",
	weight = 5,
	environments = {
		volcano = 1,
		aquifer = 0.25
	},
	button_key = "b_fac_fas_act",
	ppu_coder = {"Foo54"},
	ppu_artist = {"squeax09"},
	atlas = "fas_fish_general",
	pos = {x=0,y=1},
	pixel_size = {w=69,h=88},
	config = {
		extra = {
			selection = 1
		},
		immutable = {
			active = false,
			progress = 1,
			used = false,
			result = nil
		}
	},
	disable_visual_scaling = true,
	stats = {
		length = {min = 25, max = 26},
		weight = {min = 25, max = 26}
	},
	attributes = {"usable", "passive"},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.selection}, key = card.ability.immutable.active and "fish_fac_fas_tsundere_active" or nil}
	end,
	can_use = function (self, card)
		return not card.ability.immutable.active and not card.ability.immutable.used and not G.fac_fas_tsunderfish_ui
	end,
	keep_on_use = function (self, card)
		return true
	end,
	use = function (self, card)
		card.ability.immutable.option = 0
		G.fac_fas_tsunderfish_ui = FishAndChips.FooSqueax.tsunderfish.create_act_uibox(card)
	end
}

SMODS.Atlas{
	key = "fas_icons",
	path = FishAndChips.FooSqueax.file_path .. "icons.png",
	px = 32,
	py = 32
}

function G.FUNCS.fac_fas_tsunderfish_update (e)
	if e.states.hover.is ~= e.config.ref_table.past_hover then
		G["fac_fas_" .. e.config.ref_table.name]:set_sprite_pos({x = e.states.hover.is and 1 or 0, y = 0})
	end
	e.config.ref_table.past_hover = e.states.hover.is
end

function G.FUNCS.fac_fas_tsunderfish_button (e)
	local card = G.fac_fas_tsunderfish_ui.config.major
	G.fac_fas_tsunderfish_ui:remove()
	G.fac_fas_check = nil
	G.fac_fas_flirt = nil
	G.fac_fas_approach = nil
	card.ability.immutable.option = e.config.ref_table.option
	local progress = {2, 2, 3, 2, 2, 3}
	local do_progress
	G.fac_fas_tsunderfish_ui = FishAndChips.FooSqueax.tsunderfish.create_act_uibox(card)
	if progress[card.ability.immutable.progress] == card.ability.immutable.option then
		card.ability.immutable.progress = card.ability.immutable.progress + 1
		do_progress = true
		if card.ability.immutable.progress > #progress then
			card.ability.immutable.active = true
			G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra.selection
			G.GAME.starting_params.play_limit = G.GAME.starting_params.play_limit + card.ability.extra.selection
			G.GAME.starting_params.discard_limit = G.GAME.starting_params.discard_limit + card.ability.extra.selection
		end
	end
	card.ability.immutable.result = card.ability.immutable.option == 1 and 0 or do_progress and 1 or 2 -- check, success, failure
	G.fac_fas_tsunderfish_ui:remove()
	G.fac_fas_tsunderfish_ui = FishAndChips.FooSqueax.tsunderfish.create_act_uibox(card)
	delay(14)
	G.E_MANAGER:add_event(Event{
		func = function()
			card.ability.immutable.result = nil
			G.fac_fas_tsunderfish_ui:remove()
			G.fac_fas_tsunderfish_ui = nil
			if card.ability.immutable.active == true then
				SMODS.calculate_effect({message = localize("ph_fac_fas_tsunderfish_active")}, card)
			end
			return true
		end
	})
end

function FishAndChips.FooSqueax.tsunderfish.create_act_uibox (card)
	local state = card.ability.immutable
	local added_ui
	if state.result then
		local key
		if state.result == 0 then key = "check"
		elseif state.result == 2 then key = "fail_" .. pseudorandom_element({"a", "b", "c", "d"}, "fac_fas_tsunderfish_failure")
		elseif state.result == 1 then
			if state.option == 2 then key = "approach_" .. ({nil, "a", "b", nil, "c", "d"})[state.progress]
			elseif state.option == 3 then key = "flirt_" .. pseudorandom_element({"a", "b", "c", "d"}, "fac_fas_tsunderfish_flirt") end
		end
		added_ui = {
			{n = G.UIT.R, nodes = {
				{n = G.UIT.O, config = {object = 
					DynaText{
						string = {localize("ph_fac_fas_tsunderfish_" .. key .. "_1")},
						colours = {G.C.WHITE},
						pop_in = 1,
						bump_amount = 0,
						scale = 0.5,
					}
				}}
			}},
			{n = G.UIT.R, nodes = {
				{n = G.UIT.O, config = {object = 
					DynaText{
						string = {localize("ph_fac_fas_tsunderfish_" .. key .. "_2")},
						colours = {G.C.WHITE},
						pop_in = 1,
						bump_amount = 0,
						scale = 0.5,
					}
				}}
			}},
			key == "check" and {n = G.UIT.R, nodes = {
				{n = G.UIT.O, config = {object = 
					DynaText{
						string = {localize("ph_fac_fas_tsunderfish_" .. key .. "_3")},
						colours = {G.C.WHITE},
						pop_in = 1,
						bump_amount = 0,
						scale = 0.5,
					}
				}}
			}} or nil
		}
	elseif state.option == 0 then
		G.fac_fas_check = SMODS.create_sprite(0, 0, 0.3, 0.3, "fac_fas_icons")
		G.fac_fas_flirt = SMODS.create_sprite(0, 0, 0.3, 0.3, "fac_fas_icons")
		G.fac_fas_approach = SMODS.create_sprite(0, 0, 0.3, 0.3, "fac_fas_icons")
		added_ui = {
			{n = G.UIT.C, config = {minw = 2.4, minh = 2.2, align = "tl"}, nodes = {
				{n = G.UIT.R, config = {minw = 2.4, minh = 1, align = "cl", button_dist = 0, fac_ignore = true, func = "fac_fas_tsunderfish_update", button = "fac_fas_tsunderfish_button", ref_table = {option = 1, name = "check"}}, nodes = {
					{n = G.UIT.C, config = {align = "cm", minw = 0.3, minh = 0.3}, nodes = {
						{n = G.UIT.O, config = {object = G.fac_fas_check}}
					}},
					{n = G.UIT.C, nodes = {
						{n = G.UIT.B, config = {w = 0.1, h = 0.1}}
					}},
					{n = G.UIT.C, config = {align = "tl"}, nodes = {
						{n = G.UIT.T, config = {text = localize("k_fac_fas_check"), colour = G.C.WHITE, scale = 0.5}}
					}}
				}},
				{n = G.UIT.R, nodes = {
					{n = G.UIT.B, config = {w = 0.2, h = 0.2}}
				}},
				{n = G.UIT.R, config = {minw = 2.4, minh = 1, align = "cl", button_dist = 0, fac_ignore = true, func = "fac_fas_tsunderfish_update", button = "fac_fas_tsunderfish_button", ref_table = {option = 2, name = "approach"}}, nodes = {
					{n = G.UIT.C, config = {align = "cm", minw = 0.3, minh = 0.3}, nodes = {
						{n = G.UIT.O, config = {object = G.fac_fas_approach}}
					}},
					{n = G.UIT.C, nodes = {
						{n = G.UIT.B, config = {w = 0.1, h = 0.1}}
					}},
					{n = G.UIT.C, config = {align = "tl"}, nodes = {
						{n = G.UIT.T, config = {text = localize("k_fac_fas_approach"), colour = G.C.WHITE, scale = 0.5}}
					}}
				}}
			}},
			{n = G.UIT.C, nodes = {
				{n = G.UIT.B, config = {w = 0.2, h = 0.2}},
			}},
			{n = G.UIT.C, config = {minw = 2.4, minh = 2.2, align = "tl"}, nodes = {
				{n = G.UIT.R, config = {minw = 2.4, minh = 1, align = "cl", button_dist = 0, fac_ignore = true, func = "fac_fas_tsunderfish_update", button = "fac_fas_tsunderfish_button", ref_table = {option = 3, name = "flirt"}}, nodes = {
					{n = G.UIT.C, config = {align = "cm", minw = 0.3, minh = 0.3}, nodes = {
						{n = G.UIT.O, config = {object = G.fac_fas_flirt}}
					}},
					{n = G.UIT.C, nodes = {
						{n = G.UIT.B, config = {w = 0.1, h = 0.1}}
					}},
					{n = G.UIT.C, config = {align = "tl"}, nodes = {
						{n = G.UIT.T, config = {text = localize("k_fac_fas_flirt"), colour = G.C.WHITE, scale = 0.5}}
					}}
				}}
			}}
		}
	elseif state.option == 1 then
		-- unused inbetween dialogue
	end
	local base_ui = {n = G.UIT.ROOT, config = {minw = 7.5, minh = 3, colour = FishAndChips.C.FooSqueax.BLACK, padding = 0.1, align = "cm"}, nodes = {
		{n = G.UIT.R, config = {minw = 7.3, minh = 2.8, colour = G.C.WHITE, padding = 0.1, align = "cm"}, nodes = {
			{n = G.UIT.R, config = {minw = 7.1, minh = 2.6, colour = FishAndChips.C.FooSqueax.BLACK, align = "tl", padding = 0.1}, nodes = added_ui}
		}}
	}}
	return UIBox{
		definition = base_ui,
		config = {
			major = card,
			r_bond = "Weak",
			align = "tm",
			instance_type = "CARD"
		}
	}
end