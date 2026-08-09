FishAndChips.Fish {
	key = "pa_sushi",
	weight = 8,
	atlas = "pa_pulsarfish",
	pos = { x = 2, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xmult", "food" },
	environments = {
		soup = 1,
	},
	stats = {
		length = {min = 0.01, max = 0.01},  --vibes
		weight = {min = 0.0003, max = 0.0003}
	},
	blueprint_compat = true,
	config = {
		extra = {
			xmult = 1.5
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
        local other_fish_in_soup = context.other_unknown and context.other_unknown.config.center and context.other_unknown.config.center.environments and context.other_unknown.config.center.environments.soup
        if other_fish_in_soup then
            return {
                xmult = card.ability.extra.xmult
            }
        end
	end,
}