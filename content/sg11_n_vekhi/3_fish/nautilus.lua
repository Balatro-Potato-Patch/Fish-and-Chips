SMODS.Atlas({
    key = "sg11_n_vekhi_nautilus",
    path = "sg11_n_vekhi/nautilus.png",
    px = 71,
    py = 95,
})

FishAndChips.Fish({
    key = "sg11_n_vekhi_nautilus",
    atlas = "fac_sg11_n_vekhi_nautilus",
    pos = { x = 0, y = 0 },
    ppu_coder = { "sleepyg11" },
    ppu_artist = { "vevekhi" },
    attributes = { "generation", },
    config = {},
    weight = 12,
    stats = {
        weight = { min = 1, max = 1.8 },
        length = { min = 0.2, max = 0.45 },
    },
    environments = {
        pier = 4,
        garden = 1,
    },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            if #G.consumeables.cards + (G.GAME.consumeable_buffer or 0) > 0 then
                return {
                    message = localize("k_fac_bait_ex"),
                    func = function()
                        local w = (G.CARD_W + 0.1) * 1 * 2 - 0.1
                        local h = G.CARD_H
                        local bait_card
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.fac_nautilus_area =
                                    CardArea(card.T.x + card.T.w / 2 - w / 2, card.T.y - 0.25 - h, w, h, {
                                        type = "joker",
                                        card_limit = 1,
                                        highlight_limit = 1,
                                        highlighted_limit = 1,
                                        align_buttons = true,
                                        bg_colour = G.C.CLEAR,
                                        fixed_limit = true,
                                        no_card_count = true,
                                    })
                                return true
                            end,
                        }))
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local _card = SMODS.create_card({ set = "fac_Bait", area = G.fac_nautilus_area })
                                G.fac_nautilus_area:emplace(_card)
                                FishAndChips.add_bait_to_inventory(_card.config.center.key)
                                bait_card = _card
                                return true
                            end,
                        }))
                        delay(1.5)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                bait_card:start_dissolve()
                                return true
                            end,
                        }))
                        delay(0.5)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.fac_nautilus_area:remove()
                                return true
                            end,
                        }))
                    end,
                }
            end
        end
    end,
})
