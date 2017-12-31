local F, G, V = unpack(select(2, ...))
local name, ns = ...
local oUF = ns.oUF

local CustomFilter = function(icons, ...)
	local _, icon, name, _, _, _, _, _, _, caster = ...
	if (caster == 'player' or caster == 'vechicle') then
		return true
	end
	return false
end

local auraIcon = function(auras, button)
	auras.disableCooldown = false
	auras.showDebuffType = true

	button.overlay:SetTexture(nil)
	button.icon:SetTexCoord(.1, .9, .1, .9)
	F.createBorder(button, button, true)
end

-- Nameplates
oUF:RegisterStyle("gempUI - Nameplates", function(self, unit)
	if not unit:match("nameplate") then
		return
	end

	

	local health = CreateFrame("StatusBar", nil, self)
	health:SetAllPoints()
	health:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
	health.colorHealth = true
	health.colorTapping = true
	health.colorDisconnected = true
	health.frequentUpdates = true

	local border = CreateFrame("Frame", nil, health)
	border:SetFrameStrata("BACKGROUND")
	border:SetWidth(G.nameplates.width + 2)
	border:SetHeight(G.nameplates.height + 2)
	border:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]],
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		edgeSize = 1,
	})
	border:SetBackdropColor(unpack(G.colors.base))
	border:SetBackdropBorderColor(unpack(G.colors.border))
	border:SetPoint("BOTTOM", 0, -1)
	border:Show()


	self.Health = health


	self.Namecontainer = CreateFrame("frame", nil, self)
	self.Name = self.Namecontainer:CreateFontString(nil)
	self.Name:SetShadowOffset(1, -1)
	self.Name:SetTextColor(1, 1, 1)
	self.Name:ClearAllPoints()
	self.Name:SetFont(G.fonts.square, G.nameplates.fontsize)
	self.Name:SetShadowColor(0, 0, 0)
	self.Name:SetPoint("BOTTOM", self, "TOP", 0, 2)
	self:Tag(self.Name, '[name]')


	local cb = createStatusbar(self, G.texture, nil, nil, nil, unpack(G.colors.base))

	cb.Text = fs(cb, 'OVERLAY', G.fonts.square, G.nameplates.fontsize - 1, G.nameplates.fontflag, 1, 1, 1, 'LEFT')
	cb.Text:SetPoint('LEFT', cb, 2, 0)
	cb.CastingColor = G.colors.base
	cb.CompleteColor = { 0.12, 0.86, 0.15, G.colors.base[4] }
	cb.FailColor = { 1.0, 0.09, 0, G.colors.base[4] }
	cb.ChannelingColor = { 0.32, 0.3, G.colors.base[4] }
	cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
	cb.Icon:SetPoint('TOPRIGHT', cb, 'TOPLEFT', -1, 0)
	cb.Icon:SetTexCoord(.1, .9, .1, .9)

	cb:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", G.nameplates.height + 1, -1)
	cb:SetSize(G.nameplates.width - G.nameplates.height - 1, G.nameplates.height)
	cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())

	cb.Spark = cb:CreateTexture(nil, 'OVERLAY')
	cb.Spark:SetTexture([=[Interface\Buttons\WHITE8x8]=])
	cb.Spark:SetBlendMode('Add')
	cb.Spark:SetHeight(cb:GetHeight() - 2)
	cb.Spark:SetWidth(1)
	cb.Spark:SetVertexColor(1, 1, 1)


	cb.OnUpdate = OnCastbarUpdate
	cb.PostCastStart = PostCastStart
	cb.PostChannelStart = PostCastStart
	cb.PostCastStop = PostCastStop
	cb.PostChannelStop = PostCastStop
	cb.PostCastFailed = PostCastFailed
	cb.PostCastInterrupted = PostCastFailed


	cb.Backdrop = F.createBorder(cb, cb, true)
	cb.IBackdrop = F.createBorder(cb, cb.Icon, true)
	self.Castbar = cb

	self.Castbar.Shield = self.Castbar:CreateTexture(nil, 'OVERLAY')
	self.Castbar.Shield:SetSize(self.Castbar:GetHeight(), self.Castbar:GetHeight())
	self.Castbar.Shield:SetPoint('LEFT', self.Castbar.Icon)
	self.Castbar.Shield:SetTexture(G.media .. "textures\\shield")

	self.Debuffs = CreateFrame("Frame", nil, self)
	self.Debuffs:ClearAllPoints()
	self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 13)
	self.Debuffs:SetSize(cb:GetWidth(), 24)
	self.Debuffs.size = 24
	self.Debuffs:EnableMouse(false)
	self.Debuffs.onlyShowPlayer = true
	self.Debuffs.disableMouse = true
	self.Debuffs.size = 24
	self.Debuffs.initialAnchor  = "BOTTOMLEFT"
	self.Debuffs.spacing = 4
	self.Debuffs.num = 20
	self.Debuffs['growth-y'] = "UP"
	self.Debuffs.PostCreateIcon = auraIcon

	self:EnableMouse(false) -- For some off reason we need this so we can click our plates..??
	self.Health:EnableMouse(false) 
	self:SetScale(UIParent:GetEffectiveScale() * 1)
	self:SetSize(G.nameplates.width, G.nameplates.height)
	self:SetPoint("CENTER", 0, -25)
end)

oUF:SpawnNamePlates()
