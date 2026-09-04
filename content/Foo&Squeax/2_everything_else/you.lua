FishAndChips.Fish{
	key = "fas_you",
	weight = 5,
	environments = {
		styx = 1,
		backroom = 0.25,
		swamp = 0.5
	},
	badge_key = "k_fac_fas_frog",
	ppu_coder = {"Foo54"},
	ppu_artist = {"squeax09"},
	atlas = "fas_fish_general",
	pos = {x=2,y=1},
	pixel_size = {w=56,h=94},
	stats = {
		weight = {min = 2, max = 2},
		length = {min = 1, max = 1}
	},
	config = {
		immutable = {
			primed = false,
			used = false
		}
	},
	attributes = {"usable", "deltarune", "utdr", "editions",},
	blueprint_compat = false,
	calculate = function(self, card, context)
		if context.fac_fish_caught and not context.blueprint and not context.retrigger_joker then
			if card.ability.immutable.primed then
				context.fac_fish_caught:set_edition(SMODS.poll_edition{no_negative = true, guaranteed = true})
				card.ability.immutable.primed = false
				card.ability.immutable.used = true
			end
		end
		if context.ante_end and not context.blueprint and not context.retrigger_joker then
			card.ability.immutable.used = false
		end
	end,
	can_use = function (self, card)
		return not card.ability.immutable.used
	end,
	keep_on_use = function (self, card)
		return true
	end,
	use = function(self, card)
		card.ability.immutable.primed = not card.ability.immutable.primed
		juice_card_until(card, function() return not card.ability.immutable.used and card.ability.immutable.primed end, true)
	end,
}
