FishAndChips.Fish {
	key = "pa_sushi",
	weight = 8,
	atlas = "pa_pulsarfish",
	pos = { x = 2, y = 1 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "mult", "food" },
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

		if card.config and card.config.center and card.config.center.set == "fac_Fish" and card.area and (card.area.config.collection or card.area.config.fac_compendium) then
			for _, fish in ipairs(G.FAC_ENVIRONMENT_POOL) do
				for letter in string.gmatch(localize{type = "name_text", set = "fac_Env", key = fish.key}, '.') do
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
        -- each fish catchable in the soup gives x1.5 mult
        if context.other_joker and context.other_joker then
            return {
                xmult = card.ability.extra.xmult
            }
        end
	end,
}