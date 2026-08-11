--#region Misc
PotatoPatchUtils.Developer({
	name = 'Pulsar',
	atlas = 'fac_pa_pulsarfish',
	pos = {x = 2, y = 3},
	colour = FishAndChips.C.FISH,            --fish!!!!!
	fac_partner = 'fac_Axy',
	loc = true,
	loc_vars = function(self, info_queue, card)
        local quip_list = {
            "IT'S! HD! HOUR!!!",
            'xchips.ogg',
            'Still a little sad I missed out on being a dev for wormhole',
			'Can I give a shoutout to Fishing Resort (2011)',
			'My theory is that I am the roaring knight',
			'Always bet on Planet 9',
			"Try Blindside! It's not my mod I just think it's cool",
			"I feel obligated to mention Kerbal Space Program 2 Redux somewhere",
			"Someone really needs to draw Flatbread Flounder x Sticky Steelhead ship art"
		}
        local quip = pseudorandom_element(quip_list, pseudoseed('pulsar'))
        return { vars = {
            quip,
			elements = { SMODS.create_sprite(0, 0, 0.35, 0.35, "fac_pa_pulsarplead") }
        }}
    end,

})

PotatoPatchUtils.Developer({
	name = 'Axy',
	atlas = 'fac_pa_pulsarfish',
	pos = {x = 4, y = 3},
	colour = HEX('418A83'),
	fac_partner = 'fac_Pulsar',
	pronouns = 'they_them'
})

SMODS.Atlas({
	key = "pa_pulsarfish", -- Please include your name/team name in your atlas keys
	path = "pulsar&axy/feesh.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "pa_doorfish", -- Please include your name/team name in your atlas keys
	path = "pulsar&axy/doorpopup.png",
	px = 71,
	py = 95,
})

SMODS.Sound {
	key = "pa_wiinormal",
	path = "pulsar&axy/wiiplayfishingnormal.ogg"
}
SMODS.Sound {
	key = "pa_wiibonus",
	path = "pulsar&axy/wiiplayfishingbonus.ogg"
}

SMODS.Atlas({
	key = 'pa_pulsarplead',
	path = 'pulsar&axy/pulsarplead.png',
	px = 113,
	py = 113
})

--#endregion
