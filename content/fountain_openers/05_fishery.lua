FishAndChips.Fish {
	key = "fo_fishery",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 5,
	ppu_coder = { "Alexi" },
	ppu_artist = { "Grahkon" },
	attributes = { "rank", "jack", "king", "queen", "mult", "xmult" },
	config = {
        extra = {
            mult = 2,
            xmult = 1.25,
        }
	},
	environments = {
		garden = 1,
	},
    loc_vars = function(self, info_queue, card)
		return { vars = {
            card.ability.extra.mult,
            card.ability.extra.xmult,
        }}
	end,
	calculate = function(self, card, context)
        if context.after and not context.blueprint then
            local jacks = false
            for _, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() == 11 then
                    jacks = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            assert(SMODS.change_base(scored_card, nil, "Queen"))
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if jacks then
                return {
                    message = localize("fac_fo_hey_raly"),
                    -- hey raly soundbite
                }
            end
        end

        if context.individual and context.cardarea == G.play then
            if (context.other_card:get_id() == 13 or context.other_card:get_id() == 12) then
                return {
                    xmult = card.ability.extra.xmult
                }
            elseif context.other_card:get_id() == 11 then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end,
}