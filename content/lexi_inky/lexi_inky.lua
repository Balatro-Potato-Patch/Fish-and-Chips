SMODS.Gradient({
	key = "l_i_lexi",
	colours = {
		HEX("ff75c9"),
		G.C.WHITE,
		G.C.ORANGE,
	},
	cycle = 2,
})

PotatoPatchUtils.Developer({
	name = "lexi",
	--atlas = "",
	colour = SMODS.Gradients["fac_l_i_lexi"],
	fac_partner = "inky",
	loc = true,
	click = function(self)
		love.system.openURL("https://triple6lexi.carrd.co/")
	end,
})

PotatoPatchUtils.Developer({
	name = "inky",
	--atlas = "",
	colour = HEX("189bcc"),
	fac_partner = "lexi",
	loc = true,
})

--[[SMODS.Atlas({
	key = "l_i_credits",
	path = "lexi_inky/credits.png",
	px = 71,
	py = 95,
})]]

SMODS.Atlas({
	key = "l_i_fish",
	path = "lexi_inky/fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish({
	key = "l_i_square",
	atlas = "l_i_fish",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"economy",
		"rank",
	},
	environments = {
		calm_pond = 1,
	},
	cost = 2,
	config = {
		extra = {
			sand = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sand,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 4 then
				return {
					sand_dollars = card.ability.extra.sand,
				}
			end
		end
	end,
})

SMODS.Atlas({
	key = "l_i_smartass",
	path = "lexi_inky/smartass.png",
	px = 360,
	py = 360,
	atlas_table = "ANIMATION_ATLAS",
	frames = 35,
	fps = 35,
})
--[[
FishAndChips.Fish({
	key = "l_i_smartass",
	--atlas = "l_i_smartass",
	pos = { x = 0, y = 0 },
	weight = 5,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"passive",
		"mult",
	},
	environments = {
		calm_pond = 1,
	},
	cost = 2,
	config = {
		extra = {
			mult = 0,
			mult_gain = 6,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.mult_gain,
				elements = {
					SMODS.create_sprite(0, 0, 3, 3, "fac_l_i_smartass"),
				},
			},
		}
	end,
})]]
