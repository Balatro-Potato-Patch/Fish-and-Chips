PotatoPatchUtils.Developer {
    name = "metanite64",
    colour = HEX("FF61F7"),
    loc = true
}

SMODS.Atlas {
    key = "meta_fish",
    path = "metanite64/fish.png",
    px = 71, py = 95
}

SMODS.current_mod.optional_features = SMODS.current_mod.optional_features or {}
SMODS.current_mod.optional_features.post_trigger = true
