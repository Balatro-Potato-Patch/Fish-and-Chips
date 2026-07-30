-- Because there's literally no intented ways to get fish card when it caught, I added my own
local old_smods_add_card = SMODS.add_card
function SMODS.add_card(arg, ...)
	local r = old_smods_add_card(arg, ...)
	if r then
		if G.FISHING and arg.area and arg.area == G.FISHING.fac_fish_reward_area then
			SMODS.calculate_context({ fac_fishing_reward_reveal = true, fac_reward_card = r })
		end
	end
	return r
end
