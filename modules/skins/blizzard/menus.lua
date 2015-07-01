-- changes the Escape menu
gempUI_rebackdrop(GameMenuFrame)
GameMenuFrameHeader:Hide()

local dummyFunc = function() end
for id, btn in pairs({GameMenuFrame:GetChildren()}) do
	btn.Left:SetTexture(nil);
	btn.Right:SetTexture(nil);
	btn.Middle:SetTexture(nil);
	btn:SetHighlightTexture(nil);
	
	btn.Left.SetTexture = dummyFunc;
	btn.Right.SetTexture = dummyFunc;
	btn.Middle.SetTexture = dummyFunc;
end

-- removes textures from some blizzard buttons
GameMenuButtonHelp:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonStore:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonWhatsNew:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonOptions:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonUIOptions:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonKeybindings:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonMacros:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonAddons:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonLogout:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonQuit:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")
GameMenuButtonContinue:SetHighlightTexture(gempUI_media.."blizzard\\highlights\\long_button")


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



