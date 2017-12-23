local F, G, V = unpack(select(2, ...))

-- removes the green border
CharacterBag0Slot.IconBorder:SetTexture(0,0,0,0)
CharacterBag1Slot.IconBorder:SetTexture(0,0,0,0)
CharacterBag2Slot.IconBorder:SetTexture(0,0,0,0)
CharacterBag3Slot.IconBorder:SetTexture(0,0,0,0)


CharacterBag0Slot:SetPoint("RIGHT", UIParent, "RIGHT", -6, -358)
CharacterBag1Slot:SetPoint("RIGHT", UIParent, "RIGHT", -6, -326)
CharacterBag2Slot:SetPoint("RIGHT", UIParent, "RIGHT", -6, -294)
CharacterBag3Slot:SetPoint("RIGHT", UIParent, "RIGHT", -6, -262)


CharacterBag0Slot:Hide()
CharacterBag1Slot:Hide()
CharacterBag2Slot:Hide()
CharacterBag3Slot:Hide()

