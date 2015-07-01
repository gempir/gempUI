-- This sets some simple saved variables for Skada so it fits in my current minimap damage frame


if (IsAddOnLoaded("Skada")) then
	if SkadaSkinSet == true then

	elseif SkadaSkinSet == nil or false then
		
		SkadaDB.hasUpgraded = true
		SkadaDB.profiles.Default.windows[1].barslocked = true
		SkadaDB.profiles.Default.windows[1].point = "TOPRIGHT"
		SkadaDB.profiles.Default.windows[1].barwidth = 176
		SkadaDB.profiles.Default.windows[1].barheight = 12
		SkadaDB.profiles.Default.windows[1].background.height = 72
		SkadaDB.profiles.Default.windows[1].enabletitle = false
		SkadaDB.profiles.Default.windows[1].barfont = "Roboto"
		SkadaDB.profiles.Default.windows[1].bartexture = "Flat"
		SkadaDB.profiles.Default.windows[1].barslocked = true
		SkadaDB.profiles.Default.windows[1].background.color.a = 0
		SkadaDB.profiles.Default.icon.hide = true
		-- Barcolors
		SkadaDB.profiles.Default.windows[1].barbgcolor.a = 0
		SkadaDB.profiles.Default.windows[1].barcolor.r = gempUIcolor.r
		SkadaDB.profiles.Default.windows[1].barcolor.g = gempUIcolor.g
		SkadaDB.profiles.Default.windows[1].barcolor.b = gempUIcolor.b
		-- Position
		SkadaDB.profiles.Default.windows[1].y = -208
		SkadaDB.profiles.Default.windows[1].x = -7

		if not SkadaDB.profiles.Default.windows[1].background then
			SkadaDB.profiles.Default.windows[1].background = {}
		end
	end
end

if (IsAddOnLoaded("Skada")) then
	SkadaSkinSet = true 
end



	