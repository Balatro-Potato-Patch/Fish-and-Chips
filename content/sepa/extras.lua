SMODS.Atlas({
	key = "fac_sepa_devs",
	path = "sepa/catrabbit.png",
	px = 142,
	py = 95,
})

SMODS.Atlas({
	key = "fac_sepa_bagremove",
	path = "sepa/bagreselfsmoke.png",
	px = 71,
	py = 133,
	atlas_table = 'ANIMATION_ATLAS',
	frames = 10, 
	fps = 5
})

SMODS.Atlas({
	key = "fac_sepa_darkner",
	path = "sepa/devicehands.png",
	px = 81,
	py = 95,
	atlas_table = 'ANIMATION_ATLAS',
	frames = 4, 
	fps = 2
})

SMODS.Font{
    key = "sepa_ultra",
    path = "sepa/VCR_OSD_MONO_1.001.ttf",
    render_scale = 200,
    TEXT_HEIGHT_SCALE = 0.83,
    TEXT_OFFSET = {x=0,y=0},
    FONTSCALE = 0.1,
    squish = 1,
    DESCSCALE = 1
}

SMODS.Font{
    key = "sepa_spongemeboy",
    path = "sepa/Spongeboy Me Bob.ttf",
    render_scale = 170,
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

SMODS.ObjectType({
    key = "fac_sepa_goodspec",
    default = "c_fool",
    cards = {
        c_talisman = true,
        c_ectoplasm = true,
        c_immolate = true,
        c_deja_vu = true,
        c_hex = true,
        c_trance = true,
        c_medium = true,
        c_cryptid = true,
        c_aura = true,
    },
})

SMODS.Sound{
    key = "ultrakill-explosion",
    path = "sepa/ultrakill-explosion.ogg",
    pitch = 1,
    volume = 0.5,
}


for i = 1, 7 do
    SMODS.Sound({
        key = 'credits_voices_' .. i,
        path = 'sepa/CreditVoices/audio' .. i .. '.ogg'
   })
end


for i = 1, 20 do
    SMODS.Sound({
        key = 'credits_audio_' .. i,
        path = 'sepa/Omg so many fucking sounds/audio' .. i .. '.ogg'
   })
end