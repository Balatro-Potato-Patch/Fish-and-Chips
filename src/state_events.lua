G.STATES.FAC_FISHING = 1521566585389584465

G.FISHING_STATES = {
	SETUP = 0,

	LOBBY = 1,
	MOVING = 2,
	CASTING = 3,
	WAITING = 4,
	HOOKED = 5,
	HOOKING = 6,
	RESULTS = 7,

	LEAVING = 20,
}

local g_update_ref = Game.update
---@diagnostic disable-next-line: duplicate-set-field
function Game:update(dt)
	g_update_ref(self, dt)

	-- shader fish logic

	--if pseudorandom("fac_shader_rotate") < 0.1 then
		--print("rotate")
		--FishAndChips.mod_badge.vr = FishAndChips.mod_badge.vr + math.sin(G.TIMERS.REAL) / 50--(pseudorandom("fac_shader_rotate_ar") - 0.5) / 50
	--end
	--FishAndChips.mod_badge.vr = FishAndChips.mod_badge.vr * 0.99

	--FishAndChips.mod_badge.vr = math.min(math.max(FishAndChips.mod_badge.vr, -3), 3)
	--FishAndChips.mod_badge.r = G.TIMERS.REAL / 10 --FishAndChips.mod_badge.r + FishAndChips.mod_badge.vr / 180 * math.pi
	--FishAndChips.mod_badge.r = math.max(math.min(FishAndChips.mod_badge.r, math.pi * 5 / 4), math.pi * 3 / 4)

	FishAndChips.mod_badge.cr = math.cos(-FishAndChips.mod_badge.r)
	FishAndChips.mod_badge.sr = math.sin(-FishAndChips.mod_badge.r)

	local vel = -20 * dt
	FishAndChips.mod_badge.x = FishAndChips.mod_badge.x + vel * math.cos(FishAndChips.mod_badge.r)
	FishAndChips.mod_badge.y = FishAndChips.mod_badge.y + vel * math.sin(FishAndChips.mod_badge.r)


	-- end shader fish logic

	if G.STATE == G.STATES.FAC_FISHING and not G.SETTINGS.paused then
		G:update_fac_fishing(dt)

		if G.FISHING_STATE == G.FISHING_STATES.LOBBY then
			G:update_fac_fishing_lobby(dt)
		end
		if G.FISHING_STATE == G.FISHING_STATES.MOVING then
			G:update_fac_fishing_moving(dt)
		end
		if G.FISHING_STATE == G.FISHING_STATES.CASTING then
			G:update_fac_fishing_casting(dt)
		end
		if G.FISHING_STATE == G.FISHING_STATES.WAITING then
			G:update_fac_fishing_waiting(dt)
		end
		if G.FISHING_STATE == G.FISHING_STATES.HOOKED then
			G:update_fac_fishing_hooked(dt)
		end
		if G.FISHING_STATE == G.FISHING_STATES.HOOKING then
			G:update_fac_fishing_hooking(dt)
		end
		if G.FISHING_STATE == G.FISHING_STATES.RESULTS then
			G:update_fac_fishing_results(dt)
		end
	else
		FishAndChips.stop_reel_sound()
	end

	FishAndChips.update_sound_volume()
end

function G:update_fac_fishing_moving(dt)
	if not G.FISHING_STATE_COMPLETE then
		G.FISHING_STATE_COMPLETE = true
		G.E_MANAGER:add_event(Event{
			trigger = 'immediate',
			func = function ()
				G.FISHING.fishing.alignment.offset.y = G.ROOM.T.y + 29
				return true
			end
		})
		G.E_MANAGER:add_event(Event{
			trigger = 'after',
			delay = 0.5,
			func = function()
				FishAndChips.create_fishing_UI()
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						G.FISHING.fishing.alignment.offset.y = 0
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED),
							blockable = false,
							blocking = false,
							func = function()
								FishAndChips.fishing_card_setup()
								return true
							end,
						}))
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.5,
							func = function()
								-- controller stuff
								return true
							end,
						}))
						return true
					end,
				}))
				return true
			end
		})
	end
end
--[[
function G:update_fac_fishing_lobby(dt)
	if not G.FISHING_STATE_COMPLETE then
		G.FISHING_STATE_COMPLETE = true
	end
end
function G:update_fac_fishing_casting(dt)
	if not G.FISHING_STATE_COMPLETE then
		G.FISHING_STATE_COMPLETE = true
	end
end
function G:update_fac_fishing_waiting(dt)
	if not G.FISHING_STATE_COMPLETE then
		G.FISHING_STATE_COMPLETE = true
	end
end
function G:update_fac_fishing_hooked(dt)
	if not G.FISHING_STATE_COMPLETE then
		G.FISHING_STATE_COMPLETE = true
	end
end
function G:update_fac_fishing_hooking(dt)
	if not G.FISHING_STATE_COMPLETE then
		G.FISHING_STATE_COMPLETE = true
	end
end
function G:update_fac_fishing_results(dt)
	if not G.FISHING_STATE_COMPLETE then
		G.FISHING_STATE_COMPLETE = true
	end
end
--]] -- defined in fishminigamemechanics.lua

function FishAndChips.fishing_card_setup()
	G.FISHING_STATE = G.FISHING_STATES.LOBBY
	G.FISHING_STATE_COMPLETE = false
end

function FishAndChips.create_fishing_UI()
	for _, item in pairs(G.FISHING or {}) do
		if item.remove then item:remove() end
	end
	G.FISHING = {}
	G.FAC_JIMBO_ANIMATION_STATE = nil
	G.NOT_SAFE_TO_PRESS_BUTTONS = false
	G.FISHING.fishing = UIBox({
		definition = G.UIDEF.fac_fishing(),
		config = {
			align = "cmi",
			offset = { x = 0, y = G.ROOM_ATTACH.T.h + 5 },
			major = G.ROOM_ATTACH,
			bond = "Weak",
		},
	})

	FishAndChips.get_environment():generate_ui()

	
	G.FISHING.fishing_buttons = UIBox({
		definition = G.UIDEF.fac_fishing_buttons(),
		config = {
			align = "cri",
			offset = { x = -0.5, y = -1 },
			major = G.FISHING.fishing,
			bond = "Glued",
		},
	})
	G.FISHING.fishing_area_display = UIBox({
		definition = G.UIDEF.fac_fishing_area_display(),
		config = {
			align = "tli",
			offset = { x = 0.5, y = 0.225 },
			major = G.FISHING.fishing,
			bond = "Glued",
		},
	})

	G.FISHING.fishing_bait_inventory = UIBox({
		definition = G.UIDEF.fac_bait_inventory_button(),
		config = {
			align = "bm",
			offset = { x = 0, y = 0.1 },
			major = G.fac_bait_area,
			bond = "Glued",
		},
	})

	if G.GAME.fac_active_bait then
		FishAndChips.update_bait_counter(G.fac_bait_area.cards[1])
	end

	G.FISHING.fac_fish_reward_area = CardArea(0, 0, G.CARD_W, G.CARD_H, {
		type = "joker",
		highlight_limit = 0,
		highlighted_limit = 0,
		align_buttons = true,
		bg_colour = G.C.CLEAR,
		no_card_count = true,
	})
	G.FISHING.fac_fishing_reward_box = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = { colour = G.C.CLEAR },
			nodes = {
				{ n = G.UIT.O, config = { object = G.FISHING.fac_fish_reward_area } },
			},
		},
		config = {
			align = "cmi",
			offset = { x = 0, y = 0 },
			major = G.FISHING.fishing,
			bond = "Glued",
		},
	})

	G.FISHING.fac_treasure_reward_area = CardArea(0, 0, G.CARD_W, G.CARD_H, {
		type = "joker",
		highlight_limit = 0,
		highlighted_limit = 0,
		align_buttons = true,
		bg_colour = G.C.CLEAR,
		no_card_count = true,
	})
	G.FISHING.fac_treasure_reward_box = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = { colour = G.C.CLEAR },
			nodes = {
				{ n = G.UIT.O, config = { object = G.FISHING.fac_treasure_reward_area } },
			},
		},
		config = {
			align = "cmi",
			offset = { x = -3.5, y = 0 },
			major = G.FISHING.fishing,
			bond = "Glued",
		},
	})

	for index = 1, 2 do
		local status = UIBox({
			T = { x = 0, y = 0 },
			definition = G.UIDEF.fac_fishing_status(index),
			config = {
				align = "a",
				can_collide = false,
			},
		})
		G.FISHING["fishing_status_" .. index] = status
		for ui_index, box in ipairs(G.I.UIBOX) do
			if box == status then
				table.remove(G.I.UIBOX, ui_index)
				break
			end
		end
	end

	FishAndChips.update_jimbo_state(FishAndChips.JIMBO_ANIMATION_STATES.IDLE)

	-- move fishing ui behind hud ui
	for index, box in ipairs(G.I.UIBOX) do
		if box == G.FISHING.fishing then
			table.remove(G.I.UIBOX, index)
			break
		end
	end
	for index, box in ipairs(G.I.UIBOX) do
		if box == G.HUD then
			table.insert(G.I.UIBOX, index, G.FISHING.fishing)
			break
		end
	end
end

function G:update_fac_fishing(dt)
	if G.buttons then
		self.buttons:remove()
		self.buttons = nil
	end
	if G.shop then
		G.shop.alignment.offset.y = G.ROOM.T.y + 11
	end
	if not G.STATE_COMPLETE then
		G.FISHING_STATE = G.FISHING_STATES.SETUP
		G.FISHING_STATE_COMPLETE = true
		G.STATE_COMPLETE = true
		G.CONTROLLER.interrupt.focus = true
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				
				FishAndChips.create_fishing_UI()

				-- move 
				G.deck.T.y = G.deck.T.y + 10
				G.hand.T.y = G.hand.T.y + 10
				G.jokers.T.y = G.jokers.T.y - 10
				G.consumeables.T.y = G.consumeables.T.y - 10
				G.fac_fishing_bucket_bottom.alignment.offset.y = -0.2
				G.fac_fishing_bucket_bottom.alignment.offset.x = -0.8
				G.fac_rod_area.T.y = G.fac_rod_area.T.y + 10
				G.fac_bait_area.T.y = G.fac_bait_area.T.y + 10
				-- revert this when done fishing

				--other ui setup goes here
				G.ROOM.jiggle = G.ROOM.jiggle + 3
				ease_colour(G.C.DYN_UI.MAIN, G.C.BLUE)
				ease_background_colour({ new_colour = G.C.BLUE, special_colour = G.C.L_BLACK, contrast = 1.5 })
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						G.FISHING.fishing.alignment.offset.y = 0
						ease_value(G.HUD.alignment.offset, "x", -10) -- for some reason this value changes instantly unlike others
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 1.3 * math.sqrt(G.SETTINGS.GAMESPEED),
							blockable = false,
							blocking = false,
							func = function()
								FishAndChips.fishing_card_setup()
								FishAndChips.tutorial()
								-- card setup goes here
								return true
							end,
						}))
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.5,
							func = function()
								-- controller stuff
								return true
							end,
						}))
						return true
					end,
				}))
				return true
			end,
		}))
	end
end

---any additional changes to the hands position
---@param offset? integer change the intial offset from 0
---@return integer
function FishAndChips.hand_offset(offset)
	offset = offset or 0
	if not G.deck_preview and G.GAME.fac_fish_expanded then
		offset = offset + 5
	end
	if G.fac_fish_area then
		if G.hand and G.hand.cards and #G.hand.cards > 0 and G.STATE ~= G.STATES.TAROT_PACK and G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED then
			for _, card in ipairs(G.fac_fish_area.highlighted) do
				if card.config.center.requires_hand then
					offset = offset - 3
					break
				end
			end
		end
	end
	return offset
end
