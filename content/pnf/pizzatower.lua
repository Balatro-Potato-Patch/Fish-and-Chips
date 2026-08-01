PotatoPatchUtils.Developer({
    name = 'FirstTry',
    atlas = 'fac_pnf_firsttry',
    loc = true,
    colour = G.C.SECONDARY_SET.Spectral,
    display_size = { w = 71 * 20.7, h = 95 * 20.7 },
    fac_partner =
    'Pixel',            -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
    click = function(self)
        play_sound("fac_pnf_fts",math.random(0.95,1.25),1)
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            func = function()
                self:juice_up(1, 0.2)
                return true
            end
        }))
    end
})

PotatoPatchUtils.Developer({
    name = 'Pixel',
    atlas = 'fac_pnf_pixelcredits',
    loc = true,
    colour = G.C.SECONDARY_SET.Planet,
    fac_partner =
    'FirstTry',            -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
    click = function(self)
        play_sound("fac_pnf_pixelsounds")
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            func = function()
                self:juice_up(1, 0.2)
                return true
            end
        }))
    end
})

SMODS.Atlas({
    key = "pnf_firsttry", -- Please include your name/team name in your atlas keys
    path = "pnf/FirstTryCredits.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "pnf_flyan", -- Please include your name/team name in your atlas keys
    path = "pnf/FlyingAnchovy.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "pnf_blueax", -- Please include your name/team name in your atlas keys
    path = "pnf/SuspiciousBlueAxolotl.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "pnf_rib", -- Please include your name/team name in your atlas keys
    path = "pnf/Ribbit.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "pnf_dupli", -- Please include your name/team name in your atlas keys
    path = "pnf/Barramunduplicare.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "pnf_pixelfish", -- Please include your name/team name in your atlas keys
    path = "pnf/PixelFish.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "pnf_pixelcredits", -- Please include your name/team name in your atlas keys
    path = "pnf/PixelCredits.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "pnf_star", -- Please include your name/team name in your atlas keys
    path = "pnf/OriginalStarfish.png",
    px = 71,
    py = 95,
})

SMODS.Sound({
    key = "pnf_pixelsounds", -- Please include your name/team name in your atlas keys
    path = "pnf/pixelnoise.ogg",
})

SMODS.Sound({
    key = "pnf_fts", -- Please include your name/team name in your atlas keys
    path = "pnf/firsttrynoise.ogg",
})

FishAndChips.Fish {
    key = "blueax",
    atlas = "pnf_blueax",
    pos = { x = 0, y = 0 },
    weight = 1,
    blueprint_compat = true,
    ppu_coder = { "FirstTry" },
    ppu_artist = { "FirstTry" },
    attributes = { "mult", "chips", "xmult", "economy" },
    config = {
        extra = {
            scoring = 2,
            gain = 2,
            trigger = false
        },
        immutable = {
            revert = 2
        }
    },
    environments = {
        wormhole = 1,
        backroom = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.scoring, card.ability.extra.gain, colours = { HEX("4db1f6") } } }
    end,
    calculate = function(self, card, context)
        local eval = function(card) return card.ability.extra.trigger == true end
        juice_card_until(card, eval, false)
        if context.joker_main then
            if card.ability.extra.trigger then
                local ret = {}
                local scoreret = pseudorandom(pseudoseed("fish_fac_blueax"), 1, 10)
                if scoreret == 1 or scoreret == 10 then
                    ret.chips = card.ability.extra.scoring
                end
                if scoreret == 2 or scoreret == 10 then
                    ret.mult = card.ability.extra.scoring
                end
                if scoreret == 3 or scoreret == 10 then
                    ret.xmult = (card.ability.extra.scoring / 2)
                end
                if scoreret == 4 or scoreret == 10 then
                    ret.xchips = (card.ability.extra.scoring / 2)
                end
                if scoreret == 5 or scoreret == 10 then
                    ret.score = card.ability.extra.scoring
                end
                if scoreret == 6 or scoreret == 10 then
                    ret.xscore = (card.ability.extra.scoring / 2)
                end
                if scoreret == 7 or scoreret == 10 then
                    ret.blindsize = -card.ability.extra.scoring
                end
                if scoreret == 8 or scoreret == 10 then
                    ret.xblindsize = -(card.ability.extra.scoring / 2)
                end
                if scoreret == 9 or scoreret == 10 then
                    ret.dollars = card.ability.extra.scoring
                end
                return ret
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "scoring",
                    scalar_value = "gain",
                    operation = "X",
                    scaling_message = {
                        message = "+" .. (card.ability.extra.scoring * card.ability.extra.gain) .. " Value",
                        colour = G.C.DARK_EDITION
                    }
                })
            end
        end
        if context.after then
            if card.ability.extra.trigger then
                card.ability.extra.scoring = card.ability.immutable.revert
                card.ability.extra.trigger = false
                return { message = localize("k_reset") }
            end
        end
    end,
    can_use = function(self, card)
        return G.GAME.blind.in_blind
    end,
    keep_on_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        card.ability.extra.trigger = true
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.5 + math.random() * 0.4,
            func = function()
                play_sound('gong', 1, 0.5)
                card:juice_up(1, 0.2)
                return true
            end
        }))
    end
}

FishAndChips.Fish {
    key = "dupli",
    atlas = "pnf_dupli",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    weight = 1,
    blueprint_compat = true,
    ppu_coder = { "FirstTry" },
    ppu_artist = { "FirstTry" },
    attributes = { "mult" },
    config = {
        extra = {
            mult = 0,
            mult_mod = 2,
        },
        immutable = {
            revert = 0
        }
    },
    environments = {
        wormhole = 1,
        backroom = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod, colours = { HEX("4db1f6") } } }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.mult = card.ability.immutable.revert
            return { message = localize("k_reset") }
        end
        if context.individual and context.cardarea == G.play then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_mod",
                scaling_message = {
                    message = "+" .. (card.ability.extra.mult * card.ability.extra.mult_mod) .. " Mult",
                    colour = G.C.MULT
                }
            })
        end
        if (context.joker_main and (to_big(card.ability.extra.mult) > 1)) or context.forcetrigger then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}

FishAndChips.Fish {
    key = "pixelfish",
    atlas = "pnf_pixelfish",
    pos = { x = 0, y = 0 },
    weight = 5,
    blueprint_compat = true,
    ppu_coder = { "Pixel" },
    ppu_artist = { "FirstTry" },
    attributes = { "chips", "chipgain", "xchips", "xchipgain", "sellamount", "sellgoal" },
    config = {
        extra = {
            chips = 0,
            xchips = 1,
            chipgain = 5,
            xchipgain = 0.05,
        },
        immutable = {
            sellamount = 0,
            sellgoal = 3,
        }
    },
    environments = {
        city_river = 5,
        wormhole = 1
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.xchips, card.ability.extra.chipgain, card.ability.extra.xchipgain, card.ability.immutable.sellamount, card.ability.immutable.sellgoal } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then return { chips = card.ability.extra.chips, xchips = card.ability.extra.xchips } end
        if context.selling_card then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips",
                scalar_value = "chipgain",
                scaling_message = {
                    message = "+" .. (card.ability.extra.chips + card.ability.extra.chipgain) .. " Chips",
                    colour = G.C.CHIPS
                }
            })
            card.ability.immutable.sellamount = card.ability.immutable.sellamount + 1
            if card.ability.immutable.sellamount > card.ability.immutable.sellgoal - 1 then
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xchips",
                    scalar_value = "xchipgain",
                    scaling_message = {
                        message = "+" .. (card.ability.extra.xchips + card.ability.extra.xchipgain) .. " XChips",
                        colour = G.C.CHIPS
                    }
                })
            card.ability.immutable.sellamount = 0
            end
        end
    end,
}

FishAndChips.Fish {
    key = "ribbit",
    atlas = "pnf_rib",
    pos = { x = 0, y = 0 },
    weight = 5,
    blueprint_compat = true,
    ppu_coder = { "FirstTry" },
    ppu_artist = { "FirstTry" },
    attributes = { "passive" },
    config = {
        extra = {
            select = 1,
        },
        immutable = {
            revert = 0
        }
    },
    environments = {
        calm_pond = 5,
        swamp = 5
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.select, colours = { HEX("4db1f6") } } }
    end,
    add_to_deck = function (self, card, from_debuff)
    local add = card.ability.extra.select
	G.hand:change_size(add)
    SMODS.change_play_limit(add)
	SMODS.change_discard_limit(add)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards - add
    ease_discard(-add)
    end,
    remove_from_deck = function (self, card, from_debuff)
    local add = card.ability.extra.select
    G.hand:change_size(-add)
    SMODS.change_play_limit(-add)
	SMODS.change_discard_limit(-add)
    G.GAME.round_resets.discards = G.GAME.round_resets.discards + add
    ease_discard(add)
    end,
}

FishAndChips.Fish {
    key = "patrickstarwalker",
    atlas = "pnf_star",
    pos = { x = 0, y = 0 },
    weight = 3,
    blueprint_compat = true,
    ppu_coder = { "FirstTry" },
    ppu_artist = { "FirstTry" },
    attributes = { "chips", "destroy_card" },
    config = {
        extra = {
            xchips = 1,
            add = 0.2
        },
        immutable = {
            revert = 0
        }
    },
    environments = {
        city_river = 1,
        wormhole = 3,
        styx = 1,
        backroom = 3
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.xchips, card.ability.extra.add, colours = { HEX("4db1f6") } } }
    end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {xchips = card.ability.extra.xchips}
            end
    if context.destroy_card and context.cardarea == G.play then
                if SMODS.has_enhancement(context.destroy_card,"m_stone") then
                    SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "xchips",
                    scalar_value = "add",
                    operation = "+",
                    message_key = "a_xchips",
                    message_colour = G.C.CHIPS
                })
             return {remove = true}
        end
    end
end
}


FishAndChips.Fish {
    key = "flyinganchovy",
    atlas = "pnf_flyan",
    pos = { x = 0, y = 0 },
    weight = 3,
    blueprint_compat = true,
    ppu_coder = { "FirstTry" },
    ppu_artist = { "FirstTry" },
    attributes = { "mult", "rank" },
    config = {
        extra = {
            mult = 1
        },
        immutable = {
            revert = 0
        }
    },
    environments = {
        soup = 5,
        chocolate_river = 3,
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return { vars = { card.ability.extra.xchips, card.ability.extra.add, colours = { HEX("4db1f6") } } }
    end,
        calculate = function(self, card, context)
       if context.individual and context.cardarea == G.play and not context.end_of_round then
         if next(context.poker_hands['Straight']) then
            local rankmult, cardID = 1,1
            local raised_card = nil
            for i = 1, #G.play.cards do
                if cardID <= G.play.cards[i].base.id and not SMODS.has_no_rank(G.play.cards[i]) then
                    rankmult = G.play.cards[i].base.nominal
                    cardID = G.play.cards[i].base.id
                    raised_card = G.play.cards[i]
                end
            end
            if raised_card == context.other_card then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    return {
                        mult = rankmult
                    }
                end
            end
        end
    end
end
}
