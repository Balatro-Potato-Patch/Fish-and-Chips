FishAndChips.Fish {
	key = "fo_neutron_starfish",
	atlas = "fish",
	pos = { x = 3, y = 0 },
    eternal_compat = false,
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
    stats = {
		weight = {min = 1000, max = 2000},
		length = {min = 2.5 * 10^-15, max = (2.5 + 0.00001) * 10^-15}
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