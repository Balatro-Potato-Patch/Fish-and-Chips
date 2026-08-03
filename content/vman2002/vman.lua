PotatoPatchUtils.Developer({
	name = 'VMan_2002',
	atlas = 'fac_vman2002_fish',
	colour = G.C.BLUE,
	loc = "fac_dev_vman2002"
})

SMODS.Atlas({
	key = "vman2002_fish", -- Please include your name/team name in your atlas keys
	path = "vman2002/cards.png",
	px = 71,
	py = 95,
})

local chips_atlas = SMODS.Atlas({
	key = "vman2002_chips", -- Please include your name/team name in your atlas keys
	path = "vman2002/chips.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "vman2002_manos", -- Please include your name/team name in your atlas keys
	path = "vman2002/sinister.png",
	px = 71,
	py = 95,
})

SMODS.Sound({
	key = "vman2002_manosorry",
	path = "vman2002/manosorry.ogg"
})

local function slowmf(lol)
	local x = G.SETTINGS.GAMESPEED
	G.SETTINGS.GAMESPEED = 1
	lol()
	G.E_MANAGER:add_event(Event({
		func = function()
			G.SETTINGS.GAMESPEED = x
			return true
		end
	}))
end

fac_topuplib_inspect = topuplib and topuplib.inspect or function(name, value) --TODO: this is temporary (this is from topuplib, which has an incompatibility rn)
	if not value then
		value = name
		name = "var"
	end
	fac_topuplib_inspectedvalue = value
	local t = type(value)
	if t == "table" then
		local r = {}
		local keys = {}
		for k, v in pairs(value) do
			r[#r + 1] = tostring(k)..": "..type(v).." "..tostring(v)
			keys[#keys + 1] = tostring(k)
		end
		print(name .. ": " .. tostring(value) .. ", table with length " .. #value .. " and " .. tostring(r).." keys")
		print("inspect: {" .. table.concat(r, ", ") .. "}")
		print("keys: {" .. table.concat(keys, ", ") .. "}")
	else
		print(name .. ": " .. tostring(value) .. " of type " .. t)
	end
end

local returnTrue = topuplib and topuplib.returnTrue or function() return true end

--#region Fish

local chips_col = {HEX("EBF6F8"), HEX("FD5F55"), HEX("55A383"), HEX("009CFD"), HEX("4F6367"), HEX("8A71E1"), HEX("E47C4C"), HEX("F2C255")}
FishAndChips.Fish { --Chips
	key = "vman2002_chips",
	atlas = "vman2002_chips",
	pos = { x = 0, y = 0 },
	weight = 6,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "xchips", "score" },
	pronouns = "they_them",
	config = {
		extra = {
			xchips = 1.3,
			score = 800
		}
	},
	stats = { weight = { min = 0.19, max = 0.2 }, length = {min = 0.051, max = 0.101}},
	environments = {
		backroom = 0.7, city_river = 0.4
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips, card.ability.extra.score } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { x_chips = card.ability.extra.xchips, score = card.ability.extra.score } end
	end,
	set_ability = function(self, card)
		if not (card.ability.unriggable and card.ability.unriggable.fac_chips_col) then
			card.ability.unriggable = card.ability.unriggable or {}
			card.ability.unriggable.fac_chips_col = card.ability.unriggable.fac_chips_col or {}
			local s = os.time() - math.floor(os.clock() * 100) % 7e4
			while #card.ability.unriggable.fac_chips_col ~= 5 do
				s = (s * 43) % 46217
				table.insert(card.ability.unriggable.fac_chips_col, (s % #chips_col) + 1)
			end
		end
	end,
	draw = function(self, card, layer)
		if not card.fac_chips_sprites then
			card.fac_chips_sprites = {}
			for i = 1, 5 do
				--TODO: someone fix the sprite alignment positioning stuff (i'm not gonna. i would if i knew how)
				local s = Sprite(card.VT.x, card.VT.y, card.VT.w, card.VT.h, chips_atlas, {x=6-i, y=0})
				s.T = card.T
				s.role.draw_major.tilt_var = card.children.center.role.draw_major.tilt_var
				card.fac_chips_sprites[i] = s
			end
		end
		for i = 1, 5 do
			card.fac_chips_sprites[i]:draw_self(chips_col[card.ability.unriggable.fac_chips_col[i]])
		end
		card.children.center:draw_shader('dissolve')
	end,
	impulse_min = 0.1,
	impulse_max = 0.2,
	decision_min = 0.4,
	decision_max = 0.6
}

FishAndChips.Fish { --Trust
	key = "vman2002_trust",
	atlas = "vman2002_fish",
	pos = { x = 1, y = 0 },
	weight = 8,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "xchips", "score" },
	config = {
		extra = {
			odds_add = 2
		}
	},
	stats = { weight = { min = 0.01, max = 0.02 }, length = {min = 0.01, max = 0.02}}, --TODO: Stats
	environments = {
		city_river = 0.4, pier = 0.6
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.odds_add } }
	end,
    calculate = function(self, card, context)
		if context.mod_probability and G.GAME.fac_trust_active and G.GAME.current_round.hands_played == 0 then
			return {numerator = context.numerator + card.ability.extra.odds_add}
		end
    end,
	impulse_min = 0.1,
	impulse_max = 0.3,
	decision_min = 0.7,
	decision_max = 0.8
}

local todeg, todeg2 = 180/math.pi, 8/360
FishAndChips.Fish { --Manos
	key = "vman2002_manos",
	atlas = "vman2002_manos",
	pos = { x = 0, y = 0 },
	weight = 2,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "usable", "retrigger", "destroy_card", "self_eternal" },
	config = {
		extra = {
			active = false,
			straights_current = 0,
			straights_goal = 8,
			flushes_current = 0,
			flushes_goal = 8,
			repetitions = 1
		}
	},
	stats = { weight = { min = 0.01, max = 0.02 }, length = {min = 0.01, max = 0.02}}, --TODO: Stats
	environments = {
		styx = 1
	},
	loc_vars = function(self, info_queue, card)
		local manoline = 1
		local ex = card.ability.extra
		if ex.active then
			local rip = (os.clock() * 9)
			manoline = (rip % 2 >= 1) and 2 or 3
			if rip % 9 > 7 then
				manoline = manoline + 2
			end
		else
			info_queue[#info_queue+1] = {set = "Other", key = "eternal"}
		end
		return {
			vars = {
				localize("fac_vman2002_manos" .. manoline),
				ex.straights_current,
				ex.straights_goal,
				ex.flushes_current,
				ex.flushes_goal,
				ex.repetitions,
				colours = {G.C.ETERNAL}
			},
			key = ex.active and "fish_fac_vman2002_manos_active" or G.PROFILES[G.SETTINGS.profile].fac_manos_known and "fish_fac_vman2002_manos_known" or nil,
		}
	end,
	calculate = function(self, card, context)
		local ex = card.ability.extra
		if not ex.active then return end
		if not context.blueprint then
			if context.joker_main then
				local c = false
				fac_topuplib_inspect(context)
				if next(context.poker_hands.Flush) and ex.flushes_current < ex.flushes_goal then
					SMODS.scale_card(card, {ref_value = "flushes_current", no_message = true})
					c = true
				end
				if next(context.poker_hands.Straight) and ex.straights_current < ex.straights_goal then
					SMODS.scale_card(card, {ref_value = "straights_current", no_message = true})
					c = true
				end
				return c and {message = tostring((ex.straights_goal + ex.flushes_goal) - (ex.straights_current + ex.flushes_current)), colour = G.C.RED} or nil
			end
			if context.after and ex.straights_current >= ex.straights_goal and ex.flushes_current >= ex.flushes_goal then
				SMODS.destroy_cards(card, {bypass_eternal = true})
				return {
					message = localize('fac_vman2002_manos_done'),
					colour = G.C.RED
				}
			end
			if G.GAME.current_round.hands_played == 0 then
				return (context.cardarea == G.play or context.cardarea == "unscored") and context.destroy_card and {remove = true} or nil
			end
		end
		if G.GAME.current_round.hands_played == 1 then
			return context.repetition and context.cardarea == G.play and {repetitions = ex.repetitions} or nil
		end
	end,
	draw = function(self, card)
		if not card.ability.extra.active then return end
		prep_draw(card, 1)
		local mx, my = love.graphics.inverseTransformPoint(love.mouse.getPosition())
		local xs = (math.floor(((math.atan2(mx - 0.6, my - 2.5) * todeg) + 112.5) * todeg2) % 8) + 1
		if card.children.center.sprite_pos_copy.x ~= xs then
			card.children.center:set_sprite_pos({x = xs, y = 0})
		end
		love.graphics.pop()
	end,
	use = function(self, card)
		local ex = card.ability.extra
		if not ex.active then
			ex.active = true
			slowmf(function() SMODS.calculate_effect({ message_card = card,
				message = localize("fac_vman2002_manosorry"),
				sound = "fac_vman2002_manosorry",
				colour = G.C.RED,
				pitch = 1
			}, card) end)
			card:add_sticker("eternal", true)
			G.PROFILES[G.SETTINGS.profile].fac_manos_known = true
		end
	end,
	can_use = function(self, card)
		return (G.GAME.current_round.hands_played == 0 or G.STATE ~= G.STATES.SELECTING_HAND) and not card.ability.extra.active
	end,
	keep_on_use = returnTrue,
	usable = true,
	impulse_min = 0.3,
	impulse_max = 0.4,
	decision_min = 0.1,
	decision_max = 0.4
}

FishAndChips.Fish { --Necklace
	key = "vman2002_necklace",
	atlas = "vman2002_fish",
	pos = { x = 2, y = 0 },
	pixel_size = {w=68,h=68},
	weight = 2,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "editions" },
	stats = { weight = { min = 0.01, max = 0.09 }, length = {min = 0.4, max = 0.6}},
	environments = {
		pier = 0.6, city_river = 1, backroom = 0.3, garden = 0.8
	},
	set_ability = function(self, card)
		if not card.edition then
			card:set_edition(poll_edition("fac_vman2002_necklace", 1, false, true))
		end
	end,
	treasure = true
}

FishAndChips.Fish { --Coupon
	key = "vman2002_coupon",
	atlas = "vman2002_fish",
	pos = { x = 0, y = 1 },
	weight = 1,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "tag" },
	stats = { weight = { min = 0.02, max = 0.02 }, length = {min = 0.015, max = 0.021}},
	environments = {
		wormhole = 1, pier = 0.9
	},
	use = function(self, card)
		local possible = {}
		for k,v in pairs(SMODS.get_attribute_pool("editions")) do
			if G.P_TAGS[v] then
				table.insert(possible, v)
			end
		end
		add_tag({key = pseudorandom_element(possible, "fac_vman2002_coupon")})
	end,
	can_use = function()
		return G.STATE ~= G.STATES.FAC_FISHING
	end,
	draw = function(self, card)
		if card.config.center.discovered or card.bypass_discovery_center then
			card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
		end
	end,
	usable = true,
	impulse_min = 0.2,
	impulse_max = 0.6,
	decision_min = 0.3,
	decision_max = 0.7
}

local tim = "fish_fac_vman2002_timothy"
FishAndChips.Fish { --Timothy
	key = "vman2002_timothy",
	atlas = "vman2002_fish",
	pos = { x = 1, y = 1 },
	weight = 4,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "xmult", "reset", "usable" },
	stats = { weight = { min = 0.21, max = 0.67 --[[i dont like 67 but it fits here]] }, length = {min = 0.017, max = 0.025}},
	environments = {
		calm_pond = 0.5, pier = 0.9
	},
	config = {
		extra = {
			ante_used = false,
			xmult = 1,
			xmult_gain = 0.2
		}
	},
	loc_vars = function(self, info_queue, card)
		local ex = card.ability.extra
		return {vars = {ex.xmult, ex.xmult_gain, localize(G.GAME.fac_last_used_fish == tim and "fac_vman2002_timothy_active" or "fac_vman2002_timothy_inactive")}}
	end,
	use = function(self, card)
		card.ability.extra.ante_used = true
		slowmf(function() SMODS.calculate_effect({ message_card = card,
			message = localize("fac_vman2002_timothy" .. (math.floor(os.clock() * 69420) % 6)),
			colour = G.C.RED,
			pitch = 1
		}, card) end)
	end,
	can_use = function(self, card)
		return not card.ability.extra.ante_used
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if G.GAME.fac_last_used_fish ~= tim then
				if card.ability.extra.xmult > 1 then
					card.ability.extra.xmult = 1
					return {message = localize('fac_vman2002_timothy_reset')}
				end
			else
				SMODS.scale_card(card, {
					ref_value = "xmult", -- the key to the value in the ref_table
					scalar_value = "xmult_gain", -- the key to the value to scale by, in the ref_table by default
				})
			end
			return
		end
		if context.joker_main then
			return {xmult = card.ability.extra.xmult}
		end
	end,
	keep_on_use = returnTrue,
	usable = true,
	impulse_min = 0.4,
	impulse_max = 0.8,
	decision_min = 0.3,
	decision_max = 0.7
}

--#endregion
