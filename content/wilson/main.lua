local wilson_colour = SMODS.Gradient{
    key = "wilson_colour",
    cycle = 60,
    colours = {
        G.C.GOLD,
        lighten(G.C.PURPLE, 0.2),
    }
}

PotatoPatchUtils.Developer({
	name = 'wilson',
	atlas = 'fac_wilson_credit',
    colour = wilson_colour,
    loc = "d_fac_wilson",
})

SMODS.Atlas({
	key = "wilson_fish",
	path = "wilson/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
	key = "wilson_credit",
	path = "wilson/credit.png",
	px = 71,
	py = 95,
})

FishAndChips.Fish {
	key = "wilson_measuring_tape",
	ppu_coder = { "wilson" },
	attributes = { "xmult", "scaling" },
	weight = 1,
	atlas = "wilson_fish",
	pos = { x = 1, y = 0 },
	pixel_size = { w = 68, h = 46 },
	config = {
		extra = {
			xmult = 1,
			mod = 0.2,
			percent = .25,
		}
	},
	environments = {
		garden = 10,
		wormhole = 3,
		backroom = 3,
	},
	stats = {
		weight = {min = 0.005, max = 0.20},
		length = {min = 0.15, max = 1}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.mod } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then return { xmult = card.ability.extra.xmult } end
		if context.setting_blind and not context.blueprint then
			local my_pos = nil
			for i = 1, #G.fac_fish_area.cards do
				if G.fac_fish_area.cards[i] == card then
					my_pos = i
					break
				end
			end
			if my_pos and G.fac_fish_area.cards[my_pos + 1] then
				local sliced_card = G.fac_fish_area.cards[my_pos + 1]
				local mod = 0
				local extra = nil
				local stats = sliced_card.ability.stats or { weight = 0, height = 0}
				local myStats = card.ability.stats
				local weight_mod = 0
				local length_mod = 0
				if stats.weight > myStats.weight then
					mod = mod + card.ability.extra.mod
					weight_mod = stats.weight * card.ability.extra.percent
					if myStats.weight + weight_mod > stats.weight then
						weight_mod = stats.weight - card.ability.stats.weight
					end
					extra = { message = "+" .. FishAndChips.format_measurement(weight_mod, 'weight', stats.units) }
				end
				if stats.length > myStats.length then
					mod = mod + card.ability.extra.mod
					length_mod = stats.length * card.ability.extra.percent
					if myStats.length + length_mod > stats.length then
						length_mod = stats.length - card.ability.stats.length
					end
					local nextra = { message = "+" .. FishAndChips.format_measurement(length_mod, 'length', stats.units) }
					if extra then
						extra.extra = nextra
					else
						extra = nextra
					end
				end
				if mod > 0 then
					card.ability.extra.xmult = card.ability.extra.xmult + mod
					myStats.weight = myStats.weight + weight_mod
					myStats.length = myStats.length + length_mod
					return {
						message = localize { type = 'variable', key = 'a_xmult', vars = { mod } },
						colour = G.C.RED,
						extra = extra,
					}
				end
			end
		end
	end,
}

FishAndChips.Fish {
	key = "wilson_mug",
	ppu_coder = { "wilson" },
	attributes = { "xmult", "scaling" },
	atlas = "wilson_fish",
	pos = { x = 0, y = 0 },
	pixel_size = { w = 69, h = 55 },
	weight = 1,
	badge_key = "k_fac_maybe_fish",
	environments = {
		wormhole = 10,
	},
	stats = {
		weight = {min = 0.25, max = 0.6},
		length = {min = 0.10, max = 0.20}
	},
	calculate = function(self, card, context)
		if context.modify_scoring_hand then
			if next(SMODS.find_card"j_splash") then return { remove_from_hand = true } end -- Doesn't play nice by default
			local c = context.other_card
			local scoring = false
			for _, v in ipairs(context.scoring_hand) do
				if c == v then scoring = true break end
			end
			if scoring then return { remove_from_hand = true } end
			return { add_to_hand = true }
		end
	end,
}

