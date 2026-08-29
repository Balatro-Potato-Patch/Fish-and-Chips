local all_other_minty_fish_weights = 14
local invasive_weight = 75 - all_other_minty_fish_weights

FishAndChips.Fish{
    key = "minty_seabass",
    atlas = "minty_fish",
    pos = {x=0, y=0},
    weight = invasive_weight,
    ppu_coder = {"minty"},
    ppu_artist = {"Animal Crossing devteam"},
    environments = {
        pier = (5/invasive_weight),
        soup = invasive_weight,
        chocolate_river = invasive_weight,
        volcano = invasive_weight,
        backroom = invasive_weight,
        wormhole = invasive_weight,
    },
    stats = {
        weight = {min = 2.5, max = 4},
        length = {min = 0.2, max = 0.65},
    },
    cost = 0,
    blueprint_compat = false,
    eternal_compat = false,
    config = {
        extra = {
            luck = 1,
            sand_dollar_odds = 3,
            bait_odds = 8
        }
    },
    attributes = {
        "usable", "economy", "generation"
    },
    loc_vars = function (self, info_queue, card)
        local key = self.key
        local luck = card.ability.extra.luck
        if card.ability.extra.native then
            luck = luck*2
            key = key.."_alt"
        end

        local sd_luck, sd_odds = SMODS.get_probability_vars(card, luck, card.ability.extra.sand_dollar_odds, "fac_minty_seabass_sand_dollar", false)
        local bait_luck, bait_odds = SMODS.get_probability_vars(card, luck, card.ability.extra.bait_odds, "fac_minty_seabass_bait", false)
        return {
            key = key,
            vars = {
                sd_luck, sd_odds,
                bait_luck, bait_odds,
            }
        }
    end,
    flavour_vars = function (self, info_queue, card)
        local key = self.key
        if card.ability.extra.native then
            key = key.."_alt"
        end

        return {
            key = key
        }
    end,
    use = function (self, card)
        SMODS.destroy_cards(card, {colours = {G.C.RED}, skip_calc = true})
        local luck = card.ability.extra.luck
        if card.ability.extra.native then
            luck = luck*2
        end

        if SMODS.pseudorandom_probability(card, "fac_minty_seabass_sand_dollar", luck, card.ability.extra.sand_dollar_odds) then
            ease_sand_dollars(1)
        end
        if SMODS.pseudorandom_probability(card, "fac_minty_seabass_bait", luck, card.ability.extra.bait_odds) then
            local bait = SMODS.poll_object{type = "fac_Bait"}
            FishAndChips.add_bait_to_inventory(bait, 1)
        end
        local caught_env = card.ability.extra.caught_at
        if caught_env and caught_env ~= "pier" then
            G.GAME.minty_seabass_chummed[caught_env] = (G.GAME.minty_seabass_chummed[caught_env] or 0) + 1

            if G.GAME.minty_seabass_chummed[caught_env] > 7 then
                if SMODS.pseudorandom_probability(card, "minty_seabass_eradication_"..caught_env, 1, 7, nil, true) then
                    G.GAME.minty_seabass_eradicated[caught_env] = true
                end
            end
        end
    end,
    can_use = function (self, card)
        return true
    end,
    on_catch = function (self, card)
        local env = (FishAndChips.get_environment() or {}).key or "unknown area"
        if env == "pier" then
            card.ability.extra.native = true
        else
            card.ability.extra.caught_at = env
        end
        if G.GAME.minty_seabass_ever_caught then
            SMODS.calculate_effect({message = localize("k_fac_minty_youagain_qex"), delay = 3 }, card)
        else
            G.GAME.minty_seabass_ever_caught = true
        end
    end,
    in_pool = function (self, args)
        local env = (FishAndChips.get_environment() or {}).key
        if not env then return false end

        return not G.GAME.minty_seabass_eradicated[env]
    end,
}

local use_and_sell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
	local ret = use_and_sell(card)
	if card.config.center.key == "fish_fac_minty_seabass" and card.area.config.type == "joker" then
		local use = {
            n = G.UIT.C,
            config = { align = "cr" },
            nodes = {

                {
                    n = G.UIT.C,
                    config = { ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r = 0.08, minw = 1.25, minh = (card.area and card.area.config.type == "joker") and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = "use_card", func = "can_use_consumeable" },
                    nodes = {
                        { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                        { n = G.UIT.T, config = { text = localize("b_fac_minty_chum"), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
                    }
                }
            }
        }
		ret = {
			n = G.UIT.ROOT,
			config = { padding = 0, colour = G.C.CLEAR },
			nodes = {
				{
					n = G.UIT.C,
					config = { padding = 0.15, align = "cl" },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cl" },
							nodes = {
								use
							}
						},
					}
				},
			}
		}
	end
	return ret
end