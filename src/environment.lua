--#region Environment Init
SMODS.Atlas({
	key = "background",
	path = "core/location_backgrounds.png",
	px = 560,
	py = 322,
})

FishAndChips.Environments = {}

local extension = {
	obj_table = FishAndChips.Environments,
	obj_buffer = {},
	set = 'fac_Env',
	prefix_config = { key = false },
	required_params = {
		'key',
		'generate_ui',
		'ppu_artist'
	},
	update = function() end,
	background_atlas = "fac_background",
	background_pos = { x = 0, y = 0 },
	collection_atlas = "fac_collection_background",
	collection_pos = { x = 0, y = 0 },
	pre_inject_class = function(self)
		G.FAC_ENVIRONMENTS = {}
		G.FAC_ENVIRONMENT_POOL = {}
	end,
	post_generate_ui = function() end,
	inject = function(self)
		G.FAC_ENVIRONMENTS[self.key] = self
		if not self.omit then SMODS.insert_pool(G.FAC_ENVIRONMENT_POOL, self) end
		SMODS.Attribute({key = self.key})--:inject()
		local self_generate_ui_ref = self.generate_ui
		self.generate_ui = function(_self)
			self_generate_ui_ref(_self)
			FishAndChips.draw_jimbo(_self)
			_self:post_generate_ui()
		end
	end,
}
---@class FishAndChips.Environment: SMODS.GameObject
FishAndChips.Environment = Object.extend(SMODS.GameObject)
for k, v in pairs(extension or {}) do
	FishAndChips.Environment[k] = v
end
table.insert(SMODS.GameObject.subclasses, 4, FishAndChips.Environment)
FishAndChips.Environment.subclasses = {}
--#endregion

--#region Environment Utils

--- Returns the current fishing environment
--- @return FishAndChips.Environment
function FishAndChips.get_environment()
	return FishAndChips.Environments[G.GAME.fac_fishing_environment]
end

function FishAndChips.is_environment_complete(environment)
    for _, k in ipairs(SMODS.get_attribute_pool(environment)) do
		local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[k] or {}
        if not (fish_data.times_caught and fish_data.times_caught > 0) and not G.P_CENTERS[k].no_collection then
			return false
		end
    end
	
	return true
end

-- --- Returns a `key` of the polled fish
-- ---@param _force_env: string?
function FishAndChips.poll_fish(_force_env)
	local fishing_active = G.STATE == G.STATES.FAC_FISHING
	_force_env = _force_env or FishAndChips.rod_function('force_environment')
	local fish_pool = SMODS.create_poll_pool({_force_env or G.GAME.fac_fishing_environment}, {types = {'fac_Fish'}})	
	
	fish_pool = FishAndChips.rod_function('modify_pool', fish_pool) or fish_pool
	local catch = SMODS.poll_object({pool = fish_pool, use_bait = fishing_active, current_env = _force_env or G.GAME.fac_fishing_environment})
	catch = FishAndChips.rod_function('modify_catch', catch) or catch
	return catch
end


SMODS.Attribute({key = 'fac_treasure'})
function FishAndChips.poll_treasure_fish()
	local fish_pool = SMODS.create_poll_pool({'fac_treasure'}, {types = {'fac_Fish'}})
	return SMODS.poll_object({pool = fish_pool, current_env = 'fac_treasure'})
end

local get_weight_of_object = SMODS.get_weight_of_object
function SMODS.get_weight_of_object(obj, opt_weight, args)
	if obj and obj.set == 'fac_Fish' and args.current_env then
		if args.current_env == 'fac_treasure' then
			local w = obj.treasure and 1 or 0
			return w, w
		elseif args.current_env == 'all' then
			local w = obj.weight or 0
			return w, w
		end
		local weight = obj.environments[args.current_env]
		if args.use_bait and G.GAME.fac_active_bait then
			local bait = G.P_CENTERS[G.GAME.fac_active_bait]
			local target_attributes = bait.target
			if type(target_attributes) == 'string' then target_attributes = {target_attributes} end
			for _, target_attribute in ipairs(target_attributes) do
				if SMODS.has_attribute(obj, target_attribute) then
					return weight, bait:boost_weight(weight)
				end
			end
		end
		return weight, weight
	end
	return get_weight_of_object(obj, opt_weight, args)
end
--#endregion

--#region Environment Objects

--Calm Pond
SMODS.Atlas {
	key = "calm_pond_waterfall",
	path = "core/calm pond/waterfall.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 5,
	frames = 3,
	px = 116,
	py = 172,
}

SMODS.Atlas {
	key = "calm_pond_sparkles",
	path = "core/calm pond/sparkles.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 494,
	py = 77
}

FishAndChips.Environment{
	key = "calm_pond",
	ambience = 'fac_ambience_calm_pond',
	colour = HEX('6ed4ae'),
	ppu_artist = {"GhostSalt"},
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.calm_pond_water_fall = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 116 / 71 * scale_w, G.CARD_H * 172 / 95 * scale_h, "fac_calm_pond_waterfall", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = 5.14, y = 0.172 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.calm_pond_sparkles = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 494 / 71 * scale_w, G.CARD_H * 77 / 95 * scale_h, "fac_calm_pond_sparkles", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bri",
				offset = { x = -0.2, y = -0.1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
}

--Canal District
SMODS.Atlas {
	key = "city_river_river",
	path = "core/city river/river.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 518,
	py = 195
}

SMODS.Atlas {
	key = "city_river_casino",
	path = "core/city river/casino.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 16,
	px = 116,
	py = 37
}

SMODS.Atlas {
	key = "city_river_smoker",
	path = "core/city river/smoker.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 4,
	px = 25,
	py = 53
}

FishAndChips.Environment {
	background_pos = { x = 2, y = 0 },
	key = "city_river",
	ambience = 'fac_ambience_canal_district',
	ppu_artist = {"GhostSalt"},
	colour = HEX('4a419a'),
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.city_river_river = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 518 / 71 * scale_w, G.CARD_H * 195 / 95 * scale_h, "fac_city_river_river", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bri",
				offset = { x = -0.18, y = -0.108 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.city_river_casino = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 116 / 71 * scale_w, G.CARD_H * 37 / 95 * scale_h, "fac_city_river_casino", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = 1.38, y = -3.09 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.city_river_smoker = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 25 / 71 * scale_w, G.CARD_H * 53 / 95 * scale_h, "fac_city_river_smoker", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = -5.92, y = -2.84 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
}

--Swamp
SMODS.Atlas {
	key = "swamp_mushes_a",
	path = "core/swamp/mushes a.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 2,
	frames = 8,
	px = 136,
	py = 66
}

SMODS.Atlas {
	key = "swamp_mushes_b",
	path = "core/swamp/mushes b.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 1.75,
	frames = 8,
	px = 171,
	py = 47
}

SMODS.Atlas {
	key = "swamp_mushes_c",
	path = "core/swamp/mushes c.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3.5,
	frames = 10,
	px = 103,
	py = 51
}

FishAndChips.Environment {
	background_pos = { x = 0, y = 1 },
	key = "swamp",
	ambience = 'fac_ambience_swamp',
	ppu_artist = {"GhostSalt"},
	colour = HEX('70c765'),
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.swamp_mushes_a = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 136 / 71 * scale_w, G.CARD_H * 66 / 95 * scale_h, "fac_swamp_mushes_a", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = -6.72, y = -2.08 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.swamp_mushes_b = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 171 / 71 * scale_w, G.CARD_H * 47 / 95 * scale_h, "fac_swamp_mushes_b", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = 4.33, y = -1.55 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.swamp_mushes_c = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 103 / 71 * scale_w, G.CARD_H * 51 / 95 * scale_h, "fac_swamp_mushes_c", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bri",
				offset = { x = -0.12, y = -0.1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
}

--Volcano
SMODS.Atlas {
	key = "volcano_bubbles",
	path = "core/volcano/bubbles.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 3,
	px = 515,
	py = 110
}

SMODS.Atlas {
	key = "volcano_smoke",
	path = "core/volcano/smoke.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 5,
	frames = 3,
	px = 192,
	py = 116
}

FishAndChips.Environment {
	background_pos = { x = 1, y = 1 },
	key = "volcano",
	ambience = 'fac_ambience_volcano',
	ppu_artist = {"GhostSalt"},
	colour = HEX('ff6d00'),
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.volcano_bubbles = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 515 / 71 * scale_w, G.CARD_H * 110 / 95 * scale_h, "fac_volcano_bubbles", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bri",
				offset = { x = -0.16, y = -0.08 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.volcano_smoke = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 192 / 71 * scale_w, G.CARD_H * 116 / 95 * scale_h, "fac_volcano_smoke", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "tri",
				offset = { x = -0.12, y = 0.105 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
}




--Cavern Aquifer
SMODS.Atlas {
	key = "aquifer_waves_a",
	path = "core/aquifer/waves a.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 163,
	py = 22
}

SMODS.Atlas {
	key = "aquifer_waves_b",
	path = "core/aquifer/waves b.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 311,
	py = 35
}

SMODS.Atlas {
	key = "aquifer_waves_c",
	path = "core/aquifer/waves c.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 58,
	py = 20
}

FishAndChips.Environment {
	background_pos = { x = 2, y = 1 },
	key = "aquifer",
	ambience = 'fac_ambience_cavern',
	ppu_artist = {"GhostSalt"},
	colour = HEX('419d46'),
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.aquifer_waves_a = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 163 / 71 * scale_w, G.CARD_H * 22 / 95 * scale_h, "fac_aquifer_waves_a", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cli",
				offset = { x = 0.105, y = 1.14 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.aquifer_waves_b = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 311 / 71 * scale_w, G.CARD_H * 35 / 95 * scale_h, "fac_aquifer_waves_b", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = 1.46, y = 0.76 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.aquifer_waves_c = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 58 / 71 * scale_w, G.CARD_H * 20 / 95 * scale_h, "fac_aquifer_waves_c", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cri",
				offset = { x = -0.105, y = 0.82 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
}




--Ocean Pier
SMODS.Atlas {
	key = "pier_ripples",
	path = "core/pier/ripples.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 424,
	py = 40
}

SMODS.Atlas {
	key = "pier_waves",
	path = "core/pier/waves.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 480,
	py = 161
}

SMODS.Atlas {
	key = "pier_overlay",
	path = "core/pier/pier.png",
	px = 121,
	py = 74
}

FishAndChips.Environment {
	background_pos = { x = 1, y = 0 },
	ppu_artist = { "DottyKitty" },
	key = "pier",
	ambience = 'fac_ambience_pier',
	colour = HEX('43c7ff'),
	water_bounds = {
		top = 0.92,
		bottom = 0.96
	},
	jimbo_offset = {
		x = 1.1,
		y = -1.85
	},
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.pier_ripples = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 424 / 71 * scale_w, G.CARD_H * 40 / 95 * scale_h, "fac_pier_ripples", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cli",
				offset = { x = 4.925, y = 4.26 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.pier_waves = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 480 / 71 * scale_w, G.CARD_H * 161 / 95 * scale_h, "fac_pier_waves", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = 1.36, y = 1.269 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
	post_generate_ui = function (self)
		local scale_w = 1.232
		local scale_h = 1.232
		G.FISHING.pier_overlay = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 121 / 71 * scale_w, G.CARD_H * 74 / 95 * scale_h, "fac_pier_overlay", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bli",
				offset = { x = 0.17, y = -0.1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end
}


--River Styx
SMODS.Atlas {
	key = "styx_crystal",
	path = "core/styx/crystal.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 6,
	frames = 20,
	px = 170,
	py = 121
}

SMODS.Atlas {
	key = "styx_ferryman",
	path = "core/styx/ferryman.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 2,
	frames = 7,
	px = 14,
	py = 9
}

SMODS.Atlas {
	key = "styx_waves",
	path = "core/styx/waves.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 3,
	frames = 3,
	px = 99,
	py = 32
}

FishAndChips.Environment {
	background_pos = { x = 1, y = 2 },
	key = "styx",
	ambience = 'fac_ambience_styx',
	ppu_artist = {"GhostSalt"},
	colour = HEX('2e7caf'),
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.crystal = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 170 / 71 * scale_w, G.CARD_H * 121 / 95 * scale_h, "fac_styx_crystal", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = 5.7, y = -2.95 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.ferryman = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 14 / 71 * scale_w, G.CARD_H * 9 / 95 * scale_h, "fac_styx_ferryman", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cmi",
				offset = { x = -6.75, y = -1.58 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.waves = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 99 / 71 * scale_w, G.CARD_H * 32 / 95 * scale_h, "fac_styx_waves", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bli",
				offset = { x = 0.1, y = -1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
}


--Chocolate River
SMODS.Atlas {
	key = "chocolate_river_close_part",
	path = "core/chocolate river/close part.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 3,
	px = 491,
	py = 209
}

SMODS.Atlas {
	key = "chocolate_river_mid_part",
	path = "core/chocolate river/mid part.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 3,
	px = 193,
	py = 78
}

SMODS.Atlas {
	key = "chocolate_river_far_part",
	path = "core/chocolate river/far part.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 3,
	px = 113,
	py = 29
}

FishAndChips.Environment {
	background_pos = { x = 2, y = 2 },
	key = "chocolate_river",
	ambience = 'fac_ambience_calm_pond',
	colour = HEX('a4615e'),
	ppu_artist = {"GhostSalt"},
	generate_ui = function(self)
		local scale_h = 1.232
		local scale_w = 1.232
		G.FISHING.close_part = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 491 / 71 * scale_w, G.CARD_H * 209 / 95 * scale_h, "fac_chocolate_river_close_part", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bri",
				offset = { x = -0.17, y = -0.1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.mid_part = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 193 / 71 * scale_w, G.CARD_H * 78 / 95 * scale_h, "fac_chocolate_river_mid_part", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "tmi",
				offset = { x = 3.65, y = 0.1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.far_part = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 113 / 71 * scale_w, G.CARD_H * 29 / 95 * scale_h, "fac_chocolate_river_far_part", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "tli",
				offset = { x = 0.1, y = 0.1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
	end,
}


-- The Soup

FishAndChips.Environment {
	background_pos = { x = 2, y = 3 },
	key = "soup",
	ambience = 'fac_ambience_soup',
	colour = HEX('ffc743'),
	ppu_artist = { "Gappie" },
	generate_ui = function(self)

	end,
}


-- Garden of Hope

FishAndChips.Environment {
	background_pos = { x = 0, y = 2 },
	key = "garden",
	ambience = 'fac_ambience_calm_pond',
	ppu_artist = { "Gappie" },
	colour = HEX('b5d55b'),
	jimbo_offset = {
		x = 0.9,
		y = -2.35
	},
	generate_ui = function(self)

	end,
}



--Wormhole
SMODS.Atlas {
	key = "wormhole_banana_ad",
	path = "core/Wormhole/banana_ad.png",
	px = 140,
	py = 119
}
SMODS.Atlas {
	key = "wormhole_other_ad",
	path = "core/Wormhole/other_ad.png",
	px = 191,
	py = 131
}
SMODS.Atlas {
	key = "wormhole_ledge_ad",
	path = "core/Wormhole/Ledge.png",
	px = 145,
	py = 111
}

SMODS.Atlas {
	key = "wormhole_hole",
	path = "core/Wormhole/Hole.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 3,
	px = 563,
	py = 326
}

SMODS.Atlas {
	key = "wormhole_potato",
	path = "core/Wormhole/Potato.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 3,
	px = 111,
	py = 89
}

SMODS.Atlas {
	key = "wormhole_rocket",
	path = "core/Wormhole/Rocket.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 3,
	px = 114,
	py = 56
}

local FAC_WORMHOLE_SCALE = 1.232
local FAC_WORMHOLE_PARKED = 100
local FAC_WORMHOLE_SPAWN_MARGIN = 0.4
local FAC_WORMHOLE_REST_CHANCE = 0.3
local FAC_WORMHOLE_MIN_GAP = 2
local FAC_WORMHOLE_ROCKET_WOBBLE_R = math.rad(8)
local FAC_WORMHOLE_ROCKET_WOBBLE_R_SPEED = 3.5
local FAC_WORMHOLE_ROCKET_WOBBLE_Y = 0.15
local FAC_WORMHOLE_ROCKET_WOBBLE_Y_SPEED = 2.2
local FAC_WORMHOLE_ROCKET_LOOP_CHANCE = 0.4
local FAC_WORMHOLE_POTATO_DEFAULT_FACING = math.rad(160)
local FAC_WORMHOLE_ROCKET_PATH = { duration = 9, from = { x = 0, y = 0 }, to = { x = 0, y = 0 }, start_time = -1e6 }
local FAC_WORMHOLE_POTATO_PATH = { duration = 12, from = { x = 0, y = 0 }, to = { x = 0, y = 0 }, start_time = -1e6 }

local function fac_wormhole_random_in_range(key, lo, hi)
	return lo + pseudorandom(key) * (hi - lo)
end

local function fac_wormhole_edge_x(fraction)
	local bg = G.FISHING.fishing
	if not bg then return 0 end
	return (bg.T.w / 2) * fraction
end

local function fac_wormhole_edge_y(fraction)
	local bg = G.FISHING.fishing
	if not bg then return 0 end
	return (bg.T.h / 2) * fraction
end
local function fac_wormhole_pick_layer(key)
	local roll = pseudorandom(key)
	if roll < 1 / 3 then
		return "under"
	elseif roll < 2 / 3 then
		return "over"
	else
		return "top"
	end
end

local function fac_wormhole_apply_size(sprite, mult)
	if not sprite or not sprite.fac_base_w then return end
	local w, h = sprite.fac_base_w * mult, sprite.fac_base_h * mult
	sprite.T.w, sprite.T.h = w, h
	sprite.fac_w, sprite.fac_h = w, h
end

local function fac_wormhole_create_flyer(name, atlas_key, px, py)
	if G.FISHING[name] then
		G.FISHING[name]:remove()
	end
	local sprite = SMODS.create_sprite(0, 0, G.CARD_W * px / 71 * FAC_WORMHOLE_SCALE, G.CARD_H * py / 95 * FAC_WORMHOLE_SCALE, atlas_key, { x = 0, y = 0 })
	sprite.fac_base_w = sprite.T.w
	sprite.fac_base_h = sprite.T.h
	G.FISHING[name .. "_sprite"] = sprite
	G.FISHING[name] = UIBox {
		definition = {
			n = G.UIT.ROOT,
			config = { colour = G.C.CLEAR },
			nodes = {
				{ n = G.UIT.O, config = { object = sprite } },
			},
		},
		config = {
			align = "cmi",
			offset = { x = FAC_WORMHOLE_PARKED, y = FAC_WORMHOLE_PARKED },
			major = G.FISHING.fishing,
			bond = "Glued",
		},
	}
end

local function fac_wormhole_update_rocket()
	local path = FAC_WORMHOLE_ROCKET_PATH
	local under, over, top = G.FISHING.wormhole_rocket_under, G.FISHING.wormhole_rocket_over, G.FISHING.wormhole_rocket_top
	if not under or not over or not top then return end
	local elapsed = G.TIMERS.REAL - path.start_time
	if elapsed >= path.duration then
		path.start_time = G.TIMERS.REAL
		elapsed = 0
		local should_start_flight = false
		if path.state == "flying" or path.state == nil then
			path.state = "cooldown"
			path.duration = FAC_WORMHOLE_MIN_GAP
		elseif path.state == "resting" then
			should_start_flight = true
		else
			if pseudorandom("fac_wormhole_rocket_rest") < FAC_WORMHOLE_REST_CHANCE then
				path.state = "resting"
				path.duration = fac_wormhole_random_in_range("fac_wormhole_rocket_rest_duration", 6, 14)
			else
				should_start_flight = true
			end
		end

		if should_start_flight then
			path.state = "flying"
			local left_x = fac_wormhole_edge_x(-1 - FAC_WORMHOLE_SPAWN_MARGIN)
			local right_x = fac_wormhole_edge_x(1 + FAC_WORMHOLE_SPAWN_MARGIN)
			if pseudorandom("fac_wormhole_rocket_dir") < 0.5 then
				path.from.x, path.to.x = left_x, right_x
			else
				path.from.x, path.to.x = right_x, left_x
			end
			path.y = fac_wormhole_random_in_range("fac_wormhole_rocket_y", fac_wormhole_edge_y(-0.6), fac_wormhole_edge_y(-0.1))
			path.layer = fac_wormhole_pick_layer("fac_wormhole_rocket_layer")
			path.duration = fac_wormhole_random_in_range("fac_wormhole_rocket_duration", 5.5, 9)
			local size = fac_wormhole_random_in_range("fac_wormhole_rocket_size", 0.75, 1.35)
			local target_sprite = G.FISHING["wormhole_rocket_" .. path.layer .. "_sprite"]
			fac_wormhole_apply_size(target_sprite, size)

			path.has_loop = pseudorandom("fac_wormhole_rocket_has_loop") < FAC_WORMHOLE_ROCKET_LOOP_CHANCE
			path.flight_duration = path.duration
			if path.has_loop then
				path.loop_progress = fac_wormhole_random_in_range("fac_wormhole_rocket_loop_at", 0.35, 0.65)
				local base_radius = fac_wormhole_random_in_range("fac_wormhole_rocket_loop_radius", 0.8, 1.6)
				path.loop_radius = base_radius * size
				local total_dx = math.abs(right_x - left_x)
				local loop_circumference = 2 * math.pi * path.loop_radius
				local speed = total_dx / path.flight_duration
				path.loop_time = math.min(loop_circumference / speed, 0.5 * path.flight_duration)
				path.loop_start = path.loop_progress * path.flight_duration
				path.duration = path.flight_duration + path.loop_time
			end
		end
	end
	if path.state ~= "flying" then
		under.alignment.offset.x, under.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		over.alignment.offset.x, over.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		top.alignment.offset.x, top.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		return
	end
	if path.layer == nil then path.layer = "over" end
	local slots = { under = under, over = over, top = top }
	local active = slots[path.layer]
	for name, box in pairs(slots) do
		if name ~= path.layer then
			box.alignment.offset.x, box.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		end
	end
	local facing_right = path.to.x > path.from.x
	local flight_duration = path.flight_duration or path.duration
	local in_loop = false
	local loop_theta = 0
	local flight_elapsed = elapsed
	if path.has_loop then
		local loop_end = path.loop_start + path.loop_time
		if elapsed < path.loop_start then
			flight_elapsed = elapsed
		elseif elapsed <= loop_end then
			in_loop = true
			flight_elapsed = path.loop_start
			loop_theta = (elapsed - path.loop_start) / path.loop_time * 2 * math.pi
		else
			flight_elapsed = elapsed - path.loop_time
		end
	end

	local flight_progress = math.min(flight_elapsed / flight_duration, 1)
	local base_x = path.from.x + (path.to.x - path.from.x) * flight_progress
	local base_y = path.y

	local rotation
	if in_loop then
		local dir_sign = facing_right and 1 or -1
		active.alignment.offset.x = base_x + path.loop_radius * dir_sign * math.sin(loop_theta)
		active.alignment.offset.y = base_y + path.loop_radius * (math.cos(loop_theta) - 1)
		rotation = facing_right and (math.pi - loop_theta) or loop_theta
	else
		active.alignment.offset.x = base_x
		active.alignment.offset.y = base_y + FAC_WORMHOLE_ROCKET_WOBBLE_Y * math.sin(G.TIMERS.REAL * FAC_WORMHOLE_ROCKET_WOBBLE_Y_SPEED)
		local base_rotation = facing_right and math.pi or 0
		local wobble = FAC_WORMHOLE_ROCKET_WOBBLE_R * math.sin(G.TIMERS.REAL * FAC_WORMHOLE_ROCKET_WOBBLE_R_SPEED)
		rotation = base_rotation + wobble
	end
	local sprite = G.FISHING["wormhole_rocket_" .. path.layer .. "_sprite"]
	if sprite then
		sprite.T.r = rotation
		sprite.fac_rotation = rotation
	end
end

local function fac_wormhole_update_potato()
	local path = FAC_WORMHOLE_POTATO_PATH
	local under, over, top = G.FISHING.wormhole_potato_under, G.FISHING.wormhole_potato_over, G.FISHING.wormhole_potato_top
	if not under or not over or not top then return end
	local elapsed = G.TIMERS.REAL - path.start_time
	if elapsed >= path.duration then
		path.start_time = G.TIMERS.REAL
		elapsed = 0
		local should_start_flight = false
		if path.state == "flying" or path.state == nil then
			path.state = "cooldown"
			path.duration = FAC_WORMHOLE_MIN_GAP
		elseif path.state == "resting" then
			should_start_flight = true
		else
			if pseudorandom("fac_wormhole_potato_rest") < FAC_WORMHOLE_REST_CHANCE then
				path.state = "resting"
				path.duration = fac_wormhole_random_in_range("fac_wormhole_potato_rest_duration", 8, 16)
			else
				should_start_flight = true
			end
		end

		if should_start_flight then
			path.state = "flying"
			local left_x, right_x = fac_wormhole_edge_x(-1), fac_wormhole_edge_x(1)
			path.from.x = fac_wormhole_random_in_range("fac_wormhole_potato_from_x", left_x, right_x)
			path.to.x = fac_wormhole_random_in_range("fac_wormhole_potato_to_x", left_x, right_x)
			path.from.y = fac_wormhole_edge_y(-1 - FAC_WORMHOLE_SPAWN_MARGIN)
			path.to.y = fac_wormhole_edge_y(1 + FAC_WORMHOLE_SPAWN_MARGIN)
			path.layer = fac_wormhole_pick_layer("fac_wormhole_potato_layer")
			path.duration = fac_wormhole_random_in_range("fac_wormhole_potato_duration", 7.5, 12)
			local size = fac_wormhole_random_in_range("fac_wormhole_potato_size", 0.7, 1.0)
			local target_sprite = G.FISHING["wormhole_potato_" .. path.layer .. "_sprite"]
			fac_wormhole_apply_size(target_sprite, size)
		end
	end
	if path.state ~= "flying" then
		under.alignment.offset.x, under.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		over.alignment.offset.x, over.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		top.alignment.offset.x, top.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		return
	end

	local progress = math.min(elapsed / path.duration, 1)
	if path.layer == nil then path.layer = "over" end

	local slots = { under = under, over = over, top = top }
	local active = slots[path.layer]
	for name, box in pairs(slots) do
		if name ~= path.layer then
			box.alignment.offset.x, box.alignment.offset.y = FAC_WORMHOLE_PARKED, FAC_WORMHOLE_PARKED
		end
	end

	local dx = path.to.x - path.from.x
	local dy = path.to.y - path.from.y
	active.alignment.offset.x = path.from.x + dx * progress
	active.alignment.offset.y = path.from.y + dy * progress
	local sprite = G.FISHING["wormhole_potato_" .. path.layer .. "_sprite"]
	if sprite then
		local rotation = math.atan2(dy, dx) - FAC_WORMHOLE_POTATO_DEFAULT_FACING
		sprite.T.r = rotation
		sprite.fac_rotation = rotation
	end
end

FishAndChips.Environment {
	ppu_artist = { "DottyKitty" },
	background_pos = { x = 0, y = 3 },
	key = "wormhole",
	ambience = 'fac_ambience_wormhole',
	colour = HEX('2f2c3f'),
	jimbo_offset = {
		x = 3,
		y = -2.75
	},
	update = function (self, dt)
		if G.FISHING then
			if G.FISHING.banana_ad then
				G.FISHING.banana_ad.alignment.offset.y = -2 - 0.1 * math.sin(G.TIMERS.REAL)
			end
			if G.FISHING.other_ad then
				G.FISHING.other_ad.alignment.offset.y = -0.2 - 0.1 * math.sin(G.TIMERS.REAL * 0.99 + 0.1)
			end
			fac_wormhole_update_rocket()
			fac_wormhole_update_potato()
		end
	end,
	generate_ui = function(self)
		local scale_h = FAC_WORMHOLE_SCALE
		local scale_w = FAC_WORMHOLE_SCALE
		G.FISHING.hole = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 563 / 71 * scale_w, G.CARD_H * 326 / 95 * scale_h, "fac_wormhole_hole", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bri",
				offset = { x = -0.17, y = -0.04 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		fac_wormhole_create_flyer("wormhole_rocket_under", "fac_wormhole_rocket", 114, 56)
		fac_wormhole_create_flyer("wormhole_potato_under", "fac_wormhole_potato", 111, 89)
		G.FISHING.banana_ad = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 140 / 71 * scale_w, G.CARD_H * 119 / 95 * scale_h, "fac_wormhole_banana_ad", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cli",
				offset = { x = 1, y = -2 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.FISHING.other_ad = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 191 / 71 * scale_w, G.CARD_H * 131 / 95 * scale_h, "fac_wormhole_other_ad", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "cri",
				offset = { x = -1, y = -0.2 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		fac_wormhole_create_flyer("wormhole_rocket_over", "fac_wormhole_rocket", 114, 56)
		fac_wormhole_create_flyer("wormhole_potato_over", "fac_wormhole_potato", 111, 89)
	end,
	post_generate_ui = function (self)
		local scale_w = FAC_WORMHOLE_SCALE
		local scale_h = FAC_WORMHOLE_SCALE
		G.FISHING.ledge_ad = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.O, config = { object = SMODS.create_sprite(0, 0, G.CARD_W * 145 / 71 * scale_w, G.CARD_H * 111 / 95 * scale_h, "fac_wormhole_ledge_ad", { x = 0, y = 0 }) } },
				},
			},
			config = {
				align = "bli",
				offset = { x = 0.17, y = -0.1 },
				major = G.FISHING.fishing,
				bond = "Glued",
			},
		}
		G.E_MANAGER:add_event(Event({
			func = function()
				fac_wormhole_create_flyer("wormhole_rocket_top", "fac_wormhole_rocket", 114, 56)
				fac_wormhole_create_flyer("wormhole_potato_top", "fac_wormhole_potato", 111, 89)
				return true
			end
		}))
	end
}


-- Backroom

FishAndChips.Environment {
	background_pos = { x = 1, y = 3 },
	key = "backroom",
	ambience = 'fac_ambience_backroom',
	ppu_artist = { "Gappie" },
	colour = HEX('a2bedc'),
	water_bounds = {
		top = 0.92,
		bottom = 0.96
	},
	jimbo_offset = {
		x = 1.6,
		y = -1
	},
	generate_ui = function(self)

	end,
}

--#endregion


