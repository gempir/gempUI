local F, G = unpack(select(2, ...))

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
	string:SetShadowOffset(1, -1)
	string:SetTextColor(r, g, b)
	if justify then
		string:SetJustifyH(justify)
	end
	return string
end

-----------------------------------------------------------------------------------------

local hider = CreateFrame("Frame", "Hider", G.frame)
hider:Hide()