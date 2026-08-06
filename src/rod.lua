--#region Rod Init

---@class FishAndChips.Rod: SMODS.Center
FishAndChips.Rod = SMODS.Center:extend {
	unlocked = true,
	discovered = false,
	pos = { x = 0, y = 0 },
	locked_pos = { x = 2, y = 2 },
	atlas = "fac_rods",
	cost = 8,
	set = "fac_Rod",
	class_prefix = "rod",
	required_params = {
		"key",
	},
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_rod"), FishAndChips.C.ROD, G.C.WHITE, 1.2)
	end,
	inject = function(self)
		self.config = self.config or {}
		self.config.fishing = self.config.fishing or {}
		SMODS.Center.inject(self)
	end,
}
G.C.SET.fac_Rod = FishAndChips.C.ROD
G.C.SECONDARY_SET.fac_Rod = FishAndChips.C.ROD

function G.UIDEF.create_UIBox_your_collection_rods()
	local pool = {}
	for k, v in pairs(G.P_CENTER_POOLS.fac_Rod) do
		if not v.no_collection then pool[#pool + 1] = v end
	end
	return SMODS.card_collection_UIBox(pool, { 4, 4 }, {
		no_materialize = true,
		h_mod = 0.95,
		back_func = 'your_collection_other_gameobjects',
	})
end

function G.FUNCS.fac_your_collection_rods(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu {
		definition = G.UIDEF.create_UIBox_your_collection_rods(),
	}
end

--#endregion

--#region Rod Utils

--- Gets the current rod center, or wooden if there is none
--- @return FishAndChips.Rod
--- @return Card|nil
function FishAndChips.get_rod()
	local rod = G.fac_rod_area.cards[1]
	if not rod then return G.P_CENTERS.rod_fac_wooden end
	return rod.config.center, rod
end

--- call the given method on the currently owned fishing rod
---@param method any the method to call, if it exists
---@param ... any arguments for the method (excluding the card)
function FishAndChips.rod_function(method, ...)
	local center, rod = FishAndChips.get_rod()
	if center[method] and type(center[method]) == "function" then
		return center[method](center, rod, ...)
	end
end

--#endregion

--#region Rod Objects

FishAndChips.Rod {
	key = "wooden",
	discovered = true,
	ppu_artist = { "DottyKitty" },
}

FishAndChips.Rod {
	key = "fiberglass",
	pos = { x = 1, y = 0 },
	unlocked = false,
	check_for_unlock = function(self, args)
		return args.type == "fac_tutorial"
	end,
	config = {
		fishing = {
			bar_size = 0.34,
			catch_gain = 0.12
		}
	},
	ppu_coder = { "Foo54" },
	ppu_artist = { "GhostSalt" }
}

FishAndChips.Rod {
	key = "carbon",
	pos = { x = 2, y = 0 },
	unlocked = false,
	check_for_unlock = function(self, args)
		return args.type == "fac_tutorial"
	end,
	config = {
		fishing = {
			bar_size = 0.18,
			catch_gain = 0.46
		}
	},
	ppu_coder = { "Foo54" },
	ppu_artist = { "GhostSalt" }
}

FishAndChips.Rod {
	key = "glimmering",
	ppu_artist = { "DottyKitty" },
	pos = { x = 0, y = 1 },
	bait_bonus = 2,
	unlocked = false,
	check_for_unlock = function(self, args)
		if args.type == "fac_fish_caught" then
			for _, v in pairs(G.P_CENTER_POOLS.fac_Bait) do
				if not G.PROFILES[G.SETTINGS.profile].fac_fishing.baits_used[v.key] then
					return false
				end
			end
			return true
		end
	end
}

FishAndChips.Rod {
	key = "extradimensional",
	ppu_artist = { "squeax09" },
	pos = { x = 1, y = 1 },
	unlocked = false,
	additional_pools = {
		"Joker", "Consumeables"
	},
	check_for_unlock = function(self, args)
		if args.type == "fac_fish_caught" then
			return ((G.PROFILES[G.SETTINGS.profile].fac_fishing.career_fish_caught) >= 50)
		end
	end,
	modify_pool = function(self, card, pool)
		if true or pseudorandom("fac_extradimensional") < 0.125 then
			local to_add = SMODS.create_poll_pool(self.additional_pools, {})
			return SMODS.merge_lists({ pool, to_add })
		end
	end
}

FishAndChips.Rod {
	key = "lucky",
	pos = { x = 2, y = 1 },
	ppu_artist = { "DottyKitty" },
	unlocked = false,
	check_for_unlock = function(self, args)
		return args.type == "fac_treasure" and args.value >= 10
	end,
	config = {
		extra = {
			num = 1,
			dem = 2,
			money = 3
		}
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.dem, "fac_lucky_rod")
		return { vars = { num, dem, card.ability.extra.money } }
	end,
	on_catch = function(self, card, key)
		if SMODS.pseudorandom_probability(card, "fac_lucky_rod", card.ability.extra.num, card.ability.extra.dem) then
			ease_dollars(card.ability.extra.money)
		end
	end,
	ppu_coder = { "Foo54" }
}

FishAndChips.Rod {
	key = "distortion",
	ppu_artist = { "squeax09" },
	pos = { x = 0, y = 2 },
	unlocked = false,
	check_for_unlock = function(self, args)
		if args.type == "fac_fish_caught" then
			for _, v in pairs(G.FAC_ENVIRONMENT_POOL) do
				if not G.PROFILES[G.SETTINGS.profile].fac_fishing.environments_fished[v.key] then
					return false
				end
			end
			return true
		end
	end,
	force_environment = function(self, card, args)
		if pseudorandom("fac_distortion") < 0.25 then
			return pseudorandom_element(FishAndChips.Environments, "fac_distorition_poll", {
				in_pool = function(v, _args)
					return v ~= FishAndChips.CurrentFishingPool
				end
			}).key
		end
	end
}

FishAndChips.Rod {
	key = "harpoon",
	pos = { x = 1, y = 2 },
	unlocked = false,
	check_for_unlock = function(self, args)
		return args.type == "fac_perfect_catches" and args.value >= 5
	end,
	config = {
		fishing = {
			catch_loss = 0,
			catch_gain = 0,
			bar_size = 0.05
		}
	},
	ppu_coder = { "Foo54" }
}
--#endregion
