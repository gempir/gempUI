local addon, core = ...
local name, ns = ...

core[1] = {} -- F, functions
core[2] = {} -- G, globals like fonts, textures, media, Ace3
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
	fontflag = "MONOCHROMEOUTLINE",
}

G.unitframes = {
	font = G.fonts.square,
	fontsize = 13,
	fontflag = "",
	player = {
		width = 184,
		health = 30,
		power = 8, -- rage, mana etc.
		special = 8, -- holy power, runes etc.
		castbar = {
			width = 280,
			xOff = 285,
			yOff = -67
		},
		aurabar = {
			width = 210,
			height = 24
		}
	},
	target = {
		width = 184,
		health = 30,
		power = 8
	},
	targettarget = {
		width = 80,
		health = 27,
		xOff = 0,
		yOff = -92,
	},
	party = {
		width = 166,
		health = 26,
		power = 3,
		xOff = 200,
		yOff = -600
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
		yOff = 50
	},
	focustarget = {
		xOff = 5,
		yOff = 0
	},
	boss = {
		width = 166,
		health = 27,
		power = 3, 
		xOff = 120,
		yOff = 400
	},
}

G.nameplates = {
	width = 120,
	height = 10,
	fontsize = 10,
	fontflag = '',
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

G.actionbars = {
	extra = {
		x = 0,
		y = 0,
	}
}


V = {
	oUF = ns.oUF,
	playerlevel = UnitLevel("player"),
	playername = UnitName("player"),
	class = select(2, UnitClass('player'))
}

------ Shared Media
local LSM = LibStub("LibSharedMedia-3.0")

LSM:Register("statusbar", "Flat", G.texture)
LSM:Register("font", "Square", G.fonts.square)

LSM:Register(LSM.MediaType.FONT, "Roboto", G.fonts.roboto)
LSM:Register(LSM.MediaType.FONT, "Roboto Bold", G.fonts.roboto_bold)
LSM:Register(LSM.MediaType.FONT, "Roboto Bold Italic", G.fonts.roboto_bolditalic)
LSM:Register(LSM.MediaType.FONT, "Roboto Italic", G.fonts.roboto_italic)

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

Zork - rTooltip, rActionButtonStyler, rActionbar
Skaarj - ouF_Skaarj
nightcracker, Coote - ncHoverbind
10leej - Click Menu - Copyright (c) 2015 10leej (MIT License)

General cool People who helped me out
Haste, Mayron, Resike, Fizzlemizz, Seerah, Leatrix, semlar, Clamsoda, jeruku

]] --