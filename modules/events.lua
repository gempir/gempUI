local F, G, V = unpack(select(2, ...))

-- ERRORS

local addonName, eventHandlers = ..., { }

local errorFrame = CreateFrame("Frame")
errorFrame:SetScript('OnEvent', function(self, event, messageType, message)
	if G.ace.db.profile.hideErrors == "never" then
		UIErrorsFrame:AddMessage(message, 1, .1, .1)
	elseif G.ace.db.profile.hideErrors == "combat" and not UnitAffectingCombat("player") then
		UIErrorsFrame:AddMessage(message, 1, .1, .1)
	elseif G.ace.db.profile.hideErrors == "always" then
	end		
end)

UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
errorFrame:RegisterEvent("UI_ERROR_MESSAGE")

-- MERCHANTS


local frame = CreateFrame("FRAME", "MerchantEventCheck");
frame:RegisterEvent("MERCHANT_SHOW");
frame:SetScript("OnEvent", function() 

	if G.ace.db.profile.sellJunk then 
		for bag = 0,4,1 do for slot = 1, GetContainerNumSlots(bag),
			1 do local name = GetContainerItemLink(bag,slot)

				if name and string.find(name,"ff9d9d9d") then
					UseContainerItem(bag,slot)
				end
			end
		end
	end

	if G.ace.db.profile.autoRepair then 
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


