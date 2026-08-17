--#region Bait Init
---@class FishAndChips.Bait: SMODS.Center
FishAndChips.Bait = SMODS.Center:extend{
	unlocked = true,
	discovered = false,
	obj_buffer = {},
	pos = { x = 0, y = 0 },
	atlas = "fac_bait",
	cost = 4,
	boost = 3,
	config = {},
	set = 'fac_Bait',
	class_prefix = 'bait',
	required_params = {
		'key',
		'target',
		'boost'
	},
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_bait"), FishAndChips.C.BAIT, G.C.WHITE, 1.2)
	end,
	inject = function(self)
		-- idk we might want something here
		SMODS.Center.inject(self)
	end,
	loc_vars = function (self, info_queue, card)
		local boost = FishAndChips.get_bait_boost(self, self.boost)
		return {
			vars = {
				boost
			}
		}
	end,
	boost_weight = function (self, weight)
		local boost = FishAndChips.get_bait_boost(self, self.boost)
		return weight * boost
	end
}

G.C.SET.fac_Bait = FishAndChips.C.BAIT
G.C.SECONDARY_SET.fac_Bait = FishAndChips.C.BAIT

function G.UIDEF.create_UIBox_your_collection_bait()
	local pool = {}
	for k, v in pairs(G.P_CENTER_POOLS.fac_Bait) do
		if not v.no_collection then pool[#pool + 1] = v end
	end
	return SMODS.card_collection_UIBox(pool, { 5, 5, 5}, {
		no_materialize = true,
		h_mod = 0.95,
		back_func = 'your_collection_other_gameobjects',
	})
end

function G.FUNCS.fac_your_collection_bait(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu {
		definition = G.UIDEF.create_UIBox_your_collection_bait(),
	}
end


SMODS.UndiscoveredSprite {
	key = 'fac_Bait',
	atlas = 'soup',
	pos = { x = 0, y = 0 },
	no_overlay = true,
}
SMODS.UndiscoveredCompat.fac_Bait = true
--#endregion

--#region Bait Utils

function FishAndChips.add_bait_to_shop(key, amt)
	local found = false
	for _, b in ipairs(G.GAME.fac_bait_shop_items) do
		if b.key == key then
			b.amt = b.amt + (amt or 1)
			found = true
			break
		end
	end
	if not found then
		table.insert(G.GAME.fac_bait_shop_items, 1, { key = key, amt = 1 })
	end
end

function FishAndChips.remove_bait_from_shop(key)
	for _, b in ipairs(G.GAME.fac_bait_shop_items) do
		if b.key == key and b.amt >= 1 then
			b.amt = b.amt - 1
			break
		end
	end
end

function FishAndChips.clean_up_bait_shop()
	local new = {}
	for _, b in ipairs(G.GAME.fac_bait_shop_items) do
		if b.amt ~= 0 then
			new[#new + 1] = b
		end
	end
	G.GAME.fac_bait_shop_items = new
end

function FishAndChips.get_bait_shop_item(key)
	for _, b in ipairs(G.GAME.fac_bait_shop_items) do
		if b.key == key then
			return b
		end
	end
end


function FishAndChips.add_bait_to_inventory(key, amt)
	local found = false
	local inv = G.GAME.fac_bait_inventory
	for _, b in ipairs(inv) do
		if b.key == key then
			b.amt = b.amt + (amt or 1)
			found = true
			break
		end
	end
	if not found then
		table.insert(inv, { key = key, amt = (amt or 1) })
	end
	if key == G.GAME.fac_active_bait then
		FishAndChips.update_bait_counter(G.fac_bait_area.cards[1])
	end
	if not G.GAME.fac_active_bait then
		G.FUNCS.fac_set_active_bait({ config = { key = key }})
	end
end

function FishAndChips.remove_bait_from_inventory(key, amt)
	local zeroed = false
	for _, b in ipairs(G.GAME.fac_bait_inventory) do
		if b.key == key and b.amt >= 1 then
			b.amt = math.max(b.amt - (amt or 1), 0)
			if b.amt == 0 then
				b = nil
				zeroed = true
			end
			break
		end
	end
	if key == G.GAME.fac_active_bait then
		G.E_MANAGER:add_event(Event({
			func = function()
				FishAndChips.update_bait_counter(G.fac_bait_area.cards[1])
				return true;
			end
		}))
	end
	if zeroed then
		FishAndChips.clean_up_bait_inventory()
		if key == G.GAME.fac_active_bait then
			SMODS.destroy_cards(G.fac_bait_area.cards[1], { pinch_anim = true })
			G.GAME.fac_active_bait = nil
			if G.FISHING.fishing_bait_count then
				G.E_MANAGER:add_event(Event({
					func = function()
						G.FISHING.fishing_bait_count:remove()
						return true;
					end
				}))
			end
		end
	end
end

function FishAndChips.get_bait_inventory_item(key)
	for _, b in ipairs(G.GAME.fac_bait_inventory) do
		if b.key == key then
			return b
		end
	end
end

function FishAndChips.clean_up_bait_inventory()
	local new = {}
	for _, b in ipairs(G.GAME.fac_bait_inventory) do
		if b.amt ~= 0 then
			new[#new + 1] = b
		end
	end
	G.GAME.fac_bait_inventory = new
end

function FishAndChips.get_bait_boost(obj, boost)
	if G.fac_rod_area then
		local center, rod = FishAndChips.get_rod()
		if center.bait_bonus then
			if type(center.bait_bonus) == 'function' then
				return center:bait_bonus(obj, boost)
			elseif type(center.bait_bonus) == 'number' then
				return boost * center.bait_bonus
			end
		end
	end
	return boost
end
--#endregion

--#region Bait Objects
FishAndChips.Bait{
	key = "normal",
	ppu_artist = {'squeax09'},
	target = '',
	pixel_size = {w = 63, h = 91},
	cost = 1,
	in_pool = function(self, args)
		args = args or {}
		return args.source ~= 'fac_bait_shop'
	end
}
FishAndChips.Bait{
	key = "mult",
	ppu_artist = {'squeax09'},
	pos = {x = 2, y = 0},
	target = 'mult',
}
FishAndChips.Bait{
	key = "chips",
	ppu_artist = {'squeax09'},
	pos = {x = 1, y = 0},
	pixel_size = {w = 60, h = 78},
	target = 'chips',
}
FishAndChips.Bait{
	key = "economy",
	ppu_artist = {'squeax09'},
	pos = {x = 3, y = 0},
	pixel_size = {w = 60, h = 73},
	target = 'economy',
}
FishAndChips.Bait{
	key = "xmult",
	ppu_artist = {'squeax09'},
	pos = {x = 6, y = 1},
	pixel_size = {w = 69, h = 74},
	target = 'xmult',
}
FishAndChips.Bait{
	key = "retrigger",
	ppu_artist = {'squeax09'},
	pos = {x = 6, y = 0},
	pixel_size = {w = 50, h = 78},
	target = 'retrigger',
}
FishAndChips.Bait{
	key = "space",
	ppu_artist = {'squeax09'},
	pos = {x = 4, y = 0},
	pixel_size = {w = 62, h = 83},
	target = 'hand_level'
}
FishAndChips.Bait{
	key = "function",
		ppu_artist = {'squeax09'},
	pos = {x = 5, y = 0},
	pixel_size = {w = 70, h = 86},
	target = 'usable'
}
FishAndChips.Bait{
	key = "suit",
	ppu_artist = {'squeax09'},
	pos = {x = 0, y = 1},
	pixel_size = {w = 68, h = 66},
	target = 'suit'
}
FishAndChips.Bait{
	key = "passive",
	ppu_artist = {'squeax09'},
	pos = {x = 1, y = 1},
	pixel_size = {w = 47, h = 77},
	target = 'passive',
}
FishAndChips.Bait{
	key = "rank",
	ppu_artist = {'squeax09'},
	pos = {x = 2, y = 1},
	pixel_size = {w = 70, h = 87},
	target = 'rank',
}
FishAndChips.Bait{
	key = "copy",
	ppu_artist = {'squeax09'},
	pos = {x = 3, y = 1},
	pixel_size = {w = 60, h = 84},
	target = 'copying',
}
FishAndChips.Bait{
	key = "generation",
	ppu_artist = {'squeax09'},
	pos = {x = 7, y = 0},
	pixel_size = {w = 27, h = 85},
	target = 'generation',
}
FishAndChips.Bait{
	key = "boss",
	ppu_artist = {'squeax09'},
	pos = {x = 4, y = 1},
	pixel_size = {w = 37, h = 84},
	target = 'boss_blind',
}
FishAndChips.Bait{
	key = "destroy",
	ppu_artist = {'squeax09'},
	pos = {x = 5, y = 1},
	pixel_size = {w = 68, h = 68},
	target = 'destroy_card',
}
--#endregion
