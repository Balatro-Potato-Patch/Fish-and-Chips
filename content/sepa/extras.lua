SMODS.Atlas({
	key = "fac_sepa_devs",
	path = "sepa/catrabbit.png",
	px = 71,
	py = 95,
})

SMODS.Font{
    key = "ultra",
    path = "VCR_OSD_MONO_1.001.ttf",
    render_scale = 200,
    TEXT_HEIGHT_SCALE = 0.83,
    TEXT_OFFSET = {x=0,y=0},
    FONTSCALE = 0.1,
    squish = 1,
    DESCSCALE = 1
}

SMODS.ObjectType({
    key = "fac_sepa_goodtarots",
    default = "c_fool",
    cards = {
		c_fool = true,
		c_hermit = true,
		c_emperor = true,
		c_hanged_man = true,
		c_death = true,
    },
})

--[[SMODS.ObjectType({
    key = "fac_sepa_goodspectrals",
    default = "c_fool",
    cards = {
		c_fool = true,
		c_hermit = true,
		c_emperor = true,
		c_high_priestess = true,
		c_hanged_man = true,
		c_death = true,
    },
})]]

SMODS.Sound{
    key = "ultrakill-explosion",
    path = "sepa/ultrakill-explosion.ogg",
    pitch = 1,
    volume = 0.5,
}