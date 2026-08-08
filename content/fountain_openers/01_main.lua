FountainOpeners = {}

local alexi_text_colors = {
    HEX("45FFDA"),
    HEX("2AC2FF"),
    HEX("307FFF"),
    HEX("C180FF"),
    HEX("FFC7FF"),
}
local alexi_click_count = 5

SMODS.Atlas {
    key = "fo_dev_credits",
    path = "fountain_openers/fo_dev_credits.png",
    px = 71,
    py = 95,
    atlas_table = "ASSET_ATLAS"
}

SMODS.Atlas {
    key = "fo_fucking_kill",
    path = "fountain_openers/fucking_kill.png",
    px = 377,
    py = 105,
    frames = 5,
    atlas_table = "ANIMATION_ATLAS"
}

SMODS.Atlas {
    key = "fo_fucking_killed",
    path = "fountain_openers/fucking_killed.png",
    px = 466,
    py = 106,
    frames = 5,
    atlas_table = "ANIMATION_ATLAS"
}

SMODS.Sound {
    key = "fac_fo_explosion",
    path = "fountain_openers/fac_fo_explosion.ogg"
}

SMODS.Sound {
    key = "fac_fo_splat",
    path = "fountain_openers/fac_fo_splat.wav"
}

SMODS.Sound {
    key = "fac_fo_knight_cut2",
    path = "fountain_openers/fac_fo_knight_cut2.wav"
}

SMODS.Sound {
    key = "fac_fo_explosion2",
    path = "fountain_openers/fac_fo_explosion2.ogg"
}

SMODS.Sound {
    key = "fac_fo_parry",
    path = "fountain_openers/ultrakill_parry.ogg"
}

SMODS.DynaTextEffect {
    key = "alexi_text",
    func = function(dynatext, index, letter)
        local idx = math.min(index, 5)
        letter.colour = alexi_text_colors[idx]
        letter.offset.y = math.cos(G.TIMERS.REAL * 2.95 + index) * 9
    end,
}

PotatoPatchUtils.Developer {
	name = "fo_alexi",
	atlas = "fac_fo_dev_credits",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
	text_effect = "fac_alexi_text",
	fac_partner = "fac_fo_grahkon",
	fac_dw_shader = true, -- thanks elleeeee love youuu :3
    loc = true,
	click = function(self)
        play_sound("fac_fo_splat", 1.5-alexi_click_count*0.1)
        if alexi_click_count == 1 then
            love.system.openURL("https://en.pronouns.page/@invalidOS")
            alexi_click_count = 5
        else
            alexi_click_count = alexi_click_count - 1
        end
    end,
    calculate = function(self, context)
        local floweries = SMODS.find_card("fish_fac_fo_fishery")
        if #floweries > 0 then
            if context.fac_end_fishing then
                if not context.failed and not context.fish == "fish_fac_fo_fishery" then
                    if context.perfect or context.treasure then
                        FountainOpeners.random_flowery_sound({
                            "heh_one_more_for_the_fans",
                            "heh_its_my_jarona",
                            "all_according_to_all_according_to_plant",
                            "wow",
                            "thatsgreat",
                            "leaf_it_to_me",
                            "give_it_to_you",
                            "sustingus",
                            "glue"
                        })
                    else
                        FountainOpeners.random_flowery_sound({
                            "heytherelittleguy",
                            "heyguysithinkifoundaglue",
                            "its_all_yours",
                            "minipeppers",
                            "hey_boys",
                            "hey",
                            "hey_guys",
                        })
                    end
                else
                    FountainOpeners.random_flowery_sound({
                        "sorryaboutthatguys",
                        "sorryabouttheguy"
                    })
                end

            elseif context.fac_environment_changed and context.forced then
                FountainOpeners.random_flowery_sound({
                    "mysterious_wind",
                    "what_a_predictable_creature"
                })

            -- some of these also taken from utdr
            elseif context.game_over then
                FountainOpeners.random_flowery_sound({
                    "sustingus",
                    "nonono",
                    "goodbye",
                    "go_home",
                    "get_a_chance_1",
                    "get_a_chance_2",
                    "forget_it"
                })

            elseif context.open_booster then
                FountainOpeners.flowery_sound("hereicomesanfrandisco")

            elseif context.skipping_booster then
                FountainOpeners.flowery_sound("hereicomesanfrandisco_weak")

            elseif context.blind_disabled then
                FountainOpeners.flowery_sound("nonono")

            elseif context.blind_defeated then
                FountainOpeners.random_flowery_sound({
                    "heh_one_more_for_the_fans",
                    "heh_its_my_jarona",
                    "all_according_to_all_according_to_plant",
                    "wow",
                    "thatsgreat",
                    "leaf_it_to_me",
                    "give_it_to_you",
                    "sustingus",
                    "glue"
                })

            elseif context.card_added and context.card.config.center.set == "Joker" then
                FountainOpeners.random_flowery_sound({
                    "heytherelittleguy",
                    "heyguysithinkifoundaglue",
                    "its_all_yours",
                    "minipeppers",
                    "hey_boys",
                    "hey",
                    "hey_guys",
                })

            elseif context.after then
                local jacks = false
                local kings = false
                local queens = false
                for _, scored_card in ipairs(context.scoring_hand) do
                    if scored_card:get_id() == 11 then
                        jacks = true
                    elseif scored_card:get_id() == 13 then
                        kings = true
                    elseif scored_card:get_id() == 12 then
                        queens = true
                    end
                end

                if jacks then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            FountainOpeners.random_flowery_sound({
                                "hey_raly",
                                "dont_you_like_serving_humans",
                                "im_only_trying_to_help_you",
                                "imsorryonceagainikeptaladyinwaiting",
                                "sorrytokeepaladyinwaiting"
                            })
                            return true
                        end
                    }))
                elseif queens then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            FountainOpeners.random_flowery_sound({
                                "hey_raly",
                                "imsorryonceagainikeptaladyinwaiting",
                                "sorrytokeepaladyinwaiting"
                            })
                            return true
                        end
                    }))
                elseif kings then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            FountainOpeners.flowery_sound("my_king")
                            return true
                        end
                    }))
                end
            end
        end

        if context.fac_end_fishing and not context.failed and (#SMODS.find_card("fish_fac_fo_anvil") > 0) then
            context.fish_obj.fac_fo_anvil = true
        end
    end,
}

PotatoPatchUtils.Developer {
	name = "fo_grahkon",
	atlas = "fac_fo_dev_credits",
    pos = { x = 2, y = 0 },
    soul_pos = { x = 3, y = 0 },
	colour = G.C.GREEN,
	fac_partner = "fac_fo_alexi",
	fac_dw_shader = true,
    loc = true,
    click = function(self)
        play_sound("fac_fo_knight_cut2", 1)
    end,

    -- still done by alexi but. it's grahkon's fish.
    -- handles decreasing the amount of rerolls for when there's multiple crabkhons
    calculate = function(self, context)
        if context.reroll_shop then
            local crabkhons = SMODS.find_card("fish_fac_fo_crabkhon")
            if #crabkhons > 0 then
                local target_crab
                for _, crab in ipairs(crabkhons) do
                    if crab.ability.extra.remaining > 0 then
                        target_crab = crab
                        break
                    end
                end

                if target_crab then
                    target_crab.ability.extra.remaining = math.max(0, target_crab.ability.extra.remaining - 1)
                end
            end
        end
    end,
}

-- also used by the shit squad; shader by slimestuff
function FountainOpeners.dark_flip(card)
    local pos = card.children.center.sprite_pos
    card.children.center:set_sprite_pos({x=pos.x,y=1-pos.y})
    local pos2 = card.children.ppu_floating_sprite.sprite_pos
    card.children.ppu_floating_sprite:set_sprite_pos({x=pos2.x,y=1-pos2.y})
end

-- weird way of doing it but it ensures it happens after every dev object loads so Yea
G.E_MANAGER:add_event(Event({
    func = function()
        for _, dev in pairs(PotatoPatchUtils.Developers) do
            if dev.fac_dw_shader then
                dev.extra_click = dev.click
                dev.click = function(card)
                    FountainOpeners.dark_flip(card)
                    card:juice_up()
                    dev.extra_click(card)
                end
            end
        end
        return true
    end,
    blockable = false,
    blocking = false,
}))