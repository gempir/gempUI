local F, G, V = unpack(select(2, ...))


-------------------------------------------------------
-- WORLDMARKERS BUTTON
-------------------------------------------------------

local dmgButton = CreateFrame("Button", "button_gDamage", UIParent)
dmgButton:SetPoint("CENTER", UIParent, "TOPRIGHT", -154, -196)
dmgButton:SetWidth(60)
dmgButton:SetHeight(25)
dmgButton:RegisterForClicks("LeftButtonDown")
dmgButton:SetFrameStrata("BACKGROUND")
dmgButton:SetScript("OnClick", function()

	gDMG_Toggle()

end)

F.addBackdrop(dmgButton)
F.createOverlay(dmgButton)


-------------------------------------------------------
-- AUTOMATOR CONFIG BUTTON
-------------------------------------------------------

local amButton = CreateFrame("Button", "button_gAutomatorConfig", UIParent)

amButton:SetPoint("CENTER", UIParent, "TOPRIGHT", -95, -196)
amButton:SetWidth(60)
amButton:SetHeight(25)
amButton:SetFrameStrata("BACKGROUND")
amButton:RegisterForClicks("LeftButtonDown")
amButton:SetScript("OnClick", function()

	if gAC_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -201)
	elseif not gAC_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -273)
	end

	gAC_Toggle()
end)

F.addBackdrop(amButton)
F.createOverlay(amButton)


-------------------------------------------------------
-- DAMAGE ADDON BUTTON 
-------------------------------------------------------
local wmButton = CreateFrame("Button", "button_gWorldmarkers", UIParent)

wmButton:SetPoint("CENTER", UIParent, "TOPRIGHT", -36, -196)
wmButton:SetWidth(60)
wmButton:SetHeight(25)
wmButton:SetFrameStrata("BACKGROUND")
wmButton:RegisterForClicks("LeftButtonDown")
wmButton:SetScript("OnClick", function()

	if gWM_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -201)
	elseif not gWM_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -271)
	end

	gWM_Toggle()
end)

F.addBackdrop(wmButton)
F.createOverlay(wmButton)
