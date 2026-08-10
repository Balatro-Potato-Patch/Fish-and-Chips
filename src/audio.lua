local FAC_MOD_PATH = SMODS.current_mod.path
local FAC_REEL_SOUND_FILES = {
    fac_reeling_in = "assets/sounds/core/reeling in.ogg",
    fac_pulling_drag = "assets/sounds/core/pulling drag.ogg",
}
local fac_reel_sound_cache = {}

local function fac_get_reel_sound(key)
    if fac_reel_sound_cache[key] == nil then
        local rel_path = FAC_REEL_SOUND_FILES[key]
        local file_data = rel_path and SMODS.NFS.newFileData(FAC_MOD_PATH .. rel_path)
        local source = file_data and love.audio.newSource(file_data, "stream")
        if source then
            source:setVolume(G.SETTINGS.SOUND.volume*G.SETTINGS.SOUND.game_sounds_volume/(100*100))
            source:setLooping(true)
        end
        fac_reel_sound_cache[key] = source or false
    end
    return fac_reel_sound_cache[key] or nil
    -- hi murphy
end

function FishAndChips.handle_reel_sound()
    local source = FishAndChips.current_reel_sound and fac_get_reel_sound(FishAndChips.current_reel_sound)
    if source and not source:isPlaying() then
        source:play()
    end
end

function FishAndChips.stop_reel_sound()
    for _, source in pairs(fac_reel_sound_cache) do
        if source and source:isPlaying() then
            source:stop()
        end
    end
end

local fac_ambience_cache = {}

local function fac_get_ambience_sound(key)
    if fac_ambience_cache[key] == nil then
        local path = SMODS.Sounds[key].full_path
        local file_data = path and SMODS.NFS.newFileData(path)
        local source = file_data and love.audio.newSource(file_data, "stream")
        if source then
            source:setVolume(G.SETTINGS.SOUND.volume*G.SETTINGS.SOUND.game_sounds_volume/(100*100))
            source:setLooping(true)
        end
        fac_ambience_cache[key] = source or false
    end
    return fac_ambience_cache[key] or nil
end

function FishAndChips.handle_ambience()
    if FishAndChips.mod.config.ambience then
        local ambience_key = FishAndChips.get_environment().ambience
        local source = ambience_key and fac_get_ambience_sound(ambience_key)
        if source and not source:isPlaying() then
            source:play()
        end
    end
end

function FishAndChips.stop_ambience()
    for _, source in pairs(fac_ambience_cache) do
        if source and source:isPlaying() then
            source:stop()
        end
    end
end

function FishAndChips.update_sound_volume()
    for _, source in pairs(fac_reel_sound_cache) do
        if source and source:isPlaying() then
            source:setVolume(G.SETTINGS.SOUND.volume*G.SETTINGS.SOUND.game_sounds_volume/(100*100))
        end
    end
    for _, source in pairs(fac_ambience_cache) do
        if source and source:isPlaying() then
            source:setVolume(G.SETTINGS.SOUND.volume*G.SETTINGS.SOUND.game_sounds_volume/(100*100))
        end
    end
end
