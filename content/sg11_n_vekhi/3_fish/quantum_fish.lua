SMODS.Sound({
	key = "quantum_fish_photo_shot",
	path = "sg11_n_vekhi/photo_shot.ogg",
})

local center = FishAndChips.Fish({
	key = "sg11_n_vekhi_quantum_fish",
	atlas = "fish",
	pos = { x = 0, y = 0 },
	ppu_coder = { "sleepyg11" },
	ppu_artist = { "vevekhi" },
	attributes = { "xmult" },
	config = {
		extra = {
			xmult = 3,
		},
	},
	weight = 3,
	environments = {},
	loc_vars = function(self, info_queue, card)
		return {
			vars = { card.ability.extra.xmult },
			key = card.ability.extra.wild and (self.key .. "_wild") or nil,
		}
	end,
	set_sprites = function(self, card) end,
	calculate = function(self, card, context)
		if context.before then
			EMPTY(FishAndChips.QuantumFish.cards_to_score)
			local possible_cards = {}
			for _, c in ipairs(SMODS.get_card_areas("playing_cards")) do
				for _, cc in ipairs(c.cards) do
					table.insert(possible_cards, cc)
				end
			end
			for _, c in ipairs(SMODS.get_card_areas("jokers")) do
				if c.area ~= G.vouchers and c.area ~= G.discard then
					for _, cc in ipairs(c.cards) do
						table.insert(possible_cards, cc)
					end
				end
			end
			local winner = pseudorandom_element(possible_cards, "pac_quantum_fish")
			if winner then
				FishAndChips.QuantumFish.cards_to_score[winner] = card
			end
		end
		if
			context.individual
			and (context.cardarea == G.play or context.cardarea == G.hand)
			and FishAndChips.QuantumFish.cards_to_score[context.other_card] == card
		then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
		if context.other_main and FishAndChips.QuantumFish.cards_to_score[context.other_main] == card then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})

local function start_quantum_fish_sequence(card)
	card.ability.extra.wild = true
	local text_box
	local function display_quantum_text(text)
		if text_box then
			text_box:remove()
		end
		text_box = UIBox({
			definition = {
				n = G.UIT.ROOT,
				config = { emboss = 0.1, r = 0.2, padding = 0.2 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm" },
						nodes = {
							{
								n = G.UIT.T,
								config = {
									text = text,
									scale = 0.5,
									colour = G.C.UI.TEXT_LIGHT,
								},
							},
						},
					},
				},
			},
			config = {
				align = "bm",
				major = card,
				r_bond = "Weak",
				offset = { x = 0, y = 0.1 },
			},
		})
		text_box:juice_up(0.15)
		play_sound("generic1")
	end

	card.ability.extra.wild = true
	G.E_MANAGER:add_event(Event({
		func = function()
			card.children.center:set_sprite_pos({ x = 1, y = 0 })
			card:start_materialize(nil, true, 4)
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1.5,
		timer = "REAL",
		func = function()
			display_quantum_text(localize("pac_quantum_fish_1"))
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1.5,
		timer = "REAL",
		func = function()
			display_quantum_text(localize("pac_quantum_fish_2"))
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 2,
		timer = "REAL",
		func = function()
			display_quantum_text(localize("pac_quantum_fish_3"))
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 3,
		func = function()
			play_sound("fac_quantum_fish_photo_shot")
			attention_text({
				major = card,
				align = "cm",
				colour = G.C.WHITE,
				scale = 0,
				hold = 2,
				text = "",
				backdrop_colour = G.C.WHITE,
				backdrop_scale = 4,
			})
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1.25,
		func = function()
			card.ability.extra.wild = nil
			card.children.center:set_sprite_pos({ x = 0, y = 0 })
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 1.25,
		func = function()
			text_box:remove()
			local old_materialize = card.start_materialize
			function card:start_materialize(...)
				self.start_materialize = old_materialize
			end
			return true
		end,
	}))
end

FishAndChips.QuantumFish = {
	cards_to_score = {},
	center = center,
	calculate = function(context)
		if context.fac_fish_caught then
			if context.fac_fish_caught.config.center == center then
				start_quantum_fish_sequence(context.fac_fish_caught)
			end
		end
	end,
}
