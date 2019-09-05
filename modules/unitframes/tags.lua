local F, G, V = unpack(select(2, ...))
local name, ns = ...
local oUF = ns.oUF 
local cfg = ns.cfg

local sValue = function(val)
	if (val >= 1e6) then
		return ('%.fm'):format(val / 1e6)
	elseif (val >= 1e3) then
		return ('%.fk'):format(val / 1e3)
	else
		return ('%d'):format(val)
	end
end

local function hex(r, g, b)
	if not r then return '|cffFFFFFF' end
	if (type(r) == 'table') then
		if (r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
end

oUF.colors.power['MANA'] = { 0.37, 0.6, 1 }
oUF.colors.power['RAGE'] = { 0.9, 0.3, 0.23 }
oUF.colors.power['FOCUS'] = { 1, 0.81, 0.27 }
oUF.colors.power['RUNIC_POWER'] = { 0, 0.81, 1 }
oUF.colors.power['AMMOSLOT'] = { 0.78, 1, 0.78 }
oUF.colors.power['FUEL'] = { 0.9, 0.3, 0.23 }
oUF.colors.power['POWER_TYPE_STEAM'] = { 0.55, 0.57, 0.61 }
oUF.colors.power['POWER_TYPE_PYRITE'] = { 0.60, 0.09, 0.17 }
oUF.colors.power['POWER_TYPE_HEAT'] = { 0.55, 0.57, 0.61 }
oUF.colors.power['POWER_TYPE_OOZE'] = { 0.76, 1, 0 }
oUF.colors.power['POWER_TYPE_BLOOD_POWER'] = { 0.7, 0, 1 }

oUF.Tags.Methods['color'] = function(u, r)
	local reaction = UnitReaction(u, 'player')
	if (UnitIsPlayer(u)) then
		local _, class = UnitClass(u)
		return hex(oUF.colors.class[class])
	elseif reaction and not (UnitIsPlayer(u)) then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.Tags.Events['color'] = 'UNIT_HEALTH'

local function utf8sub(string, i, dots)
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 194 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 244 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1) .. (dots and '...' or '')
		else
			return string
		end
	end
end

oUF.Tags.Methods['long:name'] = function(u, r)
	local name = UnitName(realUnit or u or r)
	return utf8sub(name, 14, false)
end
oUF.Tags.Events['long:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['short:name'] = function(u, r)
	local name = UnitName(realUnit or u or r)
	return utf8sub(name, 10, false)
end
oUF.Tags.Events['short:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['veryshort:name'] = function(u, r)
	local name = UnitName(realUnit or u or r)
	return utf8sub(name, 5, false)
end
oUF.Tags.Events['veryshort:name'] = 'UNIT_NAME_UPDATE'

oUF.Tags.Methods['lvl'] = function(u)
	local level = UnitLevel(u)
	local typ = UnitClassification(u)
	local color = GetQuestDifficultyColor(level)

	if level == MAX_PLAYER_LEVEL then
		return nil
	end

	if level <= 0 then
		level = '??'
	end

	if typ == 'rareelite' then
		return hex(color) .. level .. 'r+'
	elseif typ == 'elite' then
		return hex(color) .. level .. '+'
	elseif typ == 'rare' then
		return hex(color) .. level .. 'r'
	else
		return hex(color) .. level
	end
end

oUF.Tags.Methods['player:hp'] = function(u)
	local power = UnitPower(u)
	local min, max = UnitHealth(u), UnitHealthMax(u)
	local _, str, r, g, b = UnitPowerType(u)
	local t = oUF.colors.power[str]
	if t then
		r, g, b = t[1], t[2], t[3]
	end
	if UnitIsDead(u) then
		return '|cff559655 Dead|r'
	elseif UnitIsGhost(u) then
		return '|cff559655 Ghost|r'
	elseif not UnitIsConnected(u) then
		return '|cff559655 D/C|r'
	elseif (min < max) then
		if (power > 0) then
			return ('|cffAF5050' .. sValue(min)) .. ' | ' .. math.floor(min / max * 100 + .5) .. '%' .. ('|cffAF5050 || ') .. hex(r, g, b) .. sValue(power)
		else
			return ('|cffAF5050' .. sValue(min)) .. ' | ' .. math.floor(min / max * 100 + .5) .. '%'
		end
	else
		if (power > 0) then
			return ('|cff559655' .. sValue(min)) .. ('|cff559655 || ') .. hex(r, g, b) .. sValue(power)
		else
			return ('|cff559655' .. sValue(min))
		end
	end
end
oUF.Tags.Events['player:hp'] = 'UNIT_HEALTH UNIT_POWER_UPDATE UNIT_CONNECTION'

oUF.Tags.Methods['raid:hp'] = function(u)
	local d = oUF.Tags.Methods['missinghp'](u) or 0
	local incheal = UnitGetIncomingHeals(u) or 0
	local min, max = UnitHealth(u), UnitHealthMax(u)
	local per = math.floor(min / max * 100 + .5)
	if UnitIsDead(u) then
		return '|cff559655 Dead|r'
	elseif UnitIsGhost(u) then
		return '|cff559655 Ghost|r'
	elseif not UnitIsConnected(u) then
		return '|cff559655 D/C|r'
	elseif (per < 90) and true then
		return '|cffAF5050-' .. sValue(d) .. '|r'
	else
		return nil
	end
end
oUF.Tags.Events['raid:hp'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags.Methods['party:hp'] = function(u)
	local min, max = UnitHealth(u), UnitHealthMax(u)
	if UnitIsDead(u) then
		return '|cff559655 Dead|r'
	elseif UnitIsGhost(u) then
		return '|cff559655 Ghost|r'
	elseif not UnitIsConnected(u) then
		return '|cff559655 D/C|r'
	else
		return ('|cff559655' .. math.floor(min / max * 100 + .5) .. '%')
	end
end
oUF.Tags.Events['party:hp'] = 'UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags.Methods['boss:hp'] = function(u)
	local min, max = UnitHealth(u), UnitHealthMax(u)
	if UnitIsDead(u) then
		return '|cff559655 Dead|r'
	else
		return ('|cff559655' .. math.floor(min / max * 100 + .5) .. '%')
	end
end
oUF.Tags.Events['boss:hp'] = 'UNIT_HEALTH_FREQUENT UNIT_MAXHEALTH UNIT_TARGETABLE_CHANGED'

oUF.Tags.Methods['altpower'] = function(u)
	local cur = UnitPower(u, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(u, ALTERNATE_POWER_INDEX)
	local per = math.floor(cur / max * 100 + .5)
	return ('|cffCDC5C2' .. sValue(cur)) .. ('|cffCDC5C2 || ') .. sValue(max)
end
oUF.Tags.Events['altpower'] = 'UNIT_POWER_UPDATE UNIT_MAXPOWER'

oUF.Tags.Methods['player:power'] = function(u)
	local fury = UnitPower('player', SPELL_POWER_DEMONIC_FURY)
	local mana = UnitPower('player', SPELL_POWER_MANA)
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return nil
	elseif class == 'WARLOCK' then
		local r, g, b = 0.9, 0.37, 0.37
		return ('|cff559655 || ') .. hex(r, g, b) .. sValue(fury)
	elseif class == 'DRUID' and not UnitPowerType('player') == SPELL_POWER_MANA then
		local r, g, b = oUF.colors.power['MANA']
		return ('|cff559655 || ') .. hex(r, g, b) .. sValue(mana)
	elseif class == 'MONK' then
		local r, g, b = 0.52, 1.0, 0.52
		return ('|cff559655 || ') .. hex(r, g, b) .. sValue(stagger)
	else
		return nil
	end
end
oUF.Tags.Events['player:power'] = 'UNIT_POWER_UPDATE PLAYER_TALENT_UPDATE UNIT_HEALTH UNIT_CONNECTION'

oUF.Tags.Methods['LFD'] = function(u)
	local role = UnitGroupRolesAssigned(u)
	if role == 'HEALER' then
		return '|cff8AFF30H|r'
	elseif role == 'TANK' then
		return '|cff5F9BFFT|r'
	elseif role == 'DAMAGER' then
		return '|cffFF6161D|r'
	end
end
oUF.Tags.Events['LFD'] = 'PLAYER_ROLES_ASSIGNED'