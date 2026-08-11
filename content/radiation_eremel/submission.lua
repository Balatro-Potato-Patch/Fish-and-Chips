PotatoPatchUtils.Developer({
	name = 'eremel',
    loc = true,
	-- atlas = 'radiation_eremel_credits',
	colour = HEX('3FC7EB'),
	fac_partner = 'fac_radiation'
})

PotatoPatchUtils.Developer({
	name = 'radiation',
    loc = true,
	-- atlas = 'radiation_eremel_credits',
	pos = {x = 1, y = 0},
	colour = HEX('FF7C0A'),
	fac_partner = 'fac_eremel'
})

SMODS.Atlas({
    key = 'r_e_fish',
    path = 'radiation_eremel/fish.png',
    px = 71, py = 95
})

FishAndChips.Fish({
    key = 'r_e_butterfly_fish',
    atlas = 'r_e_fish',
    pos = {x = 4, y = 0},
    ppu_coder = {'eremel'},
    ppu_artist = {'radiation'},
    weight = 10,
    environments = {
        calm_pond = 3,
        pier = 4,
        garden = 6,
        wormhole = 1,
        chocolate_river = 1
    },
    attributes = {'chance', 'modify_card', 'suit', 'hand_type'},
    stats = {
        weight = {min = 0.03, max = 0.15},
        length = {min = 0.12, max = 0.22},
    },
    config = {extra = {denom = 4, hand = 'Flush'}},
    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.denom, 'r_e_butterfly')
        return {vars = {n, d, localize(card.ability.extra.hand, 'poker_hands'), 
           card.ability.extra.current and (card.ability.extra.current == 'Wild' and localize({set = 'Enhanced', type = 'name_text', key = 'm_wild'}) or localize(card.ability.extra.current, 'suits_plural')) or localize('fac_r_e_random_suits'),
           colours = {card.ability.extra.current and (G.C.SO_1[card.ability.extra.current] or G.ARGS.LOC_COLOURS.attention) or G.ARGS.LOC_COLOURS.inactive},
        ppu_bubbles = {'usable', 'toggle'}}}
    end,
    flush_options = {
        Hearts = {pos = {x=1,y=0}, colour = 'Hearts'},
        Diamonds = {pos = {x=3,y=0}, colour = 'Diamonds'},
        Clubs = {pos = {x=2,y=0}, colour = 'Clubs'},
        Spades = {pos = {x=0,y=0}, colour = 'Spades'},
        Wild = {pos = {x=1,y=1}, colour = 'attention'},
        Modded = {pos = {x=0,y=1}, colour = 'inactive'}
    },
    detect_suit = function(hand)
        local suits = {}
        local suit
        for _, card in ipairs(hand) do
            if SMODS.has_no_suit(card) then
            elseif SMODS.has_any_suit(card) then
                suits.Wild = (suits.Wild or 0) + 1
                if suits.Wild > (suits[suit] or 0) then suit = 'Wild' end
            else
                suits[card.base.suit] = (suits[card.base.suit] or 0) + 1
                if suits[card.base.suit] > (suits[suit] or 0) then suit = card.base.suit end
            end
        end
        return suit
    end,
    check_card = function(self, card, other)
        if card.ability.extra.current == 'Wild' then
            return not SMODS.has_enhancement(other, 'm_wild')
        end
        return not other:is_suit(card.ability.extra.current)
    end,
    calculate = function(self, card, context)
        if context.before and next(context.poker_hands.Flush) then
            card.ability.extra.current = self.detect_suit(context.scoring_hand)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    local pos = self.flush_options[card.ability.extra.current] or self.flush_options.Modded
                    card.children.center:set_sprite_pos(pos.pos)
                    card:juice_up()
                    return true
                end
            }))
            return {
                message = card.ability.extra.current .. ' Flush!',
                colour = G.C.SO_1[card.ability.extra.current]
            }
        end
        -- TODO: tidy up these animations
        if context.individual and context.cardarea == G.play and self:check_card(card, context.other_card) then
            if SMODS.pseudorandom_probability(card, 'r_e_butterfly', 1, card.ability.extra.denom) then
                local target = context.other_card
                local suit = card.ability.extra.current or pseudorandom_element(SMODS.Suit.obj_buffer)

                if suit == 'Wild' then
                    G.E_MANAGER:add_event(Event({
                            type = 'after',
                            func = function()
                                target:juice_up()
                                target:set_ability('m_wild')
                                return true
                            end
                        }))
                else
                    target.base.suit = card.ability.extra.current
                        G.E_MANAGER:add_event(Event({
                            type = 'after',
                            func = function()
                                target:juice_up()
                                assert(SMODS.change_base(target, suit))
                                return true
                            end
                        }))
                end
                return {
                    message = 'Butterfly!',
                }
            end
        end
    end,
})