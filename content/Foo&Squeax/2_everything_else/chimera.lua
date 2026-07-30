FishAndChips.Fish{
	key = "fas_chimera",
	atlas = "fas_credits_foo",
	config = {
		extra = {
			scaling = 0.401,
			xmult = 1,
			rate = 3,
		},
		immutable = {
			fish = "fish_fac_flounder",
		}
	},
	weight = 10,
	ppu_coder = {"Foo54"},
	environments = {
		soup = 1,
		wormhole = 1,
		backroom = 1,
	},
	attributes = {"scaling", "food", "xmult", "destroy_card"},
	load = function (self, card, card_table, other_card)
		card.T.w = card.T.w * card_table.ability.extra.xmult
	end,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS[card.ability.immutable.fish]
		return {vars = {localize{type = "name_text", key = card.ability.immutable.fish, set = "fac_Fish"}, card.ability.extra.rate, card.ability.extra.scaling, card.ability.extra.xmult}}
	end,
	update = function (self, card, dt)
		if FishAndChips.FooSqueax.fat_idiot.active then
			for _, box in ipairs(G.I.UIBOX) do
				if box.config.major == FishAndChips.FooSqueax.fat_idiot.fih then
					box:remove()
					for _, _box in ipairs(G.I.UIBOX) do
						if _box.config.major == box then
							_box:remove()
						end
					end
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.modify_weights then
			for _, _card in ipairs(context.pool) do
				if _card.key == card.ability.immutable.fish then
					_card.weight = _card.weight * card.ability.extra.rate
				end
			end
		end
		if context.fac_fish_caught and SMODS.has_attribute(context.fac_fish_caught.config.center, "food") and not context.blueprint and not FishAndChips.FooSqueax.fat_idiot.active then
			local fih = context.fac_fish_caught
			FishAndChips.FooSqueax.fat_idiot.fih = fih
			fih:start_materialize()
			FishAndChips.FooSqueax.fat_idiot.active = true
			FishAndChips.FooSqueax.fat_idiot.state = 0
			G.E_MANAGER:add_event(Event{
				func = function()
					if not FishAndChips.FooSqueax.fat_idiot.timer then
						fih.disable_align = true
						local angle = math.atan(card.T.y - fih.T.y, card.T.x - fih.T.x)
						local dist = 0.2
						local dx = dist * math.cos(angle)
						local dy = dist * math.sin(angle) / 2
						fih.T.x = fih.T.x + dx
						fih.T.y = fih.T.y + dy

						card.disable_align = true
						card.T.x = card.T.x - dx
						card.T.y = card.T.y - dy
					end
					if fih.T.x + fih.T.w / 2 >= card.T.x and fih.T.y + fih.T.h / 2 >= card.T.y then
						-- timer based system cause I can't use events within events while delaying future events
						if not FishAndChips.FooSqueax.fat_idiot.timer then
							FishAndChips.FooSqueax.fat_idiot.timer = G.TIMERS.REAL
						end
						if FishAndChips.FooSqueax.fat_idiot.state < 3 and G.TIMERS.REAL - FishAndChips.FooSqueax.fat_idiot.timer >= 0.5 then
							FishAndChips.FooSqueax.fat_idiot.state = FishAndChips.FooSqueax.fat_idiot.state + 1
							FishAndChips.FooSqueax.fat_idiot.timer = G.TIMERS.REAL
							card:juice_up()
							fih:juice_up()
						elseif FishAndChips.FooSqueax.fat_idiot.state == 3 then
							fih:shatter()
							FishAndChips.FooSqueax.fat_idiot.state = 4
						elseif FishAndChips.FooSqueax.fat_idiot.state == 4 and G.TIMERS.REAL - FishAndChips.FooSqueax.fat_idiot.timer < 2 then
							card.T.w = card.T.w / card.ability.extra.xmult
							SMODS.scale_card(card, {
								ref_table = card.ability.extra,
								ref_value = "xmult",
								scalar_value = "scaling",
								scaling_message = {
									message = localize("k_fac_fas_nom")
								}
							})
							card.T.w = card.T.w * card.ability.extra.xmult
							FishAndChips.FooSqueax.fat_idiot.active = false
							FishAndChips.FooSqueax.fat_idiot.timer = nil
							card.disable_align = false
							return true
						end
					end
				end
			})
		end
	end,
}