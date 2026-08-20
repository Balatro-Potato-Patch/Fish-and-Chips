FishAndChips.Fish {
    key = 'gappieyouh_psa',
    atlas = 'gy_fish',
    weight = 5,
    pos = {x=5,y=0},
    ppu_coder = { 'Youh' },
    ppu_artist = { 'Gappie' },
    attributes = { 'economy', 'boss_blind', "generation", },
    stats = {
        weight = {min = 0.001, max = 0.01},
        length = {min = 0.1, max = 0.15}
    },
    environments = {
        garden = 1,
        calm_pond = 1,
        wormhole = 1,
        backroom = 1
    },
    config = {
        extra = {
            bait = 2,
            sand_dollars = 3
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.bait, card.ability.extra.sand_dollars}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
            -- everybody say thank you wilson for the code
			local w = (G.CARD_W + 0.1) * card.ability.extra.bait * 2 - 0.1
			local h = G.CARD_H
			local created_bait = {}
			delay(1)
			for i = 1, card.ability.extra.bait do
				G.E_MANAGER:add_event(Event {
					func = function()
						local _card = SMODS.create_card { set = "fac_Bait" }
						if not G.fac_temp_bait_area then
							G.fac_temp_bait_area = CardArea(
								card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.5 - h,
								w, h,
								{
									type = "joker",
									card_limit = card.ability.extra.bait,
									highlight_limit = 1,
									highlighted_limit = 1,
									align_buttons = true,
									bg_colour = G.C.CLEAR,
									fixed_limit = true,
									no_card_count = true,
								}
							)
						end
						G.fac_temp_bait_area:emplace(_card)
						created_bait[#created_bait + 1] = _card
						FishAndChips.add_bait_to_inventory(_card.config.center.key)
						return true
					end
				})
				delay(0.2)
			end
			delay(1)
			for i = 1, card.ability.extra.bait do
				G.E_MANAGER:add_event(Event {
					func = function()
						created_bait[i]:start_dissolve()
						return true
					end
				})
				delay(0.2)
			end
			delay(0.5)
			G.E_MANAGER:add_event(Event {
				func = function()
					G.fac_temp_bait_area:remove()
					G.fac_temp_bait_area = nil
					return true
				end
			})
            return {sand_dollars = card.ability.extra.sand_dollars}
        end
    end
}
