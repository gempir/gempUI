local F, G, V = unpack(select(2, ...))


local function noop() end

ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -52, -377)
ObjectiveTrackerFrame.ClearAllPoints = noop
ObjectiveTrackerFrame.SetPoint = noop
ObjectiveTrackerFrame:SetHeight(476)

