local addon, ns = ...
local cfg = CreateFrame("Frame")
local F, G = unpack(select(2, ...))
--ActionBars config
cfg.mAB = {
	size = 42, -- setting up default buttons size
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
		buttons = 7,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "BOTTOM", x = 0, y = 136 },
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
		buttons = 7,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "BOTTOM", x = 0, y = 92 },
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
		buttons = 7,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "BOTTOM", x = 0, y = 48 },
		custom_visibility_macro = false
	},
	["Bar4"] = {
		hide_bar = false,
		show_in_combat = false,
		show_on_mouseover = false,
		bar_alpha = 1,
		fadeout_alpha = 0.0,
		orientation = "HORIZONTAL",
		rows = 1,
		buttons = 7,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "BOTTOM", x = 0, y = 4 },
		custom_visibility_macro = false
	},
	["Bar5"] = {
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
		scale = 0.9,
		show_on_mouseover = false,
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
		position = { a = "CENTER", x = 0, y = 0 },
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
		position = { a = "BOTTOM", x = 200, y = 4 },
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
local mAB = CreateFrame("Frame", "gempActionBars", G.frame)

--- - Addon functions
local myclass = select(2, UnitClass("player"))

-- holder creating func
mAB.CreateHolder = function(name, pos)
	local bar = CreateFrame("Frame", name, G.frame, "SecureHandlerStateTemplate")
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
		local btn = CreateFrame("CheckButton", bname .. (i - 12), G.frame, "ActionBarButtonTemplate")
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
	end
	-- show grid
	for i = 1, 12 do
		local btn = _G[format("ActionButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarRightButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarBottomRightButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarLeftButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("MultiBarBottomLeftButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)

		btn = _G[format("ExtraBarButton%d", i)]
		btn:SetAttribute("showgrid", 1)
		btn:SetAttribute("statehidden", nil)
		btn:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_CVAR)
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
OverrideActionBar:SetParent(overridebar)
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil)
MultiBarBottomLeft:SetParent(bottomleftbar)
MultiBarBottomRight:SetParent(bottomrightbar)
MultiBarLeft:SetParent(leftbar)
MultiBarRight:SetParent(rightbar)
MultiBarRight:EnableMouse(false)
PetActionBarFrame:SetParent(petbar)
PossessBarFrame:SetParent(stancebar)
PossessBarFrame:EnableMouse(false)
StanceBarFrame:SetParent(stancebar)
StanceBarFrame:SetPoint("BOTTOMLEFT", stancebar, -12, -3)
StanceBarFrame.ignoreFramePositionManager = true

-- set up action bars
mAB.SetBar(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "Bar1")
mAB.SetBar(overridebar, "OverrideActionBarButton", NUM_ACTIONBAR_BUTTONS, "Bar1")
RegisterStateDriver(overridebar, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
mAB.SetBar(bottomleftbar, "MultiBarBottomLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar2")
mAB.SetBar(bottomrightbar, "MultiBarBottomRightButton", NUM_ACTIONBAR_BUTTONS, "Bar3")
mAB.SetBar(leftbar, "MultiBarLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar4")
mAB.SetBar(rightbar, "MultiBarRightButton", NUM_ACTIONBAR_BUTTONS, "Bar5")
mAB.SetBar(petbar, "PetActionButton", NUM_PET_ACTION_SLOTS, "PetBar")
petbar:SetScale(cfg.bars["PetBar"].scale or 0.80)
RegisterStateDriver(petbar, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
mAB.SetStanceBar(stancebar, "StanceButton", NUM_STANCE_SLOTS)
mAB.SetStanceBar(stancebar, "PossessButton", NUM_POSSESS_SLOTS)
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
-- mAB.SetVisibility("PetBar", petbar)


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
	--OverrideActionBar,
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
local OverrideTexList = {
	"_BG",
	"_MicroBGMid",
	"_Border",
	"EndCapL",
	"EndCapR",
	"Divider1",
	"Divider2",
	"Divider3",
	"ExitBG",
	"MicroBGL",
	"MicroBGR",
	"ButtonBGL",
	"ButtonBGR",
	"_ButtonBGMid",
}
for _, t in pairs(OverrideTexList) do
	OverrideActionBar[t]:SetAlpha(0)
end


-- ExtraBar button implementation
extraButton = CreateFrame("Frame", "ExtraBtn_holder", G.frame)
if not cfg.bars["ExtraButton"].disable then
	extraButton:SetPoint(cfg.bars["ExtraButton"].position.a, cfg.bars["ExtraButton"].position.x, cfg.bars["ExtraButton"].position.y)
	extraButton:SetSize(1, 1)

	-- ExtraActionBarFrame:Hide()
	-- ExtraActionButton1:SetParent(G.frame)
	ExtraActionButton1:ClearAllPoints()
	ExtraActionButton1:SetPoint("CENTER", G.frame, "CENTER", -50, -300)

	-- ZoneAbilityFrame:SetParent(G.frame)
	-- ZoneAbilityFrame:ClearAllPoints()
	-- ZoneAbilityFrame:SetPoint("CENTER", G.frame, "CENTER", 100, -300)

	ZoneAbilityFrame:SetParent(G.frame)
	ZoneAbilityFrame:ClearAllPoints()
	ZoneAbilityFrame:SetPoint("CENTER", G.frame, "CENTER", 40, -300)
	ZoneAbilityFrame.ignoreFramePositionManager = true
	ZoneAbilityFrame.Style:SetAlpha(0)

	hooksecurefunc(ZoneAbilityFrame, 'UpdateDisplayedZoneAbilities', function(self)
		for spellButton in self.SpellButtonContainer:EnumerateActive() do
			if spellButton and not spellButton.styled then
				spellButton.NormalTexture:SetAlpha(0)
				spellButton:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
				
				F.addBackdrop(spellButton)
				F.createBorder(spellButton, spellButton, true)

				spellButton.Icon:SetDrawLayer('ARTWORK')
				spellButton.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				spellButton.styled = true
			end
		end
	end)

	-- Fix button visibility
	hooksecurefunc(ZoneAbilityFrame, 'SetParent', function(self, parent)
		if parent == _G.ExtraAbilityContainer then
			self:SetParent(G.frame)
		end
	end)

	-- ExtraAbilityContainer:Hide()

	-- ExtraActionButton1.noResize = true
	-- ExtraActionBarFrame.ignoreFramePositionManager = true
end

-- ExtraAbility

-- G.frame_MANAGED_FRAME_POSITIONS.ZoneAbilityFrame = nil
-- ZoneAbilityFrame:ClearAllPoints();
-- ZoneAbilityFrame:SetPoint("CENTER", G.frame, "CENTER", 0, -200);


exitVehicle = CreateFrame("Button", "ExitVehicleButton", G.frame)
exitVehicle:SetPoint("BOTTOM", G.frame, cfg.bars["ExitVehicleButton"].position.a, cfg.bars["ExitVehicleButton"].position.x, cfg.bars["ExitVehicleButton"].position.y)
exitVehicle:SetWidth(28)
exitVehicle:SetHeight(28)
F.createBorder(exitVehicle)
F.createOverlay(exitVehicle)
exitVehicle:Hide()

exitVehicle:SetScript("OnClick", function(self, button) 
	if UnitOnTaxi("player") then TaxiRequestEarlyLanding() else VehicleExit() end
end)

local exitIcon = exitVehicle:CreateTexture("BACKGROUND")
exitIcon:SetTexture(G.media .. "actionbars\\vehicleexit")
exitIcon:SetPoint("TOPLEFT", exitVehicle, "TOPLEFT", 1, -1)
exitIcon:SetPoint("BOTTOMRIGHT", exitVehicle, "BOTTOMRIGHT", -1, 1)
exitIcon:SetTexCoord(.1, .9, .1, .9)

exitVehicle:RegisterEvent("UNIT_ENTERING_VEHICLE")
exitVehicle:RegisterEvent("UNIT_ENTERED_VEHICLE")
exitVehicle:RegisterEvent("UNIT_EXITING_VEHICLE")
exitVehicle:RegisterEvent("UNIT_EXITED_VEHICLE")
exitVehicle:RegisterEvent("ZONE_CHANGED_NEW_AREA")
exitVehicle:SetScript("OnEvent", function(self, event, ...)
	local arg1 = ...;
	if (((event == "UNIT_ENTERING_VEHICLE") or (event == "UNIT_ENTERED_VEHICLE")) and arg1 == "player") then
		exitVehicle:Show()
	elseif (((event == "UNIT_EXITING_VEHICLE") or (event == "UNIT_EXITED_VEHICLE")) and arg1 == "player") or (event == "ZONE_CHANGED_NEW_AREA" and not UnitHasVehicleUI("player")) then
		exitVehicle:Hide()
	end
end)



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

-- fix main bar keybind not working after a talent switch
hooksecurefunc('TalentFrame_LoadUI', function()
	PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
end)

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
