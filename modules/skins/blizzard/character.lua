local F, G, V = unpack(select(2, ...))

-- CharacterFrame big
CharacterFrameInsetRight:DisableDrawLayer("BACKGROUND")
CharacterFrameInsetRight:DisableDrawLayer("BORDER")
F.ReskinPortraitIcon(CharacterFrame, true)


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
