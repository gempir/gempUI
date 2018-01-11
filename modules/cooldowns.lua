local F, G, V = unpack(select(2, ...))

--[[	Cooldown Watch
	by SDPhantom
	http://www.phantomweb.org	]]
------------------------------------------

local CDText = {};
local function OnUpdate(self)
	local ptr = CDText[self];--	Table can contain false if no FontString found
	if ptr then--	Sanity Check
		local now, start, duration = GetTime(), self:GetCooldownTimes();
		start, duration = start/1000, duration/1000;--	Start and Duration are in milliseconds

--		Calculate needed values
		local elapsed=now-start;
        local remain=math.max(0,duration-elapsed);
        ptr:SetFont(G.cooldowns.font, self:GetHeight() / 2.2, G.cooldowns.fontflag)

--		Colorize text
        if elapsed<0 then	
            ptr:SetTextColor(1,0,0,0.625);--	Red if negative elapsed
        elseif remain>=3600 then
            ptr:SetTextColor(1,0.5,0,0.625);--	Orange hours
        elseif remain>=60 then
            ptr:SetTextColor(1,1,0,0.625);--	Yellow minutes
        else				
            ptr:SetTextColor(1,1,1,0.625);--	White seconds
		end
	end
end

--	Global Metamethod Hook (Hurray for shared metatables)
hooksecurefunc(getmetatable(CreateFrame("Cooldown")).__index,"SetCooldown",function(self,start,duration,enabled)
	if CDText[self] == nil then--	Table can contain false if no FontString found
		self:SetHideCountdownNumbers(false);--	SetHide to false means show
		
		local txt=self:GetRegions();
		if txt then--	Sanity Check
			txt:ClearAllPoints();
			txt:SetPoint("CENTER", 1, 1);
			self:HookScript("OnUpdate",OnUpdate);
		end
		CDText[self]=txt or false;--	Cast nil to false so we don't run on same frame again
	end
end);
