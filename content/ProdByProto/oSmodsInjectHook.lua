local inj = SMODS.injectItems
function SMODS.injectItems(...)
    FishAndChips.ProdByProto.loadFih()
    inj(...)
end