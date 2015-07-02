local F, G, V = unpack(select(2, ...))

buttonsize = 30         -- Buff Size
spacing = 4             -- Buff Spacing
buffsperrow = 12        -- Buffs Per Row
growthvertical = 1      -- Growth Direction. 1 = down, 2 = up
growthhorizontal = 1    -- Growth Direction. 1 = left, 2 = right
font = G.fonts.square

-- Default Spawn Positions
local positions = {
    [1]  =  { p = "TOPRIGHT",   a = UIParent,   x = -181,    y = 3  },  -- Buff Anchor
    [2]  =  { p = "TOPRIGHT",   a = UIParent,   x = -181,    y = -143  },  -- Debuff Anchor
    [3]  =  { p = "TOPRIGHT",   a = UIParent,   x = 0,    y = -110  },  -- Enchant Anchor
}
--End Config

local function anchor(frame, r, g, b, pos, anchor, x, y)
    frame:SetBackdrop({
        bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1, 
        insets = {left = -0, right = -0, top = -0, bottom = -0} 
                    })
    frame:SetBackdropColor(r, g, b, 1)
    frame:SetHeight(buttonsize)
    frame:SetWidth(buttonsize)
    frame:SetPoint(pos, anchor, pos, x, y)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:SetFrameStrata("BACKGROUND")
    frame:SetAlpha(0)
end

local function MoveFunc(frame)
    if movebars==1 then
        frame:SetAlpha(1)
        frame:RegisterForDrag("LeftButton","RightButton")
        frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
        frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
        frame:SetFrameStrata("DIALOG")
    elseif movebars==0 then
        frame:SetAlpha(0)
        frame:SetScript("OnDragStart", function(self) self:StopMovingOrSizing() end)
        frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
        frame:SetFrameStrata("BACKGROUND")
    end
end

local buffholder = CreateFrame("Frame", "Buffs", UIParent)
anchor(buffholder, 0, 1, 0, positions[1].p, positions[1].a, positions[1].x, positions[1].y)
local debuffholder = CreateFrame("Frame", "Debuffs", UIParent)
anchor(debuffholder, 1, 0, 0, positions[2].p, positions[2].a, positions[2].x, positions[2].y)
local enchantholder = CreateFrame("Frame", "TempEnchants", UIParent)
anchor(enchantholder, 0, 0, 1, positions[3].p, positions[3].a, positions[3].x, positions[3].y)



local function makeitgrow(button, index, anchor)
    for i = 1, BUFF_ACTUAL_DISPLAY do 
        if growthvertical == 1 then
            if growthhorizontal == 1 then
                if index == ((buffsperrow*i)+1) then _G[button..index]:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", 0, -(buttonsize+spacing+4)*i) end
            else
                if index == ((buffsperrow*i)+1) then _G[button..index]:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, -(buttonsize+spacing+4)*i) end
            end
        else
            if growthhorizontal == 1 then
                if index == ((buffsperrow*i)+1) then _G[button..index]:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", 0, (buttonsize+spacing+4)*i) end
            else
                if index == ((buffsperrow*i)+1) then _G[button..index]:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, (buttonsize+spacing+4)*i) end
            end
        end
    end
    if growthhorizontal == 1 then
        _G[button..index]:SetPoint("RIGHT", _G[button..(index-1)], "LEFT", -(spacing+4), 0)
    else
        _G[button..index]:SetPoint("LEFT", _G[button..(index-1)], "RIGHT", (spacing+4), 0)
    end
end

local function StyleBuffs(button, index, framekind, anchor)
    local buff = button..index
    _G[buff.."Icon"]:SetTexCoord(.1, .9, .1, .9)
    _G[buff.."Icon"]:SetDrawLayer("OVERLAY")
    _G[buff]:ClearAllPoints()
    _G[buff]:SetHeight(buttonsize)
    _G[buff]:SetWidth(buttonsize)
    _G[buff]:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8x8", insets = { left = -1, right = -1, top = -1, bottom = -1}})
    
    if framekind == 2 then _G[buff]:SetBackdropColor(.7,0,0,1)
    elseif framekind == 3 then _G[buff]:SetBackdropColor(0,0,.5,1)
    else _G[buff]:SetBackdropColor(0,0,0,1) end
    
    _G[buff.."Count"]:SetFont(font, 12, "THINOUTLINE")
    _G[buff.."Duration"]:SetFont(font, 12, "THINOUTLINE")
    
    _G[buff.."Count"]:ClearAllPoints()
    _G[buff.."Count"]:SetPoint("TOPRIGHT", 1, -1)
    _G[buff.."Count"]:SetDrawLayer("OVERLAY")
    
    _G[buff.."Duration"]:ClearAllPoints()
    _G[buff.."Duration"]:SetPoint("BOTTOM")
    _G[buff.."Duration"]:SetDrawLayer("OVERLAY")
    if _G[buff.."Border"] then _G[buff.."Border"]:Hide() end
    
    if index == 1 then _G[buff]:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", -10, -10) end
    if index ~= 1 then makeitgrow(button, index, _G[button..1]) end
end

local function UpdateBuff()
    for i = 1, BUFF_ACTUAL_DISPLAY do
        StyleBuffs("BuffButton", i, 1, buffholder)
    end
    for i = 1, BuffFrame.numEnchants do
        StyleBuffs("TempEnchant", i, 3, enchantholder)
    end
end
local function UpdateDebuff(buttonName, index)
    StyleBuffs(buttonName, index, 2, debuffholder)
end

local function updateTime(button, timeLeft)
    local duration = _G[button:GetName().."Duration"]
    if SHOW_BUFF_DURATIONS == "1" and timeLeft then
        duration:SetTextColor(1, 1, 1)
        local d, h, m, s = ChatFrame_TimeBreakDown(timeLeft);
        if d > 0 then
            duration:SetFormattedText("%1dd", d)
        elseif h > 0 then
            duration:SetFormattedText("%1dh", h)
        elseif m > 0 then
            duration:SetFormattedText("%1dm", m)
        else
            duration:SetFormattedText("%1d", s)
        end
    end
end

hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuff)
hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuff)
hooksecurefunc("AuraButton_UpdateDuration", updateTime)
SetCVar("consolidateBuffs", 0)