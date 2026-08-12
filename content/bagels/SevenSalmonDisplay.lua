SMODS.Atlas {
	key = 'bagels_seven_salmon_display',
	path = 'bagels/seven_salmon_display.png',
	px = 71,
	py = 143,
}

local function disp(self, card)
	card.children.center = SMODS.create_sprite(
		card.T.x,
		card.T.y,
		card.T.w,
		card.T.h,
		self.atlas,
		{ x = ((((card or {}).ability or {}).extra or {}).cards or 5) - 1, y = 0 }
	)

	card.children.center.states.hover = card.states.hover
	card.children.center.states.click = card.states.click
	card.children.center.states.drag = card.states.drag
	card.children.center.states.collide.can = false
	card.children.center:set_role { major = card, role_type = 'Glued', draw_major = card }
end

FishAndChips.Fish {
	key = 'bagels_seven_salmon_display',
	atlas = 'bagels_seven_salmon_display',
	ppu_coder = { 'BakersDozenBagels', 'Emik' },
	ppu_artist = { 'BakersDozenBagels' },
	weight = 10,
	environments = { garden = 1, calm_pond = 1, chocolate_river = 0.7 },
	stats = { weight = { min = 218, max = 427 }, length = { min = 5.2, max = 10.5 } },
	attributes = { 'xmult' },
	config = { extra = { xmult = 3, cards = 5 } },
	loc_vars = function(_, _, card)
		return {
			vars = {
				card.ability.extra.xmult,
				card.ability.extra.cards,
				card.ability.extra.cards == 1 and '' or 's',
			},
		}
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff then
			card.ability.extra.cards = pseudorandom('fac_fish_bagels_seven_salmon_display', 1, 5)
		end
		disp(self, card)
	end,
	calculate = function(self, card, context)
		if context.end_of_round and not context.repetition and not context.individual then
			card.ability.extra.cards = pseudorandom('fac_fish_bagels_seven_salmon_display', 1, 5)
			G.E_MANAGER:add_event(Event {
				func = function()
					disp(self, card)
					return true
				end,
			})
			return { message = localize 'k_reset', colour = G.C.RED, message_card = card }
		end

		if context.joker_main and #context.scoring_hand == card.ability.extra.cards then
			return {
				x_mult = card.ability.extra.xmult,
			}
		end
	end,
	set_sprites = disp,
}

if Balatest then
	-- No time lmao
end
