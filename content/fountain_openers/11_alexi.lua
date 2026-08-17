if CardPronouns then
    CardPronouns.Pronoun {
        colour = HEX("307fff"),
        text_colour = G.C.WHITE,
        pronoun_table = { "She", "Fae", "It", "They" },
        in_pool = function()
            return false
        end,
        key = "fo_alexi_pronouns"
    }
end

FishAndChips.Fish {
	key = "fo_alexi",
    pronouns = Lemniscate and "lem_alexi_pronouns" or "fo_alexi_pronouns",
	atlas = "fo_alexi",
    display_size = { w = 234 * 0.69, h = 240 * 0.69 },
    pixel_size = { w = 234, h = 240 },
	pos = { x = 0, y = 0 },
	weight = 2,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_alexi" },
	attributes = { "copying", "position", "joker", },
    disable_visual_scaling = true,
    blueprint_compat = true,

    impulse_max = 0.45,
    impulse_min = 0.25,
    decision_max = 0.45,
    decision_min = 0.15,
    vel_limit = 0.45,
    colour = FountainOpeners.AlexiGradient,

	environments = {
		backroom = 2,
        swamp = 2,
        wormhole = 2,
        aquifer = 0.25,
        pier = 1,
	},
    stats = {
        weight = {min = 220, max = 220},
		length = {min = 5.35, max = 5.35},
	},
    cost = 8,
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers or card.area == G.fac_fish_area then
            local lfish = G.fac_fish_area.cards[1]
            local rfish = G.fac_fish_area.cards[#G.fac_fish_area.cards]

            local ljoker = G.jokers.cards[1]
            local rjoker = G.jokers.cards[#G.jokers.cards]

            local tfish = G.fac_fish_area.cards[3]
            local tjoker = G.jokers.cards[3]

            local bubbles = {}
            for _, pair in ipairs({{lfish, rfish}, {ljoker, rjoker}, {tfish, tjoker}}) do
                for i = 1, 2 do
                    local compatible = pair[i] and pair[i] ~= card and pair[i].config.center.blueprint_compat
                    bubbles[#bubbles+1] = compatible and "compatible" or "incompatible"
                end
            end

            return {
                vars = {
                    ppu_bubbles = bubbles,
                }
            }
        end

		return {
            key = self.key .. "_alt"
        }
	end,
	calculate = function(self, card, context)
        local bpc = context.blueprint_copier

        local lfish = G.fac_fish_area.cards[1]
        local rfish = G.fac_fish_area.cards[#G.fac_fish_area.cards]

        local ljoker = G.jokers.cards[1]
        local rjoker = G.jokers.cards[#G.jokers.cards]

        local tfish = G.fac_fish_area.cards[3]
        local tjoker = G.jokers.cards[3]

        local rets = {}
        for _, pair in ipairs({{lfish, rfish}, {ljoker, rjoker}, {tfish, tjoker}}) do
            local idx = math.floor(pseudorandom("fo_alexi_choice") + 1.5)

            if pair[idx] and bpc ~= pair[idx] and (bpc ~= card or pair[idx] ~= card) and pair[idx].config.center.blueprint_compat then
                rets[#rets+1] = SMODS.blueprint_effect(card, pair[idx], context)
            end
        end

        if #rets > 0 then
            return SMODS.merge_effects(rets)
        end
    end,
    set_badges = (SMODS.Mods["ellejokers"] or {}).can_load and function(self, card, badges)
        if (self.discovered) then
            badges[#badges+1] = slimeutils.table_create_badge(elle_badges.poly)
        end
    end or nil,
    set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_fo_slimegirl"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
}
