FishAndChips.Fish {
	key = "pa_photon",
	weight = 1,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 3 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "generation", "skip", "tag" },
	environments = {
		wormhole = 1,
	},
	stats = {
		length = {min = 3e-7, max = 4e-7, units = { format = "nm_format", scale = 1e-9, precision = 4}},
		weight = {min = 0, max = 0}
	},
	blueprint_compat = true,
	config = {
		extra = {
			tags = 2
		}
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.tags } }
	end,
	calculate = function(self, card, context)
        -- give two random tags when a blind is skipped_rank
        if context.skip_blind then
            for i=1,card.ability.extra.tags do
                local tag = Tag(pseudorandom_element(G.P_TAGS).key)
                tag:set_ability()
                add_tag(tag)
            end
        end
	end,
	draw = function(self, card, layer)
		if self.discovered or card.params.bypass_discovery_center then
			card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
		end
	end,
}

SMODS.Shader{
	key = 'pa_photon',
	path = "pulsar&axy/fac_pa_photon.fs"
}