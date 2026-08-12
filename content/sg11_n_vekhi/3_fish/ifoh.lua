SMODS.Atlas({
    key = "sg11_n_vekhi_ifoh",
    path = "sg11_n_vekhi/ifoh.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "sg11_n_vekhi_ifoh_lore",
    path = "sg11_n_vekhi/ifoh_lore.png",
    px = 336,
    py = 191,
})


FishAndChips.Fish({
    key = "sg11_n_vekhi_ifoh",
    atlas = "fac_sg11_n_vekhi_ifoh",
    pos = { x = 0, y = 0 },
    ppu_coder = { "sleepyg11" },
    ppu_artist = { "vevekhi" },
    blueprint_compat = false,
    attributes = {
        "enhancements",
    },
    config = {
        extra = {
            requirement = 3,
        },
    },
    weight = 5,
    stats = {
        weight = { min = 1.1, max = 1.3 },
        length = { min = 0.5, max = 0.6 },
    },
    environments = {
        volcano = 5,
        city_river = 8,
        wormhole = 4,
    },
    flavour_vars = function(self, info_queue, card)
        return {
            vars = {
                elements = { SMODS.create_sprite(0, 0, 3.5, 3.5 / 336 * 191, "fac_sg11_n_vekhi_ifoh_lore") },
            },
        }
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = { self.config.extra.requirement },
        }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local enhanced = {}
            for _, scored_card in ipairs(context.scoring_hand) do
                if
                    next(SMODS.get_enhancements(scored_card))
                    and not scored_card.debuff
                    and not scored_card.vampired
                then
                    enhanced[#enhanced + 1] = scored_card
                end
            end

            if #enhanced >= self.config.extra.requirement then
                for _, scored_card in ipairs(enhanced) do
                    scored_card.vampired = true
                    scored_card:set_ability("c_base", nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            scored_card.vampired = nil
                            return true
                        end,
                    }))
                end
                for _, hand_card in ipairs(G.hand.cards) do
                    if not hand_card.fac_ifoh and not next(SMODS.get_enhancements(hand_card)) then
                        hand_card.fac_ifoh = true
                        local enhancement = SMODS.poll_enhancement({ guaranteed = true, key = "fac_ifoh" })
                        hand_card:set_ability(enhancement, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                hand_card:juice_up()
                                hand_card.fac_ifoh = nil
                                return true
                            end,
                        }))
                    end
                end
                return {
                    message = "Upgrade!",
                }
            end
        end
    end,
})
