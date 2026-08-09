PotatoPatchUtils.Developer {
    name = "metanite64",
    colour = HEX("FF61F7"),
    loc = true,
    atlas = "fac_meta_credits"
}

SMODS.Atlas {
    key = "meta_credits",
    path = "metanite64/credits.png",
    px = 71, py = 95
}

SMODS.Atlas {
    key = "meta_fish",
    path = "metanite64/fish.png",
    px = 71, py = 95
}

SMODS.Atlas {
    key = "meta_obstacles",
    path = "metanite64/obstacles.png",
    px = 32, py = 32
}

SMODS.current_mod.optional_features = SMODS.current_mod.optional_features or {}
SMODS.current_mod.optional_features.post_trigger = true

local rgg_ref = SMODS.current_mod.reset_game_globals or function(run_start) return end
SMODS.current_mod.reset_game_globals = function(run_start)
    rgg_ref(run_start)
    if run_start then
        G.GAME.fac_meta = {
            tsuchi_bonus = 0
        }
    end
end

G.ARGS.LOC_COLOURS.fac_meta = HEX("F399FF")
G.ARGS.LOC_COLOURS.fac_meta_quint = HEX("7C008F")
