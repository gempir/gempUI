local F, G, V = unpack(select(2, ...))

local addonName, eventHandlers = ..., { }

local errorFrame = CreateFrame("Frame")
errorFrame:SetScript('OnEvent', function(self, event, messageType, message)
	if not UnitAffectingCombat("player") then
		UIErrorsFrame:AddMessage(message, 1, .1, .1)
	end		
end)

function setErrorVisibility()
	if gempDB.hideErrors then
		UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
		errorFrame:RegisterEvent("UI_ERROR_MESSAGE")
	else 
		UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE")
		errorFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	end
end

F.onOptionsLoaded(function() 
	setErrorVisibility()
end)

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
			gDamage:Show()
			gDMG_visible = true
		elseif gWorldmarkers:IsShown() then
			Skada:ToggleWindow()
		end
	  elseif not SkadaBarWindowSkada:IsShown() then
	  	if gDMG_visible == true then
	  		Skada:ToggleWindow()
	  	end
	 end
	end
	frame:SetScript("OnEvent", eventHandler)
end

-------------------------------------------------------------------------------
---------- Checks if Skada is loaded and disables anything Skada related if not
-------------------------------------------------------------------------------
local function SkadaToggleWindowIfLoaded()
	if (IsAddOnLoaded("Skada")) then
		Skada:ToggleWindow()
	end
end
-------------------------------------------------------------------------------
---------- Checks if other frames were open before and reopens them if so
-------------------------------------------------------------------------------
local frame = CreateFrame("FRAME", "LoadCheck");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
local function eventHandler(self, event, ...)

	if gWM_visible == true then
		gWorldmarkers:Show()
	end

end
frame:SetScript("OnEvent", eventHandler);
-------------------------------------------------------------------------------
---------- Creates Config Frame 
-------------------------------------------------------------------------------

gWorldmarkers = CreateFrame("Frame", "gWorldmarkers", UIParent);
gWorldmarkers:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -6, -207);
F.addBackdrop(gWorldmarkers)
gWorldmarkers:SetWidth(178);
gWorldmarkers:SetHeight(25);
gWorldmarkers:SetFrameStrata("background")
gWorldmarkers:Hide();


function gWM_Toggle()
	if gDMG_visible == true then
		gDamage:Hide()
		gDMG_visible = false
		SkadaToggleWindowIfLoaded()
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

local gDamage = CreateFrame("Frame", "gDamage", UIParent);
gDamage:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -6, -207);
F.addBackdrop(gDamage)
gDamage:SetWidth(178);
gDamage:SetHeight(146);
gDamage:SetFrameStrata("LOW")
gDamage:Hide();


function gDMG_Toggle()
	if gWM_visible then
		gWorldmarkers:Hide()
		gWM_visible = false
		gDamage:Show()
		gDMG_visible = true
		SkadaToggleWindowIfLoaded()
	elseif gDMG_visible then
		gDamage:Hide()
		gDMG_visible = false
		SkadaToggleWindowIfLoaded()
	else
		gDamage:Show()
		gDMG_visible = true
		SkadaToggleWindowIfLoaded()
	end
end

local frame = CreateFrame("FRAME", "MerchantEventCheck");
frame:RegisterEvent("MERCHANT_SHOW");
frame:SetScript("OnEvent", function() 

	if G.ace:GetSellJunk() then 
		for bag = 0,4,1 do for slot = 1, GetContainerNumSlots(bag),
			1 do local name = GetContainerItemLink(bag,slot)

				if name and string.find(name,"ff9d9d9d") then
					UseContainerItem(bag,slot)
				end
			end
		end
	end

	if G.ace:GetAutoRepair() then 
		if (CanMerchantRepair()) then	
			repairAllCost, canRepair = GetRepairAllCost();
			if (canRepair and repairAllCost > 0) then
				guildRepairedItems = false
				if (IsInGuild() and CanGuildBankRepair()) then
					local amount = GetGuildBankWithdrawMoney()
					local guildBankMoney = GetGuildBankMoney()
					amount = amount == -1 and guildBankMoney or min(amount, guildBankMoney)

					if (amount >= repairAllCost) then
						RepairAllItems(true);
						guildRepairedItems = true
						DEFAULT_CHAT_FRAME:AddMessage("Equipement has been repaired by your Guild", 255, 255, 255)
					end
				end				
				if (repairAllCost <= GetMoney() and not guildRepairedItems) then
					RepairAllItems(false);
					DEFAULT_CHAT_FRAME:AddMessage("Equipement has been repaired for "..GetCoinTextureString(repairAllCost), 255, 255, 255)
				end
			end
		end
	end
end)


