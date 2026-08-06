-- Ruby Snapper
FishAndChips.Fish {
    key = "ruby_snapper",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {enchant = false, times = 5, fish_left = 5}},
    blueprint_compat = true,
    badge_key = "k_fac_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.times, card.ability.extra.fish_left}}
    end,
    calculate = function(self, card, context)
        if context.selling_card and context.card.ability.set == "fac_Fish" then
            if not context.blueprint and not card.ability.extra.enchant then
                card.ability.extra.fish_left = card.ability.extra.fish_left - 1
                if card.ability.extra.fish_left <= 0 then
                    card.ability.extra.enchant = true
                    play_sound("fac_enchant", 1, 0.8)
                end
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
    weight = SEABUN.weight,
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