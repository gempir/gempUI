local F, G, V = unpack(select(2, ...))


local function CreateMarkerButton(btnName, iconnum, x, y)
	local frame = CreateFrame("Button", btnName, gWorldmarkers);
	frame:SetPoint("CENTER", gWorldmarkers, x, y)
	frame:SetWidth(22);
	frame:SetHeight(22);
	frame:SetAttribute("type", "macro");
	
	t = frame:CreateTexture("raidicon")
	t:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. iconnum)
	t:SetAllPoints()

	F.createOverlay(frame)
end

CreateMarkerButton("WM_YellowFlareSet", 1, -77, -24);
WM_YellowFlareSet:SetAttribute("macrotext", "/wm 5");

CreateMarkerButton("WM_BlueFlareSet", 6, -55, -24);
WM_BlueFlareSet:SetAttribute("macrotext", "/wm 1");

CreateMarkerButton("WM_OrangeFlareSet", 2, -33, -24);
WM_OrangeFlareSet:SetAttribute("macrotext", "/wm 6");

CreateMarkerButton("WM_PinkFlareSet", 3, -11, -24);
WM_PinkFlareSet:SetAttribute("macrotext", "/wm 3");

CreateMarkerButton("WM_GreenFlareSet", 4, 11, -24);
WM_GreenFlareSet:SetAttribute("macrotext", "/wm 2");

CreateMarkerButton("WM_RedFlareSet", 7, 33, -24);
WM_RedFlareSet:SetAttribute("macrotext", "/wm 4");

CreateMarkerButton("WM_MoonFlareSet", 5, 55, -24);
WM_MoonFlareSet:SetAttribute("macrotext", "/wm 7");

CreateMarkerButton("WM_SkullFlareSet", 8, 77, -24);
WM_SkullFlareSet:SetAttribute("macrotext", "/wm 8");

-- clear the worldmarkers

local function CreateMarkerClearButton(btnName, x, y)
	local frame = CreateFrame("Button", btnName, gWorldmarkers);
	frame:SetPoint("CENTER", gWorldmarkers, x, y)
	frame:SetWidth(22);
	frame:SetHeight(22);
	frame:SetAttribute("type", "macro");

	t = frame:CreateFontString("raidicon")
	t:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\roboto.ttf", 14, "THINOUTLINE");
	t:SetText("X");
	t:SetPoint("CENTER", frame, "CENTER", 0, 0);

	F.createOverlay(frame)
end


CreateMarkerClearButton("WM_YellowFlareClear", -77, -3);
WM_YellowFlareClear:SetAttribute("macrotext", "/cwm 5");

CreateMarkerClearButton("WM_BlueFlareClear", -55, -3);
WM_BlueFlareClear:SetAttribute("macrotext", "/cwm 1");

CreateMarkerClearButton("WM_OrangeFlareClear", -33, -3);
WM_OrangeFlareClear:SetAttribute("macrotext", "/cwm 6");

CreateMarkerClearButton("WM_PinkFlareClear", -11, -3);
WM_PinkFlareClear:SetAttribute("macrotext", "/cwm 3");

CreateMarkerClearButton("WM_GreenFlareClear", 11, -3);
WM_GreenFlareClear:SetAttribute("macrotext", "/cwm 2");

CreateMarkerClearButton("WM_RedFlareClear", 33, -3);
WM_RedFlareClear:SetAttribute("macrotext", "/cwm 4");

CreateMarkerClearButton("WM_MoonFlareClear", 55, -3);
WM_MoonFlareClear:SetAttribute("macrotext", "/cwm 7");

CreateMarkerClearButton("WM_SkullFlareClear", 77, -3);
WM_SkullFlareClear:SetAttribute("macrotext", "/cwm 8");



-- Rolecheck / ReadyCheck / Clear All

local function CreateRaidButton(btnName, text, x, y)
	local frame = CreateFrame("Button", btnName, gWorldmarkers);
	frame:SetPoint("CENTER", gWorldmarkers, x, y)
	frame:SetWidth(60);
	frame:SetHeight(25);
	frame:SetAttribute("type", "macro");
	
	t = frame:CreateFontString("raidbutton")
	t:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 13, "THINOUTLINE");
	t:SetText(text);
	t:SetPoint("CENTER", frame, "CENTER", 2, 0);

	F.createBorder(frame)
	F.createOverlay(frame)
end

CreateRaidButton("wReadycheck", "Ready", -59, 23);
wReadycheck:SetAttribute("macrotext", "/readycheck");

CreateRaidButton("wRolecheck", "Role", 0, 23);
wRolecheck:SetAttribute("macrotext", "/run InitiateRolePoll()");

CreateRaidButton("wClearAll", "Clear", 59, 23);
wClearAll:SetAttribute("macrotext", "/cwm all");