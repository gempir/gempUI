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
		buttons =  6,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "CENTER", x = 0, y = -390 },
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
		buttons = 6,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "CENTER", x = 0, y = -429 },
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
		buttons = 6,
		button_size = cfg.mAB.size,
		button_spacing = cfg.mAB.spacing,
		position = { a = "CENTER", x = 0, y = -468 },
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

-- HANDOVER
ns.cfg = cfg


-------------------------- CONFIG END ----------------------------------------

local addon, ns = ...
local cfg = ns.cfg
G.mAB = CreateFrame("Frame")
local mAB = G.mAB

--- - Addon functions
local myclass = select(2, UnitClass("player"))

-- holder creating func
mAB.CreateHolderLegacy = function(name, pos)
	local bar = CreateFrame("Frame", name, UIParent, "SecureHandlerStateTemplate")
	bar:SetPoint(pos.a, pos.x, pos.y)
	bar:SetFrameStrata("MEDIUM")
	return bar
end

-- holder creating func
mAB.CreateHolder = function(barName, relativeTo, x, y)
	local bar = CreateFrame("Frame", barName .. "_holder", UIParent, "SecureHandlerStateTemplate")
	bar:SetPoint(relativeTo, x, y)
    bar:SetFrameStrata("MEDIUM")
	return bar
end

-- I always wanted to have my personal death star to destroy stuff!
local DeathStar = mAB.CreateHolderLegacy("DeathStar", { a = "TOP", x = 0, y = 100 })
DeathStar:Hide()

-- style function for bars
--mAB.SetBar = function(bar, btn, num, orient, rows, visnum, bsize, spacing)
mAB.SetBarLegacy = function(bar, btn, num, cfgn)
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

G.actionbars = {
    ["OverrideActionBar"] = mAB.CreateHolder("OverrideActionBar", "CENTER", 0, 0),
    ["Bar1"] = mAB.CreateHolder("Bar1", "CENTER", 0, 0),
    ["Bar2"] = mAB.CreateHolder("Bar2", "CENTER", 0, 0)
}

MainMenuBarArtFrame:SetParent(G.actionbars["Bar1"])
OverrideActionBar:SetParent(G.actionbars["OverrideActionBar"])
OverrideActionBar:EnableMouse(false)
OverrideActionBar:SetScript("OnShow", nil)
RegisterStateDriver(G.actionbars["OverrideActionBar"], "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
RegisterStateDriver(OverrideActionBar, "visibility", "[overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

function mAB.RefreshBar(barName, blizzardName)
    mAB.SetBar(
        barName,
        blizzardName, 
        "CENTER", 
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].x, 
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].y,
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].rows,
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].length,
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].size,
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].spacing,
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].hidden,
        G.ace.db.profile.actionbars["bar" .. string.sub(barName, -1)].orientation
    )
end

function mAB.SetBar(barName, blizzardName, relativeTo, x, y, rows, length, size, spacing, hidden, orientation)
    local num = NUM_ACTIONBAR_BUTTONS
    local first_row_num = math.floor(length / rows)
    local holder = nil
    if blizzardName == "OverrideActionBarButton" then
        holder = G.actionbars["OverrideActionBar"]
    else 
        holder = G.actionbars[barName]
    end
    if hidden then
        holder:SetParent(DeathStar)
    else 
        holder:SetParent(UIParent)
    end
    holder:SetPoint(relativeTo, x, y)
    
    if blizzardName == "ActionBarButton" then
        RegisterStateDriver(holder, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists]hide;show")
    end

    for i = 1, num do
        local button = _G[blizzardName .. i]
        if not button then
            break
        end
        button:SetSize(size, size)
        button:ClearAllPoints()
        button:SetParent(holder)
        if i == 1 then
            button:SetPoint("BOTTOMLEFT", holder, 0, 0)
        else
            local previous = _G[blizzardName .. i - 1]
            if orientation == "HORIZONTAL" then
                if rows == 1 then
                    button:SetPoint("LEFT", previous, "RIGHT", spacing, 0)
                else
                    button:SetPoint("TOPLEFT", previous, "TOPRIGHT", spacing, 0)
                    if i == first_row_num + 1 then
                        button:SetPoint("TOPLEFT", _G[blizzardName .. (i - first_row_num)], "BOTTOMLEFT", 0, -spacing)
                    end
                    if i == first_row_num * 2 + 1 then
                        button:SetPoint("TOPLEFT", _G[blizzardName .. (i - first_row_num)], "BOTTOMLEFT", 0, -spacing)
                    end
                end

                if i > length then
                    button:SetParent(DeathStar)
                end
            else 
                if rows == 1 then
                    button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, spacing)
                else
                    button:SetPoint("BOTTOMLEFT", previous, "TOPLEFT", 0, spacing)
                    if i == first_row_num + 1 then
                        button:SetPoint("BOTTOMLEFT", _G[blizzardName .. (i - first_row_num)], "BOTTOMRIGHT", spacing, 0)
                    end
                    if i == first_row_num * 2 + 1 then
                        button:SetPoint("BOTTOMLEFT", _G[blizzardName .. (i - first_row_num)], "BOTTOMRIGHT", spacing, 0)
                    end
                end
            end
        end
    end
    if orientation == "HORIZONTAL" then
        if rows == 1 then
            holder:SetWidth(size * length + spacing * (length - 1))
            holder:SetHeight(size)
        else
            holder:SetWidth(size * first_row_num + spacing * (first_row_num - 1))
            holder:SetHeight(size * rows + spacing)
        end
    else 
        if rows == 1 then
			holder:SetWidth(size)
			holder:SetHeight(size * length + spacing * (length - 1))
		else
			holder:SetWidth(size * rows + spacing)
			holder:SetHeight(size * first_row_num + spacing * (first_row_num - 1))
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


--- - Modifying default action bars
-- Creating holder frames for each bar
-- local mainbar = mAB.CreateHolderLegacy("Bar1_holder", cfg.bars["Bar1"].position)
local bottomleftbar = mAB.CreateHolderLegacy("Bar2_holder", cfg.bars["Bar2"].position)
local bottomrightbar = mAB.CreateHolderLegacy("Bar3_holder", cfg.bars["Bar3"].position)
leftbar = mAB.CreateHolderLegacy("Bar4_holder", cfg.bars["Bar4"].position)
rightbar = mAB.CreateHolderLegacy("Bar5_holder", cfg.bars["Bar5"].position)
local extrabar = mAB.CreateHolderLegacy("Bar6_holder", cfg.bars["Bar6"].position)
local stancebar = mAB.CreateHolderLegacy("StanceBar_holder", cfg.bars["StanceBar"].position)
local petbar = mAB.CreateHolderLegacy("PetBar_holder", { a = cfg.bars["PetBar"].position.a, x = cfg.bars["PetBar"].position.x * 1.25, y = cfg.bars["PetBar"].position.y * 1.25 })
local exitVehicle = mAB.CreateHolderLegacy("ExitVehicle_holder", cfg.bars["ExitVehicleButton"].position)
--local extrabtn = mAB.CreateHolderLegacy("ExtraBtn_holder", cfg.ExtraButton["Position"])

--- - Forging action bars
-- parenting action buttons to our holders

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
-- mAB.SetBarLegacy(mainbar, "ActionButton", NUM_ACTIONBAR_BUTTONS, "Bar1")
mAB.SetBarLegacy(bottomleftbar, "MultiBarBottomLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar2")
mAB.SetBarLegacy(bottomrightbar, "MultiBarBottomRightButton", NUM_ACTIONBAR_BUTTONS, "Bar3")
mAB.SetBarLegacy(leftbar, "MultiBarLeftButton", NUM_ACTIONBAR_BUTTONS, "Bar4")
mAB.SetBarLegacy(rightbar, "MultiBarRightButton", NUM_ACTIONBAR_BUTTONS, "Bar5")
mAB.SetBarLegacy(petbar, "PetActionButton", NUM_PET_ACTION_SLOTS, "PetBar")
RegisterStateDriver(petbar, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
mAB.SetStanceBar(stancebar, "StanceButton", NUM_STANCE_SLOTS)
mAB.SetStanceBar(stancebar, "PossessButton", NUM_POSSESS_SLOTS)


-- hiding default frames and textures
local FramesToHide = {
	MainMenuBar,
	--MainMenuBarArtFrame, 
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
V.extraButton = CreateFrame("Frame", "ExtraBtn_holder", UIParent)
if not cfg.bars["ExtraButton"].disable then
	V.extraButton:SetPoint(cfg.bars["ExtraButton"].position.a, cfg.bars["ExtraButton"].position.x, cfg.bars["ExtraButton"].position.y)
	V.extraButton:SetSize(36, 36)

	ExtraActionBarFrame:SetParent(V.extraButton)
	ExtraActionBarFrame:ClearAllPoints()
	ExtraActionBarFrame:SetPoint("CENTER", V.extraButton, "CENTER", 0, 0)

	-- ExtraActionButton1.noResize = true
	ExtraActionBarFrame.ignoreFramePositionManager = true
end


exitVehicle = CreateFrame("Button", "ExitVehicleButton", UIParent)
exitVehicle:SetPoint("BOTTOM", UIParent, cfg.bars["ExitVehicleButton"].position.a, cfg.bars["ExitVehicleButton"].position.x, cfg.bars["ExitVehicleButton"].position.y)
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


local MicroMenu = mAB.CreateHolderLegacy("MicroMenu_holder", { a = cfg.bars["MicroMenu"].position.a, x = cfg.bars["MicroMenu"].position.x * (2 - cfg.bars["MicroMenu"].scale), y = cfg.bars["MicroMenu"].position.y * (2 - cfg.bars["MicroMenu"].scale) })
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


F.onOptionsLoaded(function() 
    G.mAB.RefreshBar("Bar1", "ActionButton")
    G.mAB.RefreshBar("Bar1", "OverrideActionBarButton")
    -- G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
end)
