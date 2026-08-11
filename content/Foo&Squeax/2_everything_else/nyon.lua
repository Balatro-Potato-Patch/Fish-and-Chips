SMODS.Sound{
	key = "fas_nyon",
	path = FishAndChips.FooSqueax.file_path .. "nyon.ogg"
}
SMODS.Sound{
	key = "fas_nyom",
	path = FishAndChips.FooSqueax.file_path .. "nyom.ogg"
}
SMODS.Sound{
	key = "fas_ule",
	path = FishAndChips.FooSqueax.file_path .. "ule.ogg"
}
SMODS.Sound{
	key = "fas_nyoom",
	path = FishAndChips.FooSqueax.file_path .. "nyoom.ogg"
}
SMODS.Sound{
	key = "fas_nyon!",
	path = FishAndChips.FooSqueax.file_path .. "nyon!.ogg"
}

SMODS.Atlas{
	key = "fas_nyon",
	path = FishAndChips.FooSqueax.file_path .. "blubblub.png",
	px = 71,
	py = 95
}

FishAndChips.Fish{
	key = "fas_kawkaw",
	weight = 5,
	environments = {
		calm_pond = 1, -- WHY is it not garden above it's liek the field of flowersssssss </3
		garden = 0.75
	},
	atlas = "fas_nyon",
	badge_key = "k_fac_fas_nyon_label",
	ppu_artist = {"squeax09"},
	ppu_coder = {"Foo54"},
	disable_visual_scaling = true,
	config = {
		extra = {
			xmult = 4,
			rounds = 3
		},
		immutable = {
			gain = 10,
			timer = 20,
			slow = false,
		}
	},
	stats = {
		length = {min = 5, max = 5},
		weight = {min = 5, max = 5}
	},
	attributes = {"xmult", "deltarune", "utdr"},
	flavour_vars = function(self, info_queue, card)
		return {vars = {nil, nil, pseudorandom_element({"Nyon!", "Ueueleuleuleue"})}}
	end,
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.xmult, card.ability.extra.call, nil, card.ability.immutable.timer}}
	end,
	update = function (self, card, dt)
		if card.REMOVED then return end
		if not G.SETTINGS.paused then
			if card.area and not card.area.config.collection then
				if card.ability.immutable.slow then
					local limit = 300 * G.real_dt
					local px, py = G.CONTROLLER.cursor_position.x, G.CONTROLLER.cursor_position.y
					local x, y = love.mouse.getPosition()
					local dx, dy = x - px, y - py
					if math.abs(dx) > limit then
						dx = math.max(-limit, math.min(limit, dx))
						love.mouse.setX(px + dx)
					end
					if math.abs(dy) > limit then
						dy = math.max(-limit, math.min(limit, dy))
						love.mouse.setY(py + dy)
					end
				else
					card.ability.immutable.timer = card.ability.immutable.timer - G.real_dt
					if card.ability.immutable.timer < 0 then
						card.ability.immutable.timer = 100000
						card_eval_status_text(card, "extra", nil, nil, nil, {instant = true, message = localize("k_fac_fas_nyom")})
						card.dont_nyon = true
						play_sound("fac_fas_nyoom")
						card.children.center:set_sprite_pos{x = 2, y = 0}
						delay(2)
						SMODS.destroy_cards(card)
					end
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
				func = function()
					G.E_MANAGER:add_event(Event{
						func = function ()
							card.children.center:set_sprite_pos{x = 1, y = 0}
							delay(2)
							G.E_MANAGER:add_event(Event{
								blocking = false,
								func = function()
									card.children.center:set_sprite_pos{x = 0, y = 0}
									return true
								end
							})
							play_sound("fac_fas_nyon")
							return true
						end
					})
					return true
				end
			}
		end
		if context.end_of_round and context.main_eval and not context.blueprint and card.ability.immutable.slow then
			card.ability.extra.rounds = card.ability.extra.rounds - 1
			if card.ability.extra.rounds == 0 then
				card.ability.extra.rounds = 3
				card.ability.immutable.slow = false
				FishAndChips.FooSqueax.nyon.unsticky()
				card_eval_status_text(card, "extra", nil, nil, nil, {instant = true, message = localize("k_fac_fas_nyon")})
				play_sound("fac_fas_nyon")
				card.children.center:set_sprite_pos{x = 1, y = 0}
				delay(2)
				G.E_MANAGER:add_event(Event{
					blocking = false,
					func = function()
						card.children.center:set_sprite_pos{x = 0, y = 0}
						return true
					end
				})
			end
		end
	end,
	load = function (self, card, card_table, other_card)
		if card_table.ability.immutable.slow then
			FishAndChips.FooSqueax.nyon.sticky()
		end
	end,
	remove_from_deck = function (self, card, from_debuff)
		if not from_debuff then
			if card.ability.immutable.slow then
				FishAndChips.FooSqueax.nyon.unsticky()
			end
		end
	end
}

SMODS.Atlas{
	key = "fas_sticky",
	path = FishAndChips.FooSqueax.file_path .. "sticky.png",
	px = 50,
	py = 74
}

function FishAndChips.FooSqueax.nyon.sticky()
	if not G.fac_fas_nyon then
		G.fac_fas_nyon = UIBox{
			definition = {n = G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes = {
				{n = G.UIT.O, config = {object = SMODS.create_sprite(0, 0, 1, 1 / 50 * 74, "fac_fas_sticky")}}
			}},
			config = {
				major = G.CURSOR,
				align = "cmi",
				offset = {
					x = -G.ROOM.T.x,
					y = -G.ROOM.T.y
				},
				instance_type = "DROPDOWN"
			}
		}
		G.fac_fas_nyon.states.collide.can = false
	end
end

function FishAndChips.FooSqueax.nyon.unsticky()
	G.GAME.fac_FooSqueax.nyon = G.GAME.fac_FooSqueax.nyon - 1
	if G.GAME.fac_FooSqueax.nyon <= 0 then
		G.GAME.fac_FooSqueax.nyon = 0
		if G.fac_fas_nyon then
			G.fac_fas_nyon:remove()
			G.fac_fas_nyon = nil
		end
	end
end

local card_click_ref = Card.click
---@diagnostic disable-next-line: duplicate-set-field
function Card:click()
	card_click_ref(self)
	if self.config.center.key == "fish_fac_fas_kawkaw" then
		if self.ability.immutable.timer >= 100 then
			if not self.area.config.collection and not self.ability.immutable.slow then
				G.GAME.fac_FooSqueax.nyon = G.GAME.fac_FooSqueax.nyon + 1
				FishAndChips.FooSqueax.nyon.sticky()
			end
			self.ability.immutable.slow = true
			card_eval_status_text(self, "extra", nil, nil, nil, {instant = true, message = localize("k_fac_fas_ule")})
			play_sound("fac_fas_ule")
			self.children.center:set_sprite_pos{x = 0, y = 1}
			delay(0.1)
			local counter
			local start
			local frame = 1
			G.E_MANAGER:add_event(Event{
				blocking = false,
				func = function()
					if not counter then counter = G.TIMERS.REAL end
					if not start then start = G.TIMERS.REAL end
					if G.TIMERS.REAL - counter >= 1/15 then
						frame = (frame) % 3 + 1
						self.children.center:set_sprite_pos{x = frame, y = 1}
						counter = G.TIMERS.REAL
						if G.TIMERS.REAL - start >= 0.5 then
							self.children.center:set_sprite_pos{x = 0, y = 0}
							return true
						end
					end
				end
			})
		else
			self.ability.immutable.timer = self.ability.immutable.timer + self.ability.immutable.gain
			card_eval_status_text(self, "extra", nil, nil, nil, {instant = true, message = localize("k_fac_fas_nyon")})
			play_sound("fac_fas_nyon")
			self.children.center:set_sprite_pos{x = 1, y = 0}
			delay(0.2)
			G.E_MANAGER:add_event(Event{
				blocking = false,
				func = function()
					self.children.center:set_sprite_pos{x = 0, y = 0}
					return true
				end
			})
		end
	end
end

local card_start_dissolve_ref = Card.start_dissolve
---@diagnostic disable-next-line: duplicate-set-field
function Card:start_dissolve(...)
	if self.config.center.key == "fish_fac_fas_kawkaw" and not self.dont_nyon then
		self.dissolve_params = {...}
		self:remove()
	else
		card_start_dissolve_ref(self, ...)
	end
end


local card_remove_ref = Card.remove
---@diagnostic disable-next-line: duplicate-set-field
function Card:remove()
---@diagnostic disable-next-line: undefined-field
	if self.config.center.key == "fish_fac_fas_kawkaw" and not self.dont_nyon then
		if (self.area and self.area.config.collection) or not self.area then
			self.dont_nyon = true
			self:remove()
			return
		end
		self.REMOVED = true
		play_sound("fac_fas_nyon!")
		self.children.center:set_sprite_pos{x = 4, y = 1}
		delay(3)
		G.E_MANAGER:add_event(Event{
			blocking = false,
			func = function()
				self.dont_nyon = true
				if self.dissolve_params then
					self:start_dissolve(self.dissolve_params[1], self.dissolve_params[2], self.dissolve_params[3], self.dissolve_params[4])
				else
					self:remove()
				end
				return true
			end
		})
	else
		card_remove_ref(self)
	end
end