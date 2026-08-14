local once = true
PotatoPatchUtils.Developer({
	name = 'minty',
	atlas = 'fac_minty_credit',
    pos = {x=0, y=0},
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

        if context.fac_fish_caught and context.fish == "fish_fac_minty_kyriaki" then
            if context.perfect then
                play_sound("fac_minty_cool")
            else
                play_sound("fac_minty_good")
            end
        end

        if context.check_eternal and context.other_card.config.center.key == "fish_fac_minty_seabass" and context.trigger.from_sell then
            return {
                no_destroy = true
            }
        end
    end,
    set_line_boil = function (self, center, card, row, force)
        if (G.SETTINGS.reduced_motion or force) and not card.nomotion then
            card.nomotion = true
            center.atlas = "fac_minty_nolineboilfish"
            center.pos = {x=0,y=row}
            card:set_sprites(center)
        end
        if (not G.SETTINGS.reduced_motion or force == false) and (card.nomotion ~= false) then
            card.nomotion = false
            center.atlas = "fac_minty_lineboilfish"
            center.pos = {y=row}
            card:set_sprites(center)
        end
    end,
    get_lineboil_atlas_info = function (self, row)
        if not row then return nil end --placeholder escape hatch, should be able to remove this once all the fish have art
        if G.SETTINGS.reduced_motion then
            return "minty_nolineboilfish", {x=0, y=row}
        else
            return "minty_lineboilfish", {x = 0, y=row}
        end
    end
})