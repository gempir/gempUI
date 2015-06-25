
-------------------------------------------------------------------------------
---------- Checks if Skada is active and parents it to the dmg frame of the minimap
-------------------------------------------------------------------------------
if (IsAddOnLoaded("Skada")) then

	local frame = CreateFrame("FRAME", "LoadCheck");
	frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	local function eventHandler(self, event, ...)
	 if SkadaBarWindowSkada:IsShown() then
		if not gDamage:IsShown() then
			gDamage:Show();
			gDMG_visible = true;
		elseif gAutomatorConfig:IsShown() then 
			Skada:ToggleWindow();
		elseif gWorldmarkers:IsShown() then 
			Skada:ToggleWindow();
		end
	  elseif not SkadaBarWindowSkada:IsShown() then
	  	if gDMG_visible == true then
	  		Skada:ToggleWindow();
	  	end
	 end
	end
	frame:SetScript("OnEvent", eventHandler);
end

-------------------------------------------------------------------------------
---------- Checks if Skada is loaded and disables anything Skada related if not
-------------------------------------------------------------------------------
local function SkadaToggleWindowIfLoaded()
	if (IsAddOnLoaded("Skada")) then
		Skada:ToggleWindow();
	end
end
-------------------------------------------------------------------------------
---------- Checks if other frames were open before and reopens them if so
-------------------------------------------------------------------------------
local frame = CreateFrame("FRAME", "LoadCheck");
	frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	local function eventHandler(self, event, ...)

		if gAC_visible == true then
			gAutomatorConfig:Show()
		elseif gWM_visible == true then
			gWorldmarkers:Show()
		end
	
	end
	frame:SetScript("OnEvent", eventHandler);
-------------------------------------------------------------------------------
---------- Creates Config Frame 
-------------------------------------------------------------------------------


-----------------------------------------------------------------------------

gWorldmarkers = CreateFrame("Frame", "gWorldmarkers", UIParent);
gWorldmarkers:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -6, -207);
gWorldmarkers:SetBackdrop({
        bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
        insets = {left = -0, right = -0, top = -0, bottom = -0} 
        })
gWorldmarkers:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
gWorldmarkers:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gWorldmarkers:SetWidth(178);
gWorldmarkers:SetHeight(71);
gWorldmarkers:SetFrameStrata("background")
gWorldmarkers:Hide();


function gWM_Toggle()
	if(gWM_visible == true) then
		gWorldmarkers:Hide();
		gWM_visible = false;
	elseif(gAC_visible ==true) then
		gAutomatorConfig:Hide();
		gAC_visible = false;

		gWorldmarkers:Show();
		gWM_visible = true;
	elseif(wDMG_visible == true) then
		gDamage:Hide();
		gDMG_visible = false;
		SkadaToggleWindowIfLoaded();

		gWorldmarkers:Show();
		gWM_visible = true;
	else
		gWorldmarkers:Show();
		gWM_visible = true;
	end
end

-----------------------------------------------------------------------------


local gAutomatorConfig = CreateFrame("Frame", "gAutomatorConfig", UIParent);


gAutomatorConfig:SetBackdrop({
        bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
        insets = {left = -0, right = -0, top = -0, bottom = -0} 
        })
gAutomatorConfig:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -6, -207);
gAutomatorConfig:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
gAutomatorConfig:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gAutomatorConfig:SetWidth(178);
gAutomatorConfig:SetHeight(73);
gAutomatorConfig:SetFrameStrata("background")
gAutomatorConfig:Hide();



function gAC_Toggle()
	if(gAC_visible == true) then
		gAutomatorConfig:Hide();
		gAC_visible = false;

	elseif(gWM_visible == true) then
		gWorldmarkers:Hide();
		gWM_visible = false;

		gAutomatorConfig:Show();
		gAC_visible = true;

	elseif(gDMG_visible == true) then
		gDamage:Hide();
		gDMG_visible = false;
		SkadaToggleWindowIfLoaded();

		gAutomatorConfig:Show();
		gAC_visible = true;

	else
		gAutomatorConfig:Show();
		gAC_visible = true;


	end
end


-----------------------------------------------------------------------------

local gDamage = CreateFrame("Frame", "gDamage", UIParent);
gDamage:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -6, -207);
gDamage:SetBackdrop({
        bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
        insets = {left = -0, right = -0, top = -0, bottom = -0} 
        })
gDamage:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
gDamage:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gDamage:SetWidth(178);
gDamage:SetHeight(74);
gDamage:SetFrameStrata("background")
gDamage:Hide();


function gDMG_Toggle()
	if(gAC_visible == true) then
		gAutomatorConfig:Hide();
		gAC_visible = false;

		gDamage:Show();
		gDMG_visible = true;
		SkadaToggleWindowIfLoaded();
	elseif(gWM_visible == true) then
		gWorldmarkers:Hide();
		gWM_visible = false;

		gDamage:Show();
		gDMG_visible = true;
		SkadaToggleWindowIfLoaded();
	elseif(gDMG_visible == true) then
		gDamage:Hide();
		gDMG_visible = false;
		SkadaToggleWindowIfLoaded();
	else
		gDamage:Show();
		gDMG_visible = true;
		SkadaToggleWindowIfLoaded();
	end
end




-------------------------------------------------------------------------------
---------- Option menu inside the config frame
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
------ Config for Errors
-------------------------------------------------------------------------------

local gAC_1 = CreateFrame("Frame",nil, gAutomatorConfig)
gAC_1:SetWidth(178) 
gAC_1:SetHeight(25) 
gAC_1:SetPoint("CENTER", gAutomatorConfig, "CENTER", 0, 24)
gAC_1:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gAC_1:SetBackdropColor(0,0,0,0)
gAC_1:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gAC_1:EnableMouse()



local gAC_1button = CreateFrame("Button", nil, gAC_1)
      gAC_1button:SetWidth(178)
      gAC_1button:SetHeight(25)
      gAC_1button:SetPoint("CENTER", gAC_1, "CENTER", 0,0)
	  gAC_1button:EnableMouse()
	  gAC_1button:SetScript("OnMouseDown", function(self, button)
	  		if hideerrors == true then
	  			hideerrors = false
	  		elseif hideerrors == false then
	  			hideerrors = true
	  		else 
	  			hideerrors = false
	  		end

	  		if hideerrors == true then
				gAC_1:SetBackdropColor(0,1,0,0.2)
				gAC_1t = "Error are hidden"
				print("Errors are hidden");
				hideerrorsfunc();
			elseif hideerrors == false then
				gAC_1:SetBackdropColor(1,0,0,0.2)
				gAC_1t = "Error are not hidden"
				print("Errors are not hidden");
				UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
			end
	  end)

local buttonOverlay = CreateFrame("Frame", nil, gAC_1button)
      buttonOverlay:SetWidth(178)
      buttonOverlay:SetHeight(25)
      buttonOverlay:SetPoint("CENTER", gAC_1button, "CENTER", 0,0)
	  buttonOverlay:SetBackdrop({
			bgFile = [[Interface\Buttons\WHITE8x8]],
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 1,
		})
	  buttonOverlay:SetBackdropColor(0,0,0,0)
	  buttonOverlay:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)

	  gAC_1button:SetScript('OnEnter', function() buttonOverlay:SetBackdropColor(1,1,1,0.15) end)
	  gAC_1button:SetScript('OnLeave', function() buttonOverlay:SetBackdropColor(0,0,0,0) end)

gACt_1 = gAC_1button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_1:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_1:SetText("Disable Errors");
gACt_1:SetPoint("CENTER", gAC_1button, "CENTER", 1,-1);


local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if hideerrors == true then
		gAC_1:SetBackdropColor(0,1,0,0.2);
		
		hideerrorsfunc();
	elseif hideerrors == false then
		gAC_1:SetBackdropColor(1,0,0,0.2);
		
	end
end
frame:SetScript("OnEvent", eventHandler);

---------------------------------------------------------------------------------

local gAC_2 = CreateFrame("Frame",nil, gAutomatorConfig)
gAC_2:SetWidth(178) 
gAC_2:SetHeight(25) 
gAC_2:SetPoint("CENTER", gAutomatorConfig, "CENTER", 0, 0)
gAC_2:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gAC_2:SetBackdropColor(0,0,0,0)
gAC_2:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gAC_2:EnableMouse()

local gAC_2button = CreateFrame("Button", nil, gAC_2)
      gAC_2button:SetWidth(178)
      gAC_2button:SetHeight(15)
      gAC_2button:SetPoint("CENTER", gAC_2, "CENTER", 0,0)
	  gAC_2button:EnableMouse()
	  gAC_2button:SetScript("OnMouseDown", function(self, button)
	  		if autorepair == true then
	  			autorepair = false
	  		elseif autorepair == false then
	  			autorepair = true
	  		else 
	  			autorepair = false
	  		end

	  		if autorepair == true then
				gAC_2:SetBackdropColor(0,1,0,0.2)
				print("Auto-Repair is on (Guild first)");
				autorepairfunc();
			elseif autorepair == false then
				gAC_2:SetBackdropColor(1,0,0,0.2)
				print("Auto-Repair is off");
			
			end
			
	  end)

local buttonOverlay = CreateFrame("Frame", nil, gAC_2button)
      buttonOverlay:SetWidth(178)
      buttonOverlay:SetHeight(25)
      buttonOverlay:SetPoint("CENTER", gAC_2button, "CENTER", 0,0)
	  buttonOverlay:SetBackdrop({
			bgFile = [[Interface\Buttons\WHITE8x8]],
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 1,
		})
	  buttonOverlay:SetBackdropColor(0,0,0,0)
	  buttonOverlay:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)

	  gAC_2button:SetScript('OnEnter', function() buttonOverlay:SetBackdropColor(1,1,1,0.15) end)
	  gAC_2button:SetScript('OnLeave', function() buttonOverlay:SetBackdropColor(0,0,0,0) end)



gACt_2 = gAC_2button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_2:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_2:SetText("Auto Repair");
gACt_2:SetPoint("CENTER", gAC_2button, "CENTER", 0,-1);

local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if autorepair == true then
		gAC_2:SetBackdropColor(0,1,0,0.2);
		
		autorepairfunc();
	elseif autorepair == false then
		gAC_2:SetBackdropColor(1,0,0,0.2);
		
	end
end
frame:SetScript("OnEvent", eventHandler);

------------------------------------------------------------------------------------


local gAC_3 = CreateFrame("Frame",nil, gAutomatorConfig)
gAC_3:SetWidth(178) 
gAC_3:SetHeight(25) 
gAC_3:SetPoint("CENTER", gAutomatorConfig, "CENTER", 0, -24)
gAC_3:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gAC_3:SetBackdropColor(0,0,0,0)
gAC_3:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gAC_3:EnableMouse()

local gAC_3button = CreateFrame("Button", nil, gAC_3)
      gAC_3button:SetWidth(178)
      gAC_3button:SetHeight(15)
      gAC_3button:SetPoint("CENTER", gAC_3, "CENTER", 0,0)
	  gAC_3button:EnableMouse()
	  gAC_3button:SetScript("OnMouseDown", function(self, button)
	  		if selljunk == true then
	  			selljunk = false
	  		elseif selljunk == false then
	  			selljunk = true
	  		else 
	  			selljunk = false
	  		end

	  		if selljunk == true then
				gAC_3:SetBackdropColor(0,1,0,0.2)
				print("Junk will be sold");
				selljunkfunc();
			elseif selljunk == false then
				gAC_3:SetBackdropColor(1,0,0,0.2)
				print("Junk won't be sold");
			
			end
	  end)

local buttonOverlay = CreateFrame("Frame", nil, gAC_3button)
      buttonOverlay:SetWidth(178)
      buttonOverlay:SetHeight(25)
      buttonOverlay:SetPoint("CENTER", gAC_3button, "CENTER", 0,0)
	  buttonOverlay:SetBackdrop({
			bgFile = [[Interface\Buttons\WHITE8x8]],
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 1,
		})
	  buttonOverlay:SetBackdropColor(0,0,0,0)
	  buttonOverlay:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)

	  gAC_3button:SetScript('OnEnter', function() buttonOverlay:SetBackdropColor(1,1,1,0.15) end)
	  gAC_3button:SetScript('OnLeave', function() buttonOverlay:SetBackdropColor(0,0,0,0) end)



gACt_3 = gAC_3button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_3:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_3:SetText("Sell Junk");
gACt_3:SetPoint("CENTER", gAC_3button, "CENTER", 0,-1);

local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("MERCHANT_SHOW");
local function eventHandler(self, event, ...)
	if selljunk == true then
		gAC_3:SetBackdropColor(0,1,0,0.2);
		
		selljunkfunc();
	elseif selljunk == false then
		gAC_3:SetBackdropColor(1,0,0,0.2);
		
	end
end
frame:SetScript("OnEvent", eventHandler);