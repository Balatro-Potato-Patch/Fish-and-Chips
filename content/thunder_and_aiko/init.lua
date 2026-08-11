local thunderedge_gradient = SMODS.Gradient({
	key = "thunderedge_gradient",
	colours = {
		HEX("89C41B"),
		HEX("C5CC41"),
	},
	cycle = 1.5,
})

local aikoyori_gradient = SMODS.Gradient({
	key = "aikoyori_gradient",
	colours = {
		HEX("600060"),
		HEX("000000"),
	},
	cycle = 3,
})

SMODS.Sound({
	key = "moai_catch",
	path = "thunder_and_aiko/moai.ogg",
})

SMODS.Sound({
	key = "bruh",
	path = "thunder_and_aiko/bruh.ogg",
})

SMODS.Sound({
	key = "warning",
	path = "thunder_and_aiko/warning.ogg",
})

SMODS.Font({
    key = "fac_kreon",
    path = "thunder_and_aiko/Kreon.ttf",
    FONTSCALE = 0.085,
    TEXT_HEIGHT_SCALE = 0.8,
    TEXT_OFFSET = { x = 0, y = -15 },
})

SMODS.Font({
    key = "fac_papyrus",
    path = "thunder_and_aiko/papyrus.ttf",
	TEXT_HEIGHT_SCALE = 0.7
})


SMODS.Atlas({
	key = "thunder_and_aiko_credits",
	path = "thunder_and_aiko/thunderedgeaikoyori.png",
	px = 142,
	py = 95,
})


PotatoPatchUtils.Developer({
	name = "thunderedge",
	loc = true,
	atlas = "fac_thunder_and_aiko_credits",
	colour = thunderedge_gradient,
	fac_partner = "fac_aikoyori",
	joint_credits = 2,
})

PotatoPatchUtils.Developer({
	name = "aikoyori",
	loc = true,
	atlas = "fac_thunder_and_aiko_credits",
	pos = { x = 1, y = 0 },
	colour = aikoyori_gradient,
	fac_partner = "fac_thunderedge",
	joint_credits = 2,
})
