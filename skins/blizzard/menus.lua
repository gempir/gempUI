


-- changes the Escape menu
gempUI_rebackdrop(GameMenuFrame)
GameMenuFrameHeader:Hide()
--GameMenuButtonHelp:SetNormalTexture(gempUI_media.."blizzard\\Buttons\\UI-Panel-QuestHideButton")

-- removes textures from some blizzard buttons
gempUI_textureclear(GameMenuButtonHelp.Left)
gempUI_textureclear(GameMenuButtonHelp.Middle)
gempUI_textureclear(GameMenuButtonHelp.Right)

gempUI_textureclear(GameMenuButtonStore.Left)
gempUI_textureclear(GameMenuButtonStore.Middle)
gempUI_textureclear(GameMenuButtonStore.Right)

gempUI_textureclear(GameMenuButtonWhatsNew.Left)
gempUI_textureclear(GameMenuButtonWhatsNew.Middle)
gempUI_textureclear(GameMenuButtonWhatsNew.Right)

gempUI_textureclear(GameMenuButtonOptions.Left)
gempUI_textureclear(GameMenuButtonOptions.Middle)
gempUI_textureclear(GameMenuButtonOptions.Right)

gempUI_textureclear(GameMenuButtonUIOptions.Left)
gempUI_textureclear(GameMenuButtonUIOptions.Middle)
gempUI_textureclear(GameMenuButtonUIOptions.Right)

gempUI_textureclear(GameMenuButtonKeybindings.Left)
gempUI_textureclear(GameMenuButtonKeybindings.Middle)
gempUI_textureclear(GameMenuButtonKeybindings.Right)

gempUI_textureclear(GameMenuButtonMacros.Left)
gempUI_textureclear(GameMenuButtonMacros.Middle)
gempUI_textureclear(GameMenuButtonMacros.Right)

gempUI_textureclear(GameMenuButtonAddons.Left)
gempUI_textureclear(GameMenuButtonAddons.Middle)
gempUI_textureclear(GameMenuButtonAddons.Right)

gempUI_textureclear(GameMenuButtonLogout.Left)
gempUI_textureclear(GameMenuButtonLogout.Middle)
gempUI_textureclear(GameMenuButtonLogout.Right)

gempUI_textureclear(GameMenuButtonQuit.Left)
gempUI_textureclear(GameMenuButtonQuit.Middle)
gempUI_textureclear(GameMenuButtonQuit.Right)

gempUI_textureclear(GameMenuButtonContinue.Left)
gempUI_textureclear(GameMenuButtonContinue.Middle)
gempUI_textureclear(GameMenuButtonContinue.Right)





-- gives the buttons a dark background
gempUI_rebackdropdark(GameMenuButtonHelp)
gempUI_rebackdropdark(GameMenuButtonStore)
gempUI_rebackdropdark(GameMenuButtonWhatsNew)
gempUI_rebackdropdark(GameMenuButtonOptions)
gempUI_rebackdropdark(GameMenuButtonUIOptions)
gempUI_rebackdropdark(GameMenuButtonKeybindings)
gempUI_rebackdropdark(GameMenuButtonMacros)
gempUI_rebackdropdark(GameMenuButtonAddons)
gempUI_rebackdropdark(GameMenuButtonLogout)
gempUI_rebackdropdark(GameMenuButtonQuit)
gempUI_rebackdropdark(GameMenuButtonContinue)





-- Skin for the Objective Tracker
ObjectiveTrackerBlocksFrame.QuestHeader.Background:SetTexture(nil)
gempUI_rebackdrop(ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)
ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetNormalTexture(gempUI_media.."blizzard\\Buttons\\UI-Panel-QuestHideButton")
ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetPushedTexture(gempUI_media.."blizzard\\Buttons\\UI-Panel-QuestHideButton")
ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetHighlightTexture(gempUI_media.."highlights\\32")

