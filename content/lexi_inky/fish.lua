SMODS.Atlas({
	key = "l_i_fish",
	path = "lexi_inky/fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish({
	key = "l_i_id",
	atlas = "l_i_fish",
	pos = { x = 0, y = 1 },
	weight = 3,
	treasure = true,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"economy",
	},
	environments = {
		city_river = 1,
	},
	cost = 4,
	config = {
		extra = {
			sand = 3,
		},
	},
	stats = {
		weight = { min = 0.003, max = 0.006 },
		length = { min = 0.08, max = 0.086 },
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.sand,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.modify_final_cashout and not context.blueprint then
			local econFish = 0
			for k, v in ipairs(G.fac_fish_area.cards) do
				if v:has_attribute("economy") then
					econFish = econFish + 1
				end
			end
			if econFish > 0 then
				return {
					sand_dollars = econFish * card.ability.extra.sand,
				}
			end
		end
	end,
	badge_key = "k_fac_l_i_id",
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_feather",
	atlas = "l_i_fish",
	pos = { x = 1, y = 1 },
	weight = 3,
	treasure = true,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"economy",
	},
	environments = {
		styx = 1,
	},
	cost = 4,
	config = {
		extra = {},
	},
	stats = {
		weight = { min = 0, max = 0 },
		length = { min = 0.22, max = 0.27 },
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context) end,
	badge_key = "k_fac_l_i_feather",
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_square",
	atlas = "l_i_fish",
	pos = { x = 0, y = 0 },
	weight = 9,
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
		garden = 2,
	},
	stats = {
		weight = { min = 4, max = 12 },
		length = { min = 0.6, max = 2.2 },
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
	disable_fish_scaling = true,
})

SMODS.Atlas({
	key = "l_i_propal",
	path = "lexi_inky/propal_fisj.png",
	px = 71,
	py = 95,
})

local letters = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
}

local getRandWood = function()
	return pseudorandom_element(letters, "fac_l_i_wood")
end

local getRandPlastic = function()
	return pseudorandom_element(letters, "fac_l_i_plastic")
end

local letterIndex = {}
for k, v in pairs(letters) do
	letterIndex[v] = k - 1
end

FishAndChips.Fish({
	key = "l_i_wood",
	atlas = "l_i_propal",
	pos = { x = 0, y = 0 },
	weight = 7,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"rank",
		"mult",
	},
	environments = {
		wormhole = 1,
	},
	stats = {
		weight = { min = 0.005, max = 0.01 },
		length = { min = 0.003, max = 0.0055 },
	},
	cost = 4,
	config = {
		extra = {
			letter = "A",
			perm_mult = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.letter,
				card.ability.extra.perm_mult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if
				context.other_card:get_id() == 14
				or context.other_card:get_id() == 3
				or context.other_card:get_id() == 7
			then
				context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0)
					+ card.ability.extra.perm_mult
				local raWood = getRandWood()
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card.children.center:set_sprite_pos({ x = letterIndex[raWood], y = 0 })
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				card.ability.extra.letter = raWood
				return {
					message = localize("k_upgrade_ex"),
					colour = G.C.MULT,
				}
			end
		end
	end,
	disable_fish_scaling = true,
})

FishAndChips.Fish({
	key = "l_i_plastic",
	atlas = "l_i_propal",
	pos = { x = 0, y = 1 },
	weight = 7,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"rank",
		"score",
	},
	environments = {
		wormhole = 1,
	},
	stats = {
		weight = { min = 0.005, max = 0.01 },
		length = { min = 0.003, max = 0.0055 },
	},
	cost = 4,
	config = {
		extra = {
			letter = "A",
			score = 100,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.letter,
				card.ability.extra.score,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 4 or context.other_card:get_id() == 8 then
				local raPlastic = getRandPlastic()
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card.children.center:set_sprite_pos({ x = letterIndex[raPlastic], y = 1 })
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					func = function()
						card:flip()
						return true
					end,
				}))
				card.ability.extra.letter = raPlastic
				return {
					score = card.ability.extra.score,
				}
			end
		end
	end,
	disable_fish_scaling = true,
})

-- cat fish/fish bait

-- yhsifishy

SMODS.Sound({
	key = "l_i_87",
	path = "lexi_inky/87.ogg",
})

FishAndChips.Fish({
	key = "l_i_freddy",
	atlas = "l_i_fish",
	pos = { x = 3, y = 0 },
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
	stats = {
		weight = { min = 170, max = 187 },
		length = { min = 1.987, max = 2.3 },
	},
	cost = 4,
	config = {
		extra = {},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {},
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
	disable_fish_scaling = true,
})

-- kevin

local use_and_sell = G.UIDEF.use_and_sell_buttons
---@diagnostic disable-next-line: duplicate-set-field
function G.UIDEF.use_and_sell_buttons(card)
	local ret = use_and_sell(card)
	if card.config.center.key == "fish_fac_l_i_fof" then
		local sell = {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cr",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						one_press = true,
						button = "sell_card",
						func = "can_sell_card",
					},
					nodes = {
						{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
						{
							n = G.UIT.C,
							config = { align = "tm" },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm", maxw = 1.25 },
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_sell"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.4,
												shadow = true,
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = { align = "cm" },
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("$"),
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
												font = SMODS.Fonts["fac_sand_dollars"],
											},
										},
										{
											n = G.UIT.T,
											config = {
												ref_table = card,
												ref_value = "sell_cost_label",
												colour = G.C.WHITE,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
		local use = {
			n = G.UIT.C,
			config = { align = "cr" },
			nodes = {
				{
					n = G.UIT.C,
					config = {
						ref_table = card,
						align = "cm",
						padding = 0.1,
						r = 0.08,
						minw = 1.25,
						minh = 0.8,
						hover = true,
						shadow = true,
						colour = G.C.UI.BACKGROUND_INACTIVE,
						fac_ignore = true,
						button = "fac_use_fish",
						func = "fac_can_use_fish",
						handy_insta_action = "use",
					},
					nodes = {
						{ n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
						{
							n = G.UIT.C,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm", maxw = 1.25 },
									nodes = {
										{
											n = G.UIT.T,
											config = {
												text = localize("b_fac_l_i_eat"),
												colour = G.C.UI.TEXT_LIGHT,
												scale = 0.55,
												shadow = true,
											},
										},
									},
								},
							},
						},
					},
				},
			},
		}
		ret = {
			n = G.UIT.ROOT,
			config = { padding = 0, colour = G.C.CLEAR },
			nodes = {
				{
					n = G.UIT.C,
					config = { padding = 0.15, align = "cl" },
					nodes = {
						{ n = G.UIT.R, config = { align = "cl" }, nodes = {
							sell,
						} },
						{ n = G.UIT.R, config = { align = "cl" }, nodes = {
							use,
						} },
					},
				},
			},
		}
	end
	return ret
end

FishAndChips.Fish({
	key = "l_i_fof",
	atlas = "l_i_fish",
	pos = { x = 2, y = 0 },
	pixel_size = {
		h = 45,
		w = 53,
	},
	display_size = {
		h = 45 * 1.33,
		w = 53 * 1.33,
	},
	weight = 8,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"discards",
		"useable",
		"food",
	},
	environments = {
		soup = 1,
		city_river = 1,
	},
	stats = {
		weight = { min = 0.13, max = 0.15 },
		length = { min = 0.1, max = 0.2 },
	},
	cost = 3.79,
	config = {
		extra = {
			discards = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.discards,
			},
		}
	end,
	can_use = function(self, card)
		return G.GAME.blind and G.GAME.blind.in_blind
	end,
	use = function(self, card)
		ease_discard(card.ability.extra.discards)
	end,
	badge_key = "k_fac_l_i_burger",
	disable_fish_scaling = true,
})

SMODS.Sound({
	key = "l_i_music",
	path = "lexi_inky/music.ogg",
	sync = false,
})

SMODS.Sound({
	key = "music_l_i",
	path = "lexi_inky/music.ogg",
	sync = false,
	pitch = 1,
	select_music_track = function()
		return next(SMODS.find_card("fish_fac_l_i_fish_ost")) and 10000
	end,
})

FishAndChips.Fish({
	key = "l_i_fish_ost",
	atlas = "l_i_fish",
	pos = { x = 4, y = 0 },
	weight = 1,
	treasure = true,
	ppu_coder = {
		"lexi",
	},
	ppu_artist = {
		"inky",
	},
	attributes = {
		"passive",
		"xmult",
		"economy",
	},
	disable_fish_scaling = true,
	environments = {},
	stats = {
		weight = { min = 0.035, max = 0.055 },
		length = { min = 0.01, max = 0.015 },
	},
	cost = 10,
	config = {
		extra = {
			xmult = 4,
			dollars = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.dollars,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
				dollars = card.ability.extra.dollars,
			}
		end
	end,
	badge_key = "k_fac_l_i_music",
})

-- fishsocks
