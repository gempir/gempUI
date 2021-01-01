local F, G, V = unpack(select(2, ...))

function F.getPixel(pixels)
	return PixelUtil.GetNearestPixelSize(pixels, UIParent:GetEffectiveScale(), 1)
end

--[[
 create a frame that adds a 1px border
 * object parent - parent of new frame
 * object anchor - frame that the new frame will be attached to
 * bool extend - 1px outside of the anchor or outside
]] --
function F.createBorder(self, anchor, extend)
	spacing = 0
	if extend then
		spacing = F.getPixel(1)
	end

	if not anchor then
		anchor = parent
	end

	if self:GetObjectType() == "StatusBar" then
		self = CreateFrame("Frame", nil, self)
		self:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
		self:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 0, 0)
	end

	if not self.borders then
        self.borders = {}
		for i=1, 4 do
			self.borders[i] = self:CreateLine(nil, "LOW", nil, 0)	
            local l = self.borders[i]
            l:SetThickness(F.getPixel(1))
			l:SetColorTexture(unpack(G.colors.border))
            if i==1 then
                l:SetStartPoint("TOPLEFT", -spacing, spacing)
                l:SetEndPoint("TOPRIGHT", spacing, spacing)
            elseif i==2 then
                l:SetStartPoint("TOPRIGHT", spacing, spacing)
                l:SetEndPoint("BOTTOMRIGHT", spacing, -spacing)
            elseif i==3 then
                l:SetStartPoint("BOTTOMRIGHT", spacing, -spacing)
                l:SetEndPoint("BOTTOMLEFT", -spacing, -spacing)
            else
                l:SetStartPoint("BOTTOMLEFT", -spacing, -spacing)
                l:SetEndPoint("TOPLEFT", -spacing, spacing)
            end
        end
    end

	return self
end

function F.createFontString(parent) 
	local fs = parent:CreateFontString(nil, "OVERLAY");
	fs:SetFont(G.fonts.square, 14, "");
	fs:SetShadowOffset(1, -1);
	fs:SetPoint("CENTER", parent, "CENTER", 0, 0);
	return fs
end

function F.sendToChat(cmd) 
	local editbox=ChatEdit_ChooseBoxForSend(DEFAULT_CHAT_FRAME);
	ChatEdit_ActivateChat(editbox);
	editbox:SetText(cmd);
	ChatEdit_OnEnterPressed(editbox);
end

function F.createOverlay(element, anchor)
	if not anchor then
		anchor = element
	end

	local buttonOverlay = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
	buttonOverlay:SetPoint("TOPLEFT", anchor, "TOPLEFT", 1, -1)
	buttonOverlay:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", -1, 1)
	buttonOverlay:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]]
	})
	buttonOverlay:SetBackdropColor(1,1,1,0.15)
	buttonOverlay:SetFrameLevel(element:GetFrameLevel() + 1)
	buttonOverlay:Hide()

	element:SetScript('OnEnter', function() buttonOverlay:Show() end)
	element:SetScript('OnLeave', function() buttonOverlay:Hide() end)
end

function F.addBackdrop(frame)
	F.addBackdropNoBorder(frame)
	F.createBorder(frame)
end

function F.addBackdropNoBorder(frame)
	Mixin(frame, BackdropTemplateMixin)
	frame:SetBackdrop({
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=]
	})
	frame:SetBackdropColor(unpack(G.colors.base))
end

function F.print(message)
	print("|cff00FF7Fg|rUI | ".. message)
end


-- Events
local events = {}

local host = CreateFrame('Frame')
host:SetScript('OnEvent', function(_, event, ...)
	for func in pairs(events[event]) do
		if event == 'COMBAT_LOG_EVENT_UNFILTERED' then
			func(event, CombatLogGetCurrentEventInfo())
		else
			func(event, ...)
		end
	end
end)

function F:RegisterEvent(event, func, unit1, unit2)
	if not events[event] then
		events[event] = {}
		if unit1 then
			host:RegisterUnitEvent(event, unit1, unit2)
		else
			host:RegisterEvent(event)
		end
	end

	events[event][func] = true
end

function F:UnregisterEvent(event, func)
	local funcs = events[event]
	if funcs and funcs[func] then
		funcs[func] = nil

		if not next(funcs) then
			events[event] = nil
			host:UnregisterEvent(event)
		end
	end
end
