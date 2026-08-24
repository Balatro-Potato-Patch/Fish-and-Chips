-- TODO: Port all uses of set_card_type_badge to badge_key
FishAndChips.Fish {
	key = "tss_shadow_cryscarp",
	atlas = "tss_azfish",
	pos = { x = 2, y = 0 },
	pixel_size = { w = 100, h = 93 },
	display_size = { w = 100*.7, h = 93*.7 },
	weight = 4,
	stats = {weight = {min = 0, max = 0}, length = {min = .4, max = .6}}, -- i imagine shadow crystals being weightless
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "passive", "deltarune", "utdr", },
	config = { extra = { speed = 2 } },
	environments = {
		styx = 10,
		garden = 4
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.bait_fac_normal
		return { vars = { card.ability.extra.speed } }
	end,
	calculate = function(self, card, context)
		if context.fac_modify_fishing_profile and G.GAME.fac_active_bait == "bait_fac_normal" then
			context.fishing_profile.treasure_gain = context.fishing_profile.treasure_gain * card.ability.extra.speed
		end
	end
}

FishAndChips.Fish {
	key = "tss_medic",
	atlas = "tss_azfish",
	pos = { x = 0, y = 1 },
	pixel_size = { w = 92, h = 101 },
	display_size = { w = 92*.8, h = 101*.8 },
	weight = 5,
	stats = {weight = {min = 200, max = 250}, length = {min = 2, max = 3}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "passive", "hands", "prevents_death", },
	config = { extra = { blu = false } },
	blueprint_compat = false,
	environments = {
		city_river = 1,
		styx = 2,
		pier = 6
	},
	calculate = function(self, card, context)
		if context.after and not context.blueprint and not context.retrigger_joker and G.GAME.current_round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips and SMODS.find_card(card.config.center_key)[1]==card then
			ease_hands_played(G.GAME.round_resets.hands)
			G.E_MANAGER:add_event(Event{func = function()
				SMODS.destroy_cards(card)
			return true end})

			return {
				message = localize("fac_tss_revive"),
				colour = G.C[card.ability.extra.blu and "BLUE" or "RED"]
			}
		end
	end,
	set_ability = function(self, card, initial, delay_sprites)
		card.ability.extra.blu = pseudorandom("fac_tss_medic",0,1) == 0
		card.children.center:set_sprite_pos({x=card.ability.extra.blu and 1 or 0, y=1})
	end,
	update = function(self, card, dt)
		card.children.center:set_sprite_pos({x=card.ability.extra.blu and 1 or 0, y=1})
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge("Mercenary", FishAndChips.C[card.ability.extra.blu and "FISH" or "ROD"], G.C.WHITE, 1.2)
	end
}

FishAndChips.Fish {
	key = "tss_bfb",
	atlas = "tss_azfish",
	pos = { x = 2, y = 2 },
	pixel_size = { w = 75, h = 91 },
	display_size = { w = 75, h = 91 },
	weight = 3,
	stats = {weight = {min = 2000, max = 2500}, length = {min = 7, max = 10}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "chips", "xmult", "generation", "on_sell", "chance", },
	config = { extra = { chips = 100, xmult = 2.5, count = 4, odds = 40 } },
	environments = {
		pier = 10,
		aquifer = 2
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fcc_tss_bfb")
		info_queue[#info_queue + 1] = G.P_CENTERS.fish_fac_tss_moab
		return { vars = { card.ability.extra.chips, card.ability.extra.xmult, card.ability.extra.count, num, dem } }
	end,
	calculate = function(self, card, context)
		if context.selling_self then
			for i = 1, card.ability.extra.count do
				local c = SMODS.create_card({area = G.fac_fish_area, key = "fish_fac_tss_moab"})
				G.fac_fish_area:emplace(c)
			end
		end
		if context.joker_main then
			local destroy = SMODS.pseudorandom_probability(card, "fac_tss_moab", 1, card.ability.extra.odds)
			return {
				chips = card.ability.extra.chips,
				xmult = card.ability.extra.xmult,
				message = destroy and localize("fac_tss_popped") or nil,
				colour = destroy and G.C.RED or nil,
				func = destroy and function()
					G.E_MANAGER:add_event(Event{func=function()
						SMODS.destroy_cards(card)
						card:start_dissolve()
						local c = SMODS.create_card({area = G.fac_fish_area, key = "fish_fac_tss_moab"})
						G.fac_fish_area:emplace(c)
					return true end})
				end or nil
			}
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("fac_tss_bloon"), FishAndChips.C.ROD, G.C.WHITE, 1.2)
	end
}

FishAndChips.Fish {
	key = "tss_moab",
	atlas = "tss_azfish",
	pos = { x = 1, y = 2 },
	pixel_size = { w = 80, h = 78 },
	display_size = { w = 80, h = 78 },
	weight = 6,
	stats = {weight = {min = 800, max = 1000}, length = {min = 5, max = 7}},
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "xchips", "chance", }, -- not a bait attribute but oh well -- I have good news for you (mf) -- I actually have bad news for you (removed destroy_card because it was inaccurate) (mf) -- Actually aren't we gonna make the Chips bait Chips instead of +Chips (mf)
	config = { extra = { odds = 20, xchips = 1.5 } },
	environments = {
		pier = 10,
		aquifer = 2
	},
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fcc_tss_moab")
		return { vars = { card.ability.extra.xchips, num, dem } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local destroy = SMODS.pseudorandom_probability(card, "fac_tss_moab", 1, card.ability.extra.odds)
			return {
				xchips = card.ability.extra.xchips,
				message = destroy and localize("fac_tss_popped") or nil,
				colour = destroy and G.C.BLUE or nil,
				func = destroy and function()
					G.E_MANAGER:add_event(Event{func=function()
						SMODS.destroy_cards(card)
						card:start_dissolve()
					return true end})
				end or nil
			}
		end
	end,
	set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("fac_tss_bloon"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end
}

FishAndChips.Fish {
	key = "tss_cult",
	atlas = "tss_azfish",
	pos = { x = 2, y = 1 },
	pixel_size = { w = 83, h = 109 },
	display_size = { w = 83*.8, h = 109*.8 },
	weight = 3,
	stats = {weight = {min = 3, max = 5}, length = {min = .8, max = 1.2}}, -- pls replace later
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "xmult", "usable", "scaling", "destroy_card", "position" },
	environments = {
		styx = 10,
		swamp = 2
	},
	config = { extra = { xmult = 1, xmult_mod = .5, lose = 1, antecheck = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult, card.ability.extra.lose, ppu_bubbles = {card.ability.extra.antecheck and "used" or "usable"} } }
	end,
	calculate = function(self, card, context)
		if card.ability.extra.xmult ~= 1 then
			if context.ante_change and context.ante_end and not card.ability.extra.antecheck then
				-- card.ability.extra.xmult = math.max(card.ability.extra.xmult-card.ability.extra.lose, 1)
				SMODS.scale_card(card, {
					ref_value = "xmult",
					scalar_value = "lose",
					no_message = true,
					operation = "-",
				})
				if card.ability.extra.xmult <= 1 then card.ability.extra.xmult = 1 end
				return {
					message = localize("fac_tss_cult_fail")
				}
			end
			if context.joker_main then
				return {xmult = card.ability.extra.xmult}
			end
		end
	end,
	use = function(self, card)
		card.ability.extra.antecheck = true
		local self_pos = 0
		for i = 1, #card.area.cards do
			if card.area.cards[i] == card then self_pos = i break end
		end

		local t = card.area.cards[self_pos+1]
		SMODS.destroy_cards(t)
		SMODS.scale_card(card, {
			ref_value = "xmult",
			scalar_value = "xmult_mod",
			no_message = true,
		})
		G.E_MANAGER:add_event(Event({func = function()
			card.ability.extra.triggering = false
		return true end}))
	end,
	can_use = function(self, card)
		local self_pos = 0
		for i = 1, #card.area.cards do
			if card.area.cards[i] == card then self_pos = i break end
		end

		return card.area.cards[self_pos+1] and not card.ability.extra.antecheck
	end,
	keep_on_use = function (self, card)
		return true
	end
}

FishAndChips.Fish {
	key = "tss_watrena",
	atlas = "tss_azfish",
	pos = { x = 0, y = 2 },
	pixel_size = { w = 106, h = 102 },
	display_size = { w = 106*.9, h = 102*.9 },
	weight = 3,
	stats = {weight = {min = 0, max = 0}, length = {min = 0, max = 0}}, -- pls replace later
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "passive", "chance", "editions" },
	environments = {
		garden = 10
	},
	config = { extra = { odds = 3 } },
	loc_vars = function(self, info_queue, card)
		local num, dem = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "fcc_tss_watrena")
		return { vars = { num, dem } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and context.fish_obj and G.GAME.fac_fishing_environment == "garden" and SMODS.pseudorandom_probability(card,"fcc_tss_watrena",1,card.ability.extra.odds) then
			context.fish_obj:set_edition(SMODS.poll_edition({key = 'fac_tss_watrena', guaranteed = true}))
		end
	end
}

FishAndChips.Fish {
	key = "tss_ferish",
	atlas = "tss_azfish",
	pos = { x = 1, y = 0 },
	pixel_size = { w = 98, h = 100 },
	display_size = { w = 98*.9, h = 100*.9 },
	weight = 3,
	stats = {weight = {min = 0, max = 0}, length = {min = 0, max = 0}}, -- pls replace later
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "mult", "suit", "hearts", "modify_card", "perma_bonus", },
	environments = {
		city_river = 10,
		calm_pond = 8
	},
	config = { extra = { mult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card:is_suit("Hearts") then
			context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) +
				card.ability.extra.mult
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT
			}
		end
	end
}

FishAndChips.Fish {
	key = "tss_bee",
	atlas = "tss_azfish",
	pos = { x = 0, y = 0 },
	stats = {weight = {min = .04, max = .32}, length = {min = .04, max = .32}}, -- actual bee sizes but i added a couple zeros
	pixel_size = { w = 88, h = 71 },
	display_size = { w = 88*.8, h = 71*.8 },
	weight = 1,
	ppu_coder = { "slimestuff" },
	ppu_artist = { "azazel" },
	attributes = { "passive" },
	environments = {
		calm_pond = 1,
		garden = 10
	},
	calculate = function(self, card, context)
		if pseudorandom("fac_tss_bee", 1, 1000) == 1 then -- we do a little bit of trolling
			return {
				message = localize("fac_tss_good_news"),
				colour = G.C.YELLOW,
				card = card
			}
		end
	end
}
