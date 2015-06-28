-- If you want to change something here keep in mind that the buttons are sorted vertical. So 1,2,3 are vertical first column and so on.
-------------------------------------------------------------------------------
---------- sets the variables for the first start of the UI
-------------------------------------------------------------------------------

if gHideerrors == nil then
	gHideerrors = false
end
if gSelljunk == nil then
	gSelljunk = false
end
if gAutorepair == nil then
	gAutorepair = 0
end
if gXpbar == nil then
	gXpbar = true
end
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
	if gDMG_visible == true then
		gDamage:Hide()
		gDMG_visible = false
		SkadaToggleWindowIfLoaded()

		gWorldmarkers:Show()
		gWM_visible = true
	elseif gAC_visible == true then
		gAutomatorConfig:Hide()
		gAC_visible = false

		gWorldmarkers:Show()
		gWM_visible = true
	elseif gWM_visible == true then
		gWorldmarkers:Hide()
		gWM_visible = false
	else
		gWorldmarkers:Show()
		gWM_visible = true
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
gAC_1:SetWidth(60) 
gAC_1:SetHeight(25) 
gAC_1:SetPoint("CENTER", gAutomatorConfig, "CENTER", -59, 24)
gAC_1:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gAC_1:SetBackdropColor(0,0,0,0)
gAC_1:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gAC_1:EnableMouse()



local gAC_1button = CreateFrame("Button", nil, gAC_1)
      gAC_1button:SetWidth(60)
      gAC_1button:SetHeight(25)
      gAC_1button:SetPoint("CENTER", gAC_1, "CENTER", 0,0)
	  gAC_1button:EnableMouse()
	  gAC_1button:SetScript("OnMouseDown", function(self, button)
	  		if gHideerrors == true then
	  			gHideerrors = false
	  		elseif gHideerrors == false then
	  			gHideerrors = true
	  		else 
	  			gHideerrors = false
	  		end

	  		if gHideerrors == true then
				gAC_1:SetBackdropColor(0,1,0,0.2)
				print("|cff00FF7F[gemp]|r Errors are hidden");
				gHideerrorsfunc();
			elseif gHideerrors == false then
				gAC_1:SetBackdropColor(1,0,0,0.2)
				print("|cff00FF7F[gemp]|r Errors are not hidden");
				UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
			end
	  end)

local buttonOverlay = CreateFrame("Frame", nil, gAC_1button)
      buttonOverlay:SetWidth(60)
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
gACt_1:SetText("Errors");
gACt_1:SetPoint("CENTER", gAC_1button, "CENTER", 1,-1);


local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if gHideerrors == true then
		gAC_1:SetBackdropColor(0,1,0,0.2);
		
		gHideerrorsfunc();
	elseif gHideerrors == false then
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
	  		if gAutorepair == 0 then 
	  			gAutorepair = 1 
	  		elseif gAutorepair == 1 then
	  			gAutorepair = 2
	  		elseif gAutorepair == 2 then
	  			gAutorepair = 0
	  		end
	  		

	  		if gAutorepair == 1 then
				gAC_2:SetBackdropColor(0,1,0,0.2)
				ChatFrame1:AddMessage("|cff00FF7F[gemp]|r Auto-Repair is on (Player)");
				gACt_2:SetText("Auto Repair Player");
			elseif gAutorepair == 2 then
				gAC_2:SetBackdropColor(0,1,0,0.2)
				ChatFrame1:AddMessage("|cff00FF7F[gemp]|r Auto-Repair is on (Guild first)");
				gACt_2:SetText("Auto Repair Guild");
			elseif gAutorepair == 0 then
				gAC_2:SetBackdropColor(1,0,0,0.2)
				ChatFrame1:AddMessage("|cff00FF7F[gemp]|r Auto-Repair is off");
				gACt_2:SetText("Auto Repair is off");
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
gACt_2:SetPoint("CENTER", gAC_2button, "CENTER", 0,-1);

if gAutorepair == 1 then
		gAC_2:SetBackdropColor(0,1,0,0.2);
		gACt_2:SetText("Auto Repair Player");
	elseif gAutorepair == 2 then
		gAC_2:SetBackdropColor(0,1,0,0.2);
		gACt_2:SetText("Auto Repair Guild");
	elseif gAutorepair == 0 then
		gAC_2:SetBackdropColor(1,0,0,0.2);
		gACt_2:SetText("Auto Repair is off");
end


local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if gAutorepair == 1 then
		gAC_2:SetBackdropColor(0,1,0,0.2);
		gACt_2:SetText("Auto Repair Player");
	elseif gAutorepair == 2 then
		gAC_2:SetBackdropColor(0,1,0,0.2);
		gACt_2:SetText("Auto Repair Guild");
	elseif gAutorepair == 0 then
		gAC_2:SetBackdropColor(1,0,0,0.2);
		gACt_2:SetText("Auto Repair is off");
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
	  		if gSelljunk == true then
	  			gSelljunk = false
	  		elseif gSelljunk == false then
	  			gSelljunk = true
	  		else 
	  			gSelljunk = false
	  		end

	  		if gSelljunk == true then
				gAC_3:SetBackdropColor(0,1,0,0.2)
				print("|cff00FF7F[gemp]|r Junk will be sold");
				gSelljunkfunc();
			elseif gSelljunk == false then
				gAC_3:SetBackdropColor(1,0,0,0.2)
				print("|cff00FF7F[gemp]|r Junk won't be sold");
			
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
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if gSelljunk == true then
		gAC_3:SetBackdropColor(0,1,0,0.2);
	elseif gSelljunk == false then
		gAC_3:SetBackdropColor(1,0,0,0.2);
	end
end
frame:SetScript("OnEvent", eventHandler);

-------------------------------------------------------------------------------
------ Config for the XP Bar
-------------------------------------------------------------------------------

local gAC_4 = CreateFrame("Frame",nil, gAutomatorConfig)
gAC_4:SetWidth(60) 
gAC_4:SetHeight(25) 
gAC_4:SetPoint("CENTER", gAutomatorConfig, "CENTER", 0, 24)
gAC_4:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
})
gAC_4:SetBackdropColor(0,0,0,0)
gAC_4:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
gAC_4:EnableMouse()



local gAC_4button = CreateFrame("Button", nil, gAC_4)
      gAC_4button:SetWidth(60)
      gAC_4button:SetHeight(25)
      gAC_4button:SetPoint("CENTER", gAC_4, "CENTER", 0,0)
	  gAC_4button:EnableMouse()
	  gAC_4button:SetScript("OnMouseDown", function(self, button)
	  		if gXpbar == true then
	  			gXpbar = false
	  		elseif gXpbar == false then
	  			gXpbar = true
	  		else 
	  			gXpbar = false
	  		end

	  		if gXpbar == true then
					gAC_4:SetBackdropColor(0,1,0,0.2)
					
			elseif gXpbar == false then
					gAC_4:SetBackdropColor(1,0,0,0.2)
			end


	  		if gempUI_playerlevel == MAX_PLAYER_LEVEL then
	  			if gXpbar == true then
					print("|cff00FF7F[gemp]|r Reputationbar is now shown");
					gempUI_rep:SetAlpha(1)
				elseif gXpbar == false then
					print("|cff00FF7F[gemp]|r Reputationbar is now hidden");
					gempUI_rep:SetAlpha(0)
				end
	  		else

		  		if gXpbar == true then
					print("|cff00FF7F[gemp]|r Experiencebar is now shown");
					gempUI_exp:SetAlpha(1)
				elseif gXpbar == false then
					print("|cff00FF7F[gemp]|r Experiencebar is now hidden");
					gempUI_exp:SetAlpha(0)
				end
			end
	  end)

local buttonOverlay = CreateFrame("Frame", nil, gAC_4button)
      buttonOverlay:SetWidth(60)
      buttonOverlay:SetHeight(25)
      buttonOverlay:SetPoint("CENTER", gAC_4button, "CENTER", 0,0)
	  buttonOverlay:SetBackdrop({
			bgFile = [[Interface\Buttons\WHITE8x8]],
			edgeFile = [[Interface\Buttons\WHITE8x8]],
			edgeSize = 1,
		})
	  buttonOverlay:SetBackdropColor(0,0,0,0)
	  buttonOverlay:SetBackdropBorderColor(0,1,0,0.2)

	  gAC_4button:SetScript('OnEnter', function() buttonOverlay:SetBackdropColor(1,1,1,0.15) end)
	  gAC_4button:SetScript('OnLeave', function() buttonOverlay:SetBackdropColor(0,0,0,0) end)

if gempUI_playerlevel == MAX_PLAYER_LEVEL then
	rep_or_xp_text = "REPBar"
else
	rep_or_xp_text = "EXPBar"
end

gACt_4 = gAC_4button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_4:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_4:SetText(rep_or_xp_text);
gACt_4:SetPoint("CENTER", gAC_4button, "CENTER",1,-1);


local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if gXpbar == true then
		gAC_4:SetBackdropColor(0,1,0,0.2);
		
		gHideerrorsfunc();
	elseif gXpbar == false then
		gAC_4:SetBackdropColor(1,0,0,0.2);
		
	end
end
frame:SetScript("OnEvent", eventHandler);

---------------------------------------------------------------------------------

