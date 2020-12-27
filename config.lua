local F, G, V = unpack(select(2, ...))

G.ace = LibStub("AceAddon-3.0"):NewAddon("gempUI", "AceConsole-3.0", "AceEvent-3.0")

function getPixel(pixels)
	return PixelUtil.GetNearestPixelSize(pixels, UIParent:GetEffectiveScale(), 1)
end

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
        },
        unitframes = {
            name = "Unitframes",
            type = 'group',
            order = 1,
            childGroups = "tree",
            args = {
                player = {
                    name = "Player",
                    type = 'group',
                    order = 0,
                    args = {
                        width = {
                            order = 0,
                            name = "Width",
                            desc = "/reload to see changes",
                            min = 50,
                            max = 600,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].width
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].width = value
                            end
                        },
                        showName = {
                            order = 1,
                            name = "Show Name",
                            desc = "/reload to see changes",
                            type = "toggle",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].showName
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].showName = value
                            end
                        },
                        health = {
                            order = 2,
                            name = "Health Height",
                            desc = "/reload to see changes",
                            min = 1,
                            max = 100,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].health
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].health = value
                            end
                        },
                        power = {
                            order = 3,
                            name = "Power Height",
                            desc = "/reload to see changes",
                            min = 1,
                            max = 100,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].power
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].power = value
                            end
                        },
                        x = {
                            order = 4,
                            name = "Position X",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['player'].x)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['player'].x = value
                                refreshUnitframePositions()
                            end
                        },
                        y = {
                            order = 5,
                            name = "Position Y",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['player'].y)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['player'].y = value
                                refreshUnitframePositions()
                            end
                        },
                        castbarHeader = {
                            order = 6,
                            name = "Castbar",
                            type = "header",
                        },
                        castbarX = {
                            order = 7,
                            name = "Position X",
                            desc = "/reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['player'].castbarX)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['player'].castbarX = value
                            end
                        },
                        castbarY = {
                            order = 8,
                            name = "Position Y",
                            desc = "/reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['player'].castbarY)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['player'].castbarY = value
                            end
                        },
                        castbarWidth = {
                            order = 9,
                            name = "Width",
                            desc = "/reload to see changes",
                            min = 10,
                            max = 600,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].castbarWidth
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].castbarWidth = value
                            end
                        },
                        castbarHeight = {
                            order = 10,
                            name = "Height",
                            desc = "/reload to see changes",
                            min = 1,
                            max = 50,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].castbarHeight
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].castbarHeight = value
                            end
                        },
                        auraBarsHeader = {
                            order = 11,
                            name = "AuraBars",
                            type = "header",
                        },
                        auraBarsX = {
                            order = 12,
                            name = "Position X",
                            desc = "Relative to player frame | /reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['player'].auraBarsX)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['player'].auraBarsX = value
                            end
                        },
                        auraBarsY = {
                            order = 13,
                            name = "Position Y",
                            desc = "Relative to player frame | /reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['player'].auraBarsY)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['player'].auraBarsY = value
                            end
                        },
                        auraBarsWidth = {
                            order = 14,
                            name = "Width",
                            desc = "/reload to see changes",
                            min = 10,
                            max = 600,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].auraBarsWidth
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].auraBarsWidth = value
                            end
                        },
                        auraBarsHeight = {
                            order = 15,
                            name = "Height",
                            desc = "/reload to see changes",
                            min = 2,
                            max = 50,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].auraBarsHeight
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].auraBarsHeight = value
                            end
                        },
                        auraBarsSpacing = {
                            order = 16,
                            name = "Spacing",
                            desc = "/reload to see changes",
                            min = -1,
                            max = 50,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].auraBarsSpacing
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].auraBarsSpacing = value
                            end
                        },
                        auraBarsFontSize = {
                            order = 17,
                            name = "FontSize",
                            desc = "/reload to see changes",
                            min = 6,
                            max = 60,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['player'].auraBarsFontSize
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['player'].auraBarsFontSize = value
                            end
                        },
                    }
                },
                target = {
                    name = "Target",
                    type = 'group',
                    order = 1,
                    args = {
                        width = {
                            order = 0,
                            name = "Width",
                            desc = "/reload to see changes",
                            min = 50,
                            max = 600,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].width
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].width = value
                            end
                        },
                        allDebuffs = {
                            type = "toggle",
                            order = 1,
                            name = "Show all enemy debuffs",
                            desc = "Will show more than just your debuffs on target frames",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].allDebuffs
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].allDebuffs = value
                            end
                        },
                        health = {
                            order = 2,
                            name = "Health Height",
                            desc = "/reload to see changes",
                            min = 1,
                            max = 100,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].health
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].health = value
                            end
                        },
                        power = {
                            order = 3,
                            name = "Power Height",
                            desc = "/reload to see changes",
                            min = 1,
                            max = 100,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].power
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].power = value
                            end
                        },
                        x = {
                            order = 4,
                            name = "Position X",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['target'].x)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['target'].x = value
                                refreshUnitframePositions()
                            end
                        },
                        y = {
                            order = 5,
                            name = "Position Y",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['target'].y)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['target'].y = value
                                refreshUnitframePositions()
                            end
                        },
                        castbarHeader = {
                            order = 6,
                            name = "Castbar",
                            type = "header",
                        },
                        castbarX = {
                            order = 7,
                            name = "Position X",
                            desc = "/reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['target'].castbarX)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['target'].castbarX = value
                            end
                        },
                        castbarY = {
                            order = 8,
                            name = "Position Y",
                            desc = "/reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['target'].castbarY)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['target'].castbarY = value
                            end
                        },
                        castbarWidth = {
                            order = 9,
                            name = "Width",
                            desc = "/reload to see changes",
                            min = 10,
                            max = 600,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].castbarWidth
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].castbarWidth = value
                            end
                        },
                        castbarHeight = {
                            order = 10,
                            name = "Height",
                            desc = "/reload to see changes",
                            min = 1,
                            max = 50,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].castbarHeight
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].castbarHeight = value
                            end
                        },
                        auraBarsHeader = {
                            order = 11,
                            name = "AuraBars",
                            type = "header",
                        },
                        auraBarsX = {
                            order = 12,
                            name = "Position X",
                            desc = "Relative to target frame | /reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['target'].auraBarsX)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['target'].auraBarsX = value
                            end
                        },
                        auraBarsY = {
                            order = 13,
                            name = "Position Y",
                            desc = "Relative to target frame | /reload to see changes",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['target'].auraBarsY)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['target'].auraBarsY = value
                            end
                        },
                        auraBarsWidth = {
                            order = 14,
                            name = "Width",
                            desc = "/reload to see changes",
                            min = 10,
                            max = 600,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].auraBarsWidth
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].auraBarsWidth = value
                            end
                        },
                        auraBarsHeight = {
                            order = 15,
                            name = "Height",
                            desc = "/reload to see changes",
                            min = 2,
                            max = 50,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].auraBarsHeight
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].auraBarsHeight = value
                            end
                        },
                        auraBarsSpacing = {
                            order = 16,
                            name = "Spacing",
                            desc = "/reload to see changes",
                            min = -1,
                            max = 50,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].auraBarsSpacing
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].auraBarsSpacing = value
                            end
                        },
                        auraBarsFontSize = {
                            order = 17,
                            name = "FontSize",
                            desc = "/reload to see changes",
                            min = 6,
                            max = 60,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['target'].auraBarsFontSize
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['target'].auraBarsFontSize = value
                            end
                        },
                    }
                },
                targettarget = {
                    name = "Target of Target",
                    type = 'group',
                    order = 1,
                    args = {
                        width = {
                            order = 0,
                            name = "Width",
                            desc = "/reload to see changes",
                            min = 50,
                            max = 600,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['targettarget'].width
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['targettarget'].width = value
                            end
                        },
                        health = {
                            order = 1,
                            name = "Health Height",
                            desc = "/reload to see changes",
                            min = 1,
                            max = 100,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.unitframes['targettarget'].health
                            end,
                            set = function(info, value)
                                G.ace.db.profile.unitframes['targettarget'].health = value
                            end
                        },
                        x = {
                            order = 2,
                            name = "Position X",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['targettarget'].x)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['targettarget'].x = value
                                refreshUnitframePositions()
                            end
                        },
                        y = {
                            order = 3,
                            name = "Position Y",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.unitframes['targettarget'].y)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.unitframes['targettarget'].y = value
                                refreshUnitframePositions()
                            end
                        },
                    }
                },
            }
        },
        panels = {
            name = "Panels",
            type = 'group',
            order = 2,
            childGroups = "tree",
            args = {
                mainpanel = {
                    name = "Mainpanel",
                    type = 'group',
                    order = 0,
                    args = {
                        Hidden = {
                            order = 0,
                            name = "Hidden",
                            desc = "",
                            type = "toggle",
                            get = function()
                                return G.ace.db.profile.panels['mainpanel'].hidden
                            end,
                            set = function(info, value)
                                G.ace.db.profile.panels['mainpanel'].hidden = value
                                G.ace:GetModule("Panels"):SetPanel("mainpanel", UIParent, G.ace.db.profile.panels['mainpanel'].x, G.ace.db.profile.panels['mainpanel'].y, G.ace.db.profile.panels['mainpanel'].width, G.ace.db.profile.panels['mainpanel'].height, G.ace.db.profile.panels['mainpanel'].hidden)
                            end
                        },
                        width = {
                            order = 1,
                            name = "Width",
                            desc = "",
                            min = 1,
                            max = 4096,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.panels['mainpanel'].width
                            end,
                            set = function(info, value)
                                G.ace.db.profile.panels['mainpanel'].width = value
                                G.ace:GetModule("Panels"):SetPanel("mainpanel", UIParent, G.ace.db.profile.panels['mainpanel'].x, G.ace.db.profile.panels['mainpanel'].y, G.ace.db.profile.panels['mainpanel'].width, G.ace.db.profile.panels['mainpanel'].height, G.ace.db.profile.panels['mainpanel'].hidden)
                            end
                        },
                        height = {
                            order = 2,
                            name = "Height",
                            desc = "",
                            min = 1,
                            max = 2160,
                            step = 1,
                            type = "range",
                            get = function()
                                return G.ace.db.profile.panels['mainpanel'].height
                            end,
                            set = function(info, value)
                                G.ace.db.profile.panels['mainpanel'].height = value
                                G.ace:GetModule("Panels"):SetPanel("mainpanel", UIParent, G.ace.db.profile.panels['mainpanel'].x, G.ace.db.profile.panels['mainpanel'].y, G.ace.db.profile.panels['mainpanel'].width, G.ace.db.profile.panels['mainpanel'].height, G.ace.db.profile.panels['mainpanel'].hidden)
                            end
                        },
                        x = {
                            order = 3,
                            name = "Position X",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.panels['mainpanel'].x)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.panels['mainpanel'].x = value
                                G.ace:GetModule("Panels"):SetPanel("mainpanel", UIParent, G.ace.db.profile.panels['mainpanel'].x, G.ace.db.profile.panels['mainpanel'].y, G.ace.db.profile.panels['mainpanel'].width, G.ace.db.profile.panels['mainpanel'].height, G.ace.db.profile.panels['mainpanel'].hidden)
                            end
                        },
                        y = {
                            order = 4,
                            name = "Position Y",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.panels['mainpanel'].y)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.panels['mainpanel'].y = value
                                G.ace:GetModule("Panels"):SetPanel("mainpanel", UIParent, G.ace.db.profile.panels['mainpanel'].x, G.ace.db.profile.panels['mainpanel'].y, G.ace.db.profile.panels['mainpanel'].width, G.ace.db.profile.panels['mainpanel'].height, G.ace.db.profile.panels['mainpanel'].hidden)
                            end
                        }
                    }
                },
            }
        },
    }
}

local defaults = {
    profile = {
        sellJunk = true,
        autoRepair = true,
        hideErrors = "never",
        auraWatch = {},
        unitframes = {
            player = {
                width = 184,
                showName = false,
                health = 30,
                power = 8,
                x = -259,
                y = -400,
                castbarX = 0,
                castbarY = -566,
                castbarWidth = 300,
                castbarHeight = 25,
                auraBarsX = 157,
                auraBarsY = 25,
                auraBarsWidth = 118,
                auraBarsHeight = 32,
                auraBarsSpacing = -1,
                auraBarsFontSize = 18,
            },
            target = {
                width = 184,
                allDebuffs = false,
                health = 30,
                power = 8,
                x = 259,
                y = -400,
                castbarX = 259,
                castbarY = -435,
                castbarWidth = 182,
                castbarHeight = 16,
                auraBarsX = -157,
                auraBarsY = 25,
                auraBarsWidth = 118,
                auraBarsHeight = 32,
                auraBarsSpacing = -1,
                auraBarsFontSize = 18,
            },
            targettarget = {
                width = 80,
                health = 27,
                x = 309,
                y = -479,
            }
        },
        panels = {
            mainpanel = {
                hidden = false,
                width = 322,
                height = 165,
                x = 0,
                y = -464,
            }
        },
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

local function setupUI()
    G.ace:GetModule("Panels"):SetPanel("mainpanel", UIParent, G.ace.db.profile.panels['mainpanel'].x, G.ace.db.profile.panels['mainpanel'].y, G.ace.db.profile.panels['mainpanel'].width, G.ace.db.profile.panels['mainpanel'].height, G.ace.db.profile.panels['mainpanel'].hidden)
end

function G.ace:OnInitialize()
    local frame = CreateFrame("FRAME", "SavedVarsFrame");
    frame:RegisterEvent("ADDON_LOADED")
    frame:SetScript("OnEvent", function(self, event, arg1)
        if arg1 == "gempUI" then
            self:UnregisterEvent("ADDON_LOADED")
            G.ace.db = LibStub("AceDB-3.0"):New("gempDB", defaults, true)

            options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(G.ace.db)
            LibStub("AceConfig-3.0"):RegisterOptionsTable("gempUI", options)
            self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gempUI", "gempUI")

            setupUI()
        end 
    end)
    


   
end

