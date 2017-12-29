local F, G, V = unpack(select(2, ...))

local addonName, eventHandlers = ..., { }

local errorFrame = CreateFrame("Frame")
errorFrame:SetScript('OnEvent', function(self, event, messageType, message)
	if not UnitAffectingCombat("player") then
		UIErrorsFrame:AddMessage(message, 1, .1, .1)
	end		
end)

function hideerrorsfunc()
	if gempDB.hideerrors then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		errorFrame:RegisterEvent("UI_ERROR_MESSAGE")
	else 
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		errorFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	end
end

-- auto junk sell
function selljunk()

	if gempDB.selljunk then
		for bag = 0,4,1 do for slot = 1, GetContainerNumSlots(bag),

		1 do local name = GetContainerItemLink(bag,slot)

			if name and string.find(name,"ff9d9d9d") then
				UseContainerItem(bag,slot)
			end
		end
		end
	end
end

-- autorepair / autojunkseller
function autorepair()

	if CanMerchantRepair() then
		local cost = GetRepairAllCost()
		local guildName, guildRankName, guildRankIndex = GetGuildInfo('player');

		if gempDB.autorepair == 1 then
			RepairAllItems()
			if cost > 0 then
			end
		elseif gempDB.autorepair == 2 then
			RepairAllItems(1)
			if cost > 0 then
			end
		elseif gempDB.autorepair == 0 then

		end

	end

end

-- no Idea why this is needed, gempDB default in gempUI.lua should already default the vars but for some reason it doesn't
if gempDB.autorepair == nil then
		gempDB.autorepair = 0
end
if gempDB.selljunk == nil then
	gempDB.selljunk = false
end


-------------------------------------------------------------------------------
---------- Checks if Skada is active and parents it to the dmg frame of the minimap
-- don't rely on this in other modules
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
F.addBackdrop(gWorldmarkers)
gWorldmarkers:SetWidth(178);
gWorldmarkers:SetHeight(71);
gWorldmarkers:SetFrameStrata("background")
gWorldmarkers:Hide();


function gWM_Toggle()
	if gAC_visible == true then
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

gAutomatorConfig:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -6, -207);
F.addBackdrop(gAutomatorConfig)
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
	else
		gAutomatorConfig:Show();
		gAC_visible = true;


	end
end


-----------------------------------------------------------------------------

local gDamage = CreateFrame("Frame", "gDamage", UIParent);
gDamage:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -183, -6);
F.addBackdrop(gDamage)
gDamage:SetWidth(178);
gDamage:SetHeight(202);
gDamage:SetFrameStrata("LOW")
gDamage:Hide();


function gDMG_Toggle()
	if gDMG_visible then
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
F.addBackdrop(gAC_1)
gAC_1:EnableMouse()



local gAC_1button = CreateFrame("Button", nil, gAC_1)
      gAC_1button:SetWidth(60)
      gAC_1button:SetHeight(25)
      gAC_1button:SetPoint("CENTER", gAC_1, "CENTER", 0,0)
	  gAC_1button:EnableMouse()
	  gAC_1button:SetScript("OnMouseDown", function(self, button)
	  		if gempDB.hideerrors == true then
	  			gempDB.hideerrors = false
	  		elseif gempDB.hideerrors == false then
	  			gempDB.hideerrors = true
	  		else
	  			gempDB.hideerrors = false
	  		end

	  		if gempDB.hideerrors == true then
				gAC_1:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4])
				print("|cff00FF7F[gemp]|r Errors in combat are hidden");
				hideerrorsfunc();
			elseif gempDB.hideerrors == false then
				gAC_1:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4])
				print("|cff00FF7F[gemp]|r Errors in combat are not hidden");
				UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
			end
	  end)

F.createOverlay(gAC_1button, gAC_1)

gACt_1 = gAC_1button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_1:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_1:SetText("Errors");
gACt_1:SetPoint("CENTER", gAC_1button, "CENTER", 1,-1);


local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if gempDB.hideerrors == true then
		gAC_1:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4]);

		hideerrorsfunc();
	elseif gempDB.hideerrors == false then
		gAC_1:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4]);

	end
end
frame:SetScript("OnEvent", eventHandler);

---------------------------------------------------------------------------------

local gAC_2 = CreateFrame("Frame",nil, gAutomatorConfig)
gAC_2:SetWidth(178)
gAC_2:SetHeight(25)
gAC_2:SetPoint("CENTER", gAutomatorConfig, "CENTER", 0, 0)
F.addBackdrop(gAC_2)
gAC_2:EnableMouse()

local gAC_2button = CreateFrame("Button", nil, gAC_2)
      gAC_2button:SetWidth(178)
      gAC_2button:SetHeight(15)
      gAC_2button:SetPoint("CENTER", gAC_2, "CENTER", 0,0)
	  gAC_2button:EnableMouse()
	  gAC_2button:SetScript("OnMouseDown", function(self, button)

	  		if gempDB.autorepair == 0 then
	  			gempDB.autorepair = 1
	  		elseif gempDB.autorepair == 1 then
	  			gempDB.autorepair = 2
	  		elseif gempDB.autorepair == 2 then
	  			gempDB.autorepair = 0
	  		end


	  		if gempDB.autorepair == 1 then
				gAC_2:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4])
				ChatFrame1:AddMessage("|cff00FF7F[gemp]|r Auto-Repair is on (Player)");
				gACt_2:SetText("Auto Repair Player");
			elseif gempDB.autorepair == 2 then
				gAC_2:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4])
				ChatFrame1:AddMessage("|cff00FF7F[gemp]|r Auto-Repair is on (Guild first)");
				gACt_2:SetText("Auto Repair Guild");
			elseif gempDB.autorepair == 0 then
				gAC_2:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4])
				ChatFrame1:AddMessage("|cff00FF7F[gemp]|r Auto-Repair is off");
				gACt_2:SetText("Auto Repair is off");
			end

end)

F.createOverlay(gAC_2button, gAC_2)



gACt_2 = gAC_2button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_2:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_2:SetPoint("CENTER", gAC_2button, "CENTER", 0,-1);

if gempDB.autorepair == 1 then
		gAC_2:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4]);
		gACt_2:SetText("Auto Repair Player");
	elseif gempDB.autorepair == 2 then
		gAC_2:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4]);
		gACt_2:SetText("Auto Repair Guild");
	elseif gempDB.autorepair == 0 then
		gAC_2:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4]);
		gACt_2:SetText("Auto Repair is off");
end


local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if gempDB.autorepair == 1 then
		gAC_2:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4]);
		gACt_2:SetText("Auto Repair Player");
	elseif gempDB.autorepair == 2 then
		gAC_2:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4]);
		gACt_2:SetText("Auto Repair Guild");
	elseif gempDB.autorepair == 0 then
		gAC_2:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4]);
		gACt_2:SetText("Auto Repair is off");
	end
end
frame:SetScript("OnEvent", eventHandler);

------------------------------------------------------------------------------------


local gAC_3 = CreateFrame("Frame",nil, gAutomatorConfig)
gAC_3:SetWidth(178)
gAC_3:SetHeight(25)
gAC_3:SetPoint("CENTER", gAutomatorConfig, "CENTER", 0, -24)
F.addBackdrop(gAC_3)
gAC_3:EnableMouse()

local gAC_3button = CreateFrame("Button", nil, gAC_3)
      gAC_3button:SetWidth(178)
      gAC_3button:SetHeight(15)
      gAC_3button:SetPoint("CENTER", gAC_3, "CENTER", 0,0)
	  gAC_3button:EnableMouse()
	  gAC_3button:SetScript("OnMouseDown", function(self, button)
	  		if gempDB.selljunk == true then
	  			gempDB.selljunk = false
	  		elseif gempDB.selljunk == false then
	  			gempDB.selljunk = true
	  		else
	  			gempDB.selljunk = false
	  		end

	  		if gempDB.selljunk == true then
				gAC_3:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4])
				print("|cff00FF7F[gemp]|r Junk will be sold");
				selljunk();
			elseif gempDB.selljunk == false then
				gAC_3:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4])
				print("|cff00FF7F[gemp]|r Junk won't be sold");

			end
	  end)

F.createOverlay(gAC_3button, gAC_3)


gACt_3 = gAC_3button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_3:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_3:SetText("Sell Junk");
gACt_3:SetPoint("CENTER", gAC_3button, "CENTER", 0,-1);

local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)
	if gempDB.selljunk == true then
		gAC_3:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4]);
	elseif gempDB.selljunk == false then
		gAC_3:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4]);
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
F.addBackdrop(gAC_4)
gAC_4:EnableMouse()

local gAC_4button = CreateFrame("Button", nil, gAC_4)
      gAC_4button:SetWidth(60)
      gAC_4button:SetHeight(25)
      gAC_4button:SetPoint("CENTER", gAC_4, "CENTER", 0,0)
	  gAC_4button:EnableMouse()
	  gAC_4button:SetScript("OnMouseDown", function(self, button)
	  		if gempDB.xpbar == true then
	  			gempDB.xpbar = false
	  		elseif gempDB.xpbar == false then
	  			gempDB.xpbar = true
	  		else
	  			gempDB.xpbar = false
	  		end

	  		if gempDB.xpbar == true then
					gAC_4:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4])

			elseif gempDB.xpbar == false then
					gAC_4:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4])
			end


	  		if V.playerlevel == MAX_PLAYER_LEVEL then
	  			if gempDB.xpbar == true then
					print("|cff00FF7F[gemp]|r Reputationbar is now shown");
					gempXpbar:Show()
					gXpbarp:Show()
				elseif gempDB.xpbar == false then
					print("|cff00FF7F[gemp]|r Reputationbar is now hidden");
					gempXpbar:Hide()
					gXpbarp:Hide()
				end
	  		else
		  		if gempDB.xpbar == true then
					print("|cff00FF7F[gemp]|r Experiencebar is now shown");
					gempXpbar:Show()
					gXpbarp:Show()
				elseif gempDB.xpbar == false then
					print("|cff00FF7F[gemp]|r Experiencebar is now hidden");
					gempXpbar:Hide()
					gXpbarp:Hide()
				end
			end
	  end)

F.createOverlay(gAC_4button, gAC_4)


if UnitLevel("player") == MAX_PLAYER_LEVEL then
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
	if gempDB.xpbar == true then
		gAC_4:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4]);
		gXpbarp:Show()
		gempXpbar:Show()

	elseif gempDB.xpbar == false then
		gAC_4:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4]);
		gXpbarp:Hide()
		gempXpbar:Hide()
	end
end
frame:SetScript("OnEvent", eventHandler);

---------------------------------------------------------------------------------

-------------------------------------------------------------------------------
------ Config for the XP Bar Text
-------------------------------------------------------------------------------

local gAC_5 = CreateFrame("Frame",nil, gAutomatorConfig)
gAC_5:SetWidth(60)
gAC_5:SetHeight(25)
gAC_5:SetPoint("CENTER", gAutomatorConfig, "CENTER", 59, 24)
F.addBackdrop(gAC_5)
gAC_5:EnableMouse()



local gAC_5button = CreateFrame("Button", nil, gAC_5)
      gAC_5button:SetWidth(60)
      gAC_5button:SetHeight(25)
      gAC_5button:SetPoint("CENTER", gAC_5, "CENTER", 0,0)
	  gAC_5button:EnableMouse()
	  gAC_5button:SetScript("OnMouseDown", function(self, button)

	  	if gempDB.threatbar then
	  		gempDB.threatbar = false
	  	elseif not gempDB.threatbar then
	  		gempDB.threatbar = true
	  	else
	  		gempDB.threatbar = true
	  	end

		  if gempDB.threatbar == true then
			print("|cff00FF7F[gemp]|r Threatbar is now shown");
			gAC_5:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4])
			gThreat:SetAlpha(1)
		elseif gempDB.threatbar == false then
			print("|cff00FF7F[gemp]|r Threatbar is now hidden");
			gAC_5:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4])
			gThreat:SetAlpha(0)
		end
	end)

F.createOverlay(gAC_5button, gAC_5)



gACt_5 = gAC_5button:CreateFontString(nil, "OVERLAY", gAutomatorConfig);
gACt_5:SetFont("Interface\\AddOns\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE");
gACt_5:SetText("THREAT");
gACt_5:SetPoint("CENTER", gAC_5button, "CENTER",1,-1);


local frame = CreateFrame("FRAME", "check");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)

		  if gempDB.threatbar == true then
			gAC_5:SetBackdropColor(0/255, 84/255, 28/255, G.colors.base[4])
			gThreat:SetAlpha(1)
		elseif gempDB.threatbar == false then
			gAC_5:SetBackdropColor(150/255, 10/255, 10/255, G.colors.base[4])
			gThreat:SetAlpha(0)
		end

end
frame:SetScript("OnEvent", eventHandler);
local frame = CreateFrame("FRAME", "MerchantEventCheck");
frame:RegisterEvent("MERCHANT_SHOW");
local function eventHandler(self, event, ...)

	selljunk()
	autorepair()

end
frame:SetScript("OnEvent", eventHandler);


