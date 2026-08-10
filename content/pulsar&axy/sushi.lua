FishAndChips.Fish {
	key = "pa_sushi",
	weight = 8,
	atlas = "pa_pulsarfish",
	pos = { x = 5, y = 2 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "xmult", "food" },
	environments = {
		soup = 1,
	},
	stats = {
		length = {min = 0.14, max = 0.25},  --vibes
		weight = {min = 0.075, max = 140}
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