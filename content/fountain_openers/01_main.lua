FountainOpeners = {}

local alexi_text_colors = {
    HEX("45FFDA"),
    HEX("2AC2FF"),
    HEX("307FFF"),
    HEX("C180FF"),
    HEX("FFC7FF"),
}
local alexi_click_count = 5

local function dark_flip(card)
    local pos = card.children.center.sprite_pos
    card.children.center:set_sprite_pos({x=pos.x,y=1-pos.y})
    local pos2 = card.children.ppu_floating_sprite.sprite_pos
    card.children.ppu_floating_sprite:set_sprite_pos({x=pos2.x,y=1-pos2.y})
end

SMODS.DynaTextEffect {
    key = "alexi_text",
    func = function(dynatext, index, letter)
        local idx = math.min(index, 5)
        letter.colour = alexi_text_colors[idx]
        letter.offset.y = math.cos(G.TIMERS.REAL * 2.95 + index) * 9
    end,
}

PotatoPatchUtils.Developer {
	name = 'Alexi',
	atlas = 'fac_cards',
	text_effect = "fac_alexi_text",
	fac_partner = 'Grahkon',
	fac_dw_shader = true, -- thanks elleeeee love youuu :3
	click = function(self)
        -- dark_flip(self)

        play_sound("fac_fo_splat",1.5-alexi_click_count*0.1)
        self:juice_up()
        if alexi_click_count == 1 then
            love.system.openURL("https://en.pronouns.page/@invalidOS")
            alexi_click_count = 5
        else
            alexi_click_count = alexi_click_count - 1
        end
    end
}

PotatoPatchUtils.Developer {
	name = 'Grahkon',
	atlas = 'fac_cards',
	-- pos = {x = 1, y = 0},
	colour = G.C.GREEN,
	fac_partner = 'Alexi',
	fac_dw_shader = true,
}