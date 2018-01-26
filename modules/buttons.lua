local F, G, V = unpack(select(2, ...))

msButton = CreateFrame("Button", "button_gDamage", UIParent)
msButton:SetPoint("TOP", Minimap, "BOTTOM", -59, 1)
msButton:SetWidth(60)
msButton:SetHeight(25)
msButton:SetFrameStrata("BACKGROUND")
msButton:RegisterForClicks("LeftButtonDown")
F.addBackdrop(msButton)
F.createOverlay(msButton)


clockButton = CreateFrame("Button", "button_gAutomatorConfig", UIParent)
clockButton:SetPoint("TOP", Minimap, "BOTTOM", 0, 1)
clockButton:SetWidth(60)
clockButton:SetHeight(25)
clockButton:SetFrameStrata("BACKGROUND")
clockButton:RegisterForClicks("LeftButtonDown")
clockButton:SetScript("OnClick", function()
	if ( not IsAddOnLoaded("Blizzard_Calendar") ) then
		UIParentLoadAddOn("Blizzard_Calendar");
	end
	if ( Calendar_Toggle ) then
		Calendar_Toggle();
	end
end)
F.addBackdrop(clockButton)
F.createOverlay(clockButton)


fpsButton = CreateFrame("Button", "button_gRaid", UIParent)
fpsButton:SetPoint("TOP", Minimap, "BOTTOM", 59, 1)
fpsButton:SetWidth(60)
fpsButton:SetHeight(25)
fpsButton:SetFrameStrata("BACKGROUND")
fpsButton:RegisterForClicks("LeftButtonDown")
F.addBackdrop(fpsButton)
F.createOverlay(fpsButton)


gRaid = CreateFrame("Frame", "gRaid", UIParent);
gRaid:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -6, -207);
F.addBackdrop(gRaid)
gRaid:SetWidth(178);
gRaid:SetHeight(25);
gRaid:SetFrameStrata("background")
gRaid:Hide();

if UnitInParty("player") or UnitInRaid("player") then
	gRaid:Show();
end

gRaid:RegisterEvent("GROUP_ROSTER_UPDATE")
gRaid:SetScript("OnEvent", function()
	if UnitInParty("player") or UnitInRaid("player") then
		gRaid:Show();
	else 
		gRaid:Hide();
	end
end)

local function CreateRaidButton(text, x, y)
	local frame = CreateFrame("Button", nil, gRaid, "SecureActionButtonTemplate");
	frame:SetPoint("CENTER", gRaid, x, y)
	frame:SetWidth(60);
	frame:SetHeight(25);
	frame:SetAttribute("type", "macro");
	
	t = F.createFontString(frame)
	t:SetText(text);
	t:SetPoint("CENTER", frame, "CENTER", 2, 0);

	F.createBorder(frame)
	F.createOverlay(frame)

	return frame
end

wReadycheck = CreateRaidButton("Ready", -59, 0);
wReadycheck:SetScript("OnMouseDown", function(self, button)
	DoReadyCheck()
end)

wPull = CreateRaidButton("Pull 10", 0, 0);
wPull:SetScript("OnMouseDown", function(self, button)
	SlashCmdList["DEADLYBOSSMODSPULL"]("10")
end)

wRole = CreateRaidButton("Cancel", 59, 0);
wRole:SetScript("OnMouseDown", function(self, button)
	SlashCmdList["DEADLYBOSSMODSPULL"]("0")
end)
