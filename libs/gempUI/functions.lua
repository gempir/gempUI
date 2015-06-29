function gempUI_rebackdrop(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
	})
	frame:SetBackdropColor(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
	frame:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
end

function gempUI_rebackdropdark(frame)
	frame:SetBackdrop(nil)
	frame:SetBackdrop({
	bgFile = [[Interface\Buttons\WHITE8x8]],
	edgeFile = [[Interface\Buttons\WHITE8x8]],
	edgeSize = 1,
	})
	frame:SetBackdropColor(gempUIcolor.r+0.05,gempUIcolor.g+0.05,gempUIcolor.b+0.05,gempUIcolor.a)
	frame:SetBackdropBorderColor(gempUIbordercolor.r, gempUIbordercolor.g, gempUIbordercolor.b, gempUIbordercolor.a)
end

function gempUI_retexture(frame)
	frame:SetTexture(nil)
	frame:SetTexture(gempUIcolor.r,gempUIcolor.g,gempUIcolor.b,gempUIcolor.a)
end

function gempUI_textureclear(t)
	local setting
	hooksecurefunc(t, "SetTexture", function(self)
	    if setting then
	        return
	    end
	    setting = true
	    t:SetTexture(nil)
	    setting = nil
	end)
	t:SetTexture(nil)
end