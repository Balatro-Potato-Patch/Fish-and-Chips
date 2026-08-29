FishAndChips.Fish {
    key = "vv_stinkyboot",
    weight = 5,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "chips", "sell_value", "lose_economy", },
    stats = { weight = { min = 1, max = 1 }, length = { min = 1, max = 1 } },
    atlas = 'fac_vv_fish',
    pos = { x = 5, y = 0 },
    environments = {
        -- calm_pond = 1, (its your private property friend)
        -- chocolate_river = 1, (the oompa loompa did not make it)
        -- styx = 1, (everyone is fucking dead)
        pier = 1,
        swamp = 1,
        aquifer = 1,
        -- volcano = 0, (itd burn up)
        -- soup = 0,  (healthcode violation)
        city_river = 1,
        -- garden = 1, (too pure)
        backroom = 1,
        wormhole = 1,
    }, -- you can find ts everywhere it will not be funny
    cost = 1,
    config = { extra = { chips = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips * G.GAME.fac_sand_dollars } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips * G.GAME.fac_sand_dollars
            }
        end
    end
}

FishAndChips.Fish {
    key = "vv_fireicefish",
    weight = 4,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "xblindsize" },
    atlas = 'fac_vv_fish',
    pos = { x = 2, y = 1 },
    stats = { weight = { min = 98, max = 98 }, length = { min = 2.06, max = 2.06 } },
    environments = { wormhole = 0.05 },
    cost = 4,
    config = { extra = { x_blind = 0.75 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_blind } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            return {
                xblindsize = card.ability.extra.x_blind
            }
        end
    end,
}
FishAndChips.Fish {
    key = "vv_willowfish",
    weight = 3,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "chips", "xchips" },
    stats = { weight = { min = 63.5, max = 63.5 }, length = { min = 2.2, max = 2.2 } },
    environments = { pier = 3, garden = 1.2 },
    cost = 1,
    atlas = 'fac_vv_fish',
    pos = { x = 1, y = 0 },
    config = { extra = { x_chips = 1, chipsmodifier = 0.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_chips, card.ability.extra.chipsmodifier } }
    end,
    calculate = function(self, card, context)
        if context.fac_end_fishing and not context.failed then
            SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "x_chips",
				scalar_value = "chipsmodifier",
			})
        end
        if context.joker_main then
            return {
                x_chips = card.ability.extra.x_chips
            }
        end
    end,
}

FishAndChips.Fish {
    key = "vv_blahaj",
    weight = 5,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "xmult", 'editions' },
    environments = { pier = 5 },
    atlas = 'fac_vv_fish',
    pos = { x = 0, y = 1 },
    stats = { weight = { min = 0.67, max = 0.67 }, length = { min = 1, max = 1.05 } },
    cost = 5,
    config = { extra = { x_mult = 1.3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.edition ~= nil then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
}

FishAndChips.Fish {
    key = "vv_winggaster",
    weight = 6,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "chips", "undertale", "utdr", },
    stats = { weight = { min = 66.6, max = 66.6 }, length = { min = 6, max = 6 } },
    environments = {
        styx = 6,
        wormhole = 3,
        backroom = 1.6
    },
    cost = 6,
    atlas = 'fac_vv_fish',
    pos = { x = 2, y = 0 },
    config = { extra = { chips = 666 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
        if context.end_of_round and context.main_eval then
            SMODS.destroy_cards(SMODS.find_card("fish_fac_vv_winggaster"))
            play_sound('fac_vv_mysterygo')
            return {
                message = " ",
                colour = G.C.WHITE
            }
        end
    end
}

FishAndChips.Fish {
    key = "vv_jetfish",
    weight = 3,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    stats = { weight = { min = 0.04, max = 0.1 }, length = { min = 1, max = 1 } },
    attributes = { "chips", "hands", },
    atlas = 'fac_vv_fish',
    pos = { x = 3, y = 0 },
    environments = { pier = 3, aquifer = 2, city_river = 0.9 },
    cost = 3,
    config = { extra = { mult = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        -- Can i give myself code credit pretty please (mf)
        if context.individual and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 then
            if #context.scoring_hand == #G.play.cards then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

FishAndChips.Fish {
    key = "vv_immortalsnail",
    weight = 3,
    stats = { weight = { min = 1, max = 3 }, length = { min = 1, max = 1 } },
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "xmult", "boss_blind", "destroy_card", "scaling", },
    atlas = 'fac_vv_fish',
    pos = { x = 4, y = 0 },
    environments = { calm_pond = 3, pier = 2.2, backroom = 1, wormhole = 1 },
    cost = 1,
    config = { extra = { xmult = 1, xmult_gain = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_gain } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and context.blind.boss then
            -- Does Madness still gain XMult when it doesn't destroy a card? (mf)
            SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "xmult",
				scalar_value = "xmult_gain",
				message_key = "a_xmult",
				message_colour = G.C.RED,
			})

            local destructable_jokers = {}
            for i = 1, #G.fac_fish_area.cards do
                if G.fac_fish_area.cards[i] ~= card and not SMODS.is_eternal(G.fac_fish_area.cards[i], card) and not G.fac_fish_area.cards[i].getting_sliced then
                    destructable_jokers[#destructable_jokers + 1] =
                        G.fac_fish_area.cards[i]
                end
            end
            local joker_to_destroy = pseudorandom_element(destructable_jokers, 'vremade_madness')

            if joker_to_destroy then
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        (context.blueprint_card or card):juice_up(0.8, 0.8)
                        joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))
            end
            return nil, true
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}

FishAndChips.Fish {
    key = "vv_seashroom",
    weight = 3,
    stats = { weight = { min = 1, max = 3 }, length = { min = 1, max = 1 } },
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { 'suit', 'retrigger', "debuff", },
    atlas = 'fac_vv_fish',
    pos = { x = 7, y = 0 },
    environments = { calm_pond = 3 },
    cost = 1,
    config = { extra = { repetitions = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repetitions } }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and context.other_card:is_suit_shade('dark') then
            return {
                repetitions = 1
            }
        end
        if context.individual and context.cardarea == G.play and context.other_card:is_suit_shade('light') then
            SMODS.debuff_card(card, true, 'sunlight')
            return {
                message = "Zzzzz....", -- TODO: localize
                colour = G.C.DARK_EDITION
            }
        end
    end
}

FishAndChips.Fish {
    key = "vv_blobfish",
    weight = 3,
    stats = { weight = { min = 1, max = 2 }, length = { min = 0.2, max = 0.7 } },
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { 'usable', 'editions' },
    atlas = 'fac_vv_fish',
    pos = { x = 1, y = 1 },
    environments = { pier = 3 },
    cost = 1,
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
        info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
        return { vars = {} }
    end,
    use = function(self, card, area, copier)
        local editionless_fish = SMODS.Edition:get_edition_cards(G.fac_fish_area, true)

        local eligible_card = pseudorandom_element(editionless_fish, 'vv_blobfish')
        local edition = SMODS.poll_edition { key = "vv_blobfish", guaranteed = true, no_negative = true, options = { 'e_holo', 'e_foil' } }
        eligible_card:set_edition(edition, true)
        check_for_unlock({ type = 'have_edition' })
    end,
    can_use = function(self, card)
        local edition_cards = SMODS.Edition:get_edition_cards(G.fac_fish_area, true)
        for _, other_card in ipairs(edition_cards) do
            if other_card ~= card then return true end
        end
    end
}

local leviathan_scale = FishAndChips.mod.config.shrink_sprites and 0.7 or 1

FishAndChips.Fish {
    key = "vv_leviathan",
    weight = 2,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    stats = { weight = { min = 5020, max = 5020 }, length = { min = 10.86, max = 10.86 } },
    attributes = { 'destroy_card', 'economy' },
    atlas = 'fac_vv_leviathan',
    pos = { x = 0, y = 0 },
    display_size = { w = 71 * leviathan_scale, h = 198 * leviathan_scale },
    environments = { pier = 2, city_river = 1 },
    cost = 1,
    config = { extra = { sand_dollar = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.sand_dollar } }
    end,
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 then
            return {
                sand_dollars = card.ability.extra.sand_dollar,
                remove = true
            }
        end
    end
}

FishAndChips.Fish {
    key = "vv_fish",
    weight = 1,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    stats = { weight = { min = 1, max = 1 }, length = { min = 1, max = 1 } },
    attributes = { 'generation', "tarot", "planet", "spectral", },
    atlas = 'fac_vv_fish',
    pos = { x = 6, y = 0 },
    environments = { calm_pond = 1, pier = 1, city_river = 1 },
    cost = 4,
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    use = function(self, card, area)
        for i = 1, math.min(1, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    local sets = { 'Tarot', 'Planet', 'Spectral' }
                    local random_set = pseudorandom_element(sets, 'random_consumable_set')
                    SMODS.add_card({ set = random_set })
                    SMODS.destroy_cards(card)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
        end
        delay(0.6)
        play_sound('fac_vv_fish')
        return true
    end,
    can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit
    end
}

local oldcardsetsellvalue = Card.set_sell_value
function Card:set_sell_value()
    local g = oldcardsetsellvalue(self)
    if self.config.center.key == 'fish_fac_vv_stinkyboot' then
        self.sell_cost = 0
    end
    return g
end
