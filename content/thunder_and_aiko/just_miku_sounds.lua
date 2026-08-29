

FishAndChipsThunderEdgeAiko.MikuSounds = { 
    "ado_readymade", "ado_usseewa", "asi_super_idol_105_jp", "astra_im_gonna_get_you", 
    "certified_hood_classic", "credit_card_in_buffoon_pack", "deco_monitoring", "deco_vampire", 
    "ed_sheeran_perfect", "fire_in_the_hole", "flowery_here_i_come_san_frandisco", "flowery_its_my_jarona", 
    "frederic_oddloop", "iosys_cirno_s_perfect_math_class", "jamiroquai_virtual_insanity", "justin_bieber_baby", 
    "kairikibear_darling_dance", "kanaria_king", "kessoku_band_seishun_complex", "kurousap_senbonzakura", "kz_tell_your_world", 
    "laura_shigihara_zombie_on_your_lawn", "lena_raine_pigstep", "leonz_among_us", "ligma", "mc_movie_chicken_jockey", "michael_jackson_smooth_criminal", 
    "nayutalien_alien_alien", "paket_phoenix", "portal_glados_boss_entrance", "queen_another_one_bites_the_dust", "rick_astley_never_gonna", "ryo_world_is_mine", 
    "sangatsu_no_phantasia_seishun_nante_iranaiwa", "shadow_wizard_money_gang", "six_seven", "smash_mouth_all_star", "three_maisondes_love_trap_muchuu", 
    "toby_fox_cutie_mew_mew_magic", "toby_fox_flower_man_en", "toby_fox_flower_man_jp", "tuyu_doro_no_bunzai", "tuyu_loser_girl", "yoasobi_gunjou", 
    "yorushika_itte", "yorushika_yoru_magai", "yoshimotoojisan_ojisan_koubun", "zutomayo_shade",
}
FishAndChipsThunderEdgeAiko.MikuSoundsObjects = {}

for i, sound_keys in ipairs(FishAndChipsThunderEdgeAiko.MikuSounds) do
    FishAndChipsThunderEdgeAiko.MikuSoundsObjects[#FishAndChipsThunderEdgeAiko.MikuSoundsObjects+1] = SMODS.Sound{
        key = "thunder_aiko_miku_"..sound_keys,
        path = "thunder_and_aiko/miku/"..sound_keys..".ogg",
        fac_is_miku_sound = true,
    }
end

FishAndChipsThunderEdgeAiko.play_random_miku_sound = function (volume)
    G.SOUND_MANAGER.channel:push({ type = 'fac_th_ai_stop' }) 
    local sound_key = pseudorandom_element(FishAndChipsThunderEdgeAiko.MikuSounds, "FishAndChipsThunderEdgeAiko.play_random_miku_sound")
    play_sound("fac_thunder_aiko_miku_"..sound_key, nil, volume)
end