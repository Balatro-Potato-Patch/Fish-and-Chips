G.PROFILES[G.SETTINGS.profile].fac_tutorial_seen = G.PROFILES[G.SETTINGS.profile].fac_tutorial_seen or false

SMODS.Joker({
	key = "mack",
	in_pool = function(self, args)
		return false
	end,
	atlas = "cards",
	no_collection = true,
	loc_txt = {
		name = "Mack",
		text = {
			"{C:red}INTERNAL JOKER",
			"{C:red}USED FOR TUTORIAL",
			"{C:red}PURPOSES ONLY",
		},
	},
})

function FishAndChips.tutorial()
	if G.PROFILES[G.SETTINGS.profile].fac_tutorial_seen then
		return
	end
	G.SETTINGS.tutorial_progress = { this_just_needs_to_exist = true }
	G.PROFILES[G.SETTINGS.profile].fac_tutorial_seen = true
	FishAndChips.in_tutorial = true
	G.SETTINGS.paused = true
	local step = 1
	step = tutorial_info({
		text_key = "fac_fishing_1a",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_1b",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_1c",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_1d",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_2a",
		attach = {
			major = G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_go_fish"),
			type = "cm",
			offset = { x = -3, y = 0 },
		},
		highlight = { G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_go_fish") },
		align = "cl",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_2b",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_2c",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_2d",
		attach = {
			major = G.FISHING.fishing_bait_inventory,
			type = "cm",
			offset = { x = 0, y = 2 },
		},
		highlight = { G.FISHING.fishing_bait_inventory },
		align = "cr",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_2e",
		attach = {
			major = G.FISHING.fishing_bait_inventory,
			type = "cm",
			offset = { x = 0, y = 2 },
		},
		highlight = { G.FISHING.fishing_bait_inventory },
		align = "cr",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_3a",
		attach = {
			major = G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_open_bait_shop"),
			type = "cm",
			offset = { x = -3, y = 0 },
		},
		highlight = { G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_open_bait_shop") },
		align = "cl",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_3b",
		attach = {
			major = G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_open_bait_shop"),
			type = "cm",
			offset = { x = -3, y = 0 },
		},
		highlight = { G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_open_bait_shop") },
		align = "cl",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_4a",
		attach = {
			major = G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_reroll_location"),
			type = "cm",
			offset = { x = -3, y = 0 },
		},
		highlight = { G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_reroll_location") },
		align = "cl",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_4b",
		attach = {
			major = G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_reroll_location"),
			type = "cm",
			offset = { x = -3, y = 0 },
		},
		highlight = { G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_reroll_location") },
		align = "cl",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_5",
		attach = {
			major = G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_toggle_fishing"),
			type = "cm",
			offset = { x = -3, y = 0 },
		},
		highlight = { G.FISHING.fishing_buttons:get_UIE_by_ID("fac_btn_toggle_fishing") },
		align = "cl",
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_6a",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_6b",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_6c",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	step = tutorial_info({
		text_key = "fac_fishing_7",
		attach = { major = G.ROOM_ATTACH, type = "cm", offset = { x = 0, y = 0 } },
		step = step,
		fac_tutorial = true,
	})
	G.E_MANAGER:add_event(
		Event({
			blockable = false,
			timer = "REAL",
			func = function()
				if
					(G.OVERLAY_TUTORIAL.step == step and not G.OVERLAY_TUTORIAL.step_complete)
					or G.OVERLAY_TUTORIAL.skip_steps
				then
					if G.OVERLAY_TUTORIAL.Jimbo then
						G.OVERLAY_TUTORIAL.Jimbo:remove()
					end
					if G.OVERLAY_TUTORIAL.content then
						G.OVERLAY_TUTORIAL.content:remove()
					end
					G.OVERLAY_TUTORIAL:remove()
					G.OVERLAY_TUTORIAL = nil
					FishAndChips.in_tutorial = nil
					check_for_unlock({ type = 'fac_tutorial' })
					return true
				end
				return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
			end,
		}),
		"tutorial"
	)
	G.SETTINGS.paused = false
end

local skip_tutorial_hook = G.FUNCS.skip_tutorial_section
function G.FUNCS.skip_tutorial_section(e)
	skip_tutorial_hook(e)
	if FishAndChips.in_tutorial then check_for_unlock({ type = 'fac_tutorial' }) end
	FishAndChips.in_tutorial = nil
end
