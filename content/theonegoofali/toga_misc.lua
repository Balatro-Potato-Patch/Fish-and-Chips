-- No achievements? At least show something for all those clicks.
function G.FUNCS.fac_toga_close_main(e)
	FishAndChips.toga_oopsnothing2()
end

function G.FUNCS.fac_toga_close_real(e)
	if G.ACTIVE_MOD_UI and G.ACTIVE_MOD_UI.id == 'FishAndChips' then G.FUNCS.openModUI_FishAndChips() else G.FUNCS.exit_overlay_menu() end
end

function FishAndChips.toga_oopsnothinguidef()
	local rtxt = G.localization.misc.ui_strings.fac_toga_oopsnothing
	return { n = G.UIT.ROOT, config = { align = "cm", colour = {0,0,0,0.8}, padding = 32.01, r = 0.1, minw = 5, id = 'fac_toga_oopsnothing'}, nodes = {
		{n = G.UIT.C, config = { align = "cl", outline = 1, outline_colour = HEX('C3C3C3'), colour = G.C.UI.BACKGROUND_INACTIVE, padding = 0.035 }, nodes = {
			{n = G.UIT.R, config = {align = "cl", colour = HEX('000082'), minw = 5}, nodes = {
				{n = G.UIT.C, config = { align = "cl", padding = 0.1 }, nodes = {
					{n = G.UIT.T, config = { text = rtxt[1], scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
				}},
			}},
			{n = G.UIT.R, config = { align = "cl", minw = 5 }, nodes = {
				{n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {
					{n = G.UIT.O, config = { w = 1, h = 1, object = SMODS.create_sprite(0, 0, 0.8*1, 0.8*1, SMODS.get_atlas('fac_modicon')) } },
				}},
				{n = G.UIT.C, config = { align = "cl", padding = -0.05}, nodes = {
					{n = G.UIT.R, config = { align = "cl", padding = 0.2 }, nodes = {
						{n = G.UIT.R, config = { align = "cl", padding = -0.05 }, nodes = {
							{n = G.UIT.T, config = { text = rtxt[2], scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
						}},
					}},
				}},
			}},
			{n = G.UIT.R, config = {align = "cm", colour = HEX('c0c0c0'), padding = 0.15}, nodes = {
				{n = G.UIT.C, config = { align = "cm" }, nodes = {
					UIBox_button({label = { localize('fac_toga_ok') }, button = "fac_toga_close_main", minw = 2, minh = 0.65, colour = HEX('555555')})
				}},
			}},
		}},
	}}
end

function FishAndChips.toga_oopsnothing2uidef()
	local rtxt = G.localization.misc.ui_strings.fac_toga_oopsnothing2
	return { n = G.UIT.ROOT, config = { align = "cm", colour = {0,0,0,0.8}, padding = 32.01, r = 0.1, minw = 5, id = 'fac_toga_oopsnothing'}, nodes = {
		{n = G.UIT.C, config = { align = "cl", outline = 1, outline_colour = HEX('C3C3C3'), colour = G.C.UI.BACKGROUND_INACTIVE, padding = 0.035 }, nodes = {
			{n = G.UIT.R, config = {align = "cl", colour = HEX('000082'), minw = 5}, nodes = {
				{n = G.UIT.C, config = { align = "cl", padding = 0.1 }, nodes = {
					{n = G.UIT.T, config = { text = rtxt[1], scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
				}},
			}},
			{n = G.UIT.R, config = { align = "cl", minw = 5 }, nodes = {
				{n = G.UIT.C, config = { align = "tl", padding = 0.05 }, nodes = {
					{n = G.UIT.O, config = { w = 1, h = 1, object = SMODS.create_sprite(0, 0, 0.8*1, 0.8*1, SMODS.get_atlas('fac_modicon')) } },
				}},
				{n = G.UIT.C, config = { align = "cl", padding = -0.05}, nodes = {
					{n = G.UIT.R, config = { align = "cl", padding = 0.2 }, nodes = {
						{n = G.UIT.R, config = { align = "cl", padding = -0.05 }, nodes = {
							{n = G.UIT.T, config = { text = rtxt[2], scale = 0.5, colour = G.C.UI.TEXT_LIGHT }},
						}},
					}},
				}},
			}},
			{n = G.UIT.R, config = {align = "cm", colour = HEX('c0c0c0'), padding = 0.15}, nodes = {
				{n = G.UIT.C, config = { align = "cm" }, nodes = {
					UIBox_button({label = { localize('fac_toga_ok') }, button = "fac_toga_close_real", minw = 2, minh = 0.65, colour = HEX('555555')})
				}},
			}},
		}},
	}}
end

local node_click_ref = Node.click
function Node:click()
	node_click_ref(self)
	if FishAndChips and type(FishAndChips.toga_updateclick) == 'function' then
		FishAndChips.toga_updateclick(self)
	end
end

local clickcount, hastriggered = 0, false
function FishAndChips.toga_updateclick(self)
	if self and self.ppu_member and not hastriggered then
		clickcount = (clickcount or 0) + 1
		if clickcount >= 1337 then
			hastriggered = true
			FishAndChips.toga_oopsnothing()
			sendInfoMessage("54 68 65 20 45 61 73 74 65 72 20 45 67 67 20 77 61 73 20 74 72 69 67 67 65 72 65 64 2e", "Fish and Chips - TheOneGoofAli")
			sendInfoMessage("54 68 61 6e 6b 73 20 66 6f 72 20 70 6c 61 79 69 6e 67 20 46 69 73 68 20 61 6e 64 20 43 68 69 70 73 21", "Fish and Chips - TheOneGoofAli")
		end
	end
end

FishAndChips.toga_hasshown = { false, false }
function FishAndChips.toga_oopsnothing()
	if not FishAndChips.toga_hasshown[1] then
		FishAndChips.toga_hasshown[1] = true
		if love.audio then love.audio.stop() end
		G.SETTINGS.paused = true
		G.FUNCS.overlay_menu({
			definition = FishAndChips.toga_oopsnothinguidef(),
			config = {
				align = "cm",
				offset = {x = 0, y = 0},
				bond = 'Weak',
				no_esc = true,
				no_back = true,
			}
		})
		play_sound('fac_toga_spidersolitairehint', 1, 0.5)
	end
end

function FishAndChips.toga_oopsnothing2()
	if not FishAndChips.toga_hasshown[2] and FishAndChips.toga_hasshown[1] then
		FishAndChips.toga_hasshown[2] = true
		G.SETTINGS.paused = true
		G.FUNCS.overlay_menu({
			definition = FishAndChips.toga_oopsnothing2uidef(),
			config = {
				align = "cm",
				offset = {x = 0, y = 0},
				bond = 'Weak',
				no_esc = true,
				no_back = true,
			}
		})
		play_sound('fac_toga_spidersolitairehint', 1, 0.5)
		FishAndChips.toga_fakeachievement()
	end
end

-- Achievemen't.
local function factogafakeachievementuibox()
	local _atlas = SMODS.get_atlas('fac_modicon')
	local t_s =  SMODS.create_sprite(0, 0, 1.5*(_atlas.px/_atlas.py), 1.5, _atlas.key or _atlas.name, {x = 0, y = 0})

	t_s.states.drag.can = false
	t_s.states.hover.can = false
	t_s.states.collide.can = false

	local name, subtext, unlock = localize("fac_toga_fakechievement_name") or 'ERROR', localize("fac_toga_fakechievement_txt") or 'ERROR', localize("fac_toga_fakechievement_unlocked") or 'ERROR'

	local t = {n=G.UIT.ROOT, config = {align = 'cl', r = 0.1, padding = 0.06, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
		{n=G.UIT.R, config={align = "cl", padding = 0.2, minw = 20, r = 0.1, colour = G.C.BLACK, outline = 1.5, outline_colour = G.C.GREY}, nodes={
			{n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
				{n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
					{n=G.UIT.O, config={object = t_s}},
				}},
				{n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
					{n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
						{n=G.UIT.T, config={text = name, scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
					}},
					{n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
						{n=G.UIT.T, config={text = subtext, scale = 0.35, colour = G.C.FILTER, shadow = true}},
					}},
					{n=G.UIT.R, config={align = "cm", maxw = 3.4, padding = 0.1}, nodes={
						{n=G.UIT.T, config={text = unlock, scale = 0.35, colour = G.C.FILTER, shadow = true}},
					}},
				}}
			}}
		}}
	}}
	return t
end

function FishAndChips.toga_fakeachievement()
	G.E_MANAGER:add_event(Event({
		no_delete = true,
		pause_force = true,
		timer = 'UPTIME',
		func = function()
			if G.achievement_notification then
				G.achievement_notification:remove()
				G.achievement_notification = nil
			end
			G.achievement_notification = G.achievement_notification or UIBox{
				definition = factogafakeachievementuibox(),
				config = {align='cr', offset = {x=20,y=0},major = G.ROOM_ATTACH, bond = 'Weak'}
			}
			return true
		end
	}), 'achievement')
	G.E_MANAGER:add_event(Event({
		no_delete = true,
		trigger = 'after',
		pause_force = true,
		timer = 'UPTIME',
		delay = 0.1,
		func = function()
			G.achievement_notification.alignment.offset.x = G.ROOM.T.x - G.achievement_notification.UIRoot.children[1].children[1].T.w - 0.8
			return true
		end
	}), 'achievement')
	G.E_MANAGER:add_event(Event({
		no_delete = true,
		pause_force = true,
		trigger = 'after',
		timer = 'UPTIME',
		delay = 0.1,
		func = function()
			play_sound('highlight1', nil, 0.5)
			play_sound('foil2', 0.5, 0.4)
			play_sound('fac_toga_sonicspecialtext', nil, 0.35)
			return true
		end
	}), 'achievement')
	G.E_MANAGER:add_event(Event({
		no_delete = true,
		pause_force = true,
		trigger = 'after',
		delay = 5.1,
		timer = 'UPTIME',
		func = function()
			G.achievement_notification.alignment.offset.x = 20
			return true
		end
	}), 'achievement')
	G.E_MANAGER:add_event(Event({
		no_delete = true,
		pause_force = true,
		trigger = 'after',
		delay = 0.5,
		timer = 'UPTIME',
		func = function()
			if G.achievement_notification then
				G.achievement_notification:remove()
				G.achievement_notification = nil
			end
			return true
		end
	}), 'achievement')
end