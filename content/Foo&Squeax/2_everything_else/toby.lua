SMODS.Atlas{
	key = "fas_toby",
	path = FishAndChips.FooSqueax.file_path .. "toby.png",
	px = 62,
	py = 52
}

SMODS.Atlas{
	key = "fas_toby_fish",
	path = FishAndChips.FooSqueax.file_path .. "toby_fish.png",
	px = 71,
	py = 71
}

FishAndChips.Fish{
	key = "fas_toby_fish",
	ppu_coder = {"Foo54"},
	weight = 5,
	environments = {
		wormhole = 1,
		aquifer = 1,
		pier = 1,
		garden = 1,
		volcano = 1,
		swamp = 1
	},
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {elements = {SMODS.create_sprite(0, 0, 2, 2 / 62 * 52, "fac_fas_toby")}}}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			self.extra_cost = self.extra_cost - 1
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
		return g_uidef_card_h_popup_ref(card)
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