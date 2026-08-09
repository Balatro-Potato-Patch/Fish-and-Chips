FishAndChips.Fish {
	key = "pa_charcoal_biscuit",
	weight = 8,
	atlas = "pa_pulsarfish",
	pos = { x = 2, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "suit", "spades", "retrigger", "food" },
	environments = {
		chocolate_river = 1,
	},
	stats = {
		length = {min = 0.01, max = 0.01},  --vibes
		weight = {min = 0.0003, max = 0.0003}
	},
	blueprint_compat = true,
	config = {
		extra = {
			repetitions = 1
		}
	},
	loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.repetitions}}
	end,
	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:is_suit('Spades') then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
	end,
}