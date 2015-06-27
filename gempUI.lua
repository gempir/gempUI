-------------------------------------------------------------------------------------
------ Options
-------------------------------------------------------------------------------------

gempUIcolor = {r =  0.1,	g =  0.1, 	b =  0.1, a = 1}   -- defines general color of the UI
gempUIsecondcolor = {r = 0, g = 0.5, b = 0.4}  	   -- this is the green tone used in something like the rep bar Hex: #008066
gempUIbordercolor = {r =  0,	g =  0, 	b =  0, a = 1} -- this is experimental which is why it doesn't work with anything


-- several general options
gempUI = {						
	actionbars_side_two = false,			-- adds a second actionbar on the right
	actionbars_main_three = false,			-- adds a third actionbar in the middle
	castbar_safezone = false				-- shows a safezone for the castbar 
	}

	
-- positions

-- Version Output
print("|cff00FF7F gemp|rUI v0.1 BETA")

-- Shared Media
local LSM = LibStub("LibSharedMedia-3.0") 
 
LSM:Register("statusbar", "Flat", [[Interface\Addons\gempUI\media\textures\flat.tga]])
LSM:Register("font", "Square", [[Interface\Addons\gempUI\media\fonts\square.ttf]])	 

LSM:Register(LSM.MediaType.FONT, "Roboto", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Bold", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_bold.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Bold Italic", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_bolditalic.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Italic", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_italic.ttf")

-------------------------------------------------------------------------------------
------ Credits
-------------------------------------------------------------------------------------

-- Used General Font is Roboto by Google
-- Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf

-- The 2nd Font is called SquareFont from dafont user "agustinluisbou92" or "Bou Fonts"
-- Interface\\Addons\\gempUI\\media\\fonts\\square.ttf

-- Icon Credit
-- http://cliparts.co/clip-art-sword

-- This UI is a compilation of a lot of Addons and some stuff is written by me (Gempir)
-- A lot of Credit goes to these great people who wrote these addons, most of them can be found on wowinterface.com

-- Zork - rTooltip, rActionButtonStyler, rChat
-- Skaarj - ouF_Skaarj
-- Yarko - Cooldowns
-- Dridzt - TinyMainBarInfo (Info texts)
-- nightcracker, Coote - ncHoverbind 
-- Monolit - m_Actionbars (monoActionbars)
-- Tuller - TullaRange
-- Blooblahguy - bBuffs
-- 10leej - Click Menu - Copyright (c) 2015 10leej (MIT License)

