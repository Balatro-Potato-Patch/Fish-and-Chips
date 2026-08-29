-- Bismuth Totemfish
FishAndChips.Fish {
    key = "bismuth_totemfish",
    atlas = "seabunny",
    pos = {x = 7, y = 0},
    config = {extra = {gain = 0.4, xmult = 1, times = 8, count = 0, base = 1}, seen = {}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {vars = {card.ability.extra.gain, card.ability.extra.xmult}, key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.gain, card.ability.extra.xmult, card.ability.extra.times, card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult
            }
        elseif not context.blueprint then
            if context.before then
                local targets = {}
                for k, v in ipairs(G.deck.cards) do
                    if v.ability.set == "Enhanced" then
                        table.insert(targets, v)
                    end
                end
                local stolen = 0
                for k, v in ipairs(context.scoring_hand) do
                    if #targets == 0 then
                        break
                    end
                    if v.ability.set == "Default" then
                        local hit, i = pseudorandom_element(targets, "fac_bismuth_totemfish")
                        v:set_ability(G.P_CENTERS[next(SMODS.get_enhancements(hit))])
                        hit:set_ability(G.P_CENTERS.c_base)
                        table.remove(targets, i)
                        stolen = stolen + 1
                    end
                end
                if stolen > 0 and not card.ability.extra.enchant then
                    card.ability.extra.count = card.ability.extra.count + stolen
                    if card.ability.extra.count < card.ability.extra.times then
                        return {
                            message = card.ability.extra.count .. "/" .. card.ability.extra.times
                        }
                    end
                    SEABUN.enchant(card)
                end
            elseif context.individual and card.ability.extra.enchant and context.cardarea == G.play then
                local enhance = next(SMODS.get_enhancements(context.other_card))
                if enhance and not card.ability.seen[enhance] then
                    card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                    card.ability.seen[enhance] = true
                end
            elseif context.after then
                card.ability.extra.xmult = card.ability.extra.base
                card.ability.seen = {}
            end
        end
    end,
    weight = 4,
    attributes = {"xmult", "full_deck", "modify_card", "enhancements", },
    environments = {
        pier = 20,
        aquifer = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 1.5, max = 2},
        length = {min = 0.7, max = 0.8}
    }
}
