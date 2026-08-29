FishAndChips.Fish({
	key = "codamite",
	weight = 8,
	environments = {
		pier = 0.2,
		backroom = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"boss_blind",
		"usable",
		"xblindsize",
	},
	blueprint_compat = false,
	eternal_compat = false,
	atlas = "hayayaya_fih",
	pos = { x = 1, y = 0 },
	stats = {
		length = { min = 0.5, max = 1.3 },
		weight = { min = 0.8, max = 2.5 },
	},
	can_use = function(self, card)
		return G.STATE == G.STATES.SELECTING_HAND
	end,
	use = function(self, card)
		delay(0.5)

		card:highlight(false)

		-- If this is bigger than 0.5 then fuck you
		local gambling = pseudorandom("hayayaya_explosion_chance_" .. G.GAME.round_resets.ante, 0, 1) > 0.5

		G.E_MANAGER:add_event(Event({
			func = function()
				card.children.hayayaya_explosion = SMODS.create_sprite(
					card.T.x,
					card.T.y,
					card.T.w * 2.5,
					card.T.h * 2.65,
					"fac_hayayaya_explosion",
					{ x = 0, y = 0 }
				)
				card.children.hayayaya_explosion.role.role_type = "Minor"
				card.children.hayayaya_explosion.role.major = card.children.center
				card.children.hayayaya_explosion.role.offset =
					{ x = -card.children.hayayaya_explosion.T.w / 4, y = -card.children.hayayaya_explosion.T.h / 4 }
				card.children.hayayaya_explosion.hayayaya_explosion = true
				SMODS.mod_blind_size({ mult = gambling and 2 or 0.5, card = G.GAME.blind, effect = {} })
				play_sound("fac_hayayaya_explosion")
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.2,
			func = function()
				card.children.center.states.visible = false
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.5,
			func = function()
				-- I'm sure this won't have consequences!
				card:remove()
				return true
			end,
		}))

		-- delay(0.5)
	end,
})

local animate = AnimatedSprite.animate
---@diagnostic disable-next-line
function AnimatedSprite:animate()
	local frame_finished = (math.floor((G.TIMERS.REAL - self.offset_seconds) / self.current_animation.frame_duration))
		> 0
	animate(self)
	if frame_finished and self.current_animation.current >= 17 and self.hayayaya_explosion then
		self:remove()
	end
end
