-- some global variables to use


gempUI_playerlevel=UnitLevel("player")



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