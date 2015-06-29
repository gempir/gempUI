-- redoes a lot of simple tooltips like the micromenu on the minimap
gempUI_rebackdrop(DropDownList1MenuBackdrop)
gempUI_rebackdrop(ItemRefTooltip)

-- font changes

GameTooltipHeaderText:SetFont(gempUI_fonts_roboto, 14, "NONE")
GameTooltipText:SetFont(gempUI_fonts_roboto, 12, "NONE")
Tooltip_Small:SetFont(gempUI_fonts_roboto, 11, "NONE")


GameTooltip.bg = CreateFrame("Frame", nil, GameTooltip)
GameTooltip.bg:SetAllPoints(true)
GameTooltip.bg:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -0, right = -0, top = -0, bottom = -0} 
					}) -- or just set this to your own backdrop
GameTooltip:SetBackdrop(nil)

GameTooltip.bg:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a) -- replace ... with the actual color you want to use
GameTooltip.bg:SetFrameLevel(0)



GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("LEFT",1,0)
GameTooltipStatusBar:SetPoint("RIGHT",-1,0)
GameTooltipStatusBar:SetPoint("BOTTOM",GameTooltipStatusBar:GetParent(),"TOP",0,0)  
GameTooltipStatusBar:SetHeight(3)
GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\gempUI\\textures\\flat.tga")

GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil,"BACKGROUND",nil,-8)
GameTooltipStatusBar.bg:SetPoint("TOPLEFT",-1,1)
GameTooltipStatusBar.bg:SetPoint("BOTTOMRIGHT",1,-1)
GameTooltipStatusBar.bg:SetTexture(1,1,1)
GameTooltipStatusBar.bg:SetVertexColor(0,0,0,0.7)


-- item border (thank you Zork)

local function TooltipOnShow(self,...)
    
    local itemName, itemLink = self:GetItem()
    if itemLink then
      local itemRarity = select(3,GetItemInfo(itemLink))
      if itemRarity then
        GameTooltip.bg:SetBackdropBorderColor(unpack({GetItemQualityColor(itemRarity)}))
      end
    else
    	GameTooltip.bg:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a) 
    end
  end

local tooltips = { GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, }
for idx, tooltip in ipairs(tooltips) do

   tooltip:HookScript("OnShow", TooltipOnShow)
end

-- target line (thank you again Zork)

