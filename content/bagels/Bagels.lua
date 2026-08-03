SMODS.Atlas {
	key = 'bagels_credits',
	path = 'bagels/credits.png',
	px = 71,
	py = 95,
}
SMODS.Atlas {
	key = 'bagels_fish',
	path = 'bagels/fish.png',
	px = 71,
	py = 95,
}

PotatoPatchUtils.Developer {
	name = 'Emik',
	atlas = 'fac_bagels_credits',
	loc = true,
	pos = { x = 0, y = 1 },
	soul_pos = { x = 1, y = 1 },
	colour = G.C.BLACK,
	fac_partner = 'BakersDozenBagels',
}
PotatoPatchUtils.Developer {
	name = 'BakersDozenBagels',
	atlas = 'fac_bagels_credits',
	loc = true,
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	colour = G.C.BLACK,
	fac_partner = 'Emik',
}

FishAndChips.Fish {
	key = 'bagels_gwah',
	atlas = 'bagels_fish',
	pos = { x = 0, y = 0 },
	weight = 75,
	environments = { calm_pond = 1 },
	attributes = {},
	ppu_coder = { 'BakersDozenBagels' },
	stats = { weight = { min = 2, max = 3 }, length = { min = 3, max = 4 } },
	treasure = true,
}

if Balatest then
	Balatest.TestPlay {
		name = 'bagels_gwah',
		execute = function()
			FishAndChips.Balatest_obtain_fish {
				{ fish = 'fish_fac_bagels_gwah', weight = 1 },
				{ fish = 'fish_fac_bagels_gwah', weight = 2 },
				{ fish = 'fish_fac_bagels_gwah', weight = 3 },
				{ fish = 'fish_fac_bagels_gwah', weight = 4 },
				{ fish = 'fish_fac_bagels_gwah', weight = 5 },
			}
		end,
	}
end
