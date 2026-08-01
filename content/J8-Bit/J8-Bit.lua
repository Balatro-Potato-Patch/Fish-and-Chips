-- ## ATLASES ##

SMODS.Atlas({
    key = "j8bit_fish", -- Please include your name/team name in your atlas keys
    path = "J8-Bit/fish_temp.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "j8bit_credits", -- Please include your name/team name in your atlas keys
    path = "J8-Bit/credits_temp.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "j8bit_trustmeimadolphin",
    path = "J8-Bit/trustmeimadolphin.png",
    px = 460,
    py = 332,
})

SMODS.Atlas({
    key = "j8bit_poppup",
    path = "J8-Bit/poppup.png",
    px = 88,
    py = 112,
    atlas_table = 'ANIMATION_ATLAS',
    fps = 8,
    frames = 6
})

-- ## COLORS ##

loc_colour('red')
G.ARGS.LOC_COLOURS.j8bit_tumblr = HEX("36465d")
G.ARGS.LOC_COLOURS.j8bit_youtube = HEX("cc181e")
G.ARGS.LOC_COLOURS.j8bit_bluesky = HEX("01A5FF")
G.ARGS.LOC_COLOURS.j8bit_steam = HEX("171D25")

local j8_colors = {
    HEX("F1641F"),
    HEX("F1641F"),
    HEX("8306C1"),
    HEX("8306C1"),
}

SMODS.DynaTextEffect {
    key = "j8_text",
    func = function(dynatext, index, letter)
        local s = #j8_colors
        local o = index * -0.5
        local t = (G.TIMERS.REAL + o)
        letter.colour = mix_colours(
            j8_colors[((math.floor(t) + s + 1) % s) + 1],
            j8_colors[((math.floor(t) + s) % s) + 1],
            t % 1.0)
        letter.offset.y = math.sin(t * 2.0 + o) * 4
        letter.offset.x = math.cos(t * 1.0 + o) * 8
    end,
}

local rainbow_colors = {
    G.C.RED,
    G.C.FILTER,
    G.C.GOLD,
    G.C.BLUE,
    G.C.PURPLE,
}

SMODS.DynaTextEffect {
    key = "j8_rainbow",
    func = function(dynatext, index, letter)
        local s = #rainbow_colors
        local o = index * -0.5
        local t = (G.TIMERS.REAL + o)
        letter.colour = mix_colours(
            rainbow_colors[((math.floor(t) + s + 1) % s) + 1],
            rainbow_colors[((math.floor(t) + s) % s) + 1],
            t % 1.0)
    end,
}

-- ## DEVELOPERS ##

PotatoPatchUtils.Developer({
    name = 'J8-Bit',
    atlas = 'fac_j8bit_credits',
    text_effect = "fac_j8_text",
    loc = "PotatoPatchDev_J8-Bit",
    pos = { x = 0, y = 0 },
    click = function(self)
        --play_sound('worm_lfc_j8_click',1.5-j8_click_count*0.1,2)
        self:juice_up()
        love.system.openURL("https://bsky.app/profile/j8-bit.bsky.social")
        love.system.openURL("https://www.youtube.com/@j8-bitforager842")
        love.system.openURL("https://aforager.tumblr.com")
        love.system.openURL("https://store.steampowered.com/app/4551740/CalvinChess/")
        love.system.openURL("https://balatromods.miraheze.org/wiki/Forager_Nonessentials")
    end
})
