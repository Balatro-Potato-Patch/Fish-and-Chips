local row = 3
local atlas, pos = PotatoPatchUtils.Developers.fac_minty:get_lineboil_atlas_info(row)

FishAndChips.Fish{
    key = "minty_starfish",
    atlas = atlas,
    pos = pos,
    weight = 1,
    ppu_coder = {"minty"},
    ppu_artist = {"minty"},
    environments = { --Maximum 6
        pier = 10,
        backroom = 3,
        wormhole = 1,
        swamp = 1,
    },
    attributes = {
        "space", "hand_level"
    },
    stats = {
        weight = { min = 1.5, max = 6}, --In kilograms
        length = { min = 0.13, max = 0.5}, --In meters
    },
    config = {
        extra = {
            luck = 1,
            odds = 3,
        }
    },
    loc_vars = function (self, info_queue, card)
        local luck, odds = SMODS.get_probability_vars(card, card.ability.extra.luck, card.ability.extra.odds, "minty_fac_starfish_level", true)

        return {
            vars = {
                luck, odds
            }
        }
    end,
    update = function (self, card, dt)
        PotatoPatchUtils.Developers.fac_minty:set_line_boil(self, card, row)
    end,
    calculate = function (self, card, context)
        if context.poker_hand_changed and context.card.config.center_key ~= card.config.center_key and context.new_level > context.old_level then
            if SMODS.pseudorandom_probability(card, "minty_fac_starfish_level", card.ability.extra.luck, card.ability.extra.odds) then
                return {
                    level_up = 1,
                    level_up_hand = context.scoring_name
                }
            end
        end
    end
}
