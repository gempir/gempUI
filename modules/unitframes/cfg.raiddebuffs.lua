local _, ns = ...
local ORD = ns.oUF_RaidDebuffs or oUF_RaidDebuffs
if not ORD then return end

local RaidDebuffs = {
-- Highmaul
-- The Butcher
156152, -- Gushing Wounds
156147, -- The Cleaver
-- Kargath Bladefist
159178, -- Open Wounds (Tank switch)
159113, -- Impale (DoT)
-- Twin Ogron
155569, -- Injured (DoT)
167200, -- Arcane Wound (DoT)
-- Ko'ragh
161242, -- Caustic Energy (DoT)
162184, -- Expel Magic: Shadow
-- Tectus
162892, -- Petrification
-- Brackenspore
163241, -- Rot (Stacks)
-- Imperator Mar'gok
158605, -- Mark of Chaos
164176, -- Mark of Chaos: Displacement
164178, -- Mark of Chaos: Fortification
164191, -- Mark of Chaos: Replication
157763, -- Fixate
158553, -- Crush Armor (Stacks)
}
ORD:RegisterDebuffs(RaidDebuffs)