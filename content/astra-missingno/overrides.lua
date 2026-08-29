local am_select_from_pack_ref = Card.selectable_from_pack
function Card.selectable_from_pack(card, pack)
    local area, can_also_use = am_select_from_pack_ref(card, pack)
    if card.created_by_missingno then
        if not area and not card:can_use_consumeable() then
            area = 'consumeables'
        end
    end
    return area, can_also_use
end