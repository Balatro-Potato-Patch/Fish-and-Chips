FishAndChips.vman2002 = {developer = PotatoPatchUtils.Developer({
	name = 'VMan_2002',
	atlas = 'fac_vman2002_fish',
	colour = G.C.BLUE,
	loc = "fac_dev_vman2002"
})}

SMODS.Atlas({
	key = "vman2002_fish",
	path = "vman2002/cards.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "vman2002_chips",
	path = "vman2002/chips_new.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "vman2002_manos",
	path = "vman2002/sinister.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "vman2002_blackbody",
	path = "vman2002/blackbody.png",
	px = 71,
	py = 95,
	atlas_table = "ANIMATION_ATLAS",
	frames = 5,
	fps = 6
})

SMODS.Atlas({
	key = "vman2002_manohands",
	path = "vman2002/allitthoughtabout.png", --casually ripped
	px = 131,
	py = 174,
})

SMODS.Sound({
	key = "vman2002_manosorry",
	path = "vman2002/manosorry.ogg"
})

SMODS.Sound({
	key = "vman2002_manoboom",
	path = "vman2002/manoboom.ogg"
})

FishAndChips.vman2002.slowmf = function(lol, speed)
	local x = G.SETTINGS.GAMESPEED
	G.SETTINGS.GAMESPEED = speed or 1
	lol()
	G.E_MANAGER:add_event(Event({
		func = function()
			G.SETTINGS.GAMESPEED = x
			return true
		end
	}))
end

local returnTrue = topuplib and topuplib.returnTrue or function() return true end

--#region Fish

local chips_col = {HEX("EBF6F8"), HEX("FD5F55"), HEX("55A383"), HEX("009CFD"), HEX("4F6367"), HEX("8A71E1"), HEX("E47C4C"), HEX("F2C255")}
FishAndChips.vman2002.chips_col = chips_col
FishAndChips.Fish { --Chips
	key = "vman2002_chips",
	atlas = "vman2002_chips",
	pos = { x = 0, y = 0 },
	weight = 6,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "xchips", "score" },--i did this knowingly
	pronouns = "they_them",
	config = {extra = {xchips = 1.3, score = 800}},
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
		local sc = G.SETTINGS.GRAPHICS.texture_scaling
		local rsc = FishAndChips.mod.config.performance_mode and 1 or sc
		if card.fac_chips_sprites ~= rsc then
			card.fac_chips_sprites = rsc
			if card.children.center.canvas then
				card.children.center.canvas:release()
			end
			local c = SMODS.CanvasSprite({X=card.T.x, Y=card.T.y, W=card.T.w, H=card.T.h, canvasScale = rsc})
			if rsc == 1 then
				c.canvas:setFilter("nearest")
			end
			c.role = card.children.center.role
			card.children.center = c
			love.graphics.push()
			love.graphics.origin()
			c.canvas:renderTo(function()
				local ps, rps, colcnt, zc, o_r, o_g, o_b, o_a, r_r, r_g, xa, ya = sc - 1, rsc - 1, #chips_col
				local imd = G.ASSET_ATLAS.fac_vman2002_chips.image_data
				local off = bit.lshift(71, ps)
				for x = 1, 70 do
					for y = 1, 94 do
						xa, ya, rxa, rya = bit.lshift(x, ps), bit.lshift(y, ps), bit.lshift(x, rps), bit.lshift(y, rps)
						--print("seek pixel ",xa,ya,xa+off)
						o_r, o_g, o_b, o_a = imd:getPixel(xa, ya)
						r_r, r_g = imd:getPixel(xa + off, ya)
						if r_g < 0.5 then
							zc = chips_col[(card.ability.unriggable.fac_chips_col[math.ceil(r_r * 10)] % colcnt) + 1]
							--print("seek chip col ",math.ceil(r_r * 10))
							love.graphics.setColor(o_r * zc[1], o_g * zc[2], o_b * zc[3], o_a)
						else
							love.graphics.setColor(o_r, o_g, o_b, o_a)
						end
						love.graphics.rectangle("fill", rxa, rya, rsc, rsc)
					end
				end
			end)
			love.graphics.pop()
		end
	end,
	in_pool = function()
		--because +score is so powerful in early antes
		local a = (G.GAME.fac_chips_attempts or 0) + 0.4
		G.GAME.fac_chips_attempts = a
		return a >= 4 - G.GAME.round_resets.ante
	end,
	impulse_min = 0.1,
	impulse_max = 0.2,
	decision_min = 0.4,
	decision_max = 0.6,
	badge_key = "k_fac_pkr_chips"
}

FishAndChips.Fish { --Trust
	key = "vman2002_trust",
	atlas = "vman2002_fish",
	pos = { x = 1, y = 0 },
	weight = 8,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "mod_chance" }, 
	config = {extra = {odds_add = 2}},
	stats = { weight = { min = 20*2, max = 21*2 }, length = {min = 0.17*1.8, max = 0.251*1.9}},
	environments = {
		calm_pond = 0.7, pier = 0.6
	},
	loc_vars = function(self, info_queue, card)
		local ex = card.ability.extra
		return { vars = { ex.odds_add, ex.odds_add + 1 } }
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
local manohands_quads, manohands_sprites, mano_rate_check = {}, {}
mano_rate_check = {0, {[false] = returnTrue, [true] = function()
	if mano_rate_check[1] == 7 then
		mano_rate_check[1] = 0
		return true
	end
	mano_rate_check[1] = mano_rate_check[1] + 1
end}, {[false] = 35, [true] = 8*35}}
FishAndChips.Fish { --Manos
	key = "vman2002_manos",
	atlas = "vman2002_manos",
	pos = { x = 0, y = 0 },
	weight = 3,
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
	_manohands_quads = manohands_quads,
	_manohands_sprites = manohands_sprites,
	stats = { length = { min = 3.8, max = 4.5 }, weight = {min = 600, max = 1100}},
	environments = {styx = 1},
	flavour_vars = function(self, info_queue, card)
		local manoline = 1
		local ex = card.ability.extra
		if ex.active then
			local rip = (os.clock() * 9) --no big deal
			manoline = (rip % 2 >= 1) and 2 or 3
			if rip % 9 > 7 then
				manoline = manoline + 2
			end
		end
		return {vars = {localize("fac_vman2002_manos" .. manoline)}}
	end,
	loc_vars = function(self, info_queue, card)
		local ex = card.ability.extra
		if not ex.active then
			info_queue[#info_queue+1] = {set = "Other", key = "eternal"}
		end
		return {
			vars = {
				69, --unused
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
				if next(context.poker_hands.Straight) and ex.straights_current < ex.straights_goal then
					SMODS.scale_card(card, {ref_value = "straights_current", no_message = true})
					c = true
				end
				if next(context.poker_hands.Flush) and ex.flushes_current < ex.flushes_goal then
					SMODS.scale_card(card, {ref_value = "flushes_current", no_message = true})
					c = true
				end
				return c and {message = tostring((ex.straights_goal + ex.flushes_goal) - (ex.straights_current + ex.flushes_current)), colour = G.C.RED} or nil
			end
			if context.after and ex.straights_current >= ex.straights_goal and ex.flushes_current >= ex.flushes_goal then
				SMODS.destroy_cards(card, {bypass_eternal = true})
				return {
					message = localize('fac_vman2002_manos_done'),
					sound = "fac_vman2002_manoboom",
					colour = G.C.RED,
					pitch = 1,
					func = function()
						FishAndChips.vman2002.manoboom_time = G.TIMERS.REAL
					end
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
		if not card.fac_manohands then
			local s = 0.014
			card.fac_manohands = {f = 0}
			if not next(manohands_quads) then
				for i = 0, 14 do
					manohands_quads[i] = love.graphics.newQuad(i * 131, 0, 131, 174, 1965, 174)
				end
				manohands_sprites[1] = {0, 0.3, s, s, 1, 0}
				manohands_sprites[2] = {2, 0.3, -s, s, 1, 0}
				for i = 1, 3 do
					local o = i*-0.5
					local a = 0.8-(i*0.2)
					table.insert(manohands_sprites, 1, {0, 2.4, s, -s, a, o})
					table.insert(manohands_sprites, 1, {2, 2.4, -s, -s, a, o})
				end
			end
		end
		prep_draw(card, 1)
		local mh = card.fac_manohands
		local pf = FishAndChips.mod.config.performance_mode
		if mano_rate_check[2][pf]() then
			local mx, my = love.graphics.inverseTransformPoint(love.mouse.getPosition())
			local xs = (math.floor(((math.atan2(mx - 0.6, my - 2.5) * todeg) + 112.5) * todeg2) % 8) + 1
			if card.children.center.sprite_pos_copy.x ~= xs then
				card.children.center:set_sprite_pos({x = xs, y = 0})
			end
			local fd = love.timer.getDelta() * mano_rate_check[3][pf]
			if mh.f < 4 then
				mh.f = mh.f + (0.255 * fd)
			elseif mh.f <= 7 then
				mh.f = mh.f + (0.755 * fd)
			else
				mh.f = (mh.f + (0.155 * fd)) % 15
			end
		end
		local hi = G.ASSET_ATLAS.fac_vman2002_manohands.image
		for k = pf and 5 or 1, 8 do
			local v = manohands_sprites[k]
			love.graphics.setColor(1,1,1,v[5])
			love.graphics.draw(hi, manohands_quads[math.floor(mh.f + v[6]) % 15], v[1], v[2], 0, v[3], v[4], 65, 0)
		end
		love.graphics.pop()
	end,
	use = function(self, card)
		local ex = card.ability.extra
		if not ex.active then
			ex.active = true
			FishAndChips.vman2002.slowmf(function() SMODS.calculate_effect({ message_card = card,
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
	weight = 5,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "editions" },
	stats = { weight = { min = 0.01, max = 0.09 }, length = {min = 0.4, max = 0.6}},
	environments = {
		pier = 0.6, city_river = 1
	},
	set_ability = function(self, card)
		if not card.edition then
			G.E_MANAGER:add_event(Event({
				blockable = false,
				func = function()
					local c = card.area and (card.area.config.collection or card.area.config.fac_compendium)
					card:set_edition(poll_edition("fac_vman2002_necklace", 1, false, true), c, c)
					return true
				end
			}))
		end
	end,
	treasure = true,
	blueprint_compat = false,
	badge_key = "k_fac_jewellery"
}

FishAndChips.Fish { --Coupon
	key = "vman2002_coupon",
	atlas = "vman2002_fish",
	pos = { x = 0, y = 1 },
	weight = 2,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "tag", "usable" },
	stats = { weight = { min = 0.02, max = 0.02 }, length = {min = 0.015*2, max = 0.021*2}},
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
	loc_vars = function(self, card)
		return {vars = {ppu_bubbles = {G.STATE == G.STATES.FAC_FISHING and "inactive" and "usable"}}}
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
	decision_max = 0.7,
	blueprint_compat = false,
	badge_key = "k_fac_coupon"
}

local tim = "fish_fac_vman2002_timothy"
FishAndChips.vman2002.timothyActive = function()
	return G.GAME.fac_last_used_fish == tim
end
FishAndChips.Fish { --Timothy
	key = "vman2002_timothy",
	atlas = "vman2002_fish",
	pos = { x = 1, y = 1 },
	weight = 4,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "xmult", "reset", "usable" },
	pronouns = "he_him",
	stats = { weight = { min = 21*6, max = 67*7 --[[i dont like 67 but it fits here]] }, length = {min = 0.17*4, max = 0.25*5}},
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
		return {vars = {ex.xmult, ex.xmult_gain, ppu_bubbles = {FishAndChips.vman2002.timothyActive() and "active" or "inactive"}}}
	end,
	flavour_vars = function(self, info_queue, card)
		return {vars = {localize(FishAndChips.vman2002.timothyActive() and "fac_vman2002_timothy_active" or "fac_vman2002_timothy_inactive")}}
	end,
	use = function(self, card)
		card.ability.extra.ante_used = true
		FishAndChips.vman2002.slowmf(function() SMODS.calculate_effect({ message_card = card,
			message = localize("fac_vman2002_timothy" .. (math.floor(os.clock() * 69420) % 8)),
			colour = G.C.RED,
			pitch = 1
		}, card) end)
	end,
	can_use = function(self, card)
		return not card.ability.extra.ante_used
	end,
	calculate = function(self, card, context)
		if context.ante_change and context.ante_end then
			card.ability.extra.ante_used = false
		end
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			if G.GAME.fac_last_used_fish ~= tim then
				if card.ability.extra.xmult > 1 then
					return SMODS.reset_card(card, {ref_value = "xmult", reset_value = 1, reset_message = {message_key = "fac_vman2002_timothy_reset"}})
				end
			else
				SMODS.scale_card(card, {ref_value = "xmult", scalar_value = "xmult_gain",})
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


FishAndChips.vman2002.blackbody_targets = function()
	local ret = {}
	for k,v in pairs(G.jokers.cards) do
		if not v.edition then
			table.insert(ret, v)
		end
	end
	return ret
end
FishAndChips.Fish { --Blackbody
	key = "vman2002_blackbody",
	atlas = "vman2002_blackbody",
	pos = { x = 0, y = 0 },
	weight = 3,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "usable", "editions", "xblindsize" },
	stats = { weight = { min = 0.4*5*4, max = 0.6618*5*4 }, length = {min = 0.015*12*4, max = 0.0234*12*4}},
	environments = {
		wormhole = 0.5, styx = 1, backroom = 0.4
	},
	config = {
		extra = {
			rounds = 0,
			rounds_goal = 8
		}
	},
	loc_vars = function(self, info_queue, card)
		local ex = card.ability.extra
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		return {vars = {ex.rounds, ex.rounds_goal, ppu_bubbles = {ex.rounds >= ex.rounds_goal and "usable" or "inactive"}}}
	end,
	use = function(self, card)
		local t = FishAndChips.vman2002.blackbody_targets()
		if not next(t) then return end
		pseudorandom_element(t, "fac_vman2002_blackbody"):set_edition("e_negative")
	end,
	can_use = function(self, card)
		return card.ability.extra.rounds >= card.ability.extra.rounds_goal and next(FishAndChips.vman2002.blackbody_targets())
	end,
	calculate = function(self, card, context)
		local ex = card.ability.extra
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			ex.rounds = ex.rounds + 1
			return {message = ex.rounds .. "/" .. ex.rounds_goal}
		end
	end,
	usable = true,
	blueprint_compat = true
}

FishAndChips.vman2002.navy_blade_usable = function(self, card)
	return card.ability.extra.uses < card.ability.extra.uses_max and (G.STATE == G.STATES.SELECTING_HAND or card.area.config.collection or card.area.config.fac_compendium)
end
FishAndChips.Fish { --Navy Blade
	key = "vman2002_navyblade",
	atlas = "vman2002_fish",
	pos = { x = 2, y = 1 },
	weight = 8,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "xblindsize", "usable", "economy", "reset" }, 
	config = {extra = {uses = 0, uses_max = 6, xblindsize = 1.2, dollars = 5}},
	stats = { weight = { min = 0.6*10, max = 0.6618*10.5 }, length = {min = 0.015*15, max = 0.0234*15.5}},
	environments = {
		aquifer = 0.9, swamp = 0.5
	},
	loc_vars = function(self, info_queue, card)
		local ex = card.ability.extra
		return {vars = {ex.uses, ex.uses_max, ex.xblindsize, ex.dollars, ppu_bubbles = {FishAndChips.vman2002.navy_blade_usable(self, card) and "usable" or "inactive"}}}
	end,
	can_use = FishAndChips.vman2002.navy_blade_usable,
	use = function(self, card)
		local ex = card.ability.extra
		ex.uses = ex.uses + 1
		SMODS.calculate_effect({ message_card = card,
			xblindsize = ex.xblindsize,
			dollars = ex.dollars
		}, card)
	end,
	calculate = function(self, card, context)
		if context.ante_change and context.ante_end and card.ability.extra.uses ~= 0 then
			card.ability.extra.uses = 0
			return {message = localize("k_reset")}
		end
	end,
	keep_on_use = returnTrue,
	usable = true,
	blueprint_compat = false
}

--i odnt have much time left i cba to finish this
--[[FishAndChips.fac_fuck_set = "fac_Fish"
local fuck = FishAndChips.Fish { --fuck
	key = "vman2002_fuck",
	atlas = "vman2002_fish",
	pos = { x = 1, y = 0 },
	weight = 7,
	ppu_coder = { "VMan_2002" },
	ppu_artist = { "VMan_2002" },
	attributes = { "usable" }, 
	config = {extra = 3, choose = 1},
	stats = { weight = { min = 0.6*10, max = 0.6618*10.5 }, length = {min = 0.015*15, max = 0.0234*15.5}},
	environments = {
		aquifer = 0.9, swamp = 0.5
	},
	can_use = function(self, card)
		return true
	end,
	use = function(self, card)
		card.ability.set = "Booster"
		card.cost = 0
		G.FUNCS.use_card({ config = { ref_table = card } })
	end,
	usable = true,
	blueprint_compat = false,
	create_card = function(self, card)
		return {set = FishAndChips.fac_fuck_set, area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "unique_string_for_rng", edition = "e_foil"}
	end
}

for k,v in pairs({"update_pack", "ease_background_colour", "create_UIBox"}) do
	fuck[v] = SMODS.Booster[v]
end]]

--#endregion
