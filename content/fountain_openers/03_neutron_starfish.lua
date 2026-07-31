FishAndChips.Fish {
	key = "fo_neutron_starfish",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 3,
	ppu_coder = { "Alexi" },
	ppu_artist = { "Grahkon" },
	attributes = { "destroy_card", "hand_level", "usable" },
	config = {
        levels = 1,
	},
	environments = {
		wormhole = 1,
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
    end,
}