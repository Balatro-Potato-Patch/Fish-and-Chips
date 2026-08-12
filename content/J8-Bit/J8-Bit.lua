-- ## ATLASES ##

SMODS.Atlas({
    key = "j8bit_fish", -- Please include your name/team name in your atlas keys
    path = "J8-Bit/fish.png",
    px = 71,
    py = 95,
})

SMODS.Atlas({
    key = "j8bit_credits", -- Please include your name/team name in your atlas keys
    path = "J8-Bit/credits.png",
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

FishAndChips.AttributeColorTable = {
    mult = G.C.MULT,
    chips = G.C.CHIPS,
    economy = G.C.MONEY,
    xmult = G.C.MULT,
    retrigger = G.C.FILTER,
    hand_level = G.C.SECONDARY_SET.Planet,
    usable = G.C.RED,
    suits = FishAndChips.suits_gradient,
    suit = FishAndChips.suits_gradient,
    passive = G.C.BLUE,
    rank = G.C.UI.TEXT_DARK,
    copying = G.C.GREEN,
    generation = G.C.FILTER,
    boss_blind = G.C.DYN_UI.DARK,
    destroy_card = G.C.RED,
    food = G.C.INACTIVE,
    hand = G.C.BLUE,
    hands = G.C.BLUE,
    discard = G.C.RED,
    discards = G.C.RED,
    xchips = G.C.CHIPS,
    score = G.C.PURPLE,
    xscore = G.C.PURPLE,
    blindsize = G.C.DYN_UI.LIGHT or G.C.DYN_UI.DARK,
    balance = G.C.PURPLE,
    swap = G.C.SWAP,
    reset = G.C.INACTIVE,
    diamonds = G.C.SUITS.Diamonds,
    hearts = G.C.SUITS.Hearts,
    spades = G.C.SUITS.Spades,
    clubs = G.C.SUITS.Clubs,
    chance = G.C.GREEN,
    mod_chance = G.C.GREEN,
    joker_slot = G.C.FILTER,
    joker = G.C.FILTER,
    tarot = G.C.SECONDARY_SET.Tarot,
    planet = G.C.SECONDARY_SET.Planet,
    spectral = G.C.SECONDARY_SET.Spectral,
    enhancement = G.C.SECONDARY_SET.Enhanced,
    editions = G.C.DARK_EDITION,
    seals = G.C.DARK_EDITION,
    tags = G.C.FILTER,
    reroll = G.C.GREEN,
    on_sell = G.C.MONEY
}

-- ## DEVELOPERS ##
local j8_click_count = 5
PotatoPatchUtils.Developer({
    name = 'J8-Bit',
    atlas = 'fac_j8bit_credits',
    text_effect = "fac_j8_text",
    loc = "PotatoPatchDev_J8-Bit",
    pos = { x = 0, y = 0 },
    click = function(self)
        --play_sound('worm_lfc_j8_click',1.5-j8_click_count*0.1,2)
        j8_click_count = j8_click_count - 1
        if j8_click_count <= 0 then
            j8_click_count = 5
            self:juice_up()
            love.system.openURL("https://bsky.app/profile/j8-bit.bsky.social")
            love.system.openURL("https://www.youtube.com/@j8-bitforager842")
            love.system.openURL("https://aforager.tumblr.com")
            love.system.openURL("https://store.steampowered.com/app/4551740/CalvinChess/")
            love.system.openURL("https://balatromods.miraheze.org/wiki/Forager_Nonessentials")
        end
    end
})

-- ## SHADERS ##

FishAndChips.load_custom_image = function(filename)
    local full_path = (SMODS.current_mod.path .. "assets/1x/" .. filename)
    local file_data = assert(NFS.newFileData(full_path), ("Failed to create file_data"))
    local tempimagedata = assert(love.image.newImageData(file_data), ("Failed to create tempimagedata"))
    return (assert(love.graphics.newImage(tempimagedata), ("Failed to create return image")))
end
SMODS.Shader({ key = 'axo', path = 'J8-Bit/axo.fs' })
FishAndChips.load_bearing_j8 = FishAndChips.load_custom_image("J8-Bit/load_bearing_j8.png")
