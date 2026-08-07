-- Enchantfish
SMODS.Font {
    key = "sga",
    path = "seabunny/sga.ttf"
}

FishAndChips.Fish {
    key = "enchantfish",
    atlas = "seabunny",
    pos = {x = 1, y = 1},
    config = {extra = {rounds = 2, max = 20, count = 0}},
    blueprint_compat = false,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rounds, card.ability.extra.max, card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.count = card.ability.extra.count + 1
            if card.ability.extra.count == card.ability.extra.rounds then
                SEABUN.enchant(card)
            end
            return {
                message = (card.ability.extra.count < card.ability.extra.rounds) and (card.ability.extra.count .. "/" .. card.ability.extra.rounds) or localize("k_active_ex")
            }
        elseif context.selling_self and card.ability.extra.count >= card.ability.extra.rounds then
            for k, v in ipairs(G.fac_fish_area.cards) do
                if v.config.center.badge_key == "k_fac_seabunny_mineral_fish" then
                    SEABUN.enchant(v)
                elseif type(v.ability.extra) ~= "table" or not v.ability.extra.enchant then
                    v.ability.extra_value = (v.ability.extra_value or 0) + math.min(v.sell_cost, card.ability.extra.max)
                    v:set_cost()
                end
            end
        end
    end,
    weight = SEABUN.weight,
    attributes = {"economy"},
    environments = {
        swamp = 20,
        garden = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 1.5, max = 2.5},
        length = {min = 0.6, max = 0.7}
    }
}