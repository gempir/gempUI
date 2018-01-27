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
                            max = 50,
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
                            max = 50,
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
                            max = 50,
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
                            max = 50,
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
                            max = 50,
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
    }
}

local defaults = {
    profile = {
        sellJunk = true,
        autoRepair = true,
        hideErrors = "never",
        unitframes = {
            player = {
                width = 184,
                showName = false,
                health = 30,
                power = 8,
                x = -219,
                y = -386,
                castbarX = 0,
                castbarY = -512,
                castbarWidth = 240,
                castbarHeight = 25,
            },
            target = {
                width = 184,
                allDebuffs = false,
                health = 30,
                power = 8,
                x = 219,
                y = -386,
                castbarX = 219,
                castbarY = -420,
                castbarWidth = 182,
                castbarHeight = 16,
            },
            targettarget = {
                width = 80,
                health = 27,
                x = 269,
                y = -479,
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

