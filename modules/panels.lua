local F, G, V = unpack(select(2, ...))





F.onOptionsLoaded(function() 
	gempUI_mainpanel = CreateFrame("Frame", nil, UIParent)
	gempUI_mainpanel:SetFrameStrata("BACKGROUND")
	F.addBackdrop(gempUI_mainpanel)
	gempUI_mainpanel:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 48)
	gempUI_mainpanel:SetSize(242, 126)
	gempUI_mainpanel:Show()
end)

local gempUI_sidepanel = CreateFrame("Frame", nil, UIParent)
gempUI_sidepanel:SetFrameStrata("BACKGROUND")
gempUI_sidepanel:SetWidth(47)
gempUI_sidepanel:SetHeight(318)
F.addBackdrop(gempUI_sidepanel)
gempUI_sidepanel:SetPoint("RIGHT", 1, 0)
gempUI_sidepanel:Show()


-- bagslots panel


gempUI_bagpanel = CreateFrame("Frame", nil, UIParent)
gempUI_bagpanel:SetFrameStrata("BACKGROUND")
gempUI_bagpanel:SetWidth(47)
gempUI_bagpanel:SetHeight(144)
F.addBackdrop(gempUI_bagpanel)
gempUI_bagpanel:SetPoint("RIGHT", 1, -230)
gempUI_bagpanel:Hide()


local function Container_OnShow(self)
	local id = self.id --container ID
	gempUI_bagpanel:Show()
	CharacterBag0Slot:Show()
	CharacterBag1Slot:Show()
	CharacterBag2Slot:Show()
	CharacterBag3Slot:Show()
end

for i = 1, NUM_CONTAINER_FRAMES do
	local frame = _G["ContainerFrame" .. i];
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

local frame = _G["ContainerFrame" .. 1];
local frame2 = _G["ContainerFrame" .. 2];
local frame3 = _G["ContainerFrame" .. 3];
local frame4 = _G["ContainerFrame" .. 4];

if frame and frame2 and frame3 and frame4 then
	frame:HookScript("OnHide", Container_OnHide)
end


