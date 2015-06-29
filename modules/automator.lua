
local addonName, eventHandlers = ..., { }


-------------------------------------------------------------------------------
---------- Automator functions
-------------------------------------------------------------------------------
-- Hide Error text
function gHideerrorsfunc()
	if gHideerrors then
		local allowedErrors = { }

			eventHandlers['UI_ERROR_MESSAGE'] = function(message)
				if allowedErrors[message] then
							UIErrorsFrame:AddMessage(message, 1, .1, .1)
				end
		end

		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	end
end


-- auto junk sell

function gSelljunkfunc()	

	if gSelljunk then
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
function gAutorepairfunc() 
	
		if CanMerchantRepair() then
				local cost = GetRepairAllCost()
				local guildName, guildRankName, guildRankIndex = GetGuildInfo('player');

				if gAutorepair == 1 then
					RepairAllItems()
					if cost > 0 then
					end
				elseif gAutorepair == 2 then
					RepairAllItems(1)
					if cost > 0 then
					end
				elseif gAutorepair == 0 then

				end

		end
	
end

-- maybe later implementation, this destroys all grey items in the bags

function destroyjunkfunc()
		
	for x = 0,4 do for y = 1, GetContainerNumSlots(x) 
		do local n = GetContainerItemLink(x,y) 

			if n and string.find(n,"ff9d9d9d") then 
					DEFAULT_CHAT_FRAME:AddMessage("Trashing "..n) 
					PickupContainerItem(x,y) 
					DeleteCursorItem() 
			end 
		end
	end

end


-------------------------------------------------------------------------------
---------- Checks for merchant windows opening to sell and repair
-------------------------------------------------------------------------------

local frame = CreateFrame("FRAME", "MerchantEventCheck");
frame:RegisterEvent("MERCHANT_SHOW");
local function eventHandler(self, event, ...)

	gSelljunkfunc();
	gAutorepairfunc();

end
frame:SetScript("OnEvent", eventHandler);

