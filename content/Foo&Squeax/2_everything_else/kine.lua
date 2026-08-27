FishAndChips.Fish{
	key = "fas_kine",
	weight = 5,
	environments = {
		garden = 1,
		calm_pond = 0.2,
	},
	ppu_coder = {"Foo54", "squeax09"},
	ppu_artist = {"squeax09"},
	atlas = 'fas_fish_general',
	pos = {x=4,y=0},
	pixel_size = {w=59,h=95},
	config = {
		area_num = 0,
		area_UI = {},
		stored_center = ""
	},
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	attributes = {"copying", "usable"},
	disable_visual_scaling = true,
	loc_vars = function(self, info_queue, card)
		local joker = ""
		if G.fac_fas_kine_areas and G.fac_fas_kine_areas[card.ability.area_num] and G.fac_fas_kine_areas[card.ability.area_num].cards and G.fac_fas_kine_areas[card.ability.area_num].cards[1] then -- i probably dont need all three checks here but
			joker = G.P_CENTERS[card.ability.stored_center].name
		else
			joker = "None"
		end
		local joker_check = G.jokers and #G.jokers.cards > 0 and G.jokers.cards[1].ability.eternal
		return {vars = {joker, (joker_check and "(Cannot grab " or ""), (joker_check and "Eternals" or ""), (joker_check and ")" or "")}}
	end,
	load = function (self, card, card_table, other_card)
		card.ability.area_UI = {}
		local reload_flags = {}
		function FishAndChips.FooSqueax.kine_reload(table)
			table = {
				saved_area = card.ability.area_num ~= 0,
				rendered_area = saved_area and G.fac_fas_kine_areas[card.ability.area_num],
				stored_center = card.ability.stored_center,
				area_cards = rendered_area and stored_center,
				rendered_cards = stored_center and stored_center == G.fac_fas_kine_areas[card.ability.area_num].cards[1],
				card_UI = rendered_cards and card.ability.area_UI ~= {},
			}
		end
		FishAndChips.FooSqueax.kine_reload(reload_flags)
		if not reload_flags.saved_area then
			card.ability.area_num = #G.fac_fas_kine_areas+1
			reload_flags.saved_area = true
		end
		FishAndChips.FooSqueax.kine_reload(reload_flags)
		if not reload_flags.rendered_area then
			G.fac_fas_kine_areas[card.ability.area_num] = CardArea(
				-10, -10,
				G.CARD_W, G.CARD_H,
				{
					card_limit = 1,
					type = "joker",
					highlighted_limit = 1,
					highlight_limit = 1,
				}
			)
			G.fac_fas_kine_areas[card.ability.area_num].states.visible = false
			reload_flags.rendered_area = true
		end

		FishAndChips.FooSqueax.kine_reload(reload_flags)
		if reload_flags.area_cards and not reload_flags.rendered_cards and reload_flags.stored_center then
			SMODS.destroy_cards(G.fac_fas_kine_areas[card.ability.area_num].cards, { bypass_eternal = true })
		end
		FishAndChips.FooSqueax.kine_reload(reload_flags)
		if reload_flags.stored_center and not reload_flags.rendered_cards and reload_flags.rendered_area then
			G.E_MANAGER:add_event(Event{
				func = function ()
					local _card = SMODS.create_card({
						set = "Joker",
						key = card.ability.stored_center,
						area = G.fac_fas_kine_areas[card.ability.area_num]
					})
					_card.T.w = G.CARD_W / 3
					_card.T.h = G.CARD_H / 3
					_card.states.hover.can = true
					_card.states.click.can = false
					_card.no_shadow = true
					_card.ability.fac_fas_kine = card.ability.area_num
					G.fac_fas_kine_areas[card.ability.area_num]:emplace(_card)
					return true
				end
			})
			reload_flags.rendered_cards = true
		end
		FishAndChips.FooSqueax.kine_reload(reload_flags)
		if not reload_flags.cardUI then
			card.ability.area_UI = UIBox({
				definition = {
					n = G.UIT.ROOT,
					config = { colour = G.C.CLEAR },
					nodes = {
						{ n = G.UIT.O, config = { object = G.fac_fas_kine_areas[card.ability.area_num].cards[1] } },
					},
				},
				config = {
					align = "cr",
					offset = { x = -0.45, y = 0.05 },
					major = card,
					instance_type = "CARD",
				},
			})
			reload_flags.cardUI = true
		end
		FishAndChips.FooSqueax.kine_reload(reload_flags)
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint and G.fac_fas_kine_areas[card.ability.area_num] then
			for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
				_card:calculate_rental()
				if not _card.debuff then
					_card:calculate_perishable()
				end
			end
		end
		if not context.retrigger_joker_check and G.fac_fas_kine_areas[card.ability.area_num] then
			for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
				if _card.ability.fac_fas_kine == card.ability.area_num then
					return _card:calculate_joker(context)
				end
			end
		end
	end,
	can_use = function (self, card)
		if G.fac_fas_kine_areas[card.ability.area_num] then
			for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
				if _card.ability.fac_fas_kine == card.ability.area_num then
					return true
				end
			end
		end
		return G.jokers.cards[1] and not G.jokers.cards[1].ability.eternal
	end,
	keep_on_use = function (self, card)
		return true
	end,
	use = function (self, card)
		if G.fac_fas_kine_areas[card.ability.area_num] and G.fac_fas_kine_areas[card.ability.area_num].cards and G.fac_fas_kine_areas[card.ability.area_num].cards[1] then
			for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
				if _card.ability.fac_fas_kine == card.ability.area_num then
					_card:start_dissolve()
					G.fac_fas_kine_areas[card.ability.area_num].cards[_] = nil
					card.ability.area_UI = {}
					break
				end
			end
		end
		if G.jokers.cards[1] then
			G.E_MANAGER:add_event(Event{
				func = function()
					local _card = G.jokers.cards[1]
					_card.T.w = G.CARD_W / 3
					_card.T.h = G.CARD_H / 3
					G.jokers:remove_card(_card)
					G.fac_fas_kine_areas[card.ability.area_num]:emplace(_card)
					card.ability.area_UI = UIBox({
						definition = {
							n = G.UIT.ROOT,
							config = { colour = G.C.CLEAR },
							nodes = {
								{ n = G.UIT.O, config = { object = G.fac_fas_kine_areas[card.ability.area_num].cards[1] } },
							},
						},
						config = {
							align = "cr",
							offset = { x = -0.45, y = 0.05 },
							major = card,
							instance_type = "CARD",
						},
					})
					_card.states.hover.can = true
					_card.states.click.can = false
					_card.no_shadow = true
					_card.ability.fac_fas_kine = card.ability.area_num
					card.ability.stored_center = _card.config.center.key
					local card_remove_ref = card.remove
					function card:remove()
						card_remove_ref(self)
						if _card then
							_card:remove()
							_card = nil
						end
					end
					return true
				end
			})
			delay(0.07)
		end
		G.fac_fas_kine_areas[card.ability.area_num]:save()
		G:save_progress()
	end,
	add_to_deck = function (self, card, from_debuff)
		if not G.fac_fas_kine_areas[card.ability.area_num] then -- If a kine joker cardarea has not been made for Kine [aka when getting a new one to start with]
			card.ability.area_num = #G.fac_fas_kine_areas+1
			G.fac_fas_kine_areas[card.ability.area_num] = CardArea(
				-10, -10,
				G.CARD_W, G.CARD_H,
				{
					type = "joker",
					card_limit = 1,
					highlighted_limit = 1,
					highlight_limit = 1
				}
			)
			G.fac_fas_kine_areas[card.ability.area_num].states.visible = false
		else -- Fallback
			card.ability.area_num = #G.fac_fas_kine_areas+1
			G.fac_fas_kine_areas[card.ability.area_num] = CardArea(
				-10, -10,
				G.CARD_W, G.CARD_H,
				{
					type = "joker",
					card_limit = 1,
					highlighted_limit = 1,
					highlight_limit = 1
				}
			)
			G.fac_fas_kine_areas[card.ability.area_num].states.visible = false
		end
		if card.ability.stored_center ~= "" then
			G.E_MANAGER:add_event(Event{
				func = function ()
					local _card = SMODS.create_card({
						set = "Joker",
						key = card.ability.stored_center,
						area = G.fac_fas_kine_areas[card.ability.area_num]
					})
					_card.T.w = G.CARD_W / 3
					_card.T.h = G.CARD_H / 3
					_card.states.hover.can = true
					_card.states.click.can = false
					_card.no_shadow = true
					_card.ability.fac_fas_kine = card.ability.area_num
					G.fac_fas_kine_areas[card.ability.area_num]:emplace(_card)
					card.ability.area_UI = UIBox({
						definition = {
							n = G.UIT.ROOT,
							config = { colour = G.C.CLEAR },
							nodes = {
								{ n = G.UIT.O, config = { object = G.fac_fas_kine_areas[card.ability.area_num].cards[1] } },
							},
						},
						config = {
							align = "cr",
							offset = { x = -0.45, y = 0.05 },
							major = card,
							instance_type = "CARD",
						},
					})
					return true
				end
			})
		end
	end,
	remove_from_deck = function (self, card, from_debuff)
		if G.fac_fas_kine_areas[card.ability.area_num] then
			if G.fac_fas_kine_areas[card.ability.area_num].cards then
				SMODS.destroy_cards(G.fac_fas_kine_areas[card.ability.area_num].cards, { bypass_eternal = true })
			end
			G.fac_fas_kine_areas[card.ability.area_num]:remove()
			G.fac_fas_kine_areas[card.ability.area_num] = nil
		end
		card.ability.area_num = 0
		card.ability.area_UI = {}
	end,
}

local game_update_ref = Game.update
function Game:update(dt)
	game_update_ref(self, dt)
	if G.fac_fas_kine_areas then
		G.fac_fas_kine_areas:align_cards()
	end
end

copy_card_ref = copy_card
function copy_card(other, new_card, card_scale, playing_card, strip_edition)
	if other.config.center.key == 'fish_fac_fas_kine' then
		local new_card = SMODS.create_card({
			set = "fac_Fish",
			key = "fish_fac_fas_kine",
			area = G.fac_fish_area
		})
		if not strip_edition then 
			new_card:set_edition(other.edition or {}, nil, true)
			for k,v in pairs(other.edition or {}) do
				if type(v) == 'table' then
					new_card.edition[k] = copy_table(v)
				else
					new_card.edition[k] = v
				end
			end
		end
		check_for_unlock({type = 'have_edition'})
		new_card:set_seal(other.seal, true)
		if other.seal then
			for k, v in pairs(other.ability.seal or {}) do
				if type(v) == 'table' then
					new_card.ability.seal[k] = copy_table(v)
				else
					new_card.ability.seal[k] = v
				end
			end
		end
		if other.params then
			new_card.params = other.params
			new_card.params.playing_card = playing_card
		end
		new_card.debuff = other.debuff
		new_card.pinned = other.pinned
		if other.edition and strip_edition then
			new_card.ability.card_limit = new_card.ability.card_limit - (other.edition.card_limit or 0)
			new_card.ability.extra_slots_used = new_card.ability.extra_slots_used - (other.edition.extra_slots_used or 0)
		end
		if other.ability.stored_center then new_card.ability.stored_center = other.ability.stored_center end
		new_card:set_cost()
		return new_card
	else
		return copy_card_ref(other, new_card, card_scale, playing_card, strip_edition)
	end
end