FishAndChips.FooSqueax = {
	file_path = "Foo&Squeax/",
	fat_chud = {
		active = false,
		state = 0,
		timer = nil,
		fih = nil
	}
}

SMODS.Atlas{
	key = "fas_credits_foo",
	path = FishAndChips.FooSqueax.file_path .. "credits/foo.png",
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = "fas_credits_sqx",
	path = FishAndChips.FooSqueax.file_path .. "credits/gabby.png",
	px = 71,
	py = 95,
}

SMODS.Atlas{
	key = "fas_fish_general",
	path = FishAndChips.FooSqueax.file_path .. "fish.png",
	px = 71,
	py = 95
}

PotatoPatchUtils.Developer{
	name = "Foo54",
	atlas = "fac_fas_credits_foo",
	colour = HEX("ED5B5B"),
	fac_partner = "squeax09",
	loc = true
}

PotatoPatchUtils.Developer{
	name = "squeax09",
	atlas = "fac_fas_credits_sqx",
	pixel_size = {w = 66, h = 80},
	colour = HEX("c551bd"),
	fac_partner = "Foo54",
	loc = true
}

FishAndChips.mod.optional_features = FishAndChips.mod.optional_features or {}
FishAndChips.mod.optional_features.retrigger_joker = true

local fishandchips_mod_reset_game_globals_ref = FishAndChips.mod.reset_game_globals
---@diagnostic disable-next-line: duplicate-set-field
function FishAndChips.mod.reset_game_globals (run_start)
---@diagnostic disable-next-line: need-check-nil
	fishandchips_mod_reset_game_globals_ref(run_start)
	if run_start then
		G.GAME.fac_FooSqueax = {
			bucket = {
				on = false,
				water_height = 1
			},
			wormholes = {}
		}
	end
	G.GAME.fac_FooSqueax.wormholes.target = pseudorandom_element(PotatoPatchUtils.Developers).name
end

local cardarea_emplace_red = CardArea.emplace
---@diagnostic disable-next-line: duplicate-set-field
function CardArea:emplace(card, ...)
	if card.ppu_member and card.ppu_member.name == "Foo54" then
		local dev_card2 = Card(0, 0, G.CARD_W / 1.25, G.CARD_H / 1.25, nil, G.P_CENTERS.c_base)
    dev_card2.children.center:remove()
    dev_card2.children.center = SMODS.create_sprite(dev_card2.T.x, dev_card2.T.y, dev_card2.T.w, dev_card2.T.h, "fac_rods", {x = 1, y = 2})
    dev_card2.children.center.states.hover = dev_card2.states.hover
    dev_card2.children.center.states.click = dev_card2.states.click
    dev_card2.children.center.states.drag = dev_card2.states.drag
    dev_card2.children.center.states.collide.can = true
    dev_card2.children.center:set_role({major = dev_card2, role_type = 'Glued', draw_major = dev_card2})
    dev_card2.no_shadow = true
		function dev_card2:hover() end
		self:emplace(dev_card2)
	end
	cardarea_emplace_red(self, card, ...)
end