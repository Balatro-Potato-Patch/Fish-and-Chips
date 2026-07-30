--yippee fish


--TODO: set up atlas
SMODS.Atlas ({
    key = "equi_fish",
    path = "equi/fish.png",
    px = 71,
    py = 95
})

SMODS.Atlas ({
    key = "equi_credits",
    path = "equi/equicredits.png",
    px = 71,
    py = 95
})

PotatoPatchUtils.Developer {
    name = "Equi",
    atlas = "fac_equi_credits",
    pos = { x = 0, y = 0 }, -- temp
    colour = G.C.BLUE,
    loc = true
}

--Mr Chips
FishAndChips.Fish {
    key = "mrchips",
    atlas = "equi_fish",
    pos = { x = 0, y = 0 },
    weight = 20,
    cost = 3,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "chips", "rank" },
    config = {
        extra = {
            chips = 1
        }
    },
    treasure = true,
    environments = {
        city_river = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint and not context.game_over then
            for i = 1, #G.hand.cards do
                G.hand.cards[i].ability.perma_bonus = (G.hand.cards[i].ability.perma_bonus or 0) + (card.ability.extra.chips * G.hand.cards[i]:get_id())
            end
            return {
                message = localize("k_upgrade_ex")
            }
        end
    end
}

--Antarctic Krill
FishAndChips.Fish {
    key = "antarctickrill",
    --atlas
    pos = { x = 1, y = 0 },
    weight = 15,
    cost = 5,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "generation" },
    config = {
        extra = {
            sand_dollar_req = 8
        }
    },
    environments = {
        styx = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sand_dollar_req } }
    end,

    calculate = function(self, card, context)
        if context.joker_main and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            if G.GAME.fac_sand_dollars >= card.ability.extra.sand_dollar_req then
                G.GAME.joker_buffer = G.GAME.joker_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card {
                            set = "Joker",
                            rarity = "Common"
                        }
                        G.GAME.joker_buffer = 0
                        return true
                    end
                }))
                return {
                    message = localize("k_plus_joker"),
                    colour = G.C.BLUE
                }
            end
        end
    end
}

--Carptical Illusion
FishAndChips.Fish {
    key = "carpticalillusion",
    atlas = "equi_fish",
    pos = { x = 4, y = 0 },
    display_size = { w = 66, h = 46 },
    pixel_size = { w = 66, h = 46 },
    weight = 5,
    cost = 7,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "generation" },
    config = { extra = { chosen_bait = 2 } },
    environments = {
        backroom = 1,
        wormhole = 0.25
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chosen_bait, localize{ set = "fac_Bait", type = "name_text", key = G.P_CENTER_POOLS.fac_Bait[card.ability.extra.chosen_bait].key } } }
    end,

    calculate = function(self, card, context)
        if context.fac_fish_hooked then
            if G.GAME.fac_active_bait == G.P_CENTER_POOLS.fac_Bait[card.ability.extra.chosen_bait].key then
                card.ability.extra.chosen_bait = pseudorandom("equi_carpticalillusion", 2, #G.P_CENTER_POOLS.fac_Bait)
                if (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = "before",
                        delay = 0.0,
                        func = (function()
                            SMODS.add_card {
                                set = "Spectral"
                            }
                            return true
                        end)}))
                    return {
                        message = localize("k_plus_spectral"),
                        colour = G.C.SPECTRAL
                    }
                else
                    return {
                        message = localize("k_fac_equi_no_room"),
                        colour = G.C.SPECTRAL
                    }
                end
            end
        end
    end,

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.chosen_bait = pseudorandom("equi_carpticalillusion", 2, #G.P_CENTER_POOLS.fac_Bait)
    end
}