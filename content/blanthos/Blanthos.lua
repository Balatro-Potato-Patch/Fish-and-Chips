PotatoPatchUtils.Developer({
	name = 'Blanthos',
	atlas = 'fac_cards',
	colour = G.C.YELLOW,
	fac_partner = 'fac_Hunter'
})

PotatoPatchUtils.Developer({
	name = 'Hunter',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.YELLOW,
	fac_partner = 'fac_Blanthos'
})

SMODS.Atlas({
	key = "blanthos_hunter_fish", -- Please include your name/team name in your atlas keys
	path = "blanthos/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "blanthos_hunter_gasterhat", -- Please include your name/team name in your atlas keys
	path = "blanthos/gasterhat.png",
	px = 710,
	py = 950,
})

SMODS.Gradient {
    key = 'happy_gradient',
    colours = {G.C.FILTER, G.C.GREEN},
    cycle = 1
}

SMODS.Gradient {
    key = 'bored_gradient',
    colours = {G.C.SECONDARY_SET.Spectral, G.C.SECONDARY_SET.Planet},
    cycle = 1
}

--#region Fish

FishAndChips.Fish {
	key = "gneep_gnarp",
	atlas = "blanthos_hunter_fish",
	pos = { x = 0, y = 0 },
	weight = 25,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "Hunter" },
	attributes = { "hand_level", "scaling", "hand_type", "space", "usable", "economy" },
	config = {
		extra = {
			happiness = 75,
			boredom = 5,
			food_cost = 3,
			food_happiness = 5
		},
		immutable = {
			hand = "HighCard"
		}
	},
	environments = {
		chocolate_river = 1,
		wormhole = 1,
		soup = 1
	},
	stats = {
		weight = {min = 3.6, max = 5.4},
		length = {min = 0.4, max = 0.46}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.happiness, card.ability.extra.boredom, card.ability.extra.food_cost, card.ability.extra.food_happiness, math.floor (card.ability.extra.happiness / 15), localize(card.ability.immutable.hand, "poker_hands") } }
	end,
	can_use = function(self, card)
		return G.GAME.dollars >= card.ability.extra.food_cost
	end,
    keep_on_use = function()
        return true
    end,
	use = function(self, card)
ease_dollars(-card.ability.extra.food_cost)
            SMODS.scale_card(card, {
                    ref_value = "happiness",
                    scalar_value = "food_happiness",
                    operation = '+',
                    message_key = "blanth_yum",
                    message_colour = G.C.SECONDARY_SET.Planet
                })
                return nil, true
		end,
  calculate = function(self, card, context)
        if context.before then
            return {
                message = localize("blanth_placeholder"),
                colour = G.C.SECONDARY_SET.Planet,
                func = function()
                    SMODS.upgrade_poker_hands({
                        hands = card.ability.immutable.hand,
                        level_up = math.floor (card.ability.extra.happiness / 15),
                        from = context.blueprint and context.blueprint_card or card
                    })
                end
            }
        end
        if context.after then
            SMODS.upgrade_poker_hands({
                hands = card.ability.immutable.hand,
                level_up = math.ceil (-card.ability.extra.happiness / 15),
                from = context.blueprint and context.blueprint_card or card
            })
            return nil, true
        end

        if context.end_of_round and context.main_eval then
         if card.ability.extra.happiness - card.ability.extra.boredom <= 0 then
                SMODS.destroy_cards(card, {pinch_anim = true})
                return {
                    message = localize("blanth_placeholder")
                }
            else
                SMODS.scale_card(card, {
                    ref_value = "happiness",
                    scalar_value = "boredom",
                    operation = '-',
                    message_key = "blanth_bored",
                    message_colour = G.C.SECONDARY_SET.Planet
                })
                return nil, true
		end
	end
end,
    set_ability = function(self, card, initial, delay_sprites)
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        card.ability.immutable.hand = pseudorandom_element(_poker_hands, 'fac_gneep_gnarp')
    end
}

FishAndChips.Fish {
	key = "spectre_fish",
	atlas = "blanthos_hunter_fish",
	pos = { x = 1, y = 0 },
	weight = 14,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "Hunter" },
	attributes = { "mult", "scaling" },
	config = {
		extra = {
			mult = 14,
			scaling = 14
		},
		immutable = {
			inactive = false
		}
	},
	environments = {
		styx = 1,
		aquifer = 0.5
	},
	stats = {
		weight = {min = 0, max = 0},
		length = {min = 3, max = 8}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.scaling, card.ability.immutable.inactive and "Inactive" or "Active" } }
	end,
	calculate = function(self, card, context)
        if context.end_of_round then
            card.ability.immutable.inactive = false
        end
if (context.joker_type_destroyed and context.card == card and not card.ability.immutable.inactive) then
            card.ability.immutable.inactive = true
                SMODS.scale_card(card, {
                    ref_value = "mult",
                    scalar_value = "scaling",
                    operation = '+'
                })
                return nil, true, {no_destroy = true}
		end
		if context.joker_main then return { mult = card.ability.extra.mult } end
	end,
}


FishAndChips.Fish {
	key = "gaster_hat",
	atlas = "blanthos_hunter_gasterhat",
	pos = { x = 0, y = 0 },
	weight = 6,
	ppu_coder = { "Blanthos" },
	ppu_artist = { "Hunter" },
	attributes = { "mult", "scaling" },
	config = {
		extra = {
			odds = 4
		}
	},
	environments = {
		styx = 1,
		pier = 0.5,
		garden = 0.1
	},
	stats = {
		weight = {min = 0.5, max = 0.5},
		length = {min = 0.62, max = 0.62}
	},
	loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'fac_gaster_fish')
        return { vars = { numerator, denominator } }
	end,
	calculate = function(self, card, context)
if context.selling_card and context.card.ability.set == 'Joker' and SMODS.pseudorandom_probability(card, 'fac_gaster_hat', 1, card.ability.extra.odds) then
return {
sand_dollars = math.random(5)
}
end
end,
}
--#endregion
