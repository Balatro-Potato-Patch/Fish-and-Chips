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
		area_UI = {}
	},
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	attributes = {"copying", "usable"},
	disable_visual_scaling = true,
	loc_vars = function(self, info_queue, card)
		local joker = ""
		if G.fac_fas_kine_areas[card.ability.area_num] and G.fac_fas_kine_areas[card.ability.area_num].cards and G.fac_fas_kine_areas[card.ability.area_num].cards[1] then -- i probably dont need all three checks here but
			joker = G.P_CENTERS[G.fac_fas_kine_areas[card.ability.area_num].cards[1].config.center.key].name
		else
			joker = "None"
		end
		return {vars = {joker}}
	end,
	load = function (self, card, card_table, other_card)
		if card.ability.area_num ~= 0 then
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
			G.E_MANAGER:add_event(Event{
				func = function ()
					for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
						if _card.ability.fac_fas_kine == card.ability.area_num then
							_card.states.hover.can = false
							local card_remove_ref = card.remove
							function card:remove()
								card_remove_ref(self)
								if _card then
									_card:remove()
									_card = nil
								end
							end
						end
					end
					return true
				end
			})
		end
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval and not context.blueprint then
			for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
				_card:calculate_rental()
				if not _card.debuff then
					_card:calculate_perishable()
				end
			end
		end
		if not context.retrigger_joker_check then
			for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
				if _card.ability.fac_fas_kine == card.ability.area_num then
					return _card:calculate_joker(context)
				end
			end
		end
	end,
	can_use = function (self, card)
		for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
			if _card.ability.fac_fas_kine == card.ability.area_num then
				return true
			end
		end
		return G.jokers.cards[1]
	end,
	keep_on_use = function (self, card)
		return true
	end,
	use = function (self, card)
		if G.fac_fas_kine_areas[card.ability.area_num].cards and G.fac_fas_kine_areas[card.ability.area_num].cards[1] then
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
	end,
	remove_from_deck = function (self, card, from_debuff)
		if G.fac_fas_kine_areas[card.ability.area_num].cards then
			SMODS.destroy_cards(G.fac_fas_kine_areas[card.ability.area_num].cards, { bypass_eternal = true })
		end
		G.fac_fas_kine_areas[card.ability.area_num]:remove()
		G.fac_fas_kine_areas[card.ability.area_num] = nil
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