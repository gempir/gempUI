local F, G = unpack(select(2, ...))

------------------------------------------------------------------------
-- Basic configuration section. Width, height, anchor point etc ...
------------------------------------------------------------------------

-- Bar settings
local width = 49
local height = 22

-- Tooltip settings
local ttanchorpoint = "BOTTOMLEFT"
local ttanchorframe = "BOTTOMRIGHT"
local ttxoffset = 5
local ttyoffset = -2
local grepbarcolor = { 0 / 255, 150 / 255, 50 / 255 }

------------------------------------------------------------------------
-- End of configuration
------------------------------------------------------------------------

-- Local variables
local gained, sessionxp, min, max
local name, standing, minrep, maxrep, value
local factions = {}
local flen = 0

local TEXTURE = G.media .. "textures\\flat"
local BACKDROP = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	insets = { top = 0, left = 0, bottom = 0, right = 0 },
}
local shadows = {
	edgeFile = "Interface\\Buttons\\WHITE8x8",
	edgeSize = 1,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

local reaction = {
	[1] = { r = 222 / 255, g = 95 / 255, b = 95 / 255 }, -- Hated
	[2] = { r = 222 / 255, g = 95 / 255, b = 95 / 255 }, -- Hostile
	[3] = { r = 222 / 255, g = 95 / 255, b = 95 / 255 }, -- Unfriendly
	[4] = { r = 218 / 255, g = 197 / 255, b = 92 / 255 }, -- Neutral
	[5] = { r = 75 / 255, g = 175 / 255, b = 76 / 255 }, -- Friendly
	[6] = { r = 75 / 255, g = 175 / 255, b = 76 / 255 }, -- Honored
	[7] = { r = 0 / 255, g = 112 / 255, b = 221 / 255 }, -- Revered
	[8] = { r = 163 / 255, g = 53 / 255, b = 238 / 255 }, -- Exalted
}
local repstanding = {
	[1] = "Hated",
	[2] = "Hostile",
	[3] = "Unfriendly",
	[4] = "Neutral",
	[5] = "Friendly",
	[6] = "Honored",
	[7] = "Revered",
	[8] = "Exalted",
}

local font = CreateFont("xpBarFont")
font:SetFont(G.fonts.square, 12, "THINOUTLINE")
font:SetTextColor(1, 1, 1)

------------------------------------------------------------------------
-- Tooltip
------------------------------------------------------------------------
local function truncate(value)
	if (value > 9999) then
		return string.format("|cffffffff%.0f|rk", value / 1e3)
	else
		return "|cffffffff" .. value .. "|r"
	end
end



------------------------------------------------------------------------
-- Panels
------------------------------------------------------------------------

--	Create the panel and bars
gXpbarp = CreateFrame("Frame", nil, G.frame, BackdropTemplateMixin and "BackdropTemplate")
gXpbarp:SetFrameStrata("LOW")
gXpbarp:SetHeight(height - 2)
gXpbarp:SetWidth(width - 2)
gXpbarp:SetPoint("RIGHT", G.frame, "RIGHT", 1, 169)


F.addBackdrop(gXpbarp)

gempXpbar = CreateFrame("statusbar", nil, G.frame)
gempXpbar:SetPoint("CENTER", gXpbarp, "CENTER", 0, 0)
gempXpbar:SetOrientation("HORIZONTAL")
gempXpbar:SetWidth(width - 2)
gempXpbar:SetHeight(height - 3)
gempXpbar:SetStatusBarTexture(TEXTURE)
gempXpbar:SetStatusBarColor(unpack(grepbarcolor))
gempXpbar:EnableMouse()

local text = gempXpbar:CreateFontString(nil, "OVERLAY")
text:SetPoint("CENTER", gempXpbar, "CENTER", 0, 0)
text:SetFontObject(font)
text:SetAlpha(0)

local xpreptxt = CreateFrame("Frame", xpreptxt, gempXpbar)
xpreptxt:SetPoint("CENTER", gXpbarp, "CENTER", 0, 0)
xpreptxt:SetWidth(width - 2)
xpreptxt:SetHeight(height - 3)

------------------------------------------------------------------------
-- Tooltip
------------------------------------------------------------------------
local function OnEnter(self)
	-- Create the tooltip
	-- GameTooltip:SetOwner(self, 'ANCHOR_NONE')
	-- GameTooltip:SetPoint(ttanchorpoint, self, ttanchorframe, ttxoffset, ttyoffset)
	GameTooltip_SetDefaultAnchor(GameTooltip, G.frame)

	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()

	-- Tooltip for tracking experience
	if (name == nil) then
		local min = UnitXP("player")
		local max = UnitXPMax("player")
		local retVal = GetXPExhaustion()

		-- Display basic experience information
		GameTooltip:AddLine("Experience", 0 / 255, 150 / 255, 50 / 255)
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(format('Experience: %s  / %s (%.1f%%)', truncate(min), truncate(max), min / max * 100))
		GameTooltip:AddLine(format('Remaining: %s (%.1f%%)', truncate(max - min), 100 - (min / max * 100)))

		if (retVal) then
			GameTooltip:AddLine(format('|cff1369caRested: %s (|cffffffff%.1f|r%%)', truncate(retVal), retVal / max * 100))
		end


		-- Tooltip for tracking reputation
	else
		maxrep = (maxrep - minrep)
		minrep = (value - minrep)

		-- Display basic reputation information
		GameTooltip:AddLine("Reputation", 0 / 255, 150 / 255, 50 / 255)
		GameTooltip:AddLine(' ')
		GameTooltip:AddLine(format('Watched Faction: |cffffffff%s|r', name))
		GameTooltip:AddLine(format('Current Standing: |cFF%02x%02x%02x%s|r', reaction[standing].r * 255, reaction[standing].g * 255, reaction[standing].b * 255, repstanding[standing]))
		GameTooltip:AddLine(format('Value: |cffffffff%d|r  / |cffffffff%d|r %.1f%%', minrep, maxrep, minrep / maxrep * 100))
	end

	GameTooltip:Show()
	UIFrameFadeIn(text, 0.3, 1, 1)
end

local function OnLeave(self)
	GameTooltip:Hide()
	UIFrameFadeOut(text, 0.3, 1, 0)
end

------------------------------------------------------------------------
-- Update Functions
------------------------------------------------------------------------
function gempXpbar:PLAYER_XP_UPDATE()
	gained = 0
	sessionxp = 0
	min = UnitXP("player")
	max = UnitXPMax("player")

	-- Prevent game loading errors
	if (min == nil or max == nil) then
		return
	end

	-- Handle the counting of gained experience even after the player has levelled up
	if (UnitXP("player") >= min) then
		gained = UnitXP("player") - min
	else
		gained = UnitXP("player") + (max - min)
	end

	sessionxp = sessionxp + gained
	min = UnitXP("player")
	max = UnitXPMax("player")

	-- Discover if a faction is curently being watched if so return nil
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
	if (name ~= nil) then
		return nil
	end

	-- Set the xpbar colour and values
	gempXpbar:SetStatusBarColor(unpack(grepbarcolor))
	gempXpbar:SetMinMaxValues(0, max)
	gempXpbar:SetValue(min)

	-- If the player has just gained some experience display this on the main bar else just display current experience information
	if (gained == 0) then
		text:SetFormattedText("|cffffffff%.1f|r%%", min / max * 100)
	else
		text:SetFormattedText("|cffffffff%.1f|r%% +|cffffffff%.0f|r", min / max * 100, gained)
	end
end

function gempXpbar:PLAYER_ENTERING_WORLD()

	-- Prevent game loading errors
	if (min == nil or max == nil) then
		return
	end

	-- Handle the counting of gained experience even after the player has levelled up
	if (UnitXP("player") >= min) then
		gained = UnitXP("player") - min
	else
		gained = UnitXP("player") + (max - min)
	end

	sessionxp = sessionxp + gained
	min = UnitXP("player")
	max = UnitXPMax("player")

	-- Discover if a faction is curently being watched if so return nil
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
	if (name ~= nil) then
		return nil
	end

	-- Set the xpbar colour and values
	gempXpbar:SetStatusBarColor(unpack(grepbarcolor))
	gempXpbar:SetMinMaxValues(0, max)
	gempXpbar:SetValue(min)

	-- If the player has just gained some experience display this on the main bar else just display current experience information
	if (gained == 0) then
		text:SetFormattedText("|cffffffff%.1f|r%%", min / max * 100)
	else
		text:SetFormattedText("|cffffffff%.1f|r%% +|cffffffff%.0f|r", min / max * 100, gained)
	end
end

function gempXpbar:UPDATE_FACTION()

	-- This event fires before the reputation panel is loaded so if the panel isn't ready return nil
	if (GetNumFactions() == 0) then return nil end

	-- If the factions table hasn't been loaded load it to compare against during the session
	if (flen == 0) then
		for i = 1, GetNumFactions() do
			name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild = GetFactionInfo(i)
			if (not isHeader) then
				factions[name] = barValue
			end
		end
		for key, value in pairs(factions) do
			flen = flen + 1
		end
	end

	-- Discover if a faction is curently being watched if so PLAYER_XP_UPDATE() then return nil
	name, standing, minrep, maxrep, value = GetWatchedFactionInfo()
	if (name == nil) then
		self:PLAYER_XP_UPDATE()
		return nil
	end

	maxrep = (maxrep - minrep)
	minrep = (value - minrep)

	gempXpbar:SetStatusBarColor(unpack(grepbarcolor))
	gempXpbar:SetMinMaxValues(0, maxrep)
	gempXpbar:SetValue(minrep)

	text:SetFormattedText("|cffffffff %.1f%%|r", minrep / maxrep * 100)
end

--	RegisterEvents

gempXpbar:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...); end)
xpreptxt:SetScript("OnEnter", OnEnter)
xpreptxt:SetScript("OnLeave", OnLeave)
gempXpbar:RegisterEvent("PLAYER_ENTERING_WORLD")
gempXpbar:RegisterEvent("PLAYER_XP_UPDATE")
gempXpbar:RegisterEvent("UPDATE_FACTION")
