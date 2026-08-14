-- Golden Goldfish
FishAndChips.Fish {
    key = "golden_goldfish",
    atlas = "seabunny",
    pos = {x = 5, y = 0},
    config = {extra = {num = 1, denom = 2, max = 5, max_ench = 25, times = 5, count = 5}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        local num, denom = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, "fac_golden_goldfish")
        if card.ability.extra.enchant then
            return {vars = {num, denom, card.ability.extra.max, card.ability.extra.max_ench}, key = self.key .. "_enchant"}
        end
        return {vars = {num, denom, card.ability.extra.max, card.ability.extra.max_ench, card.ability.extra.times, card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if context.destroy_card and context.destroying_card == context.scoring_hand[#context.scoring_hand] and SMODS.pseudorandom_probability(card, "fac_golden_goldfish", card.ability.extra.num, card.ability.extra.denom) then
            local mod = 0
            local max_plus = not context.blueprint and card.ability.extra.enchant and card.ability.extra.max_ench or card.ability.extra.max
            if SMODS.has_enhancement(context.destroying_card, "m_gold") then
                mod = math.min(max_plus, math.max(-card.ability.extra.max, G.GAME.dollars))
            else
                mod = math.min(max_plus, -math.min(card.ability.extra.max, math.floor(G.GAME.dollars / 2)))
            end
            ease_dollars(mod)
            return {
                message = (mod < 0 and "-" or "") .. localize("$") .. mod,
                remove = true
            }
        elseif context.remove_playing_cards and not context.blueprint and not card.ability.extra.enchant then
            card.ability.extra.count = card.ability.extra.count + #context.removed
            if card.ability.extra.count < card.ability.extra.times then
                return {
                    message = card.ability.extra.count .. "/" .. card.ability.extra.times
                }
            end
            SEABUN.enchant(card)
        end
    end,
    in_pool = function(self, args)
        if G.playing_cards then
            for k, v in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(v, "m_gold") then
                    return true
                end
            end
        end
        return false
    end,
    weight = 4,
    attributes = {"economy", "lose_economy", "chance", "enhancements", "destroy_card"},
    environments = {
        pier = 20,
        aquifer = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 8.5, max = 12},
        length = {min = 0.27, max = 0.4}
    }
}
