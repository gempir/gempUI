local F, G, V = unpack(select(2, ...))


-- Rolecheck / ReadyCheck / Clear All

local function CreateRaidButton(text, x, y)
	local frame = CreateFrame("Button", nil, gWorldmarkers, "SecureActionButtonTemplate");
	frame:SetPoint("CENTER", gWorldmarkers, x, y)
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

