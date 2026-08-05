-- Potato Patch Utils
PotatoPatchUtils.Developer {
    name = "ouiiskey",
    colour = HEX("f96932"),
    atlas = "fac_seabunny",
    pos = {x = 0, y = 0},
    fac_partner = "Lusha"
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
    fac_partner = "ouiiskey"
}

-- Fish
SEABUN = {
    weight = 75 / 2
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
        if type(card.ability.extra) == "table" and card.ability.extra.enchant then
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
    if context.selling_card and context.card.config.center:is(FishAndChips.Fish) then
        G.GAME.current_round.fish_sold = true
    elseif context.end_of_round then
        G.GAME.current_round.fish_sold = false
    end
    Scmc_ref(self, context)
end