------------------------------------------------------------------------
-- SmartGear · ui_recommendations.lua
-- Creates the interactive pop-up window for Recommendations
------------------------------------------------------------------------

local SmartGear = _G.SmartGear
local L = SmartGear.L
local RecFrame = nil

local function CreateRecommendationsFrame()
    if RecFrame then return end
    
    RecFrame = CreateFrame("Frame", "SmartGearRecommendationsFrame", UIParent)
    RecFrame:SetSize(400, 350)
    RecFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 50)
    RecFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    RecFrame:SetMovable(true)
    RecFrame:EnableMouse(true)
    RecFrame:RegisterForDrag("LeftButton")
    RecFrame:SetScript("OnDragStart", RecFrame.StartMoving)
    RecFrame:SetScript("OnDragStop", RecFrame.StopMovingOrSizing)
    RecFrame:Hide()
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, RecFrame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)
    
    -- Title
    local titleBg = RecFrame:CreateTexture(nil, "ARTWORK")
    titleBg:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
    titleBg:SetWidth(300)
    titleBg:SetHeight(64)
    titleBg:SetPoint("TOP", 0, 12)
    
    local titleText = RecFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleText:SetPoint("TOP", titleBg, "TOP", 0, -14)
    titleText:SetText(L["REC_TITLE"])
    titleText:SetTextColor(1, 0.82, 0)
    
    -- Content Area
    RecFrame.Content = CreateFrame("Frame", nil, RecFrame)
    RecFrame.Content:SetPoint("TOPLEFT", 15, -40)
    RecFrame.Content:SetPoint("BOTTOMRIGHT", -15, 15)
    
    -- Dungeons Section
    local dTitle = RecFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    dTitle:SetPoint("TOPLEFT", 5, -5)
    dTitle:SetText("|cffffff00" .. L["REC_DUNGEONS"] .. "|r")
    
    RecFrame.TiersContainer = CreateFrame("Frame", nil, RecFrame.Content)
    RecFrame.TiersContainer:SetPoint("TOPLEFT", dTitle, "BOTTOMLEFT", 0, -5)
    RecFrame.TiersContainer:SetSize(360, 140)
    
    -- Generate Tier FontStrings
    RecFrame.TierTexts = {}
    for i = 1, 8 do
        local fs = RecFrame.TiersContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        fs:SetPoint("TOPLEFT", 10, -(i-1) * 16)
        fs:SetJustifyH("LEFT")
        fs:SetWidth(350)
        RecFrame.TierTexts[i] = fs
    end
    
    -- Spacer
    local spacer = RecFrame.Content:CreateTexture(nil, "ARTWORK")
    spacer:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
    spacer:SetHeight(2)
    spacer:SetPoint("TOPLEFT", RecFrame.TiersContainer, "BOTTOMLEFT", 0, -10)
    spacer:SetPoint("TOPRIGHT", RecFrame.TiersContainer, "BOTTOMRIGHT", 0, -10)
    spacer:SetTexCoord(0.81, 0.94, 0.5, 1)

    -- Stats Section
    local sTitle = RecFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    sTitle:SetPoint("TOPLEFT", spacer, "BOTTOMLEFT", 0, -10)
    sTitle:SetText("|cffffff00" .. L["REC_STATS"] .. "|r")
    
    RecFrame.SpecText = RecFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    RecFrame.SpecText:SetPoint("TOPLEFT", sTitle, "BOTTOMLEFT", 10, -5)
    RecFrame.SpecText:SetTextColor(0, 1, 1)
    
    RecFrame.GemsLabel = RecFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    RecFrame.GemsLabel:SetPoint("TOPLEFT", RecFrame.SpecText, "BOTTOMLEFT", 0, -8)
    RecFrame.GemsLabel:SetText("|cffffcc00"..L["REC_GEMS"].."|r")
    
    RecFrame.GemsValue = RecFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    RecFrame.GemsValue:SetPoint("TOPLEFT", RecFrame.GemsLabel, "BOTTOMLEFT", 10, -2)
    RecFrame.GemsValue:SetWidth(340)
    RecFrame.GemsValue:SetJustifyH("LEFT")
    RecFrame.GemsValue:SetWordWrap(true)
    
    RecFrame.EnchLabel = RecFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    RecFrame.EnchLabel:SetPoint("TOPLEFT", RecFrame.GemsValue, "BOTTOMLEFT", -10, -8)
    RecFrame.EnchLabel:SetText("|cffffcc00"..L["REC_ENCHANTS"].."|r")
    
    RecFrame.EnchValue = RecFrame.Content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    RecFrame.EnchValue:SetPoint("TOPLEFT", RecFrame.EnchLabel, "BOTTOMLEFT", 10, -2)
    RecFrame.EnchValue:SetWidth(340)
    RecFrame.EnchValue:SetJustifyH("LEFT")
    RecFrame.EnchValue:SetWordWrap(true)
end

function SmartGear:UpdateRecommendationsContent()
    if not RecFrame then return end
    
    -- 1. Refresh GS
    local myGS = SmartGear:GetUnitGearScore("player")
    local _, classFile = UnitClass("player")
    
    -- 2. Update Tier List Colors
    local tiers = SmartGear.InstanceTiers
    for i = 1, #tiers do
        local tier = tiers[i]
        local fs = RecFrame.TierTexts[i]
        
        -- Color logic: 
        -- Green if overgeared, Yellow if currently in bracket, Gray if undergeared
        local color = "|cff888888" -- Gray
        local prefix = "- "
        
        if myGS >= tier.min and myGS <= tier.max then
            color = "|cffffff00" -- Yellow (Active Bracket)
            prefix = "> "
        elseif myGS > tier.max then
            color = "|cff00ff00" -- Green (Geared)
            prefix = "+ "
        end
        
        fs:SetText(color .. prefix .. tier.title .. " (" .. tier.min .. " - " .. tier.max .. ")|r")
    end
    
    -- 3. Update Spec & Gems/Enchants
    local activeSpec = self:GetActiveSpecInfo()
    local specName = L["REC_UNKNOWN_SPEC"]
    local gems = "-"
    local enchants = "-"
    
    if activeSpec and activeSpec.name then
        specName = activeSpec.name
        
        local classData = SmartGear.SpecRecommendations[classFile]
        if classData and classData[specName] then
            gems = classData[specName].gems
            enchants = classData[specName].enchants
        end
    end
    
    -- Fallback to generic text if no spec detected (e.g. low level without spent talents)
    RecFrame.SpecText:SetText(specName)
    RecFrame.GemsValue:SetText(gems)
    RecFrame.EnchValue:SetText(enchants)
end

function SmartGear:ToggleRecommendations()
    if not RecFrame then
        CreateRecommendationsFrame()
    end
    
    if RecFrame:IsVisible() then
        RecFrame:Hide()
    else
        self:UpdateRecommendationsContent()
        RecFrame:Show()
    end
end
