FishAndChips.Fish{
	key = "fas_sardine",
	weight = 5,
	disable_visual_scaling = true,
	stats = {
		length = {min = 0.07, max = 0.20},
		weight = {min = 0.002, max = 0.005}
	},
	ppu_coder = {"Foo54"},
	environments = {
		city_river = 1,
		garden = 1
	},
	config = {
		extra = {
			limit = 2,
			chips = 25
		}
	},
	attributes = {"chips", "usable"},
	loc_vars = function(self, info_queue, card)
---@diagnostic disable-next-line: undefined-global
		if SynthB then SynthB.song_info(info_queue, card, "fac_zaako") end
		return {vars = {card.ability.extra.limit, card.ability.extra.chips}}
	end,
	calculate = function(self, card, context)
		if context.other_unknown and context.other_unknown.config.center.set == "fac_Fish" then
			if #(context.other_unknown.config.center.attributes or {}) <= card.ability.extra.limit then
				return {
					chips = card.ability.extra.chips
				}
			end
		end
	end,
	can_use = function (self, card)
		for i, _card in ipairs(G.fac_fish_area.cards) do
			if _card == card then
				return i > 1
			end
		end
		return false
	end,
	keep_on_use = function (self, card)
		return true
	end,
	use = function(self, card)
		for i, _card in ipairs(G.fac_fish_area.cards) do
			if _card == card then
				local __card = G.fac_fish_area.cards[i - 1]
				if __card then
					local attrs = #(__card.config.center.attributes or {})
					local s = "s"
					if attrs == 1 then s = "" end
					SMODS.calculate_effect({message = localize{type = "variable", key = "k_fac_fas_attributes", vars = {attrs, s}}}, __card)
				end
			end
		end
	end,
}