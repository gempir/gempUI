local F, G, V = unpack(select(2, ...))

local addonName, eventHandlers = ..., { }


-- thanks to Resike for these two
-- these get Info about specific frames

function GetFrameInfoFromCursor()
    local fn = GetMouseFocus():GetName()
    local f = _G[fn]
    print("|cFF50C0FF".."<---------------------------------------------->".."|r")
    print("|cFF50C0FF".."Frame:".."|r", fn)
    local p = f:GetParent()
    print("|cFF50C0FF".."Parent:".."|r", p:GetName())
    for i = 1, f:GetNumPoints() do
        local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint(i)
        if point and relativeTo and relativePoint and xOfs and yOfs then
            print(i..".", "|cFF50C0FF".."p:".."|r", point, "|cFF50C0FF".."rfn:".."|r", relativeTo:GetName(), "|cFF50C0FF".."rp:".."|r", relativePoint, "|cFF50C0FF".."x:".."|r", xOfs, "|cFF50C0FF".."y:".."|r", yOfs)
        end
    end
    print("|cFF50C0FF".."Scale:".."|r", f:GetScale())
    print("|cFF50C0FF".."Effective Scale:".."|r", f:GetEffectiveScale())
    print("|cFF50C0FF".."Protected:".."|r", f:IsProtected())
    print("|cFF50C0FF".."Strata:".."|r", f:GetFrameStrata())
    print("|cFF50C0FF".."Level:".."|r", f:GetFrameLevel())
    print("|cFF50C0FF".."Width:".."|r", f:GetWidth())
    print("|cFF50C0FF".."Height:".."|r", f:GetHeight())
end

function GetFrameInfo(f)
    local fn = f:GetName()
    print("|cFF50C0FF".."<---------------------------------------------->".."|r")
    print("|cFF50C0FF".."Frame:".."|r", fn)
    local p = f:GetParent()
    print("|cFF50C0FF".."Parent:".."|r", p:GetName())
    for i = 1, f:GetNumPoints() do
        local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint(i)
        if point and relativeTo and relativePoint and xOfs and yOfs then
            print(i..".", "|cFF50C0FF".."p:".."|r", point, "|cFF50C0FF".."rfn:".."|r", relativeTo:GetName(), "|cFF50C0FF".."rp:".."|r", relativePoint, "|cFF50C0FF".."x:".."|r", xOfs, "|cFF50C0FF".."y:".."|r", yOfs)
        end
    end
    print("|cFF50C0FF".."Scale:".."|r", f:GetScale())
    print("|cFF50C0FF".."Effective Scale:".."|r", f:GetEffectiveScale())
    print("|cFF50C0FF".."Protected:".."|r", f:IsProtected())
    print("|cFF50C0FF".."Strata:".."|r", f:GetFrameStrata())
    print("|cFF50C0FF".."Level:".."|r", f:GetFrameLevel())
    print("|cFF50C0FF".."Width:".."|r", f:GetWidth())
    print("|cFF50C0FF".."Height:".."|r", f:GetHeight())
end

--- Here start the gempUI functions
-- hides errors 
function hideerrorsfunc()
	if gempDB.hideerrors then
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
function F.selljunk()	

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
function F.autorepair() 
	
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


function F.rebackdrop(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
	})
	frame:SetBackdropColor(G.color.r,G.color.g,G.color.b,G.color.a)
	frame:SetBackdropBorderColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)
end

function F.rebackdroplight(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
	})
	frame:SetBackdropColor(G.color.r+0.05,G.color.g+0.05,G.color.b+0.05,G.color.a)
	frame:SetBackdropBorderColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)
end

function F.retexture(frame)
	frame:SetTexture(nil)
	frame:SetTexture(G.color.r,G.color.g,G.color.b,G.color.a)
end

function F.ReskinPortraitIcon(frame, isButtonFrame)
	local name = frame:GetName()

	_G[name.."Bg"]:Hide()
	_G[name.."TitleBg"]:Hide()
	_G[name.."Portrait"]:Hide()
	_G[name.."PortraitFrame"]:Hide()
	_G[name.."TopRightCorner"]:Hide()
	_G[name.."TopLeftCorner"]:Hide()
	_G[name.."TopBorder"]:Hide()
	_G[name.."TopTileStreaks"]:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	_G[name.."LeftBorder"]:Hide()
	_G[name.."RightBorder"]:Hide()

	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")

		frame.Inset.Bg:Hide()
		frame.Inset:DisableDrawLayer("BORDER")
	end
end



