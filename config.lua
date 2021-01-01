local F, G = unpack(select(2, ...))

G.ace = LibStub("AceAddon-3.0"):NewAddon("gempUI", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "gempUI",
    handler = G.ace,
    type = 'group',
    childGroups = "tab",
    args = {
        general = {
            name = "General",
            type = 'group',
            order = 0,
            args = {
                autoRepair = {
                    type = "toggle",
                    order = 0,
                    name = "Auto repair",
                    desc = "Automatically repair Guild first then personal",
                    get = function()
                        return G.ace.db.profile.autoRepair
                    end,
                    set = function(info, value)
                        G.ace.db.profile.autoRepair = value
                    end
                },
                sellJunk = {
                    type = "toggle",
                    order = 1,
                    name = "Sell junk",
                    desc = "Automatically vendor greys",
                    get = function()
                        return G.ace.db.profile.sellJunk
                    end,
                    set = function(info, value)
                        G.ace.db.profile.sellJunk = value
                    end
                },
                hideErrors = {
                    type = "select",
                    order = 2,
                    name = "Hide Errors",
                    desc = "Mute Blizzard error frame",
                    values = {
                        combat = "Hide errors in combat",
                        always = "Always hide errors",
                        never = "Never hide errors"
                    },
                    get = function()
                        return G.ace.db.profile.hideErrors
                    end,
                    set = function(info, value)
                        G.ace.db.profile.hideErrors = value
                    end
                },
            }
        }
    }
}

local defaults = {
    profile = {
        sellJunk = true,
        autoRepair = true,
        hideErrors = "never",
        auraWatch = {},
    }
}

function G.ace:OnInitialize()
    local frame = CreateFrame("FRAME", "SavedVarsFrame");
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, arg1)
        self:UnregisterEvent("ADDON_LOADED")
        G.ace.db = LibStub("AceDB-3.0"):New("gempDB", defaults, true)

        options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(G.ace.db)
        LibStub("AceConfig-3.0"):RegisterOptionsTable("gempUI", options)
        self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gempUI", "gempUI")
    end)   
end

