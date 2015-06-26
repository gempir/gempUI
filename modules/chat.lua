
  -- // rChat
  -- // zork - 2012


  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = ns.cfg

  --add more chat font sizes
  for i = 1, 23 do
    CHAT_FONT_HEIGHTS[i] = i+7
  end

  --hide the menu button
  ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
  ChatFrameMenuButton:Hide()

  --hide the friend micro button
  FriendsMicroButton:HookScript("OnShow", FriendsMicroButton.Hide)
  FriendsMicroButton:Hide()

  --don't cut the toastframe
  BNToastFrame:SetClampedToScreen(true)
  BNToastFrame:SetClampRectInsets(-15,15,15,-15)

  ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
 
  -----------------------------
  -- FUNCTIONS
  -----------------------------

  local function skinChat(self)
    if not self or (self and self.skinApplied) then return end

    local name = self:GetName()

    --chat frame resizing
    self:SetClampRectInsets(0, 0, 0, 0)
    self:SetMaxResize(UIParent:GetWidth(), UIParent:GetHeight())
    self:SetMinResize(100, 50)

    --set font, outline and shadow for chat text
    self:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    self:SetShadowOffset(1,-1)
    self:SetShadowColor(0,0,0,0.6)

    --fix the buttonframe
    local frame = _G[name.."ButtonFrame"]
    frame:Hide()
    frame:HookScript("OnShow", frame.Hide)

    --editbox skinning
    _G[name.."EditBoxLeft"]:Hide()
    _G[name.."EditBoxMid"]:Hide()
    _G[name.."EditBoxRight"]:Hide()
    _G[name.."EditBoxFocusLeft"]:SetTexture(nil)
    _G[name.."EditBoxFocusRight"]:SetTexture(nil)
    _G[name.."EditBoxFocusMid"]:SetTexture(nil)

    local eb = _G[name.."EditBox"]
    eb:SetAltArrowKeyMode(false)
    eb:ClearAllPoints()
    eb:SetPoint("BOTTOM",self,"TOP",0,22)
    eb:SetPoint("LEFT",self,-5,0)
    eb:SetPoint("RIGHT",self,10,0)
    eb:SetHeight(20)
    eb:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
		insets = {left = -0, right = -0, top = -0, bottom = -0} 
					})
	eb:SetBackdropColor(0,0,0,0.5)
	eb:SetBackdropBorderColor(0,0,0,1)

  end

  -----------------------------
  -- CALL
  -----------------------------

  --chat skinning
  for i = 1, NUM_CHAT_WINDOWS do
    skinChat(_G["ChatFrame"..i])
  end

  --skin temporary chats
  hooksecurefunc("FCF_OpenTemporaryWindow", function()
    for _, chatFrameName in pairs(CHAT_FRAMES) do
      local frame = _G[chatFrameName]
      if (frame.isTemporary) then
        skinChat(frame)
      end
    end
  end)

  local a = CreateFrame("Frame")
  a:RegisterEvent("PLAYER_LOGIN")
  a:SetScript("OnEvent", fixStuffOnLogin)


-- Opacity of the currently selected chat tab.
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0

-- Opacity of currently alerting chat tabs.
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0

-- Opacity of non-selected, non-alerting chat tabs.
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 1
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0

-- Redoes some loot messages 

-- self 
CURRENCY_GAINED = "Currency: %s";
CURRENCY_GAINED_MULTIPLE = "Currency: %s x%d";
CURRENCY_GAINED_MULTIPLE_BONUS = "Currency: %s x%d (Bonus)";
LOOT_ITEM_BONUS_ROLL_SELF = "Loot: %s  (Bonus)";
LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE = "Loot: %sx%d (Bonus)";
LOOT_ITEM_CREATED_SELF = "Create: %s";
LOOT_ITEM_CREATED_SELF_MULTIPLE = "Create: %sx%d";
LOOT_ITEM_PUSHED_SELF = "Loot: %s";
LOOT_ITEM_PUSHED_SELF_MULTIPLE = "Loot: %sx%d";
LOOT_ITEM_REFUND = "Refund: %s";
LOOT_ITEM_REFUND_MULTIPLE = "Refund: %sx%d";
LOOT_ITEM_SELF = "Loot: %s";
LOOT_ITEM_SELF_MULTIPLE = "Loot: %sx%d";

-- players
LOOT_ITEM = "%s loots: %s";
LOOT_ITEM_BONUS_ROLL = "%s loots: %s (Bonus)";
LOOT_ITEM_BONUS_ROLL_MULTIPLE = "%s loots: %sx%d";
LOOT_ITEM_MULTIPLE = "%s loots: %sx%d";
LOOT_ITEM_PUSHED = "%s loots: %s";
LOOT_ITEM_PUSHED_MULTIPLE = "%s loots: %sx%d";

-- shorten cahnnel names


CHAT_GUILD_GET                = "[G]|h%s:\32"
CHAT_INSTANCE_CHAT_GET        = "[I] |h%s:\32"
CHAT_INSTANCE_CHAT_LEADER_GET = "[I] |h%s:\32"
CHAT_OFFICER_GET              = "[G]|h%s:\32"
CHAT_PARTY_GET                = "[P]|h%s:\32"
CHAT_PARTY_GUIDE_GET          = "[P]|h%s:\32"
CHAT_PARTY_LEADER_GET         = "[P]|h%s:\32"
CHAT_RAID_GET                 = "[R] |h%s:\32"
CHAT_RAID_LEADER_GET          = "[R] |h%s:\32"
CHAT_RAID_WARNING_GET         = "[R] %s:\32"
CHAT_SAY_GET                  = "[S]%s:\32"
CHAT_YELL_GET                 = "[S]%s:\32"

