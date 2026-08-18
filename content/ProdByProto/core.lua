SMODS.Atlas({
	key = "proto_dev",
	path = "ProdByProto/pfp.png",
	px = 684,
	py = 684,
})

PotatoPatchUtils.Developer({
	name = "ProdByProto",
    colour = HEX("d66b1c"),
    loc = true,
    atlas = "fac_proto_dev",
    display_size = {w,h = 684,684},
    click = function ()
        love.system.openURL("https://ko-fi.com/foxgirlproto/")
    end
})


SMODS.Atlas({
	key = "proto_noName",
	path = "ProdByProto/noName.png",
	px = 256,
	py = 192,
})

SMODS.Atlas({
	key = "proto_fish",
	path = "ProdByProto/fish.png",
	px = 71,
	py = 95,
})

SMODS.Atlas({
    key = "proto_items",
    path = "ProdByProto/noir_items.png",
    px = 71,
    py = 95
})


SMODS.Font({
    key = "helvetica",
    path = "ProdByProto/Helvetica.ttf",
})

SMODS.Font({
    key = "handwriting",
    path = "ProdByProto/slwronghandfont/SlWronghandRegularDemoxRDeR.ttf",
})

SMODS.Font({
    key = "playfair",
    path = "ProdByProto/playfair/PlayfairDisplay-Bold.ttf",
})


SMODS.Sound{
    key = "music_jersey",
    path = "ProdByProto/music_jersey.ogg",
    pitch = 1,
    volume = 0.8,
    select_music_track = function (self)
        if G.GAME and not G.screenwipe and G.GAME.proto_q_music == "jclub" and FishAndChips.mod.config.noir_music then
            return 1.7e308
        end
    end
}

SMODS.Sound{
    key = "music_noir1",
    path = "ProdByProto/music_noir1.ogg",
    pitch = 1,
    volume = 0.8,
    select_music_track = function (self)
        if G.GAME and not G.screenwipe and G.GAME.proto_q_music == "noir1" and FishAndChips.mod.config.noir_music then
            return 1.7e308
        end
    end
}

SMODS.Sound{
    key = "music_noir2",
    path = "ProdByProto/music_noir2.ogg",
    pitch = 1,
    volume = 0.8,
    select_music_track = function (self)
        if G.GAME and not G.screenwipe and G.GAME.proto_q_music == "noir2" and FishAndChips.mod.config.noir_music then
            return 1.7e308
        end
    end
}


SMODS.ScreenShader{
    key = "proto_noir",
    path = "ProdByProto/noir.fs",
    should_apply = function(self)
        return G.GAME and G.GAME.proto_noirshade
    end
}


FishAndChips.ProdByProto = {}


function FishAndChips.ProdByProto.addEnvs()
	local envWeights = {}
	local envBuffer = FishAndChips.Environment.obj_buffer
	for i = 1, 6 do
		envWeights[envBuffer[i]] = 5 - ((0.5*i)-0.5)
	end
	return envWeights
end


function FishAndChips.ProdByProto.string_split(inputstr, sep)
	if sep == nil then sep = "%s" end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

function FishAndChips.ProdByProto.noirDialog(storyFlag)
    local nodes = {}
    local vars_ = {}
    local trueEnd = false
    if SMODS.find_card("fish_fac_proto_noir")[1] then local noirFish = SMODS.find_card("fish_fac_proto_noir")[1] end
    G.SETTINGS.paused = true
    if storyFlag == 6 then
        for _,item in pairs(noirFish.ability.extra.noir_inv) do
            if item == "true_memo" then
                trueEnd = true
            end
        end
        if trueEnd then
            vars_[1] = localize("proot_noir6a")
            vars_[2] = localize("proot_noir6b")
            vars_[3] = localize("proot_noir6c")
        else
            vars_[1] = localize("proot_noir6awkward")
            vars_[2] = localize("proot_noir6boring")
            vars_[3] = localize("proot_noir6colourless")
        end
    end
    if storyFlag == 7 then
        if G.GAME.proto_noirshade then G.GAME.proto_noirshade = false end
        vars_[1] = localize("proot_noir_congrats")
        vars_[2] = localize("proot_noir_finalgrade")
        if G.GAME.noir_pts < 145 then vars_[3] = "C\n" end
        if G.GAME.noir_pts < 185 then vars_[3] = "B\n" end
        if G.GAME.noir_pts > 184 then vars_[3] = "A\n" end
        vars_[4] = localize("proot_noir_finalitems")
        for _,item in ipairs(noirFish.ability.extra.noir_inv) do
            vars_[4] = vars_[4]..localize("proot_noir_"..item).." (+"..FishAndChips.ProdByProto.itemScores[item].Pts.." Pts.,".." x"..FishAndChips.ProdByProto.itemScores[item].xPts.." Pts.), \n"
        end
        vars_[5] = "\n"..localize("proot_noir_finalscore")..G.GAME.noir_pts.."\n"
        vars_[6] = localize("proot_noir_credits")
        local concatVars = table.concat(vars_,"")
        vars_ = {
            concatVars
        }
    end
    for _, str in ipairs(FishAndChips.ProdByProto.string_split(localize({ type = "variable", key = "proot_noir"..storyFlag, vars = vars_ }),"\n")) do 
        nodes[#nodes+1] = {n=G.UIT.R, config={}, nodes = {{n=G.UIT.T, config={text = str, scale = 0.3, colour = G.C.UI.TEXT_LIGHT, font = SMODS.Fonts["fac_playfair"]}}}}       
    end
    return create_UIBox_generic_options { --this function is vanilla its generic boilerplate stuff, its the thing that creates the "menu" and the back button
        contents = {{n=G.UIT.C, config={}, nodes = nodes}}
    }
end

function FishAndChips.ProdByProto.loadLevel(card,level)
    for _,iCard in pairs(G.playing_cards) do
        iCard.ability.noir_mark = nil
        iCard.ability.noir_plot = nil
        iCard.ability.noir_level = nil
        iCard.ability.aux = nil
    end
    for _,_ in pairs({1}) do
        if level > 12 then break end
        for _,item in pairs(card.ability.extra.noir_levels[level]) do
            local item_card = pseudorandom_element(G.playing_cards, "pick non item", {
                in_pool = function(v)
                    return not v.ability.noir_mark and SMODS.is_playing_card(v)
                end
            })
            if type(item) == "table" then
                if item[1] then item_card.ability.noir_mark = item[1] end
                if item[2] then item_card.ability.noir_plot = item[2] end
                if item[3] then item_card.ability.noir_level = item[3] end
            else
                if item then item_card.ability.noir_mark = item end
            end
            for _,jtem in pairs(FishAndChips.ProdByProto.auxItems) do
                item_card.ability.aux = (item_card.ability.noir_mark == jtem)
                if item_card.ability.aux then break end
            end
        end
    end
end

function FishAndChips.ProdByProto.testJokers(num)
    for i = 1, num do
        SMODS.add_card({ key = "j_stencil" })
    end
end