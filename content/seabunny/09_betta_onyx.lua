-- Betta Onyx
local recalc_size = function(card, set, add, first)
    local tally = {}
    if set then
        tally[set] = add and 1 or -1
    end
    local limit = G.consumeables.config.card_limit
    if not first then
        limit = limit - card.ability.extra.size
    end
    card.ability.extra.size = 0
    for k, v in ipairs(G.consumeables.cards) do
        tally[v.ability.set] = (tally[v.ability.set] or 0) + 1
    end
    for k, v in pairs(tally) do
        if v > 0 then
            card.ability.extra.size = card.ability.extra.size + 1
        end
    end
    if card.ability.extra.enchant then
        G.consumeables.config.card_limit = limit + card.ability.extra.size
    end
end

FishAndChips.Fish {
    key = "betta_onyx",
    atlas = "seabunny",
    pos = {x = 8, y = 0},
    config = {extra = {size = 0, times = 9, count = 0}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {vars = {card.ability.extra.size}, key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.size, card.ability.extra.times, card.ability.extra.count}}
    end,
    add_to_deck = function(self, card, from_debuff)
        recalc_size(card, nil, nil, true)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.size
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local seen = {}
            for k, v in ipairs(G.consumeables.cards) do
                seen[v.ability.set] = true
            end
            local created = false
            for k, v in ipairs(SMODS.ConsumableType.obj_buffer) do
                if not seen[v] and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    created = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event{trigger = "before", func = function()
                        SMODS.add_card{set = v}
                        G.GAME.consumeable_buffer = 0
                        return true end})
                end
            end
            if created then
                return {
                    message = localize("k_fac_seabunny_created")
                }
            end
        elseif not context.blueprint then
            if context.card_added and context.card.ability.consumeable then
                recalc_size(card, context.card.ability.set, true)
            elseif (context.selling_card or context.joker_type_destroyed) and context.card.ability.consumeable then
                recalc_size(card, context.card.ability.set)
            elseif context.selling_card and context.card.config.center.name == "fish_fac_enchantfish" then
                recalc_size(card)
            elseif context.using_consumeable then
                recalc_size(card)
                if not card.ability.extra.enchant then
                    card.ability.extra.count = card.ability.extra.count + 1
                    if card.ability.extra.count < card.ability.extra.times then
                        return {
                            message = card.ability.extra.count .. "/" .. card.ability.extra.times
                        }
                    end
                    SEABUN.enchant(card)
                    recalc_size(card, nil, nil, true)
                end
            end
        end
    end,
    weight = 4,
    attributes = {"consumable_slot", "generation", "consumable",},
    environments = {
        pier = 20,
        aquifer = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 4, max = 7},
        length = {min = 1.5, max = 2.5}
    }
}
