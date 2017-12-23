local F, G, V = unpack(select(2, ...))

-- TinyMainbarInfo
-- by Bastian Pflieger <wb@illogical.de>


local FORMAT_NETSTATS = "%.2f KB/S"
local FORMAT_MEMORY_USAGE = "%.3f MB"
local FORMAT_FPS
local FORMAT_LAG = ""

local onlineTime = 0;
local timer = 0;
local doScan, loaded;


local function TinyMainbarInfo_OnLoad(self)

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_MONEY")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	self:RegisterEvent("UPDATE_INVENTORY_ALERTS")
	self:RegisterEvent("PLAYER_AVG_ITEM_LEVEL_READY")
	self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("PLAYER_FLAGS_CHANGED")
end


local function TinyMainbarInfo_OnUpdate(self, elapsed)
	onlineTime = onlineTime + elapsed;
	timer = timer + elapsed;
end

local function TinyMainbarInfo_OnUpdate2(self, elapsed)
	if doScan and GetTime() > (doScan + 0.5) then

		doScan = nil
	end
	if timer > 1 then

		-- Update network flow
		local kbin, kbout, mlatency, wlatency = GetNetStats();


		if mlatency >= 250 then
			FORMAT_LAG = RED_FONT_COLOR_CODE .. "%dms" .. FONT_COLOR_CODE_CLOSE;
		elseif mlatency >= 100 then
			FORMAT_LAG = LIGHTYELLOW_FONT_COLOR_CODE .. "%dms" .. FONT_COLOR_CODE_CLOSE;
		else
			FORMAT_LAG = "%dms";
		end

		self.latText:SetText(string.format(FORMAT_LAG, mlatency, wlatency));



		-- Update fps
		local fps = GetFramerate()
		if fps < 15 then
			FORMAT_FPS = RED_FONT_COLOR_CODE .. "%.0ffps" .. FONT_COLOR_CODE_CLOSE
		elseif fps < 30 then
			FORMAT_FPS = YELLOW_FONT_COLOR_CODE .. "%.0ffps" .. FONT_COLOR_CODE_CLOSE
		else
			FORMAT_FPS = "%.0ffps"
		end
		self.fpsText:SetText(string.format(FORMAT_FPS, fps));

		timer = 0;
	end
end

do
	local timeframe = CreateFrame("Frame")
	timeframe:SetScript("OnUpdate", TinyMainbarInfo_OnUpdate)

	local f = CreateFrame("Frame", "TinyMainbarInfoFrame", MainMenuBarArtFrame)
	f:SetFrameLevel(f:GetParent():GetFrameLevel() + 1)
	f:SetScript("OnEvent", TinyMainbarInfo_OnEvent)
	f:SetScript("OnUpdate", TinyMainbarInfo_OnUpdate2)



	local latText = f:CreateFontString(nil, "OVERLAY")
	latText:SetPoint("CENTER", UIPARENT, "TOPRIGHT", -154, -196)
	f.latText = latText
	f.latText:SetFont("Interface\\Addons\\gempUI\\media\\fonts\\square.ttf", 14, 'THINOUTLINE')
	f.latText:SetTextColor(1, 1, 1)


	local fpsText = f:CreateFontString(nil, "OVERLAY")
	fpsText:SetPoint("CENTER", UIPARENT, "TOPRIGHT", -36, -196)
	f.fpsText = fpsText
	f.fpsText:SetFont("Interface\\Addons\\gempUI\\media\\fonts\\square.ttf", 14, 'THINOUTLINE')
	f.fpsText:SetTextColor(1, 1, 1)

	local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
	clockFrame:Hide()
	clockTime:SetFont("Interface\\Addons\\gempUI\\media\\fonts\\square.ttf", 14, "THINOUTLINE")
	clockTime:SetTextColor(1, 1, 1)
	TimeManagerClockButton:SetFrameStrata("TOOLTIP")
	TimeManagerClockButton:SetPoint("CENTER", UIParent, "TOPRIGHT", -95, -197)
	TimeManagerClockButton:EnableMouse(false)
	clockTime:SetShadowOffset(0, 0)
	clockTime:Show()


	TinyMainbarInfo_OnLoad(f)
end

