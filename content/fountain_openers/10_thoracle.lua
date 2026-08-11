local function club_devotion()
    local s = 0
    for _, card in ipairs(G.hand.cards) do
        if card:is_suit("Clubs", true) then
            s = s + card.base.nominal
        end
    end

    return s
end

FishAndChips.Fish {
	key = "fo_thoracle",
	atlas = "fo_fish",
	pos = { x = 8, y = 0 },
	weight = 8,
	disable_visual_scaling = true,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_grahkon" },
	attributes = { "suit", "clubs", "xblindsize", "usable" },
	config = {
		extra = {
			active = true,
            xblindsize = 0.5
		},
	},
    cost = 5,
	environments = {
		pier = 1,
        swamp = 1
	},
	stats = {
		weight = {min = 60, max = 180},
		length = {min = 1.5, max = 2.2},
	},
    impulse_max = 0.45,
    decision_max = 0.6,
    decision_min = 0.9,
	loc_vars = function(self, info_queue, card)
		return {
            vars = {
                card.ability.extra.active and localize{
                    type = "variable",
                    key = "loyalty_active"
                } or localize("k_fac_fo_inactive"),
                card.ability.extra.xblindsize,
            }
        }
	end,
    calculate = function(self, card, context)
        if context.setting_blind then
            card.ability.extra.active = true
            return {
                message = localize{
                    type = "variable",
                    key = "loyalty_active"
                }
            }
        end
    end,
    use = function(self, card, area)
        if club_devotion() > #G.deck.cards then
            SMODS.calculate_effect({
                xblindsize = card.ability.extra.xblindsize
            }, card)
        else
            SMODS.calculate_effect({
                message = localize("k_nope_ex"),
                colour = G.C.SECONDARY_SET.Tarot,
                focus = card,
                sound = "cancel"
            }, card)
        end

        card.ability.extra.active = false
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 1 and card.ability.extra.active and G.GAME.blind and G.GAME.blind.in_blind
    end,
    keep_on_use = function(self, card)
        return true
    end,
}