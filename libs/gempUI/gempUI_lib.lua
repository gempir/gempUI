-- some global variables to use


gempUI_playerlevel=UnitLevel("player")
gempUI_playername=UnitName("player")

-- media path

gempUI_media = "Interface\\AddOns\\gempUI\\media\\"

-- fonts

gempUI_fonts_square = "Interface\\Addons\\gempUI\\media\\fonts\\square.ttf"
gempUI_fonts_roboto = "Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf"


-- functions

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



-- Shared Media
local LSM = LibStub("LibSharedMedia-3.0") 
 
LSM:Register("statusbar", "Flat", [[Interface\Addons\gempUI\media\textures\flat.tga]])
LSM:Register("font", "Square", [[Interface\Addons\gempUI\media\fonts\square.ttf]])	 

LSM:Register(LSM.MediaType.FONT, "Roboto", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Bold", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_bold.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Bold Italic", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_bolditalic.ttf")
LSM:Register(LSM.MediaType.FONT, "Roboto Italic", "Interface\\AddOns\\gempUI\\media\\fonts\\roboto_italic.ttf")