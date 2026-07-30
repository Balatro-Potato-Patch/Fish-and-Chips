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

local function getPosForSmartass() -- w local spam for readability 🥹
	local wTen = love.graphics.getWidth() / 10
	local hTen = love.graphics.getHeight() / 10
	local centerX = love.graphics.getWidth() / 2
	local centerY = love.graphics.getHeight() / 2
	return math.floor(math.random(-wTen, wTen)) + centerX, math.floor(math.random(-hTen, hTen)) + centerY
end
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
	cost = 4,
	config = {
		extra = {
			mult = 0,
			mult_gain = 6,
			active = true,
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
	calculate = function(self, card, context)
		--
	end,
})
]]

-- wood letter

-- plastic letter

-- cat fish

-- yhsifishy

SMODS.Sound({
	key = "l_i_87",
	path = "lexi_inky/87.ogg",
})

FishAndChips.Fish({
	key = "l_i_freddy",
	--atlas = "l_i_fish",
	--pos = { x = 0, y = 0 },
	weight = 10,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"rank",
	},
	environments = {
		wormhole = 1,
		backroom = 0.5,
	},
	cost = 4,
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sand,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.initial_scoring_step and not context.blueprint then
			if #context.scoring_hand == 4 and #context.scoring_hand == #context.full_hand then
				for k, v in ipairs(context.scoring_hand) do
					if k == 1 then
						assert(SMODS.change_base(v, nil, "Ace"))
						v:juice_up()
					end
					if k == 2 then
						assert(SMODS.change_base(v, nil, "9"))
						v:juice_up()
					end
					if k == 3 then
						assert(SMODS.change_base(v, nil, "8"))
						v:juice_up()
					end
					if k == 4 then
						assert(SMODS.change_base(v, nil, "7"))
						v:juice_up()
					end
				end
			end
		end
	end,
	on_catch = function(self, card)
		play_sound("fac_l_i_87", nil, 2)
	end,
})
