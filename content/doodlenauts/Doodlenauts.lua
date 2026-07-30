PotatoPatchUtils.Developer({
	name = 'F404',
	atlas = 'DoodlenautsAvatar',
    pos = {x = 0, y = 0},
	colour = HEX('ff00ff'),
	fac_partner = 'Buckaroodle' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'Buckaroodle',
	atlas = 'DoodlenautsAvatar',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'F404'
})

SMODS.Atlas({
	key = "DoodlenautsFish", 
	path = "Doodlenauts/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "DoodlenautsAvatar", 
	path = "Doodlenauts/avatars.png",
	px = 71,
	py = 95,
})

-- Bottom Feeder
FishAndChips.Fish {
	key = 'bottomfeeder',
	atlas = 'fac_placeholders',
	pos = { x = 0, y = 0 },
	weight = 10, --this will be updated when more fish are added
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'chips', 'rank' },
	config = {
		extra = {
			chips = 0,
			chip_gain = 1,
			--ranks = { 2 , 3 }
		}
	},
	environments = {
		calm_pond = 0.4,
		pier = 0.4,
		swamp = 0.2,
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.chip_gain,
				--card.ability.extra.ranks
			}
		}
	end,
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local scoring_ranks = { 2 , 3 , 4 , 5 }
			local triggered = false
			for i, rank in ipairs(scoring_ranks) do
				if context.other_card:get_id() == scoring_ranks[i] then
					card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
					triggered = true
					break
				end
			end
			if triggered then
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.CHIPS,
					message_card = card
            	}
			end
		end
		if context.joker_main then
			return {
				chips = card.ability.extra.chips
			}
		end
	end
}

FishAndChips.Fish {
	key = 'bigbasswheel',
	atlas = 'fac_placeholders',
	pos = { x = 0, y = 0 },
	weight = 10, --this will be updated when more fish are added
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'usable' },
	config = {
		extra = {
			num = 1,
			denom = 3,
		}
	},
	environments = {
		calm_pond = 0.6,
		garden = 0.4
	},
	loc_vars = function(self, info_queue, card)
		local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.denom, 'fac_bigbasswheel')
		return {
			vars = {
				numerator,
				denominator
			}
		}
	end,
	use = function(self, card, area)
		if SMODS.pseudorandom_probability(card, 'fac_bigbasswheel', card.ability.extra.num, card.ability.extra.denom) then
			local eligible_fish = {}
			for i, fish in ipairs(G.fac_fish_area.cards) do
				if not fish.edition and fish ~= card then
					eligible_fish[#eligible_fish+1] = fish
				end
			end
			--local editionless_fish = SMODS.Edition:get_edition_cards(G.fac_fish_area, true)
			local selected_fish = pseudorandom_element(eligible_fish, 'fac_bigbasswheel')
			local edition = SMODS.poll_edition { key = 'fac_bigbasswheel', guaranteed = true, no_negative = true, options = { 'e_foil', 'e_holo' } }
			selected_fish:set_edition(edition, true)
		else
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        silent = true
                    })
                    play_sound('fac_line_snap', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
		end
	end,
	can_use = function(self, card)
        --return next(SMODS.Edition:get_edition_cards(G.fac_fish_area, true))
		for i, fish in ipairs(G.fac_fish_area.cards) do
			if not fish.edition and fish ~= card then
				return true
			end
		end
    end
}

FishAndChips.Fish {
	key = 'britishflag',
	atlas = 'DoodlenautsFish',
	pos = { x = 2, y = 0 },
	weight = 10, --this will be updated when more fish are added
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'chips' },
	config = {
		extra = {
			chips_per_fish = 20,
		}
	},
	environments = {
		city_river = 0.5,
		wormhole = 0.25,
		pier = 0.25
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_per_fish,
				card.ability.extra.chips_per_fish * (G.fac_fish_area and #G.fac_fish_area.cards or 0)
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips_per_fish * #G.fac_fish_area.cards
			}
		end
	end
}

FishAndChips.Fish {
	key = 'bullfrog',
	atlas = 'fac_placeholders',
	pos = { x = 0, y = 0 },
	weight = 10, --this will be updated when more fish are added
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'chips' },
	config = {
		extra = {
			chips_per_sanddollar = 8,
		}
	},
	environments = {
		swamp = 0.5,
		calm_pond = 0.3,
		garden = 0.2
	},
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips_per_sanddollar,
				card.ability.extra.chips_per_sanddollar * (G.GAME.fac_sand_dollars or 0)
			}
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chips = card.ability.extra.chips_per_sanddollar * (G.GAME.fac_sand_dollars or 0)
			}
		end
	end
}

FishAndChips.Fish {
	key = 'catfish',
	atlas = 'DoodlenautsFish',
	pos = { x = 1, y = 0 },
	weight = 10, --this will be updated when more fish are added
	ppu_coder = { 'Buckaroodle'},
	ppu_artist = { 'F404' },
	attributes = { 'passive' },
	environments = {
		calm_pond = 0.7,
		pier = 0.3
	},
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
    end,
}
