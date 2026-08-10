-- lots of this code is from @foo54 on Discord, if we need help debugging, contact them
FishAndChips.Fish {
	key = "pa_box_jellyfish",
	weight = 7,
	atlas = "pa_pulsarfish",
	pos = { x = 2, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "usable" },
	environments = {
		pier = 1,
	},
	impulse_min = 0.75,
	impulse_max = 0.85, -- distance per impulse
	decision_min = 0.75,
	decision_max = 1.6, -- time in seconds
	vel_limit = 0.42, -- speed limit
	stats = {
		length = {min = 1.75, max = 2},
		weight = { min = .75, max = 1.25}
	},
	blueprint_compat = true,
	config = {
		extra = {
			ate_booster = false
		},
		max_highlighted = 1,
		immutable = {}
	},
	load = function(self, card, card_table, other_card)
		G.E_MANAGER:add_event(Event{
			func = function ()
				for _,_card in ipairs(G.fac_pa_box_jellyfish_area.cards) do
					if _card.ability.fac_pa_box_jellyfish == card.ability.immutable.id then
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
		card.ability.immutable.id = random_string(20, pseudoseed(self.key))
	end,
    can_use = function(self, card)
		local can_pick_booster = G.shop_booster and #G.shop_booster.highlighted > 0 and #G.shop_booster.highlighted <= card.ability.max_highlighted
		local in_fishing_environment = G.GAME.fishing and not FishAndChips.in_tutorial
		local can_use_booster
		for _, _card in ipairs(G.fac_pa_box_jellyfish_area.cards) do
			if _card.ability.fac_pa_box_jellyfish == card.ability.immutable.id then
				can_use_booster = true
				break
			end
		end
        return ((can_pick_booster and not can_use_booster) or (can_use_booster)) and not card.ability.extra.ate_booster
    end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card)
		local can_use_booster
		for _, _card in ipairs(G.fac_pa_box_jellyfish_area.cards) do
			if _card.ability.fac_pa_box_jellyfish == card.ability.immutable.id then
				can_use_booster = true
				break
			end
		end
		
		if can_use_booster then
			for _, _card in ipairs(G.fac_pa_box_jellyfish_area.cards) do
				if _card.ability.fac_pa_box_jellyfish == card.ability.immutable.id then
					G.fac_fish_area:unhighlight_all()
					G.GAME.fac_fish_expanded = false
					G.fac_fishing_bucket_bottom.T.r = 0; ease_value(G.fac_fishing_bucket_bottom.T, "r", nil, nil, nil, true)
					
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.4,
						func = function ()
							_card:juice_up(0.3, 0.5)
							play_sound('tarot1')
							G.FUNCS.use_card({ config = { ref_table = _card } })
							return true
						end}))
					card.ability.extra.ate_booster = true
					break
				end
			end
		else

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				card:juice_up(0.3, 0.5)
				play_sound('tarot1')
				return true
			end}))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
				local target_pack =	copy_card(G.shop_booster.highlighted[1])
				G.fac_pa_box_jellyfish_area:emplace(target_pack)
				target_pack.states.hover.can = false
				target_pack.ability.fac_pa_box_jellyfish = card.ability.immutable.id
				target_pack.cost = 0
				local card_remove_ref = card.remove
				function card:remove()
					card_remove_ref(self)
					if target_pack then
						target_pack:remove()
						target_pack = nil
					end
				end
                return true
            end
        }))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.3,
			func = function()
				card:juice_up(0.3, 0.5)
				play_sound('tarot1')
				return true
			end}))
		end
	end,
	calculate = function(self, card, context)
		if context.starting_shop and card.ability.extra.ate_booster then
			card.ability.extra.ate_booster = false
		end
	end,
	button_key = function(self, card)
		for _, _card in ipairs(G.fac_pa_box_jellyfish_area.cards) do
			if _card.ability.fac_pa_box_jellyfish == card.ability.immutable.id then
				return localize('k_fac_pa_box_jellyfish_open')
			end
		end
		return localize('k_fac_pa_box_jellyfish_consume')
	end,
}

local FishAndChips_mod_custom_card_areas_ref = FishAndChips.mod.custom_card_areas
function FishAndChips.mod.custom_card_areas(game)
	FishAndChips_mod_custom_card_areas_ref(game)
	G.fac_pa_box_jellyfish_area = CardArea( -- Should be saved in G for it to be preserved between reloads
        0, -- x coordinate relative to top left
        0, -- y coordinate relative to top left
        game.CARD_W * 4.95, -- width (this is the default for G.jokers)
        game.CARD_H * 0.95, -- height (this is the default for G.jokers)
        {
            -- optional, but recommended configs:
            type = 'joker', -- area type, doesn't affect what type of cards can be in it, only how they're displayed and act
            -- values can be `title`, `title_2`, `joker`, `shop`, `deck`, `hand`, `consumeable`, `voucher`, `play`, `discard`
            highlight_limit = 1,
            -- optional:
            bg_colour = game.C.CLEAR, -- background color
            no_card_count = true, -- removes the card count ui for the area types that have it by default
        }
    )
	function G.fac_pa_box_jellyfish_area:align_cards()
		local scale = 4
		for i, card in ipairs(self.cards) do
			for _,_card in ipairs(G.fac_fish_area.cards) do
				if _card.config.center.key == 'fish_fac_pa_box_jellyfish' and _card.ability.immutable.id == card.ability.fac_pa_box_jellyfish then
					-- translating top left corner of target_pack
                    card.T.x = _card.T.x + _card.T.w / 2 + 0.1
                    card.T.y = _card.T.y + _card.T.h / 2 - 0.6
                    card.T.r = _card.T.r
					-- scales card down
                    if not card.memT then card.memT = copy_table(card.T) end
                    card.T.w = card.memT.w / G.CARD_W * _card.T.w / scale
                    card.T.h = card.memT.h / G.CARD_H * _card.T.h / scale
					-- centers card around top left corner
                    card.T.x = card.T.x - card.T.w / 2
                    card.T.y = card.T.y - card.T.h / 2
				end
			end
		end
	end
end