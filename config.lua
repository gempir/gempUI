local F, G, V = unpack(select(2, ...))

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
                allEnemyDebuffs = {
                    type = "toggle",
                    name = "Show all enemy debuffs",
                    desc = "Will show more than just your debuffs on target frames",
                    get = function()
                        return G.ace.db.profile.allEnemyDebuffs
                    end,
                    set = function(info, value)
                        G.ace.db.profile.allEnemyDebuffs = value
                    end
                },
                sellJunk = {
                    type = "toggle",
                    name = "Sell junk",
                    desc = "Automatically vendor greys",
                    get = function()
                        return G.ace.db.profile.sellJunk
                    end,
                    set = function(info, value)
                        G.ace.db.profile.sellJunk = value
                    end
                },
                autoRepair = {
                    type = "toggle",
                    name = "Auto repair",
                    desc = "Automatically repair Guild first then personal",
                    get = function()
                        return G.ace.db.profile.autoRepair
                    end,
                    set = function(info, value)
                        G.ace.db.profile.autoRepair = value
                    end
                },
                hideErrors = {
                    type = "select",
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
        },
    }
}

local defaults = {
    profile = {
        allEnemyDebuffs = false,
        sellJunk = true,
        autoRepair = true,
        hideErrors = "never",
        actionbars = {
            bar1 = {
                hidden = false,
                orientation = "HORIZONTAL",
                length = 6,
                size = 37,
                x = 0,
                y = -390,
                spacing = 2,
                rows = 1
            },
            bar2 = {
                hidden = false,
                orientation = "HORIZONTAL",
                length = 6,
                size = 37,
                x = 0,
                y = -429,
                spacing = 2,
                rows = 1
            }
        }
    }
}

function G.ace:OnInitialize()
    local frame = CreateFrame("FRAME", "SavedVarsFrame");
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, arg1)
        if arg1 == "gempUI" then
            self:UnregisterEvent("ADDON_LOADED")
            G.ace.db = LibStub("AceDB-3.0"):New("gempDB", defaults, true)
            options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(G.ace.db)
        end 
    end)
    


    LibStub("AceConfig-3.0"):RegisterOptionsTable("gempUI", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gempUI", "gempUI")
end