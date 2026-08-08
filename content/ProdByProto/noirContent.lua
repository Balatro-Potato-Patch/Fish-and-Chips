local facp = FishAndChips.ProdByProto

--[[
facp.items = {
    ["soda"] = {0,0}
    [""]
}
function facp.init_mark_item(args)
    SMODS.create_sprite(0, 0, G.CARD_W, G.CARD_H, "fac_proto_items", { x = , y = args.pos.y })
end

SMODS.DrawStep({
    key = "mark_card",
    -- stickers also have an order of 40
    order = 40,
    func = function(self, layer)
        -- check if the card is in fact marked
        if self.ability and self.ability.your_mark_indicator_variable then
            -- for drawing alignment purposes
            facp.mark_sprite.role.draw_major = self
            -- draw the actual sprite
            facp.mark_sprite:draw_shader("dissolve", nil, nil, nil, self.children.center)
        end
    end,
    -- just to ensure that the sprite is not drawn at the wrong times
    conditions = { vortex = false, facing = "front" },
})
]]

FishAndChips.Fish {
	key = "proto_noir",
    atlas = "Joker", --atlas = "proto_fish",
	pos = { x = 0, y = 0 },

	weight = 15,
    ppu_coder = {"ProdByProto"},
	attributes = { "usable","generation","destroy_card" },
	environments = FishAndChips.ProdByProto.addEnvs(),

	config = {
		extra = {
			
		}
	},

	loc_vars = function(self, info_queue, card)
        --idk (sterling)
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