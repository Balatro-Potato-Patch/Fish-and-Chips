-- TODO: Port all uses of set_card_type_badge to badge_key
FishAndChips.Fish {
	key = "tss_chesh",
	atlas = "tss_ellefish",
	pos = { x = 2, y = 0 },
	weight = 5,
	stats = {weight = {min = 250, max = 350}, length = {min = 2.5, max = 3.5}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "xmult", "destroy_card", "scaling", "chance", },
	config = { extra = { xmult = 1, xmult_mod = .5, odds = 4 } },
	environments = {
		backroom = 5,
		wormhole = 2,
		styx = 2
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_tss_chesh")
		return { vars = { num, dem, card.ability.extra.xmult_mod, card.ability.extra.xmult } }
	end,
	locked_loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.fish_fac_tss_resident
		return {}
	end,
	calculate = function(self, card, context)
		-- Chesh eating handled in dev calculate so they can all flock at once like hungry pirahnas
		if context.joker_main and card.ability.extra.xmult ~= 1 then return { xmult = card.ability.extra.xmult } end
	end,
	set_card_type_badge = function(self, card, badges) -- TODO: Make its own loc_key
		badges[#badges + 1] = create_badge('"'..localize("k_fac_fish")..'"', FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
}

local emplace_hook = CardArea.emplace
function CardArea:emplace(card, ...)
	emplace_hook(card.tss_cheshed and G.FISHING.fac_fish_reward_area or self,card, ...)
end

FishAndChips.Fish {
	key = "tss_resident",
	atlas = "tss_ellefish",
	pos = { x = 1, y = 0 },
	weight = 13,
	stats = {weight = {min = 75, max = 100}, length = {min = 1, max = 1.75}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "mult", "scaling", },
	config = { extra = { mult = 0, mult_mod = 2 } },
	environments = {
		city_river = 1,
		backroom = 4,
		styx = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
		    SMODS.scale_card(card, {
				ref_value = "mult",
				scalar_value = "mult_mod",
			})
		end

		if context.joker_main then return { mult = card.ability.extra.mult } end
	end
}

local function create_guppy_uibox(key)
	G.OVERLAY_MENU = true
	local d = G.P_CENTERS[key].discovered
	local fish = SMODS.create_card({key = key, discover = false, bypass_discovery_center = false})
	G.P_CENTERS[key].discovered = d
	G.OVERLAY_MENU = false
	fish:juice_up()
	fish.states.drag.can = false
	fish.states.click.can = false
	fish.states.hover.can = false
	fish:hover()
	FishAndChips.TheShitSquad.guppy_fish = fish
	return UIBox{definition={n=G.UIT.ROOT, config={colour=G.C.CLEAR}, nodes = {
		{n = G.UIT.O, config = {object=fish}}
	}},config={major = G.fac_bait_area, align = "cr", offset = { x = 1.6, y = 0 }, instance_type = 'CARD'}}
end

FishAndChips.Fish {
	key = "tss_guppy",
	atlas = "tss_ellefish",
	pos = { x = 2, y = 1 },
	weight = 3,
	stats = {weight = {min = .03, max = .08}, length = {min = .03, max = .04}}, -- actual size range of guppies
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "passive" },
	environments = {
		styx = 5,
		city_river = 3
	},
	calculate = function(self, card, context)
		if not context.retrigger_joker and not context.blueprint then
			if context.fac_fish_hooked and not FishAndChips.TheShitSquad.guppy_ui then
				FishAndChips.TheShitSquad.guppy_ui = create_guppy_uibox(context.fac_fish_hooked)
			end
			if context.fac_end_fishing and FishAndChips.TheShitSquad.guppy_ui then
				FishAndChips.TheShitSquad.guppy_fish:juice_up()
				local a = FishAndChips.TheShitSquad.guppy_fish.config.center_key
				FishAndChips.TheShitSquad.guppy_fish:start_dissolve()
				G.E_MANAGER:add_event(Event({func = function()
					if FishAndChips.TheShitSquad.guppy_ui then
						FishAndChips.TheShitSquad.guppy_ui:remove()
						FishAndChips.TheShitSquad.guppy_ui = nil
						G.GAME.used_jokers[a] = G.GAME.used_jokers[a] or not context.failed
					end
				return true end}))
			end
		end
	end
}

FishAndChips.Fish {
	key = "tss_plecoholder",
	atlas = "tss_ellefish",
	pos = { x = 0, y = 0 },
	weight = 5,
	stats = {
		weight = {
			min = 0,
			max = 0,
			units = {
				format = "fac_tss_na1",
				scale=1,
				precision = 1
		}},
		length = {
			min = 0,
			max = 0,
			units = {
				format = "fac_tss_na2",
				scale=1,
				precision = 1
	}}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "generation", "position", },
	environments = {
		wormhole = 5,
		backroom = 4
	},
	loc_vars = function(self, info_queue, card)
		local retvars = {colours={}}
		local devs = {}
		if card.area == G.fac_fish_area then
			local self_pos = 0
			for i = 1, #card.area.cards do
				if card.area.cards[i] == card then self_pos = i break end
			end

			if card.area.cards[self_pos+1] and not SMODS.is_eternal(card.area.cards[self_pos+1]) then
				devs[1] = PotatoPatchUtils.Developers["fac_"..card.area.cards[self_pos+1].config.center.ppu_coder[1] ]
				devs[2] = devs[1].fac_partner and PotatoPatchUtils.Developers[devs[1].fac_partner] or nil
			end

			for _, v in ipairs(devs) do
				retvars[#retvars+1] = v.loc and localize({set = "PotatoPatch", key = v.loc, type = "name_text"}) or v.name
				retvars.colours[#retvars.colours+1] = v.colour
			end
		end

		return {vars = retvars, key = #devs>0 and self.key..#devs or nil}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and context.main_eval and card.area == G.fac_fish_area then
			local self_pos = 0
			for i = 1, #card.area.cards do
				if card.area.cards[i] == card then self_pos = i break end
			end

			local target = card.area.cards[self_pos+1]
			if not target or SMODS.is_eternal(target) then return end

			local devs = {}
			devs[1] = PotatoPatchUtils.Developers["fac_"..target.config.center.ppu_coder[1] ]
			devs[2] = devs[1].fac_partner and PotatoPatchUtils.Developers[devs[1].fac_partner] or nil

			local showman_old = SMODS.showman
			SMODS.showman = function() return true end
			local key = SMODS.poll_object({type = 'fac_Fish', allow_duplicates = true, filter = function(t)
				local newTable = {}

				for i, v in ipairs(t) do
					local a = false
					if G.P_CENTERS[v.key] then
						for _, dev in ipairs(devs) do
							a = a or  G.P_CENTERS[v.key].ppu_coder[1] == dev.name
						end
					end
					newTable[#newTable+1] = a and v or nil
				end

				return newTable
			end})
			SMODS.showman = showman_old

			target:juice_up()
			target:set_ability(key)
			if target._fac_bucketed then
				target.T.w = target.T.w * .7
				target.T.h = target.T.h * .7
			end
		end
	end
}

FishAndChips.Fish {
	key = "tss_caviar",
	atlas = "tss_ellefish",
	pos = { x = 0, y = 1 },
	weight = 8,
	pixel_size = { w = 50, h = 40 },
    display_size = { w = 50, h = 40 },
	stats = {weight = {min = .003, max = .02}, length = {min = .03, max = .07}}, -- average caviar servings. in case you haven't been able to tell by now, i'm doing my research
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "economy", "sell_value", "food", },
	config = { extra = { mod = 2 } },
	environments = {
		city_river = 3,
		soup = 5
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mod } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
    		SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "extra_value",
                scalar_table = card.ability.extra,
                scalar_value = "mod",
                scaling_message = {
                    message = localize('k_val_up'),
                    colour = G.C.SAND_DOLLAR
                }
            })
            card:set_cost()
            return nil, true
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge("Food", FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end
}

FishAndChips.Fish {
	key = "tss_forcefish",
	atlas = "tss_ellefish",
	pos = { x = 1, y = 1 },
	weight = 4,
	stats = {weight = {min = 15, max = 25}, length = {min = .3, max = .5}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "rank", "queen", "chance", "modify_card", },
	config = { extra = { odds = 5 } },
	environments = {
		city_river = 4,
		pier = 3,
		garden = 1
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_tss_forcefish")
		return { vars = { num, dem } }
	end,
	calculate = function(self, card, context)
		if context.final_scoring_step then
			local list = {}
			for i, v in ipairs(G.play.cards) do
				if v:get_id() ~= 12 and SMODS.pseudorandom_probability(card,"fcc_tss_forcefish",1,card.ability.extra.odds) then
					list[#list+1] = v
				end
			end

			for i, c in ipairs(list) do
				G.E_MANAGER:add_event(Event({
					trigger = 'immediate',
					delay = 0.15,
					func = function()
						c:flip()
						play_sound('card1')
						c:juice_up(0.3, 0.3)
						return true
					end
				}))
			end
			delay(0.2)
			for i, c in ipairs(list) do
				G.E_MANAGER:add_event(Event({
					trigger = 'immediate',
					delay = 0.1,
					func = function()
						SMODS.change_base(c, nil, "Queen")
						return true
					end
				}))
			end
			for i, c in ipairs(list) do
				G.E_MANAGER:add_event(Event({
					trigger = 'immediate',
					delay = 0.15,
					func = function()
						c:flip()
						play_sound('tarot2')
						c:juice_up(0.3, 0.3)
						card:juice_up(0.3, 0.3)
						return true
					end
				}))
			end
			return {message = #list>0 and localize("fac_tss_forcefem") or nil}
		end
	end
}

FishAndChips.Fish {
	key = "tss_uranium",
	atlas = "tss_ellefish",
	pos = { x = 3, y = 0 },
	weight = 7,
	stats = {weight = {min = 5.6, max = 5.6}, length = {min = .15, max = .15}}, -- assuming, based off the sprite, that it's 3x longer than it's wide, these would be the correct dimensions
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "rank", "modify_card" },
	config = { extra = { pickup = 0 } },
	environments = {
		wormhole = 3,
		city_river = 1
	},
	calculate = function(self, card, context)
		if context.before then
			for i, c in ipairs(G.hand.cards) do
				c:juice_up()
				SMODS.change_base(c, nil, pseudorandom_element(SMODS.Ranks, "fac_tss_uranium").key)
			end
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_rod"), FishAndChips.C.ROD, G.C.WHITE, 1.2)
	end,
}

G.E_MANAGER:add_event(Event({blocking = false, blockable = false, func = function()
	local f = love.update
	function love.update(dt)
		f(dt)
		for i, v in ipairs(SMODS.find_card("fish_fac_tss_uranium")) do
			v.ability.extra.pickup = v.ability.extra.pickup+dt
		end
	end
return true end}))


SMODS.Shader {
	key = 'tss_uranium_glow',
	path = 'the_s_squad/uranium_glow.fs',

	send_vars = function(self, sprite, card)
		local atlas = sprite.children.center.atlas
		local w,h = atlas.image:getDimensions()
		local w2,h2 = atlas.px,atlas.py
		return {
			col = HEX("50ff81"),
			size = {w,h,math.sin(G.TIMERS.REAL)*2+5},
			cardsize = {w2,h2}
		}
	end
}

SMODS.DrawStep {
	key = 'tss_uranium_glow',
	order = -11,
	func = function(self, layer)
		if self.config.center_key == "fish_fac_tss_uranium" and (self.config.center.discovered or self.bypass_discovery_center) then
			self.children.center:draw_shader('fac_tss_uranium_glow')
		end
	end,
	conditions = { vortex = false, facing = 'front' },
}

FishAndChips.Fish {
	key = "tss_slop",
	atlas = "tss_ellefish",
	pos = { x = 3, y = 1 },
	weight = 2,
	stats = {weight = {min = 15, max = 25}, length = {min = .3, max = .5}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "retrigger", "chance", },
	config = { immutable = { num = 2, den = 3 } },
	environments = {},
	treasure = true,
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card, card.ability.immutable.num, card.ability.immutable.den, "fac_tss_slop", nil, true)
		return { vars = { num, den } }
	end,
	calculate = function(self, card, context)
		if
			context.retrigger_joker_check
			and not context.retrigger_joker
			and context.other_card
			and context.other_card:is(Card)
			and context.other_card.config.center.set == "fac_Fish"
		then
			local count = 0
			while SMODS.pseudorandom_probability(card, "fac_tss_slop", card.ability.immutable.num, card.ability.immutable.den, nil, true) do
				count = count + 1
			end
			if count>0 then
				return {
					repetitions = count,
					fac_fishingslop_end_msg = localize{ type = 'variable', key = 'k_fac_tss_again_ex_multi', vars = {count} },
				}
			end
		end
	end
}

FishAndChips.mod.optional_features = FishAndChips.mod.optional_features or {}
FishAndChips.mod.optional_features.retrigger_joker = true
