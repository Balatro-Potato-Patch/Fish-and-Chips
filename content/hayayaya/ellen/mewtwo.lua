FishAndChips.Fish({
	key = "mewtwostrikesback",
	weight = 2,
	environments = {
		styx = 0.3,
		wormhole = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"generation",
		"usable",
	},
	atlas = "hayayaya_fih",
	pos = { x = 0, y = 0 },
	-- TODO: Possibly tweak this????
	config = { extra = { min = 0.5, max = 2 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.min, card.ability.extra.max },
		}
	end,
	can_use = function(self, card)
		local eligible = {}
		for _, c in ipairs(G.fac_fish_area.cards) do
			-- Must not be itself
			if c == card then
				goto continue
			end
			-- Must not be another one of its kin
			if c.config.center_key == self.key then
				goto continue
			end
			eligible[#eligible + 1] = c
			::continue::
		end
		return #eligible > 0
	end,
	use = function(self, card)
		delay(0.5)

		local eligible = {}
		for _, c in ipairs(G.fac_fish_area.cards) do
			-- Must not be itself
			if c == card then
				goto continue
			end
			-- Must not be another one of its kin
			if c.config.center_key == self.key then
				goto continue
			end
			eligible[#eligible + 1] = c
			::continue::
		end

		local picked = pseudorandom_element(eligible, "mewtwo_fish_" .. G.GAME.round_resets.ante)

		G.E_MANAGER:add_event(Event({
			func = function()
				local copied = SMODS.copy_card(picked)
				HayayayaUtils.Misprintize({
					val = copied.ability,
					amt = pseudorandom(
						"mewtwo_fish_rnd_" .. G.GAME.round_resets.ante,
						card.ability.extra.min,
						card.ability.extra.max
					),
				})
				copied.ability.immutable = copied.ability.immutable or {}
				-- For the name 'two', 'three', etc.
				copied.ability.immutable.hayayaya_clone_count = (
					copied.ability.immutable.hayayaya_clone_count
						and copied.ability.immutable.hayayaya_clone_count + 1
					or 2
				)
				-- Go straight to two
				if copied.ability.immutable.hayayaya_clone_count == 1 then
					copied.ability.immutable.hayayaya_clone_count = 2
				end
				copied.ability.immutable.hayayaya_clone_suffix =
					HayayayaUtils.LocalizeNumber(copied.ability.immutable.hayayaya_clone_count)
				-- print(copied.ability.immutable.hayayaya_clone_suffix)
				card:juice_up()
				return true
			end,
		}))

		delay(0.5)
	end,
})
