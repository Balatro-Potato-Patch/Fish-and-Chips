PotatoPatchUtils.Developer({
	name = 'stoatski',
	--atlas = 'fac_cards',
	colour = G.C.YELLOW,
	ignore_limits = false -- USING THIS VALUE WILL RESULT IN YOUR SUBMISSION BEING REJECTED
})

SMODS.Atlas({
	key = "stoatfish", -- Please include your name/team name in your atlas keys
	path = "stoatski/fish.png",
	px = 71,
	py = 95,
})


FishAndChips.Fish {
	key = "stoatfish",
	weight = 10,
	atlas = "otter",
	pos = { x = 0, y = 0 },
	ppu_coder = { "stoatski" },
	in_pool = function() return false end,
	no_collection = true,
	discovered = true,
    environments = {
		pier = 10,
		city_river = 2.5
	},
}