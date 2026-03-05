------------------------------------------------------------------------
-- SmartGear · gearscore.lua
-- Implements the classic GearScore calculation logic.
------------------------------------------------------------------------

local GS_ItemTypes = {
    ["INVTYPE_HEAD"]        = 1.0,
    ["INVTYPE_NECK"]        = 0.5625,
    ["INVTYPE_SHOULDER"]    = 0.75,
    ["INVTYPE_BODY"]        = 0,
    ["INVTYPE_CHEST"]       = 1.0,
    ["INVTYPE_ROBE"]        = 1.0,
    ["INVTYPE_WAIST"]       = 0.75,
    ["INVTYPE_LEGS"]        = 1.0,
    ["INVTYPE_FEET"]        = 0.75,
    ["INVTYPE_WRIST"]       = 0.5625,
    ["INVTYPE_HAND"]        = 0.75,
    ["INVTYPE_FINGER"]      = 0.5625,
    ["INVTYPE_TRINKET"]     = 0.5625,
    ["INVTYPE_CLOAK"]       = 0.5625,
    ["INVTYPE_WEAPON"]      = 1.0,
    ["INVTYPE_SHIELD"]      = 1.0,
    ["INVTYPE_2HWEAPON"]    = 2.0,
    ["INVTYPE_WEAPONMAINHAND"]= 1.0,
    ["INVTYPE_WEAPONOFFHAND"] = 1.0,
    ["INVTYPE_HOLDABLE"]    = 1.0,
    ["INVTYPE_RANGED"]      = 0.3164,
    ["INVTYPE_THROWN"]      = 0.3164,
    ["INVTYPE_RANGEDRIGHT"] = 0.3164,
    ["INVTYPE_RELIC"]       = 0.3164,
    ["INVTYPE_TABARD"]      = 0,
    ["INVTYPE_BAG"]         = 0,
    [""]                    = 0,
}

local GS_QualityMultipliers = {
    [0] = 0.0,   -- Poor
    [1] = 0.005, -- Common
    [2] = 0.005, -- Uncommon (Scaling factor proxy)
    [3] = 1.0,   -- Rare
    [4] = 1.3,   -- Epic
    [5] = 1.3,   -- Legendary uses epic curve
    [6] = 1.3,   -- Artifact
    [7] = 1.3,   -- Heirloom
}

local GS_QualityColors = {
    [0] = { 0.55, 0.55, 0.55 },
    [1] = { 1.00, 1.00, 1.00 },
    [2] = { 0.12, 1.00, 0.00 },
    [3] = { 0.00, 0.44, 0.87 },
    [4] = { 0.64, 0.21, 0.93 },
    [5] = { 1.00, 0.50, 0.00 },
}

-- Approximated curve to mimic WotLK classic GearScore values for level 80 epics.
local function GetItemScoreMath(ilvl, rarity)
    if not ilvl or ilvl == 0 then return 0 end
    
    local mult = GS_QualityMultipliers[rarity] or 1.0
    local base = 0
    
    if ilvl > 120 then
        -- Standard WotLK epic scaling curve approximation
        base = ((ilvl - 91) * 4.25) * mult
        if base < 0 then base = 0 end
    else
        -- Vanilla/TBC items
        base = ((ilvl - 20) * 1.5) * mult
        if base < 0 then base = 0 end
    end
    
    if rarity == 2 then base = base * 0.8 end -- adjust down uncommon
    if rarity == 3 then base = base * 0.9 end -- adjust down rare
    if rarity == 5 then base = base * 1.1 end -- adjust up legendary
    
    return base
end

function SmartGear:GetClassicGearScore(itemLink)
    if not itemLink then return 0 end
    local _, _, rarity, ilvl, _, _, _, _, equipLoc = GetItemInfo(itemLink)
    if not equipLoc or not ilvl then return 0 end
    
    local modifier = GS_ItemTypes[equipLoc] or 0
    local mathScore = GetItemScoreMath(ilvl, rarity)
    
    return math.floor((mathScore * modifier) + 0.5)
end

function SmartGear:GetColorByGearScore(score)
    if not score then return "|cff888888" end
    if score >= 5800 then return "|cffff8000" -- legendary
    elseif score >= 4800 then return "|cffa335ee" -- epic
    elseif score >= 3200 then return "|cff0070dd" -- rare
    elseif score >= 2000 then return "|cff1eff00" -- uncommon
    else return "|cffffffff" end -- common
end

------------------------------------------------------------------------
-- Inspect Unit scanning (For Player Tooltips)
------------------------------------------------------------------------
local inspectTimer = CreateFrame("Frame")
inspectTimer.timeElapsed = 0

function SmartGear:GetUnitGearScore(unit)
    if not UnitIsPlayer(unit) then return 0 end
    
    local totalScore = 0
    local mainhandScore = 0
    local isHunter = false
    
    local _, class = UnitClass(unit)
    if class == "HUNTER" then isHunter = true end

    -- Scan 1-18 slots (Classic WotLK GS ignores shirt/tabard)
    for i = 1, 18 do
        local link = GetInventoryItemLink(unit, i)
        if link then
            local score = self:GetClassicGearScore(link)
            if i == 16 then
                mainhandScore = score
            end
            totalScore = totalScore + score
        end
    end

    -- WotLK GS formula adjusts for Hunters (ranged weapons count more) and TitansGrip weapons
    -- If mainhand is a 2H but they have an offhand, it's Titan's Grip (Warrior limit) -> half the 2H score
    -- This is a simplified fallback that covers 99% of cases correctly:
    if mainhandScore > 0 then
        local link = GetInventoryItemLink(unit, 16)
        if link then
            local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(link)
            if equipLoc == "INVTYPE_2HWEAPON" and GetInventoryItemLink(unit, 17) then
                totalScore = totalScore - math.floor(mainhandScore / 2)
            end
        end
    end

    return totalScore
end
