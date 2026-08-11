FishAndChips.Fish {
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_fringills",
	pos = { x = 0, y = 1 },
	attributes = { "xmult" },
	config = {
		extra = {
			xmult = 3
		}
	},
	cost = 2,
	weight = 10,
	environments = {
		pier = 10
	},
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
        elseif context.after and G.GAME.current_round.hands_played == 0 then
			local gap = 0.2
			local length = 3
			local loops = math.ceil(length / gap)
			
			-- shoutout GhostSalt for helping me with this <3
			local old_state = G.STATE
			G.E_MANAGER:add_event(Event({
				func = function()
					G.STATE = nil
					G.FUNCS.fac_open_fishing_menu()
					FishAndChips.DeliciousRice.bucket_locked = true
					play_sound("fac_delrice_instakill")
					return true
				end
			}))

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

			SMODS.destroy_cards(card, {destroy_func = Card.shatter})

			G.E_MANAGER:add_event(Event({
				trigger = "after",
				timer = "REAL",
				delay = 0.2,
				func = function()
					FishAndChips.DeliciousRice.bucket_locked = false
					G.FUNCS.fac_open_fishing_menu()
					G.STATE = old_state
					return true
				end
			}))
		end
	end,
}

local atlas_spong = {[true] = {x = 0, y = 0}, [false] = {x = 0, y = 1}}
FishAndChips.Fish {
	ppu_coder = { "cheekyrotter" },
	ppu_artist = { "EDriGO" },
	atlas = "delrice_fish",

	key = "delrice_spongebob",
	pos = atlas_spong[true],
	attributes = { "scaling", "mult" },
	config = {
		extra = {
			mult = 0,
			scalar = 1,
			hydrated = true,
			valid_env = false,
			in_hand = false
		}
	},

	weight = 30,
	environments = {
		pier = 10
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
				-- card.ability.extra.in_hand
				FishAndChips.DeliciousRice.in_hand
			)
		then
			-- sendDebugMessage(G.STATE)
			-- sendDebugMessage(card.ability.extra.in_hand and 'true' or 'false')
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "mult",
				scalar_value = "scalar",
			})
		
			G.E_MANAGER:add_event(Event({
				func = function()
					card:flip()
					return true
				end
			}))
			G.E_MANAGER:add_event(Event({
				func = function()
					card.children.center:set_sprite_pos(atlas_spong[false])
					card:flip()
					return true
				end
			}))
			card.ability.extra.hydrated = false

		elseif context.fac_environment_changed then
			card.ability.extra.valid_env = FishAndChips.DeliciousRice.valid_SB_env(context.fac_environment_changed)

		elseif context.ending_fishing and not card.ability.extra.hydrated then
			-- ADD DEATH CONDITION
			G.E_MANAGER:add_event(Event({
				func = function()
					G.FUNCS.fac_open_fishing_menu()
					FishAndChips.DeliciousRice.bucket_locked = true
					delay(2)
					SMODS.destroy_cards(card)
					FishAndChips.DeliciousRice.bucket_locked = false
					G.FUNCS.fac_open_fishing_menu()
					return true
				end
			}))
		end
		
	end,
	can_use = function(self, card)
		-- sendDebugMessage(card.ability.extra.valid_env and 'true' or 'false')
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
				card.children.center:set_sprite_pos(atlas_spong[true])
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
		card.children.center:set_sprite_pos(atlas_spong[state])
	end
}