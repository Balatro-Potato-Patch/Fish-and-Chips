FishAndChips.Fish({
	key = "motif",
	weight = 1,
	environments = {
		backroom = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"on_sell",
		"sell_value",
	},
	atlas = "hayayaya_fih",
	pos = { x = 2, y = 1 },
	stats = {
		length = { min = 1, max = 1 },
		weight = { min = 1, max = 1 },
	},
	badge_key = "k_fac_hayayaya_object",
	calculate = function(self, card, context)
		if
			context.selling_card
			and context.card ~= card
			and context.card.config.center.set == "fac_Fish"
			and context.card.ability.fac_bait_used
		then
			local bait = context.card.ability.fac_bait_used
			G.E_MANAGER:add_event(Event({
				func = function()
					FishAndChips.add_bait_to_inventory(bait, 1)
					SMODS.calculate_effect({ message = localize("ph_facyou_hayayaya_returned"), instant = true }, card)
					return true
				end,
			}))
		end
	end,
	add_to_deck = function(self, card, from_debuff)
		for _, c in ipairs(G.fac_fish_area.cards) do
			c:set_cost()
		end
		card:set_cost()
	end,
	remove_from_deck = function(self, card, from_debuff)
		for _, c in ipairs(G.fac_fish_area.cards) do
			c:set_cost()
		end
		card:set_cost()
	end,
})

local set_sell_value = Card.set_sell_value
---@diagnostic disable-next-line
function Card:set_sell_value()
	set_sell_value(self)
	-- When freedom motif is present, set sell cost of fish to 0
	-- Only when it's not a perfect fish as well
	if
		self.config.center.set == "fac_Fish"
		and next(SMODS.find_card("fish_fac_motif"))
		and self.ability
		and self.ability.fac_bait_used
	then
		self.sell_cost = 0
	end
end
