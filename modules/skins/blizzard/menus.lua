-- changes the Escape menu
gempUI_rebackdrop(GameMenuFrame)
GameMenuFrameHeader:Hide()

-- removes textures from some blizzard buttons
GameMenuButtonHelp:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonHelp.Left)
gempUI_textureclear(GameMenuButtonHelp.Middle)
gempUI_textureclear(GameMenuButtonHelp.Right)

GameMenuButtonStore:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonStore.Left)
gempUI_textureclear(GameMenuButtonStore.Middle)
gempUI_textureclear(GameMenuButtonStore.Right)

GameMenuButtonWhatsNew:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonWhatsNew.Left)
gempUI_textureclear(GameMenuButtonWhatsNew.Middle)
gempUI_textureclear(GameMenuButtonWhatsNew.Right)

GameMenuButtonOptions:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonOptions.Left)
gempUI_textureclear(GameMenuButtonOptions.Middle)
gempUI_textureclear(GameMenuButtonOptions.Right)

GameMenuButtonUIOptions:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonUIOptions.Left)
gempUI_textureclear(GameMenuButtonUIOptions.Middle)
gempUI_textureclear(GameMenuButtonUIOptions.Right)

GameMenuButtonKeybindings:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonKeybindings.Left)
gempUI_textureclear(GameMenuButtonKeybindings.Middle)
gempUI_textureclear(GameMenuButtonKeybindings.Right)

GameMenuButtonMacros:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonMacros.Left)
gempUI_textureclear(GameMenuButtonMacros.Middle)
gempUI_textureclear(GameMenuButtonMacros.Right)

GameMenuButtonAddons:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonAddons.Left)
gempUI_textureclear(GameMenuButtonAddons.Middle)
gempUI_textureclear(GameMenuButtonAddons.Right)

GameMenuButtonLogout:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonLogout.Left)
gempUI_textureclear(GameMenuButtonLogout.Middle)
gempUI_textureclear(GameMenuButtonLogout.Right)

GameMenuButtonQuit:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

gempUI_textureclear(GameMenuButtonQuit.Left)
gempUI_textureclear(GameMenuButtonQuit.Middle)
gempUI_textureclear(GameMenuButtonQuit.Right)

GameMenuButtonContinue:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")

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
ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetNormalTexture(gempUI_media.."blizzard\\buttons\\UI-Panel-QuestHideButton")
ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetPushedTexture(gempUI_media.."blizzard\\buttons\\UI-Panel-QuestHideButton")
ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\32")

