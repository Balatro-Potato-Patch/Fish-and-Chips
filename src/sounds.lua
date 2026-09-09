-- default fishing music
-- also for calm pond

SMODS.Sound{
	key = "calm_pond_music",
	path = "core/calm_pond.ogg",
	sync = {
		['music1'] = true,
		['music2'] = true,
		['music3'] = true,
		['music4'] = true,
		['music5'] = true,
        ['fac_music_findows_main'] = true,
        ['fac_music_findows_shop'] = true,
        ['fac_music_findows_boss'] = true,
        ['fac_music_findows_booster'] = true,
	},
	select_music_track = function(self) 
		return G.STATE == G.STATES.FAC_FISHING and 110 or nil
	end
}

for i = 1, 6 do
	SMODS.Sound({
		key = "snapper_voice-0" .. i,
		path = "core/fac_snapper_voice-0" .. i .. ".ogg"
	})
end

-- sfx
SMODS.Sound {
	key = 'celebration',
	path = 'core/celebration tone.ogg',
	volume = 0.8
}

SMODS.Sound {
	key = 'discovery',
	path = 'core/new fish discovered.ogg',
	volume = 0.8
}

SMODS.Sound {
	key = 'fish_on',
	path = 'core/fish on.ogg',
	volume = 0.8
}

SMODS.Sound {
	key = 'fish_landed',
	path = 'core/fish landed.ogg',
}

SMODS.Sound {
	key = 'rod_swing',
	path = 'core/rod swing.ogg',
	volume = 0.8
}

SMODS.Sound {
	key = 'bobber_hit',
	path = 'core/bobber hitting water.ogg',
	volume = 0.8
}

SMODS.Sound {
	key = 'line_snap',
	path = 'core/line snap.ogg',
}

SMODS.Sound {
	key = 'perfect_catch',
	path = 'core/perfect_catch.ogg',
}

SMODS.Sound {
	key = 'treasure_get',
	path = 'core/treasure get.ogg',
	volume = 0.8
}

SMODS.Sound {
	key = "flip_page",
	path = "core/fac_flip_page.ogg",
	volume = 0.2
}

SMODS.Sound {
	key = "book_close",
	path = "core/fac_book_close.ogg",
	volume = 0.2
}

-- ambience
SMODS.Sound {
	key = 'ambience_calm_pond',
	path = 'core/ambience_calm_pond.ogg'
}

SMODS.Sound {
	key = 'ambience_canal_district',
	path = 'core/ambience_canal_district.ogg'
}

SMODS.Sound {
	key = 'ambience_volcano',
	path = 'core/ambience_volcano.ogg'
}

SMODS.Sound {
	key = 'ambience_swamp',
	path = 'core/ambience_swamp.ogg'
}

SMODS.Sound {
	key = 'ambience_pier',
	path = 'core/ambience_pier.ogg'
}

SMODS.Sound {
	key = 'ambience_soup',
	path = 'core/ambience_soup.ogg'
}

SMODS.Sound {
	key = 'ambience_cavern',
	path = 'core/ambience_cavern.ogg'
}

SMODS.Sound {
	key = 'ambience_styx',
	path = 'core/ambience_styx.ogg'
}

SMODS.Sound {
	key = 'ambience_wormhole',
	path = 'core/ambience_wormhole.ogg'
}

SMODS.Sound {
	key = 'ambience_backroom',
	path = 'core/ambience_backroom.ogg'
}
