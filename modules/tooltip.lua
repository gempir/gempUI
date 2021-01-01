local F, G = unpack(select(2, ...))


GameTooltipHeaderText:SetFont(G.fonts.roboto, 14, "NONE")
GameTooltipText:SetFont(G.fonts.roboto, 12, "NONE")
Tooltip_Small:SetFont(G.fonts.roboto, 11, "NONE")

local tooltips = {
	'GameTooltip',
	'ItemRefTooltip',
	'ItemRefShoppingTooltip1',
	'ItemRefShoppingTooltip2',
	'ShoppingTooltip1',
	'ShoppingTooltip2',
	'DropDownList1MenuBackdrop',
	'DropDownList2MenuBackdrop',
}

for key, value in pairs(tooltips) do
	if not _G[value] then
		print("Broken tooltips: " + value)
	else 
		_G[value]:SetBackdrop(nil)
		F.addBackdrop(_G[value])

		_G[value].bg = CreateFrame("Frame", nil, GameTooltip)
		_G[value].bg:SetAllPoints(true)
		_G[value].bg:SetFrameLevel(0)
	end
end

GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("LEFT", 0, 0)
GameTooltipStatusBar:SetPoint("RIGHT", 0, 0)
GameTooltipStatusBar:SetPoint("BOTTOM", GameTooltipStatusBar:GetParent(), "TOP", 0, 0)
GameTooltipStatusBar:SetHeight(3)
GameTooltipStatusBar:SetStatusBarTexture("Interface\\AddOns\\gempUI\\textures\\flat.tga")

GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil, "BACKGROUND", nil, -8)
GameTooltipStatusBar.bg:SetPoint("TOPLEFT", -1, 1)
GameTooltipStatusBar.bg:SetPoint("BOTTOMRIGHT", 1, -1)
GameTooltipStatusBar.bg:SetTexture(1, 1, 1)
GameTooltipStatusBar.bg:SetVertexColor(unpack(G.colors.border))


local function TooltipOnShow(self, ...)
	for key, value in pairs(tooltips) do
		_G[value]:SetBackdrop(nil)
		F.addBackdrop(_G[value])

		_G[value].bg = CreateFrame("Frame", nil, GameTooltip)
		_G[value].bg:SetAllPoints(true)
 		_G[value].bg:SetFrameLevel(0)
	end
	Mixin(GameTooltip.bg, BackdropTemplateMixin)

	local itemName, itemLink = self:GetItem()
	if itemLink then
		local itemRarity = select(3, GetItemInfo(itemLink))
		if itemRarity then
			GameTooltip.bg:SetBackdropBorderColor(unpack({ GetItemQualityColor(itemRarity) }))
		end
	else
		GameTooltip.bg:SetBackdropBorderColor(unpack(G.colors.border))
	end
end

local tooltips = { GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, }
for idx, tooltip in ipairs(tooltips) do
	tooltip:HookScript("OnShow", TooltipOnShow)
end