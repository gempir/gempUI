local F, G, V = unpack(select(2, ...))

-- thanks to Resike for these two
-- these get Info about specific frames
function GetFrameInfoFromCursor()
	local fn = GetMouseFocus():GetName()
	local f = _G[fn]
	print("|cFF50C0FF" .. "<---------------------------------------------->" .. "|r")
	print("|cFF50C0FF" .. "Frame:" .. "|r", fn)
	local p = f:GetParent()
	print("|cFF50C0FF" .. "Parent:" .. "|r", p:GetName())
	for i = 1, f:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint(i)
		if point and relativeTo and relativePoint and xOfs and yOfs then
			print(i .. ".", "|cFF50C0FF" .. "p:" .. "|r", point, "|cFF50C0FF" .. "rfn:" .. "|r", relativeTo:GetName(), "|cFF50C0FF" .. "rp:" .. "|r", relativePoint, "|cFF50C0FF" .. "x:" .. "|r", xOfs, "|cFF50C0FF" .. "y:" .. "|r", yOfs)
		end
	end
	print("|cFF50C0FF" .. "Scale:" .. "|r", f:GetScale())
	print("|cFF50C0FF" .. "Effective Scale:" .. "|r", f:GetEffectiveScale())
	print("|cFF50C0FF" .. "Protected:" .. "|r", f:IsProtected())
	print("|cFF50C0FF" .. "Strata:" .. "|r", f:GetFrameStrata())
	print("|cFF50C0FF" .. "Level:" .. "|r", f:GetFrameLevel())
	print("|cFF50C0FF" .. "Width:" .. "|r", f:GetWidth())
	print("|cFF50C0FF" .. "Height:" .. "|r", f:GetHeight())
end

function GetFrameInfo(f)
	local fn = f:GetName()
	print("|cFF50C0FF" .. "<---------------------------------------------->" .. "|r")
	print("|cFF50C0FF" .. "Frame:" .. "|r", fn)
	local p = f:GetParent()
	print("|cFF50C0FF" .. "Parent:" .. "|r", p:GetName())
	for i = 1, f:GetNumPoints() do
		local point, relativeTo, relativePoint, xOfs, yOfs = f:GetPoint(i)
		if point and relativeTo and relativePoint and xOfs and yOfs then
			print(i .. ".", "|cFF50C0FF" .. "p:" .. "|r", point, "|cFF50C0FF" .. "rfn:" .. "|r", relativeTo:GetName(), "|cFF50C0FF" .. "rp:" .. "|r", relativePoint, "|cFF50C0FF" .. "x:" .. "|r", xOfs, "|cFF50C0FF" .. "y:" .. "|r", yOfs)
		end
	end
	print("|cFF50C0FF" .. "Scale:" .. "|r", f:GetScale())
	print("|cFF50C0FF" .. "Effective Scale:" .. "|r", f:GetEffectiveScale())
	print("|cFF50C0FF" .. "Protected:" .. "|r", f:IsProtected())
	print("|cFF50C0FF" .. "Strata:" .. "|r", f:GetFrameStrata())
	print("|cFF50C0FF" .. "Level:" .. "|r", f:GetFrameLevel())
	print("|cFF50C0FF" .. "Width:" .. "|r", f:GetWidth())
	print("|cFF50C0FF" .. "Height:" .. "|r", f:GetHeight())
end

--[[
 create a frame that adds a 1px border
 * object parent - parent of new frame
 * object anchor - frame that the new frame will be attached to
 * bool extend - 1px outside of the anchor or outside
]] --
function F.createBorderFrame(parent, anchor, extend)
	local frame = CreateFrame('Frame', nil, parent)
	frame:SetFrameStrata('MEDIUM')
	if extend then
		frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', -1, 1)
		frame:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 1, -1)
	else
		frame:SetPoint('TOPLEFT', anchor, 'TOPLEFT', 0, 0)
		frame:SetPoint('BOTTOMRIGHT', anchor, 'BOTTOMRIGHT', 0, 0)
	end
	frame:SetBackdrop({
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1
	})
	frame:SetBackdropColor(0, 0, 0, 0)
	frame:SetBackdropBorderColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)
	return frame
end




