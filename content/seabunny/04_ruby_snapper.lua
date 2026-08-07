-- Ruby Snapper
FishAndChips.Fish {
    key = "ruby_snapper",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {times = 5, count = 5}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.times, card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == "fac_Fish" then
            if not context.blueprint and not card.ability.extra.enchant then
                card.ability.extra.count = card.ability.extra.count + 1
                if card.ability.extra.count < card.ability.extra.times then
                    return {
                        message = card.ability.extra.count .. "/" .. card.ability.extra.times
                    }
                end
                SEABUN.enchant(card)
            end
            if not G.GAME.current_round.fish_sold then
                card.ability.extra_value = card.ability.extra_value + context.card.sell_cost
                card:set_cost()
                return {
                    message = localize("k_val_up"),
                    colour = FishAndChips.C.SAND_DOLLAR
                }
            end
        elseif context.selling_self and not context.blueprint and card.ability.extra.enchant then
            card.sell_cost = 2 * card.sell_cost
        end
    end,
    weight = 4,
    attributes = {"economy"},
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