--#region Fish Init

---@class FishAndChips.Fish: SMODS.Center
FishAndChips.Fish = SMODS.Center:extend {
	unlocked = true,
	discovered = false,
	pos = { x = 0, y = 0 },
	atlas = "fac_placeholders",
	cost = 4,
	config = {},
	blueprint_compat = true,
	set = "fac_Fish",
	attributes = {},
	class_prefix = "fish",
	required_params = {
		"weight",
		"key",
		"environments",
		"ppu_coder"
	},
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
	inject = function(self)
		assert(self.stats and self.stats.weight and self.stats.length and self.stats.weight.min and self.stats.weight.max and self.stats.length.min and self.stats.length.max,
			'\n\nFish with key ' .. self.original_key .. ' has an incomplete stats field.\nMake sure it uses stats = {weight = {min = X, max = Y}, length = {min = Z, max = W}}.\nWeight is submitted in kilograms, length is submitted in metres.')
		
		SMODS.Center.inject(self)
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize(card.config.center.badge_key or "k_fac_fish"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
	post_inject_class = function(self)
		FishAndChips.verify_submissions()
	end
}

local function strip_decimals(stats, value, precision)
	precision = precision or math.max(string.len(stats.min - math.floor(stats.min)) - 2, string.len(stats.max - math.floor(stats.max)) - 2, 1)
	return tonumber(string.format(value < 100 and "%."..precision.."f" or "%.d", value))
end

local function random_measurement(stats, forced)
	local delta = stats.max - stats.min
	local value = stats.min + (pseudorandom('fac_fish_measurement') * delta)
	return stats.units and value or strip_decimals(stats, value)
end


function FishAndChips.create_fish_stats(center)
	if center.set ~= 'fac_Fish' then return end
	local stats = {
        weight = random_measurement(center.stats.weight),
        length = random_measurement(center.stats.length),
		units = {
			length = center.stats.length.units,
			weight = center.stats.weight.units
		}
    }
	local w_delta = center.stats.weight.max - center.stats.weight.min
	local l_delta = center.stats.length.max - center.stats.length.min
    stats.w_prop = w_delta > 0 and (stats.weight - center.stats.weight.min)/w_delta or 0.5
    stats.l_prop = l_delta > 0  and (stats.length - center.stats.length.min)/l_delta or 0.5
	return stats
end

function FishAndChips.modify_fish_stats(card, stats)
	card.ability.stats = stats
	local stats_tot = stats.w_prop + stats.l_prop
	local scalar = stats_tot <= 0.5 and 0.75 or stats_tot <= 1.5 and 1 or stats_tot <= 1.8 and 1.5 or 2.5
	if not FishAndChips.mod.config.disable_fish_scaling and not G.P_CENTERS[card.config.center.key].disable_visual_scaling then
		card.T.scale = card.T.scale * (0.6 + (stats_tot/2*0.7))
	end
	card.base_cost = card.config.center.cost * scalar
	card:set_cost()
end

function FishAndChips.update_fish_records(save_record, stats)
	save_record.record_weight = math.max(stats.weight, save_record.record_weight or 0)
	save_record.record_length = math.max(stats.length, save_record.record_length or 0)
end

function FishAndChips.format_measurement(value, measurement, units)
	if not value then return ' ' end
	if units and units[measurement] then
		return string.format(localize(units[measurement].format), strip_decimals(nil, value/units[measurement].scale, units[measurement].precision or 2))
	end
	if measurement == 'weight' then
		if value > 10000 then
			return strip_decimals(nil, value / 1000, 1) .. 't'
		elseif value < 1 then
			return value*1000 .. 'g'
		else
			return value .. 'kg'
		end
	end
	if measurement == 'length' then
		if value > 10000 then
			return strip_decimals(nil, value / 1000, 1) .. 'km'
		elseif value < 1 then
			return value*100 .. 'cm'
		else
			return value .. 'm'
		end
	end
end

local create_card_hook = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	local card = create_card_hook(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	if card.ability.set == 'fac_Fish' and not card.ability.stats and (not area or area and not area.config.fac_compendium) then
		local stats = FishAndChips.create_card_stats or FishAndChips.create_fish_stats(card.config.center)		
		FishAndChips.modify_fish_stats(card, stats)
	end
	return card
end

local set_ability_hook = Card.set_ability
function Card:set_ability(...)
	local stats = self.ability and self.ability.stats
	set_ability_hook(self, ...)
	if self.ability.set == 'fac_Fish' and self.area and not self.area.config.fac_compendium then
		if stats then
			local new_base = self.config.center.stats
			stats.weight = strip_decimals(new_base.weight, new_base.weight.min + stats.w_prop * (new_base.weight.max - new_base.weight.min))
			stats.length = strip_decimals(new_base.length, new_base.length.min + stats.l_prop * (new_base.length.max - new_base.length.min))
		else
			stats = FishAndChips.create_fish_stats(self.config.center)
		end
		self.ability.stats = stats
		FishAndChips.modify_fish_stats(self, stats)
	end
end

local copy_card_hook = copy_card
function copy_card(...)
	local card = copy_card_hook(...)
	if card.ability.set == 'fac_Fish' then
		if not card.ability.stats then
			local stats = FishAndChips.create_fish_stats(card.config.center)
			card.ability.stats = stats
		end
		FishAndChips.modify_fish_stats(card, card.ability.stats)
	end
	return card
end

local load_hook = Card.load
function Card:load(...)
	load_hook(self, ...)
	if self.ability.set == 'fac_Fish' and self.ability.stats then FishAndChips.modify_fish_stats(self, self.ability.stats) end
end

FishAndChips.submission_weight_limit = 75
FishAndChips.fish_environment_limit = 6

G.C.SET.fac_Fish = FishAndChips.C.FISH
G.C.SECONDARY_SET.fac_Fish = FishAndChips.C.FISH

function FishAndChips.verify_submissions()
	local fac_count = 0
	local developer_ids = {}
	local contributors = {}
	local built_in_developers = {
		fac_Mack = true,
		fac_Snapper = true,
	}
	for _, id in ipairs(PotatoPatchUtils.Developer.obj_buffer) do
		local dev = PotatoPatchUtils.Developers[id]
		if dev.mod_id == 'FishAndChips' then
			assert(not developer_ids[id], 'Duplicate developer ID registered: ' .. id)
			developer_ids[id] = true
			if not built_in_developers[id] then
				fac_count = fac_count + 1
				contributors[#contributors + 1] = dev
			end
		end
	end
	assert(fac_count <= 2, 'Too many devs registered, submissions are limited to two participants.')
	if fac_count == 2 then
		local first, second = contributors[1], contributors[2]
		assert(
			first.fac_partner == second.key and second.fac_partner == first.key,
			'Two-person submissions must register each contributor as the other contributor\'s fac_partner.'
 	)
	end

	local devs = {}
	for _, fish in ipairs(G.P_CENTER_POOLS.fac_Fish) do
		devs[fish.ppu_coder[1]] = devs[fish.ppu_coder[1]] or {}
		table.insert(devs[fish.ppu_coder[1]], fish)
		local prefix = ""
		if not (fish.prefix_config and fish.prefix_config.ppu_coder == false) then
			prefix = "fac_"
		end
		local partner = PotatoPatchUtils.Developers[prefix .. fish.ppu_coder[1]].fac_partner
		if partner then
			-- print('Partner detected: ' .. partner)
			devs[partner] = devs[partner] or {}
			table.insert(devs[partner], fish)
		end
	end
	for dev, submission in pairs(devs) do
		local dev_obj = PotatoPatchUtils.Developers["fac_" .. dev]
		local total_weight = 0
		local treasure_fish_count = 0
		for _, fish in ipairs(submission) do
			total_weight = total_weight + fish.weight
			if fish.treasure then treasure_fish_count = treasure_fish_count + 1 end
			local in_envs = SMODS.table_size(fish.environments)
			assert(in_envs <= FishAndChips.fish_environment_limit or dev_obj.ignore_limits, "Fish " .. fish.key .. " is in " .. in_envs .. " environments when the limit is " .. FishAndChips.fish_environment_limit)
		end
		local scalar = math.min(1, FishAndChips.submission_weight_limit / total_weight)
			assert(not (scalar < 1) or dev_obj.ignore_limits, "Incorrect weight submission from " .. dev .. ": " .. total_weight)
			assert(treasure_fish_count <= 1 or dev_obj.ignore_limits, "More than one fish marked treasure = true from " .. dev .. "...only one per dev team is allowed")

		for _, fish in ipairs(submission) do
			fish.weight = fish.weight * scalar
			local unpack_env = function(environment)
				local values = {}
				for _, v in pairs(environment) do table.insert(values, v) end
				return unpack(values)
			end
			if next(fish.environments) then
				local max = math.max(unpack_env(fish.environments))
				for env, rate in pairs(fish.environments) do
					fish.attributes[env] = true
					SMODS.Attributes[env].keys = SMODS.merge_lists({ SMODS.Attributes[env].keys or {}, { fish.key } })
					fish.environments[env] = (rate / max) * fish.weight
				end
			end
			if fish.treasure then
				fish.attributes.fac_treasure = true
				SMODS.Attributes.fac_treasure.keys = SMODS.merge_lists({ SMODS.Attributes.fac_treasure.keys or {}, { fish.key } })
			end
		end
	end
end

function G.UIDEF.create_UIBox_your_collection_fish()
	local pool = {}
	for k, v in pairs(G.P_CENTER_POOLS.fac_Fish) do
		if not v.no_collection then pool[#pool + 1] = v end
	end
	return SMODS.card_collection_UIBox(pool, { 5, 5, 5 }, {
		no_materialize = true,
		h_mod = 0.95,
		back_func = 'your_collection_other_gameobjects',
	})
end

function G.FUNCS.fac_your_collection_fish(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu {
		definition = G.UIDEF.create_UIBox_your_collection_fish(),
	}
end

SMODS.UndiscoveredSprite {
	key = "fac_Fish",
	atlas = "soup",
	pos = { x = 0, y = 0 },
	no_overlay = true,
}
SMODS.UndiscoveredCompat.fac_Fish = true

SMODS.Shader {
	key = "hide_fish",
	path = "core/hide_fish.fs",
	send_vars = function(self, card)
		return {
			mask_colour = card and card.area and card.area.config.fac_compendium and FishAndChips.C.COMPENDIUM_COLOUR or {0,0,0,1}
		}
	end
}

-- fish outline
SMODS.DrawStep {
	key = "fac_hidden",
	order = 25,
	func = function(card, layer)
		if not card.config.center.discovered and (card.config.center.unlocked or card.area and card.area.config.fac_compendium) then
			if card.config.center.set == "fac_Fish" or card.config.center.set == "fac_Bait" or card.area and card.area.config.fac_compendium then
				card.children.center:draw_shader("fac_hide_fish", nil, card.ARGS.send_to_shader)
			end
		elseif card.config.center.set == "fac_Fish" and card.area and card.area.config.fac_compendium then
			local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[card.config.center_key] or {}
			if not (fish_data.times_caught and fish_data.times_caught > 0) then
				card.children.center:draw_shader("fac_hide_fish", nil, card.ARGS.send_to_shader)
			end
		end
	end
}

--#endregion


--#region Fish Utils

local card_highlight = Card.highlight
function Card:highlight(is_higlighted)
	if self.ability.set == "fac_Fish" then
		self.highlighted = is_higlighted
		if self.highlighted and self.area and self.area.config.type ~= "shop" then
			local x_off = (self.ability.consumeable and -0.1 or 0)
			self.children.use_button = UIBox {
				definition = G.UIDEF.use_and_sell_buttons(self),
				config = { align =
					self.area.config.align_buttons and "cr" or
					"bmi"
				, offset =
					self.area.config.align_buttons and { x = x_off - 0.4, y = 0 } or
					{ x = 0, y = 0.65 },
					parent = self }
			}
		elseif self.children.use_button then
			self.children.use_button:remove()
			self.children.use_button = nil
		end
		if self.children.select_button and not (self.highlighted and self.area and self.area.config.type ~= "shop") then
			self.children.select_button:remove(); self.children.select_button = nil
		end
		if G.STATE == G.STATES.FAC_FISHING then
			if self.config.center.requires_jokers then
				if self.highlighted then
					G.jokers.T.y = G.jokers.T.y + 15.25
					G.jokers.T.x = G.jokers.T.x + 1.5 - (self.config.center.requires_consumables and G.consumeables.T.w + 0.5 or 0)
				else
					G.jokers.T.y = G.jokers.T.y - 15.25
					G.jokers.T.x = G.jokers.T.x - 1.5 + (self.config.center.requires_consumables and G.consumeables.T.w + 0.5 or 0)
				end
			end
			if self.config.center.requires_consumables then
				if self.highlighted then
					G.consumeables.T.y = G.consumeables.T.y + 15.25
					G.consumeables.T.x = G.consumeables.T.x - 3.5
				else
					G.consumeables.T.y = G.consumeables.T.y - 15.25
					G.consumeables.T.x = G.consumeables.T.x + 3.5
				end
		
			end
		end
	else
		card_highlight(self, is_higlighted)
	end
end

--#endregion

--#region Fish Objects

-- FALLBACK FISH FOR EMPTY POOLS
local function all_env()
	local ret = {}
	for _, k in ipairs(FishAndChips.Environment.obj_buffer) do
		ret[k] = 10
	end
	return ret
end

FishAndChips.Fish {
	key = "test",
	weight = 10,
	ppu_artist = { "squeax09" },
	ppu_coder = { "Mack" },
	in_pool = function() return false end,
	no_collection = true,
	discovered = true,
	environments = all_env(),
	stats = {
		weight = {min = 1, max = 1},
		length = {min = 1, max = 1}
	},
}

--#endregion

--#region Silk Touch compat
if SilkTouch then
    --#region Drag targets
    SilkTouch.DragTarget{
        key = "fish_sell",
        moveable_t = "C_sell",
        text = function(card)
            local sell_loc = copy_table(localize('ml_sell_target'))
            sell_loc[#sell_loc+1] = localize('$')..card.sell_cost_label
            return sell_loc
        end,
        font = function(card)
            return {"default", "fac_sand_dollars"}
        end,
        colour = FishAndChips.C.SAND_DOLLAR,
        drag_condition = function(card)
            return card.area and (card.area == G.fac_fish_area or card.area == (G.FISHING or {}).fac_fish_reward_area or card.area == (G.FISHING or {}).fac_treasure_reward_area)
        end,
        active_check = function(card)
            return card:can_sell_card()
        end,
        release_func = function(card)
            G.FUNCS.sell_card{config = {ref_table = card}}
        end,
    }
    SilkTouch.DragTarget{
        key = "fish_use",
        moveable_t = "J_sell",
        text = function(card)
            return {type(card.config.center.button_key) == "function" and card.config.center:button_key(card)
				or type(card.config.center.button_key) == "string" and localize(card.config.center.button_key)
				or localize('b_use')}
        end,
        colour = G.C.ORANGE,
        drag_condition = function(card)
            return card.area and (card.area == G.fac_fish_area or card.area == (G.FISHING or {}).fac_fish_reward_area or card.area == (G.FISHING or {}).fac_treasure_reward_area) and card.config.center.use and true
        end,
        active_check = function(card)
            local temp_config = {UIBox = {states = {visible = false}}, config = {ref_table = card}}
            G.FUNCS.fac_can_use_fish(temp_config)
            return temp_config.config.button ~= nil
        end,
        release_func = function(card)
            G.FUNCS.fac_use_fish{config = {ref_table = card}}
        end,
    }
    --#endregion

    --#region Controller buttons
	local old_get_side = SilkTouch.ControllerButtons.sell.get_side
    local old_font = SilkTouch.ControllerButtons.sell.font
	local old_focus_condition = SilkTouch.ControllerButtons.sell.focus_condition
    SilkTouch.ControllerButton:take_ownership("sell",
    {
		get_side = function(card)
			local ret = old_get_side and old_get_side(card) or "left"
			if card.ability.set == 'fac_Fish' then
				ret = card:align_h_popup().type == "cl" and "right" or "left"
			end
			return ret
		end,
        font = function(card)
            local t = old_font and old_font(card) or {
                "default",
                {
                    "default",
                    "default"
                }
            }
            if card.ability.set == 'fac_Fish' then
                t[2][1] = "fac_sand_dollars"
            end
            return t
        end,
		focus_condition = function(card)
			return old_focus_condition(card) and card.area and not card.area.config.fac_bait_shop and not card.area.config.fac_bait_inventory
			and card.area ~= G.fac_bait_area and card.area ~= G.fac_rod_area
		end,
    },
    true)
	SilkTouch.ControllerButton{
		key = "fish_use",
		get_side = function(card)
			return card:align_h_popup().type == "cr" and "left" or "right"
		end,
		button_key = "rightshoulder",
		button_order = 0,
		text = function(card)
			return {
				type(card.config.center.button_key) == "function" and card.config.center:button_key(card)
				or type(card.config.center.button_key) == "string" and localize(card.config.center.button_key)
				or localize('b_use'),
				single_text = true,
			}
		end,
		text_scale = function() return {0.5} end,
		focus_condition = function(card)
			return card.area and (card.area == G.fac_fish_area or card.area == (G.FISHING or {}).fac_fish_reward_area or card.area == (G.FISHING or {}).fac_treasure_reward_area) and card.config.center.use and true
		end,
		active_check_cb = "fac_can_use_fish",
		press_func_cb = "fac_use_fish",
	}
	SilkTouch.ControllerButton{
		key = "bait_buy",
		get_side = function(card)
			return card:align_h_popup().type == "cr" and "left" or "right"
		end,
		button_key = "rightshoulder",
		button_order = 0,
		text = function(card)
			return {
				localize('b_buy'),
				single_text = true,
			}
		end,
		text_scale = function() return {0.5} end,
		focus_condition = function(card)
			return card.area and card.area.config.fac_bait_shop
		end,
		active_check_cb = "can_buy",
		press_func_cb = "buy_from_shop",
	}
    --#endregion
end
--#endregion