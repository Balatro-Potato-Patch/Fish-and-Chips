---@diagnostic disable: cast-local-type
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
	attributes = {"chips", "vocaloid"},
	loc_vars = function(self, info_queue, card)
---@diagnostic disable-next-line: undefined-global
		if SynthB then SynthB.song_info(info_queue, card, "fac_zaako") end
		local msg_left = localize{type = "variable", key = "ph_fac_fas_zaako_no_fish", vars = {localize("k_fac_fas_left")}}
		local msg_right = localize{type = "variable", key = "ph_fac_fas_zaako_no_fish", vars = {localize("k_fac_fas_right")}}
		if card.area and card.area.cards then
			for i, _card in ipairs(card.area.cards) do
				if _card == card then
					local __card = card.area.cards[i - 1]
					if __card then
						if __card.config.center.set ~= "fac_Fish" then
							msg_left = localize{type = "variable", key = "ph_fac_fas_zaako_not_a_fish", vars = {localize("k_fac_fas_left")}}
						else
							local attrs = #(__card.config.center.attributes or {})
							local s = "s"
							if attrs == 1 then s = "" end
							msg_left = localize{type = "variable", key = "ph_fac_fas_attributes", vars = {attrs, s, localize("k_fac_fas_left")}}
						end
					end
					local ___card = card.area.cards[i + 1]
					if ___card then
						if ___card.config.center.set ~= "fac_Fish" then
							msg_right = localize{type = "variable", key = "ph_fac_fas_zaako_not_a_fish", vars = {localize("k_fac_fas_right")}}
						else
							local attrs = #(___card.config.center.attributes or {})
							local s = "s"
							if attrs == 1 then s = "" end
							msg_right = localize{type = "variable", key = "ph_fac_fas_attributes", vars = {attrs, s, localize("k_fac_fas_right")}}
						end
					end
					break
				end
			end
		end
		return {vars = {card.ability.extra.limit, card.ability.extra.chips, msg_left, msg_right}}
	end,
	calculate = function(self, card, context)
		if context.other_unknown and context.other_unknown.config.center.set == "fac_Fish" then
			if #(context.other_unknown.config.center.attributes or {}) <= card.ability.extra.limit then
				return {
					chips = card.ability.extra.chips
				}
			end
		end
	end
}