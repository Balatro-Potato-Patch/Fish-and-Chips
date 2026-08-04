FishAndChips.Fish {
	key = "pa_fromg",
	weight = 6,
	atlas = "pa_pulsarfish",
	pos = { x = 3, y = 0 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "chips", "usable", "destroy_card" },
	environments = {
		swamp = 1,
		garden = 1,
		city_river = 1,
		calm_pond = 1,
		chocolate_river = 1
	},
	stats = {
		length = {min = 1.75, max = 2},
		weight = { min = 90, max = 100}
	},
	blueprint_compat = true,
	config = {
		extra = {
			chips_gain = 5,
			chips = 0
		},
		max_highlighted = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips_gain, card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
	end,
    can_use = function(self, card)
        return G.consumeables and #G.consumeables.highlighted > 0 and #G.consumeables.highlighted <= card.ability.max_highlighted
    end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.4,
			func = function()
				card:juice_up(0.3, 0.5)
				play_sound('tarot1')
				card.children.center:set_sprite_pos({x = 4, y = 0})
				return true
			end}))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                SMODS.destroy_cards(G.consumeables.highlighted)
				SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "chips",
					scalar_value = "chips_gain",
					operation = "+"
				})
                return true
            end
        }))
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.3,
			func = function()
				card:juice_up(0.3, 0.5)
				play_sound('tarot1')
				card.children.center:set_sprite_pos({x = 3, y = 0})
				return true
			end}))
	end
}