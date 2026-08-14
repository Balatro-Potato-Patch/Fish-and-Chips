SMODS.Atlas({
	key = "stoatskidev", -- Please include your name/team name in your atlas keys
	path = "stoatski/stoatskidev.png",
	px = 71,
	py = 95,
})

PotatoPatchUtils.Developer({
	name = 'stoatski',
	-- Unsure why this is not working
	atlas = 'fac_stoatskidev',
	colour = G.C.SECONDARY_SET.Spectral,
	ignore_limits = false
})


SMODS.Atlas({
	key = "stoatskifish", -- Please include your name/team name in your atlas keys
	path = "stoatski/stoatskifish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "otter",
	weight = 10, -- TODO: could this be 75 weight ?
	atlas = "stoatskifish",
	pos = { x = 0, y = 0 },
	-- I belive this is correct but may need other attributes -- Yeah (mf)
	attributes = { "generation", "destroy_card", "consumable", "spectral", "position", },
	ppu_coder = { "stoatski" },
	ppu_artist = { "stoatski" },
	blueprint_compat = false,
	stats = {
        weight = {min = 5, max = 45},
	    length = {min = 0.6, max = 1.8}
    },

    environments = {
		calm_pond = 10,
		pier = 10,
		city_river = 5
	},

	-- Caculate function
	calculate = function(self, card, context)
		-- If the contexxt is the start of round/after selecting a blind
		if context.setting_blind then
			-- Checks to see if this fish is the rightmost fish
			if G.fac_fish_area.cards[#G.fac_fish_area.cards] ~= card then
				-- destoys rightmost fish and displays message if this card was the rightmost
				SMODS.destroy_cards(G.fac_fish_area.cards[#G.fac_fish_area.cards])
				SMODS.add_card({set = "Spectral", area = G.consumeables})
				return {message = localize("ph_otter_eat")}
			else
				-- Destoys self and displays message if this fish was the rightmost
				return {
					message = localize("ph_otter_run"),
					SMODS.destroy_cards(G.fac_fish_area.cards[#G.fac_fish_area.cards])

				}
			end
		end

	end

}
