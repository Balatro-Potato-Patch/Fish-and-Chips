FishAndChips.Fish {
	key = "pa_fishingfish",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "passive" },
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
			modifier = 1.2
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.modifier } }
	end,
	calculate = function(self, card, context)
        if context.fac_modify_fishing_profile then
			context.fishing_profile.vel_limit = context.fishing_profile.vel_limit / card.ability.extra.modifier
		end
	end,
}