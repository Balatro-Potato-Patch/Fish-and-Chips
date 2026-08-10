PotatoPatchUtils.Developer({
	name = 'stoatski',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	ignore_limits = false -- USING THIS VALUE WILL RESULT IN YOUR SUBMISSION BEING REJECTED
})

SMODS.Atlas({
	key = "stoatskifish", -- Please include your name/team name in your atlas keys
	path = "stoatski/stoatskifish.png",
	px = 71,
	py = 95,
})


FishAndChips.Fish {
	key = "otter",
	weight = 10,
	atlas = "stoatskifish",
	pos = { x = 0, y = 0 },
	ppu_coder = { "stoatski" },
	in_pool = function() return false end,
	discovered = true,
    environments = {
		pier = 1000,
		city_river = 1000,
		wormhole = 100,
		calm_pond = 1000
	}
}