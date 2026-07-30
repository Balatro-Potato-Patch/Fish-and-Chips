FishAndChips.FooSqueax = {
	file_path = "Foo&Squeax/",
	bucket = {
		on = false,
		water_height = 1
	}
}

SMODS.Atlas{
	key = "fas_credits_foo",
	path = FishAndChips.FooSqueax.file_path .. "credits/teto.png",
	atlas_table = "ANIMATION_ATLAS",
	fps = 4,
	frames = 40,
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = "fas_credits_sqx",
	path = FishAndChips.FooSqueax.file_path .. "credits/gabby.png",
	px = 71,
	py = 95,
}

PotatoPatchUtils.Developer{
	name = "Foo54",
	atlas = "fac_fas_credits_foo",
	colour = HEX("ED5B5B"),
	fac_partner = "squeax09",
	loc = true
}

PotatoPatchUtils.Developer{
	name = "squeax09",
	atlas = "fac_fas_credits_sqx",
	pixel_size = {w = 66, h = 80},
	colour = HEX("c551bd"),
	fac_partner = "Foo54",
	loc = true
}

FishAndChips.mod.optional_features = FishAndChips.mod.optional_features or {}
FishAndChips.mod.optional_features.retrigger_joker = true