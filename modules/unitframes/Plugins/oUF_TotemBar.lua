local _, ns = ...
local cfg = ns.cfg
local oUF = ns.oUF or oUF
local _, class = UnitClass('player')

if not ((class == "SHAMAN" and cfg.options.TotemBar) or (class == "DRUID" and cfg.options.MushroomBar)) then return end

local total = 0
local delay = 0.01

local colors = {
	[1] = {.88,.43,.20},
	[2] = {.43,.65,.23},	
	[3] = {.39,.58,.80},
	[4] = {.82,.68,.94},
	}	

local GetTotemInfo, SetValue, GetTime = GetTotemInfo, SetValue, GetTime, SecondsToTimeAbbrev
	
local function UpdateSlot(self, slot)
	local totem = self.TotemBar
	local ptt = GetSpecialization()
	if not totem[slot] then return end

	local haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(slot)

	totem[slot]:SetStatusBarColor(unpack(colors[slot]))
	totem[slot]:SetMinMaxValues(0, 1)
	
	if (totem[slot].bg.multiplier) then
		local mu = totem[slot].bg.multiplier
		local r, g, b = totem[slot]:GetStatusBarColor()
		r, g, b = r*mu, g*mu, b*mu
		totem[slot].bg:SetVertexColor(r, g, b) 
	end
	
	totem[slot].ID = slot
	
	if(haveTotem) then
		if(duration > 0) then	
			totem[slot]:SetValue(1 - ((GetTime() - startTime) / duration))	
			totem[slot]:SetScript("OnUpdate",function(self,elapsed)
				total = total + elapsed
				if total >= delay then
					total = 0
					haveTotem, name, startTime, duration, totemIcon = GetTotemInfo(self.ID)
					local timeleft = GetTotemTimeLeft(self.ID)
					if ((GetTime() - startTime) == 0) or (duration == 0) then
						self:SetValue(0)
					else
						self:SetValue(1 - ((GetTime() - startTime) / duration))
					end	
				end
			end)					
		else
			totem[slot]:SetScript("OnUpdate",nil)
			totem[slot]:SetValue(0)
		end 
	else
		totem[slot]:SetValue(0)
	end
	
	if class == "DRUID" then
	    if (ptt and (ptt == 1 or ptt == 4)) then 
		    totem[slot]:Show()
	    else
		    totem[slot]:Hide()
	    end
	end
end

local function Update(self, unit)
	for i = 1, 4 do 
		UpdateSlot(self, i)
	end
end

local function Event(self,event,...)
	if event == "PLAYER_TOTEM_UPDATE" then
		UpdateSlot(self, ...)
	end
end

local function Enable(self, unit)
	local totem = self.TotemBar
	if(totem) then
		self:RegisterEvent("PLAYER_TOTEM_UPDATE" , Event, true)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', Update)
		totem.colors = setmetatable(totem.colors or {}, {__index = colors})
		delay = totem.delay or delay	
		TotemFrame:UnregisterAllEvents()		
		return true
	end	
end

local function Disable(self,unit)
	local totem = self.TotemBar
	if(totem) then
		self:UnregisterEvent("PLAYER_TOTEM_UPDATE", Event)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Update)
		TotemFrame:Show()
	end
end
			
oUF:AddElement("TotemBar",Update,Enable,Disable)