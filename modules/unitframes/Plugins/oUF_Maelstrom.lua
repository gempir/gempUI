local _,ns = ...
local cfg = ns.cfg
local oUF = ns.oUF or oUF

if(select(2, UnitClass('player')) ~= 'SHAMAN') and not cfg.options.Maelstrom then return end

local MAX_MAELSTROM_STACK = 5

local function GetMaelstromStack()
	aura = GetSpellInfo(53817)
	local name, rank, icon, count, debuffType, duration, expirationTime, caster = UnitAura('player', aura, nil, 'HELPFUL')
	return (count or 0)
end

local function Update(self, event, unit)
	if unit ~= 'player' then return end

	local element = self.Maelstrom

	if(element.PreUpdate) then
		element.PreUpdate()
	end

	local stack = GetMaelstromStack();

	for index = 1, MAX_MAELSTROM_STACK do
		if(index <= stack) then
			element[index]:SetAlpha(1)
		else
			element[index]:SetAlpha(.5)
		end
	end

	if(element.PostUpdate) then
		element.PostUpdate()
	end

end

function Path(self, ...)
	return (self.Maelstrom.Override or Update) (self, ...)
end

function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local Visibility = function(self, event, unit)
	local element = self.Maelstrom
	local lvl = UnitLevel('player')
	if(GetSpecialization() == 3) and (lvl >= 50) then
		element:Show()
	else
		element:Hide()
	end
end

local Enable = function(self, unit)
	local element = self.Maelstrom
	if(element and unit == 'player') then
		element.__owner = self
		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_AURA', Path)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', Visibility, true)
		
		element.Visibility = CreateFrame("Frame", nil, element)
		element.Visibility:RegisterEvent("PLAYER_ENTERING_WORLD")
		element.Visibility:RegisterEvent("PLAYER_LEVEL_UP")
		element.Visibility:SetScript("OnEvent", function(frame, event, unit) Visibility(self, event, unit) end)

       	for index = 1, MAX_MAELSTROM_STACK do
			local point = element[index]
			if(point:IsObjectType'Texture' and not point:GetTexture()) then
				point:SetTexture[[Interface\ComboFrame\ComboPoint]]
				point:SetTexCoord(0, 0.375, 0, 1)
			end
		end

		return true
	end
end

local Disable = function(self)
	local element = self.Maelstrom
	if(element) then
		self:UnregisterEvent('UNIT_AURA', Path)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', Visibility)
		self:UnregisterEvent('PLAYER_LEVEL_UP',Visibility)
	end
end

oUF:AddElement('Maelstrom', Path, Enable, Disable)