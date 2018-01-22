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
        actionbars = {
            name = "Actionbars",
            type = 'group',
            order = 1,
            args = {
                bar1 = {
                    name = "Bar 1",
                    type = 'group',
                    args = {
                        hidden = {
                            order = 0,
                            name = "Hidden",
                            type = "toggle",
                            get = function()
                                return G.ace.db.profile.actionbars.bar1.hidden
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar1.hidden = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                        orientation = {
                            order = 1,
                            name = "Orientation",
                            type = "select",
                            values = {
                                HORIZONTAL = "Horizontal",
                                VERTICAL = "Vertical",
                            },
                            get = function()
                                return G.ace.db.profile.actionbars.bar1.orientation
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar1.orientation = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                        length = {
                            order = 2,
                            name = "Buttons",
                            type = "range",
                            min = 1,
                            max = 12,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar1.length
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar1.length = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                        size = {
                            order = 3,
                            name = "Size",
                            desc = "NOT WORKING",
                            type = "range",
                            min = 25,
                            max = 75,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar1.size
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar1.size = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                        spacing = {
                            order = 4,
                            name = "Spacing",
                            type = "range",
                            min = 1,
                            max = 50,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar1.spacing
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar1.spacing = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                        rows = {
                            order = 5,
                            name = "Rows",
                            type = "range",
                            min = 1,
                            max = 3,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar1.rows
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar1.rows = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                        x = {
                            order = 6,
                            name = "Position X",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.actionbars.bar1.x)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.actionbars.bar1.x = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                        y = {
                            order = 7,
                            name = "Position Y",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.actionbars.bar1.y)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.actionbars.bar1.y = value
                                G.mAB.RefreshBar("Bar1", "ActionButton")
                            end
                        },
                    }
                },
                bar2 = {
                    name = "Bar 2",
                    type = 'group',
                    args = {
                        hidden = {
                            order = 0,
                            name = "Hidden",
                            type = "toggle",
                            get = function()
                                return G.ace.db.profile.actionbars.bar2.hidden
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar2.hidden = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                        orientation = {
                            order = 1,
                            name = "Orientation",
                            type = "select",
                            values = {
                                HORIZONTAL = "Horizontal",
                                VERTICAL = "Vertical",
                            },
                            get = function()
                                return G.ace.db.profile.actionbars.bar2.orientation
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar2.orientation = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                        length = {
                            order = 2,
                            name = "Buttons",
                            type = "range",
                            min = 1,
                            max = 12,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar2.length
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar2.length = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                        size = {
                            order = 3,
                            name = "Size",
                            desc = "NOT WORKING",
                            type = "range",
                            min = 25,
                            max = 75,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar2.size
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar2.size = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                        spacing = {
                            order = 4,
                            name = "Spacing",
                            type = "range",
                            min = 1,
                            max = 50,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar2.spacing
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar2.spacing = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                        rows = {
                            order = 5,
                            name = "Rows",
                            type = "range",
                            min = 1,
                            max = 3,
                            step = 1,
                            get = function()
                                return G.ace.db.profile.actionbars.bar2.rows
                            end,
                            set = function(info, value)
                                G.ace.db.profile.actionbars.bar2.rows = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                        x = {
                            order = 6,
                            name = "Position X",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.actionbars.bar2.x)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.actionbars.bar2.x = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                        y = {
                            order = 7,
                            name = "Position Y",
                            type = "input",
                            get = function()
                                return tostring(G.ace.db.profile.actionbars.bar2.y)
                            end,
                            set = function(info, value)
                                value = tonumber(value)
                                G.ace.db.profile.actionbars.bar2.y = value
                                G.mAB.RefreshBar("Bar2", "MultiBarBottomLeftButton")
                            end
                        },
                    }
                },
            }
        }
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
    self.db = LibStub("AceDB-3.0"):New("gempDB", defaults, true)
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)


    LibStub("AceConfig-3.0"):RegisterOptionsTable("gempUI", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("gempUI", "gempUI")
end