gempUI = {}


-------------------------------------------------------------------------------------
------ Options
-------------------------------------------------------------------------------------
ChatFrame1:AddMessage("|cff00FF7Fgemp|rUI v0.1 BETA");


gempUIcolor = {r =  0.1,	g =  0.1, 	b =  0.1, a = 1}   -- defines general color of the UI, unitframes will have some bugs
gempUIsecondcolor = {r = 0, g = 0.7, b = 0.3}  	   -- this is the green tone used in something like the rep bar, doesn't work correctly either
gempUIbordercolor = {r =  0,	g =  0, 	b =  0, a = 1} -- this is experimental which is why it doesn't work with anything


-- several general options
gempUI = {						
	actionbars_side_two = false,			-- adds a second actionbar on the right
	actionbars_main_three = false,			-- adds a third actionbar in the middle
	castbar_safezone = false				-- shows a safezone for the castbar 
	}

	
-- positions

-- Version Output


gempUI.playerlevel=UnitLevel("player")
gempUI.playername=UnitName("player")

-- media path
gempUI_media = "Interface\\AddOns\\gempUI\\media\\"

-- fonts
gempUI_fonts_square = "Interface\\Addons\\gempUI\\media\\fonts\\square.ttf"
gempUI_fonts_roboto = "Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf"



-- Shared Media
local LSM = LibStub("LibSharedMedia-3.0") 
 
LSM:Register("statusbar", "Flat", [[Interface\Addons\gempUI\media\textures\flat.tga]])
LSM:Register("font", "Square", [[Interface\Addons\gempUI\media\fonts\square.ttf]])	 

LSM:Register(LSM.MediaType.FONT, "Roboto", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Bold", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_bold.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Bold Italic", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_bolditalic.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Italic", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_italic.ttf")

-------------------------------------------------------------------------------------
------ Functions
-------------------------------------------------------------------------------------

function gempUI_rebackdrop(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
	})
	frame:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
	frame:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
end

function gempUI_rebackdropdark(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
	})
	frame:SetBackdropColor(gempUIcolor.r+0.05,gempUIcolor.g+0.05,gempUIcolor.b+0.05,gempUIcolor.a)
	frame:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
end

function gempUI_retexture(frame)
	frame:SetTexture(nil)
	frame:SetTexture(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
end

function gempUI_textureclear(t)
  
end




-- thanks to Resike for these two

function GetFrameInfoFromCursor()
    local fn = GetMouseFocus():GetName()
    local f = _G[fn]
    print("|cFF50C0FF".."<---------------------------------------------->".."|r")
    print("|cFF50C0FF".."Frame:".."|r", fn)
    local p = f:GetParent()
    print("|cFF50C0FF".."Parent:".."|r", p:GetName())
    for i = 1, f:GetNumPoints() do
        local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint(i)
        if point and relativeTo and relativePoint and xOfs and yOfs then
            print(i..".", "|cFF50C0FF".."p:".."|r", point, "|cFF50C0FF".."rfn:".."|r", relativeTo:GetName(), "|cFF50C0FF".."rp:".."|r", relativePoint, "|cFF50C0FF".."x:".."|r", xOfs, "|cFF50C0FF".."y:".."|r", yOfs)
        end
    end
    print("|cFF50C0FF".."Scale:".."|r", f:GetScale())
    print("|cFF50C0FF".."Effective Scale:".."|r", f:GetEffectiveScale())
    print("|cFF50C0FF".."Protected:".."|r", f:IsProtected())
    print("|cFF50C0FF".."Strata:".."|r", f:GetFrameStrata())
    print("|cFF50C0FF".."Level:".."|r", f:GetFrameLevel())
    print("|cFF50C0FF".."Width:".."|r", f:GetWidth())
    print("|cFF50C0FF".."Height:".."|r", f:GetHeight())
end

function GetFrameInfo(f)
    local fn = f:GetName()
    print("|cFF50C0FF".."<---------------------------------------------->".."|r")
    print("|cFF50C0FF".."Frame:".."|r", fn)
    local p = f:GetParent()
    print("|cFF50C0FF".."Parent:".."|r", p:GetName())
    for i = 1, f:GetNumPoints() do
        local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint(i)
        if point and relativeTo and relativePoint and xOfs and yOfs then
            print(i..".", "|cFF50C0FF".."p:".."|r", point, "|cFF50C0FF".."rfn:".."|r", relativeTo:GetName(), "|cFF50C0FF".."rp:".."|r", relativePoint, "|cFF50C0FF".."x:".."|r", xOfs, "|cFF50C0FF".."y:".."|r", yOfs)
        end
    end
    print("|cFF50C0FF".."Scale:".."|r", f:GetScale())
    print("|cFF50C0FF".."Effective Scale:".."|r", f:GetEffectiveScale())
    print("|cFF50C0FF".."Protected:".."|r", f:IsProtected())
    print("|cFF50C0FF".."Strata:".."|r", f:GetFrameStrata())
    print("|cFF50C0FF".."Level:".."|r", f:GetFrameLevel())
    print("|cFF50C0FF".."Width:".."|r", f:GetWidth())
    print("|cFF50C0FF".."Height:".."|r", f:GetHeight())
end

-------------------------------------------------------------------------------------
------ Functions
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
-- Mayron - For helping me with some Interface skinning


