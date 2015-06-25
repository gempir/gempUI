local function noop() end
 
ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -50, -302)
ObjectiveTrackerFrame.ClearAllPoints = noop
ObjectiveTrackerFrame.SetPoint       = noop
ObjectiveTrackerFrame:SetHeight(476)