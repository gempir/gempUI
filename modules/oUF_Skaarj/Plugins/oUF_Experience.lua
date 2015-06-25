local _, ns = ...
local cfg = ns.cfg
local oUF = ns.oUF or oUF
assert(oUF, 'oUF Experience was unable to locate oUF install')

if not cfg.exp_rep.enable or UnitLevel('player') == MAX_PLAYER_LEVEL then return end

for tag, func in pairs({
	['curxp'] = function(unit)
		return UnitXP(unit)
	end,
	['maxxp'] = function(unit)
		return UnitXPMax(unit)
	end,
	['perxp'] = function(unit)
		return math.floor(UnitXP(unit) / UnitXPMax(unit) * 100 + 0.5)
	end,
	['currested'] = function()
		return GetXPExhaustion()
	end,
	['perrested'] = function(unit)
		local rested = GetXPExhaustion()
		if(rested and rested > 0) then
			return math.floor(rested / UnitXPMax(unit) * 100 + 0.5)
		end
	end,
}) do
	oUF.Tags.Methods[tag] = func
	oUF.Tags.Events[tag] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UPDATE_EXHAUSTION'
end

local function Update(self, event, unit)
	local experience, unit = self.Experience, self.unit
	local num = GetNumGroupMembers()
	hasPetSpells, petToken = HasPetSpells()
	local inInstance, instanceType = IsInInstance()
	if(self.unit ~= unit) then return end
	
	if(experience.PreUpdate) then experience:PreUpdate(unit) end

	if(UnitLevel(unit) == MAX_PLAYER_LEVEL or UnitHasVehicleUI('player')) or (((UnitAffectingCombat"player") and ((num > 0 or hasPetSpells) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")))) and not cfg.exp_rep.unlock and cfg.treat.enable) then
		return experience:Hide()
	else
		experience:Show()
	end

	local min, max = UnitXP(unit), UnitXPMax(unit)
	experience:SetMinMaxValues(0, max)
	experience:SetValue(min)
	local exhaustion = GetXPExhaustion() or 0

	if(experience.Rested) then
		experience.Rested:SetMinMaxValues(0, max)
		experience.Rested:SetValue(math.min(min + exhaustion, max))
	end
	
	if(experience.text) then
	    if(exhaustion~=0) then
		    experience.text:SetText(format('XP: %d / %d (%d%%) |cff0090ff+ %d (%d%%)', min, max, min / max * 100, exhaustion, exhaustion / max * 100))
	    else
	        experience.text:SetText(format('XP: %d / %d (%d%%)', min, max, min / max * 100))
	    end
	end

	if(experience.PostUpdate) then
		return experience:PostUpdate(unit, min, max)
	end
end

local function Path(self, ...)
	return (self.Experience.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local experience = self.Experience
	if(experience) then
		experience.__owner = self
		experience.ForceUpdate = ForceUpdate
		
        self:RegisterEvent('PLAYER_REGEN_DISABLED', Path)
		self:RegisterEvent('PLAYER_REGEN_ENABLED', Path)
		self:RegisterEvent('PLAYER_XP_UPDATE', Path)
		self:RegisterEvent('PLAYER_LEVEL_UP', Path)
		self:RegisterEvent("UNIT_PET", Path)

		local rested = experience.Rested
		if(rested) then
			self:RegisterEvent('UPDATE_EXHAUSTION', Path)
			rested:SetFrameLevel(experience:GetFrameLevel() - 1)

			if(not rested:GetStatusBarTexture()) then
				rested:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end
		end

		if(not experience:GetStatusBarTexture()) then
			experience:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		return true
	end
end

local function Disable(self)
	if(self.Experience) then
	    self:UnregisterEvent('PLAYER_REGEN_DISABLED', Path)
		self:UnregisterEvent('PLAYER_REGEN_ENABLED', Path)
		self:UnregisterEvent('PLAYER_XP_UPDATE', Path)
		self:UnregisterEvent('PLAYER_LEVEL_UP', Path)
		self:UnregisterEvent("UNIT_PET", Path)

		if(experience.Rested) then
			self:UnregisterEvent('UPDATE_EXHAUSTION', Path)
		end
	end
end

oUF:AddElement('Experience', Path, Enable, Disable)