-- Fish
SEABUN = {
    enchant = function(card)
        card.ability.extra.enchant = true
        G.E_MANAGER:add_event(Event{func = function()
            card.ability.extra.show_enchant = true
            card:juice_up(0.6, 0.1)
            play_sound("fac_enchant", 1, 0.8)
            return true end})
    end
}

SMODS.Atlas {
    key = "seabunny",
    path = "seabunny/fish.png",
    px = 71,
    py = 95
}

SMODS.Shader {
    key = "enchant",
    path = "seabunny/enchant.fs"
}

SMODS.DrawStep {
    key = "enchant",
    order = 21,
    func = function(card, layer)
        if type(card.ability.extra) == "table" and card.ability.extra.show_enchant then
            card.children.center:draw_shader("fac_enchant", nil, G.TIMERS.REAL)
        end
    end
}

SMODS.Sound {
    key = "enchant",
    path = "seabunny/enchant.ogg"
}

-- Potato Patch Utils
SMODS.Atlas {
    key = "seabunny_credits",
    path = "seabunny/credits.png",
    px = 71,
    py = 95
}

PotatoPatchUtils.Developer {
    name = "ouiiskey",
    colour = HEX("f96932"),
    atlas = "fac_seabunny_credits",
    pos = {x = 0, y = 0},
    fac_partner = "fac_Lusha",
    loc = "PotatoPatchDev_ouiiskey",
    loc_vars = function(self, info_queue, card)
        return {vars = {elements = {DynaText{
            string = localize{type = "name_text", key = "PotatoPatchDev_Lusha", set = "PotatoPatch"},
            colours = {HEX("f35555")}, scale = 0.3,
            shaders = {"fac_lusha"},
            silent = true,
            font = SMODS.Fonts.fac_collection
            }
        }}}
    end,
    calculate = function(self, context)
        if context.selling_card and context.card.ability.set == "fac_Fish" then
            G.GAME.current_round.fish_sold = true
        elseif context.round_eval then
            G.GAME.current_round.fish_sold = false
            for k, v in ipairs(G.deck.cards) do
                if v.ability.temp_repetitions then
                    v.ability.perma_repetitions = v.ability.perma_repetitions - v.ability.temp_repetitions
                    v.ability.temp_repetitions = 0
                end
            end
        end
    end
}

SMODS.Shader {
    key = "lusha",
    path = "seabunny/lusha.fs"
}

SMODS.Atlas {
    key = "rabbit1",
    path = "seabunny/rabbit1.png",
    px = 144,
    py = 144,
    atlas_table = "ANIMATION_ATLAS",
    frames = 14
}

SMODS.Atlas {
    key = "rabbit2",
    path = "seabunny/rabbit2.png",
    px = 144,
    py = 144,
    atlas_table = "ANIMATION_ATLAS",
    frames = 29
}

SMODS.Atlas {
    key = "rabbit3",
    path = "seabunny/rabbit3.png",
    px = 144,
    py = 144,
    atlas_table = "ANIMATION_ATLAS",
    frames = 17
}

SMODS.Atlas {
    key = "rabbit4",
    path = "seabunny/rabbit4.png",
    px = 144,
    py = 144,
    atlas_table = "ANIMATION_ATLAS",
    frames = 35
}

PotatoPatchUtils.Developer {
    name = "Lusha",
    colour = HEX("f35555"),
    shaders = {"fac_lusha"},
    atlas = "fac_seabunny_credits",
    pos = {x = 1, y = 0},
    fac_partner = "fac_ouiiskey",
    loc = "PotatoPatchDev_Lusha",
    loc_vars = function(self, info_queue, card)
        return {vars = {colours = {HEX("f96932")}, elements = {
            SMODS.create_sprite(0, 0, G.CARD_H * 2 / 3, G.CARD_H * 2 / 3, "fac_rabbit" .. pseudorandom("fac_rabbit", 1, 4), {y = 0})
        }}}
    end,
    click = function ()
        love.system.openURL("https://lushabun.carrd.co/")
    end
}
