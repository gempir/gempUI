local addon, core = ...

core[1] = {} -- F, functions
core[2] = {} -- G, gempUI related stuff like options or media
core[3] = {} -- V, variables 

local F, G, V = unpack(select(2, ...))

ChatFrame1:AddMessage("|cff00FF7Fgemp|rUI");
-------------------------------------------------------------------------------------
------ Options
-------------------------------------------------------------------------------------

G.options = {						
	actionbars_side_two = false,			-- adds a second actionbar on the right
	actionbars_main_three = false,			-- adds a third actionbar in the middle
	castbar_safezone = false				-- shows a safezone for the castbar 
	}

-- positions for unitframes some of these are anchored to another 

G.pos = {
	player 			= {x = 132,  y = 189},
	target 			= {x = -132, y = 189},
	targetoftarget  = {x = 0, 	 y = -64},
	focus 			= {x = -105, y = 400},
	focustarget		= {x = 95, 	 y = 0},
	pet				= {x = 0, 	 y = -63},
	boss			= {x = 120,	 y = 400},
	tank			= {x = -105, y = 150},
	raid			= {x = 6, 	 y = -6},
	party			= {x = 724,  y = -780},
	arena			= {x = 120,	 y = 300},
}

-- Colors

G.color = {r =  0.1,	g =  0.1, 	b =  0.1, a = 1}   -- defines general color of the UI, unitframes will have some bugs
G.bordercolor = {r =  0,	g =  0, 	b =  0, a = 1} -- unitframes not fully supported, buffs and buttons don't work either

--[[
 
 
               Tank = { a = 'oUF_SkaarjPlayer', x= -105, y=  150},  
               Raid = { a = UIParent,           x=	6,  y=  -6},   
	          Party = { a = UIParent, 			x=  724,  y=  -800},
              Arena = { a = 'oUF_SkaarjTarget', x=  120, y=  300},	

]]
-- media stuff
G.media = "Interface\\AddOns\\gempUI\\media\\"

G.fonts = {
	square = "Interface\\Addons\\gempUI\\media\\fonts\\square.ttf",
	roboto = "Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf",
	roboto_bold = "Interface\\Addons\\gempUI\\media\\fonts\\roboto_bold.ttf",
	roboto_bolditalic = "Interface\\Addons\\gempUI\\media\\fonts\\roboto_bolditalic.ttf",
	roboto_italic = "Interface\\Addons\\gempUI\\media\\fonts\\roboto_italic.ttf"
}
-- useful variables

V = {
	playerlevel=UnitLevel("player"),
	playername=UnitName("player")
}

-- Saved Variables
-- default
gempDB = {
	autorepair = 0,
	hideerrors = false,
	selljunk = false,
	xpbar  = true,
	threatbar  = true,
	SkadaSkinSet = false,
	gDMG_visible = false,
	gAC_visible  = false,
	gWM_visible = false
}


-------------------------------------------------------------------------------------
------ Credits
-------------------------------------------------------------------------------------

-- Used General Font is Roboto by Google
-- Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf

-- The 2nd Font is called SquareFont from dafont user "agustinluisbou92" or "Bou Fonts"
-- Interface\\Addons\\gempUI\\media\\fonts\\square.ttf

-- This UI is a compilation of a lot of Addons and some stuff is written by me (gempir)
-- A lot of Credit goes to these great people who wrote these addons and people who helped me, most of them can be found on wowinterface.com

-- Zork - rTooltip, rActionButtonStyler
-- Skaarj - ouF_Skaarj
-- Yarko - Cooldowns
-- nightcracker, Coote - ncHoverbind 
-- Monolit - m_Actionbars (monoActionbars)
-- Tuller - TullaRange
-- Blooblahguy - bBuffs
-- 10leej - Click Menu - Copyright (c) 2015 10leej (MIT License)
-- Miziak,saulhudson - IronMicroExperience based on MicroExperience

-- General cool People 
-- Mayron, Resike, Fizzlemizz, Seerah, Leatrix, semlar, Clamsoda, jeruku


