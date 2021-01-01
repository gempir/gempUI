local F, G = unpack(select(2, ...))

local function noop() end

VehicleSeatIndicator:ClearAllPoints()
VehicleSeatIndicator:SetPoint("TOPRIGHT", G.frame, "TOPRIGHT", -290, -300)
VehicleSeatIndicator.ClearAllPoints = noop
VehicleSeatIndicator.SetPoint = noop
VehicleSeatIndicator:SetHeight(476)