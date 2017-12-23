local F, G, V = unpack(select(2, ...))

function F.rebackdrop(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]],
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		edgeSize = 1,
	})
	frame:SetBackdropColor(unpack(G.colors.base))
	frame:SetBackdropBorderColor(unpack(G.colors.border))
end

function F.rebackdroplight(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]],
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		edgeSize = 1,
	})
	frame:SetBackdropColor(G.colors.base[1] + 0.05, G.colors.base[2] + 0.05, G.colors.base[3] + 0.05, G.colors.base[4])
	frame:SetBackdropBorderColor(unpack(G.colors.border))
end