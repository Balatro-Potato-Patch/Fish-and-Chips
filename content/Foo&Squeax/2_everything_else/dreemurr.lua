FishAndChips.Fish{
	key = "fas_isreal", -- Asriel -> Ralsei -> Isreal
	weight = 5,
	ppu_coder = {"Foo54"},
	stats = {
		weight = {min = 5, max = 5},
		length = {min = 5, max = 5}
	},
	environments = {
		aquifer = 1,
		wormhole = 1,
		styx = 0.5,
	},
	disable_visual_scaling = true,
	config = {
		extra = {
			mult = 1
		}
	},
	loc_vars = function(self, info_queue, card)
		return {vars = {card.ability.extra.mult, card.ability.extra.mult * SMODS.table_size(G.GAME.fac_FooSqueax and G.GAME.fac_FooSqueax.fish_caught or {})}}
	end,
	calculate = function (self, card, context)
		if context.joker_main then
			return {
				mult = card.ability.extra.mult * SMODS.table_size(G.GAME.fac_FooSqueax.fish_caught)
			}
		end
	end
}