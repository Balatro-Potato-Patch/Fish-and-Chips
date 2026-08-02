FishAndChips.Fish {
    key = "blamperer_voucher",
    atlas = "fitch",
    pos = { x = 4, y = 0 },
    ppu_coder = { "blamperer" },
    ppu_artist = { "blamperer" },
    attributes = {
        "usable"
    },
    stats = {
        weight = { min = 0.0018, max = 0.0018 },
        length = { min = 0.0889, max = 0.0889 },
    },
    weight = 4,
    environments = {
        city_river = 10,
        pier = 3
    },
    -- This will probably look dumb
    -- set_ability = function(self, card, initial, delay_sprites)
    --     card.ability.perishable = true
    --     card.ability.perish_tally = 3
    -- end,
    can_use = function(self, card)
        return G.STATE == G.STATES.SHOP
    end,
    use = function(self, card)
        SMODS.add_voucher_to_shop(nil, true)
        G.GAME.pool_flags.fac_blamperer_vouched = true
        SMODS.destroy_cards(card, { pinch_anim = true })
    end,
    no_pool_flag = "fac_blamperer_vouched"
}
