local F, G, V = unpack(select(2, ...))

local function SetFont(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r)
	end
end


local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()
	local NORMAL = G.fonts.roboto
	local BOLD = G.fonts.roboto_bold
	local BOLDITALIC = G.fonts.roboto_bolditalic
	local ITALIC = G.fonts.roboto_italic
	local NUMBER = G.fonts.roboto_bold
	local FONT_SQUARE = G.fonts.square

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = { 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 }

	UNIT_NAME_FONT = NORMAL
	DAMAGE_TEXT_FONT = NUMBER
	STANDARD_TEXT_FONT = NORMAL

	-- Base fonts
	SetFont(AchievementFont_Small, BOLD, 11)
	SetFont(FriendsFont_Large, NORMAL, 14, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Normal, NORMAL, 12, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_Small, NORMAL, 10, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(FriendsFont_UserText, NUMBER, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameTooltipHeader, BOLD, 14, "OUTLINE")
	SetFont(GameFont_Gigantic, BOLD, 31, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(InvoiceFont_Med, ITALIC, 12, nil, 0.15, 0.09, 0.04)
	SetFont(InvoiceFont_Small, ITALIC, 10, nil, 0.15, 0.09, 0.04)
	SetFont(MailFont_Large, ITALIC, 14, nil, 0.15, 0.09, 0.04, 0.54, 0.4, 0.1, 1, -1)
	SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER, 12, "OUTLINE")
	SetFont(NumberFont_Outline_Huge, NUMBER, 29, "THICKOUTLINE", 30)
	SetFont(NumberFont_Outline_Large, NUMBER, 16, "OUTLINE")
	SetFont(NumberFont_Outline_Med, NUMBER, 14, "OUTLINE")
	SetFont(NumberFont_Shadow_Med, NORMAL, 13)
	SetFont(NumberFont_Shadow_Small, NORMAL, 11)
	SetFont(QuestFont_Shadow_Small, NORMAL, 15)
	SetFont(QuestFont_Large, NORMAL, 15)
	SetFont(QuestFont_Shadow_Huge, BOLD, 18, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(QuestFont_Super_Huge, BOLD, 23)
	SetFont(ReputationDetailFont, BOLD, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SpellFont_Small, BOLD, 10)
	SetFont(SystemFont_InverseShadow_Small, BOLD, 10)
	SetFont(SystemFont_Large, NORMAL, 16)
	SetFont(SystemFont_Med1, NORMAL, 12)
	SetFont(SystemFont_Med2, ITALIC, 13, nil, 0.15, 0.09, 0.04)
	SetFont(SystemFont_Med3, NORMAL, 14)
	SetFont(SystemFont_OutlineThick_Huge2, NORMAL, 21, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_Huge4, BOLDITALIC, 26, "THICKOUTLINE")
	SetFont(SystemFont_OutlineThick_WTF, BOLDITALIC, 30, "THICKOUTLINE", nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SystemFont_Outline_Small, NUMBER, 13, "OUTLINE")
	SetFont(SystemFont_Shadow_Huge1, BOLD, 19)
	SetFont(SystemFont_Shadow_Huge3, BOLD, 24)
	SetFont(SystemFont_Shadow_Large, NORMAL, 16)
	SetFont(SystemFont_Shadow_Med1, NORMAL, 12)
	SetFont(SystemFont_Shadow_Med2, NORMAL, 13)
	SetFont(SystemFont_Shadow_Med3, NORMAL, 14)
	SetFont(SystemFont_Shadow_Outline_Huge2, NORMAL, 21, "OUTLINE")
	SetFont(SystemFont_Shadow_Small, BOLD, 10)
	SetFont(SystemFont_Small, NORMAL, 11)
	SetFont(SystemFont_Tiny, NORMAL, 10)
	SetFont(Tooltip_Med, NORMAL, 12)
	SetFont(Tooltip_Small, BOLD, 11)

	-- Derived fonts
	SetFont(BossEmoteNormalHuge, BOLDITALIC, 26, "THICKOUTLINE")
	SetFont(CombatTextFont, NORMAL, 25)
	SetFont(ErrorFont, ITALIC, 15, nil, 60)
	SetFont(QuestFontNormalSmall, BOLD, 12, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(WorldMapTextFont, BOLDITALIC, 30, "THICKOUTLINE", 40, nil, nil, 0, 0, 0, 1, -1)

	for i = 1, 7 do
		local f = _G["ChatFrame" .. i]
		local font, size = f:GetFont()
		f:SetFont(NORMAL, size)
		f:SetShadowOffset(1, -1)
		f:SetShadowColor(0, 0, 0, 0.75)
	end

	-- -- I have no idea why the channel list is getting fucked up
	-- -- but re-setting the font obj seems to fix it
	-- for i = 1, MAX_CHANNEL_BUTTONS do
	-- 	local f = _G["ChannelButton" .. i .. "Text"]
	-- 	f:SetFontObject(GameFontNormalSmallLeft)

	-- 	-- function f:SetFont(...) error("Attempt to set font on ChannelButton"..i) end
	-- end
end)

-- changes the damage font
dmgfont = CreateFrame("Frame", "dmgfont");

local damagefont_FONT_NUMBER = "Interface\\AddOns\\gempUI\\media\\fonts\\roboto.ttf";

function dmgfont:ApplySystemFonts()

	DAMAGE_TEXT_FONT = damagefont_FONT_NUMBER;
end

dmgfont:SetScript("OnEvent",
	function()
		if (event == "ADDON_LOADED") then
			dmgfont:ApplySystemFonts()
		end
	end);
dmgfont:RegisterEvent("ADDON_LOADED");

dmgfont:ApplySystemFonts()

-- Adventure guide



local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED")

function frame:OnEvent(event, arg1)

	if event == "ADDON_LOADED" and arg1 == "Blizzard_EncounterJournal" then

		EncounterJournalSuggestFrame.Suggestion1.centerDisplay.description.text:SetFont(G.fonts.roboto, 12, "NONE")
	end
end

frame:SetScript("OnEvent", frame.OnEvent);