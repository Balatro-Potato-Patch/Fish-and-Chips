PotatoPatchUtils.Developer({
	name = 'AbelSketch',
	atlas = 'fac_sepa_devs',
	pos = {x = 1, y = 0},
	soul_pos = {x = 1, y = 1}, 
	colour = G.C.BLACK,
	fac_partner = 'DoggFly',
	loc = true,
})

PotatoPatchUtils.Developer({
	name = 'DoggFly',
	atlas = 'fac_sepa_devs',
	pos = {x = 0, y = 0},
	soul_pos = {x = 0, y = 1}, 
	colour = G.C.RED,-- Te recomendaria que lo cambies asi a un color de preferencia, agarre rojo nomas por que si
	fac_partner = 'AbelSketch',
	loc = true
})

SMODS.Atlas({
	key = "fac_sepa_devs",
	path = "sepa/catrabbit.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "sepa_fish",
	path = "sepa/pezcaos.png",
	px = 71,
	py = 95,
})

local pez = 'sepa_fish'

FishAndChips.Fish {
	key = "clownfish",
	atlas = pez,
	pos = { x = 0, y = 0 },
	weight = 10, --testestest
	ppu_coder = { "AbelSketch" },
	ppu_artist = { "DoggFly" },
	attributes = { "mult", "hands" },
	config = {
		extra = {
			mult = 10
		}
	},
	environments = {
		pier = 1
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and G.GAME.current_round.hands_played == 0 then 
			return { 
				mult = card.ability.extra.mult 
			} 
		end
	end,
}