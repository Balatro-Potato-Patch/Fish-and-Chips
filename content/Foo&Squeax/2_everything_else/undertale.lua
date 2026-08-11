FishAndChips.FooSqueax.undertale = {
	active = false,
	removing = false,
	UI = {},
	sprites = {},
	file_path = FishAndChips.FooSqueax.file_path .. "undertale/",
	OPTIONS = {
		foo = {
			{
				{"check", "check", "foo"},
				{"guest_dev", "foo_guest_dev"}
			},
			{
				{"projects", "options", "foo_projects"},
				{"colon_3", "foo_colon_3"}
			}
		},
		squeax = {
			{
				{"check", "check", "squeax"},
			}
		},
		foo_projects = {
			{
				{"worked_on", "nothing"},
				{"synthb", "link", "https://github.com/Foo54/SynthB"},
				{"bad_director", "link", "https://github.com/Foo54/BadDirectorReprinted"}
			}
		}
	}
}

SMODS.Atlas{
	key = "fas_undertale_background",
	path = FishAndChips.FooSqueax.undertale.file_path .. "background.png",
	px = 198,
	py = 238
}

SMODS.Atlas{
	key = "fas_undertale_tobysona",
	path = FishAndChips.FooSqueax.undertale.file_path .. "tobysona.png",
	px = 50,
	py = 48
}

SMODS.Atlas{
	key = "fas_undertale_icons",
	path = FishAndChips.FooSqueax.undertale.file_path .. "icons.png",
	px = 27,
	py = 38
}

SMODS.Sound{
	key = "fas_alert",
	path = FishAndChips.FooSqueax.file_path .. "snd_b.ogg"
}
SMODS.Sound{
	key = "fas_start",
	path = FishAndChips.FooSqueax.file_path .. "snd_battlefall.ogg"
}
SMODS.Sound{
	key = "fas_escape",
	path = FishAndChips.FooSqueax.file_path .. "snd_escaped.ogg"
}
SMODS.Sound{
	key = "fas_select",
	path = FishAndChips.FooSqueax.file_path .. "snd_select.ogg"
}
SMODS.Sound{
	key = "fas_spare",
	path = FishAndChips.FooSqueax.file_path .. "snd_vaporized.ogg"
}

function FishAndChips.FooSqueax.undertale:init(card)
	self.active = true
	self.UI = {}
	self.removing = true
	self.sprites = {}
	self:gogogadget_ui_blocker()
	self:draw_card(card)
	play_sound("fac_fas_alert")
	delay(0.8)
	G.E_MANAGER:add_event(Event{
		func = function ()
			self.area.cards[1].disable_align = true
			self.area.cards[1].T.y = 20
			play_sound("fac_fas_start")
			return true
		end
	})
	delay(0.05)
	G.E_MANAGER:add_event(Event{
		func = function ()
			self:main_ui()
			self.UI.card:remove()
			self.UI.card = nil
			self.area = nil
			self.removing = false
			return true
		end
	})
end

function FishAndChips.FooSqueax.undertale:draw_card(card)
	if self.UI.card then
		self.UI.card:remove()
	end
	self.area = CardArea(0, 0, card.T.w, card.T.h, {
		type = "title",
		highlight_limit = 1,
		background_colour = G.C.CLEAR,
		no_card_count = true,
		instance_type = "UNDERTALE"
	})
	local _card = copy_card(card)
	_card.children.front:remove()
	_card.children.front = nil
	_card.children.center:remove()
	_card.children.center = SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, "fac_fas_credits_foo", {x = 0, y = 0})
	_card.children.center:set_role({major = _card, role_type = 'Glued', draw_major = _card})
	_card.states.collide.can = false
	_card.states.hover.can = false
	self.area:emplace(_card)
	self.UI.card = UIBox{
		definition = {n = G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes = {
			{n = G.UIT.O, config = {object = self.area}}
		}},
		config = {
			align = "cmi",
			instance_type = "UNDERTALE",
			major = card
		}
	}
end

function FishAndChips.FooSqueax.undertale:gogogadget_ui_blocker()
	self.UI.ui_blocker = UIBox{
		definition = {n = G.UIT.ROOT, config = {minw = G.ROOM_ATTACH.T.w, minh = G.ROOM_ATTACH.T.h, colour = G.C.CLEAR}},
		config = {
			align = "cmi",
			major = G.ROOM_ATTACH,
			instance_type = "UNDERTALE"
		}
	}
end

function FishAndChips.FooSqueax.undertale:info(key, parent)
	if self.UI.text_box then
		self.UI.text_box:remove()
	end
	local text = copy_table(localize("k_fac_fas_undertale_textbox")[key])
	for i, line in ipairs(text) do
		text[i] = {n = G.UIT.R, config = {align = "tl"}, nodes = {
			line == "" and {n = G.UIT.B, config = {h = 0.5, w = 0.5}} or {n = G.UIT.O, config = {object = DynaText{
				string = {line},
				colours = {G.C.WHITE},
				pop_in = 0,
				pop_in_rate = 2,
				bump_amount = 0,
				scale = 0.5,
				silent = true
			}}}
		}}
	end
	self.UI.text_box = UIBox{
		definition = {n = G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes = text},
		config = {
			parent = parent,
			major = parent
		}
	}
	return self.UI.text_box
end

function FishAndChips.FooSqueax.undertale:options(columns, parent)
	if self.UI.text_box then
		self.UI.text_box:remove()
	end
	local nodes = {}
	local width = 14 / #columns
	for i, column in ipairs(columns) do
		local column_nodes = {}
		for _, row in ipairs(column) do
			local loc_key = "b_fac_fas_undertale_" .. row[1]
			local sprite = SMODS.create_sprite(0, 0, 0.6, 0.6, "fac_fas_icons")
			column_nodes[#column_nodes + 1] = {n = G.UIT.R, config = {minw = width, button_dist = 0, func = "fac_fas_undertale_options_update", button = "fac_fas_undertale_options_button", ref_table = {
				sprite = sprite,
				loc_key = loc_key,
				type = row[2],
				extra = row[3]
			}}, nodes = {
				{n = G.UIT.O, config = {object = sprite}},
				{n = G.UIT.O, config = {object = DynaText{
					string = {localize(loc_key)},
					colours = {G.C.WHITE},
					pop_in = 0,
					pop_in_rate = 2,
					bump_amount = 0,
					scale = 0.6,
					silent = true
				}}}
			}}
			column_nodes[#column_nodes + 1] = {n = G.UIT.R, nodes = {{n = G.UIT.B, config = {w = 0.5, h = 0.5}}}}
		end
		nodes[i] = {n = G.UIT.C, config = {minw = width}, nodes = column_nodes}
	end
	self.UI.text_box = UIBox{
		definition = {n = G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes = nodes},
		config = {
			parent = parent,
			major = parent
		}
	}
	return self.UI.text_box
end

function G.FUNCS.fac_fas_undertale_options_button (e)
	local type = e.config.ref_table.type
	local extra = e.config.ref_table.extra
	local target = FishAndChips.FooSqueax.undertale.UI.main_ui:get_UIE_by_ID("text_box")
	if type == "options" then
		target.config.object = FishAndChips.FooSqueax.undertale:options(FishAndChips.FooSqueax.undertale.OPTIONS[extra], target)
	elseif type == "check" then
		target.config.object = FishAndChips.FooSqueax.undertale:info("check_" .. extra, target)
	elseif type == "leave" then
		local info
		if extra == "spare" then
			info = "spare"
			play_sound("fac_fas_spare")
			FishAndChips.FooSqueax.undertale.sprites.foo:set_sprite_pos{x = 1, y = 1}
			FishAndChips.FooSqueax.undertale.sprites.squeax:set_sprite_pos{x = 0, y = 1}
		elseif extra == "flee" then
			play_sound("fac_fas_escape")
			info = "flee_" .. math.random(1, 4)
		end
		target.config.object = FishAndChips.FooSqueax.undertale:info(info, target)
		FishAndChips.FooSqueax.undertale.removing = true
		delay(2)
		G.E_MANAGER:add_event(Event{
			func = function()
				FishAndChips.FooSqueax.undertale:remove()
				return true
			end
		})
	elseif type == "link" then
		love.system.openURL(extra)
		return
	elseif type == "nothing" then return
	else
		target.config.object = FishAndChips.FooSqueax.undertale:info(type, target)
	end
	play_sound("fac_fas_select")
	target.UIBox:recalculate()
end

function G.FUNCS.fac_fas_undertale_options_update (e)
	if e.states.hover.is ~= e.config.ref_table.past_hover then
		e.config.ref_table.sprite:set_sprite_pos({x = e.states.hover.is and 1 or 0, y = 0})
		if e.states.hover.is then play_sound("fac_fas_select") end
	end
	e.config.ref_table.past_hover = e.states.hover.is
end

function FishAndChips.FooSqueax.undertale:main_ui()
	self.sprites.foo = SMODS.create_sprite(0, 0, 2, 2 / 25 * 24, "fac_fas_undertale_tobysona", {x = 1, y = 0})
	self.sprites.squeax = SMODS.create_sprite(0, 0, 2, 2 / 25 * 24, "fac_fas_undertale_tobysona", {x = 0, y = 0})
	self.UI.main_ui = UIBox{
		definition = {n = G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes = {
			{n = G.UIT.R, config = {align = "bm"}, nodes = {
				{n = G.UIT.O, config = {object = SMODS.create_sprite(0, 0, 5, 6, "fac_fas_undertale_background", {x = 0, y = 0})}},
				{n = G.UIT.B, config = {w = 0.5, h = 0.1}},
				{n = G.UIT.C, nodes = {
					{n = G.UIT.R, nodes = {
						{n = G.UIT.B, config = {w = 5, h = 4}}
					}},
					{n = G.UIT.R, nodes = {
						{n = G.UIT.O, config = {object = self.sprites.foo}},
						{n = G.UIT.B, config = {w = 1, h = 0.1}},
						{n = G.UIT.O, config = {object = self.sprites.squeax}},
					}}
				}},
				{n = G.UIT.B, config = {w = 0.5, h = 0.1}},
				{n = G.UIT.O, config = {object = SMODS.create_sprite(0, 0, 5, 6, "fac_fas_undertale_background", {x = 1, y = 0})}},
			}},
			{n = G.UIT.R, nodes = {
				{n = G.UIT.B, config = {w = 15, h = 0.05}}
			}},
			{n = G.UIT.R, config = {align = "tm"}, nodes = {
				{n = G.UIT.R, config = {outline = 2, outline_colour = G.C.WHITE, padding = 0.2, minw=15, minh = 3.5, align = "tl"}, nodes = {
					{n = G.UIT.O, config = {id = "text_box", object = self:info("start")}}
				}}
			}},
			{n = G.UIT.R, nodes = {
				{n = G.UIT.B, config = {w = 15, h = 0.05}}
			}},
			{n = G.UIT.R, config = {align = "cm", minh = 0.5}, nodes = {
				{n = G.UIT.C, config = {align = "cl", maxw = 5, minw = 5}, nodes = {
					{n = G.UIT.T, config = {text = G.PROFILES[G.SETTINGS.profile].name, colour = G.C.WHITE, scale = 0.45}},
					{n = G.UIT.B, config = {w = 0.5, h = 0.45}},
					{n = G.UIT.T, config = {text = "LV 1", colour = G.C.WHITE, scale = 0.45}},
				}},
				{n = G.UIT.C, config = {align = "cm", maxw = 5, minw = 5}, nodes = {
					{n = G.UIT.T, config = {text = "HP", colour = G.C.WHITE, scale = 0.3}},
					{n = G.UIT.B, config = {w = 0.05, h = 0.45}},
					{n = G.UIT.B, config = {w = 0.55, h = 0.45, colour = G.C.YELLOW}},
					{n = G.UIT.B, config = {w = 0.15, h = 0.45}},
					{n = G.UIT.T, config = {text = "20 / 20", colour = G.C.WHITE, scale = 0.45}},
				}},
				{n = G.UIT.B, config = {w = 5, h = 0.45}}
			}},
			{n = G.UIT.R, nodes = {
				{n = G.UIT.B, config = {w = 15, h = 0.05}}
			}},
			{n = G.UIT.R, config = {align = "cm"}, nodes = {
				self:button({x = 1, y = 0}, "fight"),
				{n = G.UIT.B, config = {w = 1, h = 1}},
				self:button({x = 2, y = 0}, "act"),
				{n = G.UIT.B, config = {w = 1, h = 1}},
				self:button({x = 3, y = 0}, "item"),
				{n = G.UIT.B, config = {w = 1, h = 1}},
				self:button({x = 4, y = 0}, "mercy"),
			}}
		}},
		config = {
			align = "cmi",
			major = G.ROOM_ATTACH,
			instance_type = "UNDERTALE"
		}
	}
end

function G.FUNCS.fac_fas_undertale_bottom_button_update (e)
	if e.states.hover.is ~= e.config.ref_table.past_hover then
		FishAndChips.FooSqueax.undertale.sprites[e.config.ref_table[2]]:set_sprite_pos(e.states.hover.is and {x = 0, y = 0} or e.config.ref_table[1])
		e.children[2].children[1].config.colour = e.states.hover.is and FishAndChips.C.FooSqueax.YELLOW or FishAndChips.C.FooSqueax.ORANGE
		e.config.outline_colour = e.states.hover.is and FishAndChips.C.FooSqueax.YELLOW or FishAndChips.C.FooSqueax.ORANGE
		if e.states.hover.is then play_sound("fac_fas_select") end
	end
	e.config.ref_table.past_hover = e.states.hover.is
end

function G.FUNCS.fac_fas_undertale_bottom_button_click (e)
	local type = e.config.ref_table[3]
	local target = FishAndChips.FooSqueax.undertale.UI.main_ui:get_UIE_by_ID("text_box")
	if target.config.object.cards then
		target.config.object.cards = {}
	end
	if type == "fight" then
		target.config.object = FishAndChips.FooSqueax.undertale:info("combat", target)
	elseif type == "act" then
		target.config.object = FishAndChips.FooSqueax.undertale:options({{
			{"foo", "options", "foo"},
			{"squeax", "options", "squeax"}
		}}, target)
	elseif type == "item" then
		if not G.consumeables or #G.consumeables.cards == 0 then
			target.config.object = FishAndChips.FooSqueax.undertale:info("no_items", target)
		else
			target.config.object = CardArea(G.ROOM.T.x, G.ROOM.T.y-0.2, (G.CARD_W*7.1), G.CARD_H, { card_limit = #G.consumeables.cards, type = 'title_2', highlight_limit = 0, collection = true }) 
			for i=1, #G.consumeables.cards do
				local card = Card(target.config.object.T.x, target.config.object.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[G.consumeables.cards[i].config.center_key])
				target.config.object:emplace(card)
				card.no_ui = true
			end
		end
	elseif type == "mercy" then
		target.config.object = FishAndChips.FooSqueax.undertale:options({{
			{"flee", "leave", "flee"},
			{"spare", "leave", "spare"}
		}}, target)
	end
	play_sound("fac_fas_select")
	target.UIBox:recalculate()
end

function FishAndChips.FooSqueax.undertale:button(atlas_pos, loc_key, button)
	button = button or loc_key
	loc_key = "k_fac_fas_undertale_" .. loc_key

	self.sprites[loc_key] = SMODS.create_sprite(0, 0, 1 / 38 * 27, 1, "fac_fas_undertale_icons", atlas_pos)
	
	return {n = G.UIT.C, config = {minw = 3, minh = 1, outline = 2, outline_colour = FishAndChips.C.FooSqueax.ORANGE, func = "fac_fas_undertale_bottom_button_update", button = "fac_fas_undertale_bottom_button_click", button_dist = 0, ref_table = {atlas_pos, loc_key, button}}, nodes = {
		{n = G.UIT.C, nodes = {
			{n = G.UIT.O, config = {object = self.sprites[loc_key]}}
		}},
		{n = G.UIT.C, config = {minw = 2, maxw = 2, align = "cm"}, nodes = {
			{n = G.UIT.T, config = {scale = 1, colour = FishAndChips.C.FooSqueax.ORANGE, text = localize(loc_key)}}
		}}
	}}
end

function FishAndChips.FooSqueax.undertale:remove()
	local to_remove = {}
	for _, v in pairs(self.UI) do
		to_remove[#to_remove+1] = v
	end
	for _, v in ipairs(to_remove) do
		v:remove()
	end
	self.UI = {}
	self.active = false
end

function FishAndChips.FooSqueax.undertale:draw()
	if self.active then
		love.graphics.clear(0, 0, 0, 1)
		for _, v in pairs(G.I.UNDERTALE) do
			love.graphics.push()
			v:translate_container()
			v:draw()
			love.graphics.pop()
		end
	end
end

local g_funcs_exit_overlay_menu_ref = G.FUNCS.exit_overlay_menu
---@diagnostic disable-next-line: duplicate-set-field
function G.FUNCS.exit_overlay_menu(...)
	if FishAndChips.FooSqueax.undertale.active and not FishAndChips.FooSqueax.undertale.removing then
		local target = FishAndChips.FooSqueax.undertale.UI.main_ui:get_UIE_by_ID("text_box")
		if target.config.object.cards then
			target.config.object.cards = {}
		end
		target.config.object = FishAndChips.FooSqueax.undertale:info("flee_" .. math.random(1, 4), target)
		target.UIBox:recalculate()
		FishAndChips.FooSqueax.undertale.removing = true
		delay(2)
		play_sound("fac_fas_escape")
		G.E_MANAGER:add_event(Event{
			func = function()
				FishAndChips.FooSqueax.undertale:remove()
				return true
			end
		})
	end
	g_funcs_exit_overlay_menu_ref(...)
end