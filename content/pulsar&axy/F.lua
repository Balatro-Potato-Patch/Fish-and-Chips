FishAndChips.Fish {
	key = "pa_F",
	weight = 10,
	atlas = "pa_pulsarfish",
	pos = { x = 2, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "mult", "food" },
	environments = {
		soup = 1,
		backroom = 0.5
	},
	stats = {
		length = {min = 0.01, max = 0.01},  --vibes
		weight = {min = 0.0003, max = 0.0003}
	},
	blueprint_compat = true,
	config = {
		extra = {
			mult = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		local letter_count = 0
		local charmap = {}
		if G.fac_fish_area and G.fac_fish_area.cards then
			for _, fish in ipairs(G.fac_fish_area.cards) do
				for letter in string.gmatch(localize({ type = 'name_text', set = "fac_Fish", key = fish.config.center.key }), '.') do
					if not charmap[letter] then
						charmap[letter] = true
						letter_count = letter_count + 1
					end
				end
			end
		end
			
		return { vars = { card.ability.extra.mult, letter_count * card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
			card.ability.extra.chosen_hand = pseudorandom("pa_F", 0, G.GAME.current_round.hands_left)
        end

		if context.joker_main then
			local letter_count = 0
			local charmap = {}
			for _, fish in ipairs(G.fac_fish_area.cards) do
				for letter in string.gmatch(localize({ type = 'name_text', set = "fac_Fish", key = fish.config.center.key }), '.') do
					if not charmap[letter] then
						charmap[letter] = true
						letter_count = letter_count + 1
					end
				end
			end

			return {
				mult = letter_count * card.ability.extra.mult
			}
		end
	end,
}