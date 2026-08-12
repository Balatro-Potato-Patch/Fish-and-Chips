local mf_dev_rotation = 0

PotatoPatchUtils.Developer({
	name = 'notmario',
	loc = true,
	atlas = 'fac_notmario_fish',
	pos = { x = 2, y = 2 },
    colour = SMODS.Gradient {
        key = "fac_notmario_gradient",
        colours = {
            HEX("d64ef4"),
            HEX("ff6868")
        }
    },
    text_effect = "fac_mf_credits",
    click = function(self)
        if mf_dev_rotation >= -0.05 then
            play_sound("fac_notmario_jokerrotate")
            mf_dev_rotation = mf_dev_rotation - math.pi * 4
        end
    end,
})

local lu = love.update
function love.update(dt)
    lu(dt)
    local mix_fac = 0.01 ^ dt
    mf_dev_rotation = mix_fac * (mf_dev_rotation or 0)
end

SMODS.Sound({
	key = "notmario_jokerrotate",
	path = "notmario/jokerrotate.ogg",
	pitch = 1.0,
    volume = 0.2,
})

SMODS.DynaTextEffect {
	key = "mf_credits",
	func = function(dynatext, index, letter)
		letter.offset.y = math.sin((G.TIMERS.REAL + index * 0.1) * 2) * 12
	end,
}

SMODS.DrawStep {
    key = 'fac_mf_credits_polychrome',
    order = 21,
    func = function(self, layer)
        if (((self.children or {}).center or {}).atlas or {}).name ~= "fac_notmario_fish" then
            return nil
        end
        if self.children.center.sprite_pos.x ~= 2 then return nil end
        if self.children.center.sprite_pos.y ~= 2 then return nil end
        self.children.center:set_sprite_pos({ x = 1, y = 6 })
        self.children.center:draw_shader("polychrome", nil, self.ARGS.send_to_shader)
        -- self.children.center:draw_shader("polychrome", nil, self.ARGS.send_to_shader)
        -- self.children.center:draw_shader("polychrome", nil, self.ARGS.send_to_shader)
        -- self.children.center:draw_shader("polychrome", nil, self.ARGS.send_to_shader)
        -- self.children.center:draw_shader("polychrome", nil, self.ARGS.send_to_shader)
        self.children.center:set_sprite_pos({ x = 2, y = 2 })
    end,
    conditions = { vortex = false, facing = 'front' },
}

local card_draw = Card.draw
function Card:draw(layer, ...)
    local should_hit = false
    if (((self.children or {}).center or {}).atlas or {}).name == "fac_notmario_fish" then
        if self.children.center.sprite_pos.x == 2 and self.children.center.sprite_pos.y == 2 then should_hit = true end
    end

	if should_hit then
		self.VT.r = self.VT.r + mf_dev_rotation
		for k, v in pairs(self.children) do
			v.VT.r = v.VT.r + mf_dev_rotation
		end
	end

	card_draw(self, layer, ...)

	if should_hit then
		self.VT.r = self.VT.r - mf_dev_rotation
		for k, v in pairs(self.children) do
			v.VT.r = v.VT.r - mf_dev_rotation
		end
	end
end
