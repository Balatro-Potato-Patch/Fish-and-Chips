local len = 5
local targettimer

FountainOpeners.boids = {
    active = false,
    enqueue = function(self, card)
        G.E_MANAGER:add_event(Event({func = function()
			card:juice_up()
			self.active = true
			self.pre_timer = 1  -- Timer for before the minigame
			self.timer = len    -- Timer for the minigame itself
			-- self.canvas = love.graphics.newCanvas(w+15,12)
			self.card = card
			self.hits = 0
			self.timingoffset = nil

			local t = {}
			-- card.ability.extra.xmult = 1
		return true end}))

        G.E_MANAGER:add_event(Event({func = function() return not self.active end}))
    end,
}

if not love.update then function love.update(dt) end end
local update_hook = love.update
function love.update(dt)
	update_hook(dt)

	local boids = FountainOpeners.boids
	if boids.active then
        local check_thing = boids.pre_timer
		targettimer = boids.pre_timer>0 and "pre_timer" or "timer"
		boids[targettimer] = boids[targettimer] - dt

		-- End when timer runs out
		if boids.timer < 0 then
			boids.active = false
			-- space.canvas = nil
		end
	end
end

FishAndChips.Fish {
	key = "fo_boids",
	atlas = "fish",
	pos = { x = 3, y = 0 },
	weight = 11,
	ppu_coder = { "Mack" }, -- placeholder
	ppu_artist = { "GhostSalt" }, -- placeholder
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
			FountainOpeners.boids:enqueue(card)
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