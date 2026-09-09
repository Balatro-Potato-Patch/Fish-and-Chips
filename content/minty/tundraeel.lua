local row = 8
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_tundra_eel",
    atlas = atlas,
    pos = pos,
    weight = 3,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        pier = 10,
        aquifer = 10,
        city_river = 10,
        backroom = 10,
    },
    attributes = {
        "balance"
    },
    stats = {
        weight = { min = 15, max = 35}, --In kilograms
        length = { min = 1.5, max = 3}, --In meters
    },
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    config = {
        extra = {
            balance = 30
        }
    },
    loc_vars = function (self, info_queue, card)
        return  {
            vars = {
                card.ability.extra.balance
            }
        }
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            local diff = math.abs(mult - hand_chips)
            diff = math.min(diff*(card.ability.extra.balance/100), diff)
            if diff < 1 then goto nvm end

            if mult > hand_chips then
                mult = mod_mult(mult - (diff/2))
                hand_chips = mod_chips(hand_chips + (diff/2))
            else
                mult = mod_mult(mult + (diff/2))
                hand_chips = mod_chips(hand_chips - (diff/2))
            end

            ::nvm::


            return {
                func = G.E_MANAGER:add_event(Event({
                    func = (function()
                    play_sound("fac_minty_ice")
                    ease_colour(G.C.UI_CHIPS, {0.8, 0.45, 0.85, 1})
                    ease_colour(G.C.UI_MULT, {0.8, 0.45, 0.85, 1})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        delay =  0.8,
                        func = (function() 
                                ease_colour(G.C.UI_CHIPS, G.C.BLUE, 0.8)
                                ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                            return true
                        end)
                    }))
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        blockable = false,
                        blocking = false,
                        no_delete = true,
                        delay =  1.3,
                        func = (function() 
                            G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] = G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
                            G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                            return true
                        end)
                    }))
                    return true
                    end)
                })),
                message = localize('k_balanced'),
                colour = HEX("9DECE9")
            }
        end
    end
}