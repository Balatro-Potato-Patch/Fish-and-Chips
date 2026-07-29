FishAndChips.Fish({
	key = "trojan_fish",
	weight = 10,
	environments = {
		aquifer = 1,
		backroom = 1,
		calm_pond = 1,
		chocolate_river = 1,
		city_river = 1,
		garden = 1,
		pier = 1,
		soup = 1,
		styx = 1,
		swamp = 1,
		volcano = 1,
        wormhole = 1,
	},
    attributes = { "copying", "chance" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	config = { extra = { odds = 6 } },
	loc_vars = function(self, info_queue, card)
		local main_end = nil
		if card.area and card.area == G.fac_fish_area then
			local other_fish
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then
					other_fish = G.fac_fish_area.cards[i + 1]
				end
			end
			local compatible = other_fish and other_fish ~= card and other_fish.config.center.blueprint_compat
			main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes = {
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
									or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06,
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " "
											.. localize("k_" .. (compatible and "compatible" or "incompatible"))
											.. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
					},
				},
			}
		end
		local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds)
		return { main_end = main_end, vars = {
			n,
			d,
		} }
	end,
	calculate = function(self, card, context)
		local other_fish = nil
		for i = 1, #G.fac_fish_area.cards do
			if G.fac_fish_area.cards[i] == card then
				other_fish = G.fac_fish_area.cards[i + 1]
				break
			end
		end
		local ret = SMODS.blueprint_effect(card, other_fish, context)
		if ret then
			ret.colour = G.C.BLUE
		end
		if
			context.end_of_round
			and context.main_eval
			and not context.game_over
			and not context.blueprint
			and SMODS.pseudorandom_probability(card, "fac_trojan_fish", 1, card.ability.extra.odds)
		then
			SMODS.destroy_cards(card, nil, nil, true)
            SMODS.add_card({ set = "Joker" })
			return {
				message = localize("k_fac_boom_ex"),
				colour = G.C.RED,
			}
		end
		return ret
	end,
})

local function calc_moai_mult(card)
    local min_mult = card.ability.extra.min
    local max_mult = card.ability.extra.max

    local current_date = os.date("*t")
    local current_day = current_date.yday
    local current_year = current_date.year
    local target_day_1 = os.date("*t", os.time({ year = current_year, month = 4, day = 5 })).yday
    local target_day_2 = os.date("*t", os.time({ year = current_year + 1, month = 4, day = 5 })).yday
    local diff = math.min(math.abs(current_day - target_day_1), math.abs(current_day - target_day_2))
    local max_diff = 183
    local final_mult = min_mult + (diff / max_diff) * (max_mult - min_mult)
    return math.floor(final_mult * 100) / 100
end

FishAndChips.Fish({
	key = "moai_statue",
	weight = 5,
	environments = {
		pier = 1,
        calm_pond = 1,
	},
    attributes = { "xmult" },
	ppu_coder = { "thunderedge" },
	ppu_artist = { "aikoyori" },
	config = { extra = { min = 1.5, max = 3 } },
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                card.ability.extra.min,
                card.ability.extra.max,
                calc_moai_mult(card)
            }
        }
	end,
	calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = calc_moai_mult(card)
            }
        end
	end,
})