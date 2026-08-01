local function fac_rand(min_v, max_v)
    return min_v + (max_v - min_v) * math.random()
end

local function fac_clamp(v, low, high)
    if v < low then
        return low
    end
    if v > high then
        return high
    end
    return v
end

local function fac_normal_pseudorandom(rng_key, min_v, max_v, samples)
    samples = samples or 4
    local sum = 0
    for i = 1, samples do
        sum = sum + pseudorandom(rng_key .. "_" .. i)
    end
    local t = sum / samples
    local value = min_v + math.floor(t * (max_v - min_v + 1))
    return fac_clamp(value, min_v, max_v)
end

local function fac_weighted_pick(weights, rng_key)
    local total = 0
    for _, w in pairs(weights) do
        total = total + w
    end
    if total <= 0 then
        return nil
    end
    local roll = pseudorandom(rng_key) * total
    for key, w in pairs(weights) do
        roll = roll - w
        if roll <= 0 then
            return key
        end
    end
end

local FAC_TREASURE_TYPE_WEIGHTS = { sand_dollars = 50, dollars = 40, fish = 10 }
local FAC_CAST_CHARGE_TIME = 1.1
local FAC_SPLASH_DURATION = 0.3
local FAC_CELEBRATE_DURATION = 0.9
local FAC_MATERIALIZE_GAP = 3
local FAC_SCARE_DURATION = 0.4
local FAC_DECAY_UNLOCK_THRESHOLD = 0.15
local FAC_SCENE_CANVAS_RES_SCALE = 0.55
local FAC_TRACK_H_RATIO = 0.72
local FAC_FISH_DRAW_SIZE = 10
local FAC_FISH_DRAW_VRADIUS_FACTOR = 0.56
local FAC_FISH_HITBOX_FORGIVENESS = 0.6
local fac_node_tile_xy, fac_get_scene_bounds

local FAC_ROD_TIP_FRACTION = {
    [0] = { x = 0.95, y = 0.23 },
    [1] = { x = 0.99, y = 0.26 },
    [2] = { x = 0.99, y = 0.26 },
    [3] = { x = 0.99, y = 0.34 },
    [4] = { x = 0.77, y = 0.28 },
}

local FAC_DEFAULT_FISH_TUNING = {
    bar_size = 0.26, catch_gain = 0.2, catch_loss = 0.2, treasure_gain = 0.26, vel_limit = 0.42,
    impulse_min = 0.12, impulse_max = 0.30, decision_min = 0.24, decision_max = 0.55,
    colour = { 0.55, 0.78, 0.95 }
}

local function fac_current_area()
    return (G.GAME and G.GAME.fac_current_area) or "calm_pond"
end

local function fac_profile_from_center(center)
    local t = FAC_DEFAULT_FISH_TUNING
    local rod = {}
    local key
    if G.fac_rod_area.cards[1] then
        rod = G.fac_rod_area.cards[1].ability.fishing
        key = G.fac_rod_area.cards[1].config.center.key
    end
    return {
        key = center.key,
        name = center.name or center.key,
        bar_size = rod.bar_size == nil and t.bar_size or rod.bar_size,
        treasure_gain = rod.treasure_gain == nil and t.treasure_gain or rod.treasure_gain,
        catch_gain = rod.catch_gain == nil and t.catch_gain or rod.catch_gain,
        catch_loss = rod.catch_loss == nil and t.catch_loss or rod.catch_loss,
        vel_limit = (center.vel_limit or t.vel_limit) * (rod.vel_limit or 1),
        impulse_min = (center.impulse_min or t.impulse_min) * (rod.impulse_min or 1),
        impulse_max = (center.impulse_max or t.impulse_max) * (rod.impulse_max or 1),
        decision_min = (center.decision_min or t.decision_min) * (rod.decision_min or 1),
        decision_max = (center.decision_max or t.decision_max) * (rod.decision_max or 1),
        colour = center.colour or rod.colour or t.colour,
        rod = rod,
        rod_key = key,
        center = center
    }
end

function FishAndChips.modify_fishing_profile(profile)
    local fish_profile = {
        treasure_gain = profile.treasure_gain,
        vel_limit = profile.vel_limit,
        impulse_min = profile.impulse_min,
        impulse_max = profile.impulse_max,
        decision_min = profile.decision_min,
        decision_max = profile.decision_max,
        colour = profile.colour,
    }
    local context = {
        fac_modify_fishing_profile = true,
        fishing_profile = fish_profile,
        hooked_fish = profile.center,
    }
    SMODS.calculate_context(context)
    local modified_profile = context.fishing_profile or fish_profile
    if modified_profile.treasure_gain ~= nil then profile.treasure_gain = modified_profile.treasure_gain end
    if modified_profile.vel_limit ~= nil then profile.vel_limit = modified_profile.vel_limit end
    if modified_profile.impulse_min ~= nil then profile.impulse_min = modified_profile.impulse_min end
    if modified_profile.impulse_max ~= nil then profile.impulse_max = modified_profile.impulse_max end
    if modified_profile.decision_min ~= nil then profile.decision_min = modified_profile.decision_min end
    if modified_profile.decision_max ~= nil then profile.decision_max = modified_profile.decision_max end
    if modified_profile.colour ~= nil then profile.colour = modified_profile.colour end
    return profile
end

local function fac_pick_profile()
    local key = G.GAME.fac_forced_fish or FishAndChips.poll_fish()
    local center = key and G.P_CENTERS[key]
    if not center then
        return nil
    end
    return fac_profile_from_center(center)
end

local function fac_ensure_state()
    if not G.FAC_FISH_GAME then
        G.FAC_FISH_GAME = {
            tap_requested = false,
            tap_buffer = 0,
            result_message = "",
            result_reward = 0,
            result_dollars_reward = 0,
            treasure_type = nil,
            result_timer = 0,
            cast_timer = 0,
            cast_duration = 0,
            bite_timer = 0,
            hook_window = 0,
            hook_flash_t = 0,
            meter = 0.35,
            fish_pos = 0.55,
            fish_vel = 0,
            fish_goal_vel = 0,
            fish_decision_timer = 0,
            bar_pos = 0.5,
            bar_vel = 0,
            bar_size = 0.27,
            treasure_enabled = false,
            treasure_pos = 0.5,
            treasure_meter = 0,
            got_treasure = false,
            profile = { name = "", colour = { 1, 1, 1 } },
            bobber_t = 0,
            splash_t = 0,
            scare_t = 0,
            scare_streak = 0,
            shimmer_t = 0,
            frame_id = 0,
            transition_frame = -1,
            cast_power = 0,
            casting_charge = false,
            cast_offset = 0,
            celebrate_t = 0,
            fishing_active = false,
            round_success = false,
            reel_rumbling = false,
            harpoon_dir = true,
            reel_buffer = false,
        }
    end
    return G.FAC_FISH_GAME
end

local function fac_set_fishing_state(state, new_fishing_state)
    G.FISHING_STATE = new_fishing_state
    G.FISHING_STATE_COMPLETE = false
    state.transition_frame = state.frame_id
end

local function fac_cascade_guard(state)
    return state.transition_frame == state.frame_id
end

local function fac_queue_tap(state)
    state.tap_requested = true
    state.tap_buffer = 0.16
end

local function fac_consume_tap(state)
    if state.tap_requested or state.tap_buffer > 0 then
        state.tap_requested = false
        state.tap_buffer = 0
        return true
    end
    return false
end

local function fac_get_joystick()
    local gamepad = G.CONTROLLER and G.CONTROLLER.GAMEPAD
    return (gamepad and gamepad.object) or love.joystick.getJoysticks()[1]
end

local function fac_gamepad_held(button)
    local joystick = fac_get_joystick()
    return joystick and joystick.isGamepadDown and joystick:isGamepadDown(button)
end

local function fac_reeling_held()
    return love.keyboard.isDown("space")
        or love.keyboard.isDown("up")
        or love.keyboard.isDown("w")
        or love.mouse.isDown(1)
        or fac_gamepad_held("a")
end

local function fac_rumble(strength, duration)
    local joystick = fac_get_joystick()
    if joystick and joystick.isVibrationSupported and joystick:isVibrationSupported() then
        joystick:setVibration(strength, strength, duration)
    end
end

local function fac_rumble_hold(strength)
    fac_rumble(strength, -1)
end

local function fac_rumble_release()
    local joystick = fac_get_joystick()
    if joystick then
        joystick:setVibration(0, 0)
    end
end

---gets the card area to put a center in when its acquired from fishing
---@param center SMODS.Center
---@returns CardArea
function FishAndChips.get_area_for_center(center)
    if center.set == "fac_Fish" then return G.fac_fish_area
    elseif center.set == "Joker" then return G.jokers
---@diagnostic disable-next-line: undefined-field
    elseif center.consumeable then return G.consumeables end
    return G.jokers -- default
end

local function fac_get_fishing_stats(rod_key, bait_key)
    local profile_data = G.PROFILES[G.SETTINGS.profile].fac_fishing
    profile_data.rod_data = profile_data.rod_data or {}
    profile_data.bait_data = profile_data.bait_data or {}

    local rod_stats = profile_data.rod_data[rod_key] or {}
    rod_stats.fish_caught = rod_stats.fish_caught or 0
    rod_stats.fish_lost = rod_stats.fish_lost or 0
    rod_stats.perfect_catch = rod_stats.perfect_catch or 0
    rod_stats.treasure = rod_stats.treasure or 0
    profile_data.rod_data[rod_key] = rod_stats

    local bait_stats
    if bait_key then
        bait_stats = profile_data.bait_data[bait_key] or {}
        bait_stats.fish_caught = bait_stats.fish_caught or 0
        bait_stats.fish_lost = bait_stats.fish_lost or 0
        bait_stats.perfect_catch = bait_stats.perfect_catch or 0
        bait_stats.treasure = bait_stats.treasure or 0
        profile_data.bait_data[bait_key] = bait_stats
    end

    return profile_data, rod_stats, bait_stats
end

local function fac_reveal_catch(state, profile, queue, reward_area, is_treasure_catch)
    reward_area = reward_area or G.FISHING.fac_fish_reward_area
    if not (profile.center and G.fac_fish_area) then
        return nil
    end
    local treasure_type = state.treasure_type
    local treasure_reward = treasure_type == "dollars"
        and state.result_dollars_reward or state.result_reward
    local profile_data = G.PROFILES[G.SETTINGS.profile].fac_fishing
    profile_data.fish_data = profile_data.fish_data or {}
    local fish_data = profile_data.fish_data[profile.key] or {}
    local first_catch = not (fish_data.times_caught and fish_data.times_caught > 0)
    profile.center.discovered = true
    play_sound('fac_fish_landed', math.random(0.8, 1.2))
    local added_card = SMODS.add_card({ area = reward_area, key = profile.key })
    if added_card then
        added_card:set_sprites(added_card.config.center)
        added_card.states.visible = false
        SMODS.calculate_context({fac_fish_caught = added_card, fish = profile.key, treasure = is_treasure_catch or false, perfect = state.perfect or false})
    end

    local rod_key = FishAndChips.get_rod().key
    local bait_key = G.GAME.fac_active_bait
    local _, rod_stats, bait_stats = fac_get_fishing_stats(rod_key, bait_key)
    profile_data.environments_fished = profile_data.environments_fished or {}
    profile_data.baits_used = profile_data.baits_used or {}
    profile_data.fish_data[profile.key] = profile_data.fish_data[profile.key] or {
        first_catch = os.date('%d %B'),
        times_caught = 0,
        rod = rod_key
    }
    local fish_stats = profile_data.fish_data[profile.key]
    profile_data.career_fish_caught = (profile_data.career_fish_caught or 0) + 1
    fish_stats.times_caught = (fish_stats.times_caught or 0) + 1
    rod_stats.fish_caught = rod_stats.fish_caught + 1
    if bait_stats then bait_stats.fish_caught = bait_stats.fish_caught + 1 end
    if state.perfect and queue ~= "fac_treasure_reveal" then
        profile_data.career_perfect_catch = (profile_data.career_perfect_catch or 0) + 1
        rod_stats.perfect_catch = rod_stats.perfect_catch + 1
        if bait_stats then bait_stats.perfect_catch = bait_stats.perfect_catch + 1 end
    end
    if state.got_treasure and queue ~= "fac_treasure_reveal" then
        profile_data.career_treasure_caught = (profile_data.career_treasure_caught or 0) + 1
        rod_stats.treasure = rod_stats.treasure + 1
        if bait_stats then bait_stats.treasure = bait_stats.treasure + 1 end
    end
    profile_data.environments_fished[FishAndChips.get_environment().key] = true
    if bait_key and queue ~= "fac_treasure_reveal" then
        profile_data.baits_used[bait_key] = true
    end
    check_for_unlock({
        type = 'fac_fish_caught',
        rod = rod_key, bait = G.GAME.fac_active_bait, fish = profile.key,
        treasure = state.got_treasure, perfect = state.perfect,
        [FishAndChips.get_environment().key] = true,
    })
    if state.treasure_type == 'fish' then check_for_unlock({type = 'fac_double_fish'}) end

    G:save_progress()

    local shifted_reward_box = false
    local original_reward_box_x = nil
    local function set_caught_reward_box_shift(enable)
        local reward_box = G.FISHING and G.FISHING.fac_fishing_reward_box
        if not (reward_box and reward_box.alignment and reward_box.alignment.offset) then
            return
        end
        if enable then
            if not shifted_reward_box then
                original_reward_box_x = reward_box.alignment.offset.x or 0
                reward_box.alignment.offset.x = original_reward_box_x + 2.2
                shifted_reward_box = true
            end
        elseif shifted_reward_box then
            reward_box.alignment.offset.x = original_reward_box_x or 0
            shifted_reward_box = false
            original_reward_box_x = nil
        end
    end

    local function build_caught_box(show_full)
        local has_treasure_fish_pair = state.treasure_type == "fish"
        if show_full and has_treasure_fish_pair and not is_treasure_catch then
            set_caught_reward_box_shift(true)
        end
        return UIBox{
            definition = G.UIDEF.fac_fish_data(added_card, show_full),
            config = {
                align = "bm",
                major = added_card,
                r_bond = "Weak",
                offset = {x = 0, y = 0.1}
            }
        }
    end
    local initial_area = FishAndChips.get_area_for_center(profile.center)
    local starts_full = #initial_area.cards >= initial_area.config.card_limit
    local caught_box = build_caught_box(starts_full)
    caught_box.states.visible = false
    local treasure_box
    local treasure_catch_text
    local function build_treasure_catch_text()
        local box = UIBox {
            definition = G.UIDEF.fac_treasure_catch(),
            config = {
                align = "tl",
                major = caught_box,
                offset = {x = 1, y = 0.4},
                r_bond = "Weak"
            }
        }
        box.T.r = -.40
        return box
    end
    local discovery_text
    local function build_discovery_text()
        return UIBox {
            definition = G.UIDEF.fac_newly_discovered(),
            config = {
                align = "bm",
                major = caught_box,
                offset = {x = 0, y = 0.25},
                r_bond = "Weak",
            }
        }
    end
    local perfect_catch_text
    local function build_perfect_catch_text()
        local box = UIBox {
            definition = G.UIDEF.fac_perfect_catch(),
            config = {
                align = "tr",
                major = caught_box,
                offset = {x = -1, y = 0.4},
                r_bond = "Weak"
            }
        }
        box.T.r = .40
        return box
    end
    local card_limit_stalled = false
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = (G.SETTINGS.GAMESPEED * (FAC_CELEBRATE_DURATION / 4)) + (G.SETTINGS.GAMESPEED * (FAC_MATERIALIZE_GAP / 4)),
        func = function()
            if added_card then
                added_card:start_materialize(nil, true, 4)
                if added_card.children.particles then
                    added_card.children.particles:remove()
                    added_card.children.particles = nil
                end
                play_sound('fac_celebration')
            end
            caught_box.states.visible = true
            caught_box:juice_up()
            if treasure_type == "sand_dollars" or treasure_type == "dollars" then
                treasure_box = UIBox {
                    definition = G.UIDEF.fac_treasure_reward(treasure_reward, treasure_type),
                    config = {
                        align = "cl",
                        major = added_card,
                        offset = {x = -1, y = 0},
                        r_bond = "Weak",
                    }
                }
                treasure_box:juice_up()
            end
            if is_treasure_catch then
                treasure_catch_text = build_treasure_catch_text()
                play_sound('fac_treasure_get')
            end
            return true
        end
    }), queue)
    if added_card and added_card.ability.set == "fac_Fish" and type(added_card.config.center.on_catch) == "function" then
        local center = added_card.config.center
        center:on_catch(added_card)
    end
    delay(G.SETTINGS.GAMESPEED * ((first_catch or state.perfect) and 1 or 2), queue)
    if first_catch and added_card.ability.set == 'fac_Fish' then
        G.E_MANAGER:add_event(Event({
            func = function()
                discovery_text = build_discovery_text()
                added_card:juice_up()
                play_sound('fac_discovery')
                return true;
            end
        }), queue)
        delay(G.SETTINGS.GAMESPEED * (state.perfect and 1 or 2), queue)
    end
    if not is_treasure_catch then
        if state.perfect then
            G.E_MANAGER:add_event(Event({
                func = function()
                    perfect_catch_text = build_perfect_catch_text()
                    play_sound('fac_perfect_catch')
                    G.GAME.fac_perfect_catches = G.GAME.fac_perfect_catches + 1
                    check_for_unlock({type = 'fac_perfect_catches', value = G.GAME.fac_perfect_catches})
                    return true;
                end
            }), queue)
            SMODS.calculate_effect({ message = localize('k_saved_ex'), colour = G.C.ATTENTION }, G.fac_bait_area.cards[1])
            delay(G.SETTINGS.GAMESPEED * 2, queue)
        else
            FishAndChips.remove_bait_from_inventory(G.GAME.fac_active_bait)
            if G.GAME.fac_active_bait then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.fac_bait_area.cards[1]:juice_up()
                        play_sound('generic1')
                        return true;
                    end
                }), queue)
            end
        end
    end
    local area = FishAndChips.get_area_for_center(profile.center)
    if #area.cards >= area.config.card_limit then
        G.hide_areas_again = true
        G.E_MANAGER:add_event(Event{
            func = function()
                if area == G.jokers then
                    area.T.y = area.T.y + 18
                    area.T.x = area.T.x + 1.5
                end
                if area == G.consumeables then
                    area.T.y = area.T.y + 18
                    area.T.x = area.T.x - 6
                end
                return true
            end
        }, queue)
    end
    G.E_MANAGER:add_event(Event{
        blocking = false,
        func = function()
            local area = FishAndChips.get_area_for_center(profile.center)
            if #area.cards >= area.config.card_limit and not added_card.REMOVED then
                G.NOT_SAFE_TO_PRESS_BUTTONS = false
                if not card_limit_stalled then
                    card_limit_stalled = true

                    reward_area.config.highlight_limit = 1
                    reward_area.config.highlighted_limit = 1
                    
                    caught_box:remove()
                    caught_box = build_caught_box(true)
                    caught_box.states.visible = true
                    caught_box:juice_up()
                    if discovery_text then
                        discovery_text:remove()
                        discovery_text = build_discovery_text()
                    end
                    if perfect_catch_text then
                        perfect_catch_text:remove()
                        perfect_catch_text = build_perfect_catch_text()
                    end
                    if treasure_catch_text then
                        treasure_catch_text:remove()
                        treasure_catch_text = build_treasure_catch_text()
                    end
                end
                return false
            end
            G.NOT_SAFE_TO_PRESS_BUTTONS = true
            if G.hide_areas_again then
                G.hide_areas_again = nil
                delay(G.SETTINGS.GAMESPEED * 0.5, queue)
                G.E_MANAGER:add_event(Event{
                    func = function()
                        if area == G.jokers then
                            area.T.y = area.T.y - 18
                            area.T.x = area.T.x - 1.5
                        end
                        if area == G.consumeables then
                            area.T.y = area.T.y - 18
                            area.T.x = area.T.x + 6
                        end
                        return true
                    end
                }, queue)
            end
            G.NOT_SAFE_TO_PRESS_BUTTONS = false
            if not added_card.REMOVED then
                reward_area.config.highlight_limit = 0
                reward_area.config.highlighted_limit = 0
                reward_area:remove_card(added_card)
                area:emplace(added_card)
            end
            set_caught_reward_box_shift(false)
            caught_box:remove()
            if discovery_text then discovery_text:remove() end
            if perfect_catch_text then perfect_catch_text:remove() end
            if treasure_catch_text then treasure_catch_text:remove() end
            if treasure_box then treasure_box:remove() end
            if treasure_type == "dollars" then
                ease_dollars(treasure_reward)
            elseif treasure_type == "sand_dollars" then
                ease_sand_dollars(treasure_reward)
            end
            return true
        end
    }, queue)
    return added_card
end

local function fac_finish_round(success, skip)
    local state = fac_ensure_state()
    fac_set_fishing_state(state, G.FISHING_STATES.RESULTS)
    FishAndChips.stop_reel_sound()
    FishAndChips.current_reel_sound = nil
    state.result_timer = 0
    state.round_success = success
    if state.reel_rumbling then
        state.reel_rumbling = false
        fac_rumble_release()
    end
    local fish_obj
    local treasure_obj
    if success then
        state.result_message = localize(state.perfect and "ph_fac_perfect_catch" or "ph_fac_good_catch")
        state.celebrate_t = FAC_CELEBRATE_DURATION
        fac_rumble(1, 0.4)
        state.result_reward = 0
        state.result_dollars_reward = 0
        state.treasure_type = nil
        local treasure_profile = nil
        if state.got_treasure then
            state.treasure_type = fac_weighted_pick(FAC_TREASURE_TYPE_WEIGHTS, "fac_treasure_type")
            if state.treasure_type == "fish" then
                local treasure_fish_key = FishAndChips.poll_treasure_fish()
                local treasure_center = treasure_fish_key and G.P_CENTERS[treasure_fish_key]
                if treasure_center and treasure_center.treasure then
                    treasure_profile = fac_profile_from_center(treasure_center)
                else
                    state.treasure_type = "sand_dollars"
                end
            end
            if state.treasure_type == "sand_dollars" or state.treasure_type == "dollars" then
                local base_amount = fac_normal_pseudorandom("fac_treasure_base_amount", 2, 8)
                local treasure_context = { fac_treasure_reward = base_amount, fac_treasure_reward_type = state.treasure_type }
                SMODS.calculate_context(treasure_context)
                if state.treasure_type == "sand_dollars" then
                    state.result_reward = treasure_context.fac_treasure_reward
                else
                    state.result_dollars_reward = treasure_context.fac_treasure_reward
                end
            end
            G.GAME.fac_treasure_earned = G.GAME.fac_treasure_earned + 1
            check_for_unlock({type = 'fac_treasure', value = G.GAME.fac_treasure_earned})
        end
        FishAndChips.rod_function("on_catch", state.profile.key)
        fish_obj = fac_reveal_catch(state, state.profile)
        if treasure_profile then
            FishAndChips.rod_function("on_catch", treasure_profile.key)
            G.E_MANAGER.queues.fac_treasure_reveal = G.E_MANAGER.queues.fac_treasure_reveal or {}
            treasure_obj = fac_reveal_catch(state, treasure_profile, "fac_treasure_reveal", G.FISHING.fac_treasure_reward_area, true)
        end
    else
        play_sound('fac_line_snap', 1.2)
        state.result_reward = 0
        state.result_message = localize("ph_fac_fish_slipped_away")
        state.got_treasure = false
        state.celebrate_t = 0
        if not skip then 
            check_for_unlock({type = 'fac_fish_escaped'})
        else
            local profile_data = G.PROFILES[G.SETTINGS.profile].fac_fishing
            profile_data.career_lines_snapped = (profile_data.career_lines_snapped or 0) + 1
        end
        local _, rod_stats, bait_stats = fac_get_fishing_stats(FishAndChips.get_rod().key, G.GAME.fac_active_bait)
        rod_stats.fish_lost = rod_stats.fish_lost + 1
        if bait_stats then bait_stats.fish_lost = bait_stats.fish_lost + 1 end
        fac_rumble(0.5, 0.25)
        FishAndChips.remove_bait_from_inventory(G.GAME.fac_active_bait)
        if G.GAME.fac_active_bait then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.fac_bait_area.cards[1]:juice_up()
                    play_sound('generic1')
                    return true;
                end
            }))
        end
    end
    SMODS.calculate_context({fac_end_fishing = true, failed = not success, fish = success and state.profile.key or nil, fish_obj = fish_obj or nil, treasure = success and state.got_treasure or false, treasure_available = state.treasure_enabled or false, treasure_progress = state.treasure_meter or 0, missed_treasure = success and state.treasure_enabled and not state.got_treasure or false, attempted_treasure = state.treasure_enabled and not state.got_treasure and (state.treasure_meter or 0) > 0 or false, treasure_obj = treasure_obj, perfect = success and state.perfect or false})
end
local function fac_begin_hooking_round()
    local state = fac_ensure_state()
    local profile = fac_pick_profile()
    if not profile then
        return false
    end
    profile = FishAndChips.modify_fishing_profile(profile)
    state.profile = profile
    state.meter = 0
    state.meter_primed = false
    state.decay_unlocked = false
    state.bar_size = profile.bar_size
    state.bar_pos = 1 - state.bar_size / 2
    state.bar_vel = 0
    state.fish_pos = fac_rand(0.3, 0.75)
    state.fish_vel = 0
    state.fish_goal_vel = fac_rand(-0.12, 0.12)
    state.fish_decision_timer = fac_rand(profile.decision_min, profile.decision_max)
    state.treasure_enabled = profile.rod_key ~= "rod_fac_harpoon" and math.random() < 0.66 or false
    state.treasure_pos = fac_rand(0.14, 0.86)
    state.treasure_meter = 0
    state.got_treasure = false
    state.splash_t = FAC_SPLASH_DURATION
    state.perfect = true
    state.has_reeled = false
    return true
end

function G:update_fac_fishing_lobby(dt)
    local state = fac_ensure_state()
    if fac_cascade_guard(state) then
        return
    end
    if not G.FISHING_STATE_COMPLETE then
        state.tap_requested = false
        state.tap_buffer = 0
        state.result_message = ""
        state.result_reward = 0
        state.bobber_t = 0
        state.cast_power = 0
        state.casting_charge = false
        state.fishing_active = false
        state.reel_buffer = false
        G.FISHING_STATE_COMPLETE = true
        FishAndChips.update_jimbo_state(FishAndChips.JIMBO_ANIMATION_STATES.IDLE)
    end
    state.bobber_t = state.bobber_t + dt
    if not state.fishing_active then
        return
    end
    if fac_reeling_held() then
        state.casting_charge = true
        state.cast_power = fac_clamp(state.cast_power + dt / FAC_CAST_CHARGE_TIME, 0, 1)
    elseif state.casting_charge then
        state.casting_charge = false
        state.cast_offset = fac_rand(-1, 1) * state.cast_power
        play_sound('fac_rod_swing', 1 + (state.cast_power / 2))
        fac_set_fishing_state(state, G.FISHING_STATES.CASTING)
    end
end

function G.FUNCS.fac_go_fish(e)
    if G.STATE ~= G.STATES.FAC_FISHING or G.FISHING_STATE ~= G.FISHING_STATES.LOBBY or FishAndChips.in_tutorial then
        return
    end
    if G.GAME.fac_fish_expanded then
        G.FUNCS.fac_open_fishing_menu()
    end
    fac_ensure_state().fishing_active = true
    FishAndChips.fade_fishing_buttons()
end

local fac_game_update_ref = Game.update
function Game:update(dt)
    if G.STATE == G.STATES.FAC_FISHING then
        local state = fac_ensure_state()
        state.frame_id = state.frame_id + 1
    end
    fac_game_update_ref(self, dt)
    if G.STATE == G.STATES.FAC_FISHING and not G.SETTINGS.paused then
        FishAndChips:handle_ambience()
        FishAndChips.get_environment():update(dt)
        local state = fac_ensure_state()
        if state.tap_buffer > 0 then
            state.tap_buffer = math.max(0, state.tap_buffer - dt)
        end
        if G.FISHING_STATE == G.FISHING_STATES.CASTING then
            state.tap_requested = false
            state.tap_buffer = 0
        elseif G.FISHING_STATE == G.FISHING_STATES.WAITING then
            if state.tap_requested or state.tap_buffer > 0 then
                state.tap_requested = false
                state.tap_buffer = 0
                state.scare_streak = state.scare_streak + 1
                local streak_bonus = math.min(state.scare_streak - 1, 5) * 0.4
                state.bite_timer = fac_clamp(fac_rand(0.75, 1.95) - state.cast_power * 0.55, 0.35, 1.95) + streak_bonus
                state.scare_t = FAC_SCARE_DURATION
                play_sound('fac_bobber_hit', math.random(0.9, 1.3))
                fac_rumble(0.35, 0.15)
            end
        end
        state.shimmer_t = state.shimmer_t + dt
        if state.splash_t > 0 then
            state.splash_t = math.max(0, state.splash_t - dt)
        end
        if state.celebrate_t > 0 then
            state.celebrate_t = math.max(0, state.celebrate_t - dt)
        end
        if state.scare_t > 0 then
            state.scare_t = math.max(0, state.scare_t - dt)
        end
    end
    if G.STATE == G.STATES.BLIND_SELECT and not G.blind_select and G.hand then
        G.hand.T.y = G.TILE_H - G.hand.T.h
        G.hand:hard_set_VT()
    end
end

function G:update_fac_fishing_casting(dt)
    local state = fac_ensure_state()
    if fac_cascade_guard(state) then
        return
    end
    if not G.FISHING_STATE_COMPLETE then
        state.cast_timer = 0.32 + state.cast_power * 0.35
        state.cast_duration = state.cast_timer
        state.bite_timer = fac_clamp(fac_rand(0.75, 1.95) - state.cast_power * 0.55, 0.35, 1.95)
        G.FISHING_STATE_COMPLETE = true
        FishAndChips.update_jimbo_state(FishAndChips.JIMBO_ANIMATION_STATES.CAST)
        SMODS.calculate_context{fac_cast_rod = true}
    end
    if G.FAC_JIMBO_ANIMATION_STATE == FishAndChips.JIMBO_ANIMATION_STATES.WAIT then
        state.cast_timer = state.cast_timer - dt
        if state.cast_timer <= 0 then
            state.splash_t = FAC_SPLASH_DURATION
            play_sound('fac_bobber_hit', math.random(0.6, 1.0))
            fac_set_fishing_state(state, G.FISHING_STATES.WAITING)
        end
    end
end

function G:update_fac_fishing_waiting(dt)
    local state = fac_ensure_state()
    if fac_cascade_guard(state) then
        return
    end
    if not G.FISHING_STATE_COMPLETE then
        G.FISHING_STATE_COMPLETE = true
        state.scare_t = 0
        state.scare_streak = 0
    end

    state.bobber_t = state.bobber_t + dt
    state.bite_timer = state.bite_timer - dt
    if state.bite_timer <= 0 then
        state.scare_streak = 0
        fac_set_fishing_state(state, G.FISHING_STATES.HOOKED)
        play_sound('fac_fish_on')
    end
end

function G:update_fac_fishing_hooked(dt)
    local state = fac_ensure_state()
    if fac_cascade_guard(state) then
        return
    end
    if not G.FISHING_STATE_COMPLETE then
        state.hook_window = 0.9
        state.hook_flash_t = 0
        G.FISHING_STATE_COMPLETE = true
        FishAndChips.update_jimbo_state(FishAndChips.JIMBO_ANIMATION_STATES.BITE)
    end
    state.hook_flash_t = state.hook_flash_t + dt
    if fac_consume_tap(state) then
        if fac_begin_hooking_round() then
            fac_rumble(0.75, 0.2)
            fac_set_fishing_state(state, G.FISHING_STATES.HOOKING)
        else
            fac_finish_round(false)
        end
        return
    end

    state.hook_window = state.hook_window - dt
    if state.hook_window <= 0 then
        fac_finish_round(false)
    end
end

function G:update_fac_fishing_hooking(dt)
    local state = fac_ensure_state()
    if fac_cascade_guard(state) then
        return
    end
    if not G.FISHING_STATE_COMPLETE then
        G.FISHING_STATE_COMPLETE = true
        SMODS.calculate_context{fac_fish_hooked = state.profile.key}
    end
    local reeling = fac_reeling_held()
    local up_force = 2.25
    local up_force_while_down = 6
    local gravity = 3
    local max_bar_vel = 2.2
    if state.profile.rod_key == "rod_fac_harpoon" then
        if state.harpoon_dir then
            state.bar_vel = 1
        else
            state.bar_vel = -1
        end
        -- PATCH TARGET: CUSTOM BAR BEHAVIOUR
    else
        if reeling then
            state.bar_vel = state.bar_vel - (state.bar_vel > 0 and up_force_while_down or up_force) * dt
        else
            state.bar_vel = state.bar_vel + gravity * dt
        end
    end
    state.bar_vel = fac_clamp(state.bar_vel, -max_bar_vel, max_bar_vel)
    state.bar_pos = state.bar_pos + state.bar_vel * dt
    local past_bar_pos = state.bar_pos
    if state.bar_pos < 0 + (state.bar_size / 2) then
        state.bar_pos = 0 + (state.bar_size / 2)
        state.bar_vel = 0
    elseif state.bar_pos > 1 - (state.bar_size / 2) then
        state.bar_pos = 1 - (state.bar_size / 2)
        state.bar_vel = 0
    end
    if past_bar_pos ~= state.bar_pos then
        state.harpoon_dir = not state.harpoon_dir
    end
    local profile = state.profile
    state.fish_decision_timer = state.fish_decision_timer - dt
    -- fish behavior logic
    if state.fish_decision_timer <= 0 then
        local impulse = fac_rand(profile.impulse_min, profile.impulse_max)
        if math.random() < 0.5 then
            impulse = -impulse
        end
        if state.fish_pos < 0.20 then
            impulse = math.abs(impulse)
        elseif state.fish_pos > 0.80 then
            impulse = -math.abs(impulse)
        end
        state.fish_goal_vel = fac_clamp(state.fish_goal_vel + impulse, -profile.vel_limit, profile.vel_limit)
        state.fish_decision_timer = fac_rand(profile.decision_min, profile.decision_max)
    end
    state.fish_vel = state.fish_vel + (state.fish_goal_vel - state.fish_vel) * (6.5 * dt)
    state.fish_pos = state.fish_pos + state.fish_vel * dt
    if state.fish_pos < 0 then
        state.fish_pos = 0
        state.fish_vel = math.abs(state.fish_vel) * 0.55
        state.fish_goal_vel = math.abs(state.fish_goal_vel) * 0.55
    elseif state.fish_pos > 1 then
        state.fish_pos = 1
        state.fish_vel = -math.abs(state.fish_vel) * 0.55
        state.fish_goal_vel = -math.abs(state.fish_goal_vel) * 0.55
    end
    -- end fish behavior logic
    -- fish progress logic
    local fish_hitbox_half = 0
    local _, _, _, scene_ph = fac_get_scene_bounds()
    if scene_ph and scene_ph > 0 then
        local track_h = (scene_ph * FAC_SCENE_CANVAS_RES_SCALE) * FAC_TRACK_H_RATIO
        local fish_visual_half_px = FAC_FISH_DRAW_SIZE * FAC_FISH_DRAW_VRADIUS_FACTOR
        fish_hitbox_half = (fish_visual_half_px * FAC_FISH_HITBOX_FORGIVENESS) / track_h
    end
    local in_bar = math.abs(state.fish_pos - state.bar_pos) <= (state.bar_size * 0.5 + fish_hitbox_half)
    local previous_sound_state = FishAndChips.current_reel_sound
    if in_bar then
        state.meter = state.meter + profile.catch_gain * dt
        FishAndChips.current_reel_sound = 'fac_reeling_in'
        FishAndChips.update_jimbo_state(FishAndChips.JIMBO_ANIMATION_STATES.REEL)
        state.has_reeled = true
    else
        if state.decay_unlocked then
            state.meter = state.meter - profile.catch_loss * dt
        end
        FishAndChips.current_reel_sound = 'fac_pulling_drag'
        FishAndChips.update_jimbo_state(FishAndChips.JIMBO_ANIMATION_STATES.BITE)
        if state.has_reeled and state.decay_unlocked then
            state.perfect = false
        end
    end
    if not state.decay_unlocked and state.meter >= FAC_DECAY_UNLOCK_THRESHOLD then
        state.decay_unlocked = true
    end

    if previous_sound_state ~= FishAndChips.current_reel_sound then
        FishAndChips.stop_reel_sound()
    end

    FishAndChips.handle_reel_sound()

    if state.profile.rod_key == "rod_fac_harpoon" then
        state.meter_primed = true
        if not reeling then
            state.reel_buffer = true
        end
        if reeling and state.reel_buffer then
            if in_bar then
                state.meter = 1
            else
                state.meter = 0
            end
        else
            state.meter = 0.5
        end
    end
    state.meter = fac_clamp(state.meter, 0, 1)
    if state.meter > 0 then
        state.meter_primed = true
    end

    if state.decay_unlocked and not in_bar and not state.reel_rumbling then
        state.reel_rumbling = true
        fac_rumble_hold(0.6)
    elseif (in_bar or not state.decay_unlocked) and state.reel_rumbling then
        state.reel_rumbling = false
        fac_rumble_release()
    end

    if state.treasure_enabled and not state.got_treasure then
        local chest_in_bar = math.abs(state.treasure_pos - state.bar_pos) <= (state.bar_size * 0.5)
        if chest_in_bar then
            state.treasure_meter = fac_clamp(state.treasure_meter + profile.treasure_gain * dt, 0, 1)
        end
        if state.treasure_meter >= 1 then
            state.got_treasure = true
            play_sound('fac_treasure_get')
        end
    end
    if state.meter >= 1 then
        fac_finish_round(true)
    elseif state.meter_primed and state.meter <= 0 then
        fac_finish_round(false, true)
        check_for_unlock({type = 'fac_line_snapped'})
    end
end

function G:update_fac_fishing_results(dt)
    local state = fac_ensure_state()
    if fac_cascade_guard(state) then
        return
    end
    if not G.FISHING_STATE_COMPLETE then
        state.result_timer = 0
        G.FISHING_STATE_COMPLETE = true
        FishAndChips.update_jimbo_state(FishAndChips.JIMBO_ANIMATION_STATES.IDLE)
    end
    state.result_timer = state.result_timer + dt
    if state.result_timer > 0.2 and not next(G.FISHING.fac_fish_reward_area.cards)
        and not next(G.FISHING.fac_treasure_reward_area.cards) then
        fac_set_fishing_state(state, G.FISHING_STATES.LOBBY)
        FishAndChips.show_fishing_buttons()
    end
end

local old_fac_keypressed = love.keypressed
function love.keypressed(key, scancode, isrepeat)
    if G and G.STATE == G.STATES.FAC_FISHING and not G.SETTINGS.paused then
        local state = fac_ensure_state()
        if key == "space" or key == "up" or key == "w" then
            fac_queue_tap(state)
        end
    end

    if old_fac_keypressed then
        old_fac_keypressed(key, scancode, isrepeat)
    end
end

local old_fac_mousepressed = love.mousepressed
function love.mousepressed(x, y, button, istouch, presses)
    if G and G.STATE == G.STATES.FAC_FISHING and not G.SETTINGS.paused then
        local state = fac_ensure_state()
        if button == 1 then
            fac_queue_tap(state)
        end
    end
    if old_fac_mousepressed then
        old_fac_mousepressed(x, y, button, istouch, presses)
    end
end

local old_fac_gamepadpressed = love.gamepadpressed
function love.gamepadpressed(joystick, button)
    if G and G.STATE == G.STATES.FAC_FISHING and not G.SETTINGS.paused then
        local state = fac_ensure_state()
        if button == "a" then
            fac_queue_tap(state)
        end
    end
    if old_fac_gamepadpressed then
        old_fac_gamepadpressed(joystick, button)
    end
end

local function fac_draw_vertical_meter(x, y, w, h, value, bg, fg)
    love.graphics.setColor(bg[1], bg[2], bg[3], 0.92)
    love.graphics.rectangle("fill", x, y, w, h, 10, 10)

    local filled = h * fac_clamp(value, 0, 1)
    love.graphics.setColor(fg[1], fg[2], fg[3], 0.97)
    love.graphics.rectangle("fill", x, y + (h - filled), w, filled, 10, 10)

    love.graphics.setColor(1, 1, 1, 0.18)
    love.graphics.rectangle("line", x, y, w, h, 10, 10)
end

local function fac_draw_slack_line(x1, y1, x2, y2, sag)
    local segments = 10
    local points = {}
    for i = 0, segments do
        local t = i / segments
        points[#points + 1] = x1 + (x2 - x1) * t
        points[#points + 1] = y1 + (y2 - y1) * t + sag * math.sin(t * math.pi)
    end
    love.graphics.line(points)
end

local function fac_draw_fish(x, y, size, colour)
    love.graphics.setColor(colour[1], colour[2], colour[3], 1)
    love.graphics.ellipse("fill", x, y, size * 0.95, size * FAC_FISH_DRAW_VRADIUS_FACTOR)
    love.graphics.polygon("fill", x - size * 0.95, y, x - size * 1.45, y - size * 0.44, x - size * 1.45, y + size * 0.44)
    love.graphics.setColor(1, 1, 1, 0.88)
    love.graphics.circle("fill", x + size * 0.40, y - size * 0.1, size * 0.12)
    love.graphics.setColor(0.08, 0.08, 0.08, 0.9)
    love.graphics.circle("fill", x + size * 0.40, y - size * 0.1, size * 0.06)
end

function fac_node_tile_xy(node)
    local x, y = node.T.x, node.T.y
    local c = node.container
    local guard = 0
    while c and c ~= node and guard < 8 do
        x = x + c.T.x
        y = y + c.T.y
        if c.container == c then
            break
        end
        c = c.container
        guard = guard + 1
    end
    return x, y
end

function fac_get_scene_bounds()
    local sw, sh = love.graphics.getDimensions()
    G.FISHING = G.FISHING or {}
    local box = (G.FISHING.fishing and G.FISHING.fishing.UIRoot) or G.FISHING.fishing
    if box and box.T and box.T.w and box.T.w > 0 and box.T.h and box.T.h > 0 then
        local scale = G.TILESCALE * G.TILESIZE
        local tx, ty = fac_node_tile_xy(box)
        return tx * scale, ty * scale, box.T.w * scale, box.T.h * scale
    end
    return sw * 0.08, sh * 0.08, sw * 0.84, sh * 0.84
end

local function fac_get_true_coords(moveable)
    local transform = moveable.VT or moveable.T
    local scale = G.TILESIZE * G.TILESCALE
    return (G.ROOM.T.x + transform.x) * scale, (G.ROOM.T.y + transform.y) * scale, transform.w * scale, transform.h * scale
end

local function fac_get_rod_tip_local(px, py, pw, ph, force_anim_state)
    local jimbo = G.FISHING and G.FISHING.jimbo
    if not jimbo or not (jimbo.VT or jimbo.T) or not G.ROOM or not G.ROOM.T then
        return nil
    end
    local spx, spy, spw, sph = fac_get_scene_bounds()
    if spw <= 0 or sph <= 0 then
        return nil
    end

    local jx, jy, jw, jh = fac_get_true_coords(jimbo)
    local frac = FAC_ROD_TIP_FRACTION[force_anim_state or G.FAC_JIMBO_ANIMATION_STATE or 0] or FAC_ROD_TIP_FRACTION[0]
    local real_x = jx + frac.x * jw
    local real_y = jy + frac.y * jh

    local fx = (real_x - spx) / spw
    local fy = (real_y - spy) / sph
    return px + fx * pw, py + fy * ph
end

local FAC_STATUS_QUEUE
local function fac_draw_text_with_black_bg(str, x, y, text_color)
    if FishAndChips.show_ui then
        if FAC_STATUS_QUEUE then
            FAC_STATUS_QUEUE[#FAC_STATUS_QUEUE + 1] = {
                str = str,
                x = x,
                y = y,
                colour = text_color or {0.88, 0.97, 1, 1},
            }
            return
        end
        local textbox_w = love.graphics.getFont():getWidth(str) + 12
        local textbox_h = love.graphics.getFont():getHeight() + 8
        love.graphics.setColor(G.C.BLACK[1], G.C.BLACK[2], G.C.BLACK[3], 0.65)
        love.graphics.rectangle("fill", x + 18, y - 4, textbox_w, textbox_h, 8, 8)
        local c = text_color or {0.88, 0.97, 1, 1}
        love.graphics.setColor(c)
        love.graphics.print(str, x + 24, y)
    end
end

local function fac_draw_scene_content(state, px, py, pw, ph)
    local env = FishAndChips.get_environment()
    local rod_x, rod_y = fac_get_rod_tip_local(px, py, pw, ph)
    if not rod_x then
        rod_x, rod_y = px + pw * 0.30, py + ph * 0.44
    end

    local fresh_stable_rod_x = fac_get_rod_tip_local(px, py, pw, ph, FishAndChips.JIMBO_ANIMATION_STATES.BITE) or rod_x
    state.stable_rod_x = state.stable_rod_x or fresh_stable_rod_x
    state.stable_rod_x = state.stable_rod_x + (fresh_stable_rod_x - state.stable_rod_x) * math.min(6 * love.timer.getDelta(), 1)
    local stable_rod_x = state.stable_rod_x

    local water_top = py + ph * (env.water_bounds and env.water_bounds.top or 0.80)
    local water_bottom = py + ph * (env.water_bounds and env.water_bounds.bottom or 0.84)

    local track_w = fac_clamp(pw * 0.05, 26, 52)
    local track_h = ph * FAC_TRACK_H_RATIO
    local track_x = px + pw * 0.83
    local track_y = py + ph * 0.12
    local catch_meter_x = track_x + track_w + 6
    local treasure_meter_x = math.min(catch_meter_x + 20, px + pw - 20)
    local depth = fac_clamp(0.15 + state.cast_power * 0.75, 0.08, 0.95)
    local land_x = fac_clamp(
        stable_rod_x + pw * 0.06 + depth * (pw * 0.40) + state.cast_offset * (pw * 0.04),
        stable_rod_x + 20, track_x - 40
    )
    local land_y = fac_clamp(water_bottom - depth * (water_bottom - water_top), water_top, water_bottom)

    local status_y = py + ph - 38
    love.graphics.setColor(0.88, 0.97, 1, 1)

    if G.FISHING_STATE == G.FISHING_STATES.LOBBY then
        if state.casting_charge then
            local bar_x, bar_y, bar_w, charge_h = px + 24, status_y - 18, pw - 48, 8
            love.graphics.setColor(0.10, 0.14, 0.20, 0.9)
            love.graphics.rectangle("fill", bar_x, bar_y, bar_w, charge_h, 4, 4)
            love.graphics.setColor(0.98, 0.83, 0.29, 1)
            love.graphics.rectangle("fill", bar_x, bar_y, bar_w * state.cast_power, charge_h, 4, 4)
            local str = localize("ph_fac_charging_cast")
            fac_draw_text_with_black_bg(str, px, status_y)
        elseif state.fishing_active then
            local str = localize("ph_fac_hold_to_charge")
            fac_draw_text_with_black_bg(str, px, status_y)
        else
            local key = "click_go_fish"
            if not G.GAME.fac_active_bait then
                if G.GAME.fac_bait_inventory[1] then
                    key = "equip_bait_hint"
                else
                    key = "no_bait_hint"
                end
            end
            local str = localize("ph_fac_" .. key)
            fac_draw_text_with_black_bg(str, px, status_y)
        end
    elseif G.FISHING_STATE == G.FISHING_STATES.CASTING then
        if G.FAC_JIMBO_ANIMATION_STATE ~= FishAndChips.JIMBO_ANIMATION_STATES.CAST and G.FAC_JIMBO_ANIMATION_STATE ~= FishAndChips.JIMBO_ANIMATION_STATES.IDLE then
            local progress = 1 - fac_clamp(state.cast_timer / math.max(state.cast_duration, 0.0001), 0, 1)
            local arc_x = rod_x + (land_x - rod_x) * progress
            local arc_y = rod_y + (land_y - rod_y) * progress - math.sin(progress * math.pi) * 40
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.line(rod_x, rod_y, arc_x, arc_y)
            love.graphics.setColor(1, 0.3, 0.25, 1)
            love.graphics.circle("fill", arc_x, arc_y, 6)
            local str = localize("ph_fac_casting_line")
            fac_draw_text_with_black_bg(str, px, status_y)
        end
    elseif G.FISHING_STATE == G.FISHING_STATES.WAITING or G.FISHING_STATE == G.FISHING_STATES.HOOKED then
        local bobber_x = land_x + math.sin(state.bobber_t * 1.7) * 2
        local bobber_y = land_y + math.sin(state.bobber_t * 5.8) * 4

        if state.scare_t > 0 then
            local decay = state.scare_t / FAC_SCARE_DURATION
            local shake = decay * 8
            bobber_x = bobber_x + math.sin(state.scare_t * 50) * shake
            bobber_y = bobber_y + math.cos(state.scare_t * 70) * shake * 0.6
        end

        local ripple = (state.bobber_t * 0.5) % 1
        love.graphics.setColor(0.8, 0.95, 1, 0.35 * (1 - ripple))
        love.graphics.circle("line", bobber_x, bobber_y, 10 + ripple * 22)

        love.graphics.setColor(1, 1, 1, 1)
        fac_draw_slack_line(rod_x, rod_y, bobber_x, bobber_y, 14 + math.sin(state.bobber_t * 2) * 3)
        love.graphics.setColor(1, 0.3, 0.25, 1)
        love.graphics.circle("fill", bobber_x, bobber_y, 8)
        love.graphics.setColor(1, 0.86, 0.86, 0.8)
        love.graphics.circle("line", bobber_x, bobber_y, 12)

        if G.FISHING_STATE == G.FISHING_STATES.WAITING then
            if state.scare_t > 0 then
                love.graphics.setColor(1, 0.15, 0.15, fac_clamp(state.scare_t / FAC_SCARE_DURATION, 0, 1))
                love.graphics.print("?", bobber_x - 4, bobber_y - 34, 0, 1.6, 1.6)
                fac_draw_text_with_black_bg(localize("ph_fac_fish_spooked"), px, status_y, {1, 0.15, 0.15, 1})
                check_for_unlock({type = 'fac_too_early'})
            else
                local str = localize("ph_fac_waiting_for_bite")
                fac_draw_text_with_black_bg(str, px, status_y)
            end
        else
            local blink = (math.floor(state.hook_flash_t * 9) % 2 == 0)
            love.graphics.setColor(1, 0.92, 0.34, blink and 1 or 0.65)
            love.graphics.print("!", bobber_x - 4, bobber_y - 34, 0, 1.6, 1.6)
            local str = localize("ph_fac_hit_press_now")
            fac_draw_text_with_black_bg(str, px, status_y, {1, 0.92, 0.34, blink and 1 or 0.65})
        end
    elseif G.FISHING_STATE == G.FISHING_STATES.HOOKING
        or (G.FISHING_STATE == G.FISHING_STATES.RESULTS and state.round_success) then
        local reel_t = fac_clamp(state.meter, 0, 1)
        local reel_near_x = stable_rod_x + (land_x - stable_rod_x) * 0.12
        local hook_x = land_x + (reel_near_x - land_x) * reel_t
        local hook_y = land_y

        love.graphics.setColor(1, 1, 1, 1)
        fac_draw_slack_line(rod_x, rod_y, hook_x, hook_y, 3)
        love.graphics.setColor(1, 0.3, 0.25, 1)
        love.graphics.circle("fill", hook_x, hook_y, 7)

        love.graphics.setColor(0.06, 0.20, 0.33, 0.95)
        love.graphics.rectangle("fill", track_x, track_y, track_w, track_h, 10, 10)
        love.graphics.setColor(0.60, 0.88, 1, 0.8)
        love.graphics.rectangle("line", track_x, track_y, track_w, track_h, 10, 10)

        local fish_y = track_y + state.fish_pos * track_h
        local bar_h = state.bar_size * track_h
        local bar_top = fac_clamp((track_y + state.bar_pos * track_h) - bar_h * 0.5, track_y, track_y + track_h - bar_h)

        love.graphics.setColor(0.20, 0.84, 0.44, 0.32)
        love.graphics.rectangle("fill", track_x + 5, bar_top, track_w - 10, bar_h, 8, 8)
        love.graphics.setColor(0.66, 1.0, 0.73, 0.95)
        love.graphics.rectangle("line", track_x + 5, bar_top, track_w - 10, bar_h, 8, 8)

        if state.treasure_enabled and not state.got_treasure then
            local chest_y = track_y + state.treasure_pos * track_h
            local pulse = 0.65 + 0.35 * math.sin(state.shimmer_t * 7.5)
            love.graphics.setColor(1, 0.86, 0.20, pulse)
            love.graphics.rectangle("fill", track_x + 8, chest_y - 5, track_w - 16, 10, 3, 3)
        end

        if state.splash_t > 0 then
            local splash = state.splash_t / FAC_SPLASH_DURATION
            love.graphics.setColor(0.80, 0.95, 1, 0.7 * splash)
            love.graphics.circle("line", track_x + track_w * 0.5, fish_y, 24 * (1.2 - splash))
        end

        fac_draw_fish(track_x + track_w * 0.5 + 6, fish_y, FAC_FISH_DRAW_SIZE, state.profile.colour)

        fac_draw_vertical_meter(catch_meter_x, track_y, 14, track_h, state.meter, { 0.20, 0.10, 0.13 }, { 0.97, 0.38, 0.47 })
        love.graphics.setColor(0.97, 0.76, 0.82, 1)
        love.graphics.print(localize("k_fac_catch_meter"), track_x, track_y - 20, 0, 0.7, 0.7)

        if state.treasure_enabled then
            fac_draw_vertical_meter(treasure_meter_x, track_y, 14, track_h, state.treasure_meter, { 0.19, 0.15, 0.08 }, { 0.98, 0.83, 0.29 })
            love.graphics.setColor(0.98, 0.90, 0.62, 1)
            love.graphics.print(localize("k_fac_treasure_meter"), treasure_meter_x - 14, track_y - 20, 0, 0.6, 0.6)
        end

    elseif G.FISHING_STATE == G.FISHING_STATES.RESULTS then
        love.graphics.setColor(0.88, 0.97, 1, 1)
        fac_draw_text_with_black_bg(state.result_message, px, status_y - 18)
        love.graphics.setColor(0.88, 0.97, 1, 0.9)
        fac_draw_text_with_black_bg(localize("ph_fac_press_to_continue"), px, status_y + 11)
    end
end

local FAC_SCENE_CANVAS, FAC_SCENE_CANVAS_W, FAC_SCENE_CANVAS_H
local function fac_draw_panel()
    if not G or G.STATE ~= G.STATES.FAC_FISHING or G.SETTINGS.paused then
        return
    end
    local state = fac_ensure_state()
    local px, py, pw, ph = fac_get_scene_bounds()
    if pw <= 0 or ph <= 0 then
        return
    end
    local res_scale = FAC_SCENE_CANVAS_RES_SCALE
    local cw = math.max(64, math.floor(pw * res_scale))
    local ch = math.max(64, math.floor(ph * res_scale))
    if not FAC_SCENE_CANVAS or FAC_SCENE_CANVAS_W ~= cw or FAC_SCENE_CANVAS_H ~= ch then
        FAC_SCENE_CANVAS = love.graphics.newCanvas(cw, ch)
        FAC_SCENE_CANVAS:setFilter("nearest", "nearest")
        FAC_SCENE_CANVAS_W, FAC_SCENE_CANVAS_H = cw, ch
    end
    local prev_canvas = love.graphics.getCanvas()
    love.graphics.setCanvas(FAC_SCENE_CANVAS)
    love.graphics.clear(0, 0, 0, 0)
    FAC_STATUS_QUEUE = {}
    fac_draw_scene_content(state, 0, 0, cw, ch)

    local status_queue = FAC_STATUS_QUEUE
    FAC_STATUS_QUEUE = nil
    love.graphics.setCanvas({ prev_canvas, stencil = true })
    SMODS.reload_stencil_stack()

    local blit_alpha = 1
    if G.FISHING_STATE == G.FISHING_STATES.RESULTS and state.round_success then
        blit_alpha = fac_clamp(state.celebrate_t / FAC_CELEBRATE_DURATION, 0, 1)
    end
    love.graphics.setColor(1, 1, 1, blit_alpha)
    love.graphics.draw(FAC_SCENE_CANVAS, px, py, 0, pw / cw, ph / ch)

    local screen_scale = G.TILESCALE * G.TILESIZE
    local scale_x, scale_y = pw / cw, ph / ch
    for index = 1, 2 do
        local status = G.FISHING["fishing_status_" .. index]
        local status_data = status_queue[index]
        if status then
            status.states.visible = status_data ~= nil
            if status_data then
                state["status_text_" .. index] = status_data.str
                local status_x = (px + (status_data.x + 18) * scale_x) / screen_scale
                local status_y = (py + (status_data.y - 4) * scale_y) / screen_scale
                status:hard_set_T(status_x, status_y, status.T.w, status.T.h)
                status:recalculate()

                local text = status:get_UIE_by_ID("fac_fishing_status_text_" .. index)
                if text then
                    text.config.colour = {
                        status_data.colour[1],
                        status_data.colour[2],
                        status_data.colour[3],
                        (status_data.colour[4] or 1) * blit_alpha,
                    }
                    text:update_text()
                end
                local bg = status:get_UIE_by_ID("fac_fishing_status_bg_" .. index)
                if bg then bg.config.colour[4] = 0.65 * blit_alpha end
                status:draw()
            end
        end
    end
end

FishAndChips.render_fishing_minigame = fac_draw_panel