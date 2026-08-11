PotatoPatchUtils.Developer({
	name = 'cheekyrotter',
	atlas = 'fac_cards',
	colour = G.C.RED,
	fac_partner = 'EDriGO'
})

PotatoPatchUtils.Developer({
	name = 'EDriGO',
	atlas = 'fac_cards',
	pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'cheekyrotter'
})

SMODS.Atlas({
	key = "delrice_fish", -- Please include your name/team name in your atlas keys
	path = "DeliciousRice/fish.png",
	px = 71,
	py = 95,
})

SMODS.Sound({
	key = "delrice_instakill",
	path = "DeliciousRice/instakilled.ogg"
})

FishAndChips.DeliciousRice = {}
FishAndChips.DeliciousRice.SB_envs = {
	"calm_pond",
	"styx",
	"pier",
	"aquifer",
	"city_river",
	"garden",
	"backroom"
}

FishAndChips.DeliciousRice.valid_SB_env = function(key)
	for i, v in ipairs(FishAndChips.DeliciousRice.SB_envs) do
		if v == key then return true end
	end
	return false
end

local flip_ref = Card.flip
function Card:flip()
	local ret = flip_ref(self)
	SMODS.calculate_context({card_flipped = true})
	return ret
end

local emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
	FishAndChips.DeliciousRice.emplacing = true
	emplace_ref(self, card, location, stay_flipped)
	FishAndChips.DeliciousRice.emplacing = false
end

local draw_ref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
	FishAndChips.DeliciousRice.bad_flip = false
	if to == G.deck or to == G.discard or from == G.play then 
		FishAndChips.DeliciousRice.bad_flip = true
	end
	local ret = draw_ref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
	return ret
end

local play_cards_ref = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
	FishAndChips.DeliciousRice.in_hand = true
	local ret = play_cards_ref(e)
	return ret
end

local to_discard_ref = G.FUNCS.draw_from_play_to_discard
function G.FUNCS.draw_from_play_to_discard()
	local ret = to_discard_ref()
	FishAndChips.DeliciousRice.in_hand = false
	return ret
end

local bucket_ref = G.FUNCS.fac_open_fishing_menu
function G.FUNCS.fac_open_fishing_menu(e)
	if FishAndChips.DeliciousRice.bucket_locked then return end
	return bucket_ref(e)  
end