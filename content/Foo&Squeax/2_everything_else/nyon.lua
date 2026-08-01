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

FishAndChips.Fish{
	key = "fas_kawkaw",
	weight = 5,
	environments = {
		calm_pond = 1,
		garden = 0.75
	},
	ppu_coder = {"Foo54"},
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
	attributes = {"xmult"},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.xmult, card.ability.extra.call, pseudorandom_element({"Nyon!", "Ueueleuleuleue"}), card.ability.immutable.timer}}
	end,
	update = function (self, card, dt)
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
					card_eval_status_text(card, "extra", nil, nil, nil, {instant = true, message = localize("k_fac_fas_nyon")})
				play_sound("fac_fas_nyon")
			end
		end
	end,
}

local card_click_ref = Card.click
---@diagnostic disable-next-line: duplicate-set-field
function Card:click()
	card_click_ref(self)
	if self.config.center.key == "fish_fac_fas_kawkaw" then
		if self.ability.immutable.timer >= 100 then
			self.ability.immutable.slow = true
					card_eval_status_text(self, "extra", nil, nil, nil, {instant = true, message = localize("k_fac_fas_ule")})
			play_sound("fac_fas_ule")
		else
			self.ability.immutable.timer = self.ability.immutable.timer + self.ability.immutable.gain
					card_eval_status_text(self, "extra", nil, nil, nil, {instant = true, message = localize("k_fac_fas_nyon")})
			play_sound("fac_fas_nyon")
		end
	end
end

local card_remove_ref = Card.remove
---@diagnostic disable-next-line: duplicate-set-field
function Card:remove()
	card_remove_ref(self)
---@diagnostic disable-next-line: undefined-field
	if self.config.center.key == "fish_fac_fas_kawkaw" and not self.dont_nyon then
		play_sound("fac_fas_nyon!")
	end
end