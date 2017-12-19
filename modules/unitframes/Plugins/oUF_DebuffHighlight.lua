local _, ns = ...
local cfg = ns.cfg
local oUF = ns.oUF or oUF

local playerClass = select(2, UnitClass("player"))

local CanDispel = {
	DRUID = {Magic = false, Curse = true, Poison = true},
	MAGE = {Curse = true},
	MONK = {Magic = false, Poison = true, Disease = true},
	PALADIN = {Magic = false, Poison = true, Disease = true},
	PRIEST = {Magic = true, Disease = true},
	SHAMAN = {Magic = false, Curse = true}
}

local dispellist = CanDispel[playerClass] or {}

local function CheckSpec(self, event)
	local spec = GetSpecialization()
	if playerClass == "DRUID" then
		if (spec == 4) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "MONK" then
		if (spec == 2) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "PALADIN" then
		if (spec == 1) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "SHAMAN" then
		if (spec == 3) then
			dispellist.Magic = true
		else
			dispellist.Magic = false
		end
	elseif playerClass == "PRIEST" then
		if (spec == 3) then
			dispellist.Disease = false
			dispellist.Magic = false
		else
			dispellist.Disease = true
			dispellist.Magic = true
		end
	end
end

local function GetDebuffType(unit, filter)
	if not UnitCanAssist("player", unit) then return nil end
	local i = 1
	while true do
		local _, _, texture, _, debufftype = UnitAura(unit, i, "HARMFUL")
		if not texture then break end
		if debufftype and dispellist[debufftype] then
			return debufftype, texture
		end
		i = i + 1
	end
end

local function Update(object, event, unit)
	if object.unit ~= unit  then return end
	local debuffType, texture  = GetDebuffType(unit, object.DebuffHighlightFilter)
	local color = DebuffTypeColor[debuffType] 
	local s = UnitThreatSituation(object.unit)
	if s and s > 1 then
		r, g, b = GetThreatStatusColor(s)
		object.framebd:SetBackdropBorderColor(r, g, b)
	elseif debuffType and CanDispel[playerClass]then	
		object.framebd:SetBackdropBorderColor(color.r, color.g, color.b, object.DebuffHighlightAlpha or 1)	
	else
		object.framebd:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Enable(object)
	-- if we're not highlighting this unit return
	if not object.DebuffHighlightBackdrop and not object.DebuffHighlightBackdropBorder and not object.DebuffHighlight then
		return
	end
	
	object:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', Update)
	object:RegisterEvent("UNIT_AURA", Update)
	object:RegisterEvent("PLAYER_ENTERING_WORLD", CheckSpec)
	object:RegisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	
	return true
end

local function Disable(object)
	if object.DebuffHighlightBackdrop or object.DebuffHighlightBackdropBorder or object.DebuffHighlight then
		object:UnregisterEvent("UNIT_AURA", Update)
		object:UnregisterEvent('UNIT_THREAT_SITUATION_UPDATE', Update)
		object:UnregisterEvent("PLAYER_TALENT_UPDATE", CheckSpec)
	end
end

oUF:AddElement('DebuffHighlight', Update, Enable, Disable)

for i, frame in ipairs(oUF.objects) do Enable(frame) end