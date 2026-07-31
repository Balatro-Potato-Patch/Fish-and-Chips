FishAndChips.Fish({
	key = "sg11_n_vekhi_water_ghoul",
	-- atlas = "fish",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = { "usable" },
	config = {
		extra = {
			primed = false,
		},
	},
	weight = 4,
	environments = {
		styx = 1,
	},
	can_use = function(self, card)
		return not card.ability.extra.primed
	end,
	use = function(self, card)
		card.ability.extra.primed = true
		card.children.center:set_sprite_pos({ x = 1, y = 0 })
		local eval = function()
			return card.ability.extra.primed and not card.REMOVED
		end
		juice_card_until(card, eval, true)
	end,
	keep_on_use = function(self, card)
		return true
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		return {
			key = card.ability.extra.primed and (self.key .. "_primed") or nil,
		}
	end,
	calculate = function(self, card, context)
		if context.fac_fish_caught and card.ability.extra.primed then
			local reward = context.fac_fish_caught
			if not (reward.edition and reward.edition.key == "e_negative") then
				reward:set_edition("e_negative", true, true)
				SMODS.destroy_cards(card)
			end
		end
	end,
	set_sprites = function(self, card)
		if card.ability and card.ability.extra.primed then
			card.children.center:set_sprite_pos({ x = 1, y = 0 })
		end
	end,
})
