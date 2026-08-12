FishAndChips.Fish {
	key = "fo_cij",
	atlas = "fo_fish",
	pos = { x = 7, y = 0 },
    pixel_size = { w = 48, h = 32 },
	weight = 8,
	disable_visual_scaling = true,
    blueprint_compat = false,
	ppu_coder = { "fo_alexi" },
	ppu_artist = { "fo_alexi" },
	attributes = { "passive", "hand_type" },
	config = {
		extra = {
			rerolls = 4,
            remaining = 4,
            old_remaining = 4,
		},
	},
    cost = 5,
	environments = {
		backroom = 1,
		city_river = 1,
	},
	stats = {
		weight = {min = 5, max = 5, units = {format = "fac_fo_cij_weight", scale = 1, precision = 1}},
		length = {min = 3, max = 3, units = {format = "fac_fo_cij_length", scale = 1, precision = 1}},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { localize("poker_hands", "Straight") } }
	end,
}

local gs = get_straight
function get_straight(hand, min_length, skip, wrap, ...)
    local ret = gs(hand, min_length, skip, wrap, ...)

    if #SMODS.find_card("fish_fac_fo_cij") > 0 then
        local twos = {}
        local fours = {}
        local jacks = {}
        for _, card in ipairs(hand) do
            if card:get_id() == 2 then
                twos[#twos+1] = card
            elseif card:get_id() == 4 then
                fours[#fours+1] = card
            elseif card:get_id() == 11 then
                jacks[#jacks+1] = card
            end
        end

        -- someone please optimize this shit :sob:
        if #twos > 0 and #fours > 0 and #jacks > 0 then
            for _, two in ipairs(twos) do
                for _, four in ipairs(fours) do
                    for _, jack in ipairs(jacks) do
                        ret[#ret+1] = { two, four, jack }
                    end
                end
            end
        end
    end

    return ret
end