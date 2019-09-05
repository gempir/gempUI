local F, G, V = unpack(select(2, ...))
local name, ns = ...
local oUF = ns.oUF 
local cfg = ns.cfg


local raidicons = G.media .. "unitframes\\raidicons"
local symbol = G.media .. "unitframes\\symbol.ttf"

local class_color = RAID_CLASS_COLORS[class]
local powerType, powerTypeString = UnitPowerType('player')
local class = select(2, UnitClass('player'))

local unitframes = {}

local OnEnter = function(self)
	UnitFrame_OnEnter(self)
	if self.Highlight then
		self.Highlight:Show()
	end
end

local OnLeave = function(self)
	UnitFrame_OnLeave(self)
	if self.Highlight then
		self.Highlight:Hide()
	end
end

local function auraWatchFilter(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, nameplateShowPersonal, spellID)
	return G.ace.db.profile.auraWatch[spellID] and unitCaster == "player"
end

local function createAuraBars(self, unit)
	self.AuraBars = CreateFrame("Frame", nil, self)
	self.AuraBars:SetSize(G.ace.db.profile.unitframes[unit].auraBarsWidth, 1)
	self.AuraBars.auraBarHeight = G.ace.db.profile.unitframes[unit].auraBarsHeight
	self.AuraBars:SetPoint("CENTER", G.ace.db.profile.unitframes[unit].auraBarsX, G.ace.db.profile.unitframes[unit].auraBarsY)

	self.AuraBars.auraBarTexture = G.texture
	self.AuraBars.color = G.colors.base
	self.AuraBars.bgalpha = 0
	self.AuraBars.spacing = G.ace.db.profile.unitframes[unit].auraBarsSpacing
	self.AuraBars.sort = true
	self.AuraBars.spellTimeFont = G.unitframes.font
	self.AuraBars.spellTimeSize = G.ace.db.profile.unitframes[unit].auraBarsFontSize
	self.AuraBars.filter = auraWatchFilter

	if unit == "target" then 
		self.AuraBars.reverse = true
	end
end

local auraIcon = function(auras, button)
	auras.disableCooldown = false
	auras.showDebuffType = true

	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetFrameStrata("MEDIUM")
	overlay:SetAllPoints(button)
	
	button.count:SetParent(overlay)
	button.count:SetFont(G.fonts.square, 10, "MONOCHROMEOUTLINE")
	button.count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 3, 0)

	button.overlay:SetTexture(nil)
	button.icon:SetTexCoord(.1, .9, .1, .9)
	F.createBorder(button, button, true)

	button:RegisterForClicks("MiddleButtonUp", "RightButtonUp")
end

local PostUpdateIcon = function(icons, unit, icon, index, offset)
	local name, _, _, _, dtype, duration, expirationTime, unitCaster, _, _, spellID = UnitAura(unit, index, icon.filter)
	local texture = icon.icon
	
	icon:SetScript("OnClick", function(self, button)
		if unit == "player" and button == "RightButton" then
			CancelUnitBuff("player", index)
		elseif button == "MiddleButton" then
			if G.ace.db.profile.auraWatch[spellID] then 
				G.ace.db.profile.auraWatch[spellID] = nil
				F.print(GetSpellLink(spellID) .. " is no longer tracked")
			else 
				G.ace.db.profile.auraWatch[spellID] = name
				F.print(GetSpellLink(spellID) .. " is now tracked")
			end
		end
	end)
	
	if icon.isPlayer or UnitIsFriend('player', unit) or not icon.isDebuff then
		texture:SetDesaturated(false)
	else
		texture:SetDesaturated(true)
	end
end


local CustomFilter = function(icons, ...)
	local _, icon, name, _, _, _, _, _, _, caster = ...

	if (caster == 'player' or caster == 'vechicle') then
		return true
	end

	return G.ace.db.profile.unitframes['target'].allDebuffs
end

local OnCastbarUpdate = function(self, elapsed)
	local currentTime = GetTime()
	if self.casting or self.channeling then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	elseif self.fadeOut then
		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end

local PostCastStart = function(self, unit)
	self:SetAlpha(1.0)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	if self.casting then
		self.cast = true
	else
		self.cast = false
	end
	if unit ~= 'player' and self.interrupt and UnitCanAttack('player', unit) then
		self:SetStatusBarColor(1, .9, .4)
	end
end

local PostCastStop = function(self, unit)
	if not self.fadeOut then
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.cast and self.max or 0)
	self:Show()
end

local PostCastFailed = function(self, event, unit)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end

local castbar = function(self, unit)
	local cb = createStatusbar(self, G.texture, nil, nil, nil, unpack(G.colors.base))

	cb.Time = fs(cb, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
	cb.Time:SetPoint('RIGHT', cb, -2, 0)
	cb.Text = fs(cb, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1, 'LEFT')
	cb.Text:SetPoint('LEFT', cb, 2, 0)
	cb.Text:SetPoint('RIGHT', cb.Time, 'LEFT')
	cb.CastingColor = G.colors.base
	cb.CompleteColor = { 0.12, 0.86, 0.15, G.colors.base[4] }
	cb.FailColor = { 1.0, 0.09, 0, G.colors.base[4] }
	cb.ChannelingColor = G.colors.base
	cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
	cb.Icon:SetPoint('TOPRIGHT', cb, 'TOPLEFT', -1, 0)
	cb.Icon:SetTexCoord(.1, .9, .1, .9)

	if self.unit == 'player' then
		cb:SetPoint('CENTER', UIParent, G.ace.db.profile.unitframes['player'].castbarX + (G.ace.db.profile.unitframes["player"].castbarHeight / 2) + 1, G.ace.db.profile.unitframes['player'].castbarY)
		cb:SetSize(G.ace.db.profile.unitframes["player"].castbarWidth - G.ace.db.profile.unitframes["player"].castbarHeight - 1, G.ace.db.profile.unitframes["player"].castbarHeight)
		cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
	elseif self.unit == 'target' then
		cb:SetPoint('CENTER', UIParent, G.ace.db.profile.unitframes['target'].castbarX + (G.ace.db.profile.unitframes["target"].castbarHeight / 2) + 1, G.ace.db.profile.unitframes['target'].castbarY)
		cb:SetSize(G.ace.db.profile.unitframes["target"].castbarWidth - G.ace.db.profile.unitframes["target"].castbarHeight - 1, G.ace.db.profile.unitframes["target"].castbarHeight)
		cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Shield = cb:CreateTexture(nil, 'OVERLAY')
		cb.Shield:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Shield:SetPoint('LEFT', cb.Icon)
		cb.Shield:SetTexture(G.media .. "textures\\shield")
	elseif self.unit == 'boss' then
		cb:SetPoint('TOPRIGHT', "oUF_gempUIBoss", "BOTTOMRIGHT", G.unitframes.target.castbar.xOff - 1, G.unitframes.target.castbar.yOff)
		cb:SetSize(G.unitframes.boss.width - G.unitframes.target.castbar.height - 3, G.unitframes.target.castbar.height)
		cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Shield = cb:CreateTexture(nil, 'OVERLAY')
		cb.Shield:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Shield:SetPoint('LEFT', cb.Icon)
		cb.Shield:SetTexture(G.media .. "textures\\shield")
	end

	cb.Spark = cb:CreateTexture(nil, 'OVERLAY')
	cb.Spark:SetTexture([=[Interface\Buttons\WHITE8x8]=])
	cb.Spark:SetBlendMode('Add')
	cb.Spark:SetHeight(cb:GetHeight())
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
end

local Health = function(self)
    local h = CreateFrame('StatusBar', nil, self)
    h:SetPoint('TOP')
    h:SetPoint('LEFT')
	h:SetPoint('RIGHT')
	h:SetStatusBarTexture(G.texture)
	h:SetStatusBarColor(unpack(G.colors.base))

    h.frequentUpdates = true
    h.colorDisconnected = false

	self.Health = h
end

local Power = function(self)
	local p = createStatusbar(self, G.texture, nil, nil, nil, unpack(G.colors.base))
	p:SetPoint('LEFT', self.Health, 'LEFT', 1, 0)
	p:SetPoint('RIGHT', self.Health, 'RIGHT', -1, 0)
	p:SetPoint('TOP', self.Health, 'BOTTOM', 0, 0)

	if unit == 'player' and powerType ~= 0 then p.frequentUpdates = true end

	local pbg = p:CreateTexture(nil, 'BACKGROUND')
	pbg:SetAllPoints(p)
	pbg:SetTexture(G.texture)
	pbg:SetVertexColor(unpack(G.colors.base))

	F.createBorder(p, p, true)

	p.colorClass = true
	p.colorReaction = true
	pbg.multiplier = 0

	p.bg = pbg
	self.Power = p
end

local function Icons(self)
	self.LeaderIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	self.LeaderIndicator:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, -5)
	self.LeaderIndicator:SetSize(12, 12)

	self.AssistantIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	self.AssistantIndicator:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, -5)
	self.AssistantIndicator:SetSize(12, 12)

	self.MasterLooterIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	self.MasterLooterIndicator:SetPoint('LEFT', self.Leader, 'RIGHT')
	self.MasterLooterIndicator:SetSize(11, 11)
end

local function Shared(self, unit)

	self:SetScript('OnEnter', OnEnter)
	self:SetScript('OnLeave', OnLeave)

	self:RegisterForClicks('AnyUp')

	self.framebd = F.createBorder(self, self, false)

	Health(self)

	local ricon = self.Health:CreateTexture(nil, 'OVERLAY')
	ricon:SetTexture(raidicons)
	ricon:SetSize(15, 15)
	ricon:SetPoint('TOP', 0, 8)
	self.RaidTargetIndicator = ricon

	local hl = self.Health:CreateTexture(nil, 'OVERLAY')
	hl:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
	hl:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 1)
	hl:SetTexture([=[Interface\Buttons\WHITE8x8]=])
	hl:SetVertexColor(1, 1, 1, .1)
	hl:SetBlendMode('ADD')
	hl:Hide()
	self.Highlight = hl
end

local UnitSpecific = {
	player = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)
		castbar(self)
		createAuraBars(self, unit)

		PetCastingBarFrame:UnregisterAllEvents()
		PetCastingBarFrame.Show = function() end
		PetCastingBarFrame:Hide()

		self:SetSize(G.ace.db.profile.unitframes['player'].width, G.ace.db.profile.unitframes['player'].health + G.ace.db.profile.unitframes['player'].power + 1)
		self.Health:SetHeight(G.ace.db.profile.unitframes['player'].health)
		self.Power:SetHeight(G.ace.db.profile.unitframes['player'].power)

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -4, 0)
		if powerType ~= 0 then htext.frequentUpdates = .1 end
		self:Tag(htext, '[player:hp][player:power]')

		if G.ace.db.profile.unitframes['player'].showName then
			local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
			name:SetPoint('LEFT', 4, 0)
			name:SetJustifyH'LEFT'
			self:Tag(name, '[color][long:name]')
		end

		local ct = CreateFrame('Frame', nil, self.Health)
		ct:SetSize(10, 10)
		ct:SetPoint('LEFT', 5, 0)
		ct.text = fs(ct, 'OVERLAY', symbol, 14, '', 1, 1, 1)
		ct.text:SetShadowOffset(1, -1)
		ct.text:SetPoint('LEFT')
		ct.text:SetText('|cffAF5050j|r')
		self.CombatIndicator = ct

		if (class == 'PRIEST' or class == 'PALADIN' or class == 'MONK' or class == 'ROGUE') then
			local ClassPower = CreateFrame('Frame', nil, self)
			ClassPower:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 2, -1)
			ClassPower:SetSize(G.unitframes.player.width, G.unitframes.player.special)

			if class == 'PRIEST' then
				local numMax = UnitPowerMax('player', SPELL_POWER_SHADOW_ORBS)
				ClassPower.c = numMax
			elseif class == 'PALADIN' then
				local numMax = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
				ClassPower.c = numMax
			elseif class == 'MONK' then
				local numMax = UnitPowerMax('player', SPELL_POWER_CHI)
				ClassPower.c = numMax
			elseif class == 'ROGUE' then
				local numMax = UnitPowerMax('player', SPELL_POWER_COMBO_POINTS)
				ClassPower.c = numMax
			end

			for i = 1, 11 do
				Icon = createStatusbar(ClassPower, G.texture, nil, G.unitframes.player.special, (self:GetWidth() / ClassPower.c) - 1, unpack(G.colors.base))

				if i == 1 then
					Icon:SetPoint('LEFT', ClassPower)
				else
					Icon:SetPoint('LEFT', ClassPower[i - 1], 'RIGHT', 1, 0)
				end

				ClassPower[i] = Icon
				F.createBorder(ClassPower[i], ClassPower[i], true)
			end

			self.ClassPower = ClassPower
		end



		if class == 'DEATHKNIGHT' then
			local b = CreateFrame('Frame', nil, self)
			b:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
			b:SetSize(G.unitframes.player.width, G.unitframes.player.special)

			local i = 6
			for index = 1, 6 do
				local minus = 1
				if i == 6 then 
					minus = 2
				end
				b[i] = createStatusbar(b, G.texture, nil, G.unitframes.player.special, (self:GetWidth() / 6) - minus, 1, 1, 1, 1)

				if i == 6 then
					b[i]:SetPoint('RIGHT', b)
				else
					b[i]:SetPoint('RIGHT', b[i + 1], 'LEFT', -1, 0)
				end

				b[i].bg = b[i]:CreateTexture(nil, 'BACKGROUND')
				F.createBorder(b[i], b[i], true)
				b[i].bg:SetAllPoints(b[i])
				b[i].bg:SetTexture(G.texture)
				b[i].bg:SetVertexColor(0,0,0)
				b[i].bg.multiplier = .1

				i = i - 1
			end

			b.colorSpec = true
			self.Runes = b
		end

		local b = CreateFrame('Frame', nil, self)
		b.size = 27
		b.spacing = 4
		b.num = 28
		b:SetSize(120, b.size)
		b:SetPoint('TOPRIGHT', self, 'TOPLEFT', -7, -1)
		b.initialAnchor = 'TOPRIGHT'
		b['growth-y'] = 'DOWN'
		b['growth-x'] = 'LEFT'
		b.PostCreateIcon = auraIcon
		b.PostUpdateIcon = PostUpdateIcon
		self.Buffs = b

		local d = CreateFrame('Frame', nil, self)
		d.size = 27
		d.spacing = 4
		d.num = 18
		d:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 7)
		d:SetSize(G.unitframes.player.width, d.size)
		d.initialAnchor = 'TOPLEFT'
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = d
	end,
	target = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)
		castbar(self)
		createAuraBars(self, unit)

		self:SetSize(G.ace.db.profile.unitframes['target'].width, G.ace.db.profile.unitframes['target'].health + G.ace.db.profile.unitframes['target'].power + 1)
		self.Health:SetHeight(G.ace.db.profile.unitframes['target'].health)
		self.Power:SetHeight(G.ace.db.profile.unitframes['target'].power)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 4, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[color][short:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -4, 0)
		htext.frequentUpdates = .1
		self:Tag(htext, '[player:hp]')

		local b = CreateFrame('Frame', nil, self)
		b.size = 27
		b.spacing = 4
		b.num = 18
		b:SetSize(120, b.size)
		b:SetPoint('TOPLEFT', self, 'TOPRIGHT', 7, -1)
		b.initialAnchor = 'TOPLEFT'
		b['growth-y'] = 'DOWN'
		b.PostCreateIcon = auraIcon
		b.PostUpdateIcon = PostUpdateIcon
		self.Buffs = b

		local d = CreateFrame('Frame', nil, self)
		d.size = 27
		d.spacing = 4
		d.num = 18
		d:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 7)
		d:SetSize(G.unitframes.player.width, d.size)
		d.initialAnchor = 'TOPLEFT'
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		d.CustomFilter = CustomFilter
		self.Debuffs = d

		self.SpellRange = {
			insideAlpha = 1.0,
			outsideAlpha = 0.4
		}
	end,
	focus = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)

		self:SetSize(G.unitframes.focus.width, G.unitframes.focus.health + G.unitframes.focus.power + 1)
		self.Health:SetHeight(G.unitframes.focus.health)
		self.Power:SetHeight(G.unitframes.focus.power)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 4, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[color][short:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -2, 0)
		self:Tag(htext, '[party:hp]')

		local d = CreateFrame('Frame', nil, self)
		d.size = 24
		d.spacing = 4
		d.num = 8
		d:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 7)
		d:SetSize(G.unitframes.focus.width, d.size)
		d.initialAnchor = 'TOPLEFT'
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = d

		local b = CreateFrame('Frame', nil, self)
		b.size = 24
		b.spacing = 4
		b.num = 12
		b:SetSize(b.num / 2 * b.size + b.spacing * (b.num / 2 - 1), b.size)
		b:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, 0)
		b.initialAnchor = 'TOPRIGHT'
		b['growth-x'] = 'LEFT'
		b['growth-y'] = 'DOWN'
		b.PostCreateIcon = auraIcon
		b.PostUpdateIcon = PostUpdateIcon
		self.Buffs = b
	end,
	boss = function(self, unit)
		Shared(self, unit)
		castbar(self)

		self.Health.frequentUpdates = true

		self:SetSize(G.unitframes.boss.width, G.unitframes.boss.health)
		self.Health:SetHeight(G.unitframes.boss.health)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 4, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -2, 0)
		self:Tag(htext, '[boss:hp]')

		local b = CreateFrame('Frame', nil, self)
		b.size = 25
		b.spacing = 4
		b.num = 4
		b:SetSize(b.num * b.size + b.spacing * (b.num - 1), b.size)
		b:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, -1)
		b.initialAnchor = 'TOPRIGHT'
		b['growth-x'] = 'LEFT'
		b.PostCreateIcon = auraIcon
		b.PostUpdateIcon = PostUpdateIcon
		self.Buffs = b

		local d = CreateFrame('Frame', nil, self)
		d.size = 25
		d.spacing = 4
		d.num = 4
		d:SetSize(d.num * d.size + d.spacing * (d.num - 1), d.size)
		d:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, -1)
		d.initialAnchor = 'TOPLEFT'
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = d
	end,
	pet = function(self, unit)
		Shared(self, unit)

		self:SetSize(G.unitframes.pet.width, G.unitframes.pet.health)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
	end,
	partytarget = function(self, unit)
		Shared(self, unit)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize - 2, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
	end,
	targettarget = function(self, unit)
		Shared(self, unit)

		self:SetSize(G.ace.db.profile.unitframes['targettarget'].width, G.ace.db.profile.unitframes['targettarget'].health)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('CENTER')
		self:Tag(name, '[color][short:name]')

		local d = CreateFrame('Frame', nil, self)
		d.size = 25
		d.spacing = 4
		d.num = 4
		d:SetSize(d.num * d.size + d.spacing * (d.num - 1), d.size)
		d:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, -1)
		d.initialAnchor = 'TOPLEFT'
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = d
	end,
	party = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)

		self:SetSize(G.unitframes.party.width, G.unitframes.party.health + G.unitframes.party.power + 1)
		self.Health:SetHeight(G.unitframes.party.health)
		self.Power:SetHeight(G.unitframes.party.power)

		local lfd = fs(self.Health, 'OVERLAY', symbol, 12, "", 1, 1, 1)
		lfd:SetPoint('LEFT', 4, 0)
		lfd:SetJustifyH 'LEFT'
		self:Tag(lfd, '[LFD]')

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize - 2, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', lfd, 'RIGHT', 0, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, ' [color][short:name] [lvl]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -2, 0)
		self:Tag(htext, '[party:hp]')

		local rc = self.Health:CreateTexture(nil, 'OVERLAY')
		rc:SetPoint('CENTER')
		rc:SetSize(12, 12)
		self.ReadyCheckIndicator = rc

		local d = CreateFrame('Frame', nil, self)
		d.size = 24
		d.spacing = 4
		d.num = 4
		d:SetSize(d.num * d.size + d.spacing * (d.num - 1), d.size)
		d:SetPoint('TOPRIGHT', self, 'TOPLEFT', -7, -1)
		d.initialAnchor = 'TOPRIGHT'
		d['growth-x'] = 'LEFT'
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = d

		self.SpellRange = {
			insideAlpha = 1.0,
			outsideAlpha = 0.4
		}
	end,
	arena = function(self, unit)
		Shared(self, unit)

		Power(self)
		Icons(self)

		self:SetSize(G.unitframes.arena.width, G.unitframes.arena.health + G.unitframes.arena.power - 2)
		self.Health:SetHeight(G.unitframes.arena.health)
		self.Power:SetHeight(G.unitframes.arena.power)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 4, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -2, 0)
		self:Tag(htext, '[party:hp]')
	end,
	raid = function(self, unit)
		Shared(self, unit)
		Icons(self)

		self.framebd:Hide() -- hide Shared bd
		self.framebd = F.createBorder(self, self, true)

		self:SetSize(G.unitframes.raid.width, G.unitframes.raid.health)
		F.addBackdropNoBorder(self)
		self.Health.colorClass = true

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize - 3, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('TOPLEFT', 2, -3)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[veryshort:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize - 2, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -5, -8)
		htext:SetJustifyH 'RIGHT'
		self:Tag(htext, '[raid:hp]')

		local lfd = fs(self.Health, 'OVERLAY', symbol, 10, '', 1, 1, 1)
		lfd:SetShadowOffset(1, -1)
		lfd:SetPoint('TOPRIGHT', -1, -2)
		self:Tag(lfd, '[LFD]')

		self.RaidTargetIndicator:SetSize(14, 14)
		self.RaidTargetIndicator:SetPoint('TOP', self.Health, 0, 5)

		local rc = self.Health:CreateTexture(nil, 'OVERLAY')
		rc:SetPoint('BOTTOM')
		rc:SetSize(12, 12)
		self.ReadyCheckIndicator = rc

		local hl = self.Health:CreateTexture(nil, 'OVERLAY')
		hl:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
		hl:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		hl:SetTexture([=[Interface\Buttons\WHITE8x8]=])
		hl:SetVertexColor(1, 1, 1, .1)
		hl:SetBlendMode('ADD')
		hl:Hide()
		self.Highlight = hl

		self.SpellRange = {
			insideAlpha = 1.0,
			outsideAlpha = 0.4
		}
	end,
}

UnitSpecific.focustarget = UnitSpecific.pet



oUF:RegisterStyle('gempUI', Shared)

for unit, layout in next, UnitSpecific do
	oUF:RegisterStyle('gempUI - ' .. unit:gsub('^%l', string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
	if (UnitSpecific[unit]) then
		self:SetActiveStyle('gempUI - ' .. unit:gsub('^%l', string.upper))
	elseif (UnitSpecific[unit:match('[^%d]+')]) then
		self:SetActiveStyle('gempUI - ' .. unit:match('[^%d]+'):gsub('^%l', string.upper))
	else
		self:SetActiveStyle 'gempUI'
	end
	local object = self:Spawn(unit)
	object:SetPoint(...)
	return object
end

function refreshUnitframePositions()
	for unit,object in pairs(unitframes) do
		object:SetPoint("CENTER", G.ace.db.profile.unitframes[unit].x, G.ace.db.profile.unitframes[unit].y)
	end
end

oUF:Factory(function(self)
	unitframes["player"] = spawnHelper(self, 'player', 'CENTER', G.ace.db.profile.unitframes["player"].x, G.ace.db.profile.unitframes["player"].y)
	unitframes["target"] = spawnHelper(self, 'target', 'CENTER', G.ace.db.profile.unitframes["target"].x, G.ace.db.profile.unitframes["target"].y)
	unitframes["targettarget"] = spawnHelper(self, 'targettarget', "CENTER", G.ace.db.profile.unitframes["targettarget"].x, G.ace.db.profile.unitframes["targettarget"].y)
	spawnHelper(self, 'focus', 'TOP', UIParent, 'CENTER', G.unitframes.focus.xOff, G.unitframes.focus.yOff)
	spawnHelper(self, 'focustarget', 'TOPLEFT', "oUF_gempUIFocus", "TOPRIGHT", G.unitframes.focustarget.xOff, G.unitframes.focustarget.yOff)
	spawnHelper(self, 'pet', 'LEFT', "oUF_gempUIPlayer", "LEFT",  G.unitframes.pet.xOff,  G.unitframes.pet.yOff)

	for i = 1, MAX_BOSS_FRAMES do
		spawnHelper(self, 'boss' .. i, 'LEFT', "oUF_gempUITarget", 'RIGHT', G.unitframes.boss.xOff, G.unitframes.boss.yOff - (70 * i))
	end

	local arena = {}
	self:SetActiveStyle 'gempUI - Arena'
	for i = 1, 5 do
		arena[i] = self:Spawn('arena' .. i, 'oUF_Arena' .. i)
		if i == 1 then
			arena[i]:SetPoint('LEFT', "oUF_gempUITarget", 'RIGHT',  G.unitframes.arena.xOff,  G.unitframes.arena.yOff)
		else
			arena[i]:SetPoint('TOP', arena[i - 1], 'BOTTOM', 0, -23)
		end
	end
	local arenatarget = {}
	self:SetActiveStyle 'gempUI - Pet'
	for i = 1, 5 do
		arenatarget[i] = self:Spawn('arena' .. i .. 'target', 'oUF_Arena' .. i .. 'target')
		if i == 1 then
			arenatarget[i]:SetPoint('TOPLEFT', arena[i], 'TOPRIGHT', 5, 0)
		else
			arenatarget[i]:SetPoint('TOP', arenatarget[i - 1], 'BOTTOM', 0, -27)
		end
	end

	local arenaprep = {}
	for i = 1, 5 do
		arenaprep[i] = CreateFrame('Frame', 'oUF_ArenaPrep' .. i, UIParent)
		arenaprep[i]:SetAllPoints(_G['oUF_Arena' .. i])
		arenaprep[i]:SetFrameStrata('BACKGROUND')

		arenaprep[i].Health = CreateFrame('StatusBar', nil, arenaprep[i])
		arenaprep[i].Health:SetAllPoints()
		arenaprep[i].Health:SetStatusBarTexture(G.texture)

		arenaprep[i].Spec = fs(arenaprep[i].Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		arenaprep[i].Spec:SetPoint('CENTER')
		arenaprep[i].Spec:SetJustifyH 'CENTER'

		arenaprep[i]:Hide()
	end

	local arenaprepupdate = CreateFrame('Frame')
	arenaprepupdate:RegisterEvent('PLAYER_LOGIN')
	arenaprepupdate:RegisterEvent('PLAYER_ENTERING_WORLD')
	arenaprepupdate:SetScript('OnEvent', function(self, event)
		if event == 'PLAYER_LOGIN' then
			for i = 1, 5 do
				arenaprep[i]:SetAllPoints(_G['oUF_Arena' .. i])
			end
		else
			for i = 1, 5 do
				arenaprep[i]:Hide()
			end
		end
	end)

	for i = 1, MAX_PARTY_MEMBERS do
		local pet = 'PartyMemberFrame' .. i .. 'PetFrame'
		_G[pet]:SetParent(Hider)
		_G[pet .. 'HealthBar']:UnregisterAllEvents()
	end

	self:SetActiveStyle 'gempUI - Party'
	local party = self:SpawnHeader(nil, nil, 'party', 'showPlayer',
		false, 'showSolo', false, 'showParty', true, 'xOffset', 5, 'yOffset', -10,
		'oUF-initialConfigFunction', ([[
		self:SetHeight(%d)
		self:SetWidth(%d)
		]]):format(G.unitframes.party.health + G.unitframes.party.power - 2, G.unitframes.party.width))
	party:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', G.unitframes.party.xOff, G.unitframes.party.yOff)

	self:SetActiveStyle 'gempUI - Party'
	local maintank = self:SpawnHeader(nil, nil, 'raid',
		'showRaid', true, 'showSolo', false, 'groupFilter', 'MAINTANK', 'yOffset', -23,
		'oUF-initialConfigFunction', ([[
		self:SetHeight(%d)
		self:SetWidth(%d)
	]]):format(G.unitframes.tank.health + G.unitframes.tank.power + 1, G.unitframes.tank.width))
	maintank:SetPoint('RIGHT', "oUF_gempUIPlayer", 'LEFT', G.unitframes.tank.xOff, G.unitframes.tank.yOff)

	self:SetActiveStyle 'gempUI - Partytarget'
	local maintanktarget = self:SpawnHeader(nil, nil, 'raid',
		'showRaid', true, 'showSolo', false, 'groupFilter', 'MAINTANK', 'yOffset', -23,
		'oUF-initialConfigFunction', ([[
	self:SetAttribute('unitsuffix', 'target')
	self:SetHeight(%d)
	self:SetWidth(%d)
	]]):format(G.unitframes.tanktarget.health, G.unitframes.tanktarget.width))
	maintanktarget:SetPoint('TOPLEFT', 'oUF_gempUIPartyMainTank', 'TOPRIGHT', 6, 0)
	
	if IsAddOnLoaded('Blizzard_CompactRaidFrames') then
		CompactRaidFrameManager:SetParent(Hider)
		CompactUnitFrameProfiles:UnregisterAllEvents()
	end

	self:SetActiveStyle 'gempUI - Raid'
	local raid = oUF:SpawnHeader(nil, nil, 'raid,solo', --'custom [@raid6,exists] show; hide'
		'showPlayer', true,
		'showSolo', false,
		'showParty', false,
		'showRaid', true,
		'xoffset', 5,
		'yOffset', -5,
		'point', 'TOP',
		'groupFilter', '1,2,3,4,5,6,7,8',
		'groupingOrder', '1,2,3,4,5,6,7,8',
		'groupBy', 'GROUP',
		'maxColumns', 8,
		'unitsPerColumn', 5,
		'columnSpacing', 5,
		'columnAnchorPoint', 'LEFT',
		'oUF-initialConfigFunction', ([[
		self:SetHeight(%d)
		self:SetWidth(%d)
	]]):format(G.unitframes.raid.health, G.unitframes.raid.width))
	raid:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', G.unitframes.raid.xOff, G.unitframes.raid.yOff)
end)