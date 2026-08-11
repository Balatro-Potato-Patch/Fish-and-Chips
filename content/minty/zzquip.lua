SMODS.JimboQuip{
    key = "minty_trauma_center",
    type = "loss",
    extra = {
        times = 3,
        sound = "fac_minty_slash",
        delay = 0.3,
        pitch = 0.95
    },
    filter = function (self, type)
        if next(SMODS.find_card("fish_fac_minty_kyriaki")) then
            return true
        end
    end
}