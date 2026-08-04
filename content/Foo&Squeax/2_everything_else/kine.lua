FishAndChips.Fish{
	key = "fas_kine",
	weight = 5,
	environments = {
		calm_pond = 0.2,
		garden = 1
	},
	ppu_coder = {"Foo54"},
	ppu_artist = {"squeax09"},
	atlas = 'fas_fish_general',
	pos = {x=4,y=0},
	pixel_size = {w=59,h=95},
	config = {
		immutable = {
			id = nil,
		}
	},
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	attributes = {"copying", "useable"},
	disable_visual_scaling = true,
	load = function (self, card, card_table, other_card)
		G.E_MANAGER:add_event(Event{
			func = function ()
				for _, _card in ipairs(G.fac_fas_kine_area.cards) do
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
		if not context.retrigger_joker_check then
			for _, _card in ipairs(G.fac_fas_kine_area.cards) do
				if _card.ability.fac_fas_kine == card.ability.immutable.id then
					return _card:calculate_joker(context)
				end
			end
		end
	end,
	can_use = function (self, card)
		for _, _card in ipairs(G.fac_fas_kine_area.cards) do
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
		for _, _card in ipairs(G.fac_fas_kine_area.cards) do
			if _card.ability.fac_fas_kine == card.ability.immutable.id then
				_card:start_dissolve()
				break
			end
		end
		if G.jokers.cards[1] then
			local _card = G.jokers.cards[1]
			G.jokers:remove_card(_card)
			G.fac_fas_kine_area:emplace(_card)
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
	end
}