-- Iron Silverfish
FishAndChips.Fish {
    key = "iron_silverfish",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {chips = 50, req = 50, times = 10, left = 10}},
    blueprint_compat = true,
    badge_key = "k_fac_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {vars = {card.ability.extra.chips}, key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.chips, card.ability.extra.req, card.ability.extra.times, card.ability.extra.left}}
    end,
    calculate = function(self, card, context)
        if context.remove_playing_cards then
            for k, v in ipairs(context.removed) do
                local created = {}
                if SMODS.has_enhancement(v, "m_stone") then
                    local copy = copy_card(v, nil, nil, true)
                    copy:set_ability(G.P_CENTERS.c_base)
                    copy.ability.perma_bonus = (copy.ability.perma_bonus or 0) + card.ability.extra.chips
                    SMODS.add_to_deck(copy, {area = G.deck})
                    table.insert(created, copy)
                end
                if #created > 0 then
                    return {
                        message = localize("k_copied_ex"),
                        colour = G.C.CHIPS,
                        card = card,
                        playing_cards_created = created
                    }
                end
            end
        elseif not context.blueprint then
            if context.destroy_card and context.destroying_card and card.ability.extra.enchant and SMODS.has_enhancement(context.destroying_card, "m_stone") then
                return {
                    remove = true
                }
            elseif context.individual and not card.ability.extra.enchant and context.cardarea == G.play and context.other_card:get_chip_bonus() + (context.other_card.edition and context.other_card.edition.chips or 0) >= card.ability.extra.req then
                card.ability.extra.left = card.ability.extra.left - 1
                if card.ability.extra.left <= 0 then
                    SEABUN.enchant(card)
                end
            end
        end
    end,
    weight = SEABUN.weight,
    attributes = {"chips", "generation", "destroy_card"},
    environments = {
        -- TODO
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 0, max = 0}, -- TODO
        length = {min = 0, max = 0} -- TODO
    }
}