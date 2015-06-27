
-- removes the green border
CharacterBag0Slot.IconBorder:SetTexture(0,0,0,0)
CharacterBag1Slot.IconBorder:SetTexture(0,0,0,0)
CharacterBag2Slot.IconBorder:SetTexture(0,0,0,0)
CharacterBag3Slot.IconBorder:SetTexture(0,0,0,0)

local moving
hooksecurefunc(CharacterBag0Slot, "SetPoint", function(self)
    if moving then
        return
    end
    moving = true
    self:SetMovable(true)
    self:SetUserPlaced(true)
    self:ClearAllPoints()
    self:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", 281, 250) -- Adjust the x, y values here
    self:SetMovable(false)
    moving = nil
end)
CharacterBag0Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -2, 200)

local moving
hooksecurefunc(CharacterBag1Slot, "SetPoint", function(self)
    if moving then
        return
    end
    moving = true
    self:SetMovable(true)
    self:SetUserPlaced(true)
    self:ClearAllPoints()
    self:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", 281, 218) -- Adjust the x, y values here
    self:SetMovable(false)
    moving = nil
end)
CharacterBag1Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -2, 200)

local moving
hooksecurefunc(CharacterBag2Slot, "SetPoint", function(self)
    if moving then
        return
    end
    moving = true
    self:SetMovable(true)
    self:SetUserPlaced(true)
    self:ClearAllPoints()
    self:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", 281, 186) -- Adjust the x, y values here
    self:SetMovable(false)

    moving = nil
end)
CharacterBag2Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -2, 200)

local moving
hooksecurefunc(CharacterBag3Slot, "SetPoint", function(self)
    if moving then
        return
    end
    moving = true
    self:SetMovable(true)
    self:SetUserPlaced(true)
    self:ClearAllPoints()
    self:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", 281, 154) -- Adjust the x, y values here
    self:SetMovable(false)

    moving = nil
end)
CharacterBag3Slot:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -2, 200)


CharacterBag0Slot:Hide()
CharacterBag1Slot:Hide()
CharacterBag2Slot:Hide()
CharacterBag3Slot:Hide()

