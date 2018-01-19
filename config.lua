local F, G, V = unpack(select(2, ...))

G.ace = LibStub("AceAddon-3.0"):NewAddon("gempUI", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "gempUI",
    handler = G.ace,
    type = 'group',
    args = {
        allEnemyDebuffs = {
            type = "toggle",
            name = "Show all enemy debuffs",
            desc = "Will show more than just your debuffs on target frames",
            get = "GetAllEnemyDebuffs",
            set = "SetAllEnemyDebuffs",
        },
        sellJunk = {
            type = "toggle",
            name = "Sell junk",
            desc = "Automatically vendor greys",
            get = "GetSellJunk",
            set = "SetJellJunk",
        },
        autoRepair = {
            type = "toggle",
            name = "Auto repair",
            desc = "Automatically repair Guild first then personal",
            get = "GetAutoRepair",
            set = "SetAutoRepair",
        },
        hideErrors = {
            type = "select",
            name = "Hide Errors",
            desc = "Mute Blizzard error frame",
            values = {
                always = "Hide errors in combat",
                combat = "Hide errors always",
                never = "Never hide errors"
            },
            get = "GetHideErrors",
            set = "SetHideErrors",
        },
    },
}

local defaults = {
    profile = {
        allEnemyDebuffs = false,
        sellJunk = true,
        autoRepair = true,
        hideErrors = "never"
    }
}

function G.ace:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("gempDB", defaults, true)


    LibStub("AceConfig-3.0"):RegisterOptionsTable("gempUI", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gempUI", "gempUI")
end

-- Getters/Setters

function G.ace:GetAllEnemyDebuffs()
    return self.db.profile.allEnemyDebuffs
end

function G.ace:SetAllEnemyDebuffs(info, input)
    self.db.profile.allEnemyDebuffs = input
end

function G.ace:GetSellJunk()
    return self.db.profile.sellJunk
end

function G.ace:SetJellJunk(info, input)
    self.db.profile.sellJunk = input
end

function G.ace:GetAutoRepair()
    return self.db.profile.autoRepair
end

function G.ace:SetAutoRepair(info, input)
    self.db.profile.autoRepair = input
end

function G.ace:GetHideErrors()
    return self.db.profile.hideErrors
end

function G.ace:SetHideErrors(info, input)
    self.db.profile.hideErrors = input
end













-- local uniquealyzer = 1;
-- function createCheckbutton(parent, point, x_loc, y_loc, displayname)
-- 	uniquealyzer = uniquealyzer + 1;
	
-- 	local checkbutton = CreateFrame("CheckButton", "gempUI_config_checkbutton_0" .. uniquealyzer, parent, "ChatConfigCheckButtonTemplate");
-- 	checkbutton:SetPoint(point, x_loc, y_loc);
-- 	getglobal(checkbutton:GetName() .. 'Text'):SetText(" " .. displayname);

-- 	return checkbutton
-- end

-- function createButton(parent, point, x_loc, y_loc, text, width)
-- 	uniquealyzer = uniquealyzer + 1;
--     local b = CreateFrame("Button", "gempUI_config_button_0" .. uniquealyzer, parent, "UIPanelButtonTemplate")
--     b:SetSize(120, 22)
--     b:SetText(text)
--     b:SetPoint(point, x_loc, y_loc)

--     return b
-- end

-- function createEditBox(parent, point, x, y, text)
--     local box = CreateFrame("EditBox", "gempUI_config_editbox_0" .. uniquealyzer, parent, "InputBoxTemplate")
--     box:SetPoint(point, x, y)
--     box:SetSize(60, 20)
    
-- end

-- function createText(parent, fontsize, point, x, y, text)
--     local t = parent:CreateFontString(nil, "OVERLAY")	
--     t:SetFont(G.fonts.roboto, fontsize, "")
--     t:SetShadowOffset(1, -1)
--     t:SetTextColor(1, 1, 1)
--     t:SetText(text)
--     t:SetPoint(point, x, y)
    
--     return t
-- end

-- function createLine(parent, y)
--     local f = CreateFrame("Frame", nil, parent)
--     f:SetSize(600, 1)
--     f:SetPoint("TOP", 0, y)
--     f:SetBackdrop({
-- 		edgeFile = "Interface\\Buttons\\WHITE8x8",
-- 		edgeSize = 1
-- 	})
-- 	f:SetBackdropColor(0, 0, 0, 0)
-- 	f:SetBackdropBorderColor(.3, .3, .3)
-- end

-- function loadOptions(frame, option)
--     frame:RegisterEvent("ADDON_LOADED")
--     frame:SetScript("OnEvent", function(self, event, arg1)
--         if arg1 == "gempUI" then
--             self:UnregisterEvent("ADDON_LOADED")
--             self:SetChecked(gempDB[option])
--         end 
--     end)
-- end

-- -------------------------------------------------------

-- gempUI = {};

-- gempUI.panel = CreateFrame( "Frame", "gempUI", UIParent);
-- gempUI.panel.name = "gempUI";


-- createText(gempUI.panel, 16, "TOPLEFT", 12, -12, "|cff00FF7F gemp|rUI")
-- createText(gempUI.panel, 10, "TOPLEFT", 16, -30, "Reload to apply changes")

-- local bReload1 = createButton(gempUI.panel, "TOPRIGHT", -12, -12, "Reload", 120)
-- bReload1:SetScript("OnClick", function()
--     ReloadUI()
-- end)

-- local enemyDebuffs = createCheckbutton(gempUI.panel, "TOPLEFT", 12, -48, "Show all enemy debuffs");
-- loadOptions(enemyDebuffs, "enemyDebuffs")
-- enemyDebuffs:SetScript("OnClick", function(self)
--     gempDB.enemyDebuffs = self:GetChecked()
-- end)

-- local sellJunk = createCheckbutton(gempUI.panel, "TOPLEFT", 12, -72, "Auto-Sell Junk");
-- loadOptions(sellJunk, "sellJunk")
-- sellJunk:SetScript("OnClick", function(self)
--     gempDB.sellJunk = self:GetChecked()
-- end)

-- local autoRepair = createCheckbutton(gempUI.panel, "TOPLEFT", 12, -96, "Auto-Repair (Guild First)");
-- loadOptions(autoRepair, "autoRepair")
-- autoRepair:SetScript("OnClick", function(self)
--     gempDB.autoRepair = self:GetChecked()
-- end)

-- local hideErrors = createCheckbutton(gempUI.panel, "TOPLEFT", 12, -120, "Hide errors in combat");
-- loadOptions(hideErrors, "hideErrors")
-- hideErrors:SetScript("OnClick", function(self)
--     gempDB.hideErrors = self:GetChecked()
--     setErrorVisibility()
-- end)



-- InterfaceOptions_AddCategory(gempUI.panel);

-- ------ ACTIONBARS -------



-- gempUI.actionbars = CreateFrame("Frame", "Actionbars", gempUI.panel);
-- gempUI.actionbars.name = "Actionbars";
-- gempUI.actionbars.parent = gempUI.panel.name;

-- local bReload2 = createButton(gempUI.actionbars, "TOPRIGHT", -12, -12, "Reload", 120)
-- bReload1:SetScript("OnClick", function()
--     ReloadUI()
-- end)
-- local bActionbarsshown = createButton(gempUI.actionbars, "TOPLEFT", 12, -12, "Show Actionbars", 120)
-- bActionbarsshown:SetScript("OnClick", function()
--     m_ActionBars_Toggle_Test_Mode()
-- end)

-- createText(gempUI.actionbars, 12, "TOPLEFT", 140, -18, "/hb - Hoverbind")

-- createLine(gempUI.actionbars, -42)

-- -- createEditBox(gempUI.actionbars, "TOPLEFT", 12, -72, "X Position")


-- -- Add the child to the Interface Options
-- InterfaceOptions_AddCategory(gempUI.actionbars);