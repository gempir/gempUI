

dmgfont = CreateFrame("Frame", "dmgfont");

local damagefont_FONT_NUMBER = "Interface\\AddOns\\gempUI\\media\\fonts\\roboto.ttf";

function dmgfont:ApplySystemFonts()

DAMAGE_TEXT_FONT = damagefont_FONT_NUMBER;

end

dmgfont:SetScript("OnEvent",
		    function() 
		       if (event == "ADDON_LOADED") then
			  dmgfont:ApplySystemFonts()
		       end
		    end);
dmgfont:RegisterEvent("ADDON_LOADED");

dmgfont:ApplySystemFonts()