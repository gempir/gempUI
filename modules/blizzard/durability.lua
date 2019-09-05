local F, G, V = unpack(select(2, ...))


local function noop() end

DurabilityFrame:ClearAllPoints()
DurabilityFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -210, -190)
DurabilityFrame.ClearAllPoints = noop
DurabilityFrame.SetPoint = noop

QuestWatchFrame:ClearAllPoints()
QuestWatchFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -5, -180)
QuestWatchFrame.ClearAllPoints = noop
QuestWatchFrame.SetPoint = noop