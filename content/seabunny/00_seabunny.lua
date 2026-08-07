-- Potato Patch Utils
PotatoPatchUtils.Developer {
    name = "ouiiskey",
    colour = HEX("f96932"),
    atlas = "fac_seabunny",
    pos = {x = 0, y = 0},
    fac_partner = "fac_Lusha"
}

SMODS.Shader {
    key = "lusha",
    path = "seabunny/lusha.fs"
}

PotatoPatchUtils.Developer {
    name = "Lusha",
    colour = HEX("f35555"),
    shaders = {"fac_lusha"},
    atlas = "fac_seabunny",
    pos = {x = 0, y = 0},
    fac_partner = "fac_ouiiskey"
}

-- Fish
SEABUN = {
    weight = 75 / 8,
    enchant = function(card)
        card.ability.extra.enchant = true
        G.E_MANAGER:add_event(Event{func = function()
            card.ability.extra.show_enchant = true
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

local Scmc_ref = SMODS.current_mod.calculate
SMODS.current_mod.calculate = function(self, context)
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
    Scmc_ref(self, context)
end