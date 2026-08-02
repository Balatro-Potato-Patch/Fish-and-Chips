FishAndChips.Fish {
    key = "vv_stinkyboot",
    weight = 5,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = {  "chips", "passive" },
    atlas = 'fac_vv_fish',
    pos = { x = 5, y = 0 },
    environments = { 
        calm_pond = 1,
        chocolate_river = 1,
        styx = 1,
        pier = 1,
        swamp = 1,
        aquifer = 1,
        -- volcano = 0, (itd burn up)
        -- soup = 0,  (healthcode violation)
        city_river = 1,
        garden = 1,
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
    attributes = { "destroy_card", "modifier" },
    environments = { wormhole = 0.05 },
    cost = 4,
    config = { extra = { x_blind = 0.9 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_blind } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.round_resets.ante ~= 8 then
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
    attributes = { "passive" },
    environments = { pier = 5 },
    cost = 5,
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)

    end
}

FishAndChips.Fish {
    key = "vv_size2",
    weight = 2,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
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
    weight = 1,
    ppu_coder = { "FireIce" },
    ppu_artist = { "Willow" },
    attributes = {  },
    atlas = 'fac_vv_fish',
    pos = { x = 0, y = 0 },
    environments = { calm_pond = 3, pier = 2.2, backroom = 1, wormhole = 1 },
    cost = 1,
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    calculate = function(self, card, context)

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
