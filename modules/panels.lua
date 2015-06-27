-- main_middle_panel

if gempUI.actionbars_main_three then
	extrabars_1 = 39
elseif not gempUI.actionbars_main_three then
	extrabars_1 = 0
end


local gempUI_mainpanel = CreateFrame("Frame",nil,UIParent)
gempUI_mainpanel:SetFrameStrata("BACKGROUND")
gempUI_mainpanel:SetWidth(476) 
gempUI_mainpanel:SetHeight(86+extrabars_1) 
gempUI_mainpanel:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gempUI_mainpanel:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
gempUI_mainpanel:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gempUI_mainpanel:SetPoint("BOTTOM",0,-1)
gempUI_mainpanel:Show()



-- main_side_panel

if gempUI.actionbars_side_two then
	extrabars_2 = 39
elseif not gempUI.actionbars_side_two then
	extrabars_2 = 0
end


local gempUI_sidepanel = CreateFrame("Frame",nil,UIParent)
gempUI_sidepanel:SetFrameStrata("BACKGROUND")
gempUI_sidepanel:SetWidth(47+extrabars_2) 
gempUI_sidepanel:SetHeight(476) 
gempUI_sidepanel:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gempUI_sidepanel:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
gempUI_sidepanel:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gempUI_sidepanel:SetPoint("RIGHT",1,0)
gempUI_sidepanel:Show()


-- bagslots panel


gempUI_bagpanel = CreateFrame("Frame", nil, UIParent)
gempUI_bagpanel:SetFrameStrata("BACKGROUND")
gempUI_bagpanel:SetWidth(47+extrabars_2) 
gempUI_bagpanel:SetHeight(144) 
gempUI_bagpanel:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gempUI_bagpanel:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
gempUI_bagpanel:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gempUI_bagpanel:SetPoint("RIGHT",1,-309)
gempUI_bagpanel:Hide()


local function Container_OnShow(self)
    local id = self.id --container ID
    gempUI_bagpanel:Show()
	CharacterBag0Slot:Show()
	CharacterBag1Slot:Show()
	CharacterBag2Slot:Show()
	CharacterBag3Slot:Show()
end
for i=1, NUM_CONTAINER_FRAMES do
    local frame = _G["ContainerFrame"..i];
    if frame then
        frame:HookScript("OnShow", Container_OnShow)
    end
end

local function Container_OnHide(self)
    local id = self.id --container ID
    gempUI_bagpanel:Hide()
	CharacterBag0Slot:Hide()
	CharacterBag1Slot:Hide()
	CharacterBag2Slot:Hide()
	CharacterBag3Slot:Hide()
end

    local frame = _G["ContainerFrame"..1];
    local frame2 = _G["ContainerFrame"..2];
    local frame3 = _G["ContainerFrame"..3];
    local frame4 = _G["ContainerFrame"..4];

    if frame and frame2 and frame3 and frame4 then
        frame:HookScript("OnHide", Container_OnHide)
    end
