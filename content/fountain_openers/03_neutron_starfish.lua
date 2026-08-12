FishAndChips.Fish {
	key = "fo_neutron_starfish",
	atlas = "fo_fish",
	pos = { x = 1, y = 0 },
    eternal_compat = false,
	disable_visual_scaling = true,
	weight = 2,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_grahkon" },
	attributes = { "destroy_card", "hand_level", "usable" },
	config = {
        levels = 1,
	},
    cost = 3,
	environments = {
		wormhole = 1,
        styx = 0.0001, -- because it's dying
	},
    stats = {
		weight = {min = 1000, max = 2000},
        length = {min = 2.5 * 10^-15, max = 2.5 * 10^-15, units = {format = "fac_fo_fm", scale = 1e-15, precision = 1}},
	},
	use = function(self, card, area)
        local amt = #G.hand.cards
        local hands = {}

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        SMODS.destroy_cards(G.hand.cards)
        delay(0.5)
        for i = 1, amt do
            hands[#hands+1] = pseudorandom_element(G.handlist, "fac_fo_neutron_star")
        end
        if #hands > 0 then
            SMODS.upgrade_poker_hands{
                hands = hands
            }
        end
        SMODS.draw_cards(G.hand.config.card_limit - #G.hand.cards)
        delay(0.3)
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1
    end
}