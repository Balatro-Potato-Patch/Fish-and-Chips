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
    end,
    calculate = function (self, context)
        if not G.GAME.minty_fac_init then
            G.GAME.minty_fac_init = true
            G.GAME.minty_seabass_chummed = {}
            G.GAME.minty_seabass_eradicated = {}
        end

        if context.check_eternal and context.other_card.config.center.key == "fish_fac_minty_seabass" and context.trigger.from_sell then
            return {
                no_destroy = true
            }
        end
    end,
})