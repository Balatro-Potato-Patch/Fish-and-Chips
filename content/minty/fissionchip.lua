local row = 5
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_fission",
    atlas = atlas,
    pos = pos,
    badge_key = "k_fac_maybe_fish",
    weight = 3,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        aquifer = 5,
        backroom = 10,
        wormhole = 10,
        city_river = 5,
    },
    attributes = {
        "retrigger", "chance"
    },
    stats = {
        weight = { min = 0.005, max = 0.005}, --In kilograms
        length = { min = 0.02, max = 0.02}, --In meters
    },
    config = {
        extra = {
            luck = 1,
            odds = 2,
            retriggers = 1
        }
    },
    loc_vars = function (self, info_queue, card)
        local luck, odds = SMODS.get_probability_vars(card, card.ability.extra.luck, card.ability.extra.odds, "minty_fac_fission_retrigger", false)
        local key = self.key
        if card.ability.extra.retriggers ~= 1 then
            key = key.."_plural"
        end
        
        return {
            key = key,
            vars = {
                luck, odds,
                card.ability.extra.retriggers
            }
        }
    end,
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    calculate = function (self, card, context)
        if context.retrigger_joker_check
        and not context.retrigger_joker
        and context.other_card
		and context.other_card:is(Card)
        and context.other_card.config.center.set == "fac_Fish"
        and SMODS.pseudorandom_probability(card, "minty_fac_fission_retrigger", card.ability.extra.luck, card.ability.extra.odds) then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
    end
}