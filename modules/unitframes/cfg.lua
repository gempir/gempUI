local name, ns = ...
local cfg = CreateFrame('Frame')
local _, class = UnitClass('player')
local F, G, V = unpack(select(2, ...))
  -----------------------------
  -- Media
  -----------------------------
  
cfg.texture = G.media.."textures\\flat"
cfg.symbol =  G.media.."unitframes\\symbol.ttf"
cfg.raidicons =  G.media.."unitframes\\raidicons"
cfg.edge = "Interface\\Buttons\\WHITE8x8"

--Unit Frames Font

--Pixel
cfg.font, 
cfg.fontsize, 
cfg.shadowoffsetX, 
cfg.shadowoffsetY, 
cfg.fontflag = G.fonts.square, 11, 0, 0,  'THINOUTLINE' -- '' for none THINOUTLINE Outlinemonochrome


-----------------------------
-- Unit Frames 
-----------------------------

cfg.uf = {  
        raid = true,               -- Raid 
        boss = true,               -- Boss 
        arena = true,              -- Arena 
        party = true,              -- Party 
		tank = true,               -- Maintank 
		party_target = true,       -- Party target
		tank_target = true,        -- Maintank target
}

-----------------------------
-- Unit Frames Size
-----------------------------

--player, target
cfg.player = { 
        width = 210 ,
        health = 30,
        power = 8,
        specific_power = 5,
}

--party, tank, arena, boss, focus
cfg.party = { 
        width = 166 ,
        health = 26,
        power = 3,
}

-- raid
cfg.raid = { 
        width = 60 ,
        health = 30,
        power = 2,
}

--pet, targettarget, focustarget, arenatarget, partytarget, maintanktarget
cfg.target = { 
        width = 90 ,
        height = 30,
}

  -----------------------------
  -- Unit Frames Positions
  ----------------------------
  
 cfg.unit_positions = { 					
             Player = { a = UIParent,           x= G.pos.player.x, y=  G.pos.player.y},  
             Target = { a = UIParent,            x= G.pos.target.x, y=  G.pos.target.y},  
       Targettarget = { a = 'oUF_SkaarjTarget',  x= G.pos.targetoftarget.x, y=  G.pos.targetoftarget.y},  
              Focus = { a = 'oUF_SkaarjPlayer', x= G.pos.focus.x, y=  G.pos.focus.y},  
        Focustarget = { a = 'oUF_SkaarjFocus',  x= G.pos.focustarget.x, y=  G.pos.focustarget.y},  
                Pet = { a = 'oUF_SkaarjPlayer', x= G.pos.pet.x, y=  G.pos.pet.y},  
               Boss = { a = 'oUF_SkaarjTarget', x= G.pos.boss.x, y=  G.pos.boss.y},  
               Tank = { a = 'oUF_SkaarjPlayer', x= G.pos.tank.x, y=  G.pos.tank.y},  
               Raid = { a = UIParent,           x= G.pos.raid.x, y=  G.pos.raid.y},   
	          Party = { a = UIParent, 			x= G.pos.party.x, y=  G.pos.party.y},
              Arena = { a = 'oUF_SkaarjTarget', x= G.pos.arena.x, y=  G.pos.arena.y},			  
}

  -----------------------------
  -- Unit Frames Options
  -----------------------------

cfg.options = { 
		raid_missinghp = true,           -- show/hide missing health text
		raid_incheal = false,
        specific_power = true,
		stagger_bar = true,
		cpoints = true,
		hidepower = true,                
		DruidMana = true,
		TotemBar = false,
		Maelstrom = true,
		MushroomBar = true,
		smooth = true,
		showPlayer = false,              -- show player in party
		SpellRange = true,
		range_alpha = 0.6,
		disableRaidFrameManager = true,  -- disable default compact Raid Manager 
		ResurrectIcon = false,
}

cfg.EclipseBar = { 
        enable = true,
		Alpha = 0.1,
		pos = {'TOP', 'Player', 'BOTTOM', 0, -5},
        height = 9,
}

  -----------------------------
  -- Auras 
  -----------------------------

cfg.aura = {
        --player
        player_debuffs = true,
        player_debuffs_num = 18,
		--target
        target_debuffs = true,
        target_debuffs_num = 18,
        target_buffs = true,
        target_buffs_num = 8,		
		--focus
		focus_debuffs = true,
		focus_debuffs_num = 12,
		focus_buffs = false,
		focus_buffs_num = 8,
		--boss
		boss_buffs = true,
		boss_buffs_num = 4,
		boss_debuffs = true,
		boss_debuffs_num = 4,
		--target of target
		targettarget_debuffs = true,
		targettarget_debuffs_num = 4,
		--party
		party_buffs = true,
		party_buffs_num = 4,
		
		onlyShowPlayer = false,         -- only show player debuffs on target
        disableCooldown = true,         -- hide omniCC
        font = G.fonts.square,
		fontsize = 11,
		fontflag = 'THINOUTLINE',
}

  -----------------------------
  -- Plugins 
  -----------------------------

--RaidDebuffs
cfg.RaidDebuffs = {
        enable = true,
        pos = {'CENTER'},
        size = 20,
		ShowDispelableDebuff = true,
		FilterDispellableDebuff = true,
		MatchBySpellName = false,
}

--Threat/DebuffHighlight
cfg.dh = {
        player = true,
		target = true,
		focus = true,
		pet = true,
		partytaget = false,
		party = true,
		arena = true,
		raid = true,
		targettarget = false,
}

--AuraWatch
cfg.aw = {
        enable = true,
        onlyShowPresent = true,
		anyUnit = true,
}

--AuraWatch Spells
cfg.spellIDs = {
	    DRUID = {
	            {33763, {0.2, 0.8, 0.2}},			    -- Lifebloom
	            {8936, {0.8, 0.4, 0}, 'TOPLEFT'},		-- Regrowth
	            {102342, {0.38, 0.22, 0.1}},		    -- Ironbark
	            {48438, {0.4, 0.8, 0.2}, 'BOTTOMLEFT'},	-- Wild Growth
	            {774, {0.8, 0.4, 0.8},'TOPRIGHT'},		-- Rejuvenation
	            },
	     MONK = {
	            {119611, {0.2, 0.7, 0.7}},			    -- Renewing Mist
	            {132120, {0.4, 0.8, 0.2}},			    -- Enveloping Mist
	            {124081, {0.7, 0.4, 0}},			    -- Zen Sphere
	            {116849, {0.81, 0.85, 0.1}},		    -- Life Cocoon
	            },
	  PALADIN = {
	            {20925, {0.9, 0.9, 0.1}},	            -- Sacred Shield
	            {6940, {0.89, 0.1, 0.1}, 'BOTTOMLEFT'}, -- Hand of Sacrifice
	            {114039, {0.4, 0.6, 0.8}, 'BOTTOMLEFT'},-- Hand of Purity
	            {1022, {0.2, 0.2, 1}, 'BOTTOMLEFT'},	-- Hand of Protection
	            {1038, {0.93, 0.75, 0}, 'BOTTOMLEFT'},  -- Hand of Salvation
	            {1044, {0.89, 0.45, 0}, 'BOTTOMLEFT'},  -- Hand of Freedom
	            {114163, {0.9, 0.6, 0.4}, 'RIGHT'},	    -- Eternal Flame
	            {53563, {0.7, 0.3, 0.7}, 'TOPRIGHT'},   -- Beacon of Light
	            },
	   PRIEST = {
	            {41635, {0.2, 0.7, 0.2}},			    -- Prayer of Mending
	            {33206, {0.89, 0.1, 0.1}},			    -- Pain Suppress
	            {47788, {0.86, 0.52, 0}},			    -- Guardian Spirit
	            {6788, {1, 0, 0}, 'BOTTOMLEFT'},	    -- Weakened Soul
	            {17, {0.81, 0.85, 0.1}, 'TOPLEFT'},	    -- Power Word: Shield
	            {139, {0.4, 0.7, 0.2}, 'TOPRIGHT'},     -- Renew
	            },
	   SHAMAN = {
	            {974, {0.2, 0.7, 0.2}},				    -- Earth Shield
	            {61295, {0.7, 0.3, 0.7}, 'TOPRIGHT'},   -- Riptide
	            },
	   HUNTER = {
	            {35079, {0.2, 0.2, 1}},				    -- Misdirection
	            },
	     MAGE = {
	            {111264, {0.2, 0.2, 1}},			    -- Ice Ward
	            },
	    ROGUE = {
	            {57933, {0.89, 0.1, 0.1}},			    -- Tricks of the Trade
	            },
	  WARLOCK = {
	            {20707, {0.7, 0.32, 0.75}},			    -- Soulstone
	            },
	  WARRIOR = {
	            {114030, {0.2, 0.2, 1}},			    -- Vigilance
	            {3411, {0.89, 0.1, 0.1}, 'TOPRIGHT'},   -- Intervene
	            },
 }

 
-----------------------------
-- Castbars 
-----------------------------

-- Player
cfg.player_cb = {
        enable = true,
		width = 247,
		height = 30,
}

-----------------------------
-- gempUI options
-----------------------------

if G.options.actionbars_main_three then
	cfg.player_cb.pos = {'BOTTOM', UIParent, 16, 130}
	cfg.unit_positions.Player = { a = UIParent, x= -132, y=  228 }				
    cfg.unit_positions.Target = {a = UIParent, x=  132, y=  228} 
elseif not G.options.actionbars_main_three then
	cfg.player_cb.pos = {'BOTTOM', UIParent, 16, 91}
	cfg.unit_positions.Player = { a = UIParent, x= -132, y=  189 }				
    cfg.unit_positions.Target = {a = UIParent, x=  132, y=  189}
end
        

-- Target
cfg.target_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -22},
		height = 15,
		width = 196,
}

-- Focus
cfg.focus_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -23},
		height = 15,
		width = 150,
}

-- Boss
cfg.boss_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -23},
		height = 15,
		width = 150,
}

-- Party
cfg.party_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -19},
		height = 15,
		width = 150,
}

-- Arena
cfg.arena_cb = {
        enable = true,
        pos = {'BOTTOMRIGHT', 0, -19},
		height = 15,
		width = 187,
}

-----------------------------
-- Colors 
-----------------------------
  
cfg.Color = { 				
       Health = {r =  G.color.r,	g =  G.color.g, 	b =  G.color.b, a = G.color.a},
	  Castbar = {r =  G.color.r,	g =  G.color.g, 	b =  G.color.b, a = G.color.a},
	  CPoints = {r =  .96,	g =  0.37, 	b =  0.34},
}

ns.cfg = cfg


