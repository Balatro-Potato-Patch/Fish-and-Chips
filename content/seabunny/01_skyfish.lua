-- Skyfish
FishAndChips.Fish {
    key = "skyfish",
    atlas = "seabunny",
    pos = {x = 0, y = 0},
    config = {extra = {max = 1, shrink = 0.1}},
    blueprint_compat = true,
    badge_key = "k_fac_seabunny_uma",
    decision_min = 0,
    decision_max = 0.24,
    disable_visual_scaling = true,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.max, 100 * card.ability.extra.shrink}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local prev_l = card.ability.stats.length
            card.ability.stats.length = math.min(2 * card.ability.stats.length, card.ability.extra.max)
            return {
                message = localize{type = "variable", key = "a_fac_seabunny_cm", vars = {100 * (card.ability.stats.length - prev_l)}}
            }
        end
    end,
    use = function(self, card, area)
        FishAndChips.create_baits_from_card(card, 1, 'bait_fac_normal')
        card.ability.stats.length = card.ability.stats.length - card.ability.extra.shrink
    end,
    can_use = function(self, card)
        return true
    end,
    keep_on_use = function(self, card)
        return card.ability.stats.length >= 2 * card.ability.extra.shrink
    end,
    weight = 4,
    attributes = {"usable", "generation"},
    environments = {
        calm_pond = 20,
        swamp = 50,
        backroom = 10,
    },
    ppu_coder = {"ouiiskey"},
    ppu_artist = {"Lusha"},
    stats = {
        weight = {min = 0, max = 0},
        length = {min = 0.1, max = 0.2}
    },
    draw = function(self, card, layer)
        if card.ability.stats then
            for i = 2, 10 do
                local key = "segment" .. i
                if card.children[key] then
                    if card.ability.stats.length * 10 < i then
                        card.children[key]:remove()
                        card.children[key] = nil
                    elseif not card._fac_bucketed then
                        local x = (1 - i) * card.T.w * 31 / 71
                        card.children[key]:draw_shader("dissolve", 0, nil, nil, card.children.center, card.VT.scale * (1 - 0.2 * card.shadow_height) - 1, nil, x - card.shadow_parrallax.x * card.shadow_height, -card.shadow_parrallax.y * card.shadow_height)
                        card.children[key]:draw_shader("dissolve", nil, nil, nil, card.children.center, card.VT.scale - 1, nil, x)
                        
                        if card.edition and not card.delay_edition then
                            for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                                if card.edition[v.key:sub(3)] and v.shader then
                                    if type(v.draw) == 'function' then
                                        v:draw(card.children[key], layer)
                                    else
                                        card.children[key]:draw_shader(v.shader, nil, nil, nil, card.children.center, card.VT.scale - 1, nil, x)
                                    end
                                end
                            end
                            if card.edition.negative then
                                card.children[key]:draw_shader('negative_shine', nil, nil, nil, card.children.center, card.VT.scale - 1, nil, x)
                            end
                        end
                    end
                elseif card.ability.stats.length * 10 >= i then
                    card.children[key] = SMODS.create_sprite(card.T.x, card.T.y, card.T.w, card.T.h, card.children.center.atlas, card.children.center.sprite_pos)
                    card.children[key].states.hover = card.states.hover
                    card.children[key].states.click = card.states.click
                    card.children[key].states.drag = card.states.drag
                    card.children[key].states.collide.can = true
                    card.children[key].custom_draw = true
                end
            end
        end
    end
}
