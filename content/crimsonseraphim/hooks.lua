FishAndChips.crimsonseraphim = {
    C = {
        spectral_gradient = SMODS.Gradient {
            key = "spectral_gradient",
            colours = {
                HEX"5e7297",
                HEX"c7b24a"
            }
        },
        stupid_fucking_DOGGYYYYIEEEs = SMODS.Gradient {
            key = "stupid_fucking_DOGGYYYYIEEEs",
            colours = {
                G.C.RED,
                G.C.GREEN
            }
        },
        transgender_gradient = SMODS.Gradient {
            key = "transgender_gradient",
            colours = {
                HEX"00b1ff",
                HEX"ff85fa",
                HEX"ffffff",
                HEX"ff85fa",
            }
        },
        crimsonseraphim_transparent = {0,0,0,0}
    }
}

local card_hover = Card.hover
function Card:hover()
    if self.ppu_member and self.ppu_member.hover then
        self.ppu_member:hover(self)
    end
    return card_hover(self)
end

local card_stop_hover = Card.stop_hover
function Card:stop_hover()
    if self.ppu_member and self.ppu_member.stop_hover then
        self.ppu_member:stop_hover(self)
    end
    return card_stop_hover(self)
end

local card_click = Card.click
function Card:click(...)
    if self.ppu_member and self.ppu_member.crimsonseraphim_click_sound and not FishAndChips.crimsonseraphim.click_timer then
        FishAndChips.crimsonseraphim.click_timer = true
        
        local sound = self.ppu_member:crimsonseraphim_click_sound()
        local timeout = 6.5
        if sound == "flowery" then
            FishAndChips.crimsonseraphim.jade_flashbang = G.TIMERS.REAL
            timeout = 2
        end
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            blocking = false,
            blockable = false,
            timer = "REAL",
            delay = timeout,
            func = function()
                FishAndChips.crimsonseraphim.click_timer = nil
                FishAndChips.crimsonseraphim.jade_flashbang = nil
                return true
            end
        })
        play_sound("fac_crimsonseraphim_"..sound, nil, 2)
    end
    return card_click(self, ...)
end

local game_update = Game.update
function Game:update(dt)
    if FishAndChips.crimsonseraphim.desc_card then
        FishAndChips.crimsonseraphim.desc_card.dt =  FishAndChips.crimsonseraphim.desc_card.dt + dt
        if FishAndChips.crimsonseraphim.desc_card.dt > 0.5 then
            FishAndChips.crimsonseraphim.desc_card.center = FishAndChips.crimsonseraphim.advance_center(FishAndChips.crimsonseraphim.desc_card.center)
            FishAndChips.crimsonseraphim.desc_card.h_popup:remove()
            FishAndChips.crimsonseraphim.desc_card.card:stop_hover()
            FishAndChips.crimsonseraphim.desc_card.card:set_ability(FishAndChips.crimsonseraphim.desc_card.center)
            FishAndChips.crimsonseraphim.desc_card.card.config.h_popup_dir = "bm"
            FishAndChips.crimsonseraphim.desc_card.card:hover()
            FishAndChips.crimsonseraphim.desc_card.h_popup = FishAndChips.crimsonseraphim.desc_card.card.children.h_popup
            FishAndChips.crimsonseraphim.desc_card.card.children.h_popup.parent = nil
            FishAndChips.crimsonseraphim.desc_card.card.children.h_popup = nil
            -- FishAndChips.crimsonseraphim.desc_card.card.children.center.atlas = SMODS.get_atlas(FishAndChips.crimsonseraphim.desc_card.center.atlas)
            -- FishAndChips.crimsonseraphim.desc_card.card.children.center:set_sprite_pos(FishAndChips.crimsonseraphim.desc_card.center.pos)
            FishAndChips.crimsonseraphim.desc_card.dt = 0
        end
    end
    return game_update(self, dt)
end

local card_remove = Card.remove
function Card:remove()
    if self.ppu_member and self.ppu_member.remove then
        self.ppu_member:remove(self)
    end
    return card_remove(self)
end

local should_draw_base_ref = Card.should_draw_base_shader
function Card:should_draw_base_shader(...)
    if self.children.center.aeonfish_transmute then return nil end
    return should_draw_base_ref(self, ...)
end

local get_badge_colour_ref = get_badge_colour
function get_badge_colour(key)
    return get_badge_colour_ref(key:gsub("fish_seal", "seal"))
end

local get_poker_hand_info_ref = G.FUNCS.get_poker_hand_info
function G.FUNCS.get_poker_hand_info(_cards)
    local cards = {}
    for i, v in pairs(_cards) do
        cards[#cards+1] = v
    end
    if next(SMODS.find_card("fish_fac_ruby_crystalfish")) then
        for i, v in pairs(G.I.CARD) do
            if v.config and v.config.center and v.config.center.set == "fac_Fish" and not SMODS.in_scoring(_cards, v) and v.base.suit then
                cards[#cards+1] = v
            end
        end
    end
    return get_poker_hand_info_ref(cards)
end

local poll_fish_ref = FishAndChips.poll_fish
function FishAndChips.poll_fish(_fevn)
    for i, v in pairs(SMODS.find_card("fish_fac_ghost_chaosfish")) do
        _fenv = _fenv or v.config.center:force_environment(v)
    end
    return poll_fish_ref(_fevn)
end

local card_eval_status_text_ref = card_eval_status_text
function card_eval_status_text(card, ...)
    if card then
        card_eval_status_text_ref(card, ...)
    end
end

local card_load_ref = Card.load
function Card:load(tbl)
    local ret = card_load_ref(self, tbl)
    self.fish_seal = tbl.fish_seal
    if self.ability.saved_card then
        self.ability.saved_card.card = SMODS.create_card{set = "Joker"}
        self.ability.saved_card.card:load(self.ability.saved_card.save_table)
        self.ability.saved_card.card.states.collide.can = false
        self.ability.saved_card.card.states.hover.can = false
        self.ability.saved_card.card.states.click.can = false
        self.ability.saved_card.card.states.drag.can = false
        self.ability.saved_card.card.states.focus.can = false
        self.ability.saved_card.card.states.visible = false
    end
    return ret
end

local card_save_ref = Card.save
function Card:save()
    local c = self.ability.saved_card and self.ability.saved_card.card
    if c then
        self.ability.saved_card.card = nil
    end
    local ret = card_save_ref(self)
    ret.fish_seal = self.fish_seal
    if c then
        self.ability.saved_card.card = c
    end
    return ret
end

local go_fish = G.FUNCS.fac_go_fish
function G.FUNCS.fac_go_fish(e)
    go_fish(e)
    if next(SMODS.find_card("fish_fac_rusty_revolver")) then
        G.E_MANAGER:add_event(Event{
            trigger = "after",
            blocking = false,
            func = function()
                if G.FISHING_STATE == G.FISHING_STATES.HOOKING then
                    local p
                    for i, v in pairs(SMODS.find_card("fish_fac_rusty_revolver")) do
                        if v.ability.extra.primed then
                            p = true
                            for i = 1, v.ability.extra.primed do
                                G.E_MANAGER:add_event(Event{
                                    trigger = "after",
                                    delay = 0.075*G.SETTINGS.GAMESPEED,
                                    func = function()
                                        play_sound("fac_crimsonseraphim_revolver_shots_"..math.random(1, 8))
                                        G.ROOM.jiggle = G.ROOM.jiggle + 3
                                        return true
                                    end
                                })
                            end
                            v.ability.extra.primed = nil
                        end
                    end
                    if p then 
                        G.GAME.REVOLVER_RETICLE_ALPHA = 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'ease',
                            blockable = false,
                            blocking = false,
                            ref_table = G.GAME,
                            ref_value = 'REVOLVER_RETICLE_ALPHA',
                            ease_to = 0,
                            delay = 2*G.SETTINGS.GAMESPEED,
                            func = (function(t) return t end)
                        }))
                    end
                    return true
                end
            end
        }) 
    end
end

local card_add_to_deck = Card.add_to_deck
function Card:add_to_deck(...)
    card_add_to_deck(self, ...)
    if self.ability.set == "fac_Fish" and self.config.center_key ~= "fish_fac_ultimate_weapon" then
        G.GAME.crimsonseraphim_obtained_fish = G.GAME.crimsonseraphim_obtained_fish or {}
        G.GAME.crimsonseraphim_obtained_fish[#G.GAME.crimsonseraphim_obtained_fish+1] = {card = self, savetable = self:save()}
    end
end

local card_remove = Card.remove
function Card:remove(...)
    if self.ability.set == "fac_Fish" and G.GAME.crimsonseraphim_obtained_fish then
        for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish) do
            if v.card == self then
                v.savetext = self:save()
                v.card = nil
            end
        end
    end
    if self.config.center_key == "fish_fac_another_bucket" and self.ability.saved_card then
        self.ability.saved_card.card:remove()
    end
    return card_remove(self, ...)
end

local card_start_dissolve = Card.start_dissolve
function Card:start_dissolve(...)
    if self.ability.set == "fac_Fish" and G.GAME.crimsonseraphim_obtained_fish then
        for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish) do
            if v.card == self then
                v.savetext = self:save()
                v.card = nil
            end
        end
    end
    return card_start_dissolve(self, ...)
end

local save_run_ref = save_run
function save_run(...)
    for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish or {}) do
        if type(v.card) == "number" then
            v.card = nil
        end
        if v.card then
            v.savetable = v.card:save()
            v.card = v.card.sort_id
        end
    end
    return save_run_ref(...)
end

local game_new_run = Game.new_run
function Game:new_run(args, ...)
    game_new_run(args, ...)
    if args.savetext and G.GAME.crimsonseraphim_obtained_fish then
        for i, v in pairs(G.GAME.crimsonseraphim_obtained_fish) do
            if v.card then
                for i, c in pairs(G.I.CARD) do
                    if c.sort_id == v.card and c.ability.set == "fac_Fish" then
                        v.card = c
                    end
                end
            end
        end
    end
end

local function loadmyimageistg(fn)
    local full_path = (FishAndChips.mod.path
        .. "assets/1x/crimsonseraphim/" .. fn)
    local file_data = assert(NFS.newFileData(full_path), ("Epic fail"))
    local tempimagedata = assert(love.image.newImageData(file_data), ("Epic fail 2"))
    --print ("LTFNI: Successfully loaded " .. fn)
    return (assert(love.graphics.newImage(tempimagedata), ("Epic fail 3")))
end
FishAndChips.crimsonseraphim.swooned = loadmyimageistg("swoonslash.png")
FishAndChips.crimsonseraphim.faces = loadmyimageistg("faces.png")

FishAndChips.crimsonseraphim.omega_text = {
    {
        face = 0,
        "Heya!"
    },
    {
        face = 0,
        "its me, RUBY."
    },
    {
        face = 1,
        "RUBY CRIMSONFANG!"
    },
    {
        face = 0,
        "i owe you a HUGE thanks."
    },
    {
        face = 2,
        "you really did a number on",
        "that old fool"
    },
    {
        face = 0,
        "without you, i NEVER could",
        "have gotten past him"
    },
    {
        face = 3,
        "but now, with your help..."
    },
    {
        face = 4,
        evil_talk_sound = true,
        "hes dead."
    },
    {
        face = 5,
        "and ive got the fish SOULS!"
    },
    {
        face = 99,
        no_talk_sound = true,
        "                ",
        "                ",
        "                ",
    },
    {
        face = 0,
        "god!"
    },
    {
        face = 0,
        "ive been empty for so",
        "long..."
    },
    {
        face = 2,
        "it feels great to have a",
        "SOUL inside me again."
    },
    {
        face = 1,
        "mmm... i can feel them",
        "wriggling..."
    },
    {
        face = 6,
        "awww... youre feeling left",
        "out, arent you?"
    },
    {
        face = 1,
        "well, thats just pefect."
    },
    {
        face = 0,
        "after all i only have",
        "fish souls."
    },
    {
        face = 1,
        "i still need one more."
    },
    {
        face = 7,
        evil_talk_sound = true,
        "before i become GOD."
    },
    {
        face = 7,
        evil_talk_sound = true,
        "and then, with my",
        "newfound powers..."
    },
    {
        face = 8,
        evil_talk_sound = true,
        "Dogs."
    },
    {
        face = 9,
        evil_talk_sound = true,
        "Vessels."
    },
    {
        face = 1,
        evil_talk_sound = true,
        "Everyone."
    },
    {
        face = 10,
        evil_talk_sound = true,
        "ill show them the REAL",
        "meaning of fishing"
    }

}

local drawhook = love.draw
function love.draw()
	drawhook()
	-- SWOON screen
	if G.swoon and (G.swoon > 0) then
        local _xscale = love.graphics.getWidth() / 1920
	    local _yscale = love.graphics.getHeight() / 1080
		
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.draw(FishAndChips.crimsonseraphim.swooned, 0 * _xscale * 2, 0 * _yscale * 2, 0, _xscale * 2 * 2, _yscale * 2 * 2)
	end
    if FishAndChips.crimsonseraphim.door_image and FishAndChips.crimsonseraphim.door_timer then
        love.graphics.clear({0,0,0,0})
        if FishAndChips.crimsonseraphim.door_timer > 0.0 then
            love.graphics.push()
            love.graphics.setShader()
            love.graphics.setColor( 1, 1, 1, 1 )
            local _, h = love.graphics.getDimensions()
            local y_scale = 1 - (1 - (FishAndChips.crimsonseraphim.door_timer / 4.3)) ^ 4
            love.graphics.translate(0, h * (1 - y_scale))
            love.graphics.scale(1.0, y_scale)
            love.graphics.draw(FishAndChips.crimsonseraphim.door_image, 0, 0)
            love.graphics.pop()
        end
        
	end
    if G.OMEGA_CRIMSONFANG_FACE and FishAndChips.crimsonseraphim.door_timer and FishAndChips.crimsonseraphim.door_timer <= -0.2 then
        FishAndChips.crimsonseraphim.flowey_canvas = FishAndChips.crimsonseraphim.flowey_canvas or SMODS.CanvasSprite {
            X=0, Y=0, W=480*3, H=270*3, canvasW=480*3, canvasH=270*3, canvasScale=1
        }

        local _xscale = 1
	    local _yscale = 1
        FishAndChips.crimsonseraphim.flowey_canvas.canvas:renderTo(function()
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.clear({0,0,0,1})
            local quad = love.graphics.newQuad(480*G.OMEGA_CRIMSONFANG_FACE, 0, 480, 270, 480*11, 270)
            love.graphics.draw(FishAndChips.crimsonseraphim.faces, quad, math.random()*3*0.55, math.random()*3*0.55, 0, 3, 3)

            local text = G.OMEGA_CRIMSONFANG_TEXT or {}
            local width = love.graphics.getWidth()
            local height = love.graphics.getHeight()
            local ts = 3/15
            local tss = 0
            for i, v in ipairs(text) do
                love.graphics.print(v, SMODS.Fonts.fac_determination.FONT, (math.random()-0.5) *0.5*tss+ 480*3/2 - SMODS.Fonts.fac_determination.FONT:getWidth(v)*(ts/2), (math.random()-0.5) *0.5*tss + 30*3 + 50*i + 270*3/2 - SMODS.Fonts.fac_determination.FONT:getHeight(v)*(ts/2), 0, ts, ts)
            end
        end)
        _xscale = love.graphics.getWidth() / 1920
	    _yscale = love.graphics.getHeight() / 1080
        love.graphics.draw(FishAndChips.crimsonseraphim.flowey_canvas.canvas, 0, 0, 0, _xscale * 2 * 2/3, _yscale * 2/3 * 2)
    end
end

local upd = Game.update
function Game:update(dt)
	upd(self, dt)

	-- tick based events
	if FishAndChips.crimsonseraphim.ticks == nil then FishAndChips.crimsonseraphim.ticks = 0 end
	if FishAndChips.crimsonseraphim.dtcounter == nil then FishAndChips.crimsonseraphim.dtcounter = 0 end
	FishAndChips.crimsonseraphim.dtcounter = FishAndChips.crimsonseraphim.dtcounter + dt
	FishAndChips.crimsonseraphim.dt = dt
    FishAndChips.crimsonseraphim.dt_flowey = (FishAndChips.crimsonseraphim.dt_flowey or 0) + dt

	while FishAndChips.crimsonseraphim.dtcounter >= 0.010 do
		FishAndChips.crimsonseraphim.ticks = FishAndChips.crimsonseraphim.ticks + 1
		FishAndChips.crimsonseraphim.dtcounter = FishAndChips.crimsonseraphim.dtcounter - 0.010
		if G.swoon and G.swoon > 0 then G.swoon = G.swoon - 1 end
	end
    if FishAndChips.crimsonseraphim.door_timer then
		FishAndChips.crimsonseraphim.door_timer = FishAndChips.crimsonseraphim.door_timer - dt
	end
    if FishAndChips.crimsonseraphim.door_timer and FishAndChips.crimsonseraphim.door_timer <= -1 and FishAndChips.crimsonseraphim.dt_flowey > 0.05 and G.OMEGA_CRIMSONFANG_FACE and FishAndChips.crimsonseraphim.omega_text[G.OMEGA_CRIMSONFANG_TEXT_INDEX or 1] then
        if G.OMEGA_CRIMSONFANG_TEXT_RESET then
            G.OMEGA_CRIMSONFANG_TEXT = {}
            G.OMEGA_CRIMSONFANG_TEXT_RESET = nil
        end
        FishAndChips.crimsonseraphim.dt_flowey = 0
        G.OMEGA_CRIMSONFANG_TEXT_INDEX = G.OMEGA_CRIMSONFANG_TEXT_INDEX or 1
        G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX = G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX or 1
        G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX = G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX or 1
        local text = FishAndChips.crimsonseraphim.omega_text[G.OMEGA_CRIMSONFANG_TEXT_INDEX][G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX]
        G.OMEGA_CRIMSONFANG_TEXT = G.OMEGA_CRIMSONFANG_TEXT or {}
        G.OMEGA_CRIMSONFANG_TEXT[G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX] = G.OMEGA_CRIMSONFANG_TEXT[G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX] or ""
        G.OMEGA_CRIMSONFANG_TEXT[G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX] = G.OMEGA_CRIMSONFANG_TEXT[G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX]..text:sub(G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX,G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX)
        G.OMEGA_CRIMSONFANG_FACE = FishAndChips.crimsonseraphim.omega_text[G.OMEGA_CRIMSONFANG_TEXT_INDEX].face or G.OMEGA_CRIMSONFANG_FACE
        G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX = G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX + 1
        if not FishAndChips.crimsonseraphim.omega_text[G.OMEGA_CRIMSONFANG_TEXT_INDEX].no_talk_sound then
            if FishAndChips.crimsonseraphim.omega_text[G.OMEGA_CRIMSONFANG_TEXT_INDEX].evil_talk_sound then
                play_sound("fac_crimsonseraphim_flowey2")
            else
                play_sound("fac_crimsonseraphim_flowey1")
            end
        end
        if G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX > string.len(text) then
            G.OMEGA_CRIMSONFANG_TEXT_CHARINDEX = 1
            G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX = G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX + 1
            if G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX > #FishAndChips.crimsonseraphim.omega_text[G.OMEGA_CRIMSONFANG_TEXT_INDEX] then
                G.OMEGA_CRIMSONFANG_TEXT_SUBINDEX = 1
                G.OMEGA_CRIMSONFANG_TEXT_INDEX = G.OMEGA_CRIMSONFANG_TEXT_INDEX + 1
                G.OMEGA_CRIMSONFANG_TEXT_RESET = true
                FishAndChips.crimsonseraphim.dt_flowey = -0.85
            end
        end
    end
    if FishAndChips.crimsonseraphim.dt_flowey and FishAndChips.crimsonseraphim.dt_flowey > 1 and G.OMEGA_CRIMSONFANG_TEXT_INDEX and not FishAndChips.crimsonseraphim.omega_text[G.OMEGA_CRIMSONFANG_TEXT_INDEX] then
        FishAndChips.crimsonseraphim.door_timer = nil
        G.OMEGA_CRIMSONFANG_FACE = nil
        G.FUNCS.exit_overlay_menu()
    end
end