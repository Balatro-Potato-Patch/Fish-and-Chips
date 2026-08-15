


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
	disable_visual_scaling = true,
	badge_key = "k_fac_fas_worm",
	attributes = {"xmult", "useble", "scaling", "generation"},
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
			for _, dev in ipairs(G.P_CENTERS[context.fish].ppu_coder) do
				if dev == G.GAME.fac_FooSqueax.wormholes.target or dev == PotatoPatchUtils.Developers["fac_" .. G.GAME.fac_FooSqueax.wormholes.target].fac_partner then
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
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
	can_use = function (self, card)
		return card.ability.extra.xmult > 1
	end,
	use = function(self, card)
		local bait = card.ability.extra.bait * (card.ability.extra.xmult - 1)
		local w = (G.CARD_W + 0.1) * 3 - 0.1
		local h = G.CARD_H
		G.fac_temp_bait_area = CardArea(
			card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
			w, h,
			{
				type = "joker",
				card_limit = bait,
				highlight_limit = 1,
				highlighted_limit = 1,
				align_buttons = true,
				bg_colour = G.C.CLEAR,
				fixed_limit = true,
				no_card_count = true,
			}
		)
		delay(1)
		for i = 1, bait do
			G.E_MANAGER:add_event(Event {
				func = function()
					local card = SMODS.create_card { set = "fac_Bait" }
					G.fac_temp_bait_area:emplace(card)
					FishAndChips.add_bait_to_inventory(card.config.center.key)
					return true
				end
			})
			delay(0.2)
		end
		delay(3)
		for i = 1, bait do
			G.E_MANAGER:add_event(Event {
				func = function()
					G.fac_temp_bait_area.cards[1]:start_dissolve()
					return true
				end
			})
			delay(0.2)
		end
		delay(0.5)
		G.E_MANAGER:add_event(Event {
			func = function()
				G.fac_temp_bait_area:remove()
				card:start_dissolve()
				return true
			end
		})
	end,
}
