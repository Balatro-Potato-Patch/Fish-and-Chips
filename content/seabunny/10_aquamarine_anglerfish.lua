-- Aquamarine Anglerfish
FishAndChips.Fish {
    key = "aquamarine_anglerfish",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {gain = 0.03, xmult = 1, cards = 5, times = 8, count = 0}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {vars = {card.ability.extra.gain, card.ability.extra.xmult}, key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.gain, card.ability.extra.xmult, card.ability.extra.cards, card.ability.extra.times, card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if (context.hand_drawn or context.other_drawn) and #G.deck.cards == 0 then
                for k, v in ipairs(G.hand.cards) do
                    local reps = SMODS.calculate_repetitions(v, {repetition = true, cardarea = G.hand}, {})
                    for i = 1, #reps + 1 do
                        card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                        card_eval_status_text(card, "extra", nil, nil, nil, {message = localize{type = "variable", key = "a_xmult", vars = {card.ability.extra.xmult}}})
                        if card.ability.extra.enchant then
                            v.ability.perma_repetitions = (v.ability.perma_repetitions or 0) + 1
                            v.ability.temp_repetitions = (v.ability.temp_repetitions or 0) + 1
                            card_eval_status_text(v, "extra", nil, nil, nil, {message = localize("k_fac_seabunny_retrigger")})
                        end
                    end
                end
            elseif context.pre_discard and not card.ability.extra.enchant then
                if #context.full_hand == card.ability.extra.cards then
                    card.ability.extra.count = card.ability.extra.count + 1
                    if card.ability.extra.count >= card.ability.extra.times then
                        SEABUN.enchant(card)
                    end
                else
                    card.ability.extra.count = 0
                end
                if card.ability.extra.count < card.ability.extra.times then
                    return {
                        message = card.ability.extra.count .. "/" .. card.ability.extra.times
                    }
                end
            end
        elseif context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    weight = SEABUN.weight,
    attributes = {"xmult", "retrigger"},
    environments = {
        pier = 20,
        aquifer = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 6, max = 8},
        length = {min = 0.75, max = 1.1}
    }
}