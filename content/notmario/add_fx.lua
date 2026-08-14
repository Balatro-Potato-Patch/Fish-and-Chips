-- stolen from mf
function PotatoPatchUtils.Developers.fac_notmario.parse_string(text)
    for i, v in pairs(text) do
        if type(v) == "table" then
            PotatoPatchUtils.Developers.fac_notmario.parse_string(v)
        else
            text[i] = loc_parse_string(v)
        end
    end
end

function PotatoPatchUtils.Developers.fac_notmario.create_vtext(vtext, AUT, nodes, vars, lines, num)
    local localize_args = {
        AUT = AUT,
        nodes = nodes,

        vars = vars
    }
    -- taken from localize; adds the multibox
    localize_args.AUT.multi_box = localize_args.AUT.multi_box or {}
    local i = num + 1 -- fucking janky ass method
    G.AUT = AUT
    for j, line in ipairs(lines) do
        local final_line = SMODS.localize_box(line, localize_args)
        if i == 1 or next(AUT.info) then
            nodes[#nodes+1] = final_line -- Sends main box to AUT.main
            if not next(AUT.info) then nodes.main_box_flag = true end
        elseif not next(AUT.info) then
            nodes.main_box_flag = true
            AUT.multi_box[i-1] = AUT.multi_box[i-1] or {}
            AUT.multi_box[i-1][#AUT.multi_box[i-1]+1] = final_line
        end
        if not next(AUT.info) and vars.box_colours then AUT.box_colours[i] = vars.box_colours and vars.box_colours[i] or G.C.UI.BACKGROUND_WHITE end
    end
end

function PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes(args2)
    return function(center, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        -- if not full_UI_table.box_colours then return end
        local num = full_UI_table.multi_box and #full_UI_table.multi_box + 1 or 1
        for i, args in pairs(args2) do
            if not args.func or args:func(card) then
                local keys = type(args.key) == "table" and args.key or {args.key}
                for _, k in pairs(keys) do
                    local vars = args.loc_vars and (args:loc_vars({}, card) or {}).vars or {}
                    local lines = SMODS.shallow_copy(G.localization.misc.v_dictionary_parsed[k] or {})
                    local vtext = localize{ type = "variable", key = k, vars = vars } -- the var doesn't matter here
                    PotatoPatchUtils.Developers.fac_notmario.create_vtext(vtext, full_UI_table, desc_nodes, vars, lines, num)
                    if args.seperate_boxes then
                        num = num + 1
                    end
                end
                local texts = type(args.localized_text) == "table" and args.localized_text or {args.localized_text}
                for _, k in pairs(texts) do
                    local vars = args.loc_vars and (args:loc_vars({}, card) or {}).vars or {}
                    local vtext = type(k) == "string" and {k} or k or {}
                    PotatoPatchUtils.Developers.fac_notmario.parse_string(vtext)
                    PotatoPatchUtils.Developers.fac_notmario.create_vtext(nil, full_UI_table, desc_nodes, vars, vtext, num)
                    if args.seperate_boxes then
                        num = num + 1
                    end
                end
                if not args.seperate_boxes then
                    num = num + 1
                end
            end
        end
    end
end

function PotatoPatchUtils.Developers.fac_notmario.add_extra_multiboxes(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table, ability)
    if not G.fac_fish_area then return nil end

    if ability and (ability.fac_mf_sap_chips or ability.fac_mf_sap_mult) then
        local required_key = "fac_mf_sap_chult"
        if not ability.fac_mf_sap_chips then required_key = "fac_mf_sap_mult" end
        if not ability.fac_mf_sap_mult then required_key = "fac_mf_sap_chips" end
        local desc_text = G.localization.descriptions.Other[required_key].text
        PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
            {
                localized_text = desc_text,
                loc_vars = function(self, card, center)
                    return { vars = { ability.fac_mf_sap_chips, ability.fac_mf_sap_mult } }
                end
            }
        })(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
    end

    if ability and ability.fac_mf_car_battery then
        local desc_text = G.localization.descriptions.Other["fac_mf_car_battery"].text
        local desc_text_multiple = G.localization.descriptions.Other["fac_mf_car_battery_multiple"].text
        -- collate them so we dont go off screen
        local counts = {}
        local order = {} -- :p
        for _, odds in ipairs(ability.fac_mf_car_battery) do
            if not counts[odds] then
                counts[odds] = 0
                order[#order + 1] = odds
            end
            counts[odds] = counts[odds] + 1
        end

        for _, odds in ipairs(order) do
            PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
                {
                    localized_text = counts[odds] <= 1 and desc_text or desc_text_multiple,
                    loc_vars = function(self, card, center)
                        local new_numerator, new_denominator =
                            SMODS.get_probability_vars(card, 1, odds, "fac_mf_car_battery")
                        return { vars = { new_numerator, new_denominator, counts[odds] } }
                    end
                }
            })(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
        end
    end

    if ability and ability.fac_mf_frying_fish then
        local desc_text = G.localization.descriptions.Other["fac_mf_frying_fish"].text
        if ability.fac_mf_frying_fish > 1 then
            desc_text = G.localization.descriptions.Other["fac_mf_frying_fish_multiple"].text
        end
        PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
            {
                localized_text = desc_text,
                loc_vars = function(self, card, center)
                    return { vars = { ability.fac_mf_frying_fish } }
                end
            }
        })(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
    end

    if ability and ability.fac_mf_fishion_reactor then
        local desc_text = G.localization.descriptions.Other["fac_mf_fishion_reactor"].text
        local desc_text_multiple = G.localization.descriptions.Other["fac_mf_fishion_reactor_multiple"].text
        -- collate them so we dont go off screen
        local counts = {}
        local order = {} -- :p
        for _, odds in ipairs(ability.fac_mf_fishion_reactor) do
            if not counts[odds] then
                counts[odds] = 0
                order[#order + 1] = odds
            end
            counts[odds] = counts[odds] + 1
        end

        for _, odds in ipairs(order) do
            PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
                {
                    localized_text = counts[odds] <= 1 and desc_text or desc_text_multiple,
                    loc_vars = function(self, card, center)
                        local new_numerator, new_denominator =
                            SMODS.get_probability_vars(card, 1, odds, "fac_mf_fishion_reactor")
                        return { vars = { new_numerator, new_denominator, counts[odds] } }
                    end
                }
            })(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
        end
    end

    if ability and ability.fac_mf_the_sole then
        local desc_text = G.localization.descriptions.Other["fac_mf_fishion_reactor"].text -- Its the same thing lol
        local desc_text_multiple = G.localization.descriptions.Other["fac_mf_fishion_reactor_multiple"].text
        -- collate them so we dont go off screen
        local counts = {}
        local order = {} -- :p
        for _, odds in ipairs(ability.fac_mf_the_sole) do
            if not counts[odds] then
                counts[odds] = 0
                order[#order + 1] = odds
            end
            counts[odds] = counts[odds] + 1
        end

        for _, odds in ipairs(order) do
            PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
                {
                    localized_text = counts[odds] <= 1 and desc_text or desc_text_multiple,
                    loc_vars = function(self, card, center)
                        local new_numerator, new_denominator =
                            SMODS.get_probability_vars(card, 1, odds, "fac_mf_the_sole")
                        return { vars = { new_numerator, new_denominator, counts[odds] } }
                    end
                }
            })(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
        end
    end

    if ability and ability.fac_mf_gold_pearl then
        local desc_text = G.localization.descriptions.Other["fac_mf_car_battery"].text
        local desc_text_multiple = G.localization.descriptions.Other["fac_mf_car_battery_multiple"].text
        -- collate them so we dont go off screen
        local counts = {}
        local order = {} -- :p
        for _, odds in ipairs(ability.fac_mf_gold_pearl) do
            local key = odds[1] .. "_" .. odds[2]
            if not counts[key] then
                counts[key] = 0
                order[#order + 1] = odds
            end
            counts[key] = counts[key] + 1
        end

        for _, odds in ipairs(order) do
            local num, den = odds[1], odds[2]
            local key = odds[1] .. "_" .. odds[2]
            PotatoPatchUtils.Developers.fac_notmario.generate_ui_multiboxes({
                {
                    localized_text = counts[key] <= 1 and desc_text or desc_text_multiple,
                    loc_vars = function(self, card, center)
                        local new_numerator, new_denominator =
                            SMODS.get_probability_vars(card, num, den, "fac_mf_gold_pearl")
                        return { vars = { new_numerator, new_denominator, counts[key] } }
                    end
                }
            })(_c, info_queue, other_card, desc_nodes, specific_vars, full_UI_table)
        end
    end

	for _, other_card in ipairs(G.fac_fish_area.cards) do
        if other_card.config.center.fac_mf_add_multibox then
            other_card.config.center.fac_mf_add_multibox(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table, ability, other_card)
        end
    end
end

function PotatoPatchUtils.Developers.fac_notmario.calculate_extra_effects(card, context, jokers, triggered)
    if not G.fac_fish_area then return jokers, triggered end

    if card.ability and card.ability.fac_mf_sap_chips or card.ability.fac_mf_sap_mult then
        if context.joker_main then
            if not jokers then jokers = {} end
            jokers = SMODS.merge_effects({ jokers, {
                chips = card.ability.fac_mf_sap_chips,
                mult = card.ability.fac_mf_sap_mult
            }})
        end
    end

    if card.ability and card.ability.fac_mf_car_battery then
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == (context.blueprint_card or card) then
            if not jokers then jokers = {} end
            jokers = SMODS.merge_effects({ jokers, { repetitions = #card.ability.fac_mf_car_battery }})
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.retrigger_joker_check and not context.blueprint then
            for _, odds in ipairs(card.ability.fac_mf_car_battery) do
                if SMODS.pseudorandom_probability(card, 'fac_mf_car_battery', 1, odds) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_zapped_ex'), colour = G.C.YELLOW})
                    break
                end
            end
        end
    end

    if card.ability and card.ability.fac_mf_fishion_reactor then
        if context.end_of_round and context.game_over == false and context.main_eval and not context.retrigger_joker_check and not context.blueprint then
            for _, odds in ipairs(card.ability.fac_mf_fishion_reactor) do
                if SMODS.pseudorandom_probability(card, 'fac_mf_fishion_reactor', 1, odds) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_exploded_ex'), colour = G.C.RED})
                    break
                end
            end
        end
    end

    if card.ability and card.ability.fac_mf_the_sole then
        if context.end_of_round and context.game_over == false and context.main_eval and not context.retrigger_joker_check and not context.blueprint then
            for _, odds in ipairs(card.ability.fac_mf_the_sole) do
                if SMODS.pseudorandom_probability(card, 'fac_mf_the_sole', 1, odds) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_lost_ex'), colour = darken(G.C.GREEN, 0.2)})
                    break
                end
            end
        end
    end

    if card.ability and card.ability.fac_mf_frying_fish then
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == (context.blueprint_card or card) then
            if not jokers then jokers = {} end
            jokers = SMODS.merge_effects({ jokers, { repetitions = card.ability.fac_mf_frying_fish }})
        end
    end

    if card.ability and card.ability.fac_mf_gold_pearl then
		if context.retrigger_joker_check and not context.retrigger_joker and context.other_card == (context.blueprint_card or card) then
            if not jokers then jokers = {} end
            jokers = SMODS.merge_effects({ jokers, { repetitions = #card.ability.fac_mf_gold_pearl }})
        end
        if context.end_of_round and context.game_over == false and context.main_eval and not context.retrigger_joker_check and not context.blueprint then
            for _, odds in ipairs(card.ability.fac_mf_gold_pearl) do
                if SMODS.pseudorandom_probability(card, 'fac_mf_gold_pearl', odds[1], odds[2]) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_lost_ex'), colour = G.C.RED})
                    break
                end
            end
        end
    end


	for _, other_card in ipairs(G.fac_fish_area.cards) do
        if other_card.config.center.fac_mf_add_extra_effect then
            jokers, triggered = other_card.config.center.fac_mf_add_extra_effect(card, context, jokers, triggered, other_card)
        end
    end

	-- hookable and shii 2
	return jokers, triggered
end

local card_calculate_joker = Card.calculate_joker
function Card:calculate_joker(context, ...)
	local jokers, triggered = card_calculate_joker(self, context, ...)

	return PotatoPatchUtils.Developers.fac_notmario.calculate_extra_effects(self, context, jokers, triggered)
end
