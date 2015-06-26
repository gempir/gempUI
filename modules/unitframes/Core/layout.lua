local name, ns = ...
local oUF = ns.oUF or oUF
local cfg = ns.cfg
local _, class = UnitClass('player')
local class_color = RAID_CLASS_COLORS[class]
local powerType, powerTypeString = UnitPowerType('player')

local backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -1, left = -1, bottom = -1, right = -1},
}

local OnEnter = function(self)
    UnitFrame_OnEnter(self)
    self.Highlight:Show()	
end

local OnLeave = function(self)
    UnitFrame_OnLeave(self)
    self.Highlight:Hide()	
end
	
local ChangedTarget = function(self)
    if UnitIsUnit('target', self.unit) then
        self.TargetBorder:Show()
    else
        self.TargetBorder:Hide()
    end
end

local FocusTarget = function(self)
    if UnitIsUnit('focus', self.unit) then
        self.FocusHighlight:Show()
    else
        self.FocusHighlight:Hide()
    end
end

local dropdown = CreateFrame('Frame', name .. 'DropDown', UIParent, 'UIDropDownMenuTemplate')

local function menu(self)
	dropdown:SetParent(self)
	return ToggleDropDownMenu(1, nil, dropdown, self:GetName(), -3, 0)
end

local init = function(self)
	local unit = self:GetParent().unit
	local menu, name, id

	if(not unit) then
		return
	end

	if(UnitIsUnit(unit, 'player')) then
		menu = 'SELF'
    elseif(UnitIsUnit(unit, 'vehicle')) then
		menu = 'VEHICLE'
	elseif(UnitIsUnit(unit, 'pet')) then
		menu = 'PET'
	elseif(UnitIsPlayer(unit)) then
		id = UnitInRaid(unit)
		if(id) then
			menu = 'RAID_PLAYER'
			name = GetRaidRosterInfo(id)
		elseif(UnitInParty(unit)) then
			menu = 'PARTY'
		else
			menu = 'PLAYER'
		end
	else
		menu = 'TARGET'
		name = RAID_TARGET_ICON
	end

	if(menu) then
		UnitPopup_ShowMenu(self, menu, unit, name, id)
	end
end

UIDropDownMenu_Initialize(dropdown, init, 'MENU')

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local FormatTime = function(s)
    if s >= day then
        return format('%dd', floor(s/day + 0.5))
    elseif s >= hour then
        return format('%dh', floor(s/hour + 0.5))
    elseif s >= minute then
        return format('%dm', floor(s/minute + 0.5))
    end
    return format('%d', fmod(s, minute))
end

local CreateAuraTimer = function(self,elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= 0.1 then
		self.timeLeft = self.expires - GetTime()
		if self.timeLeft > 0 then
			local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
			if self.timeLeft < 6 then
				self.remaining:SetTextColor(0.69, 0.31, 0.31)
			elseif self.timeLeft < 60 then
				self.remaining:SetTextColor(1, 0.85, 0)
			else
				self.remaining:SetTextColor(1, 1, 1)
			end
		else
			self.remaining:Hide()
			self:SetScript('OnUpdate', nil)
		end
		self.elapsed = 0
	end
end

local auraIcon = function(auras, button)
    local c = button.count
    c:ClearAllPoints()
	c:SetPoint('BOTTOMRIGHT', 3, -1)
    c:SetFontObject(nil)
    c:SetFont(cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag)
    c:SetTextColor(1, 1, 1)	
	
    auras.disableCooldown = cfg.aura.disableCooldown	
	auras.showDebuffType = true
	
    button.overlay:SetTexture(nil)
	button.icon:SetTexCoord(.1, .9, .1, .9)
	button:SetBackdrop(backdrop)
	button:SetBackdropColor(0, 0, 0, 1)
	
    button.glow = CreateFrame('Frame', nil, button)
    button.glow:SetPoint('TOPLEFT', button, 'TOPLEFT', -4, 4)
    button.glow:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 4, -4)
    button.glow:SetFrameLevel(button:GetFrameLevel()-1)
    button.glow:SetBackdrop({bgFile = '', edgeFile = cfg.glow, edgeSize = 5,
	insets = {left = 3,right = 3,top = 3,bottom = 3,},
	})
	
    local remaining = fs(button, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
    remaining:SetPoint('TOPLEFT')
    button.remaining = remaining
end

local PostUpdateIcon = function(icons, unit, icon, index, offset)
	local name, _, _, _, dtype, duration, expirationTime, unitCaster = UnitAura(unit, index, icon.filter)
	local texture = icon.icon
	if icon.isPlayer or UnitIsFriend('player', unit) or not icon.isDebuff then
		texture:SetDesaturated(false)
	else
		texture:SetDesaturated(true)
	end
	if duration and duration > 0 then
		icon.remaining:Show()
	else
		icon.remaining:Hide()
	end
	
	local r,g,b = icon.overlay:GetVertexColor()
	if icon.isDebuff then
		icon.glow:SetBackdropBorderColor(r, g, b, 1)
	else 
		icon.glow:SetBackdropBorderColor(0, 0, 0, 1)
	end	
	
    icon.duration = duration
    icon.expires = expirationTime
    icon:SetScript('OnUpdate', CreateAuraTimer)
end

local CustomFilter = function(icons, ...)
    local _, icon, name, _, _, _, _, _, _, caster = ...
    local isPlayer
    if (caster == 'player' or caster == 'vechicle') then
        isPlayer = true
    end
    if((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
        icon.isPlayer = isPlayer
        icon.owner = caster
        return true
    end
end

local PostUpdateHealth = function(health, unit)
	if(UnitIsDead(unit)) then
		health:SetValue(0)
	elseif(UnitIsGhost(unit)) then
		health:SetValue(0)
	elseif not (UnitIsConnected(unit)) then
	    health:SetValue(0)
	end
end

local PostUpdatePower = function(Power, unit, min, max)
	local h = Power:GetParent().Health
	if max == 0 and cfg.options.hidepower then
		Power:Hide()
		if unit == 'boss' then
		    h:SetHeight(cfg.party.health+cfg.party.power+1)
		else
		    h:SetHeight(cfg.player.health+cfg.player.power+1)
		end
	else
	    Power:Show()
	    if unit == 'boss' then
		    h:SetHeight(cfg.party.health)
		else
		    h:SetHeight(cfg.player.health)
		end
	end
end

local AWIcon = function(AWatch, icon, spellID, name, self)			
	local count = fs(icon, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
	count:SetPoint('BOTTOMRIGHT', icon, 5, -5)
	icon.count = count
	icon.cd:SetReverse(true)
end

local createAuraWatch = function(self, unit)
	if cfg.aw.enable and cfg.spellIDs[class] then
		local auras = CreateFrame('Frame', nil, self)
		auras:SetAllPoints(self.Health)
		auras.onlyShowPresent = cfg.aw.onlyShowPresent
		auras.anyUnit = cfg.aw.anyUnit
		auras.icons = {}
		auras.PostCreateIcon = AWIcon
		
		for i, v in pairs(cfg.spellIDs[class]) do
			local icon = CreateFrame('Frame', nil, auras)
			icon.spellID = v[1]
			icon:SetSize(6, 6)
			if v[3] then
			    icon:SetPoint(v[3])
			else
			    icon:SetPoint('BOTTOMLEFT', self.Health, 'BOTTOMRIGHT', -7 * i, 0)
			end
			icon:SetBackdrop(backdrop)
	        icon:SetBackdropColor(0, 0, 0, 1)
			
			local tex = icon:CreateTexture(nil, 'ARTWORK')
			tex:SetAllPoints(icon)
			tex:SetTexCoord(.1, .9, .1, .9)
			tex:SetTexture(cfg.texture)
			tex:SetVertexColor(unpack(v[2]))
			icon.icon = tex
		
			auras.icons[v[1]] = icon
		end
		self.AuraWatch = auras
	end
end

local channelingTicks = {
	-- Druid
	[GetSpellInfo(740)] = 4,	-- Tranquility
	[GetSpellInfo(16914)] = 10,	-- Hurricane
	[GetSpellInfo(106996)] = 10,-- Astral Storm
	-- Mage
	[GetSpellInfo(5143)] = 5,	-- Arcane Missiles
	[GetSpellInfo(10)] = 8,		-- Blizzard
	[GetSpellInfo(12051)] = 4,	-- Evocation
	-- Monk
	[GetSpellInfo(115175)] = 9,	-- Soothing Mist
	-- Priest
	[GetSpellInfo(15407)] = 3,	-- Mind Flay
	[GetSpellInfo(48045)] = 5,	-- Mind Sear
	[GetSpellInfo(47540)] = 2,	-- Penance
	--[GetSpellInfo(64901)] = 4,	-- Hymn of Hope
	[GetSpellInfo(64843)] = 4,	-- Divine Hymn
	-- Warlock
	[GetSpellInfo(689)] = 6,	-- Drain Life
	[GetSpellInfo(108371)] = 6, -- Harvest Life
	[GetSpellInfo(103103)] = 3,	-- Drain Soul
	[GetSpellInfo(755)] = 6,	-- Health Funnel
	[GetSpellInfo(1949)] = 15,	-- Hellfire
	[GetSpellInfo(5740)] = 4,	-- Rain of Fire
	[GetSpellInfo(103103)] = 3,	-- Malefic Grasp
}

local ticks = {}

local setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(cfg.texture)
				ticks[k]:SetVertexColor(0.6, 0.6, 0.6)
				ticks[k]:SetWidth(1)
				ticks[k]:SetHeight(21)
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint('CENTER', castBar, 'LEFT', delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
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
		if parent.unit == 'player' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText('', duration, self.max, self.delay )
			elseif self.Lag then
				if self.SafeZone.timeDiff >= (self.max*.5) or self.SafeZone.timeDiff == 0 then
					self.Time:SetFormattedText('', duration, self.max)
					self.Lag:SetFormattedText('')
				else
					self.Time:SetFormattedText('', duration, self.max)
					self.Lag:SetFormattedText('', self.SafeZone.timeDiff * 1000)
				end
			else
				self.Time:SetFormattedText('', duration, self.max)
			end
		else
			self.Time:SetFormattedText('', duration, self.casting and self.max + self.delay or self.max - self.delay)
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
	if unit == 'vehicle' then
		self.SafeZone:Hide()
		self.Lag:Hide()
	elseif unit == 'player' then
		local sf = self.SafeZone
		if not sf then return end
		if not sf.sendTime then sf.sendTime = GetTime() end
		sf.timeDiff = GetTime() - sf.sendTime
		sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
		if sf.timeDiff >= (self.max*.5) or sf.timeDiff == 0 then
			sf:SetWidth(0.01)
		else
			sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
		end
		if not UnitInVehicle('player') then sf:Show() else sf:Hide() end
		if self.casting then
			setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			setBarTicks(self, self.channelingTicks)
		end

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
	local cb = createStatusbar(self, cfg.texture, nil, nil, nil, 1, 1, 1, 1)		
	local cbbg = cb:CreateTexture(nil, 'BACKGROUND')
    cbbg:SetAllPoints(cb)
    cbbg:SetTexture(cfg.texture)
    cbbg:SetVertexColor(0, 0, 0, 1)
    cb.Time = fs(cb, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
	cb.Time:SetPoint('RIGHT', cb, -2, 0)		
	cb.Text = fs(cb, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1, 'LEFT')
    cb.Text:SetPoint('LEFT', cb, 2, 0)
    cb.Text:SetPoint('RIGHT', cb.Time, 'LEFT')
	cb.CastingColor = {cfg.Color.Castbar.r, cfg.Color.Castbar.g, cfg.Color.Castbar.b}
	cb.CompleteColor = {0.12, 0.86, 0.15}
	cb.FailColor = {1.0, 0.09, 0}
	cb.ChannelingColor = {0.32, 0.3, 1}
	cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
	cb.Icon:SetPoint('TOPRIGHT', cb, 'TOPLEFT', -1, 0)
    cb.Icon:SetTexCoord(.1, .9, .1, .9)

	if self.unit == 'player' then
		cb:SetPoint(unpack(cfg.player_cb.pos))
		cb:SetSize(cfg.player_cb.width, cfg.player_cb.height)
	    cb.Icon:SetSize(cfg.player_cb.height, cfg.player_cb.height)
		cb.SafeZone = cb:CreateTexture(nil, 'ARTWORK')
		cb.SafeZone:SetTexture(cfg.texture)

		if gempUI.castbar_safezone then 
			safezonealpha = 1
		elseif not gempUI.castbar_safezone then
			safezonealpha = 0
		end
		cb.SafeZone:SetVertexColor(.8,.11,.15, safezonealpha) --Safezone color
		cb.Lag = fs(cb, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
		cb.Lag:SetPoint('BOTTOMRIGHT', 0, -3)
		cb.Lag:SetJustifyH('RIGHT')
		self:RegisterEvent('UNIT_SPELLCAST_SENT', function(_, _, caster)
			if (caster == 'player' or caster == 'vehicle') and self.Castbar.SafeZone then
			self.Castbar.SafeZone.sendTime = GetTime()
				end
		end, true)
	elseif self.unit == 'target' then
		cb:SetPoint(unpack(cfg.target_cb.pos))
		cb:SetSize(cfg.target_cb.width, cfg.target_cb.height)
	    cb.Icon:SetSize(cfg.target_cb.height, cfg.target_cb.height)
	elseif self.unit == 'focus' then
		cb:SetPoint(unpack(cfg.focus_cb.pos))
		cb:SetSize(cfg.focus_cb.width, cfg.focus_cb.height)
		cb.Icon:SetSize(cfg.focus_cb.height, cfg.focus_cb.height)
	elseif self.unit == 'boss' then
		cb:SetPoint(unpack(cfg.boss_cb.pos))
		cb:SetSize(cfg.boss_cb.width, cfg.boss_cb.height)
		cb:SetFrameStrata("HIGH")
		cb.Icon:SetSize(cfg.boss_cb.height, cfg.boss_cb.height)
	elseif self.unit == 'party' then
		cb:SetPoint(unpack(cfg.party_cb.pos))
		cb:SetSize(cfg.party_cb.width, cfg.party_cb.height)
		cb.Icon:SetSize(cfg.party_cb.height, cfg.party_cb.height)
	elseif self.unit == 'arena' then
		cb:SetPoint(unpack(cfg.arena_cb.pos))
		cb:SetSize(cfg.arena_cb.width, cfg.arena_cb.height)
		cb.Icon:SetSize(cfg.arena_cb.height, cfg.arena_cb.height)
	end
	
	cb.Spark = cb:CreateTexture(nil,'OVERLAY')
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
	cb.bg = cbbg
	cb.Backdrop = framebd(cb, cb)
	cb.IBackdrop = framebd(cb, cb.Icon)
	self.Castbar = cb
end

local Healcomm = function(self) 
	local myBar = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.6)
	myBar:SetPoint('TOP')
	myBar:SetPoint('BOTTOM')
	myBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	   
	local otherBar = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.6)
	otherBar:SetPoint('TOP')
	otherBar:SetPoint('BOTTOM')
	otherBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')

    local absorbBar = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.6)
    absorbBar:SetPoint('TOP')
    absorbBar:SetPoint('BOTTOM')
    absorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
	
    local healAbsorbBar = createStatusbar(self.Health, cfg.texture, nil, nil, self:GetWidth(), 0.33, 0.59, 0.33, 0.6)
    healAbsorbBar:SetPoint('TOP')
    healAbsorbBar:SetPoint('BOTTOM')
    healAbsorbBar:SetPoint('LEFT', self.Health:GetStatusBarTexture(), 'RIGHT')
   
   self.HealPrediction = {
      myBar = myBar,
      otherBar = otherBar,
      absorbBar = absorbBar,
      healAbsorbBar = healAbsorbBar,
      maxOverflow = 1,
      frequentUpdates = true,
   }
end

local Portraits = function(self) 
    self.Portrait = CreateFrame('PlayerModel', nil, self)
	self.Portrait:SetAllPoints(self.Health)
	self.Portrait:SetAlpha(0.2)
	self.Portrait:SetFrameLevel(self.Health:GetFrameLevel())
end   

local Health = function(self) 
	local h = createStatusbar(self, cfg.texture, nil, nil, nil, 1, 1, 1, 1)
    h:SetPoint'TOP'
	h:SetPoint'LEFT'
	h:SetPoint'RIGHT'
	
	local hbg = h:CreateTexture(nil, 'BACKGROUND')
    hbg:SetAllPoints(h)
    hbg:SetTexture(cfg.texture)
   
	if cfg.class_colorbars then
        h.colorClass = true
        h.colorReaction = true
		hbg.multiplier = .4
	else
	    h:SetStatusBarColor(cfg.Color.Health.r, cfg.Color.Health.g, cfg.Color.Health.b) 
		if cfg.colorClass_bg then
			h.colorClass_bg = true
			hbg.multiplier = cfg.hbg_multiplier
		else
			hbg:SetVertexColor(cfg.Color.Health_bg.r, cfg.Color.Health_bg.g, cfg.Color.Health_bg.b, cfg.Color.Health_bg.a)
		end
    end

	h.frequentUpdates = false
	
	if cfg.options.smooth then h.Smooth = true end
	
	h.bg = hbg
    self.Health	= h 
	self.Health.PostUpdate = PostUpdateHealth
end

local Power = function(self) 
    local p = createStatusbar(self, cfg.texture, nil, nil, nil, 1, 1, 1, 1)
	p:SetPoint'LEFT'
	p:SetPoint'RIGHT'
    p:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1) 
	
	if unit == 'player' and powerType ~= 0 then p.frequentUpdates = true end	   
		
	if cfg.options.smooth then p.Smooth = true end

    local pbg = p:CreateTexture(nil, 'BACKGROUND')
    pbg:SetAllPoints(p)
    pbg:SetTexture(cfg.texture)
		
    if cfg.class_colorbars then 
		p.colorPower = true
        pbg.multiplier = .4			
    else 
		p.colorClass = true
	    p.colorReaction = true
        pbg.multiplier = .4			
	end
		
	p.bg = pbg
	self.Power = p 
end

local Icons = function(self) 
    self.Leader = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Leader:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, -3)
    self.Leader:SetSize(12, 12)
	    	
	self.Assistant = self.Health:CreateTexture(nil, 'OVERLAY')
	self.Assistant:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, -3)
    self.Assistant:SetSize(12, 12)    
	
	self.MasterLooter = self.Health:CreateTexture(nil, 'OVERLAY')
	self.MasterLooter:SetPoint('LEFT', self.Leader, 'RIGHT')
	self.MasterLooter:SetSize(11, 11)
end

local ph = function(self) 
	local ph = CreateFrame('Frame', nil, self.Health)
	ph:SetFrameLevel(self.Health:GetFrameLevel()+1)
	ph:SetSize(10, 10)
	ph:SetPoint('CENTER', 0,-3)
	ph:SetAlpha(0.2)
	ph.text = fs(ph, 'OVERLAY', cfg.symbol, 18, '', 1, 0, 1)
	ph.text:SetShadowOffset(1, -1)
	ph.text:SetPoint('CENTER')
	ph.text:SetText('M')
    self.PhaseIcon = ph
end

local function SizeUpdate(self, event,unit)
    local spec = GetSpecialization()	
	local stance = GetShapeshiftFormID()
	local lvl = UnitLevel('player')
	if ((class == 'DEATHKNIGHT' or class == 'PALADIN' or class == 'WARLOCK' or (class == 'PRIEST' and spec == SPEC_PRIEST_SHADOW)) and cfg.options.specific_power) or (class == "ROGUE" and cfg.options.cpoints) then
	    self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1)+(cfg.player.specific_power+1))
	elseif class == 'SHAMAN' then
		if  cfg.options.TotemBar and (cfg.options.Maelstrom and (spec == 3) and (lvl >= 50)) then
			self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1)+2*(cfg.player.specific_power+1))
		elseif cfg.options.TotemBar or (cfg.options.Maelstrom and (spec == 3) and (lvl >= 50)) then
			self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1)+(cfg.player.specific_power+1))
		else
			self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1))
		end
	elseif class == 'MONK' then
	    if cfg.options.stagger_bar and cfg.options.specific_power and stance == 23 then 
	        self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1)+2*(cfg.player.specific_power+1))
		elseif (cfg.options.stagger_bar and stance == 23) or cfg.options.specific_power then
		    self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1) +(cfg.player.specific_power+1))
		else
		    self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+self.Power:GetHeight()+1)
		end
	elseif class == 'DRUID' then
		if ((spec == 1 or spec == 4) and cfg.options.MushroomBar) and (stance == 1 and cfg.options.cpoints) then
			self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1)+2*(cfg.player.specific_power+1))
			self.CPoints:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -(cfg.player.specific_power+2))
		elseif ((spec == 1 or spec == 4) and cfg.options.MushroomBar) or (stance == 1 and cfg.options.cpoints) then
			self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1)+(cfg.player.specific_power+1))
			if cfg.options.cpoints then 
				self.CPoints:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -1) 
			end
		else
			self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1))
		end
	else
	    self.dh:SetSize(cfg.player.width, self.Health:GetHeight()+(self.Power:GetHeight()+1))
    end
end

local Shared = function(self, unit)

    self.menu = menu
	
    self:SetScript('OnEnter', OnEnter)
    self:SetScript('OnLeave', OnLeave)
	
    self:RegisterForClicks'AnyUp'
	
	self:SetBackdrop({
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = 0, left = 0, bottom = 0, right = 0},
	})
	
	self:SetBackdropColor(0, 0, 0)
	
	Health(self) 
		
	local ricon = self.Health:CreateTexture(nil, 'OVERLAY')
	ricon:SetTexture(cfg.raidicons)
	ricon:SetSize(20, 20)
	ricon:SetPoint('TOP', 0, 10)
	self.RaidIcon = ricon
	
	local hl = self.Health:CreateTexture(nil, 'OVERLAY')
    hl:SetAllPoints(self)
    hl:SetTexture([=[Interface\Buttons\WHITE8x8]=])
    hl:SetVertexColor(1,1,1,.05)
    hl:SetBlendMode('ADD')
    hl:Hide()
	self.Highlight = hl
	
	if cfg.options.SpellRange then
	    self.SpellRange = {
	    insideAlpha = 1,
        outsideAlpha = cfg.options.range_alpha}
	end
end

local UnitSpecific = {
    player = function(self, ...)
        Shared(self, ...)
		
		self.unit = 'player'
		
		Power(self)
		Icons(self)
		
		if cfg.options.portraits then Portraits(self) end
		
	    if cfg.player_cb.enable then
            castbar(self)
	        PetCastingBarFrame:UnregisterAllEvents()
	        PetCastingBarFrame.Show = function() end
	        PetCastingBarFrame:Hide()
        end
			
		self:SetSize(cfg.player.width, cfg.player.health+cfg.player.power+1)	
		self.Health:SetHeight(cfg.player.health)
	    self.Power:SetHeight(cfg.player.power)

		self.dh = CreateFrame('Frame', 'Player', self)
		self.dh:SetPoint('TOP')
		self.dh:SetFrameStrata('BACKGROUND')
		self.dh:RegisterEvent('PLAYER_TALENT_UPDATE')
		self.dh:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
		self.dh:RegisterEvent('PLAYER_ENTERING_WORLD')
		self.dh:RegisterEvent('PLAYER_LEVEL_UP')
		self.dh:SetScript('OnEvent', function(frame, event, unit) SizeUpdate (self, event, unit) end)

		self.framebd = framebd(self.dh, self.dh)
		
		self.DebuffHighlight = cfg.dh.player
		
		if cfg.options.healcomm then Healcomm(self) end
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
	    self:Tag(name, '[lvl] [color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
		if powerType ~= 0 then htext.frequentUpdates = .1 end
        self:Tag(htext, '[player:hp][player:power]')
		
		local ct = CreateFrame('Frame', nil, self.Health)
        ct:SetSize(10, 10)
        ct:SetPoint('CENTER')
		ct:SetAlpha(0.5)
		ct.text = fs(ct, 'OVERLAY', cfg.symbol, 14, '', 1, 1, 1)
		ct.text:SetShadowOffset(1, -1)
	    ct.text:SetPoint('CENTER')
	    ct.text:SetText('|cffAF5050j|r')
        self.Combat = ct

		local r = CreateFrame('Frame', nil, self)
		r:SetFrameLevel(self.Health:GetFrameLevel()+1)
		r:SetSize(10, 10)
		r:SetPoint('CENTER', 0, -1)
		r:SetAlpha(0.1)
		r.text = fs(r, 'OVERLAY', cfg.symbol, 16, '', class_color.r, class_color.g, class_color.b)
		r.text:SetShadowOffset(1, -1)
	    r.text:SetPoint('CENTER')
	    r.text:SetText('t')
		if cfg.class_colorbars then r.text:SetVertexColor(0.5, 0.5, 1) end
	    self.Resting = r
		
		if cfg.options.pvp then
			local PvP = self.Health:CreateTexture(nil, 'OVERLAY')
			PvP:SetSize(28, 28)
			PvP:SetPoint('BOTTOMLEFT', self.Health, 'TOPRIGHT', -15, -20)
			self.PvP = PvP
		end
		
        if cfg.options.specific_power then 
		    if class == 'DEATHKNIGHT'  then
                local b = CreateFrame('Frame', nil, self)
                b:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
                b:SetSize(cfg.player.width, cfg.player.specific_power)

				local i = 6
                for index = 1, 6 do
                    b[i] = createStatusbar(b, cfg.texture, nil, cfg.player.specific_power, (cfg.player.width+1)/6-1, 1, 1, 1, 1)
				
				    if i == 6 then
                        b[i]:SetPoint('RIGHT', b)
                    else
                        b[i]:SetPoint('RIGHT', b[i+1], 'LEFT', -1, 0)
                    end

                    b[i].bg = b[i]:CreateTexture(nil, 'BACKGROUND')
                    b[i].bg:SetAllPoints(b[i])
                    b[i].bg:SetTexture(cfg.texture)
                    b[i].bg.multiplier = .3

                    i=i-1
                end
                self.Runes = b
            end
			
			if (class == 'PRIEST' or class == 'PALADIN' or class == 'MONK') then
			    local ClassIcons = CreateFrame('Frame', nil, self)
	            ClassIcons:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
	            ClassIcons:SetSize(cfg.player.width, cfg.player.specific_power) 
				
                if class == 'PRIEST' then
					local numMax = UnitPowerMax('player', SPELL_POWER_SHADOW_ORBS)
                    ClassIcons.c = numMax
		        elseif class == 'PALADIN' then
	                local numMax = UnitPowerMax('player', SPELL_POWER_HOLY_POWER)
			        ClassIcons.c = numMax
                elseif class == 'MONK' then
	                local numMax = UnitPowerMax('player', SPELL_POWER_CHI)
			        ClassIcons.c = numMax 							
                end

	            for i = 1, 6 do		
					Icon = createStatusbar(ClassIcons, cfg.texture, nil, cfg.player.specific_power, (cfg.player.width+1)/ClassIcons.c-1, 1, 1, 1, 1)
					
					if i == 1 then
			            Icon:SetPoint('LEFT', ClassIcons)
		            else
			            Icon:SetPoint('LEFT', ClassIcons[i-1], 'RIGHT', 1, 0)
		            end
					
		            ClassIcons[i] = Icon
	            end

	            self.ClassIcons = ClassIcons
		    end
			
		    if class == 'WARLOCK' then
			    wsb = CreateFrame('Frame', nil, self)
			    wsb:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
			    wsb:SetSize(cfg.player.width, cfg.player.specific_power)
				
			    for i = 1, 4 do
				    wsb[i] = createStatusbar(wsb, cfg.texture, nil, cfg.player.specific_power, (cfg.player.width+1)/4-1, 0.9, 0.37, 0.37, 1)
					
				    if i == 1 then
					    wsb[i]:SetPoint('LEFT', wsb, 'LEFT')
				    else
					    wsb[i]:SetPoint('LEFT', wsb[i-1], 'RIGHT', 1, 0)
				    end

				    wsb[i].bg = wsb[i]:CreateTexture(nil, 'BORDER')
				    wsb[i].bg:SetAllPoints()
				    wsb[i].bg:SetTexture(cfg.texture)
				    wsb[i].bg:SetVertexColor(0.9, 0.37, 0.37, .3)
					
					self.WarlockSpecBars = wsb
			    end
	        end
		end
		
		if class == 'DRUID' and cfg.EclipseBar.enable then
            local ebar = CreateFrame('Frame', nil, self)
            ebar:SetPoint(unpack(cfg.EclipseBar.pos))
            ebar:SetSize(cfg.player.width, cfg.EclipseBar.height)
		    ebar.bd = framebd(ebar, ebar)
			
			ebar.Alpha = cfg.EclipseBar.Alpha

            local lbar = createStatusbar(ebar, cfg.texture, nil, cfg.EclipseBar.height, cfg.player.width, 0, .4, 1, 1)
            lbar:SetPoint('LEFT', ebar, 'LEFT')
            ebar.LunarBar = lbar

            local sbar = createStatusbar(ebar, cfg.texture, nil, cfg.EclipseBar.height, cfg.player.width, 1, .6, 0, 1)
            sbar:SetPoint('LEFT', lbar:GetStatusBarTexture(), 'RIGHT')
            ebar.SolarBar = sbar
			
            ebar.Spark = sbar:CreateTexture(nil, 'OVERLAY')
            ebar.Spark:SetTexture([=[Interface\Buttons\WHITE8x8]=])
            ebar.Spark:SetBlendMode('ADD')
            ebar.Spark:SetHeight(cfg.EclipseBar.height)
			ebar.Spark:SetWidth(1)
            ebar.Spark:SetPoint('LEFT', sbar:GetStatusBarTexture(), 'LEFT', 0, 0)
				
		    ebar.Text = fs(ebar.SolarBar, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 0.8, 0.8, 0.8)
            ebar.Text:SetPoint('CENTER', ebar)
            self:Tag(ebar.Text, '[EclipseDirection]')
					
		    self.EclipseBar = ebar
        end
			
		if (class == 'SHAMAN' and cfg.options.TotemBar) or (class == 'DRUID' and cfg.options.MushroomBar) then
	        local tb = CreateFrame('Frame', nil, self)
		    tb:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
			tb:SetSize(cfg.player.width, cfg.player.specific_power)	   
	        tb.Destroy = true
			
			if class == 'SHAMAN' then
			    tb.c = 4
			elseif class == 'DRUID' then
			    tb.c = 3
			end
			   
	        for i = 1, tb.c do
				t = createStatusbar(tb, cfg.texture, nil, cfg.player.specific_power, (cfg.player.width+1)/tb.c-1, 1, 1, 1, 1)
					
		        if (i == 1) then
			        t:SetPoint('LEFT', tb, 'LEFT', 0, 0)
		        else
			        t:SetPoint('TOPLEFT', tb[i-1], 'TOPRIGHT', 1, 0)
		        end

		        t.bg = t:CreateTexture(nil, 'BACKGROUND')
		        t.bg:SetAllPoints()
		        t.bg:SetTexture(1, 1, 1)
		        t.bg.multiplier = 0.2

		        tb[i] = t
	        end
			
	        self.TotemBar = tb			
		end
		
		if class == 'SHAMAN' and cfg.options.Maelstrom then
	        local ms = CreateFrame('Frame', nil, self)
			ms:SetSize(cfg.player.width, cfg.player.specific_power)

			if cfg.options.TotemBar then
		        ms:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -(cfg.player.specific_power+2))
			else
			    ms:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
			end
			
			ms.c = 5
			   
	        for i = 1, ms.c do
				m = createStatusbar(ms, cfg.texture, nil, cfg.player.specific_power, (cfg.player.width+1)/ms.c-1, .45, .35, .65, 1)
					
		        if (i == 1) then
			        m:SetPoint('LEFT', ms, 'LEFT', 0, 0)
		        else
			        m:SetPoint('TOPLEFT', ms[i-1], 'TOPRIGHT', 1, 0)
		        end	
				ms[i] = m
	        end
			
	        self.Maelstrom = ms			
		end
		
		if class == 'MONK' and cfg.options.stagger_bar then
		
		    local Stagger = CreateFrame('StatusBar', nil, self)
			
			Stagger:SetSize(cfg.player.width, cfg.player.specific_power)
			Stagger:SetStatusBarTexture(cfg.texture)
		    
			if cfg.options.specific_power then
		        Stagger:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -(cfg.player.specific_power+2))
			else
			    Stagger:SetPoint('TOPRIGHT', self.Power, 'BOTTOMRIGHT', 0, -1)
			end
		
		    Stagger.bg = Stagger:CreateTexture(nil, 'BORDER')
		    Stagger.bg:SetAllPoints()
		    Stagger.bg:SetTexture(cfg.texture)
		    Stagger.bg:SetVertexColor(0.52, 1.0, 0.52)
			Stagger.bg.multiplier = .4

            self.Stagger = Stagger
		
		end
		
		if cfg.options.cpoints and (class == 'DRUID' or class == 'ROGUE') then
		    local cp = CreateFrame('Frame', nil, self)
			if class == 'DRUID' and cfg.options.MushroomBar then
				cp:RegisterEvent('PLAYER_TALENT_UPDATE')
				cp:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
				cp:RegisterEvent('PLAYER_ENTERING_WORLD')
				cp:SetScript('OnEvent', function(frame, event, unit) SizeUpdate (self, event, unit) end)
			else
				cp:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -1)
			end
            cp:SetSize(cfg.player.width, cfg.player.specific_power)
			
		    local i = 5
            for index = 1, 5 do
                cp[i] = createStatusbar(cp, cfg.texture, nil, cfg.player.specific_power, (cfg.player.width+1)/5-1, cfg.Color.CPoints.r, cfg.Color.CPoints.g, cfg.Color.CPoints.b, 1)
				
                if i == 5 then
                    cp[i]:SetPoint('RIGHT', cp)
                else
                    cp[i]:SetPoint('RIGHT', cp[i+1], 'LEFT', -1, 0)
                end

                i=i-1
            end	
			
		    self.CPoints = cp
		end
		
		if cfg.gcd.enable then
		    local gcd = createStatusbar(self, cfg.texture, nil, cfg.gcd.height, cfg.gcd.width, class_color.r, class_color.g, class_color.b, 1)
		    gcd:SetPoint(unpack(cfg.gcd.pos))
			gcd.bg = gcd:CreateTexture(nil, 'BORDER')
            gcd.bg:SetAllPoints(gcd)
            gcd.bg:SetTexture(cfg.texture)
            gcd.bg:SetVertexColor(class_color.r, class_color.g, class_color.b, 0.4)
			gcd.bd = framebd(gcd, gcd)	
			self.GCD = gcd
		end
        
	    if cfg.treat.enable then
		    local treat = createStatusbar(UIParent, cfg.texture, nil, cfg.treat.height, cfg.treat.width, 1, 1, 1, 1)
			treat:SetFrameStrata('LOW')
	        treat:SetPoint(unpack(cfg.treat.pos))
			treat.useRawThreat = false
			treat.usePlayerTarget = false	
			treat.bg = treat:CreateTexture(nil, 'BACKGROUND')
            treat.bg:SetAllPoints(treat)
            treat.bg:SetTexture(cfg.texture)
            treat.bg:SetVertexColor(1, 1, 1, 0.3)
			if cfg.treat.text then
				treat.Title = fs(treat, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 0.8, 0.8, 0.8)
				treat.Title:SetText('Threat:')
				treat.Title:SetPoint('RIGHT', treat, 'CENTER')
				treat.Text = fs(treat, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 0.8, 0.8, 0.8)
				treat.Text:SetPoint('LEFT', treat, 'CENTER')
			end
	        treat.bg = framebd(treat, treat)
			self.ThreatBar = treat
		end
		
        if cfg.exp_rep.enable then 
            if UnitLevel('player') < MAX_PLAYER_LEVEL then		    
                e = createStatusbar(self, cfg.texture, nil, cfg.treat.height, cfg.treat.width, 0, .7, 1, 1)
				e:SetFrameStrata('LOW')
				if cfg.exp_rep.unlock then
				    e:SetPoint(gempUI.xp_rep.a, gempUI.xp_rep.b, gempUI.xp_rep.c, gempUI.xp_rep.x, gempUI.xp_rep.y)
					e:SetSize(cfg.exp_rep.width, cfg.exp_rep.height) 
				else
				    e:SetPoint(unpack(cfg.treat.pos))
				end
                e.Rested = createStatusbar(e, cfg.texture, nil, nil, nil, 0, .4, 1, .6)
                e.Rested:SetAllPoints(e)
                e.bg = e.Rested:CreateTexture(nil, 'BORDER')
                e.bg:SetAllPoints(e)
                e.bg:SetTexture(cfg.texture)
                e.bg:SetVertexColor(0, .7, 1, 0.4)
			    e.text = fs(e, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
	            e.text:SetPoint('CENTER',0,0)
				if cfg.exp_rep.show_text_on_mouseover then
					e.text:Hide()
					e:SetScript('OnEnter', function(self)UIFrameFadeIn(e.text, 0.3, 0, 1)end)
	                e:SetScript('OnLeave', function(self)UIFrameFadeOut(e.text, 0.3, 1, 0)end)
				end
                e.bd = framebd(e, e)
			    self.Experience = e

		    else 
		        local r = createStatusbar(self, cfg.texture, nil, cfg.treat.height, cfg.treat.width, 0, .7, 1, 1)
				r:SetFrameStrata('LOW')
				if cfg.exp_rep.unlock then
				    if SkadaBarWindowSkada:IsShown() then
						r:SetPoint("CENTER", button_wDamage, "TOPRIGHT", -89, -103)
					elseif gAC_3visible == true then 
						r:SetPoint("CENTER", button_wDamage, "TOPRIGHT", -89, -102)
					elseif wWM_visible == true then
						r:SetPoint("CENTER", button_wDamage, "TOPRIGHT", -89, -100)
					else 
						r:SetPoint(gempUI.xp_rep.a, gempUI.xp_rep.b, gempUI.xp_rep.c, gempUI.xp_rep.x, gempUI.xp_rep.y)
					end
			        r:SetSize(cfg.exp_rep.width, cfg.exp_rep.height)
				else
				    r:SetPoint(unpack(cfg.treat.pos))
				end
		        r.bg = r:CreateTexture(nil, 'BORDER')
		        r.bg:SetAllPoints(r)
                r.bg:SetTexture(cfg.texture)
                r.bg:SetVertexColor(0, .7, 1, 0.4)	
			    r.text = fs(r, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
	            r.text:SetPoint('CENTER')
				if cfg.exp_rep.show_text_on_mouseover then
					r.text:Hide()
					r:SetScript('OnEnter', function(self)UIFrameFadeIn(r.text, 0.3, 0, 1)end)
	                r:SetScript('OnLeave', function(self)UIFrameFadeOut(r.text, 0.3, 1, 0)end)
				end
		        r.bd = framebd(r, r)
		        self.Reputation = r		
            end					
	    end
	    
	    if cfg.AltPowerBar.player.enable then
	       local altp = createStatusbar(self, cfg.texture, nil, cfg.AltPowerBar.player.height, cfg.AltPowerBar.player.width, 1, 1, 1, 1)
           altp:SetPoint(unpack(cfg.AltPowerBar.player.pos))
		   altp.bd = framebd(altp, altp) 
           altp.bg = altp:CreateTexture(nil, 'BORDER')
           altp.bg:SetAllPoints(altp)
           altp.bg:SetTexture(cfg.texture)
           altp.bg:SetVertexColor(1, 1, 1, 0.3)
           altp.Text = fs(altp, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
           altp.Text:SetPoint('CENTER')
           self:Tag(altp.Text, '[altpower]') 
		   altp:EnableMouse(true)
		   altp.colorTexture = true
           self.AltPowerBar = altp
	    end
			
        if cfg.aura.player_debuffs then
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
			d.num = cfg.aura.player_debuffs_num 
            d:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 7)
			d:SetSize(cfg.player.width, d.size)
            d.initialAnchor = 'TOPLEFT'
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            d.CustomFilter = CustomFilter
            self.Debuffs = d
        end
    end,

    target = function(self, ...)
        Shared(self, ...)
		
		self.unit = 'target'
		
		Power(self)
		Icons(self)
		ph(self) 
		
		self.framebd = framebd(self, self)
		
		self.DebuffHighlight = cfg.dh.target
		
		if cfg.target_cb.enable then castbar(self) end
		if cfg.options.healcomm then Healcomm(self) end
		if cfg.options.portraits then Portraits(self) end
		
		self:SetSize(cfg.player.width, cfg.player.health+cfg.player.power+1)
		self.Power:SetHeight(cfg.player.power)
		self.Power.PostUpdate = PostUpdatePower
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, '[lvl] [color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
		--htext.frequentUpdates = .1
        self:Tag(htext, '[player:hp]')
		
		local q = fs(self.Health, 'OVERLAY', cfg.font, 16, cfg.fontflag, 1, 1, 1)
	    q:SetPoint('CENTER')
	    q:SetText('|cff8AFF30!|r')
	    self.QuestIcon = q
		
		if cfg.options.pvp then
			local PvP = self.Health:CreateTexture(nil, 'OVERLAY')
			PvP:SetSize(28, 28)
			PvP:SetPoint('BOTTOMLEFT', self.Health, 'TOPRIGHT', -15, -20)
			self.PvP = PvP
		end
	
		if cfg.aura.target_buffs then
            local b = CreateFrame('Frame', nil, self)
			b.size = 24
			b.spacing = 4
		    b.num = cfg.aura.target_buffs_num
            b:SetSize(b.size*b.num/2+b.spacing*(b.num/2-1), b.size)
		    b:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, 0)
            b.initialAnchor = 'TOPLEFT' 
            b['growth-y'] = 'DOWN'
            b.PostCreateIcon = auraIcon
            b.PostUpdateIcon = PostUpdateIcon
            self.Buffs = b
		end
		
        if cfg.aura.target_debuffs then
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
		    d.num = cfg.aura.target_debuffs_num
            d:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 7)
			d:SetSize(cfg.player.width, d.size)
            d.initialAnchor = 'TOPLEFT'
            d.onlyShowPlayer = cfg.aura.onlyShowPlayer
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            d.CustomFilter = CustomFilter
            self.Debuffs = d       
        end
    end,

    focus = function(self, ...)
        Shared(self, ...)
		
		self.unit = 'focus'
		
		Power(self)
		Icons(self)
		ph(self)

		self.framebd = framebd(self, self)
		
		self.DebuffHighlight = cfg.dh.focus
		
		if cfg.focus_cb.enable then castbar(self) end
		
		self:SetSize(cfg.party.width, cfg.party.health+cfg.party.power+1)
		self.Power:SetHeight(cfg.player.power)
		self.Power.PostUpdate = PostUpdatePower
		
		if cfg.options.healcomm then Healcomm(self) end
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, '[color][short:name]')
		
		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
        self:Tag(htext, '[party:hp]')
		
		if cfg.aura.focus_debuffs then
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
			d.num = cfg.aura.focus_debuffs_num
            d:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 1, 7)
			d:SetSize(cfg.party.width, d.size)
            d.initialAnchor = 'TOPLEFT'
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d
        end
		
		if cfg.aura.focus_buffs then 
            local b = CreateFrame('Frame', nil, self)
			b.size = 24
			b.spacing = 4
			b.num = cfg.aura.focus_buffs_num
            b:SetSize(b.num/2*b.size+b.spacing*(b.num/2-1), b.size)	
			b:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, 0)
            b.initialAnchor = 'TOPRIGHT'
			b['growth-x'] = 'LEFT'
			b['growth-y'] = 'DOWN'
            b.PostCreateIcon = auraIcon
            b.PostUpdateIcon = PostUpdateIcon
            self.Buffs = b
		end
    end,

	boss = function(self, ...)
        Shared(self, ...)
		
		self.unit = 'boss'
		
		--Power(self)
		ph(self)
		
		self.framebd = framebd(self, self)
		
		self.Health.frequentUpdates = true
		
		self.SpellRange.outsideAlpha = 1
		
		if cfg.boss_cb.enable then castbar(self) end
		
	    self:SetSize(cfg.party.width, cfg.party.health+13) -- +cfg.party.power
		--self.Power:SetHeight(0)
		--self.Power.PostUpdate = PostUpdatePower
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, '[color][long:name]')
		
		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
        self:Tag(htext, '[boss:hp]')
		
		if cfg.AltPowerBar.boss.enable then
	       local altp = createStatusbar(self, cfg.texture, nil, cfg.AltPowerBar.boss.height, cfg.AltPowerBar.boss.width, 1, 1, 1, 1)
           altp:SetPoint(unpack(cfg.AltPowerBar.boss.pos))
		   altp.bd = framebd(altp, altp) 
           altp.bg = altp:CreateTexture(nil, 'BORDER')
           altp.bg:SetAllPoints(altp)
           altp.bg:SetTexture(cfg.texture)
           altp.bg:SetVertexColor(1, 1, 1, 0.3)
           altp.Text = fs(altp, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 1, 1, 1)
           altp.Text:SetPoint('CENTER')
           self:Tag(altp.Text, '[altpower]') 
		   altp:EnableMouse(true)
		   altp.colorTexture = true
           self.AltPowerBar = altp
	    end
		
		if cfg.aura.boss_buffs then 
            local b = CreateFrame('Frame', nil, self)
			b.size = 24
			b.spacing = 4
			b.num = cfg.aura.boss_buffs_num
            b:SetSize(b.num*b.size+b.spacing*(b.num-1), b.size)	
			b:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, 0)
            b.initialAnchor = 'TOPRIGHT'
			b['growth-x'] = 'LEFT'
            b.PostCreateIcon = auraIcon
            b.PostUpdateIcon = PostUpdateIcon
            self.Buffs = b
		end
		
        if cfg.aura.boss_debuffs then
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
			d.num = cfg.aura.boss_debuffs_num
			d:SetSize(d.num*d.size+d.spacing*(d.num-1), d.size)
            d:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, 0)
            d.initialAnchor = 'TOPLEFT'
			d.onlyShowPlayer = true
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d			
        end
    end,

    pet = function(self, ...)
        Shared(self, ...)
		
		ph(self)
		
		self:SetSize(cfg.target.width, cfg.target.height)
		
		self.framebd = framebd(self, self)
		
		self.DebuffHighlight = cfg.dh.pet
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
		
    end,
	
	partytarget = function(self, ...)
        Shared(self, ...)
		
		self.framebd = framebd(self, self)
		
		self.DebuffHighlight = cfg.dh.partytarget
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
		
    end,

    targettarget = function(self, ...)
	    Shared(self, ...)
				 
	    self:SetSize(cfg.target.width, cfg.target.height)
		
		self.framebd = framebd(self, self)
		
		self.DebuffHighlight = cfg.dh.targettarget
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('CENTER')
		self:Tag(name, '[color][short:name]')
		 
        if cfg.aura.targettarget_debuffs then 
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
			d.num = cfg.aura.targettarget_debuffs_num
            d:SetSize(d.num*d.size+d.spacing*(d.num-1), d.size)
            d:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, 0)
            d.initialAnchor = 'TOPLEFT'
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d
        end
    end,
	
	party = function(self, ...)
		Shared(self, ...)
		
		self.unit = 'party'
		
		Power(self)
		Icons(self)
		ph(self)
		
		self.framebd = framebd(self, self)
	
	    self.DebuffHighlight = cfg.dh.party
		
		if cfg.party_cb.enable then castbar(self) end
		
		self.Health:SetHeight(cfg.party.health)
		self.Power:SetHeight(cfg.party.power)
		
		if cfg.options.healcomm then Healcomm(self) end
		
		local lfd = fs(self.Health, 'OVERLAY', cfg.symbol, 13, OUTLINE, 1, 1, 1)
		lfd:SetPoint('LEFT', 4, 0)
		lfd:SetJustifyH'LEFT'
	    self:Tag(lfd, '[LFD]')
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', lfd, 'RIGHT', 0, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, ' [color][short:name] [lvl]')
		
		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
        self:Tag(htext, '[party:hp]')
		
		local rc = self.Health:CreateTexture(nil, 'OVERLAY')
	    rc:SetPoint('CENTER')
	    rc:SetSize(12, 12)
		self.ReadyCheck = rc
		
		if cfg.aura.party_buffs then			
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
			d.num = cfg.aura.party_buffs_num
            d:SetSize(d.num*d.size+d.spacing*(d.num-1), d.size)
            d:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, 0)
            d.initialAnchor = 'TOPRIGHT'
			d['growth-x'] = 'LEFT'
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d
	    end
    end,
	
	arena = function(self, ...)
		Shared(self, ...)
		
		self.unit = 'arena'
		
		Power(self)
		Icons(self)
		ph(self)
		
		self.framebd = framebd(self, self)
	
		self.DebuffHighlight = cfg.dh.arena
		
		if cfg.arena_cb.enable then castbar(self) end
		
		self:SetSize(cfg.party.width, cfg.party.health+cfg.party.power+1)
		self.Health:SetHeight(cfg.party.health)
		self.Power:SetHeight(cfg.party.power)
		
		if cfg.options.healcomm then Healcomm(self) end
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, '[color][long:name]')
		
		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
        self:Tag(htext, '[party:hp]')
		
		if cfg.options.pvp then
			local PvP = self.Health:CreateTexture(nil, 'OVERLAY')
			PvP:SetSize(28, 28)
			PvP:SetPoint('BOTTOMLEFT', self.Health, 'TOPRIGHT', -15, -20)
			self.PvP = PvP
		end
		
		local t = CreateFrame('Frame', nil, self)
		t:SetSize(cfg.party.health+cfg.party.power+1, cfg.party.health+cfg.party.power+1)
		t:SetPoint('TOPRIGHT', self, 'TOPLEFT', -3, 0)
		t.framebd = framebd(t, t)	
		self.Trinket = t
		
		local at = CreateFrame('Frame', nil, self)
		at:SetAllPoints(t)
		at:SetFrameStrata('HIGH')
		at.icon = at:CreateTexture(nil, 'ARTWORK')
		at.icon:SetAllPoints(at)
		at.icon:SetTexCoord(0.07,0.93,0.07,0.93)  
		self.AuraTracker = at	
    end,

    raid = function(self, ...)
		Shared(self, ...)
		
		Power(self)
		Icons(self)
		createAuraWatch(self)
		
		self.framebd = framebd(self, self)
	
		self.DebuffHighlight = cfg.dh.raid
		
		self.Health:SetHeight(cfg.raid.health)
		self.Power:SetHeight(cfg.raid.power)
		
		if cfg.options.healcomm then Healcomm(self) end
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
		name:SetPoint('LEFT', 5, 5)
	    name:SetJustifyH'LEFT'
		self:Tag(name, '[color][veryshort:name]')

        local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -5, -8)
		htext:SetJustifyH'RIGHT'
        self:Tag(htext, '[raid:hp]')		
		
		local lfd = fs(self.Health, 'OVERLAY', cfg.symbol, 12, '', 1, 1, 1)
		lfd:SetPoint('BOTTOMLEFT', 6, 1)
	    self:Tag(lfd, '[LFD]')	
		
		self.RaidIcon:SetSize(14, 14)
	    self.RaidIcon:SetPoint('TOP', self.Health, 0, 8)
		
		local rc = self.Health:CreateTexture(nil, 'OVERLAY')
	    rc:SetPoint('BOTTOM')
	    rc:SetSize(12, 12)
		self.ReadyCheck = rc
		
		if cfg.options.ResurrectIcon then
			local r = CreateFrame('Frame', nil, self)
			r:SetSize(20, 20)
			r:SetPoint('CENTER')
			r:SetFrameStrata'HIGH'
			r:SetBackdrop(backdrop)
			r:SetBackdropColor(.2, .6, 1)
			r.icon = r:CreateTexture(nil, 'OVERLAY')
			r.icon:SetTexture[[Interface\Icons\Spell_Holy_Resurrection]]
			r.icon:SetTexCoord(.1, .9, .1, .9)
			r.icon:SetAllPoints(r)
			self.ResurrectIcon	= r
		end
		
	    if cfg.RaidDebuffs.enable then
	       local d = CreateFrame('Frame', nil, self)
	       d:SetSize(cfg.RaidDebuffs.size, cfg.RaidDebuffs.size)
	       d:SetPoint(unpack(cfg.RaidDebuffs.pos))
	       d:SetFrameStrata'HIGH'
	       d:SetBackdrop(backdrop)
	       d.icon = d:CreateTexture(nil, 'OVERLAY')
	       d.icon:SetTexCoord(.1,.9,.1,.9)
	       d.icon:SetAllPoints(d)
	       d.time = fs(d, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 0.8, 0.8, 0.8)
	       d.time:SetPoint('TOPLEFT', d, 'TOPLEFT', 0, 0)
		   d.count = fs(d, 'OVERLAY', cfg.aura.font, cfg.aura.fontsize, cfg.aura.fontflag, 0.8, 0.8, 0.8)
	       d.count:SetPoint('BOTTOMRIGHT', d, 'BOTTOMRIGHT', 2, 0)
		   self.RaidDebuffs = d
	    end

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
	    
		self:RegisterEvent('PLAYER_TARGET_CHANGED', ChangedTarget)
        self:RegisterEvent('RAID_ROSTER_UPDATE', ChangedTarget)
		self:RegisterEvent('PLAYER_FOCUS_CHANGED', FocusTarget)
        self:RegisterEvent('RAID_ROSTER_UPDATE', FocusTarget)
    end,
}

UnitSpecific.focustarget = UnitSpecific.pet

oUF:RegisterStyle('Skaarj', Shared)

for unit,layout in next, UnitSpecific do
    oUF:RegisterStyle('Skaarj - ' .. unit:gsub('^%l', string.upper), layout)
end

local spawnHelper = function(self, unit, ...)
    if(UnitSpecific[unit]) then
        self:SetActiveStyle('Skaarj - ' .. unit:gsub('^%l', string.upper))
    elseif(UnitSpecific[unit:match('[^%d]+')]) then 
        self:SetActiveStyle('Skaarj - ' .. unit:match('[^%d]+'):gsub('^%l', string.upper))
    else
        self:SetActiveStyle'Skaarj'
    end
    local object = self:Spawn(unit)
    object:SetPoint(...)
    return object
end

oUF:Factory(function(self)
    spawnHelper(self, 'player', 'TOP', cfg.unit_positions.Player.a, 'BOTTOM',cfg.unit_positions.Player.x, cfg.unit_positions.Player.y)
    spawnHelper(self, 'target', 'TOP', cfg.unit_positions.Target.a, 'BOTTOM', cfg.unit_positions.Target.x, cfg.unit_positions.Target.y)
    spawnHelper(self, 'targettarget', 'RIGHT', cfg.unit_positions.Targettarget.a, cfg.unit_positions.Targettarget.x, cfg.unit_positions.Targettarget.y)
    spawnHelper(self, 'focus', 'RIGHT', cfg.unit_positions.Focus.a, 'TOPLEFT', cfg.unit_positions.Focus.x, cfg.unit_positions.Focus.y)
    spawnHelper(self, 'focustarget', 'TOPRIGHT', cfg.unit_positions.Focustarget.a, cfg.unit_positions.Focustarget.x, cfg.unit_positions.Focustarget.y)
    spawnHelper(self, 'pet', 'LEFT', cfg.unit_positions.Pet.a, cfg.unit_positions.Pet.x, cfg.unit_positions.Pet.y)
	
    if cfg.uf.boss then
	    for i = 1, MAX_BOSS_FRAMES do
            spawnHelper(self, 'boss' .. i, 'LEFT', cfg.unit_positions.Boss.a, 'RIGHT', cfg.unit_positions.Boss.x, cfg.unit_positions.Boss.y - (51 * i))
        end
    end
	
	if cfg.uf.arena then
		local arena = {}	
		self:SetActiveStyle'Skaarj - Arena'
		for i = 1, 5 do
			arena[i] = self:Spawn('arena'..i, 'oUF_Arena'..i)
			if i == 1 then
				arena[i]:SetPoint('LEFT', cfg.unit_positions.Arena.a, 'RIGHT',cfg.unit_positions.Arena.x, cfg.unit_positions.Arena.y)
			else
				arena[i]:SetPoint('TOP', arena[i-1], 'BOTTOM', 0, -23)
			end
		end	
        local arenatarget = {}		
		self:SetActiveStyle'Skaarj - Pet'
		for i = 1, 5 do
			arenatarget[i] = self:Spawn('arena'..i..'target', 'oUF_Arena'..i..'target')
			if i == 1 then
				arenatarget[i]:SetPoint('TOPLEFT', arena[i], 'TOPRIGHT', 5, 0)
			else
				arenatarget[i]:SetPoint('TOP', arenatarget[i-1], 'BOTTOM', 0, -27)
			end
		end
		
		local arenaprep = {}
	    for i = 1, 5 do
		    arenaprep[i] = CreateFrame('Frame', 'oUF_ArenaPrep'..i, UIParent)
		    arenaprep[i]:SetAllPoints(_G['oUF_Arena'..i])
		    arenaprep[i]:SetFrameStrata('BACKGROUND')
			arenaprep[i].framebd = framebd(arenaprep[i], arenaprep[i])

		    arenaprep[i].Health = CreateFrame('StatusBar', nil, arenaprep[i])
		    arenaprep[i].Health:SetAllPoints()
		    arenaprep[i].Health:SetStatusBarTexture(cfg.texture)

		    arenaprep[i].Spec = fs(arenaprep[i].Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
		    arenaprep[i].Spec:SetPoint('CENTER')
			arenaprep[i].Spec:SetJustifyH'CENTER'

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
				    arenaprep[i]:SetAllPoints(_G['oUF_Arena'..i])
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
								if cfg.class_colorbars then
								    f.Health:SetStatusBarColor(class_color.r, class_color.g, class_color.b)
								else
								    f.Health:SetStatusBarColor(cfg.Color.Health.r, cfg.Color.Health.g, cfg.Color.Health.b)
								end
							    f.Spec:SetText(spec..'  -  '..LOCALIZED_CLASS_NAMES_MALE[class])
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
	end
	
    if cfg.uf.party then
		for i = 1, MAX_PARTY_MEMBERS do
			local pet = 'PartyMemberFrame'..i..'PetFrame'
			_G[pet]:SetParent(Hider)
			_G[pet..'HealthBar']:UnregisterAllEvents()
		end
		if cfg.options.showRaid then
		    self:SetActiveStyle'Skaarj - Raid'
            local party = self:SpawnHeader('oUF_Party', nil, 'party','showPlayer',
			cfg.options.showPlayer,'showSolo',false,'showParty',true ,'point','LEFT','xOffset', 5,'yOffset', -5,
			'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(cfg.raid.health+cfg.raid.power+1, cfg.raid.width)
		)
            party:SetPoint('TOPLEFT',cfg.unit_positions.Party.a,'TOPLEFT',cfg.unit_positions.Party.x,cfg.unit_positions.Party.y)
		else
		    self:SetActiveStyle'Skaarj - Party'
            local party = self:SpawnHeader('oUF_Party',nil,'party',
			'showPlayer',cfg.options.showPlayer,'showSolo',false,'showParty',true ,'yOffset', -23,
			'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(cfg.party.health+cfg.party.power+1,cfg.party.width)
		)
            party:SetPoint('TOPLEFT',cfg.unit_positions.Party.a,'TOPLEFT',cfg.unit_positions.Party.x,cfg.unit_positions.Party.y)
		    
			if cfg.uf.party_target then
		        self:SetActiveStyle'Skaarj - Partytarget' --'custom [@raid6,exists] hide; show'
		        local partytargets = self:SpawnHeader('oUF_PartyTargets', nil, 'party',
			    'showParty', true,'showSolo',false,'yOffset', -27,
			    'oUF-initialConfigFunction', ([[
				self:SetAttribute('unitsuffix', 'target')
				self:SetHeight(%d)
				self:SetWidth(%d)
				]]):format(cfg.target.height,cfg.target.width)
				)
		        partytargets:SetPoint('TOPLEFT', 'oUF_Party', 'TOPRIGHT', 5, 0)
			end
		end
    end
	
	if cfg.uf.tank then
	    self:SetActiveStyle'Skaarj - Party'
	    local maintank = self:SpawnHeader('oUF_MainTank', nil, 'raid',
		'showRaid', true,'showSolo',false, 'groupFilter', 'MAINTANK', 'yOffset', -23,
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(cfg.party.health+cfg.party.power+1,cfg.party.width)
		)
	    maintank:SetPoint('RIGHT', cfg.unit_positions.Tank.a, 'LEFT', cfg.unit_positions.Tank.x, cfg.unit_positions.Tank.y)
		
		if cfg.uf.tank_target then
		    self:SetActiveStyle'Skaarj - Partytarget'
		    local maintanktarget = self:SpawnHeader('oUF_MainTankTargets', nil, 'raid',
		    'showRaid', true,'showSolo',false,'groupFilter','MAINTANK','yOffset', -27, 
		    'oUF-initialConfigFunction', ([[
			self:SetAttribute('unitsuffix', 'target')
			self:SetHeight(%d)
			self:SetWidth(%d)
			]]):format(cfg.target.height,cfg.target.width)
			)
		    maintanktarget:SetPoint('TOPLEFT', 'oUF_MainTank', 'TOPRIGHT', 6,0)	
        end		
	end 
	
	if cfg.options.disableRaidFrameManager then
	    if IsAddOnLoaded('Blizzard_CompactRaidFrames') then
			CompactRaidFrameManager:SetParent(Hider)
			CompactUnitFrameProfiles:UnregisterAllEvents()
		end
	end

	if cfg.uf.raid then
	    self:SetActiveStyle'Skaarj - Raid'
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
		]]):format(cfg.raid.health+cfg.raid.power+1, cfg.raid.width)
		)
		raid:SetPoint('TOPLEFT', cfg.unit_positions.Raid.a, 'TOPLEFT', cfg.unit_positions.Raid.x, cfg.unit_positions.Raid.y)
	end
end)