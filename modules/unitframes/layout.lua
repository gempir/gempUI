local F, G, V = unpack(select(2, ...))
local name, ns = ...
local oUF = ns.oUF 
local cfg = ns.cfg


local raidicons = G.media .. "unitframes\\raidicons"
local symbol = G.media .. "unitframes\\symbol.ttf"

local class_color = RAID_CLASS_COLORS[class]
local powerType, powerTypeString = UnitPowerType('player')
local class = select(2, UnitClass('player'))

local backdrop = {
	bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
	insets = { top = -1, left = -1, bottom = -1, right = -1 },
}

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

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
	if s >= day then
		return format('%dd', floor(s / day + 0.5))
	elseif s >= hour then
		return format('%dh', floor(s / hour + 0.5))
	elseif s >= minute then
		return format('%dm', floor(s / minute + 0.5))
	end
	return format('%d', fmod(s, minute))
end

local AWIcon = function(AWatch, icon, spellID, name, self)			
	local count = fs(icon, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
	count:SetPoint('BOTTOMRIGHT', icon, 1, 0)
	icon.count = count
	icon.cd:SetReverse(true)
	icon.icon:SetTexCoord(.1, .9, .1, .9)
	F.createBorder(icon)
end

local createAuraWatch = function(self, unit)
	local auras = {}
		
		auras.presentAlpha = 1
		auras.missingAlpha = 0
		auras.PostCreateIcon = AWIcon
		-- Set any other AuraWatch settings
		auras.icons = {}
		for i, sid in pairs(G.aurawatch.spellIDs[class]) do
			local icon = CreateFrame("Frame", nil, self)
			icon.spellID = sid
			-- set the dimensions and positions
			icon:SetWidth(36)
			icon:SetHeight(36)
			icon:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -40 + (i * 40), 40)
			auras.icons[sid] = icon
			-- Set any other AuraWatch icon settings
		end
		self.AuraWatch = auras
end

local auraIcon = function(auras, button)
	local c = button.count
	c:ClearAllPoints()
	c:SetPoint('TOPRIGHT', -1, 0)
	c:SetFontObject(nil)
	c:SetFont(G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag)
	c:SetTextColor(1, 1, 1)

	auras.disableCooldown = false
	auras.showDebuffType = true

	button.overlay:SetTexture(nil)
	button.icon:SetTexCoord(.1, .9, .1, .9)
	button:SetBackdrop(backdrop)
	button:SetBackdropColor(unpack(G.colors.border))

	button.glow = CreateFrame('Frame', nil, button)
	button.glow:SetPoint('TOPLEFT', button, 'TOPLEFT', -4, 4)
	button.glow:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 4, -4)
	button.glow:SetFrameLevel(button:GetFrameLevel() - 1)
	button.glow:SetBackdrop({
		bgFile = "",
		edgeFile = "",
		edgeSize = 5,
		insets = { left = 3, right = 3, top = 3, bottom = 3, },
	})

	local remaining = fs(button, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
	remaining:SetPoint('TOPLEFT')
	button.remaining = remaining
end

local PostUpdateIcon = function(icons, unit, icon, index, offset)
	local name, _, _, _, dtype, duration, expirationTime, unitCaster, _, _, spellID = UnitAura(unit, index, icon.filter)
	local texture = icon.icon
	if icon.isPlayer or UnitIsFriend('player', unit) or not icon.isDebuff then
		texture:SetDesaturated(false)
	else
		texture:SetDesaturated(true)
	end
end

local FilterAuraWatch = function(icons, ...)
	local _, icon, name, _, _, _, _, _, _, caster, _, _, spellID = ...
	for k, v in pairs(G.aurawatch.spellIDs[class]) do
		if v == spellID then 
			return false
		end
	end
	return true
end

local CustomFilter = function(icons, ...)
	local _, icon, name, _, _, _, _, _, _, caster = ...
	local isPlayer
	if (caster == 'player' or caster == 'vechicle') then
		isPlayer = true
	end
	if ((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
		icon.isPlayer = isPlayer
		icon.owner = caster
		return true
	end
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
	cb.ChannelingColor = { 0.32, 0.3, G.colors.base[4] }
	cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
	cb.Icon:SetPoint('TOPRIGHT', cb, 'TOPLEFT', -1, 0)
	cb.Icon:SetTexCoord(.1, .9, .1, .9)

	if self.unit == 'player' then
		cb:SetPoint('TOPRIGHT', "oUF_gempUIPlayer", "BOTTOMRIGHT", G.unitframes.player.castbar.xOff - 1, G.unitframes.player.castbar.yOff)
		cb:SetSize(G.unitframes.player.castbar.width - G.unitframes.player.castbar.height - 3, G.unitframes.player.castbar.height)
		cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
	elseif self.unit == 'target' then
		cb:SetPoint('TOPRIGHT', "oUF_gempUITarget", "BOTTOMRIGHT", G.unitframes.target.castbar.xOff - 1, G.unitframes.target.castbar.yOff)
		cb:SetSize(G.unitframes.target.castbar.width - G.unitframes.target.castbar.height - 3, G.unitframes.target.castbar.height)
		cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Shield = cb:CreateTexture(nil, 'OVERLAY')
		cb.Shield:SetSize(cb:GetHeight(), cb:GetHeight())
		cb.Shield:SetPoint('LEFT', cb.Icon)
		cb.Shield:SetTexture(G.media .. "textures\\shield")
	end

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
end

local Health = function(self)
	local h = createStatusbar(self, G.texture, nil, nil, nil, unpack(G.colors.base))
	h:SetPoint 'TOP'
	h:SetPoint 'LEFT'
	h:SetPoint 'RIGHT'

	h.frequentUpdates = false

	self.Health = h
end

local Power = function(self)
	local p = createStatusbar(self, G.texture, nil, nil, nil, unpack(G.colors.base))
	p:SetPoint('LEFT', self.Health, 'LEFT', 1, 0)
	p:SetPoint('RIGHT', self.Health, 'RIGHT', -1, 0)
	p:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)

	if unit == 'player' and powerType ~= 0 then p.frequentUpdates = true end

	local pbg = p:CreateTexture(nil, 'BACKGROUND')
	pbg:SetAllPoints(p)
	pbg:SetTexture(G.texture)

	F.createBorder(p, p, true)

	p.colorClass = true
	p.colorReaction = true
	pbg.multiplier = .4

	p.bg = pbg
	self.Power = p
end

local function Icons(self)
	self.LeaderIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	self.LeaderIndicator:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, -3)
	self.LeaderIndicator:SetSize(12, 12)

	self.AssistantIndicator = self.Health:CreateTexture(nil, 'OVERLAY')
	self.AssistantIndicator:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, -3)
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
	ricon:SetSize(20, 20)
	ricon:SetPoint('TOP', 0, 10)
	self.RaidTargetIndicator = ricon

	local hl = self.Health:CreateTexture(nil, 'OVERLAY')
	hl:SetAllPoints(self)
	hl:SetTexture([=[Interface\Buttons\WHITE8x8]=])
	hl:SetVertexColor(1, 1, 1, .05)
	hl:SetBlendMode('ADD')
	hl:Hide()
	self.Highlight = hl

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = 0.5
	}
end

local UnitSpecific = {
	player = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)
		castbar(self)
		createAuraWatch(self)

		PetCastingBarFrame:UnregisterAllEvents()
		PetCastingBarFrame.Show = function() end
		PetCastingBarFrame:Hide()

		self:SetSize(G.unitframes.player.width, G.unitframes.player.health + G.unitframes.player.power - 2)
		self.Health:SetHeight(G.unitframes.player.health)
		self.Power:SetHeight(G.unitframes.player.power)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 4, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -2, 0)
		if powerType ~= 0 then htext.frequentUpdates = .1 end
		self:Tag(htext, '[player:hp][player:power]')

		local ct = CreateFrame('Frame', nil, self.Health)
		ct:SetSize(10, 10)
		ct:SetPoint('CENTER')
		ct:SetAlpha(0.5)
		ct.text = fs(ct, 'OVERLAY', symbol, 14, '', 1, 1, 1)
		ct.text:SetShadowOffset(1, -1)
		ct.text:SetPoint('CENTER')
		ct.text:SetText('|cffAF5050j|r')
		self.CombatIndicator = ct

		local altp = createStatusbar(self, G.texture, nil, 30, 180, unpack(G.colors.base))
		altp:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
		altp.bd = F.createBorder(altp, altp)
		altp.Text = fs(altp, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		altp.Text:SetPoint('CENTER')
		self:Tag(altp.Text, '[altpower]')
		altp:EnableMouse(true)
		altp.colorTexture = true
		self.AlternativePower = altp

		if (class == 'PRIEST' or class == 'PALADIN' or class == 'MONK') then
			local ClassPower = CreateFrame('Frame', nil, self)
			ClassPower:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 1, 0)
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
			end

			for i = 1, 11 do
				Icon = createStatusbar(ClassPower, G.texture, nil, G.unitframes.player.special, (self:GetWidth() / ClassPower.c) - 1, unpack(G.colors.base))

				if i == 1 then
					Icon:SetPoint('LEFT', ClassPower)
				else
					Icon:SetPoint('LEFT', ClassPower[i - 1], 'RIGHT', 1, 0)
				end

				ClassPower[i] = Icon
				F.createBorder(ClassPower[i], ClassPower[i])
			end

			self.ClassPower = ClassPower
		end



		if class == 'DEATHKNIGHT' then
			local b = CreateFrame('Frame', nil, self)
			b:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 1, 0)
			b:SetSize(G.unitframes.player.width, G.unitframes.player.special)

			local i = 6
			for index = 1, 6 do
				b[i] = createStatusbar(b, G.texture, nil, G.unitframes.player.special, (self:GetWidth() + 1) / 6 - 1, 1, 1, 1, 1)

				if i == 6 then
					b[i]:SetPoint('RIGHT', b)
				else
					b[i]:SetPoint('RIGHT', b[i + 1], 'LEFT', -1, 0)
				end

				b[i].bg = b[i]:CreateTexture(nil, 'BACKGROUND')
				F.createBorder(b[i], b[i])
				b[i].bg:SetAllPoints(b[i])
				b[i].bg:SetTexture(G.texture)
				b[i].bg.multiplier = .3

				i = i - 1
			end
			self.Runes = b
		end

		local b = CreateFrame('Frame', nil, self)
		b.size = 27
		b.spacing = 4
		b.num = 18
		b:SetSize(b.size * b.num / 2 + b.spacing * (b.num / 2 - 1), b.size)
		b:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, -1)
		b.initialAnchor = 'TOPRIGHT'
		b['growth-y'] = 'DOWN'
		b['growth-x'] = 'LEFT'
		b.PostCreateIcon = auraIcon
		b.PostUpdateIcon = PostUpdateIcon
		b.CustomFilter = FilterAuraWatch
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
	end,
	target = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)
		castbar(self)

		self:SetSize(G.unitframes.target.width, G.unitframes.target.health + G.unitframes.target.power - 2)
		self.Health:SetHeight(G.unitframes.target.health)
		self.Power:SetHeight(G.unitframes.target.power)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 4, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[lvl] [color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -2, 0)
		htext.frequentUpdates = .1
		self:Tag(htext, '[player:hp]')

		local b = CreateFrame('Frame', nil, self)
		b.size = 27
		b.spacing = 4
		b.num = 18
		b:SetSize(b.size * b.num / 2 + b.spacing * (b.num / 2 - 1), b.size)
		b:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, -1)
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
		d.onlyShowPlayer = false
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		d.CustomFilter = CustomFilter
		self.Debuffs = d
	end,
	focus = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)

		self:SetSize(G.unitframes.focus.width, G.unitframes.focus.health + G.unitframes.focus.power - 2)
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
		Power(self)

		self.Health.frequentUpdates = true
		self.SpellRange.outsideAlpha = 1

		self:SetSize(G.unitframes.boss.width,G.unitframes.boss.health + G.unitframes.boss.power)
		self.Health:SetHeight(G.unitframes.boss.health - 2)
		self.Power:SetHeight(G.unitframes.boss.power)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 4, 0)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -2, 0)
		self:Tag(htext, '[boss:hp]')

		local b = CreateFrame('Frame', nil, self)
		b.size = 24
		b.spacing = 4
		b.num = 4
		b:SetSize(b.num * b.size + b.spacing * (b.num - 1), b.size)
		b:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, 0)
		b.initialAnchor = 'TOPRIGHT'
		b['growth-x'] = 'LEFT'
		b.PostCreateIcon = auraIcon
		b.PostUpdateIcon = PostUpdateIcon
		self.Buffs = b

		local d = CreateFrame('Frame', nil, self)
		d.size = 24
		d.spacing = 4
		d.num = 4
		d:SetSize(d.num * d.size + d.spacing * (d.num - 1), d.size)
		d:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, 0)
		d.initialAnchor = 'TOPLEFT'
		d.onlyShowPlayer = true
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
		self.Debuffs = d
	end,
	pet = function(self, unit)
		Shared(self, unit)

		self:SetSize(G.unitframes.pet.width, G.unitframes.pet.health - 2)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
	end,
	partytarget = function(self, unit)
		Shared(self, unit)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
	end,
	targettarget = function(self, unit)
		Shared(self, unit)

		self:SetSize(G.unitframes.targettarget.width, G.unitframes.targettarget.health)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('CENTER')
		self:Tag(name, '[color][short:name]')

		local d = CreateFrame('Frame', nil, self)
		d.size = 24
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

		self:SetSize(G.unitframes.party.width, G.unitframes.party.health + G.unitframes.party.power - 2)
		self.Health:SetHeight(G.unitframes.party.health)
		self.Power:SetHeight(G.unitframes.party.power)

		local lfd = fs(self.Health, 'OVERLAY', symbol, 13, "OUTLINE", 1, 1, 1)
		lfd:SetPoint('LEFT', 4, 0)
		lfd:SetJustifyH 'LEFT'
		self:Tag(lfd, '[LFD]')

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
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
		d:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, -1)
		d.initialAnchor = 'TOPRIGHT'
		d['growth-x'] = 'LEFT'
		d.PostCreateIcon = auraIcon
		d.PostUpdateIcon = PostUpdateIcon
			self.Debuffs = d
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
		Power(self)
		Icons(self)

		self:SetSize(G.unitframes.raid.width, G.unitframes.raid.health + G.unitframes.raid.power)
		self.Health:SetHeight(G.unitframes.raid.health - 2)
		self.Power:SetHeight(G.unitframes.raid.power)

		local name = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 5, 5)
		name:SetJustifyH 'LEFT'
		self:Tag(name, '[color][veryshort:name]')

		local htext = fs(self.Health, 'OVERLAY', G.unitframes.font, G.unitframes.fontsize, G.unitframes.fontflag, 1, 1, 1)
		htext:SetPoint('RIGHT', -5, -8)
		htext:SetJustifyH 'RIGHT'
		self:Tag(htext, '[raid:hp]')

		local lfd = fs(self.Health, 'OVERLAY', symbol, 12, '', 1, 1, 1)
		lfd:SetPoint('BOTTOMLEFT', 6, 1)
		self:Tag(lfd, '[LFD]')

		self.RaidTargetIndicator:SetSize(14, 14)
		self.RaidTargetIndicator:SetPoint('TOP', self.Health, 0, 8)

		local rc = self.Health:CreateTexture(nil, 'OVERLAY')
		rc:SetPoint('BOTTOM')
		rc:SetSize(12, 12)
		self.ReadyCheckIndicator = rc

		local tborder = CreateFrame('Frame', nil, self)
		tborder:SetPoint('TOPLEFT', self, 'TOPLEFT')
		tborder:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT')
		tborder:SetBackdrop(backdrop)
		tborder:SetBackdropColor(.8, .8, .8, 1)
		tborder:SetFrameLevel(1)
		tborder:Hide()
		self.TargetBorder = tborder

		local fborder = CreateFrame('Frame', nil, self)
		fborder:SetPoint('TOPLEFT', self, 'TOPLEFT')
		fborder:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT')
		fborder:SetBackdrop(backdrop)
		fborder:SetBackdropColor(.6, .8, 0, 1)
		fborder:SetFrameLevel(1)
		fborder:Hide()
		self.FocusHighlight = fborder
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

oUF:Factory(function(self)
	spawnHelper(self, 'player', 'TOP', UIParent, 'BOTTOM', G.unitframes.player.xOff, G.unitframes.player.yOff)
	spawnHelper(self, 'target', 'TOP', UIParent, 'BOTTOM', G.unitframes.target.xOff, G.unitframes.target.yOff)
	spawnHelper(self, 'targettarget', 'RIGHT', "oUF_gempUITarget", "RIGHT",G.unitframes.targettarget.xOff, G.unitframes.targettarget.yOff)
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
		arenaprep[i].framebd = framebd(arenaprep[i], arenaprep[i])

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
	arenaprepupdate:RegisterEvent('ARENA_OPPONENT_UPDATE')
	arenaprepupdate:RegisterEvent('ARENA_PREP_OPPONENT_SPECIALIZATIONS')
	arenaprepupdate:SetScript('OnEvent', function(self, event)
		if event == 'PLAYER_LOGIN' then
			for i = 1, 5 do
				arenaprep[i]:SetAllPoints(_G['oUF_Arena' .. i])
			end
		elseif event == 'ARENA_OPPONENT_UPDATE' then
			for i = 1, 5 do
				arenaprep[i]:Hide()
			end
		else
			local numOpps = GetNumArenaOpponentSpecs()

			if numOpps > 0 then
				for i = 1, 5 do
					local f = arenaprep[i]

					if i <= numOpps then
						local s = GetArenaOpponentSpec(i)
						local _, spec, class = nil, 'UNKNOWN', 'UNKNOWN'

						if s and s > 0 then
							_, spec, _, _, _, _, class = GetSpecializationInfoByID(s)
						end

						if class and spec then
							f.Health:SetStatusBarColor(unpack(G.colors.base))
							f.Spec:SetText(spec .. '  -  ' .. LOCALIZED_CLASS_NAMES_MALE[class])
							f:Show()
						end
					else
						f:Hide()
					end
				end
			else
				for i = 1, 5 do
					arenaprep[i]:Hide()
				end
			end
		end
	end)

	for i = 1, MAX_PARTY_MEMBERS do
		local pet = 'PartyMemberFrame' .. i .. 'PetFrame'
		_G[pet]:SetParent(Hider)
		_G[pet .. 'HealthBar']:UnregisterAllEvents()
	end

	self:SetActiveStyle 'gempUI - Raid'
	local party = self:SpawnHeader(nil, nil, 'party', 'showPlayer',
		false, 'showSolo', false, 'showParty', true, 'point', 'LEFT', 'xOffset', 5, 'yOffset', -5,
		'oUF-initialConfigFunction', ([[
		self:SetHeight(%d)
		self:SetWidth(%d)
		]]):format(G.unitframes.raid.health + G.unitframes.raid.power - 2, G.unitframes.raid.width))
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
	]]):format(G.unitframes.raid.health + G.unitframes.raid.power - 2, G.unitframes.raid.width))
	raid:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', G.unitframes.raid.xOff, G.unitframes.raid.yOff)
end)


