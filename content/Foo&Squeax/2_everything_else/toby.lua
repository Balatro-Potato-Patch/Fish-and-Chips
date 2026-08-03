SMODS.Atlas{
	key = "fas_toby",
	path = FishAndChips.FooSqueax.file_path .. "toby/toby.png",
	px = 62,
	py = 52
}

SMODS.Atlas{
	key = "fas_toby_fish",
	path = FishAndChips.FooSqueax.file_path .. "toby/toby_fish.png",
	px = 71,
	py = 71
}

SMODS.Atlas{
	key = "fas_toby_sona",
	path = FishAndChips.FooSqueax.file_path .. "toby/tobysona_line.png",
	px = 22,
	py = 17
}


FishAndChips.Fish{
	key = "fas_toby_fish",
	ppu_coder = {"Foo54"},
	ppu_artist = {"squeax09"},
	atlas = 'fas_fish_general',
	pos = {x=3,y=0},
	pixel_size = { w=66, h=66},
	weight = 5,
	environments = {
		wormhole = 1,
		aquifer = 1,
		pier = 1,
		garden = 1,
		volcano = 1,
		swamp = 1
	},
	set_card_type_badge = function(self, card, badges)
		local scaling = 1.2
		badges[#badges + 1] = {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.R, config={align = "cm", colour = FishAndChips.C.FISH, r = 0.1, minw = 2, minh = 0.4*scaling, emboss = 0.05}, nodes={
        {n=G.UIT.O, config={object = SMODS.create_sprite(0, 0, 0.5 * scaling, 0.5 * scaling / 62 * 52, "fac_fas_toby")}},
      }}
    }}
	end,
	disable_visual_scaling = true,
	stats = {
		length = {min = 1, max = 1},
		weight = {min = 1, max = 1}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {elements = {SMODS.create_sprite(0, 0, 2, 2 / 62 * 52, "fac_fas_toby")}}}
	end,
	config = {
		extra = {
			add = 1,
			mult = 1
		}
	},
	attributes = {"chips", "mult", "xchips", "xmult", "score", "xscore", "blindsize", "passive", "economy"},
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			card.ability.extra_cost = (card.ability.extra_cost or 0) - 1
			card:set_cost()
		end
		if context.joker_main then
			return {
				chips = 1 / card.ability.extra.add,
				mult = 1 / card.ability.extra.add,
				xchips = 1.1 / card.ability.extra.mult,
				xmult = 1.1 / card.ability.extra.mult,
				score = 1 / card.ability.extra.add,
				xscore = 1.1 / card.ability.extra.mult,
				blindsize = 1 / card.ability.extra.add,
			}
		end
	end,
	on_catch = function (self, card)
		G.GAME.fac_FooSqueax.tobies = G.GAME.fac_FooSqueax.tobies + 3
	end
}


local desc_from_rows_ref = desc_from_rows
---@diagnostic disable-next-line: lowercase-global
function desc_from_rows(desc_nodes, empty, maxw)
	if FishAndChips.FooSqueax.toby_fish.no_desc == true then 
		FishAndChips.FooSqueax.toby_fish.no_desc = nil
		return {n=G.UIT.R, config={main_box_flag = desc_nodes.main_box_flag and true or nil}, nodes={}}
	end
	return desc_from_rows_ref(desc_nodes, empty, maxw)
end

local g_uidef_card_h_popup_ref = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
	if card.config and card.config.center and card.config.center.key == "fish_fac_fas_toby_fish" then
		FishAndChips.FooSqueax.toby_fish.no_desc = true
		FishAndChips.FooSqueax.toby_fish.custom_units = true
		local ret = g_uidef_card_h_popup_ref(card)
		FishAndChips.FooSqueax.toby_fish.custom_units = nil
		
		local search = SMODS.deepfind(ret.nodes[1].nodes, "Foo54", nil, true)[1]
		local config = search.objtree[#search.objtree - 2]
		config.object:remove()
		config.object = SMODS.create_sprite(0, 0, 0.5, 0.5 / 22 * 17, "fac_fas_toby_sona", {x = 1, y = 0})
		
		local search2 = SMODS.deepfind(ret.nodes[1].nodes, "squeax09", nil, true)[1]
		local config2 = search2.objtree[#search2.objtree - 2]
		config2.object:remove()
		config2.object = SMODS.create_sprite(0, 0, 0.5, 0.5 / 22 * 17, "fac_fas_toby_sona")

		return ret
	end
	local ret = g_uidef_card_h_popup_ref(card)
	if not G.GAME.fac_FooSqueax or not G.GAME.fac_FooSqueax.tobies then return ret end
	for i = 1, G.GAME.fac_FooSqueax.tobies do
		G.fac_fas_toby_fish = G.fac_fas_toby_fish or {}
		for _, toby in pairs(G.fac_fas_toby_fish) do
			toby:remove()
		end
		G.fac_fas_toby_fish = {}
		G.E_MANAGER:add_event(Event{
			blocking = false,
			blockable = false,
			type = "immediate",
			func = function()
					if card.children.h_popup then
					G.fac_fas_toby_fish[i] = UIBox{
						definition = G.UIDEF.fac_fas_toby_fish(i, card),
						config = {
							major = card.children.h_popup,
							align = "tli",
							r_bond = "Weak",
							instance_type = "POPUP",
							offset = {
								x = math.random() * card.children.h_popup.VT.w - 1,
								y = math.random() * card.children.h_popup.VT.h - 1
							}
						}
					}
					
					local card_children_h_popup_remove_ref = card.children.h_popup.remove
					function card.children.h_popup:remove()
						card_children_h_popup_remove_ref(self)
						if G.fac_fas_toby_fish[i] then
							G.fac_fas_toby_fish[i]:remove()
							G.fac_fas_toby_fish[i] = nil
						end
					end
				end
				return true
			end
		})
	end
	return ret
end

function G.UIDEF.fac_fas_toby_fish(i, card)
	local sprite = SMODS.create_sprite(0, 0, 1, 1, "fac_fas_toby_fish")
	return {n = G.UIT.ROOT, config = {func = "fac_fas_toby_update", colour = G.C.CLEAR, ref_table = {
		v = {
			x = math.random() * 4 - 2,
			y = math.random() * 4 - 2,
			r = 0
		},
		no_collision = {},
		i = i,
		sprite = sprite,
		card = card
	}}, nodes = {
		{n = G.UIT.O, config = {object = sprite}}
	}}
end

function G.FUNCS.fac_fas_toby_update (e)
	local data = e.config.ref_table
	local card = e.config.ref_table.card
	local popup = card.children.h_popup
	local box = G.fac_fas_toby_fish[data.i]
	local dt = G.real_dt

	if popup then
		box.alignment.offset.x = box.alignment.offset.x + data.v.x * dt
		box.alignment.offset.y = box.alignment.offset.y + data.v.y * dt
		box.T.r = box.T.r + data.v.r
		if box.alignment.offset.x <= 0 then
			box.alignment.offset.x = 0
			data.v.x = -data.v.x * 1.01
		end
		if box.alignment.offset.x + box.VT.w >= popup.VT.w then
			box.alignment.offset.x = popup.VT.w - box.VT.w
			data.v.x = -data.v.x * 1.01
		end
		if box.alignment.offset.y <= 0 then
			box.alignment.offset.y = 0
			data.v.y = -data.v.y * 1.01
		end
		if box.alignment.offset.y + box.VT.h >= popup.VT.h then
			box.alignment.offset.y = popup.VT.h - box.VT.h
			data.v.y = -data.v.y * 1.01
		end

		for i, toby in pairs(G.fac_fas_toby_fish) do
			if toby ~= box then
				if ((box.VT.x + box.VT.w / 2) - (toby.VT.x + toby.VT.w / 2)) ^ 2 + ((box.VT.y + box.VT.h / 2) - (toby.VT.y + toby.VT.h / 2)) ^ 2 <= 0.5 then
					if not data.no_collision[i] then
						data.v.x = -data.v.x * (1.1 - 2 * math.random() / 10)
						data.v.y = -data.v.y * (1.1 - 2 * math.random() / 10)
						data.v.r = (math.random() - 0.5) * math.pi / 8
						data.no_collision[i] = true
					end
				else
					data.no_collision[i] = nil
				end
			end
		end
	end
end

local fishandchips_format_measurement_ref = FishAndChips.format_measurement
---@diagnostic disable-next-line: duplicate-set-field
function FishAndChips.format_measurement(value, type, ...)
	if FishAndChips.FooSqueax.toby_fish.custom_units then
		return value .. " " .. localize("k_fac_fas_" .. (type == "weight" and "toby" or "temmie"))
	end
	return fishandchips_format_measurement_ref(value, type, ...)
end