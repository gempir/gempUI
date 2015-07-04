local F, G, V = unpack(select(2, ...))

-- CharacterFrame big
CharacterFrameInsetRight:DisableDrawLayer("BACKGROUND")
CharacterFrameInsetRight:DisableDrawLayer("BORDER")
F.ReskinPortraitIcon(CharacterFrame, true)

-- close 

CharacterFrameCloseButton:SetNormalTexture(G.media.."blizzard\\buttons\\close")
CharacterFrameCloseButton:SetHighlightTexture(G.media.."blizzard\\highlights\\32_round")
CharacterFrameCloseButton:SetPushedTexture(nil)

-- tabs
CharacterFrameTab1:DisableDrawLayer("BACKGROUND")
CharacterFrameTab3:DisableDrawLayer("BACKGROUND")
CharacterFrameTab4:DisableDrawLayer("BACKGROUND")
F.retexturetab(CharacterFrameTab1)
F.retexturetab(CharacterFrameTab3)
F.retexturetab(CharacterFrameTab4)
CharacterFrameTab1:SetHighlightTexture(G.media.."blizzard\\highlights\\tab1")
CharacterFrameTab3:SetHighlightTexture(G.media.."blizzard\\highlights\\tab3")
CharacterFrameTab4:SetHighlightTexture(G.media.."blizzard\\highlights\\tab4")

-- items
CharacterHeadSlot:DisableDrawLayer("BACKGROUND")
CharacterNeckSlot:DisableDrawLayer("BACKGROUND")
CharacterShoulderSlot:DisableDrawLayer("BACKGROUND")
CharacterBackSlot:DisableDrawLayer("BACKGROUND")
CharacterChestSlot:DisableDrawLayer("BACKGROUND")
CharacterShirtSlot:DisableDrawLayer("BACKGROUND")
CharacterTabardSlot:DisableDrawLayer("BACKGROUND")
CharacterWristSlot:DisableDrawLayer("BACKGROUND")

CharacterMainHandSlot:DisableDrawLayer("BACKGROUND")
CharacterSecondaryHandSlot:DisableDrawLayer("BACKGROUND")

CharacterHandsSlot:DisableDrawLayer("BACKGROUND")
CharacterWaistSlot:DisableDrawLayer("BACKGROUND")
CharacterLegsSlot:DisableDrawLayer("BACKGROUND")
CharacterFeetSlot:DisableDrawLayer("BACKGROUND")
CharacterFinger0Slot:DisableDrawLayer("BACKGROUND")
CharacterFinger1Slot:DisableDrawLayer("BACKGROUND")
CharacterTrinket0Slot:DisableDrawLayer("BACKGROUND")
CharacterTrinket1Slot:DisableDrawLayer("BACKGROUND")


-- categories
F.rebackdrop(CharacterFrame)
F.rebackdrop(CharacterStatsPaneCategory1)
F.rebackdrop(CharacterStatsPaneCategory2)
F.rebackdrop(CharacterStatsPaneCategory3)
F.rebackdrop(CharacterStatsPaneCategory4)
F.rebackdrop(CharacterStatsPaneCategory5)
F.rebackdrop(CharacterStatsPaneCategory6)

CharacterStatsPaneCategory1:DisableDrawLayer("BACKGROUND")
CharacterStatsPaneCategory2:DisableDrawLayer("BACKGROUND")
CharacterStatsPaneCategory3:DisableDrawLayer("BACKGROUND")
CharacterStatsPaneCategory4:DisableDrawLayer("BACKGROUND")
CharacterStatsPaneCategory5:DisableDrawLayer("BACKGROUND")
CharacterStatsPaneCategory6:DisableDrawLayer("BACKGROUND")


local category1 = CharacterStatsPaneCategory1:CreateFontString("category1", "ARTWORK")
category1:SetFont(G.fonts.roboto, 12)
category1:SetPoint("LEFT", CharacterStatsPaneCategory1,"TOP",-68,-8)
category1:SetText("General")

local category2 = CharacterStatsPaneCategory2:CreateFontString("category2", "ARTWORK")
category2:SetFont(G.fonts.roboto, 12)
category2:SetPoint("LEFT", CharacterStatsPaneCategory2,"TOP",-68,-8)
category2:SetText("Attributes")

local category3 = CharacterStatsPaneCategory3:CreateFontString("category3", "ARTWORK")
category3:SetFont(G.fonts.roboto, 12)
category3:SetPoint("LEFT", CharacterStatsPaneCategory3,"TOP",-68,-8)
category3:SetText("Enhancements")

local category4 = CharacterStatsPaneCategory4:CreateFontString("category4", "ARTWORK")
category4:SetFont(G.fonts.roboto, 12)
category4:SetPoint("LEFT", CharacterStatsPaneCategory4,"TOP",-68,-8)
category4:SetText("Attack")

local category5 = CharacterStatsPaneCategory5:CreateFontString("category5", "ARTWORK")
category5:SetFont(G.fonts.roboto, 12)
category5:SetPoint("LEFT", CharacterStatsPaneCategory5,"TOP",-68,-8)
category5:SetText("Spell")

local category6 = CharacterStatsPaneCategory6:CreateFontString("category6", "ARTWORK")
category6:SetFont(G.fonts.roboto, 12)
category6:SetPoint("LEFT", CharacterStatsPaneCategory6,"TOP",-68,-8)
category6:SetText("Defense")

F.rebackdrop(PaperDollTitlesPane)

PaperDollTitlesPaneButton1:DisableDrawLayer("BACKGROUND")
PaperDollTitlesPaneButton2:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton3:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton4:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton5:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton6:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton7:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton8:DisableDrawLayer("BACKGROUND")		
PaperDollTitlesPaneButton9:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton10:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton11:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton12:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton13:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton14:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton15:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton16:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton17:DisableDrawLayer("BACKGROUND")	
PaperDollTitlesPaneButton18:DisableDrawLayer("BACKGROUND")	

-- Equipment manager

PaperDollEquipmentManagerPaneButton1:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton2:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton3:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton4:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton5:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton6:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton7:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton8:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton9:DisableDrawLayer("BACKGROUND")
PaperDollEquipmentManagerPaneButton10:DisableDrawLayer("BACKGROUND")

-- stuff on right side

PaperDollSidebarTabs.DecorRight:SetTexture(nil)
PaperDollSidebarTabs.DecorLeft:SetTexture(nil)

PaperDollSidebarTab1.TabBg:SetTexture(nil)
PaperDollSidebarTab2.TabBg:SetTexture(nil)
PaperDollSidebarTab3.TabBg:SetTexture(nil)

F.retexturestab(PaperDollSidebarTab1)
F.retexturestab(PaperDollSidebarTab2)
F.retexturestab(PaperDollSidebarTab3)

-- Reputation 
-- sorry this shitty and not object oriented at all but I have no Idea how to turn a string into the framename I need

ReputationBar1:DisableDrawLayer("MEDIUM")
ReputationBar1ReputationBarLeftTexture:SetTexture(nil)
ReputationBar1ReputationBarRightTexture:SetTexture(nil)
ReputationBar1ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
ReputationBar1:SetHighlightTexture(G.media.."blizzard\\highlights\\32")
F.bgframe(ReputationBar1)
F.bgframe2(ReputationBar1ReputationBar)

ReputationBar2:DisableDrawLayer("MEDIUM")
ReputationBar2ReputationBarLeftTexture:SetTexture(nil)
ReputationBar2ReputationBarRightTexture:SetTexture(nil)
ReputationBar2ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar2)
F.bgframe2(ReputationBar2ReputationBar)

ReputationBar3:DisableDrawLayer("MEDIUM")
ReputationBar3ReputationBarLeftTexture:SetTexture(nil)
ReputationBar3ReputationBarRightTexture:SetTexture(nil)
ReputationBar3ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar3)
F.bgframe2(ReputationBar3ReputationBar)

ReputationBar4:DisableDrawLayer("MEDIUM")
ReputationBar4ReputationBarLeftTexture:SetTexture(nil)
ReputationBar4ReputationBarRightTexture:SetTexture(nil)
ReputationBar4ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar4)
F.bgframe2(ReputationBar4ReputationBar)

ReputationBar5:DisableDrawLayer("MEDIUM")
ReputationBar5ReputationBarLeftTexture:SetTexture(nil)
ReputationBar5ReputationBarRightTexture:SetTexture(nil)
ReputationBar5ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar5)
F.bgframe2(ReputationBar5ReputationBar)

ReputationBar6:DisableDrawLayer("MEDIUM")
ReputationBar6ReputationBarLeftTexture:SetTexture(nil)
ReputationBar6ReputationBarRightTexture:SetTexture(nil)
ReputationBar6ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar6)
F.bgframe2(ReputationBar6ReputationBar)

ReputationBar7:DisableDrawLayer("MEDIUM")
ReputationBar7ReputationBarLeftTexture:SetTexture(nil)
ReputationBar7ReputationBarRightTexture:SetTexture(nil)
ReputationBar7ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar7)
F.bgframe2(ReputationBar7ReputationBar)

ReputationBar8:DisableDrawLayer("MEDIUM")
ReputationBar8ReputationBarLeftTexture:SetTexture(nil)
ReputationBar8ReputationBarRightTexture:SetTexture(nil)
ReputationBar8ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar8)
F.bgframe2(ReputationBar8ReputationBar)

ReputationBar9:DisableDrawLayer("MEDIUM")
ReputationBar9ReputationBarLeftTexture:SetTexture(nil)
ReputationBar9ReputationBarRightTexture:SetTexture(nil)
ReputationBar9ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar9)
F.bgframe2(ReputationBar9ReputationBar)

ReputationBar10:DisableDrawLayer("MEDIUM")
ReputationBar10ReputationBarLeftTexture:SetTexture(nil)
ReputationBar10ReputationBarRightTexture:SetTexture(nil)
ReputationBar10ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar10)
F.bgframe2(ReputationBar10ReputationBar)

ReputationBar11:DisableDrawLayer("MEDIUM")
ReputationBar11ReputationBarLeftTexture:SetTexture(nil)
ReputationBar11ReputationBarRightTexture:SetTexture(nil)
ReputationBar11ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar11)
F.bgframe2(ReputationBar11ReputationBar)

ReputationBar12:DisableDrawLayer("MEDIUM")
ReputationBar12ReputationBarLeftTexture:SetTexture(nil)
ReputationBar12ReputationBarRightTexture:SetTexture(nil)
ReputationBar12ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar12)
F.bgframe2(ReputationBar12ReputationBar)

ReputationBar13:DisableDrawLayer("MEDIUM")
ReputationBar13ReputationBarLeftTexture:SetTexture(nil)
ReputationBar13ReputationBarRightTexture:SetTexture(nil)
ReputationBar13ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar13)
F.bgframe2(ReputationBar13ReputationBar)

ReputationBar14:DisableDrawLayer("MEDIUM")
ReputationBar14ReputationBarLeftTexture:SetTexture(nil)
ReputationBar14ReputationBarRightTexture:SetTexture(nil)
ReputationBar14ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar14)
F.bgframe2(ReputationBar14ReputationBar)

ReputationBar15:DisableDrawLayer("MEDIUM")
ReputationBar15ReputationBarLeftTexture:SetTexture(nil)
ReputationBar15ReputationBarRightTexture:SetTexture(nil)
ReputationBar15ReputationBar:SetStatusBarTexture(G.media.."textures\\flat")
F.bgframe(ReputationBar15)
F.bgframe2(ReputationBar15ReputationBar)

