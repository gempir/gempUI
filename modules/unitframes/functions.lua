local F, G, V = unpack(select(2, ...))

framebd = function(parent, anchor)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetFrameStrata('BACKGROUND')
	frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', 0, 0)
	frame:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 0, 0)
	frame:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1,
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=]
	})
	frame:SetBackdropColor(unpack(G.colors.base))
	frame:SetBackdropBorderColor(unpack(G.colors.border))
	return frame
end

-----------------------------------------------------------------------------------------
local function fixStatusbar(bar)
	bar:GetStatusBarTexture():SetHorizTile(false)
	bar:GetStatusBarTexture():SetVertTile(false)
end

function createStatusbar(parent, tex, layer, height, width, r, g, b, alpha)
	local bar = CreateFrame 'StatusBar'
	bar:SetParent(parent)
	if height then
		bar:SetHeight(height)
	end
	if width then
		bar:SetWidth(width)
	end
	bar:SetStatusBarTexture(tex, layer)
	bar:SetStatusBarColor(r, g, b, alpha)
	fixStatusbar(bar)
	return bar
end

-----------------------------------------------------------------------------------------
function fs(parent, layer, font, fontsiz, outline, r, g, b, justify)
	local string = parent:CreateFontString(nil, layer)
	string:SetFont(font, fontsiz, outline)
	string:SetShadowOffset(0, 0)
	string:SetTextColor(r, g, b)
	if justify then
		string:SetJustifyH(justify)
	end
	return string
end

-----------------------------------------------------------------------------------------

local hider = CreateFrame("Frame", "Hider", UIParent)
hider:Hide()