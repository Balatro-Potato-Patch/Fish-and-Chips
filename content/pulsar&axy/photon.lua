SMODS.Shader{
	key = 'pa_photon',
	path = "pulsar&axy/pa_photon.fs",
	send_vars = function(sprite, card)
		local display_value = card and card.ability and card.ability.stats and card.ability.stats.length / card.ability.stats.units.length.scale or 0
		-- display_value = tonumber(string.format('%.0f', display_value))
		return {
			fish_length = display_value
		}
	end,
}

FishAndChips.Fish {
	key = "pa_photon",
	weight = 4,
	atlas = "pa_pulsarfish",
	pos = { x = 1, y = 3 },
	ppu_artist = { "Pulsar" },
	ppu_coder = { "Axy" },
	attributes = { "generation", "skip", "tag" },
	environments = {
		wormhole = 1,
	},
	stats = {
		length = {min = 4e-7, max = 6.5e-7, units = { format = "nm_format", scale = 1e-9, precision = 4}},
		weight = {min = 0, max = 0}
	},
	blueprint_compat = true,
	config = {
		extra = {
			tags = 2
		}
	},
	loc_vars = function(self, info_queue, card)
		local color = HEX('ffffff')
		local l = card and card.ability and card.ability.stats and card.ability.stats.length / card.ability.stats.units.length.scale or 0
		-- l = tonumber(string.format('%.0f', l))
		
		-- See pa_photon.fs for citations
    	local t; local r=0.0; local g=0.0; local b=0.0;
			if l>=400.0 and l<410.0 then t=(l-400.0)/(410.0-400.0); r=0   +(0.33*t)-(0.20*t*t);
		elseif l>=410.0 and l<475.0 then t=(l-410.0)/(475.0-410.0); r=0.14         -(0.13*t*t);
		elseif l>=545.0 and l<595.0 then t=(l-545.0)/(595.0-545.0); r=0   +(1.98*t)-(     t*t);
		elseif l>=595.0 and l<650.0 then t=(l-595.0)/(650.0-595.0); r=0.98+(0.06*t)-(0.40*t*t);
		elseif l>=650.0 and l<700.0 then t=(l-650.0)/(700.0-650.0); r=0.65-(0.84*t)+(0.20*t*t) end
			if l>=415.0 and l<475.0 then t=(l-415.0)/(475.0-415.0); g=0            +(0.80*t*t);
		elseif l>=475.0 and l<590.0 then t=(l-475.0)/(590.0-475.0); g=0.8 +(0.76*t)-(0.80*t*t);
		elseif l>=585.0 and l<639.0 then t=(l-585.0)/(639.0-585.0); g=0.84-(0.84*t)            end
			if l>=400.0 and l<475.0 then t=(l-400.0)/(475.0-400.0); b=0   +(2.20*t)-(1.50*t*t);
		elseif l>=475.0 and l<560.0 then t=(l-475.0)/(560.0-475.0); b=0.7 -(     t)+(0.30*t*t) end
		
		color[1] = r
		color[2] = g
		color[3] = b

		return { vars = { card.ability.extra.tags, colours = { color } } }
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
			-- card.children.center:draw_shader('fac_hide_fish', nil, card.ARGS.send_to_shader)
			card.children.center:draw_shader('fac_pa_photon', nil, card.ARGS.send_to_shader)
			card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
		end
	end,
	shader = 'pa_photon',
}
