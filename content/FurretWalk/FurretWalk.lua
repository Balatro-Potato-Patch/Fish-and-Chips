SMODS.Atlas({
	key = "furretfih",
	path = "FurretWalk/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "creditswalk",
	path = "FurretWalk/furret.png",
	px = 71,
	py = 95,
})

PotatoPatchUtils.Developer({
	name = "FurretWalk",
	atlas = "fac_creditswalk",
	colour = G.C.CHIPS,
	loc = true
})


FishAndChips.Fish {
	key = "miketrout",
	atlas = "furretfih",
	pos = { x = 0, y = 0 },
	weight = 20,
	ppu_coder = { "FurretWalk" },
	ppu_artist = { "FurretWalk" },
	attributes = { "xmult", "scaling", },
	config = {
		extra = {
			xMultPerFish = 0.05, xMultmod = 0.05
		}
	},
	environments = {
		styx = 27,
		wormhole = 16,
        chocolate_river = 9
	},
	stats = {
		weight = {min = 9, max = 13},
		length = {min = 1.3, max = 3.5}
	},
	loc_vars = function(self, info_queue, card)
		local numFish = G.fac_fish_area and #G.fac_fish_area.cards or 1
		return { vars = { card.ability.extra.xMultPerFish, card.ability.extra.xMultmod, 1 + card.ability.extra.xMultPerFish * numFish } }
	end,
	calculate = function(self, card, context)
		    if context.joker_main then
            return {
                Xmult = 1 + card.ability.extra.xMultPerFish * #G.fac_fish_area.cards
            }
        end
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss and not context.blueprint then
            SMODS.scale_card(card, {
                ref_value = "xMultPerFish",
                scalar_value = "xMultmod",
                message_colour = G.C.MULT,
            })
            return nil, true
            -- return {
            --     message = localize('k_upgrade_ex'),
            --     colour = G.C.MULT,
            -- }
        end
	end,
}

FishAndChips.Fish {
    key = "fishmael",
    atlas = "furretfih",
    pos = { x = 1, y = 0 },
    weight = 55,
    ppu_coder = { "FurretWalk" },
    ppu_artist = { "FurretWalk" },
    attributes = { "mult", "destroy_card"},
    config = {
        extra = {
            chips = 21, chipmod = 8, suit = 'Hearts'
        }
    },
    environments = {
        calm_pond = 8,
        styx = 18,
		pier = 28
    },
    stats = {
        weight = {min = 80, max = 88},
        length = {min = 1.39, max = 1.88}
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chipmod, card.ability.extra.suit} }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
			return
			{chips = card.ability.extra.chips}
		end
		if context.destroying_card and not context.blueprint and context.destroying_card:is_suit(card.ability.extra.suit) then
		        SMODS.scale_card(card, {
										ref_value = "chips",
							scalar_value = "chipmod",
						no_message = true,
										})
				return {
                    remove = true,
                    message = "Harpooned!",
                    colour =G.C.RED,
                    card = card
                }
		end
    end,
}
