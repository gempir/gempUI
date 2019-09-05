local addon, ns = ...
local cfg = CreateFrame("Frame")
local F, G, V = unpack(select(2, ...))
--ActionBars config
cfg.mAB = {
	size = 37, -- setting up default buttons size
	size_small = 28,
	spacing = 2, -- spacing between buttons
	spacing_small = 3,
	media = {-- MEDIA
		--textures_normal = "Interface\\Addons\\m_ActionBars\\media\\icon.tga",
		--textures_pushed = "Interface\\Addons\\m_ActionBars\\media\\icon.tga",
		--textures_btbg = "Interface\\Buttons\\WHITE8x8", 
		--button_font = "Interface\\Addons\\m_ActionBars\\media\\font.ttf",
	},
}

cfg.bars = {
	["Bar1"] = {
		hide_bar = false,
		show_in_combat = false,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.5,
		orientation = "HORIZONTAL",
		rows = 1,
		buttons = 8,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "CENTER", x = 0, y = -440 },
		custom_visibility_macro = false -- set a custom visibility macro for this bar or 'false' to disable
		-- (e.g. "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists]hide;show")
	},
	["Bar2"] = {
		hide_bar = false,
		show_in_combat = false,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.5,
		orientation = "HORIZONTAL",
		rows = 1,
		buttons = 8,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "CENTER", x = 0, y = -479 },
		custom_visibility_macro = false
	},
	["Bar3"] = {
		hide_bar = false,
		show_in_combat = false,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.5,
		orientation = "HORIZONTAL",
		rows = 1,
		buttons = 8,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "CENTER", x = 0, y = -518 },
		custom_visibility_macro = false
	},
	["Bar4"] = {
		hide_bar = false,
		show_in_combat = false,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.0,
		orientation = "VERTICAL",
		rows = 1,
		buttons = 8,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "RIGHT", x = -4, y = 0 },
		custom_visibility_macro = false
	},
	["Bar5"] = {
		hide_bar = true,
		show_in_combat = false,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.0,
		orientation = "VERTICAL",
		rows = 1,
		buttons = 12,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "RIGHT", x = -43, y = 0 },
		custom_visibility_macro = false
	},
	["Bar6"] = {
		hide_bar = true,
		show_in_combat = false,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.5,
		orientation = "VERTICAL",
		rows = 1,
		buttons = 12,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "RIGHT", x = -105, y = 0 },
		custom_visibility_macro = false
	},
	["StanceBar"] = {
		hide_bar = false,
		show_in_combat = false,
		show_on_mouseover = true,
		bar_alpha = 1,
		fadeout_alpha = 0.0,
		orientation = "HORIZONTAL",
		rows = 2,
		buttons = 6,
		button_size = cfg.mAB.size_small,
		button_spacing = cfg.mAB.spacing_small,
		position = { a = "BOTTOM", x = -370, y = 0 },
		custom_visibility_macro = false
	},
	["PetBar"] = {
		hide_bar = false,
		show_in_combat = false,
		scale = 0.8,
		show_on_mouseover = true,
		bar_alpha = 1,
		fadeout_alpha = 0.0,
		orientation = "VERTICAL",
		rows = 1,
		buttons = 10,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "LEFT", x = 0, y = 0 },
		custom_visibility_macro = false
	},
	["MicroMenu"] = {
		hide_bar = false,
		show_on_mouseover = true,
		scale = 0.7,
		lock_to_CharacterFrame = false, -- position MicroMenu bar right on top of your CharacterFrame
		position = { a = "BOTTOMRIGHT", x = -545, y = 0 }, -- if not locked
	},
	["ExtraButton"] = {
		disable = false,
		position = { a = "BOTTOM", x = 0, y = 400 },
	},
	["RaidIconBar"] = {
		hide = true,
		in_group_only = true,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.5,
		orientation = "VERTICAL",
		rows = 1,
		button_size = 20,
		button_spacing = 3,
		position = { a = "RIGHT", x = -10, y = -77 },
	},
	["WorldMarkerBar"] = {
		hide = false,
		disable_in_combat = true,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.5,
		orientation = "VERTICAL",
		rows = 1,
		button_size = 20,
		button_spacing = cfg.mAB.spacing,
		position = { a = "RIGHT", x = -10, y = 122 },
	},
	["ExitVehicleButton"] = {
		position = { a = "BOTTOM", x = 0, y = 0 },
	},
}

cfg.buttons = {
	hide_hotkey = false, -- remove key binding text from the bars
	hide_macro_name = true, -- remove macro name text from the bars
	count_font_size = 12, -- remove count text from the bars
	hotkey_font_size = 11, -- font size for the key bindings text
	name_font_size = 8, -- font size for the macro name text
	colors = {
		--R,G,B
		normal = { 0, 0, 0 },
		pushed = { 1, 1, 1 },
		highlight = { .9, .8, .6 },
		checked = { .9, .8, .6 },
		outofrange = { .8, .3, .2 },
		outofmana = { .3, .3, .7 },
		usable = { 1, 1, 1 },
		unusable = { .4, .4, .4 },
		equipped = { .3, .6, .3 }
	}
}

-- HANDOVER
ns.cfg = cfg


-------------------------- CONFIG END ----------------------------------------

local addon, ns = ...
local cfg = ns.cfg
local mAB = CreateFrame("Frame")

--- - Addon functions
local myclass = select(2, UnitClass("player"))

-- holder creating func
mAB.CreateHolder = function(name, pos)
	local bar = CreateFrame("Frame", name, UIParent, "SecureHandlerStateTemplate")
	bar:SetPoint(pos.a, pos.x, pos.y)
	bar:SetFrameStrata("MEDIUM")
	return bar
end

-- I always wanted to have my personal death star to destroy stuff!
local DeathStar = mAB.CreateHolder("DeathStar", { a = "TOP", x = 0, y = 100 })
DeathStar:Hide()

-- style function for bars
--mAB.SetBar = function(bar, btn, num, orient, rows, visnum, bsize, spacing)
mAB.SetBar = function(bar, btn, num, cfgn)
	local orient, rows, visnum, bsize, spacing = cfg.bars[cfgn].orientation, cfg.bars[cfgn].rows, cfg.bars[cfgn].buttons, cfg.bars[cfgn].button_size, cfg.bars[cfgn].button_spacing
	local pad = spacing or cfg.spacing
	local first_row_num = math.floor(visnum / rows)
	local buttonList = {}
	for i = 1, num do
		local button = _G[btn .. i]
		if not button then
			break
		end
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(bsize, bsize)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("BOTTOMLEFT", bar, 0, 0)
		else
			local previous = _G[btn .. i - 1]

			if orient == "HORIZONTAL" then
				if rows == 1 then
					button:SetPoint("LEFT", previous, "RIGHT", spacing, 0)
				else
					button:SetPoint("TOPLEFT", previous, "TOPRIGHT", pad, 0)
					if i == first_row_num + 1 then
						button:SetPoint("TOPLEFT", _G[btn .. (i - first_row_num)], "BOTTOMLEFT", 0, -pad)
					end
					if i == first_row_num * 2 + 1 then
						button:SetPoint("TOPLEFT", _G[btn .. (i - first_row_num)], "BOTTOMLEFT", 0, -pad)
					end
				end
			else
				if rows == 1 then
					button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, pad)
				else
					button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, pad)
					if i == first_row_num + 1 then
						button:SetPoint("BOTTOMLEFT", _G[btn .. (i - first_row_num)], "BOTTOMRIGHT", pad, 0)
					end
					if i == first_row_num * 2 + 1 then
						button:SetPoint("BOTTOMLEFT", _G[btn .. (i - first_row_num)], "BOTTOMRIGHT", pad, 0)
					end
				end
			end
			if i > visnum then
				button:SetParent(DeathStar)
			end
		end
	end
	if orient == "HORIZONTAL" then
		if rows == 1 then
			bar:SetWidth(bsize * visnum + pad * (visnum - 1))
			bar:SetHeight(bsize)
		else
			bar:SetWidth(bsize * first_row_num + pad * (first_row_num - 1))
			bar:SetHeight(bsize * rows + pad)
		end
	else
		if rows == 1 then
			bar:SetWidth(bsize)
			bar:SetHeight(bsize * visnum + pad * (visnum - 1))
		else
			bar:SetWidth(bsize * rows + pad)
			bar:SetHeight(bsize * first_row_num + pad * (first_row_num - 1))
		end
	end
end

-- modified styling function for Extra Action Bar
mAB.SetExtraBar = function(bar, bname, orient, rows, visnum, bsize, spacing)
	local pad = spacing or cfg.spacing
	local first_row_num = math.floor(visnum / rows)
	for i = 13, 24 do
		local btn = CreateFrame("CheckButton", bname .. (i - 12), UIParent, "ActionBarButtonTemplate")
		btn:SetAttribute("action", i)
		btn:SetID(i)

		--btn:SetAttribute("showgrid", 1)
		--btn:SetAttribute("statehidden", nil)
		--btn:ClearAllPoints()
		btn:SetSize(bsize, bsize)
		btn:SetParent(bar)
		if i == 13 then
			btn:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		else
			if orient == "HORIZONTAL" then
				if rows == 1 then
					btn:SetPoint("TOPLEFT", _G[bname .. (i - 13)], "TOPRIGHT", pad, 0)
				else
					btn:SetPoint("TOPLEFT", _G[bname .. (i - 13)], "TOPRIGHT", pad, 0)
					if i == 12 + first_row_num + 1 then
						btn:SetPoint("TOPLEFT", _G[bname .. (i - first_row_num - 12)], "BOTTOMLEFT", 0, -pad)
					end
					if i == 12 + first_row_num * 2 + 1 then
						btn:SetPoint("TOPLEFT", _G[bname .. (i - first_row_num - 12)], "BOTTOMLEFT", 0, -pad)
					end
				end
			else
				if rows == 1 then
					btn:SetPoint("TOPLEFT", _G[bname .. (i - 13)], "BOTTOMLEFT", 0, -pad)
				else
					btn:SetPoint("TOPLEFT", _G[bname .. (i - 13)], "BOTTOMLEFT", 0, -pad)
					if i == 12 + first_row_num + 1 then
						btn:SetPoint("TOPLEFT", _G[bname .. (i - first_row_num - 12)], "TOPRIGHT", pad, 0)
					end
					if i == 12 + first_row_num * 2 + 1 then
						btn:SetPoint("TOPLEFT", _G[bname .. (i - first_row_num - 12)], "TOPRIGHT", pad, 0)
					end
				end
			end
			if i > visnum + 12 then
				btn:SetParent(DeathStar)
			end
		end
	end
	if orient == "HORIZONTAL" then
		if rows == 1 then
			bar:SetWidth(bsize * visnum + pad * (visnum - 1))
			bar:SetHeight(bsize)
		else
			bar:SetWidth(bsize * first_row_num + pad * (first_row_num - 1))
			bar:SetHeight(bsize * rows + pad)
		end
	else
		if rows == 1 then
			bar:SetWidth(bsize)
			bar:SetHeight(bsize * visnum + pad * (visnum - 1))
		else
			bar:SetWidth(bsize * rows + pad)
			bar:SetHeight(bsize * first_row_num + pad * (first_row_num - 1))
		end
	end
end

-- mouseover visibility condition
mAB.SetBarAlpha = function(bar, button, num, cfgn)
	local switch, baralpha, fadealpha = cfg.bars[cfgn].show_on_mouseover, cfg.bars[cfgn].bar_alpha, cfg.bars[cfgn].fadeout_alpha
	if switch then
		local function lighton(alpha)
			if bar and bar:IsShown() then
				for i = 1, num do
					local pb = _G[button .. i]
					pb:SetAlpha(alpha)
				end
			end
		end

		bar:EnableMouse(true)
		bar:SetScript("OnEnter", function(self) lighton(1) end)
		bar:SetScript("OnLeave", function(self) lighton(fadealpha or 0) end)
		for i = 1, num do
			local pb = _G[button .. i]
			pb:SetAlpha(fadealpha or 0)
			pb:HookScript("OnEnter", function(self) lighton(1) end)
			pb:HookScript("OnLeave", function(self) lighton(fadealpha or 0) end)
		end
	end
	bar:SetAlpha(baralpha or 1)
end

-- visibility condition
mAB.SetVisibility = function(n, bar)
	local ncfg = cfg.bars[n]
	if ncfg.hide_bar then
		bar:Hide()
	elseif ncfg.custom_visibility_macro then
		RegisterStateDriver(bar, "visibility", ncfg.custom_visibility_macro)
		return
	elseif ncfg.show_in_combat then
		if n == "Bar1" then
			RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists]hide;[combat,novehicleui] show;hide")
			--RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists]hide; show")
		else
			RegisterStateDriver(bar, "visibility", "[petbattle]hide;[combat] show; hide")
		end
	else
		if n == "Bar1" then
			RegisterStateDriver(bar, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists]hide;show")
		else
			RegisterStateDriver(bar, "visibility", "[petbattle]hide;show")
		end
	end
end

mAB.SetStanceBar = function(bar, btn, num)
	local orient, rows, visnum, bsize, spacing = cfg.bars["StanceBar"].orientation, cfg.bars["StanceBar"].rows, cfg.bars["StanceBar"].buttons, cfg.bars["StanceBar"].button_size, cfg.bars["StanceBar"].button_spacing
	local buttonList = {}
	local pad = spacing or cfg.spacing
	if orient == "HORIZONTAL" then
		bar:SetWidth(bsize * visnum + pad * (visnum - 1))
		bar:SetHeight(bsize)
	else
		bar:SetWidth(bsize)
		bar:SetHeight(bsize * visnum + pad * (visnum - 1))
	end

	for i = 1, num do
		local button = _G[btn .. i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetSize(bsize, bsize)
		button:ClearAllPoints()
		if orient == "HORIZONTAL" then
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", bar, 0, 0)
			else
				local previous = _G[btn .. i - 1]
				button:SetPoint("LEFT", previous, "RIGHT", spacing, 0)
			end
		else
			if i == 1 then
				--button:SetPoint("BOTTOMLEFT", bar, spacing, spacing)
				button:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
			else
				local previous = _G[btn .. i - 1]
				--button:SetPoint("LEFT", previous, "RIGHT", spacing, 0)
				button:SetPoint("TOPLEFT", _G[btn .. (i - 1)], "BOTTOMLEFT", 0, -pad)
			end
		end
	end
end

ns.mAB = mAB


-------------------------------------------------------------- LIB END ----------------------------

local addon, ns = ...
local cfg = ns.cfg
local mAB = ns.mAB

local myclass = select(2, UnitClass("player"))

--if not cfg.enable_action_bars then return end
if IsAddOnLoaded("Dominos") then return end

-- enabling default action bars
local f = CreateFrame "Frame"
f:RegisterEvent("PLAYER_ENTERING_WORLD")
--f:RegisterEvent("VARIABLES_LOADED")
f:SetScript("OnEvent", function()
	if InCombatLockdown() then return end
	local ab1, ab2, ab3, ab4 = GetActionBarToggles()
	if (not ab1 or not ab2 or not ab3 or not ab4) then
		SetActionBarToggles(1, 1, 1, 1)
		StaticPopupDialogs.SET_AB = {
			text = "gempUI is almost finished installing. Click 'Accept' for a quick UI reload and to finish the installation.",
			button1 = ACCEPT,
			button2 = CANCEL,
			OnAccept = function()
				SetCVar("uiScale", 768 / string.match(({ GetScreenResolutions() })[GetCurrentResolution()], "%d+x(%d+)"))
				ReloadUI()
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = true,
			preferredIndex = 5,
		}
		StaticPopup_Show("SET_AB")
	end
	-- show grid
	for i = 1, 12 do
		local btn = _G[format("ActionButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		ActionButton_ShowGrid(btn)

		btn = _G[format("MultiBarRightButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		ActionButton_ShowGrid(btn)

		btn = _G[format("MultiBarBottomRightButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		ActionButton_ShowGrid(btn)

		btn = _G[format("MultiBarLeftButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		ActionButton_ShowGrid(btn)

		btn = _G[format("MultiBarBottomLeftButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		ActionButton_ShowGrid(btn)

		btn = _G[format("ExtraBarButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		ActionButton_ShowGrid(btn)
	end
	--SHOW_MULTI_ACTIONBAR_1 = 1
	--SHOW_MULTI_ACTIONBAR_2 = 1
	--SHOW_MULTI_ACTIONBAR_3 = 1
	--SHOW_MULTI_ACTIONBAR_4 = 1
	--InterfaceOptions_UpdateMultiActionBars()
	--MultiActionBar_Update()
end)

--- - Modifying default action bars
-- Creating holder frames for each bar
local mainbar = mAB.CreateHolder("Bar1_holder", cfg.bars["Bar1"].position)
local overridebar = mAB.CreateHolder("OverrideBar_holder", cfg.bars["Bar1"].position)
local bottomleftbar = mAB.CreateHolder("Bar2_holder", cfg.bars["Bar2"].position)
local bottomrightbar = mAB.CreateHolder("Bar3_holder", cfg.bars["Bar3"].position)
leftbar = mAB.CreateHolder("Bar4_holder", cfg.bars["Bar4"].position)
rightbar = mAB.CreateHolder("Bar5_holder", cfg.bars["Bar5"].position)
local extrabar = mAB.CreateHolder("Bar6_holder", cfg.bars["Bar6"].position)
local stancebar = mAB.CreateHolder("StanceBar_holder", cfg.bars["StanceBar"].position)
local petbar = mAB.CreateHolder("PetBar_holder", { a = cfg.bars["PetBar"].position.a, x = cfg.bars["PetBar"].position.x * 1.25, y = cfg.bars["PetBar"].position.y * 1.25 })
local exitVehicle = mAB.CreateHolder("ExitVehicle_holder", cfg.bars["ExitVehicleButton"].position)
--local extrabtn = mAB.CreateHolder("ExtraBtn_holder", cfg.ExtraButton["Position"])

--- - Forging action bars
-- parenting action buttons to our holders
MainMenuBarArtFrame:SetParent(mainbar)
MultiBarBottomLeft:SetParent(bottomleftbar)
MultiBarBottomRight:SetParent(bottomrightbar)
MultiBarLeft:SetParent(leftbar)
MultiBarRight:SetParent(rightbar)
MultiBarRight:EnableMouse(false)
PetActionBarFrame:SetParent(petbar)
StanceBarFrame:SetParent(stancebar)
StanceBarFrame:SetPoint("BOTTOMLEFT", stancebar, -12, -3)
StanceBarFrame.ignoreFramePositionManager = true

-- set up action bars
mAB.SetBar(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "Bar1")
mAB.SetBar(overridebar, "OverrideActionBarButton", NUM_ACTIONBAR_BUTTONS, "Bar1")
RegisterStateDriver(overridebar, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
mAB.SetBar(bottomleftbar, "MultiBarBottomLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar2")
mAB.SetBar(bottomrightbar, "MultiBarBottomRightButton", NUM_ACTIONBAR_BUTTONS, "Bar3")
mAB.SetBar(leftbar, "MultiBarLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar4")
mAB.SetBar(rightbar, "MultiBarRightButton", NUM_ACTIONBAR_BUTTONS, "Bar5")
mAB.SetBar(petbar, "PetActionButton", NUM_PET_ACTION_SLOTS, "PetBar")
petbar:SetScale(cfg.bars["PetBar"].scale or 0.80)
RegisterStateDriver(petbar, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
mAB.SetStanceBar(stancebar, "StanceButton", NUM_STANCE_SLOTS)
mAB.SetExtraBar(extrabar, "ExtraBarButton", cfg.bars["Bar6"].orientation, cfg.bars["Bar6"].rows, cfg.bars["Bar6"].buttons, cfg.bars["Bar6"].button_size, cfg.bars["Bar6"].button_spacing)
-- due to new ActionBarController introduced in WoW 5.0 we have to update the extra bar independently and lock it to page 1
extrabar:RegisterEvent("PLAYER_LOGIN")
extrabar:SetScript("OnEvent", function(self, event, ...)
	for id = 1, NUM_ACTIONBAR_BUTTONS do
		local name = "ExtraBarButton" .. id
		self:SetFrameRef(name, _G[name])
	end
	self:Execute(([[
			buttons = table.new()
			for id = 1, %s do
				buttons[id] = self:GetFrameRef("ExtraBarButton"..id)
			end
		]]):format(NUM_ACTIONBAR_BUTTONS))
	self:SetAttribute('_onstate-page', ([[
			if not newstate then return end
			for id = 1, %s do
				buttons[id]:SetAttribute("actionpage", 1)
			end
		]]):format(NUM_ACTIONBAR_BUTTONS))
	RegisterStateDriver(self, "page", 1)
end)

-- apply alpha and mouseover functionality
mAB.SetBarAlpha(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "Bar1")
mAB.SetBarAlpha(bottomleftbar, "MultiBarBottomLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar2")
mAB.SetBarAlpha(bottomrightbar, "MultiBarBottomRightButton", NUM_ACTIONBAR_BUTTONS, "Bar3")
mAB.SetBarAlpha(leftbar, "MultiBarLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar4")
mAB.SetBarAlpha(rightbar, "MultiBarRightButton", NUM_ACTIONBAR_BUTTONS, "Bar5")
mAB.SetBarAlpha(extrabar, "ExtraBarButton", NUM_ACTIONBAR_BUTTONS, "Bar6")
mAB.SetBarAlpha(stancebar, "StanceButton", NUM_STANCE_SLOTS, "StanceBar")
mAB.SetBarAlpha(petbar, "PetActionButton", NUM_PET_ACTION_SLOTS, "PetBar")

-- apply visibility conditions
mAB.SetVisibility("Bar1", mainbar)
mAB.SetVisibility("Bar2", bottomleftbar)
mAB.SetVisibility("Bar3", bottomrightbar)
mAB.SetVisibility("Bar4", leftbar)
mAB.SetVisibility("Bar5", rightbar)
mAB.SetVisibility("Bar6", extrabar)
mAB.SetVisibility("StanceBar", stancebar)
mAB.SetVisibility("PetBar", petbar)


-- hiding default frames and textures
local FramesToHide = {
	MainMenuBar,
	--MainMenuBarArtFrame, 
	MainMenuBarArtFrameBackground, 
	MainMenuBarArtFrame.RightEndCap, 
	MainMenuBarArtFrame.LeftEndCap, 
	MainMenuBarArtFrame.PageNumber, 
	MainMenuBarPageNumber,
	ActionBarDownButton,
	ActionBarUpButton,
	OverrideActionBarExpBar,
	OverrideActionBarHealthBar,
	OverrideActionBarPowerBar,
	OverrideActionBarPitchFrame,
	OverrideActionBarLeaveFrameLeaveButton,
	--BonusActionBarFrame, 
	--PossessBarFrame
	MainMenuBarBackpackButton,
	StanceBarLeft,
	StanceBarMiddle,
	StanceBarRight,
	SlidingActionBarTexture0,
	SlidingActionBarTexture1,
	PossessBackground1,
	PossessBackground2,
	MainMenuBarTexture0,
	MainMenuBarTexture1,
	MainMenuBarTexture2,
	MainMenuBarTexture3,
	MainMenuBarLeftEndCap,
	MainMenuBarRightEndCap,
}
local frameHider = CreateFrame("Frame", nil)
frameHider:Hide()
for _, f in pairs(FramesToHide) do
	if f:GetObjectType() == "Texture" then
		--f:UnregisterAllEvents()
		f:SetTexture(nil)
	else
		f:SetParent(frameHider)
	end
end

-- MicroMenu


local MicroMenu = mAB.CreateHolder("MicroMenu_holder", { a = cfg.bars["MicroMenu"].position.a, x = cfg.bars["MicroMenu"].position.x * (2 - cfg.bars["MicroMenu"].scale), y = cfg.bars["MicroMenu"].position.y * (2 - cfg.bars["MicroMenu"].scale) })
MicroMenu:SetSize(305, 40)
MicroMenu:SetScale(cfg.bars["MicroMenu"].scale)
local MICRO_BUTTONS = MICRO_BUTTONS
local MicroButtons = {}
-- check the MICRO_BUTTONS table
for _, buttonName in pairs(MICRO_BUTTONS) do
	local button = _G[buttonName]
	if button then
		tinsert(MicroButtons, button)
	end
end
local SetMicroButtons = function()
	for _, b in pairs(MicroButtons) do
		b:SetParent(MicroMenu)
	end
	CharacterMicroButton:ClearAllPoints();
	CharacterMicroButton:SetPoint("BOTTOMLEFT", 0, 0)
end
SetMicroButtons()
-- gotta run this function each time we respec so we don't loose our micromenu bar
-- seems to be fixed in WoW5.0
--[[ MicroMenu:RegisterEvent("PLAYER_TALENT_UPDATE")
MicroMenu:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
MicroMenu:SetScript("OnEvent", function(self,event) 
      if  not InCombatLockdown() and (event == "PLAYER_TALENT_UPDATE" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
          SetMicroButtons()
      end
end) ]]
-- micro menu on mouseover
if cfg.bars["MicroMenu"].show_on_mouseover then
	local switcher = -1
	local function mmalpha(alpha)
		for _, f in pairs(MicroButtons) do
			f:SetAlpha(alpha)
			switcher = alpha
		end
	end

	MicroMenu:EnableMouse(true)
	MicroMenu:SetScript("OnEnter", function(self) mmalpha(1) end)
	MicroMenu:SetScript("OnLeave", function(self) mmalpha(0) end)
	for _, f in pairs(MicroButtons) do
		f:SetAlpha(0)
		f:HookScript("OnEnter", function(self) mmalpha(1) end)
		f:HookScript("OnLeave", function(self) mmalpha(0) end)
	end
	MicroMenu:SetScript("OnEvent", function(self)
		mmalpha(0)
	end)
	MicroMenu:RegisterEvent("PLAYER_ENTERING_WORLD")
	--fix for the talent button display while micromenu onmouseover
	local function TalentSwitchAlphaFix(self, alpha)
		if switcher ~= alpha then
			switcher = 0
			self:SetAlpha(0)
		end
		SetMicroButtons()
	end

	hooksecurefunc(TalentMicroButton, "SetAlpha", TalentSwitchAlphaFix)
end
if cfg.bars["MicroMenu"].hide_bar then MicroMenu:Hide() end
if cfg.bars["MicroMenu"].lock_to_CharacterFrame then
	MicroMenu:SetParent(PaperDollFrame)
	MicroMenu:SetPoint("BOTTOMLEFT", PaperDollFrame, "TOPLEFT", 65, 2)
end

-- hiding extra bars
local bars_visible = false
-- making this global function to hook in my broker toggler
m_ActionBars_Toggle_Extra_Bars = function()
	if InCombatLockdown() then return print("m_ActionBars: You can't toggle bars while in combat!") end
	if bars_visible then
		if cfg.bars["Bar1"].hide_bar then mainbar:Hide() end
		if cfg.bars["Bar2"].hide_bar then bottomleftbar:Hide() end
		if cfg.bars["Bar3"].hide_bar then bottomrightbar:Hide() end
		if cfg.bars["Bar4"].hide_bar then leftbar:Hide() end
		if cfg.bars["Bar5"].hide_bar then rightbar:Hide() end
		if cfg.bars["Bar6"].hide_bar then extrabar:Hide() end
		if cfg.bars["StanceBar"].hide_bar then stancebar:Hide() end
		if cfg.bars["MicroMenu"].hide_bar then MicroMenu:Hide() end
		if WorldMarkerBar_holder and cfg.bars["RaidIconBar"].hide_bar then WorldMarkerBar_holder:Hide() end
		if RaidIconBar_holder and cfg.bars["WorldMarkerBar"].hide_bar then RaidIconBar_holder:Hide() end
		bars_visible = false
	else
		if cfg.bars["Bar1"].hide_bar then mainbar:Show() end
		if cfg.bars["Bar2"].hide_bar then bottomleftbar:Show() end
		if cfg.bars["Bar3"].hide_bar then bottomrightbar:Show() end
		if cfg.bars["Bar4"].hide_bar then leftbar:Show() end
		if cfg.bars["Bar5"].hide_bar then rightbar:Show() end
		if cfg.bars["Bar6"].hide_bar then extrabar:Show() end
		if cfg.bars["StanceBar"].hide_bar then stancebar:Show() end
		if cfg.bars["MicroMenu"].hide_bar then MicroMenu:Show() end
		if WorldMarkerBar_holder and cfg.bars["RaidIconBar"].hide_bar then WorldMarkerBar_holder:Show() end
		if RaidIconBar_holder and cfg.bars["WorldMarkerBar"].hide_bar then RaidIconBar_holder:Show() end
		bars_visible = true
	end
end

-- and making slash command to show them
SlashCmdList["EXTRA"] = function() m_ActionBars_Toggle_Extra_Bars() end
SLASH_EXTRA1 = "/extra"
SLASH_EXTRA2 = "/eb"

-- adding testmode to make bar positioning easier
local testmodeON
m_ActionBars_Toggle_Test_Mode = function()
	local def_back = "interface\\Tooltips\\UI-Tooltip-Background"
	local backdrop_tab = {
		bgFile = def_back,
		edgeFile = nil,
		tile = false,
		tileSize = 0,
		edgeSize = 5,
		insets = { left = 0, right = 0, top = 0, bottom = 0, },
	}
	local ShowHolder = function(holder, switch)
		if not _G[holder:GetName() .. "_overlay"] then
			local f = CreateFrame("Frame", holder:GetName() .. "_overlay")
			f:SetAllPoints(holder)
			f:SetBackdrop(backdrop_tab);
			f:SetBackdropColor(.1, .1, .2, .8)
			f:SetFrameStrata("HIGH")
			local name = f:CreateFontString(nil)
			name:SetFont("Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf", 8)
			name:SetText(holder:GetName())
			name:SetPoint("BOTTOMLEFT", f, "TOPLEFT")
		end

		if switch then
			_G[holder:GetName() .. "_overlay"]:Show()
		else
			_G[holder:GetName() .. "_overlay"]:Hide()
		end
	end
	if testmodeON then
		testmodeON = false
	else
		testmodeON = true
	end
	local holders = {
		Bar1_holder,
		Bar2_holder,
		Bar3_holder,
		Bar4_holder,
		Bar5_holder,
		StanceBar_holder,
		PetBar_holder,
		MicroMenu_holder,
		RaidIconBar_holder,
		WorldMarkerBar_holder,
		ExitVehicle_holder,
		Bar6_holder,
		ExtraBtn_holder
	}
	for _, f in pairs(holders) do
		ShowHolder(f, testmodeON)
	end
end
SlashCmdList["TESTMODE"] = function() m_ActionBars_Toggle_Test_Mode() end
SLASH_TESTMODE1 = "/mab"

------------------------------------ ActionBars.lua end ------------------------------------------

local bind, localmacros = CreateFrame("Frame", "ncHoverBind", UIParent), 0
-- SLASH COMMAND
SlashCmdList.MOUSEOVERBIND = function()
	if InCombatLockdown() then print("You can't bind keys in combat.") return end
	if not bind.loaded then
		local find = string.find
		local _G = getfenv(0)

		bind:SetFrameStrata("DIALOG")
		bind:EnableMouse(true)
		bind:EnableKeyboard(true)
		bind:EnableMouseWheel(true)
		bind.texture = bind:CreateTexture()
		bind.texture:SetAllPoints(bind)
		bind.texture:SetTexture(0, 0, 0, .25)
		bind:Hide()

		local elapsed = 0
		GameTooltip:HookScript("OnUpdate", function(self, e)
			elapsed = elapsed + e
			if elapsed < .2 then return else elapsed = 0 end
			if (not self.comparing and IsModifiedClick("COMPAREITEMS")) then
				GameTooltip_ShowCompareItem(self)
				self.comparing = true
			elseif (self.comparing and not IsModifiedClick("COMPAREITEMS")) then
				for _, frame in pairs(self.shoppingTooltips) do
					frame:Hide()
				end
				self.comparing = false
			end
		end)
		hooksecurefunc(GameTooltip, "Hide", function(self) for _, tt in pairs(self.shoppingTooltips) do tt:Hide() end end)

		bind:SetScript("OnEvent", function(self) self:Deactivate(false) end)
		bind:SetScript("OnLeave", function(self) self:HideFrame() end)
		bind:SetScript("OnKeyUp", function(self, key) self:Listener(key) end)
		bind:SetScript("OnMouseUp", function(self, key) self:Listener(key) end)
		bind:SetScript("OnMouseWheel", function(self, delta) if delta > 0 then self:Listener("MOUSEWHEELUP") else self:Listener("MOUSEWHEELDOWN") end end)

		function bind:Update(b, spellmacro)
			if not self.enabled or InCombatLockdown() then return end
			self.button = b
			self.spellmacro = spellmacro

			self:ClearAllPoints()
			self:SetAllPoints(b)
			self:Show()

			ShoppingTooltip1:Hide()

			if spellmacro == "SPELL" then
				self.button.id = SpellBook_GetSpellBookSlot(self.button)
				self.button.name = GetSpellBookItemName(self.button.id, SpellBookFrame.bookType)

				GameTooltip:AddLine("Trigger")
				GameTooltip:Show()
				GameTooltip:SetScript("OnHide", function(self)
					self:SetOwner(bind, "ANCHOR_NONE")
					self:SetPoint("BOTTOM", bind, "TOP", 0, 1)
					self:AddLine(bind.button.name, 1, 1, 1)
					bind.button.bindings = { GetBindingKey(spellmacro .. " " .. bind.button.name) }
					if #bind.button.bindings == 0 then
						self:AddLine("No bindings set.", .6, .6, .6)
					else
						self:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
						for i = 1, #bind.button.bindings do
							self:AddDoubleLine(i, bind.button.bindings[i])
						end
					end
					self:Show()
					self:SetScript("OnHide", nil)
				end)
			elseif spellmacro == "MACRO" then
				self.button.id = self.button:GetID()

				if localmacros == 1 then self.button.id = self.button.id + 36 end

				self.button.name = GetMacroInfo(self.button.id)

				GameTooltip:SetOwner(bind, "ANCHOR_NONE")
				GameTooltip:SetPoint("BOTTOM", bind, "TOP", 0, 1)
				GameTooltip:AddLine(bind.button.name, 1, 1, 1)

				bind.button.bindings = { GetBindingKey(spellmacro .. " " .. bind.button.name) }
				if #bind.button.bindings == 0 then
					GameTooltip:AddLine("No bindings set.", .6, .6, .6)
				else
					GameTooltip:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
					for i = 1, #bind.button.bindings do
						GameTooltip:AddDoubleLine("Binding" .. i, bind.button.bindings[i], 1, 1, 1)
					end
				end
				GameTooltip:Show()
			elseif spellmacro == "STANCE" or spellmacro == "PET" then
				self.button.id = tonumber(b:GetID())
				self.button.name = b:GetName()

				if not self.button.name then return end

				if not self.button.id or self.button.id < 1 or self.button.id > (spellmacro == "STANCE" and 10 or 12) then
					self.button.bindstring = "CLICK " .. self.button.name .. ":LeftButton"
				else
					self.button.bindstring = (spellmacro == "STANCE" and "SHAPESHIFTBUTTON" or "BONUSACTIONBUTTON") .. self.button.id
				end

				GameTooltip:AddLine("Trigger")
				GameTooltip:Show()
				GameTooltip:SetScript("OnHide", function(self)
					self:SetOwner(bind, "ANCHOR_NONE")
					self:SetPoint("BOTTOM", bind, "TOP", 0, 1)
					self:AddLine(bind.button.name, 1, 1, 1)
					bind.button.bindings = { GetBindingKey(bind.button.bindstring) }
					if #bind.button.bindings == 0 then
						self:AddLine("No bindings set.", .6, .6, .6)
					else
						self:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
						for i = 1, #bind.button.bindings do
							self:AddDoubleLine(i, bind.button.bindings[i])
						end
					end
					self:Show()
					self:SetScript("OnHide", nil)
				end)
			else
				self.button.action = tonumber(b.action)
				self.button.name = b:GetName()

				if not self.button.name then return end

				if not self.button.action or self.button.action < 1 or self.button.action > 132 then
					self.button.bindstring = "CLICK " .. self.button.name .. ":LeftButton"
				else
					local modact = 1 + (self.button.action - 1) % 12
					if self.button.action < 25 or self.button.action > 72 then
						self.button.bindstring = "ACTIONBUTTON" .. modact
					elseif self.button.action < 73 and self.button.action > 60 then
						self.button.bindstring = "MULTIACTIONBAR1BUTTON" .. modact
					elseif self.button.action < 61 and self.button.action > 48 then
						self.button.bindstring = "MULTIACTIONBAR2BUTTON" .. modact
					elseif self.button.action < 49 and self.button.action > 36 then
						self.button.bindstring = "MULTIACTIONBAR4BUTTON" .. modact
					elseif self.button.action < 37 and self.button.action > 24 then
						self.button.bindstring = "MULTIACTIONBAR3BUTTON" .. modact
					end
				end

				GameTooltip:AddLine("Trigger")
				GameTooltip:Show()
				GameTooltip:SetScript("OnHide", function(self)
					self:SetOwner(bind, "ANCHOR_NONE")
					self:SetPoint("BOTTOM", bind, "TOP", 0, 1)
					self:AddLine(bind.button.name, 1, 1, 1)
					bind.button.bindings = { GetBindingKey(bind.button.bindstring) }
					if #bind.button.bindings == 0 then
						self:AddLine("No bindings set.", .6, .6, .6)
					else
						self:AddDoubleLine("Binding", "Key", .6, .6, .6, .6, .6, .6)
						for i = 1, #bind.button.bindings do
							self:AddDoubleLine(i, bind.button.bindings[i])
						end
					end
					self:Show()
					self:SetScript("OnHide", nil)
				end)
			end
		end

		function bind:Listener(key)
			if key == "ESCAPE" or key == "RightButton" then
				for i = 1, #self.button.bindings do
					SetBinding(self.button.bindings[i])
				end
				print("All keybindings cleared for |cff00ff00" .. self.button.name .. "|r.")
				self:Update(self.button, self.spellmacro)
				if self.spellmacro ~= "MACRO" then GameTooltip:Hide() end
				return
			end

			if key == "LSHIFT"
					or key == "RSHIFT"
					or key == "LCTRL"
					or key == "RCTRL"
					or key == "LALT"
					or key == "RALT"
					or key == "UNKNOWN"
					or key == "LeftButton"
					or key == "MiddleButton" then return
			end


			if key == "Button4" then key = "BUTTON4" end
			if key == "Button5" then key = "BUTTON5" end

			local alt = IsAltKeyDown() and "ALT-" or ""
			local ctrl = IsControlKeyDown() and "CTRL-" or ""
			local shift = IsShiftKeyDown() and "SHIFT-" or ""

			if not self.spellmacro or self.spellmacro == "PET" or self.spellmacro == "STANCE" then
				SetBinding(alt .. ctrl .. shift .. key, self.button.bindstring)
			else
				SetBinding(alt .. ctrl .. shift .. key, self.spellmacro .. " " .. self.button.name)
			end
			print(alt .. ctrl .. shift .. key .. " |cff00ff00bound to |r" .. self.button.name .. ".")
			self:Update(self.button, self.spellmacro)
			if self.spellmacro ~= "MACRO" then GameTooltip:Hide() end
		end

		function bind:HideFrame()
			self:ClearAllPoints()
			self:Hide()
			GameTooltip:Hide()
		end

		function bind:Activate()
			self.enabled = true
			self:RegisterEvent("PLAYER_REGEN_DISABLED")
		end

		function bind:Deactivate(save)
			if save then
				SaveBindings(2)
				print("All keybindings have been saved.")
			else
				LoadBindings(2)
				print("All newly set keybindings have been discarded.")
			end
			self.enabled = false
			self:HideFrame()
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
			StaticPopup_Hide("KEYBIND_MODE")
		end

		StaticPopupDialogs["KEYBIND_MODE"] = {
			text = "Hover your mouse over any actionbutton to bind it. Press the escape key or right click to clear the current actionbutton's keybinding.",
			button1 = "Save bindings",
			button2 = "Discard bindings",
			OnAccept = function() bind:Deactivate(true) end,
			OnCancel = function() bind:Deactivate(false) end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = false
		}

		-- REGISTERING
		local stance = StanceButton1:GetScript("OnClick")
		local pet = PetActionButton1:GetScript("OnClick")
		--		local button = SecureActionButton_OnClick
		local button = ActionButton1:GetScript("OnClick")

		local function register(val)
			if val.IsProtected and val.GetObjectType and val.GetScript and val:GetObjectType() == "CheckButton" and val:IsProtected() then
				local script = val:GetScript("OnClick")
				if script == button then
					val:HookScript("OnEnter", function(self) bind:Update(self) end)
				elseif script == stance then
					val:HookScript("OnEnter", function(self) bind:Update(self, "STANCE") end)
				elseif script == pet then
					val:HookScript("OnEnter", function(self) bind:Update(self, "PET") end)
				end
			end
		end

		local val = EnumerateFrames()
		while val do
			register(val)
			val = EnumerateFrames(val)
		end

		for i = 1, 12 do
			local sb = _G["SpellButton" .. i]
			sb:HookScript("OnEnter", function(self) bind:Update(self, "SPELL") end)
		end

		local function registermacro()
			for i = 1, 36 do
				local mb = _G["MacroButton" .. i]
				mb:HookScript("OnEnter", function(self) bind:Update(self, "MACRO") end)
			end
			MacroFrameTab1:HookScript("OnMouseUp", function() localmacros = 0 end)
			MacroFrameTab2:HookScript("OnMouseUp", function() localmacros = 1 end)
		end

		if not IsAddOnLoaded("Blizzard_MacroUI") then
			hooksecurefunc("LoadAddOn", function(addon)
				if addon == "Blizzard_MacroUI" then
					registermacro()
				end
			end)
		else
			registermacro()
		end
		bind.loaded = 1
	end
	if not bind.enabled then
		bind:Activate()
		StaticPopup_Show("KEYBIND_MODE")
	end
end

SLASH_MOUSEOVERBIND1 = "/hb"

--------------------------------------- HOVERBIND END --------------------------------------------


--[[
	tullaRange
		Adds out of range coloring to action buttons
		Derived from RedRange with negligable improvements to CPU usage
--]]

--locals and speed
local _G = _G
local UPDATE_DELAY = 0.15
local ATTACK_BUTTON_FLASH_TIME = _G['ATTACK_BUTTON_FLASH_TIME']
local SPELL_POWER_HOLY_POWER = _G['SPELL_POWER_HOLY_POWER']
local ActionButton_GetPagedID = _G['ActionButton_GetPagedID']
local ActionButton_IsFlashing = _G['ActionButton_IsFlashing']
local ActionHasRange = _G['ActionHasRange']
local IsActionInRange = _G['IsActionInRange']
local IsUsableAction = _G['IsUsableAction']
local HasAction = _G['HasAction']


--code for handling defaults
local function removeDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(tbl[k]) == 'table' and type(v) == 'table' then
			removeDefaults(tbl[k], v)
			if next(tbl[k]) == nil then
				tbl[k] = nil
			end
		elseif tbl[k] == v then
			tbl[k] = nil
		end
	end
	return tbl
end

local function copyDefaults(tbl, defaults)
	for k, v in pairs(defaults) do
		if type(v) == 'table' then
			tbl[k] = copyDefaults(tbl[k] or {}, v)
		elseif tbl[k] == nil then
			tbl[k] = v
		end
	end
	return tbl
end

local function timer_Create(parent, interval)
	local updater = parent:CreateAnimationGroup()
	updater:SetLooping('NONE')
	updater:SetScript('OnFinished', function(self)
		if parent:Update() then
			parent:Start(interval)
		end
	end)

	local a = updater:CreateAnimation('Animation'); a:SetOrder(1)

	parent.Start = function(self)
		self:Stop()
		a:SetDuration(interval)
		updater:Play()
		return self
	end

	parent.Stop = function(self)
		if updater:IsPlaying() then
			updater:Stop()
		end
		return self
	end

	parent.Active = function(self)
		return updater:IsPlaying()
	end

	return parent
end


--[[ The main thing ]] --

local tullaRange = timer_Create(CreateFrame('Frame', 'tullaRange'), UPDATE_DELAY)

function tullaRange:Load()
	self:SetScript('OnEvent', self.OnEvent)
	self:RegisterEvent('PLAYER_LOGIN')
	self:RegisterEvent('PLAYER_LOGOUT')
end


--[[ Frame Events ]] --

function tullaRange:OnEvent(event, ...)
	local action = self[event]
	if action then
		action(self, event, ...)
	end
end

--[[ Game Events ]] --

function tullaRange:PLAYER_LOGIN()
	if not TULLARANGE_COLORS then
		TULLARANGE_COLORS = {}
	end
	self.sets = copyDefaults(TULLARANGE_COLORS, self:GetDefaults())

	--add options loader
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn('tullaRange_Config')
	end)

	self.buttonsToUpdate = {}

	hooksecurefunc('ActionButton_OnUpdate', self.RegisterButton)
	hooksecurefunc('ActionButton_UpdateUsable', self.OnUpdateButtonUsable)
	hooksecurefunc('ActionButton_Update', self.OnButtonUpdate)
end

function tullaRange:PLAYER_LOGOUT()
	removeDefaults(TULLARANGE_COLORS, self:GetDefaults())
end


--[[ Actions ]] --

function tullaRange:Update()
	return self:UpdateButtons(UPDATE_DELAY)
end

function tullaRange:ForceColorUpdate()
	for button in pairs(self.buttonsToUpdate) do
		tullaRange.OnUpdateButtonUsable(button)
	end
end

function tullaRange:UpdateActive()
	if next(self.buttonsToUpdate) then
		if not self:Active() then
			self:Start()
		end
	else
		self:Stop()
	end
end

function tullaRange:UpdateButtons(elapsed)
	if next(self.buttonsToUpdate) then
		for button in pairs(self.buttonsToUpdate) do
			self:UpdateButton(button, elapsed)
		end
		return true
	end
	return false
end

function tullaRange:UpdateButton(button, elapsed)
	tullaRange.UpdateButtonUsable(button)
	tullaRange.UpdateFlash(button, elapsed)
end

function tullaRange:UpdateButtonStatus(button)
	local action = ActionButton_GetPagedID(button)
	if button:IsVisible() and action and HasAction(action) and ActionHasRange(action) then
		self.buttonsToUpdate[button] = true
	else
		self.buttonsToUpdate[button] = nil
	end
	self:UpdateActive()
end



--[[ Button Hooking ]] --

function tullaRange.RegisterButton(button)
	button:HookScript('OnShow', tullaRange.OnButtonShow)
	button:HookScript('OnHide', tullaRange.OnButtonHide)
	button:SetScript('OnUpdate', nil)

	tullaRange:UpdateButtonStatus(button)
end

function tullaRange.OnButtonShow(button)
	tullaRange:UpdateButtonStatus(button)
end

function tullaRange.OnButtonHide(button)
	tullaRange:UpdateButtonStatus(button)
end

function tullaRange.OnUpdateButtonUsable(button)
	button.tullaRangeColor = nil
	tullaRange.UpdateButtonUsable(button)
end

function tullaRange.OnButtonUpdate(button)
	tullaRange:UpdateButtonStatus(button)
end


--[[ Range Coloring ]] --

function tullaRange.UpdateButtonUsable(button)
	local action = ActionButton_GetPagedID(button)
	local isUsable, notEnoughMana = IsUsableAction(action)

	--usable
	if isUsable then
		--but out of range
		if IsActionInRange(action) == 0 then
			tullaRange.SetButtonColor(button, 'oor')
		else
			tullaRange.SetButtonColor(button, 'normal')
		end
		--out of mana
	elseif notEnoughMana then
		tullaRange.SetButtonColor(button, 'oom')
		--unusable
	else
		button.tullaRangeColor = 'unusuable'
	end
end

function tullaRange.SetButtonColor(button, colorType)
	if button.tullaRangeColor ~= colorType then
		button.tullaRangeColor = colorType

		local r, g, b = tullaRange:GetColor(colorType)
		button.icon:SetVertexColor(r, g, b)
	end
end

function tullaRange.UpdateFlash(button, elapsed)
	if ActionButton_IsFlashing(button) then
		local flashtime = button.flashtime - elapsed

		if flashtime <= 0 then
			local overtime = -flashtime
			if overtime >= ATTACK_BUTTON_FLASH_TIME then
				overtime = 0
			end
			flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

			local flashTexture = _G[button:GetName() .. 'Flash']
			if flashTexture:IsShown() then
				flashTexture:Hide()
			else
				flashTexture:Show()
			end
		end

		button.flashtime = flashtime
	end
end


--[[ Configuration ]] --

function tullaRange:GetDefaults()
	return {
		normal = { 1, 1, 1 },
		oor = { 1, 0.3, 0.1 },
		oom = { 0.1, 0.3, 1 }
	}
end

function tullaRange:Reset()
	TULLARANGE_COLORS = {}
	self.sets = copyDefaults(TULLARANGE_COLORS, self:GetDefaults())

	self:ForceColorUpdate()
end

function tullaRange:SetColor(index, r, g, b)
	local color = self.sets[index]
	color[1] = r
	color[2] = g
	color[3] = b

	self:ForceColorUpdate()
end

function tullaRange:GetColor(index)
	local color = self.sets[index]
	return color[1], color[2], color[3]
end

--[[ Load The Thing ]] --

tullaRange:Load()

------------------ TULLA RANGE END ------------------------------