local all_other_minty_fish_weights = 42                     --x1 = 14, x2 = 28, x3 = 42
local invasive_weight = 75 - all_other_minty_fish_weights   --x1 = 61, x2 = 47, x3 = 33

SMODS.Atlas {
    key = "minty_fucking_chum",
    path = "minty/fkn chum.png",
    px = 484,
    py = 107,
    frames = 5,
    atlas_table = "ANIMATION_ATLAS"
}

SMODS.Atlas {
    key = "minty_fucking_chum_alt",
    path = "minty/fkn chum alt.png",
    px = 495,
    py = 107,
    frames = 5,
    atlas_table = "ANIMATION_ATLAS"
}

local function fkn_chum_sprite(scale)
    scale = scale or 1
    return SMODS.create_sprite(
        0, 0,
        (FishAndChips.mod.config.family_friendly and 378 or 377) / 255 * scale,
        105 / 255 * scale,
        FishAndChips.mod.config.family_friendly and
            "fac_minty_fucking_chum_alt"
            or "fac_minty_fucking_chum",
        {x = 0, y = 0}
    )
end

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
    use_colour = function()
        if #SMODS.find_card("fish_fac_fo_anvil") > 0 then
            return G.C.UI.TEXT_LIGHT
        end
        return G.C.RED
    end,
    config = {
        extra = {
            luck = 1,
            sand_dollar_odds = 3,
            bait_odds = 3
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
        local vars = {}
        if card.ability.extra.native then
            key = key.."_alt"
        elseif #SMODS.find_card("fish_fac_fo_anvil") > 0 then
            key = key.."_anvil"
            vars = {
                elements = {
                    fkn_chum_sprite(1)
                }
            }
        end

        return {
            key = key, vars = vars
        }
    end,
    use = function (self, card)
        if #SMODS.find_card("fish_fac_fo_anvil") > 0 then
            FountainOpeners.anvil_animation:play(card)
        end

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

            if G.GAME.minty_seabass_chummed[caught_env] > 3 then
                if SMODS.pseudorandom_probability(card, "minty_seabass_eradication_"..caught_env, 1, 3, nil, true) then
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
        local text_node
        if #SMODS.find_card("fish_fac_fo_anvil") > 0 then
            text_node = {n=G.UIT.O, config={object = fkn_chum_sprite(1)}}
        else
            text_node = { n = G.UIT.T, config = { text = localize("b_fac_minty_chum"), colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true } }
        end

		local use = {
            n = G.UIT.C,
            config = { align = "cr" },
            nodes = {

                {
                    n = G.UIT.C,
                    config = { ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r = 0.08, minw = 1.25, minh = (card.area and card.area.config.type == "joker") and 0 or 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = "fac_use_fish", func = "fac_can_use_fish" },
                    nodes = {
                        { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                        text_node
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