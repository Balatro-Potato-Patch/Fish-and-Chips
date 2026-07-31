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
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize(card.config.center.badge_key or "k_fac_fish"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
	post_inject_class = function(self)
		FishAndChips.verify_submissions()
	end
}
FishAndChips.submission_weight_limit = 75

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
			first.fac_partner == second.name and second.fac_partner == first.name,
			'Two-person submissions must register each contributor as the other contributor\'s fac_partner.'
		)
	end

	local devs = {}
	-- TODO: handle duo submissions
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
		end
		local scalar = math.min(1, FishAndChips.submission_weight_limit / total_weight)
		if submission.mod == FishAndChips.mod then
			assert(not (scalar < 1) or dev_obj.ignore_limits, "Incorrect weight submission from " .. dev .. ": " .. total_weight)
			assert(treasure_fish_count <= 1 or dev_obj.ignore_limits, "More than one fish marked treasure = true from " .. dev .. "...only one per dev team is allowed")
		end
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
			mask_colour = card.area.config.fac_compendium and FishAndChips.C.COMPENDIUM_COLOUR or {0,0,0,1}
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
}

--#endregion
