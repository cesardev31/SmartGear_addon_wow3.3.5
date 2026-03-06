------------------------------------------------------------------------
-- SmartGear · ui.lua
-- CharacterFrame panel & item slot visual overlays (borders, ilvl).
-- Compatible with WoW 3.3.5a (Interface 30300).
------------------------------------------------------------------------

local COLOR_GOLD   = "|cffffd700"
local COLOR_CYAN   = "|cff00ccff"
local COLOR_WHITE  = "|cffffffff"
local COLOR_CLOSE  = "|r"

------------------------------------------------------------------------
-- Character Frame info panel
------------------------------------------------------------------------
local panel
local scoreText
local ilvlText
local specText
local gsText

local function CreatePanel()
    -- Invisible frame anchored under the character's feet
    panel = CreateFrame("Frame", "SmartGearPanel", CharacterModelFrame)
    panel:SetSize(200, 40)
    panel:SetPoint("BOTTOM", CharacterModelFrame, "BOTTOM", 0, 10)
    panel:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 2)

    -- Huge GearScore text
    gsText = panel:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")
    gsText:SetPoint("TOP", panel, "TOP", 0, 0)

    -- Smaller SmartScore and Avg iLvl sitting just below it
    scoreText = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    scoreText:SetPoint("TOPRIGHT", panel, "BOTTOM", -4, 0)

    ilvlText = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ilvlText:SetPoint("TOPLEFT", panel, "BOTTOM", 4, 0)
    
    -- Spec label (hidden/removed to save space, or we can just anchor it top right of character frame)
    specText = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    specText:SetPoint("TOP", scoreText, "BOTTOM", 0, -2)

    panel:Show()
end

function SmartGear:UpdatePanel()
    if not panel then CreatePanel() end

    local score = self.totalScore   or 0
    local ilvl  = self.avgItemLevel or 0
    local spec  = self.specName     or SmartGear_L["UNKNOWN"]
    local gs    = self:GetUnitGearScore("player")

    -- Format GS nice and big
    gsText:SetText(self:GetColorByGearScore(gs) .. gs .. COLOR_CLOSE)
    
    -- Format other stats below
    scoreText:SetText(COLOR_GOLD .. SmartGear_L["SCORE"] .. ": " .. COLOR_WHITE .. score .. COLOR_CLOSE)
    ilvlText:SetText(COLOR_GOLD  .. SmartGear_L["AVG_ILVL"] .. ": " .. COLOR_WHITE .. ilvl .. COLOR_CLOSE)
    specText:SetText(COLOR_CYAN  .. spec .. COLOR_CLOSE)
end

------------------------------------------------------------------------
-- Slot overlays: Borders, iLvl, Durability, Warnings
------------------------------------------------------------------------
local slotFrames = {}

-- WoW global names for equipment slots on the character frame
local uiSlotNames = {
    [1]  = "CharacterHeadSlot",
    [2]  = "CharacterNeckSlot",
    [3]  = "CharacterShoulderSlot",
    [15] = "CharacterBackSlot",
    [5]  = "CharacterChestSlot",
    [9]  = "CharacterWristSlot",
    [10] = "CharacterHandsSlot",
    [6]  = "CharacterWaistSlot",
    [7]  = "CharacterLegsSlot",
    [8]  = "CharacterFeetSlot",
    [11] = "CharacterFinger0Slot",
    [12] = "CharacterFinger1Slot",
    [13] = "CharacterTrinket0Slot",
    [14] = "CharacterTrinket1Slot",
    [16] = "CharacterMainHandSlot",
    [17] = "CharacterSecondaryHandSlot",
    [18] = "CharacterRangedSlot",
}

local function CreateSlotOverlay(slotID, slotName)
    local parent = _G[slotName]
    if not parent then return nil end
    
    local f = CreateFrame("Frame", nil, parent)
    f:SetAllPoints()
    f:SetFrameLevel(parent:GetFrameLevel() + 5)
    
    -- Quality Border
    f.border = f:CreateTexture(nil, "OVERLAY")
    f.border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    f.border:SetBlendMode("ADD")
    f.border:SetWidth(68)
    f.border:SetHeight(68)
    f.border:SetPoint("CENTER", parent, "CENTER", 0, 1)
    f.border:Hide()
    
    -- Item Level String
    f.ilvl = f:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    f.ilvl:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    f.ilvl:SetTextColor(1, 1, 0) -- Yellow by default
    
    -- Durability String
    f.durability = f:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    f.durability:SetPoint("BOTTOMDEFAULT", f, "BOTTOM", 0, 2)
    
    -- Warning Icon (Red dot)
    f.warn = f:CreateTexture(nil, "OVERLAY")
    f.warn:SetTexture("Interface\\GLUES\\Models\\UI_Troll\\TrollVoodooGlow01")
    f.warn:SetSize(22, 22)
    f.warn:SetPoint("TOPLEFT", f, "TOPLEFT", -4, 4)
    f.warn:SetVertexColor(1, 0, 0, 0.9)
    f.warn:SetBlendMode("ADD")
    f.warn:Hide()
    
    return f
end

function SmartGear:UpdateSlotOverlays()
    -- Only update if the character frame is actually visible
    if not CharacterFrame:IsVisible() then return end
    
    for slotID, slotName in pairs(uiSlotNames) do
        if not slotFrames[slotID] then
            slotFrames[slotID] = CreateSlotOverlay(slotID, slotName)
        end
        
        local f = slotFrames[slotID]
        if f then
            local link = GetInventoryItemLink("player", slotID)
            if link then
                -- Quality Border
                local _, _, rarity = GetItemInfo(link)
                if rarity and rarity > 1 then
                    local r, g, b = GetItemQualityColor(rarity)
                    f.border:SetVertexColor(r, g, b, 0.8)
                    f.border:Show()
                else
                    f.border:Hide()
                end
                
                -- Item Level
                local ilvl = self:GetItemLevel(link)
                if ilvl > 0 then
                    f.ilvl:SetText(ilvl)
                else
                    f.ilvl:SetText("")
                end
                
                -- Durability
                local v, m = GetInventoryItemDurability(slotID)
                if v and m and m > 0 then
                    local pct = math.floor((v/m) * 100)
                    f.durability:SetText(pct .. "%")
                    if pct < 30 then
                        f.durability:SetTextColor(1, 0.2, 0.2)
                    elseif pct < 60 then
                        f.durability:SetTextColor(1, 1, 0)
                    else
                        f.durability:SetTextColor(0, 1, 0)
                    end
                else
                    f.durability:SetText("")
                end
                
                -- Warnings (Missing gems/enchants)
                local warns = self.gearWarnings and self.gearWarnings[slotID]
                if warns and #warns > 0 then
                    f.warn:Show()
                else
                    f.warn:Hide()
                end
            else
                -- Nothing equipped
                f.border:Hide()
                f.ilvl:SetText("")
                f.durability:SetText("")
                f.warn:Hide()
            end
        end
        -- Also update target frame if we are looking at ourself
        if UnitIsUnit("target", "player") and SmartGear.UpdateTargetFrameGS then
            SmartGear:UpdateTargetFrameGS()
        end
    end
end

if CharacterFrame then
    CharacterFrame:HookScript("OnShow", function()
        SmartGear:DetectSpec()
        SmartGear:ScanGear()
        SmartGear:UpdatePanel()
        SmartGear:UpdateSlotOverlays()
    end)
end

------------------------------------------------------------------------
-- Target Frame GearScore Display
------------------------------------------------------------------------
local targetGSText

local function CreateTargetFrameGS()
    if not TargetFrame then return end
    
    local f = CreateFrame("Frame", nil, TargetFrame)
    f:SetAllPoints()
    f:SetFrameLevel(TargetFrame:GetFrameLevel() + 2)
    
    targetGSText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    targetGSText:SetPoint("BOTTOMRIGHT", TargetFrame, "BOTTOMRIGHT", -35, 14)
end

function SmartGear:UpdateTargetFrameGS()
    if not targetGSText then
        CreateTargetFrameGS()
        -- Some UI mods remove the standard TargetFrame, check if we created it
        if not targetGSText then return end
    end
    
    if UnitExists("target") and UnitIsPlayer("target") then
        local gs = self:GetUnitGearScore("target")
        if gs and gs > 0 then
            targetGSText:SetText("GS: " .. self:GetColorByGearScore(gs) .. gs .. COLOR_CLOSE)
            targetGSText:Show()
        else
            targetGSText:Hide()
        end
    else
        targetGSText:Hide()
    end
end

-- Hook the native TargetFrame updates natively
if TargetFrame then
    TargetFrame:HookScript("OnShow", function()
        SmartGear:UpdateTargetFrameGS()
    end)
    hooksecurefunc("TargetFrame_Update", function()
        SmartGear:UpdateTargetFrameGS()
    end)
end

------------------------------------------------------------------------
-- Slash commands
------------------------------------------------------------------------
SLASH_SMARTGEAR1 = "/sg"
SLASH_SMARTGEAR2 = "/smartgear"

SlashCmdList["SMARTGEAR"] = function(msg)
    msg = (msg or ""):lower():trim()

    if msg == "scan" then
        SmartGear:DetectSpec()
        SmartGear:ScanGear()
        SmartGear:UpdatePanel()
        SmartGear:UpdateSlotOverlays()
        SmartGear:Print(SmartGear_L["CMD_RESCAN"])
        return
    end

    if msg == "spec" then
        SmartGear:DetectSpec()
        SmartGear:Print(SmartGear_L["CMD_SPEC"] .. " " .. (SmartGear.specName or SmartGear_L["UNKNOWN"]))
        return
    end

    if msg == "warnings" or msg == "warn" then
        SmartGear:ScanGear()
        local found = false
        for slotID, warns in pairs(SmartGear.gearWarnings or {}) do
            for _, w in ipairs(warns) do
                SmartGear:Print(SmartGear_L["CMD_WARN_SLOT"] .. " " .. slotID .. ": " .. w)
                found = true
            end
        end
        if not found then
            SmartGear:Print(SmartGear_L["CMD_NO_WARN"])
        end
        return
    end

    local gs = SmartGear:GetUnitGearScore("player")
    local gsColor = SmartGear:GetColorByGearScore(gs)
    
    SmartGear:Print("SmartGear " .. SmartGear_L["SCORE"] .. ": " .. (SmartGear.totalScore or 0))
    SmartGear:Print("SmartGear " .. SmartGear_L["AVG_ILVL"] .. ": " .. (SmartGear.avgItemLevel or 0))
    SmartGear:Print("Classic " .. SmartGear_L["GS_SCORE"] .. ": " .. gsColor .. gs .. "|r")
    SmartGear:Print(SmartGear_L["CMD_SPEC"] .. " " .. (SmartGear.specName or SmartGear_L["UNKNOWN"]))
    SmartGear:Print(SmartGear_L["CMD_HELP"])
end
