FountainOpeners = {}

local alexi_text_colors = {
    HEX("45FFDA"),
    HEX("2AC2FF"),
    HEX("307FFF"),
    HEX("C180FF"),
    HEX("FFC7FF"),
}
local alexi_click_count = 5

-- Also used by the shit squad
function FountainOpeners.dark_flip(card)
    local pos = card.children.center.sprite_pos
    card.children.center:set_sprite_pos({x=pos.x,y=1-pos.y})
    local pos2 = card.children.ppu_floating_sprite.sprite_pos
    card.children.ppu_floating_sprite:set_sprite_pos({x=pos2.x,y=1-pos2.y})
end

SMODS.DynaTextEffect {
    key = "alexi_text",
    func = function(dynatext, index, letter)
        local idx = math.min(index, 5)
        letter.colour = alexi_text_colors[idx]
        letter.offset.y = math.cos(G.TIMERS.REAL * 2.95 + index) * 9
    end,
}

PotatoPatchUtils.Developer {
	name = 'Alexi',
	atlas = 'fac_cards',
	text_effect = "fac_alexi_text",
	fac_partner = 'Grahkon',
	fac_dw_shader = true, -- thanks elleeeee love youuu :3
	click = function(self)
        FountainOpeners.dark_flip(self)

        play_sound("fac_fo_splat",1.5-alexi_click_count*0.1)
        self:juice_up()
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
                if not context.fail and not context.fish == "fish_fac_fo_fishery" then
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
    end,
}

PotatoPatchUtils.Developer {
	name = 'Grahkon',
	atlas = 'fac_cards',
	-- pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'Alexi',
	fac_dw_shader = true,
}

function FountainOpeners.format_measurement(fish, value, type)
    local key = fish.key
    if key == "fish_fac_fo_fishery" then
        return "99999"

    elseif key == "fish_fac_fo_neutron_starfish" and type == "length" then
        return value * 1e-15 .. "fm"

    elseif key == "fish_fac_fo_boids" then
        return type == "weight" and "N/A" or "29px"

    else return FishAndChips.format_measurement(value, type) end
end

local custom_measures = {
    "fishery",
    "neutron_starfish",
    "boids",
}

--[[local guchp = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret = guchp(card)
    if card.ability and card.ability.set == 'fac_Fish' and card.area and not (card.area.config.collection or card.area.config.fac_compendium) then
        local use_custom = false
        for _, a in ipairs(custom_measures) do
            if "fish_fac_fo_" .. a == card.config.center.key then
                use_custom = true
                break
            end
        end

        if use_custom then
            local name = SMODS.deepfind(ret, 'main_box_flag', 'i')[1]
            local name_node = name.objtree

            local stats = card.ability.stats
            local stat_proto = card.config.center.stats
            local weight_perc = (stats.weight - stat_proto.weight.min)/(stat_proto.weight.max-stat_proto.weight.min)*100
            local length_perc = (stats.length - stat_proto.length.min)/(stat_proto.length.max-stat_proto.length.min)*100
            local colours = {
                darken(G.C.RED, 0.1),
                G.C.RED,
                G.C.ORANGE,
                G.C.YELLOW,
                G.C.GREEN,
                G.ARGS.LOC_COLOURS.edition
            }

            local weight_col_index = math.min(5, math.max(math.floor(weight_perc/20), 1))
            local weight_col = stats.weight == stat_proto.weight.max and colours[6] or mix_colours(colours[weight_col_index+1], colours[math.max(weight_col_index, 1)], (weight_perc - (weight_col_index * 20))/20)

            local length_col_index = math.min(5, math.max(math.floor(length_perc/20), 1))
            local length_col = stats.length == stat_proto.length.max and colours[6] or mix_colours(colours[length_col_index+1], colours[length_col_index], (length_perc - (length_col_index * 20))/20)

            name_node[#name_node - 4] = {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                {n=G.UIT.T, config = {text = localize('ph_fac_weight'), scale = 0.27, colour = G.C.WHITE, shadow = true}},
                {n=G.UIT.T, config = {text = FountainOpeners.format_measurement(card.config.center, stats.weight, 'weight'), scale = 0.27, colour = weight_col, shadow = true}},
                {n=G.UIT.T, config = {text = '  '..localize('ph_fac_length'), scale = 0.27, colour = G.C.WHITE, shadow = true}},
                {n=G.UIT.T, config = {text = FountainOpeners.format_measurement(card.config.center, stats.length, 'length'), scale = 0.27, colour = length_col, shadow = true}},
            }}
        end
    end

    return ret
end

local efe = FishAndChips.Compendium.extended_fish_entry
function FishAndChips.Compendium.extended_fish_entry(fish, left, ...)
    local text = efe(fish, left, ...)

    local use_custom = false
    for _, a in ipairs(custom_measures) do
        if "fish_fac_fo_" .. a == fish.key then
            use_custom = true
            break
        end
    end

    if use_custom then
        local fish_data = G.PROFILES[G.SETTINGS.profile].fac_fishing.fish_data[fish.key] or {
            first_catch = '',
            rod = '',
            times_caught = '',
            record_weight = '',
            record_length = ''
        }

        local fish_caught = type(fish_data.times_caught) == 'number' and (fish_data.times_caught > 0)
        local record_weight = fish_caught and localize('ph_fac_record_weight')..FishAndChips.format_measurement(fish, fish_data.record_weight or nil, 'weight') or ' '
        local record_length = fish_caught and localize('ph_fac_record_length')..FishAndChips.format_measurement(fish, fish_data.record_length or nil, 'length') or ' '

        text.nodes[1].nodes[5].nodes[1] = 
            {n=G.UIT.O, config={object = DynaText({string = record_weight, colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.3, silent = true})}}
        text.nodes[1].nodes[6].nodes[1] = 
            {n=G.UIT.O, config={object = DynaText({string = record_length, colours = {FishAndChips.C.COMPENDIUM_TEXT}, font = SMODS.Fonts.fac_collection, maxw = 3.2, pop_in_rate = 0, scale = 0.3, silent = true})}}
    end

    return text
end]]