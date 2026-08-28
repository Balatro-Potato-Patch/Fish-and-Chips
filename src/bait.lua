--#region Bait Init
---@class FishAndChips.Bait: SMODS.Center
FishAndChips.Bait = SMODS.Center:extend{
	unlocked = true,
	discovered = false,
	obj_buffer = {},
	pos = { x = 0, y = 0 },
	atlas = "fac_bait",
	mini_atlas = "fac_mini_bait",
	cost = 4,
	boost = 6,
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
G.ARGS.LOC_COLOURS.fac_Bait = FishAndChips.C.BAIT

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
	local current_inv = G.GAME.fac_bait_shop_items

	if current_inv[key] then
		current_inv[key].amt = current_inv[key].amt + 1
		found = true
	else
		current_inv[key] = {amt = amt or 1}
	end
end

function FishAndChips.remove_bait_from_shop(key, amount)
	local bait = G.GAME.fac_bait_shop_items[key]
	bait.amt = bait.amt - amount
	if bait.amt == 0 then
		G.GAME.fac_bait_shop_items[key] = nil
	end
	G.GAME.fac_active_shop_bait.amount = G.GAME.fac_active_shop_bait.amount - amount
	G.GAME.fac_active_shop_bait.all_cost = G.GAME.fac_active_shop_bait.cost * G.GAME.fac_active_shop_bait.amount
end

function FishAndChips.get_bait_shop_item(key)
	return G.GAME.fac_bait_shop_items[key]
end

function FishAndChips.create_bait_inventory_item(key, pos)
    local _size = 0.8
	local center = G.P_CENTERS[key]
	local w = center.mini_atlas and 0.65 or 71/95 * 0.65
	local sprite = SMODS.create_sprite(0,0, w, 0.65, SMODS.get_atlas(center.mini_atlas or center.atlas), center.mini_pos or center.pos)
	sprite.config.center = center
    local bait_node = {n= G.UIT.C, config={align = "cm",  padding = -0.1}, nodes={
		{n=G.UIT.C, config = {align = 'cm'}, nodes = {
			{n=G.UIT.R, config = {align = 'cm', minw = 0.65}, nodes = {
				{n=G.UIT.O, config={object = sprite, focus_with_object = true}},
            }}
        }},
        {n=G.UIT.C, config = {align = 'bl'}, nodes = {
			{n=G.UIT.R, config = {ralign = 'cl'}, nodes = {
				{n=G.UIT.O, config={object = DynaText({scale = 0.3, maxw = 0.3, string = {{ref_table = G.GAME.fac_bait_inventory[key], ref_value = 'amt', prefix = 'X'}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true})}},
            }}
        }}
    }}

	local pos = pos or (#G.HUD_bait_inv + 1)

	local colour = {G.C.GREEN, G.C.BLUE, G.C.RED}
	local box = UIBox{
		definition = {n=G.UIT.ROOT, config={align = "tl", colour = G.C.CLEAR, focus_args = {}, pos = pos}, nodes={
			bait_node
		}},
		config = {
			type = pos > 1 and 'cm' or 'tr',
			offset = pos == 1 and {x=0.2,y=0.7} or pos % 4 == 1 and {x=0.85, y=0} or {x=0,y=0.65},
			major = pos == 1 and G.fac_bait_area or pos % 4 == 1 and G.HUD_bait_inv[pos-4] or G.HUD_bait_inv[pos-1],
			fac_bait_key = key,
			instance_type = "CARD"
		},
	}
		
	box.states.hover.can = true
	box.states.drag.can = false
	box.states.collide.can = true
	box.config.force_focus = true

	box.stop_hover = function(_self) _self.hovering = false; Node.stop_hover(_self); _self.hover_tilt = 0 end

	box.hover = function(_self)
		if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not _self.hovering and _self.states.visible then
                _self.hovering = true
                    _self.hover_tilt = 3
                    sprite:juice_up(0.05, 0.02)
                    play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
                    play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)

				sprite.ability_UIBox_table = generate_card_ui(G.P_CENTERS[key], nil, {}, 'fac_Bait', {card_type = 'fac_Bait'}, nil, nil, nil, self)

                _self.config.h_popup =  G.UIDEF.card_h_popup(sprite)
                _self.config.h_popup_config = {align =  'br', offset = {x=0.2,y=-0.65}, parent = _self}
                Node.hover(_self)
            end
        end
	end

	box.click = function(_self)
		G.FUNCS.fac_set_active_bait({ config = { key = key, inventory_swap = true }})
	end

    return box
end

function FishAndChips.rebuild_bait_inventory(swapped_bait)
	if not G.GAME or not G.GAME.fac_bait_inventory or not G.fac_bait_area then return end
	local old_inventory = G.HUD_bait_inv or {}
	local ordered_keys = {}
	local seen = {}
	for _, box in ipairs(old_inventory) do
		local key = box.config and box.config.fac_bait_key
		local bait = key and G.GAME.fac_bait_inventory[key]
		local replacement = key == G.GAME.fac_active_bait and swapped_bait or key
		bait = replacement and G.GAME.fac_bait_inventory[replacement]
		if bait and bait.amt > 0 and replacement ~= G.GAME.fac_active_bait and not seen[replacement] then
			seen[replacement] = true
			ordered_keys[#ordered_keys + 1] = replacement
		end
	end
	local new_keys = {}
	for key, bait in pairs(G.GAME.fac_bait_inventory) do
		if bait.amt > 0 and key ~= G.GAME.fac_active_bait and not seen[key] then
			new_keys[#new_keys + 1] = key
		end
	end
	table.sort(new_keys)
	for _, key in ipairs(new_keys) do
		ordered_keys[#ordered_keys + 1] = key
	end
	for _, box in pairs(old_inventory) do
		box:remove()
	end
	G.HUD_bait_inv = {}
	for _, key in ipairs(ordered_keys) do
		G.HUD_bait_inv[#G.HUD_bait_inv + 1] = FishAndChips.create_bait_inventory_item(key)
	end
end

function FishAndChips.add_bait_to_inventory(key, amt)
	G.HUD_bait_inv = G.HUD_bait_inv or {}
	local found = false
	local current_inv = G.GAME.fac_bait_inventory

	if current_inv[key] then
		current_inv[key].amt = current_inv[key].amt + (amt or 1)
		found = true
	else
		current_inv[key] = {amt = amt or 1}
	end

	if key == G.GAME.fac_active_bait then
		FishAndChips.update_bait_counter(G.fac_bait_area.cards[1])
	end
	if not G.GAME.fac_active_bait then
		G.FUNCS.fac_set_active_bait({ config = { key = key }})
	elseif not found then
		FishAndChips.rebuild_bait_inventory()
	end
end

function FishAndChips.remove_bait_from_inventory(key, amt)
	local zeroed = false

	local b = G.GAME.fac_bait_inventory[key]
	b.amt = math.max(b.amt - (amt or 1), 0)
	if b.amt == 0 then
		zeroed = true
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
		if key == G.GAME.fac_active_bait then
			SMODS.destroy_cards(G.fac_bait_area.cards[1], { pinch_anim = true, skip_calc = true })
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
		G.GAME.fac_bait_inventory[key] = nil
		FishAndChips.rebuild_bait_inventory()
	end
end

function FishAndChips.get_bait_inventory_item(key)
	return G.GAME.fac_bait_inventory[key]
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
	fac_mini_artist = {'Lusha'},
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
	fac_mini_artist = {'CyanSoCalico'},
	pos = {x = 2, y = 0},
	target = 'mult',
}
FishAndChips.Bait{
	key = "chips",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 1, y = 0},
	pixel_size = {w = 60, h = 78},
	target = 'chips',
}
FishAndChips.Bait{
	key = "economy",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 3, y = 0},
	pixel_size = {w = 60, h = 73},
	target = 'economy',
	boost = 5
}
FishAndChips.Bait{
	key = "xmult",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 6, y = 1},
	pixel_size = {w = 69, h = 74},
	target = 'xmult',
}
FishAndChips.Bait{
	key = "retrigger",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 6, y = 0},
	pixel_size = {w = 50, h = 78},
	target = 'retrigger',
	boost = 8
}
FishAndChips.Bait{
	key = "space",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 4, y = 0},
	pixel_size = {w = 62, h = 83},
	target = 'hand_level',
	boost = 15
}
FishAndChips.Bait{
	key = "function",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 5, y = 0},
	pixel_size = {w = 70, h = 86},
	target = 'usable',
	boost = 4
}
FishAndChips.Bait{
	key = "suit",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 0, y = 1},
	pixel_size = {w = 68, h = 66},
	target = 'suit',
	boost = 8
}
FishAndChips.Bait{
	key = "passive",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 1, y = 1},
	pixel_size = {w = 47, h = 77},
	target = 'passive',
}
FishAndChips.Bait{
	key = "rank",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'CyanSoCalico'},
	pos = {x = 2, y = 1},
	pixel_size = {w = 70, h = 87},
	target = 'rank',
	boost = 8
}
FishAndChips.Bait{
	key = "copy",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'CyanSoCalico'},
	pos = {x = 3, y = 1},
	pixel_size = {w = 60, h = 84},
	target = 'copying',
	boost = 8
}
FishAndChips.Bait{
	key = "generation",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 7, y = 0},
	pixel_size = {w = 35, h = 85},
	target = 'generation',
	boost = 5
}
FishAndChips.Bait{
	key = "boss",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'CyanSoCalico'},
	pos = {x = 4, y = 1},
	pixel_size = {w = 37, h = 84},
	target = 'boss_blind',
	boost = 15
}
FishAndChips.Bait{
	key = "destroy",
	ppu_artist = {'squeax09'},
	fac_mini_artist = {'Lusha'},
	pos = {x = 5, y = 1},
	pixel_size = {w = 68, h = 68},
	target = 'destroy_card',
}
--#endregion
