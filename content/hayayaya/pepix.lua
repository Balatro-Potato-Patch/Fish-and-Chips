FishAndChips.Fish({
	key = "codamite",
	weight = 10,
	environments = {
		pier = 0.2,
		backroom = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"boss_blind",
		"usable",
	},
	atlas = "hayayaya_fih",
	pos = { x = 1, y = 0 },
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

		delay(0.5)
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

FishAndChips.Fish({
	key = "anglrifle",
	weight = 10,
	environments = {
		chocolate_river = 0.5,
		styx = 1,
	},
	ppu_coder = { "Ellen (Haya)" },
	ppu_artist = { "Pepix" },
	attributes = {
		"destroy_card",
		"discard",
		"scaling",
		"chips",
	},
	config = { extra = { chips = 0, chips_add = 5, done = false, discard_flush = false } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_add,
				card.ability.extra.chips,
				card.ability.extra.done and localize("ph_facyou_hayayaya_active")
					or localize("ph_facyou_hayayaya_inactive"),
			},
		}
	end,
	calculate = function(self, card, context)
		if context.pre_discard and not card.ability.extra.done then
			G.E_MANAGER:add_event(Event({
				func = function()
					card.ability.extra.done = true
					return true
				end,
			}))
		end

		-- TODO: Make each card disappear one by one?
		if context.discard and not card.ability.extra.done then
			SMODS.destroy_cards(context.other_card, {
				immediate = true,
				destroy_func = function(destroy_card, args)
					if destroy_card.shattered then
						destroy_card:shatter()
					else
						destroy_card:start_dissolve()
					end
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_add
					SMODS.calculate_effect({ message = "Upgrade!" }, card)
				end,
			})
		end

		-- Genuinely, for some reason they still exist in the discard pile
		-- We already know the actual moveable is deleted now, so just clear the table manually
		if context.hand_drawn and card.ability.extra.done and not card.ability.extra.discard_flush then
			G.E_MANAGER:add_event(Event({
				func = function()
					G.discard.cards = {}
					print("rid discard pile")
					card.ability.extra.done = true
					return true
				end,
			}))
			card.ability.extra.discard_flush = true
		end

		if context.end_of_round and context.main_eval then
			card.ability.extra.done = false
			card.ability.extra.discard_flush = false
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
			}
		end
	end,
})
