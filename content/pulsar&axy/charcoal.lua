SMODS.Atlas({
	key = 'pa_axywoo',
	path = 'pulsar&axy/axywoo.png',
	px = 555,
	py = 552
})

FishAndChips.Fish {
	key = "pa_charcoal_biscuit",
	weight = 8,
	atlas = "pa_pulsarfish",
	pos = { x = 5, y = 3 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "suit", "spades", "retrigger", "food" },
	environments = {
		chocolate_river = 1,
		volcano = 1
	},
	impulse_min = 0.12,
	impulse_max = 0.3, -- distance per impulse
	decision_min = 1,
	decision_max = 2, -- time in seconds
	vel_limit = 0.86, -- speed limit
	stats = {
		length = {min = .057, max = 0.10},
		weight = {min = .120, max = .170}
	},
	blueprint_compat = true,
	config = {
		extra = {
			repetitions = 1
		}
	},
	loc_vars = function(self, info_queue, card)
        return {vars = {
			card.ability.extra.repetitions
		}}
	end,
	flavour_vars = function(self, info_queue, card)
		return {vars = {
			elements = { SMODS.create_sprite(0, 0, 0.5, 0.5 * 552 / 555, "fac_pa_axywoo") }
		}}
	end,
	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:is_suit('Spades') then
            return {
                repetitions = card.ability.extra.repetitions
            }
        end
	end,
}