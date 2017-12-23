local F, G, V = unpack(select(2, ...))
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
        return format('%dd', floor(s/day + 0.5))
    elseif s >= hour then
        return format('%dh', floor(s/hour + 0.5))
    elseif s >= minute then
        return format('%dm', floor(s/minute + 0.5))
    end
    return format('%d', fmod(s, minute))
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
	button:SetBackdropColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)
	
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
	local cb = createStatusbar(self, cfg.texture, nil, nil, nil, G.color.r, G.color.g, G.color.b, G.color.a)	
	
    cb.Time = fs(cb, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
	cb.Time:SetPoint('RIGHT', cb, -2, 0)		
	cb.Text = fs(cb, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1, 'LEFT')
    cb.Text:SetPoint('LEFT', cb, 2, 0)
    cb.Text:SetPoint('RIGHT', cb.Time, 'LEFT')
	cb.CastingColor = {G.color.r, G.color.g, G.color.b, G.color.a}
	cb.CompleteColor = {0.12, 0.86, 0.15, G.color.a}
	cb.FailColor = {1.0, 0.09, 0, G.color.a}
	cb.ChannelingColor = {0.32, 0.3, G.color.a}
	cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
	cb.Icon:SetPoint('TOPRIGHT', cb, 'TOPLEFT', -1, 0)
	cb.Icon:SetTexCoord(.1, .9, .1, .9)

	if self.unit == 'player' then
		cb:SetPoint(unpack(cfg.player_cb.pos))
		cb:SetSize(cfg.player_cb.width, cfg.player_cb.height)
	    cb.Icon:SetSize(cfg.player_cb.height, cfg.player_cb.height)
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

	cb.Backdrop = F.createBorderFrame(cb, cb, true)
	cb.IBackdrop = F.createBorderFrame(cb, cb.Icon, true)
	self.Castbar = cb
end

local Health = function(self) 
	local h = createStatusbar(self, G.texture, nil, nil, nil, G.color.r, G.color.g, G.color.b, G.color.a)
    h:SetPoint'TOP'
	h:SetPoint'LEFT'
	h:SetPoint'RIGHT'
    
	h.frequentUpdates = false
		
    self.Health	= h 
	self.Health.PostUpdate = PostUpdateHealth
end

local Power = function(self) 
    local p = createStatusbar(self, cfg.texture, nil, nil, nil, G.color.r, G.color.g, G.color.b, G.color.a)
	p:SetPoint('LEFT', self.Health, 'LEFT', 1, 0)
	p:SetPoint('RIGHT', self.Health, 'RIGHT', -1, 0)
    p:SetPoint('TOP', self.Health, 'BOTTOM', 0, 0) 
	
	if unit == 'player' and powerType ~= 0 then p.frequentUpdates = true end	   
		
    local pbg = p:CreateTexture(nil, 'BACKGROUND')
    pbg:SetAllPoints(p)
	pbg:SetTexture(cfg.texture)

	F.createBorderFrame(p, p, true)
	
	p.colorClass = true
	p.colorReaction = true
	pbg.multiplier = .4			
		
	p.bg = pbg
	self.Power = p 
end

local function Icons(self) 
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

local function Shared(self, unit)
	
    self:SetScript('OnEnter', OnEnter)
	self:SetScript('OnLeave', OnLeave)
	
	self:RegisterForClicks('AnyUp')

	self.framebd = F.createBorderFrame(self, self, false)	
	
	Health(self) 
		
	local ricon = self.Health:CreateTexture(nil, 'OVERLAY')
	ricon:SetTexture(cfg.raidicons)
	ricon:SetSize(20, 20)
	ricon:SetPoint('TOP', 0, 10)
	self.RaidTargetIndicator = ricon
	
	local hl = self.Health:CreateTexture(nil, 'OVERLAY')
    hl:SetAllPoints(self)
    hl:SetTexture([=[Interface\Buttons\WHITE8x8]=])
    hl:SetVertexColor(1,1,1,.05)
    hl:SetBlendMode('ADD')
    hl:Hide()
	self.Highlight = hl

	self.SpellRange = {
		insideAlpha = 1,
		outsideAlpha = cfg.options.range_alpha
	}
end

local UnitSpecific = {
    player = function(self, unit)
        Shared(self, unit)		
		Power(self)
		Icons(self)
				
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
						
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
	    self:Tag(name, '[color][long:name]')

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
        self.CombatIndicator = ct

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
	    self.RestingIndicator = r
		
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
					Icon = createStatusbar(ClassIcons, cfg.texture, nil, cfg.player.specific_power, (cfg.player.width+1)/ClassIcons.c-1, G.color.r)
					
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

    target = function(self, unit)
        Shared(self, unit)		
		Power(self)
		Icons(self)
						
		if cfg.target_cb.enable then castbar(self) end
		
		self:SetSize(cfg.player.width, cfg.player.health+cfg.player.power+1)
		self.Power:SetHeight(cfg.player.power)
		self.Power.PostUpdate = PostUpdatePower
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, '[lvl] [color][long:name]')

		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
		htext.frequentUpdates = .1
        self:Tag(htext, '[player:hp]')
		
		local q = fs(self.Health, 'OVERLAY', cfg.font, 16, cfg.fontflag, 1, 1, 1)
	    q:SetPoint('CENTER')
	    q:SetText('|cff8AFF30!|r')
	    self.QuestIndicator = q
	
		if cfg.aura.target_buffs then
            local b = CreateFrame('Frame', nil, self)
			b.size = 24
			b.spacing = 4
		    b.num = cfg.aura.target_buffs_num
            b:SetSize(b.size*b.num/2+b.spacing*(b.num/2-1), b.size)
		    b:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, -1)
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

    focus = function(self, unit)
        Shared(self, unit)
		Power(self)
		Icons(self)
				
		if cfg.focus_cb.enable then castbar(self) end
		
		self:SetSize(cfg.party.width, cfg.party.health+cfg.player.power+5)
		self.Power:SetHeight(cfg.player.power)
		self.Power.PostUpdate = PostUpdatePower
				
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

	boss = function(self, unit)
		Shared(self, unit)
		Power(self)		
				
		self.Health.frequentUpdates = true
				
		if cfg.boss_cb.enable then castbar(self) end

		self.SpellRange.outsideAlpha = 1
		
		self:SetSize(cfg.party.width, cfg.party.health+13)
		self.Power:SetHeight(cfg.player.power)
		self.Power.PostUpdate = PostUpdatePower
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, '[color][long:name]')
		
		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
        self:Tag(htext, '[boss:hp]')
		
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

    pet = function(self, unit)
        Shared(self, unit)
		
		self:SetSize(cfg.target.width, cfg.target.height)
						
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
		
    end,
	
	partytarget = function(self, unit)
        Shared(self, unit)
						
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('CENTER', self.Health)
		self:Tag(name, '[color][short:name]')
		
    end,

    targettarget = function(self, unit)
	    Shared(self, unit)
				 
	    self:SetSize(cfg.target.width, cfg.target.height)
		
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('CENTER')
		self:Tag(name, '[color][short:name]')
		 
        if cfg.aura.targettarget_debuffs then 
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
			d.num = cfg.aura.targettarget_debuffs_num
            d:SetSize(d.num*d.size+d.spacing*(d.num-1), d.size)
            d:SetPoint('TOPLEFT', self, 'TOPRIGHT', 5, -1)
            d.initialAnchor = 'TOPLEFT'
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d
        end
    end,
	
	party = function(self, unit)
		Shared(self, unit)
		Power(self)
		Icons(self)
		
		if cfg.party_cb.enable then castbar(self) end
		
		self.Health:SetHeight(cfg.party.health)
		self.Power:SetHeight(cfg.party.power)
				
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
		self.ReadyCheckIndicator = rc
		
		if cfg.aura.party_buffs then			
            local d = CreateFrame('Frame', nil, self)
			d.size = 24
			d.spacing = 4
			d.num = cfg.aura.party_buffs_num
            d:SetSize(d.num*d.size+d.spacing*(d.num-1), d.size)
            d:SetPoint('TOPRIGHT', self, 'TOPLEFT', -5, -1)
            d.initialAnchor = 'TOPRIGHT'
			d['growth-x'] = 'LEFT'
            d.PostCreateIcon = auraIcon
            d.PostUpdateIcon = PostUpdateIcon
            self.Debuffs = d
	    end
    end,
	
	arena = function(self, unit)
		Shared(self, unit)

		Power(self)
		Icons(self)
					
		if cfg.arena_cb.enable then castbar(self) end
		
		self:SetSize(cfg.party.width, cfg.party.health+cfg.party.power+1)
		self.Health:SetHeight(cfg.party.health)
		self.Power:SetHeight(cfg.party.power)
				
		local name = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        name:SetPoint('LEFT', 4, 0)
        name:SetJustifyH'LEFT'
		self:Tag(name, '[color][long:name]')
		
		local htext = fs(self.Health, 'OVERLAY', cfg.font, cfg.fontsize, cfg.fontflag, 1, 1, 1)
        htext:SetPoint('RIGHT', -2, 0)
        self:Tag(htext, '[party:hp]')
		
		
		local t = CreateFrame('Frame', nil, self)
		t:SetSize(cfg.party.health+cfg.party.power+1, cfg.party.health+cfg.party.power+1)
		t:SetPoint('TOPRIGHT', self, 'TOPLEFT', -3, 0)
		t.framebd = framebd(t, t)	
		self.Trinket = t
    end,

    raid = function(self, unit)
		Shared(self, unit)
		
		Power(self)
		Icons(self)
					
		self.Health:SetHeight(cfg.raid.health)
		self.Power:SetHeight(cfg.raid.power)
				
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

-- Nameplates
oUF:RegisterStyle("gempUI", function(self, unit)
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
	
	local border = CreateFrame("Frame",nil, health)
	border:SetFrameStrata("BACKGROUND")
	border:SetWidth(G.nameplates.width+2) 
	border:SetHeight(G.nameplates.height+2) 
	border:SetBackdrop({
		bgFile = [[Interface\Buttons\WHITE8x8]],
		edgeFile = [[Interface\Buttons\WHITE8x8]],
		edgeSize = 1,
	})
	border:SetBackdropColor(G.color.r, G.color.g, G.color.b, G.color.a)
	border:SetBackdropBorderColor(G.bordercolor.r, G.bordercolor.g, G.bordercolor.b, G.bordercolor.a)
	border:SetPoint("BOTTOM",0,-1)
	border:Show()
	

	self.Health = health
	

	self.Namecontainer = CreateFrame("frame",nil,self)
	self.Name = self.Namecontainer:CreateFontString(nil)
	self.Name:SetShadowOffset(1,-1)
	self.Name:SetTextColor(1,1,1)
	self.Name:ClearAllPoints()
	self.Name:SetFont(G.fonts.square, G.nameplates.fontsize)
	self.Name:SetShadowColor(0,0,0)
	self.Name:SetPoint("BOTTOM", self, "TOP", 0, 6)	
	self:Tag(self.Name, '[name]')


	local cb = createStatusbar(self, G.texture, nil, nil, nil, G.color.r, G.color.g, G.color.b, G.color.a)	
	
	cb.Text = fs(cb, 'OVERLAY', G.fonts.square, G.nameplates.fontsize - 1, G.nameplates.fontflag, 1, 1, 1, 'LEFT')
    cb.Text:SetPoint('LEFT', cb, 2, 0)
	cb.CastingColor = {G.color.r, G.color.g, G.color.b, G.color.a}
	cb.CompleteColor = {0.12, 0.86, 0.15, G.color.a}
	cb.FailColor = {1.0, 0.09, 0, G.color.a}
	cb.ChannelingColor = {0.32, 0.3, G.color.a}
	cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
	cb.Icon:SetPoint('TOPRIGHT', cb, 'TOPLEFT', -1, 0)
	cb.Icon:SetTexCoord(.1, .9, .1, .9)

	cb:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", G.nameplates.height + 1, -1)
	cb:SetSize(G.nameplates.width - G.nameplates.height - 1, G.nameplates.height)
	cb.Icon:SetSize(cb:GetHeight(), cb:GetHeight())
	
	cb.Spark = cb:CreateTexture(nil,'OVERLAY')
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

	
	cb.Backdrop = F.createBorderFrame(cb, cb, true)
	cb.IBackdrop = F.createBorderFrame(cb, cb.Icon, true)
	self.Castbar = cb

	self:SetScale(UIParent:GetEffectiveScale()*1)
	self:SetSize(G.nameplates.width, G.nameplates.height)
	self:SetPoint("CENTER", 0, -25)
end)

oUF:SpawnNamePlates()

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
            spawnHelper(self, 'boss' .. i, 'LEFT', cfg.unit_positions.Boss.a, 'RIGHT', cfg.unit_positions.Boss.x, cfg.unit_positions.Boss.y - (70 * i))
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
								    f.Health:SetStatusBarColor(cfg.Color.Health.r, cfg.Color.Health.g, cfg.Color.Health.b, cfg.Color.Health.a)
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
		
		self:SetActiveStyle'Skaarj - Raid'
		local party = self:SpawnHeader(nil, nil, 'party','showPlayer',
			cfg.options.showPlayer,'showSolo',false,'showParty',true ,'point','LEFT','xOffset', 5,'yOffset', -5,
			'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
			]]):format(cfg.raid.health+cfg.raid.power+1, cfg.raid.width)
		)
		party:SetPoint('TOPLEFT',cfg.unit_positions.Party.a,'TOPLEFT',cfg.unit_positions.Party.x,cfg.unit_positions.Party.y)
    end
	
	if cfg.uf.tank then
	    self:SetActiveStyle'Skaarj - Party'
	    local maintank = self:SpawnHeader(nil, nil, 'raid',
		'showRaid', true,'showSolo',false, 'groupFilter', 'MAINTANK', 'yOffset', -23,
		'oUF-initialConfigFunction', ([[
			self:SetHeight(%d)
			self:SetWidth(%d)
		]]):format(cfg.party.health+cfg.party.power+1,cfg.party.width)
		)
	    maintank:SetPoint('RIGHT', cfg.unit_positions.Tank.a, 'LEFT', cfg.unit_positions.Tank.x, cfg.unit_positions.Tank.y)
		
		if cfg.uf.tank_target then
		    self:SetActiveStyle'Skaarj - Partytarget'
		    local maintanktarget = self:SpawnHeader(nil, nil, 'raid',
		    'showRaid', true,'showSolo',false,'groupFilter','MAINTANK','yOffset', -23, 
		    'oUF-initialConfigFunction', ([[
			self:SetAttribute('unitsuffix', 'target')
			self:SetHeight(%d)
			self:SetWidth(%d)
			]]):format(cfg.target.height,cfg.target.width)
			)
		    maintanktarget:SetPoint('TOPLEFT', 'oUF_SkaarjPartyMainTank', 'TOPRIGHT', 6,0)	
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