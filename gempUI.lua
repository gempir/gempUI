local addon, core = ...
local name, ns = ...

core[1] = {} -- F, functions
core[2] = {} -- G, gempUI related stuff like options or media
core[3] = {} -- V, variables

local F, G, V = unpack(select(2, ...))

ChatFrame1:AddMessage("|cff00FF7Fgemp|rUI");
-------------------------------------------------------------------------------------
------ Basics
-------------------------------------------------------------------------------------

G.media = "Interface\\AddOns\\gempUI\\media\\"
G.texture = G.media .. "textures\\flat"

G.fonts = {
	square = "Interface\\Addons\\gempUI\\media\\fonts\\square.ttf",
	roboto = "Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf",
	roboto_bold = "Interface\\Addons\\gempUI\\media\\fonts\\roboto_bold.ttf",
	roboto_bolditalic = "Interface\\Addons\\gempUI\\media\\fonts\\roboto_bolditalic.ttf",
	roboto_italic = "Interface\\Addons\\gempUI\\media\\fonts\\roboto_italic.ttf"
}

-------------------------------------------------------------------------------------
------ Options
-------------------------------------------------------------------------------------

G.cooldowns = {
	font = G.fonts.square,
	fontsize = 16,
	fontflag = "THINOUTLINE",
}

--AuraWatch Spells
G.aurawatch = {
	spellIDs = {
		DEATHKNIGHT = {
			195181, -- Bone Shield
			53365, -- Unholy Strength
		},
		WARRIOR = {
			184362, -- Enrage
			1719, -- Battlecry
			107574, -- Avatar
		}
	}
}

G.unitframes = {
	font = G.fonts.square,
	fontsize = 11,
	fontflag = "THINOUTLINE",
	player = {
		width = 210,
		health = 24,
		power = 3, -- rage, mana etc.
		special = 5, -- holy power, runes etc.
		xOff = -132,
		yOff = 180,
		castbar = {
			width = 295,
			height = 25,
			xOff = 175,
			yOff = -39
		},
		aurabar = {
			width = 210,
			height = 24
		}
	},
	target = {
		width = 210,
		health = 24,
		power = 3,
		xOff = 132,
		yOff = 180,
		castbar = {
			width = 210,
			height = 15,
			xOff = 0,
			yOff = -10
		}
	},
	targettarget = {
		width = 80,
		health = 27,
		xOff = 0,
		yOff = -64,
	},
	party = {
		width = 166,
		health = 24,
		power = 3,
		xOff = 6,
		yOff = -6
	},
	tank = {
		width = 166,
		health = 24,
		power = 3,
		xOff = -105,
		yOff = 150
	},
	tanktarget = {
		width = 80,
		health = 27
	},
	raid = {
		width = 60,
		health = 30,
		power = 2,
		xOff = 6,
		yOff = -6
	},
	arena = {
		width = 166,
		health = 24,
		power = 3,
		xOff = 120,
		yOff = 300
	},
	pet = {
		width = 80,
		health = 27,
		xOff = 0,
		yOff = -64
	},
	focus = {
		width = 166,
		health = 24,
		power = 3,
		xOff = -550,
		yOff = -20
	},
	focustarget = {
		xOff = 5,
		yOff = 0
	},
	boss = {
		width = 166,
		health = 24,
		power = 3, 
		xOff = 120,
		yOff = 400
	},
}




G.options = {
	actionbars_side_two = false, -- adds a second actionbar on the right
	actionbars_main_three = false -- adds a third actionbar in the middle
}


G.nameplates = {
	width = 120,
	height = 10,
	fontsize = 10,
	fontflag = 'THINOUTLINE',
	cbheight = 8,
	cbcolor = { r = 50, g = 50, b = 50 }
}

G.colors = {
	base = { 0, 0, 0, 0.5 },
	bg = { 0, 0, 0, 0 },
	border = { 0, 0, 0, 1 },
	special = { 0, 0.29, 0.58, 1 }
}

G.backdrop = {
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
}


V = {
	oUF = ns.oUF,
	playerlevel = UnitLevel("player"),
	playername = UnitName("player")
}

-- Saved Variables
-- default
gempDB = {
	autorepair = 0,
	hideerrors = false,
	selljunk = false,
	xpbar = true,
	threatbar = true,
	SkadaSkinSet = false,
	gDMG_visible = false,
	gAC_visible = false,
	gWM_visible = false
}


-------------------------------------------------------------------------------------
------ Credits
-------------------------------------------------------------------------------------
--[[

Used General Font is Roboto by Google
Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf

The 2nd Font is called SquareFont from dafont user "agustinluisbou92" or "Bou Fonts"
Interface\\Addons\\gempUI\\media\\fonts\\square.ttf

This UI is a compilation of a lot of Addons and some stuff is written by me (gempir)
A lot of Credit goes to these great people who wrote these addons and people who helped me, most of them can be found on wowinterface.com

Zork - rTooltip, rActionButtonStyler
Skaarj - ouF_Skaarj
Yarko - Cooldowns
nightcracker, Coote - ncHoverbind
Monolit - m_Actionbars (monoActionbars)
Tuller - TullaRange
Blooblahguy - bBuffs
10leej - Click Menu - Copyright (c) 2015 10leej (MIT License)
Miziak,saulhudson - IronMicroExperience based on MicroExperience

General cool People
Mayron, Resike, Fizzlemizz, Seerah, Leatrix, semlar, Clamsoda, jeruku

]] --