-- Potato Patch Utils
PotatoPatchUtils.Developer {
  name = "ouiiskey",
  colour = HEX("f96932"),
  atlas = "fac_seabunny",
  pos = {x = 0, y = 0},
  fac_partner = "Lusha"
}

SMODS.Shader {
  key = "lusha",
  path = "seabunny/lusha.fs"
}

PotatoPatchUtils.Developer {
  name = "Lusha",
  colour = HEX("f35555"),
  shaders = {"fac_lusha"},
  atlas = "fac_seabunny",
  pos = {x = 0, y = 0},
  fac_partner = "ouiiskey"
}

-- Fish
SMODS.Atlas {
    key = "seabunny",
    path = "seabunny/fish.png",
    px = 71,
    py = 95
}

SEABUN = {
  weight = 75 / 1
}