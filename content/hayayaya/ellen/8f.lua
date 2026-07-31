FishAndChips.Fish({
	key = "8f", -- 3 NEW
	weight = 1,
	cost = -3,
	environments = {
		calm_pond = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"usable",
	},
	decision_min = math.huge,
	decision_max = math.huge,
	vel_limit = 0,
	config = { immutable = { count = 0, max = 8 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.immutable.count, card.ability.immutable.max },
			key = self.key .. (card.ability.immutable.count >= card.ability.immutable.max and "_alt" or ""),
		}
	end,
	can_use = function(self, card)
		return G.STATE == G.STATES.BLIND_SELECT and card.ability.immutable.count >= card.ability.immutable.max
	end,
	use = function(self, card)
		-- TODO
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and card.ability.immutable.count < card.ability.immutable.max then
			card.ability.immutable.count = card.ability.immutable.count + 1
			return {
				message = string.format("%i/%i", card.ability.immutable.count, card.ability.immutable.max),
			}
		end
	end,
	on_catch = function(self, card)
		HayayayaUtils.stop_music()
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.5 * G.SPEEDFACTOR,
			func = function()
				play_sound("fac_hayayaya_mistake")
				return true
			end,
		}))
		delay(2 * G.SPEEDFACTOR)
	end,
})
