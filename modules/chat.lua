
-- Channel Names
local channelNamePattern = {
	["%[Guild%]"] = "[G]",
	["%[Party%]"] = "[P]",
	["%[Raid%]"] = "[R]",
	["%[Party Leader%]"] = "[PL]",
	["%[Dungeon Guide%]"] = "[DG]",
	["%[Instance%]"] = "[I]",
	["%[Instance Leader%]"] = "|cffff3399[|rIL|cffff3399]|r",
	["%[Raid Leader%]"] = "|cffff3399[|rRL|cffff3399]|r",
	["%[Raid Warning%]"] = "|cffff0000[|rRW|cffff0000]|r",
	["%[Officer%]"] = "[O]",
	["%[Battleground%]"] = "|cffff3399[|rBG|cffff3399]|r",
	["%[Battleground Leader%]"] = "|cffff0000[|rBGL|cffff0000]|r",
	["%[%d+%.%s(%w*)%]"] = "|cff990066[|r%1|cff990066]|r",
}

-- Mouse Scroll
local scrollLines = 1
local _G = _G
local format, gsub, strlen, strsub = string.format, string.gsub, string.len, string.sub
local pairs, type, date = pairs, type, date

-- Timestamps + Channel Names + UrlCopy (AddMessage hooks)
do
	local orig = {}
	local function AddMessageHook(frame, text, ...)
		if type(text) == "string" then
			-- Channel Names
			for k, v in pairs(channelNamePattern) do
				text = gsub(text, k, v)
			end
		end
		return orig[frame](frame, text, ...)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local c = _G["ChatFrame"..i]
		local tab = _G["ChatFrame"..i.."Tab"]
		tab:Hide()
		tab:SetScript("OnShow", function(self) self:Hide() end)
		orig[c] = c.AddMessage
		c.AddMessage = AddMessageHook
	end
	
	local currentLink, origItemRefSetHyperlink
	local function setItemRefHyperlink(tooltip, link, ...)
		if strsub(link, 1, 3) == "url" then
			currentLink = strsub(link, 5)
			StaticPopup_Show("SCMUrlCopyDialog")
			tooltip:Hide()
			return
		end
		return origItemRefSetHyperlink(tooltip, link, ...)
	end
	origItemRefSetHyperlink = ItemRefTooltip.SetHyperlink
	ItemRefTooltip.SetHyperlink = setItemRefHyperlink
	
	StaticPopupDialogs["SCMUrlCopyDialog"] = {
		text = "URL",
		button2 = TEXT(CLOSE),
		hasEditBox = 1,
		hasWideEditBox = 1,
		showAlert = 1,
		OnShow = function(this)
			local editBox = _G[this:GetName().."EditBox"]
			if editBox then
				editBox:SetText(currentLink)
				editBox:SetFocus()
				editBox:HighlightText(0)
			end
			local button = _G[this:GetName().."Button2"]
			if button then
				button:ClearAllPoints()
				button:SetWidth(200)
				button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
			end
			local icon = _G[this:GetName().."AlertIcon"]
			if icon then
				icon:Hide()
			end
		end,
		EditBoxOnEscapePressed = function(this) this:GetParent():Hide() end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
	}
end

-- Buttons
local FixChatButtons
do
	ChatFrameMenuButton.Show = ChatFrameMenuButton.Hide --Hide the chat shortcut button for emotes/languages/etc
	ChatFrameMenuButton:Hide() --Hide the chat shortcut button for emotes/languages/etc
	if FriendsMicroButton then
		FriendsMicroButton.Show = FriendsMicroButton.Hide --Hide the "Friends Online" count button
		FriendsMicroButton:Hide() --Hide the "Friends Online" count button
	end
	if QuickJoinToastButton then
		QuickJoinToastButton.Show = QuickJoinToastButton.Hide
		QuickJoinToastButton:Hide()
	end

	function FixChatButtons(i)
		local f = _G[format("%s%d%s", "ChatFrame", i, "ButtonFrame")]
		f.Show = f.Hide --Hide the up/down arrows
		f:Hide() --Hide the up/down arrows
		_G[format("%s%d", "ChatFrame", i)]:SetClampRectInsets(0,0,0,0) --Allow the chat frame to move to the end of the screen
	end

	for i = 1, NUM_CHAT_WINDOWS do
		FixChatButtons(i)
	end
end

-- Scroll
local FixScroll
do
	local function scroll(self, arg1)
		if arg1 > 0 then
			if IsShiftKeyDown() then
				self:ScrollToTop()
			elseif IsControlKeyDown() then
				self:PageUp()
			else
				for i = 1, scrollLines do
					self:ScrollUp()
				end
			end
		elseif arg1 < 0 then
			if IsShiftKeyDown() then
				self:ScrollToBottom()
			elseif IsControlKeyDown() then
				self:PageDown()
			else
				for i = 1, scrollLines do
					self:ScrollDown()
				end
			end
		end
	end

	function FixScroll(i)
		local cf = _G["ChatFrame"..i]
		cf:SetScript("OnMouseWheel", scroll)
		cf:EnableMouseWheel(true)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		FixScroll(i)
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	_G["ChatFrame"..i].isNevModAugmented = true
end

hooksecurefunc("FCF_OpenTemporaryWindow", function()
	for id, frame in pairs(CHAT_FRAMES) do
		local cf = _G[frame]
		if not cf.isNevModAugmented then
			FixChatButtons(id)
			FixEditBox(id)
			FixScroll(id)
			cf.isNevModAugmented = true
		end
	end
end)