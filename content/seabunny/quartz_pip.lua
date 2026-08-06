-- Quartz Pip
FishAndChips.Fish {
    key = "quartz_pip",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {enchant = false, num = 1, denom = 2, num_ench = 3, denom_ench = 4, max = 50, uenh_left = 50}},
    blueprint_compat = true,
    badge_key = "k_fac_mineral_fish",
    loc_vars = function(self, info_queue, card)
        local num, denom = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, "fac_quartz_pip")
        local num_ench, denom_ench = SMODS.get_probability_vars(card, card.ability.extra.num_ench, card.ability.extra.denom_ench, "fac_quartz_pip_ench")
        if card.ability.extra.enchant then
            return {vars = {num, denom, num_ench, denom_ench}, key = self.key .. "_enchant"}
        end
        return {vars = {num, denom, num_ench, denom_ench, card.ability.extra.max, card.ability.extra.uenh_left}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.other_card and context.other_card.ability.set == "Default" then
            if context.repetition then
                local hit = false
                if card.ability.extra.enchant then
                    hit = SMODS.pseudorandom_probability(card, "fac_quartz_pip_ench", card.ability.extra.num_ench, card.ability.extra.denom_ench)
                else
                    hit = SMODS.pseudorandom_probability(card, "fac_quartz_pip", card.ability.extra.num, card.ability.extra.denom)
                end
                if hit then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = 1,
                        card = card
                    }
                end
            elseif context.individual and not card.ability.extra.enchant then
                card.ability.extra.uenh_left = card.ability.extra.uenh_left - 1
                if card.ability.extra.uenh_left <= 0 then
                    card.ability.extra.enchant = true
                    play_sound("fac_enchant", 1, 0.8)
                end
            end
        end
    end,
    weight = SEABUN.weight,
    attributes = {"retrigger"},
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