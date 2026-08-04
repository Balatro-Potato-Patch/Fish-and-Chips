FishAndChips.Fish {
	key = "pa_fishingfish",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "usable", "passive"},
	environments = {
		pier = 0.5,
		backroom = 1,
		city_river = 0.5
	},
	stats = {
        weight = {min = 4, max = 10}, --similar range to actual fishing rods lengths, but heavier
        length = {min = 1, max = 2.5}
    },
	blueprint_compat = true,
	config = {
		extra = {
			toggle = 0,
			modifier = 1.2
		}
	},
	loc_vars = function(self, info_queue, card)
		local choice = card.ability.extra.toggle % 3
		local direction = "same"
		local magnitude = 1
		
		if choice == 0 then
			choice = "speed"
			direction = "slower"
			magnitude = round_number(1 / card.ability.extra.modifier, 2)
		elseif choice == 1 then
			choice = "movement distance"
			direction = "lower"
			magnitude = round_number(1 / card.ability.extra.modifier, 2)
		elseif choice == 2 then
			choice = "movement time"
			direction = "larger"
			magnitude = round_number(card.ability.extra.modifier, 2)
		end
		return { vars = { card.ability.extra.toggle, choice, direction, magnitude } }
	end,
	calculate = function(self, card, context)
        if context.fac_modify_fishing_profile then
			local choice = card.ability.extra.toggle % 3
			if choice == 0 then
				context.fishing_profile.vel_limit = context.fishing_profile.vel_limit / card.ability.extra.modifier
			elseif choice == 1 then
				context.fishing_profile.impulse_max = context.fishing_profile.impulse_max / card.ability.extra.modifier
			elseif choice == 2 then
				context.fishing_profile.decision_max = context.fishing_profile.decision_max * card.ability.extra.modifier
			end
		end
	end,
	add_to_deck = function(self, card)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				card.children.center:set_sprite_pos({x = 0, y = (card.ability.extra.toggle % 3) + 1})
				return true
			end}))
	end,
	can_use = function(self, card)
		return true
	end,
	keep_on_use = function(self, card)
		return true
	end,
	use = function(self, card)
		card.ability.extra.toggle = card.ability.extra.toggle + 1
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				card:juice_up(0.3, 0.5)
				card.children.center:set_sprite_pos({x = 0, y = (card.ability.extra.toggle % 3) + 1})
				return true
			end}))
	end
}