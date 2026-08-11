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
	cost = 2,
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
        elseif context.after and G.GAME.current_round.hands_played == 0 and not context.blueprint then
			local middle_func = function()
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("fac_delrice_instakill")
						return true
					end
				}))
				local gap = 0.2
				local length = 3
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
			end
			
			FishAndChips.DeliciousRice.fancy_death(card, {destroy_func = Card.shatter}, middle_func)
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
		
			
		elseif context.round_eval and not context.blueprint then
			
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
					return true
				end
			}))
			card.ability.extra.hydrated = false

		elseif context.fac_environment_changed and not context.blueprint then
			card.ability.extra.valid_env = FishAndChips.DeliciousRice.valid_SB_env(context.fac_environment_changed)

		elseif context.ending_fishing and not card.ability.extra.hydrated and not context.blueprint then
		-- elseif context.after then
			-- TODO: SWAP TO DEAD STATE
			-- TODO: SEPARATE EVENTS
			local middle_func = function() 
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					timer = "REAL",
					delay = 2,
					func = function()
						return true
					end
				}))
			end

			FishAndChips.DeliciousRice.fancy_death(card, nil, middle_func, true)
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
			denom = 10,
			id = 0
		}
	},

	weight = 15,
	environments = {
		pier = 30
	},
	stats = {
		weight = {min = 10, max = 10},
		length = {min = 0.028, max = 0.028}
	},
	loc_vars = function(self, info_queue, card)
 		local num, denom = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom)
 		return {vars = {num, denom, (not card.ability.extra.used) and 'unused' or 'used'}}
	end,

	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.id = G.GAME.delrice_blenders
		G.GAME.delrice_blenders = G.GAME.delrice_blenders + 1
		G.delrice_blender_areas[card.ability.extra.id] = CardArea(0, 0, 0, 0, {type = "discard", major = G.play})
	end,
	remove_from_deck = function (self, card, from_debuff)
		G.GAME.delrice_blenders = G.GAME.delrice_blenders - 1
		G.delrice_blender_areas[card.ability.extra.id] = nil
	end,
	calculate = function(self, card, context)
		if context.after and card.ability.extra.used and SMODS.pseudorandom_probability(card, 'blender_fcking_blow_up', card.ability.extra.num, card.ability.extra.denom) then
			
			
		elseif G.delrice_blender_areas[card.ability.extra.id].cards then
			for i, v in ipairs(G.delrice_blender_areas[card.ability.extra.id].cards) do
				return SMODS.blueprint_effect(card, v, context)
			end
		end
	end,
	can_use = function(self, card) return not card.ability.extra.used end,
	keep_on_use = function(self, card) return true end,
	use = function(self, card)
		card.ability.extra.used = true

		for i, v in ipairs(G.fac_fish_area.cards) do
			if v ~= card then
				local copy = copy_card(v, nil, 0)
				G.delrice_blender_areas[card.ability.extra.id]:emplace(copy)
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