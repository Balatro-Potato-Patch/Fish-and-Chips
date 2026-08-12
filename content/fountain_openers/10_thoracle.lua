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
		pier = 2,
        swamp = 2,
        styx = 0.1
	},
	stats = {
		weight = {min = 60, max = 180},
		length = {min = 1.5, max = 2.2},
	},
    impulse_max = 0.45,
    decision_max = 0.6,
    decision_min = 0.9,
	loc_vars = function(self, info_queue, card)
        local active_str = card.ability.extra.active and "active" or "inactive"
        return {
            vars = {
                card.ability.extra.xblindsize,
                elements = {
                    {n=G.UIT.C, config = {padding = 0.05}, nodes = {
                        {n=G.UIT.C, config={align = "m", colour = PotatoPatchUtils.Bubble_Colours[active_str] or G.C.RED, r = 0.05, padding = 0.06, res = 0.45}, nodes={
                            {n=G.UIT.T, config={text = localize('ppu_bubble_' .. active_str), colour = G.C.UI.TEXT_LIGHT, scale = 0.24}},
                        }}
                    }}
                },
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
    set_card_type_badge = function(self, card, badges)
		badges[#badges + 1] = create_badge(localize("k_fac_fo_merfolk_wizard"), FishAndChips.C.FISH, G.C.WHITE, 1.2)
	end,
}