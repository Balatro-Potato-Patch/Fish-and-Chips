


FishAndChips.Fish{
	key = "fas_can_of_wormholes",
	atlas = "fas_fish_general",
	pos = {x = 2, y = 0},
	ppu_artist = {"Foo54"},
	ppu_coder = {"squeax09"},
	environments = {
		wormhole = 1,
		city_river = 0.2,
	},
	stats = {
		length = {min = 0.01, max = 0.05},
		weight = {min = 0.01, max = 0.05}
	},
	weight = 5,
	config = {
		extra = {
			scale = 1,
			xmult = 1,
			bait = 3
		}
	},
	perishable_compat = false,
	disable_visual_scaling = true,
	badge_key = "k_fac_fas_worm",
	attributes = {"xmult", "usable", "scaling", "generation"},
	loc_vars = function(self, info_queue, card)
		return {vars = {
			card.ability.extra.scale,
			localize{type = "name_text", set = "PotatoPatch", key = G.GAME.fac_FooSqueax and ("PotatoPatchDev_" .. G.GAME.fac_FooSqueax.wormholes.target) or "fac_fas_dev"},
			card.ability.extra.xmult,
			card.ability.extra.bait
		}}
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and not context.failed and not context.blueprint then
			for _, dev in ipairs(SMODS.merge_lists{ G.P_CENTERS[context.fish].ppu_coder, G.P_CENTERS[context.fish].ppu_artist }) do
				if dev == G.GAME.fac_FooSqueax.wormholes.target then
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "xmult",
						scalar_value = "scale"
					})
					return nil, true
				end
			end
		end
		if context.joker_main then
			return { xmult = card.ability.extra.xmult }
		end
	end,
	can_use = function (self, card)
		return card.ability.extra.xmult >= 2
	end,
	use = function(self, card)
		FishAndChips.create_baits_from_card(card, card.ability.extra.bait * (card.ability.extra.xmult - 1))
	end,
}
