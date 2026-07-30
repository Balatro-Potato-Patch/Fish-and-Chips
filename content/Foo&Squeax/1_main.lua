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
	px = 71,
	py = 95,
}

PotatoPatchUtils.Developer{
	name = "Foo54",
	atlas = "fac_fas_credits_foo",
	colour = HEX("ED5B5B"),
	fac_partner = "Squeax",
	loc = true
}

PotatoPatchUtils.Developer{
	name = "Squeax",
	atlas = "fac_fas_credits_foo",
	colour = HEX("ED5B5B"),
	fac_partner = "Foo54",
	loc = true
}

