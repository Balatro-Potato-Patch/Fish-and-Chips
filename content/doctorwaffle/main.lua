local PPU = PotatoPatchUtils

SMODS.Atlas {
    key = "waffle_credit",
    px = 71,
    py = 95,
    path = "doctorwaffle/credit.png"
}

PPU.Developer({
	name = 'waffle',
	atlas = 'fac_waffle_credit',
	colour = HEX("7A2E2E"),
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    loc = true
})