local F, G = unpack(select(2, ...))


local function noop() end

DurabilityFrame:ClearAllPoints()
DurabilityFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -150, -302)
DurabilityFrame.ClearAllPoints = noop
DurabilityFrame.SetPoint = noop
