PotatoPatchUtils.Developer({
	name = 'Moby Nick',
	atlas = 'fac_cards',
	colour = HEX("d0d0d0"),
	ignore_limits = true,
	fac_partner = 'JoFin' 
})

PotatoPatchUtils.Developer({
	name = 'JoFin',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = HEX("FCB3EA"),
	ignore_limits = true,
	fac_partner = 'Moby Nick'
})

SMODS.Atlas({
	key = "w_d_seuss_fish",
	path = "w_d_seuss/fish.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "one",
	atlas = "w_d_seuss_fish",
	pos = { x = 0, y = 0 },
	weight = 1,
	ppu_coder = { "JoFin" },
	ppu_artist = { "JoFin" },
	attributes = { "chips" },
	config = {
		extra = {
		}
	},
	environments = {
		calm_pond = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
	end,
}

FishAndChips.Fish {
	key = "two",
	atlas = "w_d_seuss_fish",
	pos = { x = 1, y = 0 },
	weight = 1,
	ppu_coder = { "Mack" },
	ppu_artist = { "Mack" },
	attributes = { "chips" },
	config = {
		extra = {
		}
	},
	environments = {
		calm_pond = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
	end,
}

FishAndChips.Fish {
	key = "red",
	atlas = "w_d_seuss_fish",
	pos = { x = 2, y = 0 },
	weight = 1,
	ppu_coder = { "Mack" },
	ppu_artist = { "Mack" },
	attributes = { "chips" },
	config = {
		extra = {
		}
	},
	environments = {
		calm_pond = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
	end,
}

FishAndChips.Fish {
	key = "blue",
	atlas = "w_d_seuss_fish",
	pos = { x = 3, y = 0 },
	weight = 1,
	ppu_coder = { "Mack" },
	ppu_artist = { "Mack" },
	attributes = { "chips" },
	config = {
		extra = {
		}
	},
	environments = {
		calm_pond = 10,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { } }
	end,
	calculate = function(self, card, context)
	end,
}

FishAndChips.Fish {
	key = "pear",
	atlas = "w_d_seuss_fish",
	pos = { x = 4, y = 0 },
	weight = 4,
	ppu_coder = { "Moby Nick" },
	ppu_artist = { "Moby Nick" },
	attributes = { "hand_type, food" },
	config = {
		extra = {
			pear = 5,
			pear_total = 5,
			levels = 1
        }
	},
	environments = {
		pier = 4,
		soup = 1,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.pear_total, card.ability.extra.pear, card.ability.extra.levels } }
	end,
	calculate = function(self, card, context)
		if context.fac_end_fishing and not context.blueprint then 
			if card.ability.extra.pear - 1 <= 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.NIC_TETO
                }
            else
                card.ability.extra.pear = card.ability.extra.pear - 1
            end
        end

		if context.fish then 
			return { 
				level_up = card.ability.extra.levels, level_up_hand = "Pair", 
				message = localize('k_level_up_ex'),
                colour = HEX("FCB3EA")
			} 
		end
		if context.failed then 
			G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    attention_text({
                        text = localize('k_nope_ex'),
                        scale = 1.3,
                        hold = 1.4,
                        major = card,
                        backdrop_colour = G.C.SECONDARY_SET.Tarot,
                        align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
                            'tm' or 'cm',
                        offset = { x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0 },
                        silent = true
                    })
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))
		end
	end,
}