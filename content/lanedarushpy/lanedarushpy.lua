PotatoPatchUtils.Developer({
	name = 'lanedarushpy',
	-- atlas = 'fac_cards', -- TODO: add card for it
	colour = HEX("713a91"),
    loc = true,
	ignore_limits = false,
	fac_partner = 'pangaea47' -- Only use this if you have a partner! This should be a string that's the same as your partner's PPU.Dev name property
})

PotatoPatchUtils.Developer({
	name = 'pangaea47',
	-- atlas = 'fac_cards', -- TODO: add atlas
	-- pos = {x = 1, y = 0}, TODO: add card
	colour = G.C.YELLOW,
    loc = true,
	ignore_limits = false,
	fac_partner = 'lanedarushpy'
})

--- The Angler [ todo ]
-- SMODS.Atlas({
-- 	key = "lanedarushpy_angler_asleep", -- Please include your name/team name in your atlas keys
-- 	path = "lanedarushpy/angler_asleep.png",
-- 	px = 25,
-- 	py = 24,
-- })

-- SMODS.Atlas({
-- 	key = "lanedarushpy_angler_awake", -- Please include your name/team name in your atlas keys
-- 	path = "lanedarushpy/angler_awake.png",
-- 	px = 25,
-- 	py = 24,
-- })

-- SMODS.Atlas({
-- 	key = "lanedarushpy_angler_house", -- Please include your name/team name in your atlas keys
-- 	path = "lanedarushpy/angler_house.png",
-- 	px = 71,
-- 	py = 95,
-- })

SMODS.Atlas {
    key = "lanedarushpy_floppy_fih",
    path = "lanedarushpy/floppy.png",
    px = 71,
    py = 95
}
SMODS.Sound {
	key = 'laneda_flop',
	path = 'lanedarushpy/flop.ogg',
	volume = 1
}
SMODS.Sound {
	key = 'laneda_escape',
	path = 'lanedarushpy/escape.ogg',
	volume = 1
}

FishAndChips.laneda_floppy_escape = {}
FishAndChips.Fish {
	key = "floppy_fih",
	atlas = "lanedarushpy_floppy_fih",
	pos = { x = 4, y = 0 },
	weight = 75,
	ppu_coder = { "lanedarushpy" },
	ppu_artist = { "lanedarushpy" },
	attributes = { "xmult" },
	config = {
        anim = {
            fps = 6,
            frames = 5,
            x_pos = 4,
            delay = 0
        },
		extra = {
			Xmult = 1.0,
            Xmult_mod = 0.25,
            min_flop_time = 8,
            max_flop_time = 20,
            time_flop_escape = 5
		},
        immutable = {
            flopping = false,
            flop_flag = false,
            time_until_flop = 0,
            flop_start_time = 0,
            flop_away_time = 3,
            flop_at = 0
        }
	},
	environments = {
		pier = 75,
		city_river = 50,
        calm_pond = 75
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main and not card.ability.immutable.cant_flop then return { Xmult = card.ability.extra.Xmult > 1.0 and card.ability.extra.Xmult or nil } end
        if (context.end_of_round or context.first_hand_drawn or context.after) and card.ability.immutable.flop_flag then
            G.E_MANAGER:add_event(Event({
                func = function ()
                    card.ability.immutable.flop_flag = false;
                    card.ability.immutable.flopping = true;
                    card.ability.immutable.flop_start_time = G.TIMERS.REAL
                    return true;
                end
            }))
        end
	end,
    update = function(self, card, dt)
        if G.fac_fish_area then
            if card.ability.immutable.flopping then
                for _, _card in ipairs(G.fac_fish_area.highlighted) do
                    if _card == card then
                        card.ability.immutable.time_until_flop = pseudorandom("lizzie_floppy_fih", card.ability.extra.min_flop_time, card.ability.extra.max_flop_time)
                        card.ability.immutable.flop_at = G.TIMERS.REAL + card.ability.immutable.time_until_flop
                        card.ability.immutable.flopping = false;
                        
                        card.children.center:set_sprite_pos({ x = 4, y = 0 })
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = "Xmult",
                            scalar_value = "Xmult_mod",
                        });
                    end
                end
            end
        end

        if card.ability.immutable.flop_at - G.TIMERS.REAL < 1 and not card.ability.immutable.cant_flop then
            card.ability.immutable.flop_flag = true
        end

        if card.ability.immutable.flopping and card.ability.immutable.flop_start_time + card.ability.extra.time_flop_escape < G.TIMERS.REAL then
            -- time to escape vro
            card.ability.immutable.flopping = false;
            card.ability.immutable.cant_flop = true;
            
            play_sound("fac_laneda_escape", 1.0);
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                delay = 0,
                func = function()
                    if FishAndChips and FishAndChips.laneda_floppy_escape then
                        local min_rad = math.pi / 4     
                        local max_rad = 1.67 * math.pi / 4 
                        local direction_thing = min_rad + (math.random() * (max_rad - min_rad))
                        card.children.center:set_sprite_pos({ x = 5, y = 0 })
                        FishAndChips.laneda_floppy_escape[#FishAndChips.laneda_floppy_escape + 1] = {
                            x = (G.ROOM.T.x + card.VT.x) * (G.TILESIZE * G.TILESCALE),
                            y = (G.ROOM.T.y + card.VT.y) * (G.TILESIZE * G.TILESCALE),
                            w = card.VT.w * (G.TILESIZE * G.TILESCALE),
                            h = card.VT.h * (G.TILESIZE * G.TILESCALE),

                            atlas_x = 4,
                            atlas_y = 0,

                            dx = direction_thing * (G.TILESIZE * G.TILESCALE) * 7.,
                            dy = -(G.TILESIZE * G.TILESCALE) * 15.,

                            r = card.VT.r,
                            dr = direction_thing * 2.5,
                        }
                    end

                    return true;
                end
            }))
            G.E_MANAGER:add_event(Event({
                blockable = false,
                delay = 0.3,
                func = function()
                    SMODS.destroy_cards(card, { immediate = true })
                    return true;
                end
            }))
        end

        if card.ability.immutable.flopping then
            if card.ability.anim.delay >= 60 / card.ability.anim.fps then
                card.ability.anim.x_pos = (card.ability.anim.x_pos + 1) % card.ability.anim.frames;
                
                if card.ability.anim.x_pos == 0 then 
                    play_sound("fac_laneda_flop", 1.0);
                end

                card.children.center:set_sprite_pos({ x = card.ability.anim.x_pos, y = 0 })
                card.ability.anim.delay = 0
            else
                card.ability.anim.delay = card.ability.anim.delay + 1
            end
        end
    end
}

FishAndChips.laneda_floppy_escapees = {}
-- called by lovely patch :vomit:
FishAndChips.laneda_draw_floppy_escapees = function()
    for _, particle in ipairs(FishAndChips.laneda_floppy_escape) do
        if not FishAndChips.laneda_floppy_escapees[particle.atlas_x.."_"..particle.atlas_y] then
            FishAndChips.laneda_floppy_escapees[particle.atlas_x.."_"..particle.atlas_y] =
                love.graphics.newQuad(particle.atlas_x * 71, particle.atlas_y * 95, 71, 95, G.ASSET_ATLAS["fac_lanedarushpy_floppy_fih"].image)
        end
        love.graphics.push()
        love.graphics.setColor(1., 1., 1., 1.)
        love.graphics.translate(particle.x, particle.y)
        love.graphics.scale(particle.w / 71, particle.h / 95)
        love.graphics.translate(71/2, 95/2)
        love.graphics.rotate(particle.r)
        love.graphics.translate(-71/2, -95/2)
        love.graphics.draw(G.ASSET_ATLAS["fac_lanedarushpy_floppy_fih"].image, FishAndChips.laneda_floppy_escapees[particle.atlas_x.."_"..particle.atlas_y], 0., 0.)

        love.graphics.pop()
    end
end

local lu = love.update
function love.update(dt, ...)
    lu(dt, ...)
    if FishAndChips and FishAndChips.laneda_floppy_escape then
        local should_filter = false
        for _, particle in ipairs(FishAndChips.laneda_floppy_escape) do
            particle.x = particle.x + particle.dx * dt
            particle.dy = particle.dy + (1800) * 0.5 * dt
            particle.y = particle.y + particle.dy * dt
            particle.dy = particle.dy + (1800) * 0.5 * dt
            particle.r = particle.r + particle.dr * dt

            if particle.y > 100000 then
                should_filter = true
            end
        end
        if should_filter then
            local temp = FishAndChips.laneda_floppy_escape
            FishAndChips.laneda_floppy_escape = {}

            for _, particle in ipairs(FishAndChips.laneda_floppy_escape) do
                if particle.y < 100000 then
                    FishAndChips.laneda_floppy_escape[#FishAndChips.laneda_floppy_escape + 1] = particle
                end
            end
        end
    end
end