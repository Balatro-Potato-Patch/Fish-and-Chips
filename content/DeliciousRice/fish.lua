FishAndChips.Fish { -- Fring
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_fringills",
	pos = { x = 2, y = 1 },
	attributes = { "xmult" },
	config = {
		extra = {
			xmult = 3
		}
	},
	cost = 1,
	weight = 20,
	environments = {
		wormhole = 2,
		city_river = 3
	},
	eternal_compat = false,
	stats = {
		weight = {min = 7, max = 11},
		length = {min = 0.3, max = 0.6}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {xmult = card.ability.extra.xmult}
        elseif context.after
		and SMODS.last_hand_oneshot
		and G.GAME.current_round.hands_played == 0 
		and not context.blueprint 
		then
			local middle_func = function()
				FishAndChips.DeliciousRice.talk(card, 3, 0.2, "fac_delrice_instakill")
				FishAndChips.DeliciousRice.explode_destroy(card)
			end
			
			FishAndChips.DeliciousRice.fancy_death(card, nil, middle_func, false)
		end
	end,
}

local atlas_sponge = {[true] = {x = 0, y = 0}, [false] = {x = 1, y = 0}}
FishAndChips.Fish { -- Spongebob
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_spongebob",
	pos = atlas_sponge[true],
	attributes = { "scaling", "mult", "usable" },
	config = {
		extra = {
			mult = 0,
			scalar = 1,
			hydrated = true,
			valid_env = false,
			in_hand = false
		}
	},
	blueprint_compat = true,
	eternal_compat = false,
	cost = 0,
	
	weight = 30,
	environments = {
		pier = 30
	},
	stats = {
		weight = {min = 10, max = 10},
		length = {min = 0.028, max = 0.028}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.scalar } }
	end,

	add_to_deck = function(self, card, from_debuff)
		FishAndChips.DeliciousRice.talk(card, 2, 0.2, "fac_delrice_imspongebob")
		card.ability.extra.valid_env = FishAndChips.DeliciousRice.valid_SB_env(FishAndChips.get_environment().key)		
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {mult = card.ability.extra.mult}

        elseif 
			context.card_flipped 
			and (
				(not FishAndChips.DeliciousRice.emplacing
				and not FishAndChips.DeliciousRice.bad_flip)
				or
				FishAndChips.DeliciousRice.in_hand
			)
			and not context.blueprint
		then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "mult",
				scalar_value = "scalar",
			})
		
			
		elseif context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			
			G.E_MANAGER:add_event(Event({
				func = function()
					card:flip()
					card.children.center:set_sprite_pos(atlas_sponge[false])
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				timer = "REAL",
				delay = 0.1,
				func = function()
					card:flip()
					play_sound("fac_delrice_boowomp")
					return true
				end
			}))
			card.ability.extra.hydrated = false

		elseif context.fac_environment_changed and not context.blueprint then
			card.ability.extra.valid_env = FishAndChips.DeliciousRice.valid_SB_env(context.fac_environment_changed)

		elseif context.ending_fishing and not card.ability.extra.hydrated and not context.blueprint then
			local middle_func = function() 
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					timer = "REAL",
					delay = 2,
					func = function()
						return true
					end
				}))
				
				G.E_MANAGER:add_event(Event({
					-- trigger = "after",
					-- timer = "REAL",
					-- delay = 2,
					func = function()
						card:flip()
						card:set_ability(G.P_CENTERS["fish_fac_delrice_spongecorpse"])
						return true
					end
				}))
				

				G.E_MANAGER:add_event(Event({
					-- trigger = "after",
					-- timer = "REAL",
					-- delay = 0.2,
					func = function()
						card:flip()
						return true
					end
				}))
			end
			local vol = G.SETTINGS.SOUND.music_volume
			G.E_MANAGER:add_event(Event({
				trigger = "ease",
				ref_table = G.SETTINGS.SOUND,
				ref_value = "music_volume",
				ease_to = 0,
				delay = 1
			}))
			G.SETTINGS.SOUND.music_volume = 0
			FishAndChips.DeliciousRice.fancy_death(card, nil, middle_func, false, 6)
			G.E_MANAGER:add_event(Event({
				trigger = "ease",
				ref_table = G.SETTINGS.SOUND,
				ref_value = "music_volume",
				ease_to = vol,
				delay = 1
			}))
		end
		
	end,
	can_use = function(self, card)
		return card.ability.extra.valid_env and G.STATE == G.STATES.FAC_FISHING and (not card.ability.extra.hydrated)
	end,
	use = function(self, card)
		G.E_MANAGER:add_event(Event({
			func = function()
				card:flip()
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				card.children.center:set_sprite_pos(atlas_sponge[true])
				card:flip()
				return true
			end
		}))
		card.ability.extra.hydrated = true
	end,
	keep_on_use = function(self, card)
		return true
	end,
	set_sprites = function(self, card, front)
		local state = true
		if card.ability and card.ability.extra and card.ability.extra.hydrated ~= nil then
			state = card.ability.extra.hydrated
		end
		card.children.center:set_sprite_pos(atlas_sponge[state])
	end
}

FishAndChips.Fish { -- Spongecorpse
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_spongecorpse",
	pos = {x = 2, y = 0},
	attributes = {},
	config = {},
	blueprint_compat = false,
	eternal_compat = true,
	no_collection = true,
	cost = 0,

	weight = 0,
	environments = {
		pier = 0
	},
	stats = {
		weight = {min = 10, max = 10},
		length = {min = 0.028, max = 0.028}
	},
	calculate = function(self, card, context)
		if context.check_eternal then
			if context.other_card == card then 
				return {no_destroy = true}
			end
		end
	end
}

local atlas_blender = {[true] = {x = 1, y = 1}, [false] = {x = 0, y = 1}}
FishAndChips.Fish { -- Blender
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_blender",
	pos = atlas_blender[false],
	attributes = { "copying", "usable" },
	config = {
		extra = {
			used = false,
			num = 1,
			denom = 15,
			id = 0
		}
	},
	cost = 5,
	weight = 15,
	environments = {
		pier = 1,
		city_river = 1,
		backroom = 1
	},
	stats = {
		weight = {min = 3, max = 4},
		length = {min = 0.37, max = 0.45}
	},
	loc_vars = function(self, info_queue, card)
 		local num, denom = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom)
 		return {vars = {num, denom, (not card.ability.extra.used) and 'unused' or 'used'}}
	end,

	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.id = G.GAME.delrice_blenders
		G.GAME.delrice_blenders = G.GAME.delrice_blenders + 1
	end,
	remove_from_deck = function (self, card, from_debuff)
		G.GAME.delrice_blenders = G.GAME.delrice_blenders - 1
		
		if G.delrice_blender_area.cards then
			for i, v in ipairs(G.delrice_blender_area.cards) do
				if v.ability.extra.blender_id == card.ability.extra.id then
					SMODS.destroy_cards(v)
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint 
		and SMODS.pseudorandom_probability(card, 'blender_fcking_blow_up', card.ability.extra.num, card.ability.extra.denom) then
			FishAndChips.DeliciousRice.fancy_death(card,
				nil,
				FishAndChips.DeliciousRice.explode_destroy, 
				false,
				nil,
				0.8
			)
			
		elseif G.delrice_blender_area.cards then
			for i, v in ipairs(G.delrice_blender_area.cards) do
				if v.ability.extra.blender_id == card.ability.extra.id then
					local effect = SMODS.blueprint_effect(card, v, context) or nil
					if effect then SMODS.calculate_effect(effect, card) end
				end
			end
		end
	end,
	can_use = function(self, card) return not card.ability.extra.used and #G.fac_fish_area.cards > 1 end,
	keep_on_use = function(self, card) return true end,
	use = function(self, card)
		card.ability.extra.used = true

		for i, v in ipairs(G.fac_fish_area.cards) do
			if v ~= card then
				---@type Card
				local copy = copy_card(v, nil, 0)
				copy.ability.extra.blender_id = card.ability.extra.id
				G.delrice_blender_area:emplace(copy)
				SMODS.destroy_cards(v)
			end
		end
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound("fac_delrice_blender")
				return true
			end
		}))
		local gap = 0.2
		local length = 2
		local loops = math.ceil(length / gap)
		for i = 1, loops do
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				timer = "REAL",
				delay = gap,
				func = function()
					card:juice_up()
					return true
				end
			}))
		end
		G.E_MANAGER:add_event(Event({
			func = function()
				card.children.center:set_sprite_pos(atlas_blender[true])
				return true
			end
		}))
	end,
	
	set_sprites = function(self, card, front)
		local state = false
		if card.ability and card.ability.extra and card.ability.extra.used ~= nil then
			state = card.ability.extra.used
		end
		card.children.center:set_sprite_pos(atlas_blender[state])
	end
}

FishAndChips.Fish { -- Gambling
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_gambling",
	pos = {x = 0, y = 2},
	attributes = { "scaling", "economy" },
	config = {
		extra = {
			money = 1,
			scalar = 1
		}
	},
	cost = 5,
	weight = 10,
	treasure = true,
	environments = {
		backroom = 2,
		wormhole = 3
	},
	stats = {
		weight = {min = 130, max = 140},
		length = {min = 1.5, max = 1.6}
	},
	loc_vars = function(self, info_queue, card)
 		return {vars = {card.ability.extra.money, card.ability.extra.scalar}}
	end,

	add_to_deck = function(self, card, from_debuff)
		FishAndChips.DeliciousRice.talk(card, 1.2, 0.2, "fac_delrice_letsgo", 0.6)
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and context.treasure_available then
			if context.treasure then
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "money",
					scalar_value = "scalar",
				})

				local middle_func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							card.children.center:set_sprite_pos({x = 1, y = 2})
							-- sendDebugMessage("set")
							return true
						end
					}))
					local length = 1.2 
					FishAndChips.DeliciousRice.talk(card, length, 0.2, "fac_delrice_winning", 0.6)
				end

				local end_func = function() 
					card.children.center:set_sprite_pos({x = 0, y = 0}) 
					-- sendDebugMessage("reset")
				end
				
				FishAndChips.DeliciousRice.fancy_death(card,
					nil,
					middle_func, 
					false,
					nil,
					nil,
					end_func
				)

				return {sand_dollars = card.ability.extra.money}
			else				
				local middle_func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							card.children.center:set_sprite_pos({x = 1, y = 2})
							return true
						end
					}))
					FishAndChips.DeliciousRice.talk(card, 1, 0.2, "fac_delrice_dangit", 0.8)
					FishAndChips.DeliciousRice.explode_destroy(card)
				end
				
				FishAndChips.DeliciousRice.fancy_death(card,
					nil,
					middle_func, 
					false
				)
				
			end
			
		end
	end
	
}