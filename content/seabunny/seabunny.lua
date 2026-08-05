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

local fish = {
    -- "skyfish"
}
for k, v in ipairs(fish) do
    assert(SMODS.load_file("content/seabunny/" .. v .. ".lua"), "Missing file: content/seabunny/" .. v .. ".lua")()
end