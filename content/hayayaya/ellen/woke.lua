FishAndChips.Fish({
	key = "celadon",
	weight = 4,
	environments = {
		garden = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"editions",
		"usable",
	},
	-- atlas = "hayayaya_fih",
	-- pos = { x = 1, y = 1 },
	stats = {
		length = { min = 1, max = 1 },
		weight = { min = 1, max = 1 },
	},
	badge_key = "k_fac_hayayaya_badge_q",
	can_use = function(self, card)
		local eligible = {}
		for _, c in ipairs(G.fac_fish_area.cards) do
			-- Must not be itself
			if c == card then
				goto continue
			end
			-- Must not have an edition
			if c.edition then
				goto continue
			end
			eligible[#eligible + 1] = c
			::continue::
		end
		return #eligible > 0
	end,
	use = function(self, card)
		---@type balatro.Card[]
		local eligible = {}
		for _, c in ipairs(G.fac_fish_area.cards) do
			-- Must not be itself
			if c == card then
				goto continue
			end
			-- Must not have an edition
			if c.edition then
				goto continue
			end
			eligible[#eligible + 1] = c
			::continue::
		end
		local c = pseudorandom_element(eligible, "fac_celadon_" .. G.GAME.round_resets.ante)

		G.E_MANAGER:add_event(Event({
			delay = 0.4,
			trigger = "after",
			func = function()
				---@type balatro.Card
				c:set_edition("e_polychrome", true)
				card:juice_up(0.3, 0.5)
				return true
			end,
		}))

		delay(0.6)
	end,
})
