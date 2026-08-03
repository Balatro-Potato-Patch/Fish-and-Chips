-- cba

-- SMODS.Atlas({
-- 	key = "notmario_radiation", -- Please include your name/team name in your atlas keys
-- 	path = "notmario/radiation.png",
-- 	px = 101,
-- 	py = 101,
-- })

-- SMODS.DrawStep {
--     key = 'fac_mf_radiation',
--     order = -11,
--     func = function(self, layer)
--         if not G.fac_mf_shared_radiation then
--             local atlas = G.ASSET_ATLAS["fac_notmario_radiation"]
--             G.fac_mf_shared_radiation = Sprite(0, 0, atlas.px, atlas.py, atlas, { x = 0, y = 0 })
--         end

--         -- get biggest axis
--         local biggest = math.min(self.T.w, self.T.h) / G.CARD_H * (95 / 101)

--         local off_x, off_y = 0
--         local off_sx, off_sy = 0

--         -- if biggest == self.T.w and biggest == self.T.h then
--         --     -- ts square
--         --     off_sx, off_sy = 1 / 1.2, 1 / 1.2
--         -- elseif biggest == self.T.w then
--         --     -- fatass
--         --     off_sx = 1 / 1.2
--         --     off_sy = self.T.w / self.T.h / 1.2
--         -- else
--         --     -- normal
--         --     off_sy = 1 / 1.2
--         --     off_sx = self.T.h / self.T.w / 1.2
--         -- end

--         local scale = biggest

--         G.fac_mf_shared_radiation.role.draw_major = self
--         -- G.fac_mf_shared_radiation.T.w = 5
--         -- G.fac_mf_shared_radiation.T.y = 5
--         -- G.fac_mf_shared_radiation:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil, nil, nil, nil, 0.6)
--         G.fac_mf_shared_radiation:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil, -self.T.w, -self.T.h)
--     end,
--     conditions = { vortex = false, facing = 'front' },
-- }