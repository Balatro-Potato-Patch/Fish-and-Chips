FishAndChips.Fish {
	key = "pa_doorfish",
	weight = 5,
	atlas = "pa_pulsarfish",
	pos = { x = 6, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "generation", "usable" },
	environments = {
		city_river = 1,
		backroom = 0.5
	},
	stats = {
		length = { min = 0.0120, max = 0.0120},  --based on ordinary cd
		weight = { min = 0.02, max = 0.02}
	},
	choose = 3,
	blueprint_compat = true,
	config = {
		extra = {
			 times_used = 0
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.times_used + 1 } }
	end,
    can_use = function(self, card)
        local in_fishing_environment = G.GAME.fishing and not FishAndChips.in_tutorial
        return in_fishing_environment
    end,
	use = function(self, card)
        check_rank()
	end,
}