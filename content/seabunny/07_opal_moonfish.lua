-- Opal Moonfish
FishAndChips.Fish {
    key = "opal_moonfish",
    atlas = "seabunny",
    pos = {x = 6, y = 0},
    config = {extra = {times = 2, count = 0}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_mineral_fish",
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.enchant then
            return {key = self.key .. "_enchant"}
        end
        return {vars = {card.ability.extra.times, card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            local pool = {}
            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if G.GAME.hands[v.config.hand_type].played > 0 then
                    table.insert(pool, v.key)
                end
            end
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event{trigger = "before", func = function()
                SMODS.add_card{key = pseudorandom_element(pool, "fac_opal_moonfish")}
                G.GAME.consumeable_buffer = 0
                return true end})
            return {
                message = localize("k_plus_planet"),
                colour = G.C.SECONDARY_SET.Planet
            }
        elseif not context.blueprint then
            if context.setting_blind and context.blind.boss and not G.GAME.blind.disabled and card.ability.extra.enchant then
                card.ability.extra.enchant = false
                return {
                    message = localize("ph_boss_disabled"),
                    func = function()
                        G.E_MANAGER:add_event(Event{func = function()
                            G.GAME.blind:disable()
                            card.ability.extra.count = 0
                            card.ability.extra.show_enchant = false
                            play_sound("timpani")
                            delay(0.4)
                            return true end})
                    end
                }
            elseif context.skip_blind and not card.ability.extra.enchant then
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
    weight = 4,
    attributes = {"hand_level", "generation", "consumable", "planet", "boss_blind", "skip", },
    environments = {
        pier = 20,
        aquifer = 80
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 0.02, max = 540},
        length = {min = 0.1, max = 2}
    }
}
