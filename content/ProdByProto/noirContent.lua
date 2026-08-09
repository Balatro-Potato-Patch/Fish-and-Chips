local fac = SMODS.Mods["FishAndChips"]
local loadFihHook = FishAndChips.ProdByProto.loadFih
FishAndChips.ProdByProto.loadFih = function()

	if loadFihHook then loadFihHook() end
	
    local facp = FishAndChips.ProdByProto


    facp.items = {
        soda = { x = 0, y = 0 },
        fabric = { x = 1, y = 0 },
        pen = { x = 2, y = 0 },
        bcard = { x = 3, y = 0 },
        booth = { x = 4, y = 0 },
        ledger = { x = 0, y = 1 },
        gun = { x = 1, y = 1 },
        knife = { x = 2, y = 1 },
        true_memo = { x = 3, y = 1},
        door = { x = 0, y = 2 },
        lockdoor = { x = 1, y = 2 },
        key = { x = 2, y = 2 }
    }

    function facp.init_mark_sprite(pos)
        return SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, "fac_proto_items", pos)
    end

    -- *feels the thunderedge*
    -- this is our table of all currently initialized sprites
    -- each key in this table should correspond to its respective sprite
    facp.item_sprites = {}

    SMODS.DrawStep({
        key = "proto_item",
        -- stickers also have an order of 40
        order = 40,
        func = function(self, layer)
            -- check if the card is marked and its mark corresponds to a valid mark in facp.items
            if self.ability and self.ability.noir_mark and facp.items[self.ability.noir_mark] then
                -- if item_sprites does not contain a sprite for our current mark, add that sprite to the table
                -- otherwise, we just use the already created sprite
                if not facp.item_sprites[self.ability.noir_mark] then
                    facp.item_sprites[self.ability.noir_mark] =
                        facp.init_mark_sprite(facp.items[self.ability.noir_mark])
                end
                -- for drawing alignment purposes
                facp.item_sprites[self.ability.noir_mark].role.draw_major = self
                -- draw the actual sprite
                facp.item_sprites[self.ability.noir_mark]:draw_shader("dissolve", nil, nil, nil, self.children.center)
            end
        end,
        -- just to ensure that the sprite is not drawn at the wrong times
        conditions = { vortex = false, facing = "front" },
    })


    function facp.noirProg(args)
        local contextTable = {}
        if args.flg then contextTable["noir_flag"] = args.flg end
        if args.lvl then contextTable["noir_level"] = args.lvl end
        SMODS.calculate_context(contextTable)
    end

    FishAndChips.Fish {
        key = "proto_noir",
        --atlas = "proto_fish",
        mod = fac,
        pos = { x = 0, y = 0 },

        stats = {
            weight = { min = 3.75, max = 4.5 },
            length = { min = 0.8, max = 1.4 }
        },
        weight = 25,
        ppu_coder = {"ProdByProto"},
        attributes = { "usable","generation","destroy_card" },
        environments = facp.addEnvs(),

        config = {
            extra = {
                storyActive = false,
                storyComplete = false,

            }
        },

        loc_vars = function(self, info_queue, card)
            --idk (sterling)
        end,


        use = function (self, card)
            local cae = card.ability.extra
            if not cae.storyActive then facp.noirProg({ flg = 1 }) end
        end,

        can_use = function(self, card)
            local cae = card.ability.extra
            return not cae.storyActive or not cae.storyComplete
        end,


        calculate = function(self, card, context)
            local cae = card.ability.extra


            if context.individual and context.cardarea == G.play then
                if context.other_card:get_id() == 13 and context.other_card:is_suit("Hearts") then
                    return {mult = cae.mult}
                end
            end

        end,
    }
end