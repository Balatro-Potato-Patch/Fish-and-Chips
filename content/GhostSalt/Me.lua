SMODS.Sound({
	key = "grrrrr",
	path = "GhostSalt/fac_grrrrr.ogg"
})

SMODS.Font({
	key = "shag",
	path = "shag.otf",
	FONTSCALE = 0.09,
	TEXT_HEIGHT_SCALE = 0.9
})

SMODS.Font({
	key = "stencil",
	path = "stencil.ttf",
	FONTSCALE = 0.09,
	TEXT_HEIGHT_SCALE = 0.9
})

SMODS.Atlas({
	key = "GhostSaltMeUwU",
	path = "GhostSalt/MeUwU.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "GhostSaltGant",
	path = "GhostSalt/stamps/gant.png",
	px = 101,
	py = 58,
})

SMODS.Atlas({
	key = "GhostSaltFutureLuke",
	path = "GhostSalt/stamps/future luke.png",
	px = 101,
	py = 58,
})

SMODS.Atlas({
	key = "GhostSaltKyle",
	path = "GhostSalt/stamps/kyle.png",
	px = 101,
	py = 58,
})

SMODS.Atlas({
	key = "GhostSaltMorshu",
	path = "GhostSalt/stamps/morshu.png",
	px = 101,
	py = 58,
})

SMODS.Atlas({
	key = "GhostSaltBFDI",
	path = "GhostSalt/stamps/bfdi.png",
	px = 101,
	py = 58,
})

SMODS.Atlas({
	key = "GhostSaltDS",
	path = "GhostSalt/stamps/ds.png",
	px = 101,
	py = 58,
})

SMODS.Atlas({
	key = "GhostSaltDaBlinkie",
	path = "GhostSalt/stamps/da blinkie.png",
	px = 152,
	py = 22,
})

SMODS.Atlas({
	key = "GhostSaltGlaggle",
	path = "GhostSalt/glaggle/Glaggle.png",
	px = 71,
	py = 71,
})

SMODS.Atlas({
	key = "GhostSaltGlagglePrisonBackground",
	path = "GhostSalt/glaggle/GlagglePrisonBackground.png",
	px = 186,
	py = 130,
})

SMODS.Atlas({
	key = "GhostSaltGlagglePrisonBars",
	path = "GhostSalt/glaggle/GlagglePrisonBars.png",
	px = 186,
	py = 130,
})

PotatoPatchUtils.Developer({
	name = "GhostSalt",
	atlas = "fac_GhostSaltMeUwU",
	colour = G.C.WHITE,
	loc = true,
	loc_vars = function(self)
		local prison_scale = 130 / 186
		local glaggle_scale = 71 / 186
		if not G.fac_ghostsalt_glaggle_max_sec_prison then
			G.fac_ghostsalt_glaggle_max_sec_prison = {
				SMODS.create_sprite(0, 0, 4, 4 * prison_scale, "fac_GhostSaltGlagglePrisonBackground", { x = 0, y = 0 }),
				SMODS.create_sprite(0, 0, 4 * glaggle_scale, 4 * glaggle_scale, "fac_GhostSaltGlaggle", { x = 0, y = 0 }),
				SMODS.create_sprite(0, 0, 4, 4 * prison_scale, "fac_GhostSaltGlagglePrisonBars", { x = 0, y = 0 }),
			}
			G.fac_ghostsalt_glaggle_max_sec_prison[2]:remove()
		end

		if not G.fac_ghostsalt_animated_stamps then
			local stamp_scale = 58 / 101
			local blinkie_scale = 22 / 152
			G.fac_ghostsalt_animated_stamps = {
				SMODS.create_sprite(0, 0, 2, 2 * stamp_scale, "fac_GhostSaltGant", { x = 0, y = 0 }),
				SMODS.create_sprite(0, 0, 2, 2 * stamp_scale, "fac_GhostSaltFutureLuke", { x = 0, y = 0 }),
				SMODS.create_sprite(0, 0, 2, 2 * stamp_scale, "fac_GhostSaltKyle", { x = 0, y = 0 }),
				SMODS.create_sprite(0, 0, 2, 2 * stamp_scale, "fac_GhostSaltMorshu", { x = 0, y = 0 }),
				SMODS.create_sprite(0, 0, 2, 2 * stamp_scale, "fac_GhostSaltBFDI", { x = 0, y = 0 }),
				SMODS.create_sprite(0, 0, 4, 4 * blinkie_scale, "fac_GhostSaltDaBlinkie", { x = 0, y = 0 }),
			}
			if not G.fac_ghostsalt_still_stamps then
				G.fac_ghostsalt_still_stamps = {
					SMODS.create_sprite(0, 0, 2, 2 * stamp_scale, "fac_GhostSaltDS", { x = 0, y = 0 })
				}
			end
		end

		if G.fac_ghostsalt_random_fish_area then
			G.fac_ghostsalt_random_fish_area:remove()
			G.fac_ghostsalt_random_fish_area = nil
			G.fac_ghostsalt_random_fish = nil
		end
		G.fac_ghostsalt_random_fish_area = CardArea(0, 0, 2, 2, { type = "title" })
		local candidates = {}
		for k, v in pairs(G.P_CENTERS) do
			if v.set == "fac_Fish" and v.ppu_artist and v.ppu_artist[1] == "GhostSalt" then
				candidates[#candidates + 1] = k
			end
		end
		G.fac_ghostsalt_random_fish = SMODS.add_card {
			area = G.fac_ghostsalt_random_fish_area,
			key = not next(candidates) and "fish_fac_ghostsalt_ghostfish" or candidates[math.random(#candidates)],
			skip_materialize = true
		}

		G.E_MANAGER:add_event(Event({
			func = function()
				G.fac_ghostsalt_random_fish.disable_align = true
				G.fac_ghostsalt_random_fish.bypass_discovery_center = true
				return true
			end
		}))

		local n = {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes =
			{
				{
					n = G.UIT.C,
					config = { align = "cm" },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm", colour = HEX("444444") },
							nodes = {
								{
									n = G.UIT.C,
									config = { align = "cm", padding = 0.1 },
									nodes = {
										{
											n = G.UIT.R,
											config = { align = "cm" },
											nodes = {
												{
													n = G.UIT.T,
													config = { align = "cm", text = localize("k_fac_ghostsalt_glaggle1"), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, font = SMODS.Fonts.fac_stencil }
												}
											}
										},
										{
											n = G.UIT.R,
											config = { align = "cm" },
											nodes = {
												{
													n = G.UIT.T,
													config = { align = "cm", text = localize("k_fac_ghostsalt_glaggle2"), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, font = SMODS.Fonts.fac_stencil }
												}
											}
										}
									}
								}
							}
						},
						{
							n = G.UIT.R,
							config = { align = "cm", padding = 1 },
							nodes = {
								{
									n = G.UIT.B,
									config = { w = 0.1, h = 1 }
								},
								{
									n = G.UIT.C,
									config = { align = "cm" },
									nodes = {
										{ n = G.UIT.R, config = { align = "cm", w = 4, h = 4 * prison_scale, padding = -4 * prison_scale }, nodes = { { n = G.UIT.O, config = { object = G.fac_ghostsalt_glaggle_max_sec_prison[1] } } } },
										{ n = G.UIT.R, config = { align = "cm", w = 4, h = 4 * prison_scale, padding = -4 * prison_scale }, nodes = { { n = G.UIT.O, config = { object = G.fac_ghostsalt_glaggle_max_sec_prison[2] } } } },
										{ n = G.UIT.R, config = { align = "cm", w = 4, h = 4 * prison_scale, padding = -4 * prison_scale }, nodes = { { n = G.UIT.O, config = { object = G.fac_ghostsalt_glaggle_max_sec_prison[3] } } } }
									}
								},
								{
									n = G.UIT.B,
									config = { w = 0.1, h = 1 }
								}
							}
						}
					}
				},
				{
					n = G.UIT.C,
					config = { align = "cm" },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{ n = G.UIT.O, config = { object = G.fac_ghostsalt_animated_stamps[1] } },
								{ n = G.UIT.O, config = { object = G.fac_ghostsalt_animated_stamps[2] } }
							}
						},
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{ n = G.UIT.O, config = { object = G.fac_ghostsalt_animated_stamps[3] } },
								{ n = G.UIT.O, config = { object = G.fac_ghostsalt_animated_stamps[4] } }
							}
						},
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{ n = G.UIT.O, config = { object = G.fac_ghostsalt_animated_stamps[5] } },
								{ n = G.UIT.O, config = { object = G.fac_ghostsalt_still_stamps[1] } }
							}
						},
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{ n = G.UIT.O, config = { object = G.fac_ghostsalt_animated_stamps[6] } }
							}
						}
					}
				},
				{
					n = G.UIT.C,
					config = { align = "cm" },
					nodes = {
						{ n = G.UIT.O, config = { object = G.fac_ghostsalt_random_fish_area } }
					}
				}
			}
		}
		return { vars = { elements = { n } }, font = SMODS.Fonts.fac_shag }
	end,
	click = function(self)
		self:juice_up(3, 1)
		play_sound("fac_grrrrr")
	end
})

G.fac_ghostsalt_stamp_anims = {
	{
		frames = 46,
		delays = {
			0.66,
			0.33,
			0.25,
			0.25,
			0.25,
			0.25,
			0.25,
			0.25,
			0.25,
			0.25,
			0.25,
			0.25,
			0.25,
			0.58,
			0.33,
			0.25,
			0.33,
			0.5,
			1.41,
			0.2,
			0.06,
			0.06,
			0.06,
			0.91,
			0.33,
			0.5,
			1.91,
			0.16,
			0.05,
			0.05,
			0.05,
			0.05,
			0.05,
			0.05,
			0.05,
			0.41,
			0.33,
			0.2,
			0.2,
			0.2,
			0.5,
			0.2,
			0.2,
			0.2,
			0.16,
			1.08
		}
	},
	{
		frames = 31,
		delay = 0.1
	},
	{
		frames = 3,
		delay = 0.15
	},
	{
		frames = 78,
		delay = 0.1,
		pause = 1
	},
	{
		frames = 25,
		delay = 0.04
	},
	{
		frames = 26,
		delay = 0.1
	}
}

function fac_ghostsalt_animate_fish(time)
	local t = (time / .6) % 2
	if t < 0.8 then
		return -.25
	elseif t < 1 then
		return ((t - 0.8) * 5 * .5) - .25
	elseif t < 1.8 then
		return .25
	else
		return ((1 - ((t - 1.8) * 5)) * .5) - .25
	end
end

function fac_ghostsalt_ease_in_out(t)
	if t > 1 then return 1 - fac_ghostsalt_ease_in_out(t - 1) end
	return (math.cos(t * math.pi) / -2) + 0.5
end

function fac_ghostsalt_glaggle_anim()
	local x = (fac_ghostsalt_ease_in_out((os.clock() / (0.5 / 2)) % 2) * 2) - 1
	local y = (fac_ghostsalt_ease_in_out((os.clock() / (0.332198765 / 2)) % 2) * 2) - 1
	G.fac_ghostsalt_glaggle_max_sec_prison[2].VT.x = G.fac_ghostsalt_glaggle_pos.x + (x * 0.75)
	G.fac_ghostsalt_glaggle_max_sec_prison[2].VT.y = G.fac_ghostsalt_glaggle_pos.y + (y * 0.5)
end

local update_ref = Game.update
function Game:update(dt)
	if G.fac_ghostsalt_animated_stamps then
		if not G.OVERLAY_MENU then
			G.fac_ghostsalt_glaggle_pos = nil
			if G.fac_ghostsalt_random_fish_area then
				G.fac_ghostsalt_random_fish_area:remove()
				G.fac_ghostsalt_random_fish_area = nil
				G.fac_ghostsalt_random_fish = nil
			end
			for _, v in ipairs(G.fac_ghostsalt_animated_stamps) do
				v:remove()
			end
			G.fac_ghostsalt_animated_stamps = nil
		else
			if G.fac_ghostsalt_glaggle_max_sec_prison and G.fac_ghostsalt_glaggle_max_sec_prison[2] then
				if not G.fac_ghostsalt_glaggle_pos then
					G.fac_ghostsalt_glaggle_pos = { x = G.fac_ghostsalt_glaggle_max_sec_prison[2].VT.x, y = G.fac_ghostsalt_glaggle_max_sec_prison[2].VT.y }
				end
				fac_ghostsalt_glaggle_anim()
			end
			for i = 1, #G.fac_ghostsalt_animated_stamps do
				fac_ghostsalt_animate_stamp(G.fac_ghostsalt_animated_stamps[i], G.fac_ghostsalt_stamp_anims[i], dt)
			end
		end
	end

	if G.fac_ghostsalt_random_fish then
		G.fac_ghostsalt_random_fish.T.r = fac_ghostsalt_animate_fish(G.TIMERS.REAL)
	end

	return update_ref(self, dt)
end

function fac_ghostsalt_animate_stamp(v, anim, dt)
	if not anim.length then
		if anim.delay then
			anim.length = (anim.delay * anim.frames) + (anim.pause or 0)
		else
			for _, frame in ipairs(anim.delays) do
				anim.length = (anim.length or 0) + frame
			end
		end
	end
	if not v.fac_ghostsalt_anim_t then v.fac_ghostsalt_anim_t = 0 end
	v.fac_ghostsalt_anim_t = v.fac_ghostsalt_anim_t + dt
	v.fac_ghostsalt_anim_t = v.fac_ghostsalt_anim_t % anim.length
	local ix = 0
	local t_tally = 0
	for i = 1, anim.frames do
		t_tally = t_tally + (anim.delays and anim.delays[i] or anim.delay) + (i == anim.frames and anim.pause or 0)
		if t_tally > v.fac_ghostsalt_anim_t then break end
		ix = ix + 1
	end
	v:set_sprite_pos({ x = ix, y = 0 })
end
