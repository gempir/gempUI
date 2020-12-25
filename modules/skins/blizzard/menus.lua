local F, G, V = unpack(select(2, ...))

-- changes the Escape menu
-- F.rebackdrop(GameMenuFrame)
-- -- GameMenuFrameHeader:Hide()

-- local dummyFunc = function() end
-- for id, btn in pairs({ GameMenuFrame:GetChildren() }) do
-- 	btn.Left:SetTexture(nil);
-- 	btn.Right:SetTexture(nil);
-- 	btn.Middle:SetTexture(nil);
-- 	btn:SetHighlightTexture(nil);

-- 	btn.Left.SetTexture = dummyFunc;
-- 	btn.Right.SetTexture = dummyFunc;
-- 	btn.Middle.SetTexture = dummyFunc;
-- end

-- removes textures from some blizzard buttons
GameMenuButtonHelp:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonStore:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonWhatsNew:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonOptions:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonUIOptions:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonKeybindings:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonMacros:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonAddons:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonLogout:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonQuit:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")
GameMenuButtonContinue:SetHighlightTexture(G.media .. "blizzard\\highlights\\long_button")


-- F.rebackdroplight(GameMenuButtonHelp)
-- F.rebackdroplight(GameMenuButtonStore)
-- F.rebackdroplight(GameMenuButtonWhatsNew)
-- F.rebackdroplight(GameMenuButtonOptions)
-- F.rebackdroplight(GameMenuButtonUIOptions)
-- F.rebackdroplight(GameMenuButtonKeybindings)
-- F.rebackdroplight(GameMenuButtonMacros)
-- F.rebackdroplight(GameMenuButtonAddons)
-- F.rebackdroplight(GameMenuButtonLogout)
-- F.rebackdroplight(GameMenuButtonQuit)
-- F.rebackdroplight(GameMenuButtonContinue)






