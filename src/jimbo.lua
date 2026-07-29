FishAndChips.JIMBO_ANIMATION_STATES = {
	IDLE = 0,
	CAST = 1,
	WAIT = 2,
	BITE = 3,
	REEL = 4
}

--- Jimbo's animation loop
--- @param new_state integer see FishAndChips.JIMBO_ANIMATION_STATES for valid inputs
function FishAndChips.update_jimbo_state (new_state)
	if G.FAC_JIMBO_ANIMATION_STATE == new_state then return end
	G.FAC_JIMBO_ANIMATION_STATE = new_state
	FishAndChips.draw_jimbo(FishAndChips.get_environment())
end

for i = 1, 5 do
	SMODS.Atlas{
		key = "jibmo_" .. i, -- this was a typo but its funy
		path = "core/fisher.png",
		px = 183,
		py = 199,
		atlas_table = "ANIMATION_ATLAS",
		frames = ({4, 2, 4, 4, 3})[i],
		FPS = ({2, 5, 1, 7, 6})[i]
	}
end

--- Creates Jimbo's sprite
--- @return table|Sprite|AnimatedSprite
function FishAndChips.create_jimbo()
	return SMODS.create_sprite(0, 0, G.CARD_W / 71 * 183 * 1.232, G.CARD_H / 95 * 199 * 1.232, "fac_jibmo_" .. ((G.FAC_JIMBO_ANIMATION_STATE or 0) + 1), {x = 0, y = G.FAC_JIMBO_ANIMATION_STATE})
end

function FishAndChips.draw_jimbo(env)
	if G.FISHING.jimbo then
		G.FISHING.jimbo:remove()
	end
	local jimbo = FishAndChips.create_jimbo()
	G.FISHING.jimbo = UIBox{
		definition = {n = G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes = {
			{n = G.UIT.O, config = {object = jimbo}}
		}},
		config = {
			major = G.FISHING.fishing,
			align = "bli",
			bond = "Glued",
			offset = env.jimbo_offset or {
				x = 0.1,
				y = -1.74
			}
		}
	}
	for index, box in ipairs(G.I.UIBOX) do
		if box == G.FISHING.jimbo then
			table.remove(G.I.UIBOX, index)
			break
		end
	end
	for index, box in ipairs(G.I.UIBOX) do
		if box == G.FISHING.fac_fishing_reward_box then
			table.insert(G.I.UIBOX, index, G.FISHING.jimbo)
			break
		end
	end
end