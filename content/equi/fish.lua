--yippee fish

--TODO: this needs something done with the joker or whatever
PotatoPatchUtils.Developer({
    name = "Equi",
    colour = G.C.BLUE
})

--TODO: set up atlas

--Mr Chips
FishAndChips.Fish {
    key = "mrchips",
    --atlas
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