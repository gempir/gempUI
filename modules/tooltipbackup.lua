
  ---------------------------------------------
  --  rTooltip
  ---------------------------------------------

  --  A simple tooltip mod
  --  zork - 2013

  ---------------------------------------------
  
  ---------------------------------------------
  --  CONFIG
  ---------------------------------------------
  
  local cfg = {}
  
  cfg.pos   = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -6, 6 }
  cfg.scale = 1
  cfg.font = {}
  cfg.font.family = "Interface\\Addons\\gempUI\\media\\fonts\\roboto.ttf"
  
  if gempUI.tooltip_alternative then
    cfg.pos   = { "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -100, 190 }
  end
  
  ---------------------------------------------
  --  VARIABLES
  ---------------------------------------------
  
  local unpack, type = unpack, type
  local RAID_CLASS_COLORS = RAID_CLASS_COLORS
  local FACTION_BAR_COLORS = FACTION_BAR_COLORS
  local WorldFrame = WorldFrame
  local GameTooltip = GameTooltip
  local GameTooltipStatusBar = GameTooltipStatusBar
    
  ---------------------------------------------
  --  FUNCTIONS
  ---------------------------------------------

  --change some text sizes
  GameTooltipHeaderText:SetFont(cfg.font.family, 14, "NONE")
  GameTooltipText:SetFont(cfg.font.family, 12, "NONE")
  Tooltip_Small:SetFont(cfg.font.family, 11, "NONE")
  
  --gametooltip statusbar
  
  GameTooltipStatusBar:ClearAllPoints()
  GameTooltipStatusBar:SetPoint("LEFT",1,0)
  GameTooltipStatusBar:SetPoint("RIGHT",-1,0)
  GameTooltipStatusBar:SetPoint("BOTTOM",GameTooltipStatusBar:GetParent(),"TOP",0,0)  
  GameTooltipStatusBar:SetHeight(3)
  GameTooltipStatusBar:SetStatusBarTexture([[Interface\AddOns\gempUI\textures\flat.tga]])
  --gametooltip statusbar bg
  GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil,"BACKGROUND",nil,-8)
  GameTooltipStatusBar.bg:SetPoint("TOPLEFT",-1,1)
  GameTooltipStatusBar.bg:SetPoint("BOTTOMRIGHT",1,-1)
  GameTooltipStatusBar.bg:SetTexture(1,1,1)
  GameTooltipStatusBar.bg:SetVertexColor(0,0,0,0.7)
  
  --HookScript GameTooltip OnTooltipCleared
  GameTooltip:HookScript("OnTooltipCleared", function(self)
    GameTooltip_ClearStatusBars(self)
  end)

  --hooksecurefunc GameTooltip_SetDefaultAnchor
  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
    if cursor and GetMouseFocus() == WorldFrame then
      tooltip:SetOwner(parent, "ANCHOR_CURSOR")
    else
      tooltip:SetOwner(parent, "ANCHOR_NONE")
      tooltip:SetPoint(unpack(cfg.pos))
    end
  end)

  --func TooltipOnShow
  local function TooltipOnShow(self,...)
    
    self:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
    self:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
    local itemName, itemLink = self:GetItem()
    if itemLink then
      local itemRarity = select(3,GetItemInfo(itemLink))
      if itemRarity then
        self:SetBackdropBorderColor(unpack({GetItemQualityColor(itemRarity)}))
      end
    end
  end
  

  local tooltips = { GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, WorldMapTooltip, }
for idx, tooltip in ipairs(tooltips) do
  tooltip:SetBackdrop({
    bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
    edgeFile = [[Interface\Buttons\WHITE8x8]],
    edgeSize = 1,
  })
  tooltip:SetBackdropColor(1,1,1,1);
  tooltip:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)

  tooltip:SetScale(cfg.scale)
  tooltip:HookScript("OnShow", TooltipOnShow)
end



--- This changes the color of the name inside the tooltip, also the healthbar when you remove the comment

   --func GetHexColor
  local function GetHexColor(color)
    return ("%.2x%.2x%.2x"):format(color.r*255, color.g*255, color.b*255)
  end
  
  local classColors, reactionColors = {}, {}
  
  for class, color in pairs(RAID_CLASS_COLORS) do 
    classColors[class] = GetHexColor(RAID_CLASS_COLORS[class]) 
  end
  
  for i = 1, #FACTION_BAR_COLORS do
    reactionColors[i] = GetHexColor(FACTION_BAR_COLORS[i])
  end

   local function GetTarget(unit)
    if UnitIsUnit(unit, "player") then
      return ("|cffff0000%s|r"):format("<YOU>")
    elseif UnitIsPlayer(unit, "player")then
      return ("|cff%s%s|r"):format(classColors[select(2, UnitClass(unit))], UnitName(unit))
    elseif UnitReaction(unit, "player") then
      return ("|cff%s%s|r"):format(reactionColors[UnitReaction(unit, "player")], UnitName(unit))
    else
      return ("|cffffffff%s|r"):format(UnitName(unit))
    end
  end

--HookScript GameTooltip OnTooltipSetUnit
  GameTooltip:HookScript("OnTooltipSetUnit", function(self,...)
    local unit = select(2, self:GetUnit()) or (GetMouseFocus() and GetMouseFocus():GetAttribute("unit")) or (UnitExists("mouseover") and "mouseover")
    if not unit or (unit and type(unit) ~= "string") then return end
    if not UnitGUID(unit) then return end
    local ricon = GetRaidTargetIndex(unit)
    if ricon then
      local text = GameTooltipTextLeft1:GetText()
      GameTooltipTextLeft1:SetText(("%s %s"):format(ICON_LIST[ricon].."14|t", text))
    end
    for i = 2, GameTooltip:NumLines() do
      local line = _G["GameTooltipTextLeft"..i]
      if line then
        line:SetTextColor(1,1,1)
      end
    end
    if UnitIsPlayer(unit) then
      local _, unitClass = UnitClass(unit)
      local color = RAID_CLASS_COLORS[unitClass]
      GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
      GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
      if UnitIsAFK(unit) then
        self:AppendText(" |cff00cccc<AFK>|r")
      elseif UnitIsDND(unit) then
        self:AppendText(" |cffcc0000<DND>|r")
      end
      local unitGuild = GetGuildInfo(unit)
      local text = GameTooltipTextLeft2:GetText()
      if unitGuild and text and text:find("^"..unitGuild) then
        GameTooltipTextLeft2:SetText(""..text.."")
        GameTooltipTextLeft2:SetTextColor(39/255, 174/255, 96/255)
      end
    else
      local reaction = UnitReaction(unit, "player")
      if reaction then
        local color = FACTION_BAR_COLORS[reaction]
        if color then
          --GameTooltipStatusBar:SetStatusBarColor(color.r,color.g,color.b)
          GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
        end
      end
      
      local unitClassification = UnitClassification(unit)
        
      
    end
    
    if UnitIsGhost(unit) then
      self:AppendText(" |cffaaaaaa<GHOST>|r")
      GameTooltipTextLeft1:SetTextColor(0.5,0.5,0.5)
    elseif UnitIsDead(unit) then
      self:AppendText(" |cffaaaaaa<DEAD>|r")
      GameTooltipTextLeft1:SetTextColor(0.5,0.5,0.5)
    end
    
    if (UnitExists(unit.."target")) then
      GameTooltip:AddDoubleLine("|cffff9999Target|r",GetTarget(unit.."target") or "Unknown")
      GameTooltip:Show()
    end
    
  end)
  
