local F, G, V = unpack(select(2, ...))


-- font changes

GameTooltipHeaderText:SetFont(G.fonts.roboto, 14, "NONE")
GameTooltipText:SetFont(G.fonts.roboto, 12, "NONE")
Tooltip_Small:SetFont(G.fonts.roboto, 11, "NONE")


GameTooltip.bg = CreateFrame("Frame", nil, GameTooltip)
GameTooltip.bg:SetAllPoints(true)
GameTooltip.bg:SetBackdrop({
		bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -0, right = -0, top = -0, bottom = -0} 
					}) -- or just set this to your own backdrop
GameTooltip:SetBackdrop(nil)

GameTooltip.bg:SetBackdropColor(G.color.r,G.color.g,G.color.b,G.color.a) -- replace ... with the actual color you want to use
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
GameTooltipStatusBar.bg:SetVertexColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)


-- item border (thank you Zork)

local function TooltipOnShow(self,...)
    
    local itemName, itemLink = self:GetItem()
    if itemLink then
      local itemRarity = select(3,GetItemInfo(itemLink))
      if itemRarity then
        GameTooltip.bg:SetBackdropBorderColor(unpack({GetItemQualityColor(itemRarity)}))
      end
    else
    	GameTooltip.bg:SetBackdropBorderColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a) 
    end
  end

local tooltips = { GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, }
for idx, tooltip in ipairs(tooltips) do

   tooltip:HookScript("OnShow", TooltipOnShow)
end

-- target line (thank you again Zork)

