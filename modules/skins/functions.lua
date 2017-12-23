local F, G, V = unpack(select(2, ...))

function F.rebackdrop(frame)
    frame:SetBackdrop(nil)
    frame:SetBackdrop({
        bgFile = [[Interface\Buttons\WHITE8x8]],
        edgeFile = [[Interface\Buttons\WHITE8x8]],
        edgeSize = 1,
    })
    frame:SetBackdropColor(G.color.r,G.color.g,G.color.b,G.color.a)
    frame:SetBackdropBorderColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)
end

function F.rebackdroplight(frame)
    frame:SetBackdrop(nil)
    frame:SetBackdrop({
        bgFile = [[Interface\Buttons\WHITE8x8]],
        edgeFile = [[Interface\Buttons\WHITE8x8]],
        edgeSize = 1,
    })
    frame:SetBackdropColor(G.color.r+0.05,G.color.g+0.05,G.color.b+0.05,G.color.a)
    frame:SetBackdropBorderColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)
end