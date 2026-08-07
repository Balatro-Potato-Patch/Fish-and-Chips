SMODS.Sound{
    key = "minty_meow",
    path = "minty/meow.wav"
}

SMODS.Atlas{
    key = "minty_fish",
    path = "minty/fish.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "minty_lineboilfish",
    path = "minty/animated fish.png",
    px = 71,
    py = 95,
    atlas_table = "ANIMATION_ATLAS",
    frames = 2,
    fps = 4
}

SMODS.Atlas{
    key = "minty_nolineboilfish",
    path = "minty/animated fish.png",
    px = 71,
    py = 95,
}

SMODS.Attribute{ --Cards which do nothing
    key = "nothing",
    alias = {
        "useless", "no_effect"
    }
}