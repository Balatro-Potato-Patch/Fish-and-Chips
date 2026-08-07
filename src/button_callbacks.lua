function G.FUNCS.fac_open_fishing_menu (e)
	if (G.STATE == G.STATES.HAND_PLAYED) or G.GAME.fac_booster_opening then return end
	if G.STATE == G.STATES.FAC_FISHING and G.FISHING_STATE ~= G.FISHING_STATES.RESULTS and (G.FISHING_STATE ~= G.FISHING_STATES.LOBBY or (G.FAC_FISH_GAME and G.FAC_FISH_GAME.fishing_active)) then return end
	if not G.GAME.fac_fish_expanded and not G.fac_fish_area.cards[1] then
		return card_eval_status_text(G.fac_fishing_bucket_bottom, 'extra', nil, nil, nil, {message = localize('k_fac_empty'), instant = true})
	end
	G.GAME.fac_fish_expanded = not G.GAME.fac_fish_expanded
	G.fac_fish_area:unhighlight_all()
	if G.GAME.fac_fish_expanded then G.fac_fishing_bucket_bottom.T.r = 0; ease_value(G.fac_fishing_bucket_bottom.T, "r", -math.pi / 2, nil, nil, true)
	else G.fac_fishing_bucket_bottom.T.r = -math.pi / 2; ease_value(G.fac_fishing_bucket_bottom.T, "r", math.pi / 2, nil, nil, true) end
	-- desired offset is 5, the extra 1 comes from moving the hand down (done in fish_shop.toml)
	--[[if G.shop then
		if G.GAME.fac_fish_expanded then G.shop.alignment.offset.y = G.shop.alignment.offset.y + 4
		else G.shop.alignment.offset.y = G.shop.alignment.offset.y - 4 end
	end
	if G.round_eval then
		if G.GAME.fac_fish_expanded then G.round_eval.alignment.offset.y = G.round_eval.alignment.offset.y + 4
		else G.round_eval.alignment.offset.y = G.round_eval.alignment.offset.y - 4 end
	end
	if G.blind_select then
		if G.GAME.fac_fish_expanded then G.blind_select.alignment.offset.y = G.blind_select.alignment.offset.y + 4
		else G.blind_select.alignment.offset.y = G.blind_select.alignment.offset.y - 4 end
	end---]]
end

function G.FUNCS.fac_reroll_location (e)
	if G.FISHING_STATE == G.FISHING_STATES.LOBBY and not FishAndChips.in_tutorial then
		ease_dollars(-5)
		FishAndChips:stop_ambience()
		local old_env = G.GAME.fac_fishing_environment
		G.GAME.fac_fishing_environment = G.GAME.fac_next_environment or pseudorandom_element(FishAndChips.Environments, "fac_next_location", {
			in_pool = function (v, args)
				return v.key ~= G.GAME.fac_fishing_environment
			end
		}).key
		SMODS.calculate_context{fac_environment_changed = G.GAME.fac_fishing_environment, old_environment = old_env, forced = G.GAME.fac_next_environment and true}
		if G.GAME.fac_next_environment then G.GAME.fac_next_environment = nil end
		G.FISHING_STATE = G.FISHING_STATES.MOVING
		G.FISHING_STATE_COMPLETE = false
	end
end

local g_funcs_deck_info_ref = G.FUNCS.deck_info
---@diagnostic disable-next-line: duplicate-set-field
function G.FUNCS.deck_info(...)
	if not FishAndChips.safe_to_press_buttons() then return end
	return g_funcs_deck_info_ref(...)
end

function G.FUNCS.fac_toggle_ambience(e)
	if not e then
		FishAndChips.stop_ambience()
	end
end
