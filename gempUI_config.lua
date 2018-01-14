-- local F, G, V = unpack(select(2, ...))

-- local function CreatePanel(panel)
--     panel.title, panel.subtitle = panel:MakeTitleTextAndSubText(
--         "gempUI Options", "These options allow you to configure various aspects of gempUI.")

--     local function makeToggle(name, desc, varname)
--         return panel:MakeToggle(
--             "name", name,
--             "description", desc,
--             "default", V.options[varname],
--             "getFunc", function() return V.options[varname] end,
--             "setFunc", function(value) V.options[varname] = value end
--         )
--     end

--     panel.expbar = makeToggle("Activate Exp/Rep Bar", "Waypoints that are clicked in LightHeaded will be sent to TomTom, if installed.", "wp_tomtom")

  
--     local options = {}
--     table.insert(options, panel.expbar)

--     for idx,frame in ipairs(options) do
--         if idx == 1 then
--             frame:SetPoint("TOPLEFT", panel.subtitle, "BOTTOMLEFT", 0, -10)
--         else
--             frame:SetPoint("TOPLEFT", options[idx-1], "BOTTOMLEFT", 0, -5)
--         end
--     end

--     panel.bgalpha:SetPoint("TOPLEFT", options[#options], "BOTTOMLEFT", 0, -20)
--     panel.fontsize:SetPoint("TOPLEFT", panel.bgalpha, "BOTTOMLEFT", 0, -20)
-- end

-- local simple = LibStub("LibSimpleOptions-1.0").AddOptionsPanel("gempUI", CreatePanel)

