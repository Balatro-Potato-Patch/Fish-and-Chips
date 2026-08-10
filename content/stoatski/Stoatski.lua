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

-- FALLBACK FISH FOR EMPTY POOLS
local function all_env()
	local ret = {}
	for _, k in ipairs(FishAndChips.Environment.obj_buffer) do
		ret[k] = 10
	end
	return ret
end

FishAndChips.Fish {
	key = "otter",
	weight = 10,
	atlas = "stoatskifish",
	pos = { x = 0, y = 0 },
	ppu_coder = { "stoatski" },
	--discovered = true,
    environments = {
		calm_pond = 10,
		city_river = 5
	},
}