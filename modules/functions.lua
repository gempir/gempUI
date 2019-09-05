local F, G, V = unpack(select(2, ...)) --

--[[
 create a frame that adds a 1px border
 * object parent - parent of new frame
 * object anchor - frame that the new frame will be attached to
 * bool extend - 1px outside of the anchor or outside
]] function F.createBorder(
    parent,
    anchor,
    extend)
    if not anchor then
        anchor = parent
    end

    local frame = CreateFrame('Frame', nil, parent)
    frame:SetFrameStrata('BACKGROUND')
    if extend then
        frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -1, 1)
        frame:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 1, -1)
    else
        frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', 0, 0)
        frame:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 0, 0)
    end
    frame:SetBackdrop(
        {
            edgeFile = 'Interface\\Buttons\\WHITE8x8',
            edgeSize = 1
        }
    )
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(unpack(G.colors.border))
    return frame
end

function F.stripTextures(object, kill)
    for i = 1, object:GetNumRegions() do
        local region = select(i, object:GetRegions())
        if region:GetObjectType() == 'Texture' then
            if kill then
                region:Hide()
            else
                region:SetTexture(nil)
            end
        end
    end
end

function F.createFontString(parent)
    local fs = parent:CreateFontString(nil, 'OVERLAY')
    fs:SetFont(G.fonts.square, 14, '')
    fs:SetShadowOffset(1, -1)
    fs:SetPoint('CENTER', parent, 'CENTER', 0, 0)
    return fs
end

function F.sendToChat(cmd)
    local editbox = ChatEdit_ChooseBoxForSend(DEFAULT_CHAT_FRAME)
    ChatEdit_ActivateChat(editbox)
    editbox:SetText(cmd)
    ChatEdit_OnEnterPressed(editbox)
end

function F.createOverlay(element, anchor)
    if not anchor then
        anchor = element
    end

    local buttonOverlay = CreateFrame('Frame', nil, parent)
    buttonOverlay:SetPoint('TOPLEFT', anchor, 'TOPLEFT', 1, -1)
    buttonOverlay:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', -1, 1)
    buttonOverlay:SetBackdrop(
        {
            bgFile = [[Interface\Buttons\WHITE8x8]]
        }
    )
    buttonOverlay:SetBackdropColor(1, 1, 1, 0.15)
    buttonOverlay:SetFrameLevel(element:GetFrameLevel() + 1)
    buttonOverlay:Hide()

    element:SetScript(
        'OnEnter',
        function()
            buttonOverlay:Show()
        end
    )
    element:SetScript(
        'OnLeave',
        function()
            buttonOverlay:Hide()
        end
    )
end

function F.addBackdrop(frame)
    frame:SetBackdrop(
        {
            bgFile = 'Interface\\Buttons\\WHITE8x8',
            edgeFile = 'Interface\\Buttons\\WHITE8x8',
            edgeSize = 1,
            insets = {left = 0, right = 0, top = 0, bottom = 0}
        }
    )
    frame:SetBackdropColor(unpack(G.colors.base))
    frame:SetBackdropBorderColor(unpack(G.colors.border))
end

function F.addBackdropNoBorder(frame)
    frame:SetBackdrop(
        {
            bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=]
        }
    )
    frame:SetBackdropColor(unpack(G.colors.base))
end

function F.print(message)
    print('|cff00FF7Fg|rUI | ' .. message)
end

-- options

local optionFunctions = {}

local frame = CreateFrame('FRAME', 'SavedVarsFrame')
frame:RegisterEvent('ADDON_LOADED')
frame:SetScript(
    'OnEvent',
    function(self, event, arg1)
        if arg1 == 'gempUI' then
            self:UnregisterEvent('ADDON_LOADED')
            for key, value in pairs(optionFunctions) do --actualcode
                value()
            end
        end
    end
)

function F.onOptionsLoaded(func)
    table.insert(optionFunctions, func)
end
