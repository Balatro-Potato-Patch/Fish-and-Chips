local len = 5
local targettimer

local boid_sprite
local bx, by
local boid_quad = love.graphics.newQuad(0, 0, 1, 1, 1, 1)

-- adapted from vanhunteradams.com/Pico/Animal_Movement/Boids-algorithm.html
local visual_range = 150
local protected_range = 20
local centering_factor = 0.25
local avoid_factor = 0.05
local avoid_mouse_factor = 2
local matching_factor = 1
local max_speed = 450
local min_speed = 150
local turn_factor = 4
local max_bias = 0.1
local bias_increment = 0.0004
local bias_val = 0.01

G.E_MANAGER:add_event(Event({
	func = function()
		boid_sprite = love.graphics.newImage(love.image.newImageData(SMODS.NFS.newFileData(FishAndChips.mod.path ..
    		'/assets/1x/fountain_openers/boid_1x.png')))
		bx, by = boid_sprite:getDimensions()

		return true
	end
}))

FountainOpeners.Boids = {}
FountainOpeners.Boid = Object:extend()

function FountainOpeners.Boid:init(args)
	self.pos = {
		x = pseudorandom("fac_fo_boid_x") * (love.graphics.getWidth() - 62) - 31,
		y = pseudorandom("fac_fo_boid_y") * (love.graphics.getHeight() - 38) - 19,
		rot = 0
	}
	self.vel = {
		x = pseudorandom("fac_fo_boid_x") * 200,
		y = pseudorandom("fac_fo_boid_x") * 200,
	}
	self.spr = {
		x = 0,
		y = 0
	}

	for k, v in pairs(args or {}) do
		self[k] = v
	end

	FountainOpeners.Boids[#FountainOpeners.Boids+1] = self
end

local function lerp(a,b,fac)
    return a + (b - a) * fac
end

local function pythagorean(x, y)
	return math.sqrt(x^2 + y^2)
end

function FountainOpeners.Boid:update(dt)
	local xpos_avg, ypos_avg = 0, 0
	local xvel_avg, yvel_avg = 0, 0
	local close_dx, close_dy = 0, 0
	local neighboring_boids = 0

	-- loop through every boid
	for _, boid in ipairs(FountainOpeners.Boids) do
		if boid ~= self then
			local dx = self.pos.x - boid.pos.x
			local dy = self.pos.y - boid.pos.y

			local dist = math.abs(pythagorean(dx, dy))
			if dist < visual_range then
				close_dx = close_dx + self.pos.x - boid.pos.x
				close_dy = close_dy + self.pos.y - boid.pos.y
			elseif dist < protected_range then
				xpos_avg = xpos_avg + boid.pos.x
				ypos_avg = ypos_avg + boid.pos.y
				xvel_avg = xvel_avg + boid.vel.x
				yvel_avg = yvel_avg + boid.vel.y

				neighboring_boids = neighboring_boids + 1
			end
		end
	end

	if neighboring_boids > 0 then
		xpos_avg = xpos_avg / neighboring_boids
		ypos_avg = ypos_avg / neighboring_boids
		xvel_avg = xvel_avg / neighboring_boids
		yvel_avg = yvel_avg / neighboring_boids

		-- cohesion / alignment
		self.vel.x = (self.vx +
			(xpos_avg - self.pos.x)*centering_factor +
			(xvel_avg - self.vel.x)*matching_factor)

        self.vel.y = (self.vel.y +
			(ypos_avg - self.pos.y)*centering_factor +
			(yvel_avg - self.vel.y)*matching_factor)
	end

	-- avoidance
	self.vel.x = self.vel.x + close_dx*avoid_factor
	self.vel.y = self.vel.y + close_dy*avoid_factor

	-- avoid borders
	if self.pos.x > FountainOpeners.boids_game.x_max then
		self.vel.x = self.vel.x - turn_factor
	elseif self.pos.x < FountainOpeners.boids_game.x_min then
		self.vel.x = self.vel.x + turn_factor
	end
	if self.pos.y > FountainOpeners.boids_game.y_max then
		self.vel.y = self.vel.y - turn_factor
	elseif self.pos.y < FountainOpeners.boids_game.y_min then
		self.vel.y = self.vel.y + turn_factor
	end

	-- speed caps
	local speed = pythagorean(self.vel.x, self.vel.y)
	if speed < min_speed then
		self.vel.x = self.vel.x / speed * min_speed
		self.vel.y = self.vel.y / speed * min_speed
	elseif speed > max_speed then
		self.vel.x = self.vel.x / speed * max_speed
		self.vel.y = self.vel.y / speed * max_speed
	end

	self.pos.rot = math.atan2(self.vel.y, self.vel.x)

	-- update position
	for _, d in ipairs{"x", "y"} do
		self.pos[d] = self.pos[d] + self.vel[d] * dt
	end
end

FountainOpeners.boids_game = {
    active = false,
    enqueue = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
			card:juice_up()
			self.active = true
			self.pre_timer = 1  -- Timer for before the minigame
			self.timer = len    -- Timer for the minigame itself
			self.card = card
			self.x_min = 300
			self.x_max = love.graphics.getWidth() - 300
			self.y_min = 300
			self.y_max = love.graphics.getHeight() - 300

			local t = {}

			for i = 1, 50 do
				FountainOpeners.Boid {
					card = card
				}
			end
			card:juice_up(0.4,0.4)
			-- card.ability.extra.xmult = 1
		return true end}))

        G.E_MANAGER:add_event(Event({func = function() return not self.active end}))
    end,
}

-- Update hook to click and destroy meteors
if not love.mousepressed then function love.mousepressed(x, y, button, istouch, presses) end end
local click_hook = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
	for i, v in ipairs(FountainOpeners.Boids) do
		local dist = pythagorean(x - v.pos.x, y - v.pos.y)
		if dist < 45 and not v.clicked then
			print("clicked woah")
			return
		end
	end

	click_hook(x, y, button, istouch, presses)
end

if not love.update then function love.update(dt) end end
local update_hook = love.update
function love.update(dt)
	update_hook(dt)

	local boids_game = FountainOpeners.boids_game
	if boids_game.active then
		targettimer = boids_game.pre_timer>0 and "pre_timer" or "timer"
		boids_game[targettimer] = boids_game[targettimer] - dt

		for i, boid in ipairs(FountainOpeners.Boids) do
			boid:update(dt)
		end

		-- End when timer runs out
		if boids_game.timer < 0 then
			-- boids_game.active = false
			-- space.canvas = nil
		end
	end
end

-- Draw hook to place boids onscreen
if not love.draw then function love.draw() end end
local draw_hook = love.draw
function love.draw()
	draw_hook()

	love.graphics.setColor(1, 1, 1, 1)
	for i, v in ipairs(FountainOpeners.Boids) do
		--[[if v.clicked then
			local f = math.floor(v.clicked * 17)
			--meteor_quad:setViewport(f * 71, 0, 71, 100, ex, ey) -- Reposition quad to use the correct frame
			--love.graphics.draw(explosion_sprite, meteor_quad, v.pos.x, v.pos.y, 0, 2, 2, 35, 55)
		else
			meteor_quad:setViewport(v.spr.x * 64, v.spr.y * 64, 64, 64, mx, my) -- Reposition quad to use the correct frame
			love.graphics.draw(meteor_sprite, meteor_quad, v.pos.x, v.pos.y, v.pos.rot, 2, 2, 32, 32)
		end]]

		boid_quad:setViewport(v.spr.x * bx/1, v.spr.y * by/1, bx/1, by/1, bx, by) -- Reposition quad to use the correct frame
		love.graphics.draw(boid_sprite, boid_quad, v.pos.x, v.pos.y, v.pos.rot, 2, 2, 15, 10)
	end
end


FishAndChips.Fish {
	key = "fo_boids",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 11,
	ppu_coder = { "Alexi" },
	ppu_artist = { "Grahkon" },
	attributes = { "chips" }, -- placeholder
	config = {
	},
	environments = {
		wormhole = 1,
	},
	loc_vars = function(self, info_queue, card)
		-- return { vars = { card.ability.extra.chips } }
	end,
	calculate = function(self, card, context)
		if context.worm_lfc_on_play_press then
			FountainOpeners.boids_game:enqueue(card)
		end
	end,
}

-- reused from wormhole
if not Wormhole then
    local hook = G.FUNCS.play_cards_from_highlighted
    G.FUNCS.play_cards_from_highlighted = function(e)
        SMODS.calculate_context { worm_lfc_on_play_press = true }
        hook(e)
    end
end