local F, G, V = unpack(select(2, ...))

-- redoes a lot of simple tooltips like the micromenu on the minimap
F.rebackdrop(DropDownList1MenuBackdrop)
F.rebackdrop(ItemRefTooltip)

ItemRefCloseButton:SetNormalTexture(G.media.."blizzard\\buttons\\close")
ItemRefCloseButton:SetHighlightTexture(G.media.."blizzard\\highlights\\32_round")
ItemRefCloseButton:SetPushedTexture(nil)