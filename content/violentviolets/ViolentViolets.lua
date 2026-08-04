FishAndChips.Fish {
    key = "vv_stinkyboot",
    weight = 5,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = {  "chips", "passive" },
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
    config = { extra = { chips = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        card.ability.extra.chips = ( G.GAME.fac_sand_dollars )
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
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
    stats = { weight = { min = 98, max = 98 }, length = { min = 2.06, max = 2.06 } },
    environments = { wormhole = 0.05 },
    cost = 4,
    config = { extra = { x_blind = 0.9 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_blind } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips * card.ability.extra.x_blind)
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)

                    local chips_UI = G.hand_text_area.blind_chips
                    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                    G.HUD_blind:recalculate()
                    chips_UI:juice_up()
                return true end }))
        end
    end,
}
FishAndChips.Fish {
    key = "vv_willowfish",
    weight = 3,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "passive", "chips", "xchips" },
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
            card.ability.extra.x_chips = card.ability.extra.x_chips + card.ability.extra.chipsmodifier
            return {
                message = "Upgraded!",
                colour = G.C.ATTENTION
            }
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
    attributes = { "x_mult" },
    environments = { pier = 5 },
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
    key = "vv_size2",
    weight = 2,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    stats = { weight = { min = 2, max = 2 }, length = { min = 2, max = 2 } },
    attributes = {  },
    environments = { wormhole = 0.01, styx = 0.005 },
    cost = 3,
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)

    end
}

FishAndChips.Fish {
    key = "vv_winggaster",
    weight = 6,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { "chips" },
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
    key = "vv_lilypad",
    weight = 1,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    stats = { weight = { min = 0.04, max = 0.1 }, length = { min = 1, max = 1 } },
    attributes = {  },
    atlas = 'fac_vv_fish',
    pos = { x = 0, y = 0 },
    environments = { swamp = 1, garden = 1, calm_pond = 1 },
    cost = 1,
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)

    end
}

FishAndChips.Fish {
    key = "vv_immortalsnail",
    weight = 3,
    stats = { weight = { min = 1, max = 3 }, length = { min = 1, max = 1 } },
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = {  },
    atlas = 'fac_vv_fish',
    pos = { x = 4, y = 0 },
    environments = { calm_pond = 3, pier = 2.2, backroom = 1, wormhole = 1 },
    cost = 1,
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)

    end
}

FishAndChips.Fish {
    key = "vv_seashroom",
    weight = 3,
    stats = { weight = { min = 1, max = 3 }, length = { min = 1, max = 1 } },
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = { 'suit' },
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
                message = 'Again!',
				repetitions = 1,
				card = context.other_card
            }
        end
        if context.individual and context.cardarea == G.play and context.other_card:is_suit_shade('light') then
            SMODS.debuff_card(card, true, 'sunlight')
            return {
                message = "Zzzzz....",
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
    attributes = { 'usable' },
    atlas = 'fac_vv_fish',
    pos = { x = 7, y = 0 },
    environments = { pier = 3 },
    cost = 1,
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    use = function(self, card, area, copier)
        local editionless_fish = SMODS.Edition:get_edition_cards(G.fac_fish_area, true)

        local eligible_card = pseudorandom_element(editionless_fish, 'vv_blobfish')
        local edition = SMODS.poll_edition { key = "vv_blobfish", guaranteed = true, no_negative = true, options = { 'e_holo', 'e_foil' } }
        eligible_card:set_edition(edition, true)
        check_for_unlock({ type = 'have_edition' })
    end,
    can_use = function(self, card)
        return next(SMODS.Edition:get_edition_cards(G.fac_fish_area, true))
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
