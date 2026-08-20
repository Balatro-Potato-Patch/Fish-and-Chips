FishAndChips = FishAndChips or {}
FishAndChips.mod = SMODS.current_mod

FishAndChips.mod_badge = {
	x = 0,
	y = 0,
	r = math.pi * 5 / 6,
	cr = 1,
	sr = 0,
	v = 0,
	vr = -0.25/2,
}

--#region Assets
FishAndChips.C = {
	FISH = HEX("4db1f6"),
	ROD = HEX("F64D4D"),
	ENVIRONMENT = HEX("297539"),
	SAND_DOLLAR = HEX("ff8a8a"),
    FAC_PRIMARY = HEX("5987c3"),
    FAC_SECONDARY = HEX("9ebcdf"),
    COMPENDIUM_COLOUR = adjust_alpha(darken(HEX('764634'), 0.9), 0.4),
    COMPENDIUM_TEXT = adjust_alpha(darken(HEX('764634'), 0.9), 0.6)
}

FishAndChips.discovery_gradient = SMODS.Gradient {
	key = 'discovery',
	colours = {
		HEX('f7d460'),
		G.C.UI.TEXT_LIGHT
	},
	cycle = 1,
	interpolation = 'trig'
}

FishAndChips.suits_gradient = SMODS.Gradient {
	key = "suits",
	colours = {
		G.C.SUITS.Spades,
		G.C.SUITS.Hearts,
		G.C.SUITS.Clubs,
		G.C.SUITS.Diamonds
	},
	cycle = 8,
	interpolation = 'trig',
}
G.C.FAC_SUIT = FishAndChips.suits_gradient
G.ARGS.LOC_COLOURS["fac_suits"] = G.C.FAC_SUIT
G.ARGS.LOC_COLOURS['fac_sand_dollars'] = FishAndChips.C.SAND_DOLLAR
G.ARGS.LOC_COLOURS['fac_fish'] = FishAndChips.C.FISH
G.ARGS.LOC_COLOURS['fac_rod'] = FishAndChips.C.ROD
G.ARGS.LOC_COLOURS['fac_environment'] = FishAndChips.C.ENVIRONMENT

SMODS.Atlas({
	key = "soup",
	path = "core/soup.png",
	px = 1,
	py = 1,
})

SMODS.Atlas({
	key = "placeholders",
	path = "core/placeholders.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "bucket",
	path = "core/bucket.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "cards",
	path = "core/cards.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "bait",
	path = "core/bait.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "mini_bait",
	path = "core/mini_bait.png",
	px = 35,
	py = 35,
})

SMODS.Atlas({
	key = "rods",
	path = "core/rods.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "logo",
	path = "core/logo.png",
	px = 263,
	py = 129,
})

SMODS.Atlas{
	key = "upgrade_bucket",
	path = "core/bucket_plus.png",
	px = 71,
	py = 95
}

--#endregion

PotatoPatchUtils.load_files(FishAndChips.mod.path .. '/src')
PotatoPatchUtils.load_files(FishAndChips.mod.path .. '/content')

SMODS.handle_loc_file(FishAndChips.mod.path)
PotatoPatchUtils.LOC.init()
