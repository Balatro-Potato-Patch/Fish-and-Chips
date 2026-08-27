function FishAndChips.mod.custom_card_areas(game)
	game.fac_rod_area = CardArea(G.ROOM_ATTACH.T.x + 0.5 + 6 + 0.5 , G.ROOM_ATTACH.T.y - 10 + 0.3, G.CARD_W, G.CARD_H, {
		card_limit = 1,
		type = "joker",
		highlight_limit = 0,
		highlighted_limit = 0,
		align_buttons = true,
		no_card_count = true
	})
	game.fac_bait_area = CardArea(G.ROOM_ATTACH.T.x + 0.5 + 6 + 0.5 + G.CARD_W + 0.2 , G.ROOM_ATTACH.T.y - 10 + 0.3, G.CARD_W, G.CARD_H, {
		card_limit = 1,
		type = "joker",
		highlight_limit = 0,
		highlighted_limit = 0,
		align_buttons = true,
		no_card_count = true
	})
	game.fac_fish_area = CardArea(0, 0, G.CARD_W + 0.1, G.CARD_H, {
		card_limit = 5,
		type = "joker",
		highlight_limit = 1,
		highlighted_limit = 1,
		align_buttons = true
	})
	getmetatable(game.fac_fish_area.config).__index = function(t, key)
		if key == "card_limit" then
			return (t.card_limits.total_slots or 0) - (t.card_limits.extra_slots_used or 0) - (t.buffer or 0)
		end
	end
	game.fac_fish_area.load = function(self, cat)
		CardArea.load(self, cat)
		getmetatable(game.fac_fish_area.config).__index = function(t, key)
			if key == "card_limit" then
				return (t.card_limits.total_slots or 0) - (t.card_limits.extra_slots_used or 0) - (t.buffer or 0)
			end
		end
	end
	game.fac_fish_area.buffer = function(self, value, event)
		if event then
			event = type(event) == 'table' and event or {}
			G.E_MANAGER:add_event(Event({
				trigger = event.trigger or 'immediate', delay = event.delay or 0,
				func = function()
					self.config.buffer = (self.config.buffer or 0) + value
					return true
				end
			}))
		else
			self.config.buffer = (self.config.buffer or 0) + value
		end
	end
	game.fac_fish_area.has_space = function(self, value)
		value = value or 1
		return #self.cards + value <= self.config.card_limit
	end
	game.fac_fishing_bucket_bottom = UIBox({
		definition = G.UIDEF.fac_fishing_bucket_bottom(),
		config = {
			align = "bri",
			offset = { x = -0.3, y = -0.5 - G.CARD_H },
			major = G.ROOM_ATTACH,
			bond = "Weak",
			instance_type = "CARD"
		},
	})
	game.fac_fishing_bucket_cards = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = { colour = G.C.CLEAR },
			nodes = {
				{ n = G.UIT.O, config = { object = game.fac_fish_area } },
			},
		},
		config = {
			align = "tmi",
			offset = { x = 0, y = 0 },
			major = G.fac_fishing_bucket_bottom,
			bond = "Glued",
			instance_type = "CARD",
		},
	})
	game.fac_fishing_bucket_top = UIBox({
		definition = G.UIDEF.fac_fishing_bucket_top(),
		config = {
			align = "tmi",
			offset = { x = 0, y = 0 },
			major = G.fac_fishing_bucket_cards,
			bond = "Glued",
			instance_type = "CARD",
		},
	})
	local card_count_table = setmetatable({}, {
		__index = function (t, k)
			if k == "card_count" then return G.fac_fish_area.config.card_count
			elseif k == "total_slots" then return G.fac_fish_area.config.card_limits.total_slots
			else error("what are you doing") end
		end
	})
	game.fac_fishing_bucket_card_count = UIBox({
		definition = {n = G.UIT.ROOT, config = {padding = 0.03, colour = G.C.CLEAR}, nodes = {
			{n=G.UIT.B, config={w = 0.1,h=0.1}},
			{n=G.UIT.T, config={ref_table = card_count_table, ref_value = 'card_count', scale = 0.3, colour = G.C.WHITE}},
			{n=G.UIT.T, config={text = '/', scale = 0.3, colour = G.C.WHITE}},
			{n=G.UIT.T, config={ref_table = card_count_table, ref_value = 'total_slots', scale = 0.3, colour = G.C.WHITE}},
			{n=G.UIT.B, config={w = 0.1,h=0.1}}
		}},
		config = {
			align = "bm",
			offset = { x = 0, y = -0.1 },
			major = G.fac_fishing_bucket_top,
			bond = "Glued",
			xy_bond = "Strong",
			r_bond = "Weak",
			instance_type = "CARD",
		},
	})
end

function FishAndChips.mod.reset_game_globals (run_start)
	if run_start then
		G.GAME.fac_fishing_environment = not G.PROFILES[G.SETTINGS.profile].fac_tutorial_seen and "calm_pond" or pseudorandom_element(FishAndChips.create_env_pool(), "fac_starting_location")
		G.GAME.fac_envs_used[G.GAME.fac_fishing_environment] = G.GAME.fac_envs_used[G.GAME.fac_fishing_environment] + 1
		G.GAME.fac_environment_reroll_cost = 5
		G.FUNCS.fac_set_active_bait({ config = { key = 'bait_fac_normal' } })
		G.GAME.fac_bucket_price = 10
		G.GAME.fac_upgrade_text = localize{type = "variable", key = "ph_fac_upgrade_increase", vars = {G.fac_fish_area.config.card_limits.base, G.fac_fish_area.config.card_limits.base + 1}}
	end
end

FishAndChips.mod.calculate = function(self, context)
	if context.end_of_round and context.main_eval and not context.game_over then
		local amt = pseudorandom("fac_bait_gen" .. G.GAME.round_resets.ante, 2, 5)
		for _ = 1, amt do
			FishAndChips.add_bait_to_shop(SMODS.poll_object({ type = "fac_Bait", append = 'fac_bait_shop' }))
		end
		FishAndChips.add_bait_to_shop('bait_fac_normal', pseudorandom('fac_guaranteed_normal_bait' .. G.GAME.round_resets.ante, 1, 3))
	end
end

local function tally(pool)
	local obj_tally = {tally = 0, of = 0}

    for _, v in pairs(pool) do
        if (not v.no_collection or (type(v.no_collection) == 'function' and not v:no_collection())) then
                obj_tally.of = obj_tally.of+1
                if v.discovered then
                    obj_tally.tally = obj_tally.tally+1
                end
        end
    end

    return obj_tally
end

G.FUNCS.fac_mod_badge = function(e)
	if e.config.shader then return end
	e.config.shader = 'fac_mod_badge'
end

function FishAndChips.mod.custom_collection_tabs()
	return { 
		UIBox_button {
			button = "fac_your_collection_fish",
			label = { localize("b_fac_fish") },
			count = tally(G.P_CENTER_POOLS.fac_Fish),
			minw = 5,
			id = "fac_your_collection_fish",
			colour = FishAndChips.mod.badge_colour,
			text_colour = FishAndChips.mod.badge_text_colour,
			func = 'fac_mod_badge'
		},
		{n=G.UIT.R, nodes = {
			{n=G.UIT.R, config = {align = 'cm', minh = 0.9}, nodes = {
				UIBox_button {
					button = "fac_your_collection_rods",
					label = { localize("b_fac_rod") },
					count = tally(G.P_CENTER_POOLS.fac_Rod),
					minw = 2.425,
					id = "fac_your_collection_rods",
					colour = FishAndChips.mod.badge_colour,
					text_colour = FishAndChips.mod.badge_text_colour,
					func = 'fac_mod_badge',
					col = true
				},
				{n=G.UIT.C, config = {minw = 0.15}},
				UIBox_button {
					button = "fac_your_collection_bait",
					label = { localize("b_fac_bait") },
					count = tally(G.P_CENTER_POOLS.fac_Bait),
					minw = 2.425,
					id = "fac_your_collection_bait",
					colour = FishAndChips.mod.badge_colour,
					text_colour = FishAndChips.mod.badge_text_colour,
					func = 'fac_mod_badge',
					col = true
				}
			}}
		}},
	}
end

local showman_hook = SMODS.showman
function SMODS.showman(card_key)
	if G.P_CENTERS[card_key].set == "fac_Bait" then
		return true
	end
	if G.P_CENTERS[card_key].set == "fac_Fish" then
		return false
	end
	return showman_hook(card_key)
end

SMODS.RunSelectPage({
	key = 'rod_choice',
	generate_pool = function() return G.P_CENTER_POOLS.fac_Rod end,
	grid_size = {2, 4},
	automatic_preview = true,
	random_select = true,
	quick_start_text = function()
		if not G.PROFILES[G.SETTINGS.profile].last_choices.fac_rod_choice then return end
		local choice = G.PROFILES[G.SETTINGS.profile].last_choices.fac_rod_choice
		choice = G.P_CENTERS[choice].unlocked and choice or 'rod_fac_wooden'
		G.PROFILES[G.SETTINGS.profile].last_choices.fac_rod_choice = choice
		return localize({type = 'name_text', set = 'fac_Rod', key = G.PROFILES[G.SETTINGS.profile].last_choices.fac_rod_choice})
	end,
	selected_text = function(self, selection)
		if not selection then return end
		return localize({set = 'fac_Rod', key = SMODS.RunSelect.Setup.choices[self.key], type = 'name_text'})
	end,
	start_run = function(self, choice)
		choice = G.P_CENTERS[choice].unlocked and choice or 'rod_fac_wooden'
		local rod = SMODS.add_card{area = G.fac_rod_area, key = choice}
		G.PROFILES[G.SETTINGS.profile].fac_fishing.rod_data[choice] = G.PROFILES[G.SETTINGS.profile].fac_fishing.rod_data[choice] or {
			fish_caught = 0,
			fish_lost = 0,
			perfect_catch = 0,
			treasure = 0
		}
		if rod.config.center.apply and type(rod.config.center.apply) == 'function' then
			rod.config.center:apply(rod)
		end
	end,
	set_default = function(self, choice)
		return choice and G.P_CENTERS[choice].unlocked and choice or 'rod_fac_wooden'
	end,
})

FishAndChips.mod.menu_cards = function()
	if FishAndChips.mod.config.menu then
		return {
			remove_original = true,
			{ key = 'fish_fac_splash_screen' }
		}
	else
		return { func = function() return end }
	end
end

function FishAndChips.create_baits_from_card(card, amt, key)
	local w = (G.CARD_W + 0.1) * amt - 0.1
	local h = G.CARD_H
	local created_bait = {}
	delay(1)
	for i = 1, amt do
		G.E_MANAGER:add_event(Event {
			func = function()
				local _card = SMODS.create_card { set = "fac_Bait", key = key }
				if not G.fac_temp_bait_area then
					G.fac_temp_bait_area = CardArea(
						card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
						w, h,
						{
							type = "joker",
							card_limit = amt,
							highlight_limit = 1,
							highlighted_limit = 1,
							align_buttons = true,
							bg_colour = G.C.CLEAR,
							fixed_limit = true,
							no_card_count = true,
						}
					)
				end
				G.fac_temp_bait_area:emplace(_card)
				created_bait[#created_bait + 1] = _card
				FishAndChips.add_bait_to_inventory(_card.config.center.key)
				return true
			end
		})
		delay(0.2)
	end
	delay(1)
	for i = 1, amt do
		G.E_MANAGER:add_event(Event {
			func = function()
				created_bait[i]:start_dissolve()
				return true
			end
		})
		delay(0.2)
	end
	delay(0.5)
	G.E_MANAGER:add_event(Event {
		func = function()
			G.fac_temp_bait_area:remove()
			G.fac_temp_bait_area = nil
			return true
		end
	})
end
