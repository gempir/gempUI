local F, G, V = unpack(select(2, ...))


local position_a = "TOP"
local position_b = "TOP"
local position_x = 0
local position_y = -6
local width = 250
local height = 15
local bgcolor = { G.color.r, G.color.g, G.color.b, G.color.a }
local bordercolor = { G.bordercolor.r, G.bordercolor.g, G.bordercolor.b }
local font = { "Interface\\Addons\\gempUI\\media\\fonts\\square.ttf", 12, "THINOUTLINE" }
-----------------------------

gThreat = CreateFrame("StatusBar", "gThreat", UIParent)
gThreat:Show()
gThreat:SetPoint(position_a, UIParent, position_b, position_x, position_y)
gThreat:SetWidth(width)
gThreat:SetHeight(height)
gThreat:SetStatusBarTexture("Interface\\AddOns\\gempUI\\media\\textures\\flat")
gThreat:SetStatusBarColor(0 / 255, 150 / 255, 50 / 255)
gThreat:SetMinMaxValues(0, 100)
gThreat:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", insets = { left = 0, right = 0, top = 0, bottom = 0 } })
gThreat:SetBackdropColor(unpack(bgcolor))
gThreat:Hide()

local threatText = gThreat:CreateFontString(nil, "OVERLAY")
threatText:SetPoint("CENTER", gThreat, "CENTER", 0, 0)
threatText:SetFont(unpack(font))
threatText:SetTextColor(1, 1, 1)

gThreat:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
gThreat:RegisterEvent("PLAYER_TARGET_CHANGED")
gThreat:RegisterEvent("PLAYER_REGEN_DISABLED")
gThreat:SetScript("OnEvent", onEvent)
local function eventHandler(self, event, ...)

	if UnitAffectingCombat("player") then
		gThreat:Show()
	end

	local _, _, threatpct, _, _ = UnitDetailedThreatSituation("player", "target");
	if threatpct == nil then
		threatlevel = 0
	else
		threatlevel = threatpct
	end
	if threatlevel >= 100 then
		gThreat:SetStatusBarColor(160 / 255, 10 / 255, 10 / 255)
	elseif threatlevel < 50 then
		gThreat:SetStatusBarColor(0 / 255, 150 / 255, 50 / 255)
	elseif threatlevel > 50 then
		gThreat:SetStatusBarColor(220 / 255, 220 / 255, 20 / 255)
	end

	threatlevel = floor(threatlevel, .1)

	gThreat:SetValue(threatlevel)

	threatText:SetText(threatlevel)
end

gThreat:SetScript("OnEvent", eventHandler);

local border = CreateFrame("frame", nil, gThreat)
border:ClearAllPoints()
border:SetPoint("CENTER", gThreat, "CENTER", 0, 0)
border:SetSize(width + 2, height + 2)
border:SetFrameStrata("BACKGROUND")
border:SetBackdrop({
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Buttons\\WHITE8x8",
	edgeSize = 1,
	insets = { left = -0, right = -0, top = -0, bottom = -0 }
})
border:SetBackdropColor(0, 0, 0, 1)
border:SetBackdropBorderColor(unpack(bordercolor))

local frame = CreateFrame("frame")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:SetScript("OnEvent", onEvent)
local function eventHandler(self, event, ...)
	gThreat:Hide()
end

frame:SetScript("OnEvent", eventHandler);