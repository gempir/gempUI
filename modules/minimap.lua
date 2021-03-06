local F, G = unpack(select(2, ...))

Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", G.frame, "TOPRIGHT", -6, -6)
Minimap:SetSize(178, 178)
F.addBackdrop(Minimap)

-- displays time/clock 
if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn("Blizzard_TimeManager")
end

if not TimeManagerMilitaryTimeCheck:GetChecked() then TimeManagerMilitaryTimeCheck:Click() end

-- Shape Square
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')

-- functions

local function StripTextures(object, kill)
	for i = 1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Hide()
			else
				region:SetTexture(nil)
			end
		end
	end
end

-- stripping textures from some icon

StripTextures(QueueStatusFrame)
StripTextures(GarrisonLandingPageMinimapButton)

-- Minimap Buttons 
MinimapBorder:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MinimapBorderTop:Hide()
-- MiniMapVoiceChatFrame:Hide()
MinimapNorthTag:SetTexture(nil)
MinimapZoneTextButton:Hide()
MiniMapWorldMapButton:Hide()
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:Hide()
GameTimeFrame:Hide()

--Mail
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPLEFT", Minimap, -1, 2)
MiniMapMailFrame:SetFrameStrata("LOW")
MiniMapMailIcon:SetTexture("Interface\\Addons\\gempUI\\media\\minimap\\mail")
MiniMapMailBorder:Hide()
MiniMapMailFrame:SetScale(1.2)

-- Garrison 
GarrisonLandingPageMinimapButton:SetSize(0,0)
GarrisonLandingPageMinimapButton:SetAlpha(0)
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetParent(Minimap)
GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, 0)

-- Durability
DurabilityFrame:SetPoint("CENTER", Minimap, "CENTER", -30, 0)
-- DungeonFinder LFG LFR
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 1, -1)
QueueStatusMinimapButtonBorder:Hide()
QueueStatusFrame:SetBackdrop({
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	edgeFile = "Interface\\Buttons\\WHITE8x8",
	edgeSize = 1,
	insets = { left = -0, right = -0, top = -0, bottom = -0 }
})
QueueStatusFrame:SetBackdropColor(unpack(G.colors.base))
QueueStatusFrame:SetBackdropBorderColor(0, 0, 0, 1)
QueueStatusFrame:SetBackdropBorderColor(unpack(G.colors.border))

--Tracking

MiniMapTrackingBackground:SetAlpha(0)
MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetPoint("TOPRIGHT", Minimap, -2, -2)
MiniMapTrackingButtonBorder:Hide()
Mixin(MiniMapTrackingButton, BackdropTemplateMixin)
MiniMapTrackingButton:SetBackdropBorderColor(0, 0, 0)
MiniMapTracking:SetAlpha(0)


local function OnLeave()
	if not Minimap:IsMouseOver() then
		UIFrameFadeOut(MiniMapTracking, 0.3, 1, 0)
		UIFrameFadeOut(GarrisonIcon, 0.3, 1, 0)
	end
end

Minimap:HookScript('OnEnter', function()
	UIFrameFadeIn(MiniMapTracking, 0.3, 0, 1)
	UIFrameFadeIn(GarrisonIcon, 0.3, 0, 1)
end)
Minimap:HookScript('OnLeave', OnLeave)
MiniMapTrackingButton:HookScript('OnLeave', OnLeave)
QueueStatusMinimapButton:HookScript('OnLeave', OnLeave)
MiniMapMailFrame:HookScript('OnLeave', OnLeave)
TimeManagerClockButton:HookScript('OnLeave', OnLeave)


-- Scrolling in Minimap
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)


-- Local for rightclick menu

--The beginnings of a localization so even everyone can read our menu
local ClickMenu, namespace = ...

local L = setmetatable({
	['Achievements'] = ACHIEVEMENTS,
	['Calendar'] = 'Calendar', -- no Blizz global string for this
	['Character'] = CHARACTER,
	['Dungeon Journal'] = ENCOUNTER_JOURNAL,
	['Friends'] = FRIENDS,
	['Group Finder'] = GROUP_FINDER, -- actually 'Dungeon Finder' in English
	['Guild'] = GUILD,
	['Inventory'] = INVENTORY_TOOLTIP,
	['Logout'] = LOGOUT,
	['Micro Menu'] = 'Micro Menu', -- no Blizz global string for this
	['Mounts'] = MOUNTS,
	['Pets'] = PETS,
	['Player vs. Player'] = PLAYER_V_PLAYER,
	['Quest Log'] = QUESTLOG_BUTTON,
	['Quit'] = QUIT,
	['Shop'] = BLIZZARD_STORE, -- Blizz terminology uses 'Shop' instead of 'Store'
	['Spellbook'] = SPELLBOOK,
	['Support'] = GAMEMENU_HELP,
	['Talents'] = TALENTS,
	['Toy Box'] = TOY_BOX,
	['Zone Map'] = BATTLEFIELD_MINIMAP,
}, {
	__index = function(t, k)
		local v = tostring(k)
		rawset(t, k, v)
		return v
	end
})

namespace.L = L

local GAME_LOCALE = GetLocale()
if GAME_LOCALE == 'deDE' then
	L['Micro Menu'] = 'Mikromenü'
	L['Calendar'] = 'Kalender'
elseif GAME_LOCALE == 'esES' or GAME_LOCALE == 'esMX' then
	L['Micro Menu'] = 'Micro menú'
	L['Calendar'] = 'Calendario'
elseif GAME_LOCALE == 'frFR' then
	L['Micro Menu'] = 'Micro menu'
	L['Calendar'] = 'Calendrier'
elseif GAME_LOCALE == 'itIT' then
	L['Micro Menu'] = 'Micro menu'
	L['Calendar'] = 'Calendario'
elseif GAME_LOCALE == 'ptBR' then
	L['Micro Menu'] = 'Mini Menu'
	L['Calendar'] = 'Calendário'
elseif GAME_LOCALE == 'ruRU' then
	L['Micro Menu'] = 'Микроменю'
	L['Calendar'] = 'Календарь'
elseif GAME_LOCALE == 'koKR' then
	L['Micro Menu'] = '게임 메뉴'
	L['Calendar'] = '달력'
elseif GAME_LOCALE == 'zhCN' then
	L['Micro Menu'] = '微型主菜单'
	L['Calendar'] = '日历'
elseif GAME_LOCALE == 'zhTW' then
	L['Micro Menu'] = '微型選單'
	L['Calendar'] = '曆'
end




--- Rightclick menu 

local ClickMenu, namespace = ...
local L = namespace.L
local _, cfg = ... --export config

cfg = {
	MouseButton = 'RightButton', --LeftButton, RightButton, MiddleButton --Only affects minimap integration

	use_Minimap = true, --disabling this forces Click Menu to make a button
	button = {
		location = { "CENTER", G.frame, "CENTER", 0, 0 },
		blizzard_theme = false,
		color = {
			normal = { 0, 0, 0, 0.5 },
			hover = { 0.1, 0.1, 0.1, 0.5 },
			pushed = { 0, 0, 0, 1 },
		},
	},
}


local menuFrame = CreateFrame('Frame', 'ClickMenu', G.frame, 'UIDropDownMenuTemplate')
local menuList = {
	{
		text = L['Micro Menu'],
		isTitle = true,
		notCheckable = true,
	},
	{
		text = L['Character'],
		icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
		func = function()
			securecall(ToggleCharacter, 'PaperDollFrame')
		end,
		notCheckable = true,
	},
	{
		text = L['Spellbook'],
		icon = 'Interface\\MINIMAP\\TRACKING\\Class',
		func = function()
			securecall(ToggleSpellBook, BOOKTYPE_SPELL)
		end,
		notCheckable = true,
	},
	{
		text = L['Talents'],
		icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
		func = function()
			if (not PlayerTalentFrame) then
				LoadAddOn('Blizzard_TalentUI')
			end

			if (not GlyphFrame) then
				LoadAddOn('Blizzard_GlyphUI')
			end

			securecall(ToggleTalentFrame)
		end,
		notCheckable = true,
	},
	{
		text = L['Inventory'],
		icon = 'Interface\\MINIMAP\\TRACKING\\Banker',
		func = function()
			securecall(ToggleAllBags)
		end,
		notCheckable = true,
	},
	{
		text = L['Achievements'],
		icon = 'Interface\\ACHIEVEMENTFRAME\\UI-Achievement-Shield',
		func = function()
			securecall(ToggleAchievementFrame)
		end,
		notCheckable = true,
	},
	{
		text = L['Quest Log'],
		icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
		func = function()
			securecall(ToggleFrame, WorldMapFrame)
		end,
		tooltipTitle = securecall(MicroButtonTooltipText, QUESTLOG_BUTTON, 'TOGGLEQUESTLOG'),
		tooltipText = NEWBIE_TOOLTIP_QUESTLOG,
		notCheckable = true,
	},
	{
		text = L['Friends'],
		icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
		func = function()
			securecall(ToggleFriendsFrame, 1)
		end,
		notCheckable = true,
	},
	{
		text = L['Guild'],
		icon = 'Interface\\GossipFrame\\TabardGossipIcon',
		arg1 = IsInGuild('player'),
		func = function()
			if (IsTrialAccount()) then
				UIErrorsFrame:AddMessage(ERR_RESTRICTED_ACCOUNT, 1, 0, 0)
			else
				securecall(ToggleGuildFrame)
			end
		end,
		notCheckable = true,
	},
	{
		text = L['Group Finder'],
		icon = 'Interface\\LFGFRAME\\BattleNetWorking0',
		func = function()
			securecall(PVEFrame_ToggleFrame, 'GroupFinderFrame', LFDParentFrame)
		end,
		notCheckable = true,
	},
	{
		text = L['Player vs. Player'], --broke
		icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
		func = function()
			securecall(PVEFrame_ToggleFrame, 'PVPUIFrame', HonorFrame)
		end,
		tooltipTitle = securecall(MicroButtonTooltipText, PLAYER_V_PLAYER, 'TOGGLECHARACTER4'),
		tooltipText = NEWBIE_TOOLTIP_PVP,
		notCheckable = true,
	},
	{
		text = L['Dungeon Journal'],
		icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
		func = function()
			securecall(ToggleEncounterJournal)
		end,
		notCheckable = true,
	},
	{
		text = L['Mounts'], --broke
		icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster',
		func = function()
			securecall(ToggleCollectionsJournal, 1)
		end,
		tooltipTitle = securecall(MicroButtonTooltipText, MOUNTS_AND_PETS, 'TOGGLEPETJOURNAL'),
		notCheckable = true,
	},
	{
		text = L['Pets'], --broke
		icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster',
		func = function()
			securecall(ToggleCollectionsJournal, 2)
		end,
		tooltipTitle = securecall(MicroButtonTooltipText, MOUNTS_AND_PETS, 'TOGGLEPETJOURNAL'),
		notCheckable = true,
	},
	{
		text = L['Toy Box'], --broke
		icon = 'Interface\\MINIMAP\\TRACKING\\Reagents',
		func = function()
			securecall(ToggleCollectionsJournal, 3)
		end,
		tooltipTitle = securecall(MicroButtonTooltipText, TOY_BOX, 'TOGGLETOYBOX'),
		notCheckable = true,
	},
	{
		text = L['Heirlooms'], --broke
		icon = 'Interface\\MINIMAP\\TRACKING\\Reagents',
		func = function()
			securecall(ToggleCollectionsJournal, 4)
		end,
		tooltipTitle = securecall(MicroButtonTooltipText, TOY_BOX, 'TOGGLETOYBOX'),
		notCheckable = true,
	},
	{
		text = L["Calender"], --broke
		icon = 'Interface\\Calendar\\UI-Calendar-Button',
		func = function()
			if (not StoreFrame) then
				LoadAddOn('Blizzard_Calendar')
			end
			securecall(Calendar_Toggle)
		end,
		notCheckable = true,
	},
	{
		text = L['Shop'],
		icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
		func = function()
			if (not StoreFrame) then
				LoadAddOn('Blizzard_StoreUI')
			end
			securecall(ToggleStoreUI)
		end,
		notCheckable = true,
	},
	{
		text = L['Support'],
		icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
		func = function()
			securecall(ToggleHelpFrame)
		end,
		notCheckable = true,
	},
	{
		text = L['Zone Map'],
		func = function()
			securecall(ToggleBattlefieldMinimap)
		end,
		notCheckable = true,
	},
	{
		text = L['Logout'],
		func = function()
			Logout()
		end,
		notCheckable = true,
	},
	--[[
  {
	  text = L['Quit'],
	  func = function()
		ForceQuit()
	  end,
	  notCheckable = true,
	},
	]]
}
if IsAddOnLoaded("Carbonite") or IsAddOnLoaded("Sexymap") or IsAddOnLoaded("Chinchilla") then --check to see if a conflicting addon is loaded
	local button = CreateFrame("Button", nil, mainframe) --if one is we make a button
	button:SetPoint(unpack(cfg.button.location))
	button:SetWidth(50)
	button:SetHeight(25)

	button:SetText("Menu")
	button:SetNormalFontObject("GameFontNormal")

	local ntex = button:CreateTexture()
	if cfg.blizzard_theme then
		ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
	else
		ntex:SetTexture("Interface\\Buttons\\WHITE8x8")
		ntex:SetVertexColor(unpack(cfg.button.color.normal))
	end
	ntex:SetTexCoord(0, 0.625, 0, 0.6875)
	ntex:SetAllPoints()
	button:SetNormalTexture(ntex)

	local htex = button:CreateTexture()
	if blizzard_theme then
		htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
	else
		htex:SetTexture("Interface\\Buttons\\WHITE8x8")
		htex:SetVertexColor(unpack(cfg.button.color.hover))
	end
	htex:SetTexCoord(0, 0.625, 0, 0.6875)
	htex:SetAllPoints()
	button:SetHighlightTexture(htex)

	local ptex = button:CreateTexture()
	if blizzard_theme then
		ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
	else
		ptex:SetTexture("Interface\\Buttons\\WHITE8x8")
		ptex:SetVertexColor(unpack(cfg.button.color.pushed))
	end
	ptex:SetTexCoord(0, 0.625, 0, 0.6875)
	ptex:SetAllPoints()
	button:SetPushedTexture(ptex)

	button:SetScript('OnMouseUp', function(self, button)
		if button == "LeftButton" or button == "RightButton" or button == "MiddleButton" then
			securecall(EasyMenu, menuList, menuFrame, self, 27, 190, 'MENU', 8)
		end
	end)
else --if there's no addon enabled we load the config up top
	if cfg.use_Minimap then
		Minimap:SetScript('OnMouseUp', function(self, button)
			if button == cfg.MouseButton then
				securecall(EasyMenu, menuList, menuFrame, self, 27, 190, 'MENU', 8)
			else
				Minimap_OnClick(self)
			end
		end)
	else --use a button
		local button = CreateFrame("Button", nil, mainframe)
		button:SetPoint(unpack(cfg.button.location))
		button:SetWidth(50)
		button:SetHeight(25)

		button:SetText("Menu")
		button:SetNormalFontObject("GameFontNormal")

		local ntex = button:CreateTexture()
		if cfg.blizzard_theme then
			ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
		else
			ntex:SetTexture("Interface\\Buttons\\WHITE8x8")
			ntex:SetVertexColor(unpack(cfg.button.color.normal))
		end
		ntex:SetTexCoord(0, 0.625, 0, 0.6875)
		ntex:SetAllPoints()
		button:SetNormalTexture(ntex)

		local htex = button:CreateTexture()
		if blizzard_theme then
			htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
		else
			htex:SetTexture("Interface\\Buttons\\WHITE8x8")
			htex:SetVertexColor(unpack(cfg.button.color.hover))
		end
		htex:SetTexCoord(0, 0.625, 0, 0.6875)
		htex:SetAllPoints()
		button:SetHighlightTexture(htex)

		local ptex = button:CreateTexture()
		if blizzard_theme then
			ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
		else
			ptex:SetTexture("Interface\\Buttons\\WHITE8x8")
			ptex:SetVertexColor(unpack(cfg.button.color.pushed))
		end
		ptex:SetTexCoord(0, 0.625, 0, 0.6875)
		ptex:SetAllPoints()
		button:SetPushedTexture(ptex)

		button:SetScript('OnMouseUp', function(self, button)
			if button == "LeftButton" or button == "RightButton" or button == "MiddleButton" then
				securecall(EasyMenu, menuList, menuFrame, self, 27, 190, 'MENU', 8)
			end
		end)
	end
end