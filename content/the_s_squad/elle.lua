FishAndChips.Fish {
	key = "tss_chesh",
	atlas = "tss_fish",
	pos = { x = 2, y = 0 },
	weight = 5,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "xmult", "destroy_card" },
	config = { extra = { xmult = 1, xmult_mod = .25, odds = 3 } },
	environments = {
		backroom = 5,
		wormhole = 2,
		styx = 2
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fac_tss_chesh")
		return { vars = { num, dem, card.ability.extra.xmult_mod, card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		-- Chesh eating handled in dev calculate so they can all flock at once like hungry pirahnas
		if context.joker_main and card.ability.extra.xmult ~= 1 then return { xmult = card.ability.extra.xmult } end
	end
}

local emplace_hook = CardArea.emplace
function CardArea:emplace(card, ...)
	if card.tss_cheshed then emplace_hook(G.FISHING.fac_fish_reward_area, card, ...) return end
	emplace_hook(self,card, ...)
end



FishAndChips.Fish {
	key = "tss_resident",
	atlas = "tss_fish",
	pos = { x = 1, y = 0 },
	weight = 13,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "mult" },
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
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
			
			return { message = localize("k_upgrade_ex") }
		end

		if context.joker_main then return { mult = card.ability.extra.mult } end
	end
}

FishAndChips.Fish {
	key = "tss_plecoholder",
	atlas = "tss_fish",
	pos = { x = 0, y = 0 },
	weight = 5,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "mult" },
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
			
			if card.area.cards[self_pos+1] then
				devs[1] = PotatoPatchUtils.Developers["fac_"..card.area.cards[self_pos+1].config.center.ppu_coder[1]]
				devs[2] = devs[1].fac_partner and PotatoPatchUtils.Developers["fac_"..devs[1].fac_partner] or nil
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
			if not target then return end

			--local key = FishAndChips.poll_fish()
		end
	end
}

FishAndChips.Fish {
	key = "tss_caviar",
	atlas = "tss_fish",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "economy" },
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
			card.ability.extra_value = card.ability.extra_value + card.ability.extra.mod
			card:set_cost()
			return {
				message = localize('k_val_up'),
				colour = G.C.SAND_DOLLAR
			}
		end
	end
}

FishAndChips.Fish {
	key = "tss_forcefish",
	atlas = "tss_fish",
	pos = { x = 0, y = 0 },
	weight = 4,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "rank" },
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
	atlas = "tss_fish",
	pos = { x = 3, y = 0 },
	weight = 4,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "slimestuff" },
	attributes = { "rank" },
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
	add_to_deck = function(self, card)
		card.ability.extra.pickup = G.TIMERS.REAL
	end
}

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