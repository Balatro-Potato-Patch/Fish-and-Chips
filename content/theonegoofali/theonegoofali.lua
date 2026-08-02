-- We went to this café, and I had loads to eat. I had cod and chips. The cod was huge and there was
-- hundreds of chips, hundreds and hundreds of them, and I ate the lot! - "The Hollywood", Michael Rosen

-- Registering in the database...
local sfx_toga_thing = {}
PotatoPatchUtils.Developer({
	name = 'theonegoofali',
	atlas = 'fac_theonegoofali_credits',
	colour = G.C.ORANGE,
	loc = true,
	click = function()
		if sfx_toga_thing[1] then
			play_sound(sfx_toga_thing[math.random(1, #sfx_toga_thing)], 1, 0.35)
		end
	end,
})

-- Assets...
SMODS.Atlas({
	key = "theonegoofali_credits",
	path = "theonegoofali/toga_credits.png",
	px = 71,
	py = 95,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_fish",
	path = "theonegoofali/toga_fish.png",
	px = 52,
	py = 95,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_ad_blue_tanger",
	path = "theonegoofali/toga_afterdark_blue_tanger.png",
	px = 53,
	py = 108,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_ad_butterfly",
	path = "theonegoofali/toga_afterdark_butterfly.png",
	px = 71,
	py = 84,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_ad_emperor",
	path = "theonegoofali/toga_afterdark_emperor.png",
	px = 55,
	py = 101,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_ad_pinksquirrel",
	path = "theonegoofali/toga_afterdark_pinksquirrel.png",
	px = 52,
	py = 113,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_ad_red_clown",
	path = "theonegoofali/toga_afterdark_red_clown.png",
	px = 60,
	py = 86,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_ad_trigger",
	path = "theonegoofali/toga_afterdark_trigger.png",
	px = 66,
	py = 114,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_ad_yellow_tang",
	path = "theonegoofali/toga_afterdark_yellow_tang.png",
	px = 68,
	py = 89,
	disable_mipmap = true
})

SMODS.Atlas({
	key = "theonegoofali_thefish",
	path = "theonegoofali/toga_thefish.png",
	px = 64,
	py = 64,
	disable_mipmap = true
})

SMODS.Sound({key = "toga_fish", path = "theonegoofali/fish.ogg"})
SMODS.Sound({key = "toga_fishreverse", path = "theonegoofali/fishreverse.ogg"})

for _, v in ipairs({ "chimes", "chord", "comedy", "dialog-error", "dialog-question", "dialog-warning", "ding", "Indigo", "Laugh", "Wild-Eep" }) do
	local k = string.lower(v)
	SMODS.Sound({ key = "toga_"..k, path = "theonegoofali/TOGAClick/toga_"..v..".ogg" })
	table.insert(sfx_toga_thing, "fac_toga_"..k)
end

-- The Fishing Entries.
local fishregistry = {}
table.insert(fishregistry, {
	key = "theonegoofali_thefish",
	atlas = "theonegoofali_fish",
	pos = { x = 0, y = 0 },
	weight = 11,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	config = { extra = { odds = 4 } },
	loc_vars = function(self, info_queue, card)
		local num, den = SMODS.get_probability_vars(card or self, 1, (card.ability.extra or self.config.extra).odds)
		return {
			vars = {
				num, den,
				elements = { SMODS.create_sprite(0, 0, 0.5, 0.5, 'fac_theonegoofali_thefish', { x = 0, y = 0 } ) }
			}
		}
	end,
	attributes = { "usable", "editions", "chance" },
	environments = {
		wormhole = 5,
		soup = 5,
		calm_pond = 1
	},
	blueprint_compat = false,
	can_use = function(self, card)
		for k, v in pairs((G.fac_fish_area or {}).cards) do
			if v and not v.edition then return true end
		end
		return false
	end,
	use = function(self, card, area)
		if SMODS.pseudorandom_probability(card, "fac_toga_thefish", 1, card.ability.extra.odds, 'fac_toga_thefish') then
			local ef = {}
			for k, v in ipairs((G.fac_fish_area or {}).cards) do
				if v and not v.edition then table.insert(ef, v) end
			end
			if next(ef) then
				local sf = pseudorandom_element(ef, pseudoseed('fac_sebastesnorvegicus'))
				if sf then
					sf:set_edition(SMODS.poll_edition({ guaranteed = true }))
					play_sound("fac_toga_fish")
				end
			end
		else
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
				attention_text({
					text = localize('k_nope_ex'),
					scale = 1.3, 
					hold = 1.4,
					major = card,
					backdrop_colour = G.C.SECONDARY_SET.Tarot,
					align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and 'tm' or 'cm',
					offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and -0.2 or 0},
					silent = true
				})
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
					play_sound('tarot2', 0.76, 0.4);return true end}))
				play_sound('tarot2', 1, 0.4)
				card:juice_up(0.3, 0.5)
			return true end }))
			delay(0.2)
		end
		card.ability.extra.used = true
	end,
	add_to_deck = function(self, card, from_debuff)
		if not from_debuff and not G.screenwipe then
			play_sound("fac_toga_fish")
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		if not from_debuff and not G.screenwipe and not card.ability.extra.used then
			play_sound("fac_toga_fishreverse")
		end
	end,
	blueprint_compat = false,
	display_size = { w = 52, h = 95 },
	stats = { weight = { min = 3.6, max = 15 }, length = { min = 0.38, max = 1 } }
})

table.insert(fishregistry, {
	key = "theonegoofali_blue_tanger",
	atlas = "theonegoofali_ad_blue_tanger",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	attributes = { "passive" },
	environments = {
		swamp = 4,
		aquifer = 4,
	},
	blueprint_compat = false,
	config = { extra = { cmult = 1.5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { (card.ability or self.config).extra.cmult } }
	end,
	display_size = { w = 53, h = 108 },
	stats = { weight = { min = 0.5, max = 0.75 }, length = { min = 0.12, max = 0.38 } }
})

table.insert(fishregistry, {
	key = "theonegoofali_butterfly",
	atlas = "theonegoofali_ad_butterfly",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	attributes = { "passive" },
	environments = {
		wormhole = 5,
		soup = 3,
		city_river = 2,
		pier = 5
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_strength
	end,
	calculate = function(self, card, context)
		if context.retrigger_joker then return end
		
		if context.fac_toga_modify_rank and tonumber(context.amount) then return { amount = context.amount + 1 } end
	end,
	display_size = { w = 71, h = 84 },
	stats = { weight = { min = 0.45, max = 1 }, length = { min = 0.07, max = 0.3 } }
})

table.insert(fishregistry, {
	key = "theonegoofali_emperor",
	atlas = "theonegoofali_ad_emperor",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	attributes = { "usable", "generation", "tarot" },
	environments = {
		city_river = 4,
		garden = 4,
		calm_pond = 4
	},
	config = { extra = { tarots = 2 } },
	loc_vars = function(self, info_queue, card)
		local _, emptxt = pcall(function() return localize({type = 'name_text', set = 'Tarot', key = 'c_emperor'}) end)
		return { vars = { (card.ability or self.config).extra.tarots, emptxt or "The Emperor" } }
	end,
	blueprint_compat = false,
	can_use = function(self, card)
		return G.consumeables and G.consumeables.cards and #G.consumeables.cards < G.consumeables.config.card_limit
    end,
	use = function(self, card, area)
		for i = 1, math.min(card.ability.extra.tarots, G.consumeables.config.card_limit - #G.consumeables.cards) do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.4,
				func = function()
					if G.consumeables.config.card_limit > #G.consumeables.cards then
						play_sound('timpani')
						SMODS.add_card({ set = 'Tarot', key_append = "fac_toga_emp" })
						card:juice_up(0.3, 0.5)
					end
					return true
				end
			}))
		end
		delay(0.6)
	end,
	display_size = { w = 55, h = 101 },
	stats = { weight = { min = 0.45, max = 1.36 }, length = { min = 0.2, max = 0.4 } }
})

table.insert(fishregistry, {
	key = "theonegoofali_pinksquirrel",
	atlas = "theonegoofali_ad_pinksquirrel",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	attributes = { "passive", "hand_type" },
	environments = {
		wormhole = 2,
		soup = 2,
		calm_pond = 5
	},
	blueprint_compat = false,
	loc_vars = function(self, info_queue, card)
		return { vars = { localize('Straight', "poker_hands") } }
	end,
	display_size = { w = 52, h = 113 },
	stats = { weight = { min = 0.02, max = 0.15 }, length = { min = 0.07, max = 0.31 } }
})

table.insert(fishregistry, {
	key = "theonegoofali_red_clown",
	atlas = "theonegoofali_ad_red_clown",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	attributes = { "mult", "face" },
	environments = {
		volcano = 5,
		soup = 5,
	},
	config = { extra = { mult = 15 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { SMODS.signed((card.ability or self.config).extra.mult) } }
	end,
	calculate = function(self, card, context)
		if context.initial_scoring_step then return { mult = card.ability.extra.mult } end
		
		if context.retrigger_joker or context.blueprint then return end
		
		if context.debuff_hand then
			local db = true
			for k, v in pairs(context.scoring_hand or {}) do
				if v and v:is_face() then db = false; break end
			end
			if db then
				return { debuff = true, debuff_text = localize('fac_toga_red_clown_debuff'), debuff_source = card }
			end
		end
	end,
	display_size = { w = 60, h = 86 },
	stats = { weight = { min = 0.2, max = 0.3 }, length = { min = 0.13, max = 0.17 } }
})

table.insert(fishregistry, {
	key = "theonegoofali_trigger",
	atlas = "theonegoofali_ad_trigger",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	attributes = { "xmult" },
	environments = {
		styx = 3,
		garden = 4,
	},
	config = { extra = { xmult = 1.25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { (card.ability or self.config).extra.xmult } }
	end,
	calculate = function(self, card, context)
		if (context.other_unknown and context.other_unknown.ability.set == 'fac_Fish') then return { xmult = card.ability.extra.xmult } end
	end,
	display_size = { w = 66, h = 114 },
	stats = { weight = { min = 0.45, max = 2.7 }, length = { min = 0.07, max = 0.27 } }
})

table.insert(fishregistry, {
	key = "theonegoofali_yellow_tang",
	atlas = "theonegoofali_ad_yellow_tang",
	pos = { x = 0, y = 0 },
	weight = 8,
	ppu_coder = { "theonegoofali" },
	ppu_artist = { "theonegoofali" },
	attributes = { "passive", "enhancements", "hand_type" },
	environments = {
		city_river = 6,
		soup = 4,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
		return { vars = { localize('Flush', "poker_hands") } }
	end,
	blueprint_compat = false,
	display_size = { w = 68, h = 89 },
	stats = { weight = { min = 0.2, max = 0.45 }, length = { min = 0.14, max = 0.21 } }
})

for k, v in ipairs(fishregistry) do
	if not v.stats then v.stats = { weight = { min = 1, max = 1 }, length = { min = 1, max = 1 } } end -- fallback so that the game doesn't crash.
	FishAndChips.Fish(v)
end

-- Other stuff.
sendInfoMessage("Hooking SMODS.modify_rank...", "Fish and Chips - TheOneGoofAli")
local modifyrankref = SMODS.modify_rank
function SMODS.modify_rank(card, amount, manual_sprites)
	local facbtrflycalc = {}
	SMODS.calculate_context({ fac_toga_modify_rank = true, amount = amount }, facbtrflycalc)
	for _, eval in pairs(facbtrflycalc) do
		for key, eval2 in pairs(eval) do
			if eval2.amount then amount = eval2.amount end
		end
	end
	return modifyrankref(card, amount, manual_sprites)
end

sendInfoMessage("Hooking SMODS.wrap_around_straight...", "Fish and Chips - TheOneGoofAli")
local wasref = SMODS.wrap_around_straight
function SMODS.wrap_around_straight()
	if next(SMODS.find_card('fish_fac_theonegoofali_pinksquirrel')) then return true end
	return wasref()
end

sendInfoMessage("Hooking Card:get_chip_bonus...", "Fish and Chips - TheOneGoofAli")
local cgcbref = Card.get_chip_bonus
function Card:get_chip_bonus()
	local bonus, bt = cgcbref(self), SMODS.find_card('fish_fac_theonegoofali_blue_tanger')
	for k, v in ipairs(bt) do
		bonus = bonus*(v and v.ability and v.ability.extra and v.ability.extra.cmult or 1)
	end
    return bonus
end

sendInfoMessage("Hooking get_flush...", "Fish and Chips - TheOneGoofAli")
local getflushref = get_flush
function get_flush(hand)
	local ret = getflushref(hand)
	if next(ret) then return ret end
	
	if not next(SMODS.find_card('fish_fac_theonegoofali_yellow_tang')) then return {} end
	
	ret = {}
	local four_fingers = SMODS.four_fingers('flush')
	if #hand < four_fingers then return ret
	else
		local t = {}
		local gold_count = 0
		for i=1, #hand do
			if SMODS.has_enhancement(hand[i], 'm_gold') then gold_count = gold_count + 1; t[#t+1] = hand[i] end
		end
		if gold_count >= four_fingers then
			table.insert(ret, t)
			return ret
		end
		return {}
	end
end