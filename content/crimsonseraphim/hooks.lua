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
        local timeout = 8
        if sound == "flowery" then
            FishAndChips.crimsonseraphim.jade_flashbang = G.TIMERS.REAL
            timeout = 2.5
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
            FishAndChips.crimsonseraphim.desc_card.card:stop_hover()
            FishAndChips.crimsonseraphim.desc_card.card:set_ability(FishAndChips.crimsonseraphim.desc_card.center)
            FishAndChips.crimsonseraphim.desc_card.card:hover()
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