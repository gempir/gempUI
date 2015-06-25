

GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("LEFT",1,0)
GameTooltipStatusBar:SetPoint("RIGHT",-1,0)
GameTooltipStatusBar:SetPoint("BOTTOM",GameTooltipStatusBar:GetParent(),"TOP",0,-4)  
GameTooltipStatusBar:SetHeight(3)
GameTooltipStatusBar:SetStatusBarTexture([[Interface\AddOns\gempUI\textures\flat.tga]])

GameTooltip.bg = CreateFrame("Frame", nil, GameTooltip)
GameTooltip.bg:SetAllPoints(true)
GameTooltip.bg:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -0, right = -0, top = -0, bottom = -0} 
					}) -- or just set this to your own backdrop
GameTooltip:SetBackdrop(nil)
GameTooltip.bg:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a) -- replace ... with the actual color you want to use
GameTooltip.bg:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a) -- replace ... with the actual color you want to use
GameTooltip.bg:SetFrameLevel(0)



