local _, ns = ...
local cfg = ns.cfg
local oUF = ns.oUF or oUF
assert(oUF, 'oUF Reputation was unable to locate oUF install')

if not cfg.exp_rep.enable then return end

for tag, func in pairs({
	['currep'] = function()
		local __, __, min, __, value = GetWatchedFactionInfo()
		return value - min
	end,
	['maxrep'] = function()
		local __, __, min, max = GetWatchedFactionInfo()
		return max - min
	end,
	['perrep'] = function()
		local __, __, min, max, value = GetWatchedFactionInfo()
		return math.floor((value - min) / (max - min) * 100 + 0.5)
	end,
	['standing'] = function()
		local __, standing = GetWatchedFactionInfo()
		return GetText('FACTION_STANDING_LABEL' .. standing, UnitSex('player'))
	end,
	['reputation'] = function()
		return GetWatchedFactionInfo()
	end,
}) do
	oUF.Tags.Methods[tag] = func
	oUF.Tags.Events[tag] = 'UPDATE_FACTION'
end

oUF.Tags.SharedEvents.UPDATE_FACTION = true

local function Update(self, event, unit)
	local reputation = self.Reputation
	local name, standingID, min, max, value = GetWatchedFactionInfo()
	local num = GetNumGroupMembers()
	hasPetSpells, petToken = HasPetSpells()
	local inInstance, instanceType = IsInInstance()
	local Width = reputation:GetWidth()
	
	if(not name) or UnitHasVehicleUI('player') or (((UnitAffectingCombat"player") and ((num > 0 or hasPetSpells) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")))) and not cfg.exp_rep.unlock and cfg.treat.enable) then
		return reputation:Hide()
	else
		reputation:Show()
	end

	reputation:SetMinMaxValues(0, max - min)
	reputation:SetValue(value - min)
	
	local standing = _G['FACTION_STANDING_LABEL' .. standingID]
	barMax, barMin = (max-min), (value-min)
	
	if(reputation.text) then
        if 	Width < 300 then
		    reputation.text:SetText(format('%d / %d (%d%%)', barMin, barMax, ((barMin/barMax)*100) ))
		else
	        reputation.text:SetText(format(' %s | %d / %d (%d%%)', standing, barMin, barMax, ((barMin/barMax)*100) ))
		end
	end
	
	if(reputation.colorStanding) then
		local color = FACTION_BAR_COLORS[standing]
		reputation:SetStatusBarColor(color.r, color.g, color.b)
	end

	if(reputation.PostUpdate) then
		return reputation:PostUpdate(unit, name, standing, min, max, value)
	end
end

local function Path(self, ...)
	return (self.Reputation.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local reputation = self.Reputation
	if(reputation) then
		reputation.__owner = self
		reputation.ForceUpdate = ForceUpdate

		self:RegisterEvent('UPDATE_FACTION', Path)
		self:RegisterEvent("PLAYER_REGEN_DISABLED", Path)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", Path)
		self:RegisterEvent("UNIT_PET", Path)

		if(not reputation:GetStatusBarTexture()) then
			reputation:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
		end

		return true
	end
end

local function Disable(self)
	if(self.Reputation) then
		self:UnregisterEvent('UPDATE_FACTION', Path)
		self:UnregisterEvent("PLAYER_REGEN_DISABLED", Path)
		self:UnregisterEvent("PLAYER_REGEN_ENABLED", Path)
		self:UnregisterEvent("UNIT_PET", Path)
	end
end

oUF:AddElement('Reputation', Path, Enable, Disable)