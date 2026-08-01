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

--Webfishing
FishAndChips.Fish {
    key = "webfishing",
    atlas = "equi_fish",
    pos = { x = 2, y = 0 },
    display_size = { w = 65, h = 72 },
    pixel_size = { w = 65, h = 72 },
    weight = 15,
    cost = 5,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "xmult", "passive" },
    config = {
        extra = {
            xmult = 3
        }
    },
    environments = {
        swamp = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if (context.hand_drawn or context.other_drawn) and not context.blueprint then
            local forced_count = 0
            for _, playing_card in ipairs(G.hand.cards) do
                if playing_card.ability.forced_selection then
                    forced_count = forced_count + 1
                end
            end

            --kind of inconsistent and needs standardising

            if forced_count < G.hand.config.highlighted_limit then
                G.hand:unhighlight_all()
                local unselected_cards = {}
                for k, v in ipairs(G.hand.cards) do
                    if G.hand.cards[k].highlighted == false then
                        table.insert(unselected_cards, v)
                    end
                end

                local forced_card = pseudorandom_element(unselected_cards, "equi_webfishing")
                if not forced_card.ability.forced_selection then
                    forced_card.ability.forced_selection = true
                    G.hand:add_to_highlighted(forced_card)
                end
            end
        end
    end
}

--Fished For It Again Award
FishAndChips.Fish {
    key = "fishedforitagain",
    atlas = "equi_fish",
    pos = { x = 3, y = 0 },
    weight = 15,
    cost = 6,
    blueprint_compat = true,
    ppu_coder = { "Equi" },
    ppu_artist = { "Equi" },
    attributes = { "generation" },
    config = {
        extra = {
            bait_given = 1, current_fails = 0, required_fails = 4
        }
    },
    environments = {
        wormhole = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.bait_given, card.ability.extra.current_fails, card.ability.extra.required_fails } }
    end,

    calculate = function(self, card, context)
        if context.failed and not context.blueprint then
            card.ability.extra.current_fails = card.ability.extra.current_fails + 1
            if card.ability.extra.current_fails == card.ability.extra.required_fails then
                card.ability.extra.current_fails = 0
                local bait_number = pseudorandom("equi_carpticalillusion", 2, #G.P_CENTER_POOLS.fac_Bait)
                local bait = G.P_CENTER_POOLS.fac_Bait[bait_number]
                --may need to put a cap on this
                FishAndChips.add_bait_to_inventory(bait.key, card.ability.extra.bait_given)
                return {
                    message = localize {
                        type = "variable",
                        key = "k_fac_equi_plus_bait",
                        vars = { card.ability.extra.bait_given } 
                    }
                }
            else
                return {
                    message =  card.ability.extra.current_fails .. "/" .. card.ability.extra.required_fails
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