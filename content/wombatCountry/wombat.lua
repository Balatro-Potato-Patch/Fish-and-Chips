SMODS.Atlas {
	key = "fac_wombat",
	path = "wombatCountry/wombat.png",
	px = 71,
	py = 95
}

PotatoPatchUtils.Developer({
	name = 'wombatCountry',
	atlas = 'fac_wombat',
	colour = HEX('8AFFBE')
})

SMODS.Atlas({
	key = "wombatCountry_fish",
	path = "wombatCountry/fish.png",
	px = 71,
	py = 95,
})

--the dorphish
FishAndChips.Fish({
    key = "wombatCountry_dorphish",
	weight = 10,
	atlas = "wombatCountry_fish",
	pos = { x = 0, y = 0 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "usable", "economy" },
	environments = {
		backroom = 1,
		styx = 0.25,
        soup = 0.25,
	},
	stats = {
		weight = {min = 6.3, max = 9.9},
		length = {min = 0.5, max = 1.25}
	},
	config = {
		extra = {
			dollar_min = 1,
            dollar_max = 10
		}
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.dollar_min, card.ability.extra.dollar_max } }
	end,
	use = function(self, card)
        local payout = pseudorandom('dorphish', card.ability.extra.dollar_min, card.ability.extra.dollar_max)
		ease_sand_dollars(payout)
	end,
	can_use = function(self, card)
		return true
	end
})

--spunched bob
FishAndChips.Fish({
    key = "wombatCountry_spunch",
	weight = 10,
	atlas = "wombatCountry_fish",
	pos = { x = 2, y = 0 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "usable", "suit" },
	environments = {
		calm_pond = 1,
		city_river = 0.25,
	},
	stats = {
		weight = {min = 0.014, max = 0.028},
		length = {min = 0.105, max = 0.12}
	},
	config = {
		extra = {
			dollar_min = 1,
            dollar_max = 10
		}
	},
	blueprint_compat = false,
	use = function(self, card)
		local suit
        for _, playing_card in ipairs(G.deck.cards) do
			suit = pseudorandom_element(SMODS.Suits)

			SMODS.change_base(playing_card, suit.key)
		end
		play_sound('timpani')
	end,
	can_use = function(self, card)
		return true
	end
})

--sardine boys
FishAndChips.Fish({
    key = "wombatCountry_sardine",
	weight = 10,
	atlas = "wombatCountry_fish",
	pos = { x = 3, y = 0 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "usable", "rank" },
	environments = {
		pier = 1,
		city_river = 0.5,
        soup = 0.5,
	},
	stats = {
		weight = {min = 0.106, max = 0.125},
		length = {min = 0.1016, max = 0.1143}
	},
	config = {
		extra = {
			dollar_min = 1,
            dollar_max = 10
		}
	},
	blueprint_compat = false,
	use = function(self, card)
		local rank
        for _, playing_card in ipairs(G.deck.cards) do
			rank = pseudorandom_element(SMODS.Ranks)

			SMODS.change_base(playing_card, nil, rank.key)
		end
		play_sound('timpani')
	end,
	can_use = function(self, card)
		return true
	end
})

--functions to help the fish sticks work
function fac_wombat_count_sticks (level)
	local key = "fish_fac_wombatCountry_fishstick_" .. level
	local count = 0
	for _, fish in ipairs(G.fac_fish_area.cards) do
		if fish.config.center_key == key then
			count = count + 1
		end
	end
	return count
end

function fac_wombat_merge_sticks (level)
	local old_key = "fish_fac_wombatCountry_fishstick_" .. level
	local new_key = "fish_fac_wombatCountry_fishstick_" .. (level + 1)
	for _, fish in ipairs(G.fac_fish_area.cards) do
		if fish.config.center_key == old_key then
			SMODS.destroy_cards(fish, nil, nil, true)
		end
	end
	SMODS.add_card({key = new_key, area = G.fac_fish_area, set = "fac_Fish"})
end

--one fish stick
FishAndChips.Fish({
    key = "wombatCountry_fishstick_1",
	weight = 10,
	atlas = "wombatCountry_fish",
	pos = { x = 0, y = 1 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "chips" },
	environments = {
		city_river = 1,
		chocolate_river = 0.5,
		soup = 0.125,
	},
	stats = {
		weight = {min = 0.025, max = 0.03},
		length = {min = 0.07, max = 0.08}
	},
	config = {
		extra = {
			chips = 10
		}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.fish_fac_wombatCountry_fishstick_2
		return { vars = { card.ability.extra.chips} }
	end,
	calculate = function(self, card, context)
		if context.ending_fishing then
			--counts the number of one fish sticks
			local count = fac_wombat_count_sticks(1)
			--while there are an even number of one fish sticks, merge them
			while count % 2 == 0 and count > 0 do
				fac_wombat_merge_sticks(1)
				count = count - 2
			end
		end
		if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
	end
})

--two fish sticks
FishAndChips.Fish({
    key = "wombatCountry_fishstick_2",
	weight = 4,
	atlas = "wombatCountry_fish",
	pos = { x = 1, y = 1 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "chips" },
	environments = {
		city_river = 1,
		chocolate_river = 0.5,
		soup = 0.125,
	},
	stats = {
		weight = {min = 0.025, max = 0.03},
		length = {min = 0.07, max = 0.08}
	},
	config = {
		extra = {
			chips = 30
		}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.fish_fac_wombatCountry_fishstick_3
		return { vars = { card.ability.extra.chips} }
	end,
	calculate = function(self, card, context)
		if context.ending_fishing then
			--counts the number of two fish sticks
			local count = fac_wombat_count_sticks(2)
			--while there are an even number of two fish sticks, merge them
			while count % 2 == 0 and count > 0 do
				fac_wombat_merge_sticks(2)
				count = count - 2
			end
		end
		if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
	end
})

--three fish sticks
FishAndChips.Fish({
    key = "wombatCountry_fishstick_3",
	weight = 1,
	atlas = "wombatCountry_fish",
	pos = { x = 2, y = 1 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "chips" },
	environments = {
		city_river = 1,
		chocolate_river = 0.5,
		soup = 0.125,
	},
	stats = {
		weight = {min = 0.025, max = 0.03},
		length = {min = 0.07, max = 0.08}
	},
	config = {
		extra = {
			chips = 90
		}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips} }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
	end
})

--dylan fishmin
FishAndChips.Fish({
    key = "wombatCountry_dylan",
	weight = 10,
	atlas = "wombatCountry_fish",
	pos = { x = 1, y = 0 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "mult", "destroy_card", "scaling" },
	environments = {
		garden = 1,
        soup = 0.5,
	},
	stats = {
		weight = {min = 0.3, max = 0.7},
		length = {min = 0.025, max = 0.035}
	},
	config = {
		extra = {
			mult = 0.0
		}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult} }
	end,
	calculate = function(self, card, context)
		if context.setting_blind and not context.blueprint and #G.fac_fish_area.cards >= 2 and not (G.fac_fish_area.cards[1] == card) then
			--adds the weight of the leftmost fish to dylan's mult AND weight stat
			card.ability.extra.mult = card.ability.extra.mult + G.fac_fish_area.cards[1].ability.stats.weight
			card.ability.stats.weight = card.ability.stats.weight + G.fac_fish_area.cards[1].ability.stats.weight

			SMODS.destroy_cards(G.fac_fish_area.cards[1], nil, nil, true)
			return {
				message = localize('fac_wombatCountry_dylan')
			}
		end
		if context.joker_main then
            return {
                mult = card.ability.extra.mult,
            }
        end
	end
})

--yellowfish
FishAndChips.Fish({
    key = "wombatCountry_yellow",
	weight = 10,
	atlas = "wombatCountry_fish",
	pos = { x = 3, y = 1 },
	ppu_artist = { "wombatCountry" },
	ppu_coder = { "wombatCountry" },
	attributes = { "xmult", "destroy_card"},
	environments = {
		wormhole = 1,
        pier = 0.25,
	},
	stats = {
		weight = {min = 0.8, max = 22.2},
		length = {min = 0.07, max = 0.825}
	},
	config = {
		extra = {
			xmult = 2
		}
	},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult} }
	end,
	calculate = function(self, card, context)
		if context.remove_playing_cards then
			SMODS.destroy_cards(card)
		end
		if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
	end
})