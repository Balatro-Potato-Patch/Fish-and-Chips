local once = true
PotatoPatchUtils.Developer({
	name = 'minty',
	--atlas = 'fac_cards',
	colour = HEX("CA7CA7"),
    loc = true,
    click = function (self)
        local pct = (80 + math.random(40))/100
        play_sound("fac_minty_meow", pct)
        if once then
            once = false
            love.system.openURL("https://github.com/wingedcatgirl/")
        end
    end
})