-------------------------------------------------------
-- WORLDMARKERS BUTTON
-------------------------------------------------------

local button = CreateFrame("Button", "button_gWorldmarkers", UIParent)

button:SetPoint("CENTER", UIParent, "TOPRIGHT", -154, -196)
button:SetWidth(60)
button:SetHeight(25)
button:RegisterForClicks("LeftButtonDown")
button:SetScript("OnClick", function()

	if gWM_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -201)
	elseif not gWM_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -271)
	end
	   
    gWM_Toggle()

end)

button:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -0, right = -0, top = -0, bottom = -0} 
					})
button:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
button:SetBackdropBorderColor(0,0,0,1)

local buttonOverlay = CreateFrame("Frame", nil, button)
      buttonOverlay:SetWidth(60)
      buttonOverlay:SetHeight(25)
      buttonOverlay:SetPoint("CENTER", button, "CENTER", 0,0)
	  buttonOverlay:SetBackdrop({
			bgFile = [[Interface\Buttons\WHITE8x8]],
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 1,
		})
	  buttonOverlay:SetBackdropColor(0,0,0,0)
	  buttonOverlay:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
	  button:EnableMouse()
	  button:SetScript('OnEnter', function() buttonOverlay:SetBackdropColor(1,1,1,0.15) end)
	  button:SetScript('OnLeave', function() buttonOverlay:SetBackdropColor(0,0,0,0) end)


-------------------------------------------------------
-- AUTOMATOR CONFIG BUTTON
-------------------------------------------------------

local button = CreateFrame("Button", "button_gAutomatorConfig", UIParent)

button:SetPoint("CENTER", UIParent, "TOPRIGHT", -95, -196)
button:SetWidth(60)
button:SetHeight(25)
button:RegisterForClicks("LeftButtonDown")
button:SetScript("OnClick", function()
    
    if gAC_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -201)
	elseif not gAC_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -273)
	end

    gAC_Toggle()
end )

button:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -0, right = -0, top = -0, bottom = -0} 
					})
button:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
button:SetBackdropBorderColor(0,0,0,1)

local buttonOverlay = CreateFrame("Frame", nil, button)
      buttonOverlay:SetWidth(60)
      buttonOverlay:SetHeight(25)
      buttonOverlay:SetPoint("CENTER", button, "CENTER", 0,0)
	  buttonOverlay:SetBackdrop({
			bgFile = [[Interface\Buttons\WHITE8x8]],
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 1,
		})
	  buttonOverlay:SetBackdropColor(0,0,0,0)
	  buttonOverlay:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
	  button:EnableMouse()
	  button:SetScript('OnEnter', function() buttonOverlay:SetBackdropColor(1,1,1,0.15) end)
	  button:SetScript('OnLeave', function() buttonOverlay:SetBackdropColor(0,0,0,0) end)


-------------------------------------------------------
-- DAMAGE ADDON BUTTON 
-------------------------------------------------------
local button = CreateFrame("Button", "button_gDamage", UIParent)

button:SetPoint("CENTER", UIParent, "TOPRIGHT", -36, -196)
button:SetWidth(60)
button:SetHeight(25)
button:RegisterForClicks("LeftButtonDown")
button:SetScript("OnClick", function()
    
    if gDMG_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -201)
	elseif not gDMG_visible then
		gXpbarp:SetPoint("TOP", Minimap, "TOP", 0, -274)
	end

    gDMG_Toggle()
end)

button:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -0, right = -0, top = -0, bottom = -0} 
					})
button:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
button:SetBackdropBorderColor(0,0,0,1)

local buttonOverlay = CreateFrame("Frame", nil, button)
      buttonOverlay:SetWidth(60)
      buttonOverlay:SetHeight(25)
      buttonOverlay:SetPoint("CENTER", button, "CENTER", 0,0)
	  buttonOverlay:SetBackdrop({
			bgFile = [[Interface\Buttons\WHITE8x8]],
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 1,
		})
	  buttonOverlay:SetBackdropColor(0,0,0,0)
	  buttonOverlay:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
	  button:EnableMouse()
	  button:SetScript('OnEnter', function() buttonOverlay:SetBackdropColor(1,1,1,0.15) end)
	  button:SetScript('OnLeave', function() buttonOverlay:SetBackdropColor(0,0,0,0) end)