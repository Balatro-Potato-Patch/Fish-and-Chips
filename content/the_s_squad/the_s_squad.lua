PotatoPatchUtils.Developer{
	name = 'slimestuff',
	atlas = 'fac_cards',
	colour = HEX("FF53A9"),
	fac_partner = 'azazel',
	loc = true
}

PotatoPatchUtils.Developer{
	name = 'azazel',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	fac_partner = 'slimestuff',
	loc = true
}

SMODS.Atlas{
	key = "tss_fish", -- Please include your name/team name in your atlas keys
	path = "the_s_squad/fish.png",
	px = 71,
	py = 95,
}

for i = 1, 3 do
	SMODS.Sound {
		key = 'tss_eat'..i,
		path = 'the_s_squad/eat'..i..'.ogg',
		volume = 1
	}
end
	
SMODS.Sound {
	key = 'tss_burp',
	path = 'the_s_squad/burp.ogg',
	volume = 1
}