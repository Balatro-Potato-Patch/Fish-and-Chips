---@diagnostic disable: duplicate-set-field
-- code modified from SynthB

SMODS.Atlas{
	key = "mod_badge",
	path = "core/mask.png",
	px = 42,
	py = 42,
}

SMODS.Shader{
	key = "mod_badge",
	path = "core/mod_badge.fs",
	send_vars = function (sprite, card)
		return {
			mask = SMODS.Atlases.fac_mod_badge.image,
			tx = FishAndChips.mod_badge.x,
			ty = FishAndChips.mod_badge.y,
			cos_neg_theta = FishAndChips.mod_badge.cr,
			sin_neg_theta = FishAndChips.mod_badge.sr
		}
	end
}