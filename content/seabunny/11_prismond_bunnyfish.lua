-- Prismond Bunnyfish
FishAndChips.Fish {
    key = "prismond_bunnyfish",
    atlas = "seabunny",
    pos = {x = 0, y = 1},
    config = {extra = {suits = 4, xmult = 1.25, times = 4, count = 0}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {vars = {card.ability.extra.suits, card.ability.extra.xmult}, key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.suits, card.ability.extra.xmult, card.ability.extra.times, card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if context.before then
            local seen = {}
            local suits = 0
            local ranks = {}
            for k, v in ipairs(SMODS.Rank.obj_buffer) do
                ranks[v] = {}
            end
            for k, v in ipairs(context.scoring_hand) do
                for _, suit in ipairs(SMODS.Suit.obj_buffer) do
                    if v:is_suit(suit) and not seen[suit] then
                        seen[suit] = true
                        suits = suits + 1
                    end
                end
                if not v.edition then
                    ranks[v.base.value] = ranks[v.base.value] or {}
                    table.insert(ranks[v.base.value], v)
                end
            end
            if suits >= card.ability.extra.suits then
                local poly = false
                for k, v in pairs(ranks) do
                    if #v > 0 then
                        local target = pseudorandom_element(v, "fac_prismond_bunnyfish")
                        target:set_edition({polychrome = true}, true, poly)
                        if poly then
                            G.E_MANAGER:add_event(Event{trigger = "after", delay = 0, blockable = false, func = function()
                                target:juice_up(1, 0.5)
                                return true end})
                        end
                        poly = true
                    end
                end
                if poly then
                    return {
                        message = localize("k_fac_seabunny_polychrome"),
                        colour = G.C.SECONDARY_SET.Edition
                    }
                end
            end
        elseif not context.blueprint then
            if context.individual and card.ability.extra.enchant and context.cardarea == G.play and context.other_card.edition and context.other_card.edition.polychrome then
                return {
                    xmult = card.ability.extra.xmult
                }
            elseif context.pre_discard and not card.ability.extra.enchant and (next(get_flush(context.full_hand)) or next(get_straight(context.full_hand))) then
                card.ability.extra.count = card.ability.extra.count + 1
                if card.ability.extra.count < card.ability.extra.times then
                    return {
                        message = card.ability.extra.count .. "/" .. card.ability.extra.times
                    }
                end
                SEABUN.enchant(card)
            end
        end
    end,
    weight = 1,
    attributes = {"xmult"},
    treasure = true,
    environments = {
        volcano = 20,
        aquifer = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 3, max = 5},
        length = {min = 0.25, max = 0.4}
    }
}