FishAndChips.Fish {
	key = "csc_fishmongus",
	atlas = "csc_fish",
	pos = { x = 0, y = 0 },
	badge_key = "k_fac_maybe_fish",

	ppu_coder = { "CyanSoCalico" },
	ppu_artist = { "CyanSoCalico" },

	attributes = { --[[idk which attributes would fit honestly lol]] "full_deck", "seals", "modify_card", --[[i do (mf)]] --[[i was also here hello! colon three! (ghostsalt)]] },
	config = {
		extra = {
			seal = "Red"
		}
	},

	stats = {
		weight = {
			min = 67.00,
			max = 69.00
		},
		length = {
			min = 0.67,
			max = 0.69
		}
	},

    weight = 1,
	environments = {
		volcano = 1,
		wormhole = 0.1,
		backroom = 0.1
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
		return { vars = { localize({type="name_text", set="Other", key=string.lower(card.ability.extra.seal).."_seal"}) } }
	end,

	calculate = function(self, card, context)
		if context.setting_blind then
			--[[ old bad version
            local playing_card
            local count = 0
            while (not playing_card) and count < #G.deck.cards do
                count = count + 1
                local test
                test = pseudorandom_element(G.deck.cards, pseudoseed(count))
                if not test.seal then
                    playing_card = test
                end
            end
            if playing_card then
                playing_card:set_seal(card.ability.extra.seal)
                return {
                    message = localize("k_fac_csc_add_seal"),
                    colour = G.C.RED,
                    effect = true
                }
            end

			new less bad version ]]
			local candidates = {}
			for k, v in ipairs(G.deck.cards) do
				candidates[#candidates+1] = (not v.seal) and not v.fac_chosen_by_fishmongus and v or nil
			end
			if next(candidates) then
				local playing_card = pseudorandom_element(candidates, pseudoseed("fishmongus"))
				playing_card.fac_chosen_by_fishmongus = true
				return {
                    message = localize("k_fac_csc_add_seal"),
                    colour = G.C.RED,
                    effect = true,
					func = function()
						playing_card:set_seal(card.ability.extra.seal)
						playing_card.fac_chosen_by_fishmongus = nil
					end,
					card = context.blueprint and context.blueprint_card or card,
                }
			end
        end
	end,
}
