FishAndChips.Fish{
	key = "fas_kine",
	weight = 5,
	environments = {
		garden = 1,
		calm_pond = 0.2,
	},
	ppu_coder = {"Foo54"},
	ppu_artist = {"squeax09"},
	atlas = 'fas_fish_general',
	pos = {x=4,y=0},
	pixel_size = {w=59,h=95},
	config = {
		immutable = {
			id = nil,
		},
		area_num = 0
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
			joker = G.P_CENTERS[G.fac_fas_kine_areas[card.ability.area_num].cards[1].config.center_key].name
			info_queue[#info_queue+1] = G.P_CENTERS[G.fac_fas_kine_areas[card.ability.area_num].cards[1].config.center_key]
		else
			joker = "None"
		end
		return {vars = {joker}}
	end,
	load = function (self, card, card_table, other_card)
		G.fac_fas_kine_areas[card.ability.area_num] = CardArea(
			-20, -20,
			G.CARD_W, G.CARD_H,
			{
				type = "joker",
				highlighted_limit = 1,
				highlight_limit = 1
			}
		)
		G.E_MANAGER:add_event(Event{
			func = function ()
				for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
					if _card.ability.fac_fas_kine == card.ability.immutable.id then
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
	end,
	set_ability = function (self, card, initial, delay_sprites)
		card.ability.immutable.id = random_string(20, pseudoseed("fac_fas_kine"))
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
				if _card.ability.fac_fas_kine == card.ability.immutable.id then
					return _card:calculate_joker(context)
				end
			end
		end
	end,
	can_use = function (self, card)
		for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
			if _card.ability.fac_fas_kine == card.ability.immutable.id then
				return true
			end
		end
		return G.jokers.cards[1]
	end,
	keep_on_use = function (self, card)
		return true
	end,
	use = function (self, card)
		for _, _card in ipairs(G.fac_fas_kine_areas[card.ability.area_num].cards) do
			if _card.ability.fac_fas_kine == card.ability.immutable.id then
				_card:start_dissolve()
				break
			end
		end
		if G.jokers.cards[1] then
			local _card = G.jokers.cards[1]
			G.jokers:remove_card(_card)
			G.fac_fas_kine_areas[card.ability.area_num]:emplace(_card)
			_card.states.hover.can = false
			_card.ability.fac_fas_kine = card.ability.immutable.id
			local card_remove_ref = card.remove
			function card:remove()
				card_remove_ref(self)
				if _card then
					_card:remove()
					_card = nil
				end
			end
		end
	end,
	add_to_deck = function (self, card, from_debuff)
		G.fac_fas_kine_areas[#G.fac_fas_kine_areas+1] = CardArea(
			-20, -20,
			G.CARD_W, G.CARD_H,
			{
				type = "joker",
				highlighted_limit = 1,
				highlight_limit = 1
			}
		)
		card.ability.area_num = #G.fac_fas_kine_areas
	end,
	remove_from_deck = function (self, card, from_debuff)
		if G.fac_fas_kine_areas[card.ability.area_num].cards then
			SMODS.destroy_cards(G.fac_fas_kine_areas[card.ability.area_num].cards, { bypass_eternal = true })
		end
		G.fac_fas_kine_areas[card.ability.area_num] = nil
	end
}
