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

local GS_Formula = {
    ["A"] = { -- ItemLevel > 120
        [4] = { A = 91.4500, B = 0.6500 },
        [3] = { A = 81.3750, B = 0.8125 },
        [2] = { A = 73.0000, B = 1.0000 }
    },
    ["B"] = { -- ItemLevel <= 120
        [4] = { A = 26.0000, B = 1.2000 },
        [3] = { A = 0.7500,  B = 1.8000 },
        [2] = { A = 8.0000,  B = 2.0000 },
        [1] = { A = 0.0000,  B = 2.2500 }
    }
}

-- Exact WotLK GearScoreLite math curves from original source
local function GetItemScoreMath(ilvl, rarity)
    if not ilvl or ilvl == 0 then return 0 end
    
    local qualityScale = 1
    if rarity == 5 then qualityScale = 1.3; rarity = 4
    elseif rarity == 1 then qualityScale = 0.005; rarity = 2
    elseif rarity == 0 then qualityScale = 0.005; rarity = 2 end
    if rarity == 7 then rarity = 3; ilvl = 187.05 end
    
    local tableData
    if ilvl > 120 then
        tableData = GS_Formula["A"][rarity]
    else
        tableData = GS_Formula["B"][rarity]
    end
    
    if not tableData then return 0 end
    
    local scale = 1.8618
    local baseScore = ((ilvl - tableData.A) / tableData.B) * scale * qualityScale
    
    if baseScore < 0 then baseScore = 0 end
    return baseScore
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
-- Silent Inspect Engine & Cache
------------------------------------------------------------------------
-- In WotLK 3.3.5a, GetInventoryItemLink("target", slot) only works IF
-- the client has successfully inspected the target. We must silently
-- trigger NotifyInspect() and cache the calculated GearScore when the
-- server responds with the data.
------------------------------------------------------------------------
SmartGear.GSCache = {}
local inspectFrame = CreateFrame("Frame")
local lastInspectTime = 0
local currentInspectUnit = nil
local currentInspectGUID = nil

local function DoSilentInspect(unit)
    if not unit or not UnitIsPlayer(unit) or not CanInspect(unit) then return end
    
    local guid = UnitGUID(unit)
    if not guid then return end
    
    -- If we already have them cached recently or we just asked, skip.
    if SmartGear.GSCache[guid] then return end
    
    -- Throttle to avoid disconnecting from spamming the server
    if GetTime() - lastInspectTime < 1.0 then return end
    
    -- In 3.3.5a we MUST check if the inspect frame is not open by the user
    if InspectFrame and InspectFrame:IsVisible() then return end

    lastInspectTime = GetTime()
    currentInspectUnit = unit
    currentInspectGUID = guid
    
    NotifyInspect(unit)
end

-- Calculate on the spot immediately assuming data is available
local function CalculateGS(unit)
    if not unit or not UnitIsPlayer(unit) then return 0 end
    
    local totalScore = 0
    local mainhandScore = 0

    for i = 1, 18 do
        local link = GetInventoryItemLink(unit, i)
        if link then
            local score = SmartGear:GetClassicGearScore(link)
            if i == 16 then mainhandScore = score end
            totalScore = totalScore + score
        end
    end

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

inspectFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
inspectFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
inspectFrame:RegisterEvent("INSPECT_TALENT_READY")
inspectFrame:SetScript("OnEvent", function(self, event)
    if event == "UPDATE_MOUSEOVER_UNIT" then
        DoSilentInspect("mouseover")
    elseif event == "PLAYER_TARGET_CHANGED" then
        DoSilentInspect("target")
        -- Refresh target frame UI if we target someone we already know
        if TargetFrame and TargetFrame:IsVisible() and SmartGear.UpdateTargetFrameGS then
            SmartGear:UpdateTargetFrameGS()
        end
    elseif event == "INSPECT_TALENT_READY" then
        if currentInspectUnit and UnitGUID(currentInspectUnit) == currentInspectGUID then
            local score = CalculateGS(currentInspectUnit)
            if score > 0 then
                SmartGear.GSCache[currentInspectGUID] = score
                
                -- Force redraw tooltips if hovering
                local _, ttUnit = GameTooltip:GetUnit()
                if ttUnit and UnitGUID(ttUnit) == currentInspectGUID then
                    -- A hack to force the tooltip to redraw the GS
                    GameTooltip:SetUnit(ttUnit)
                end
                
                -- Force redraw Target frame UI if targeting them
                if UnitIsUnit("target", currentInspectUnit) and SmartGear.UpdateTargetFrameGS then
                    SmartGear:UpdateTargetFrameGS()
                end
            end
        end
        ClearInspectPlayer()
        currentInspectUnit = nil
        currentInspectGUID = nil
    end
end)

function SmartGear:GetUnitGearScore(unit)
    if not unit or not UnitIsPlayer(unit) then return 0 end
    if UnitIsUnit(unit, "player") then
        return CalculateGS("player")
    end
    
    local guid = UnitGUID(unit)
    if guid and self.GSCache[guid] then
        return self.GSCache[guid]
    end
    
    -- Attempt an immediate calculate just in case the client already has it somehow
    local immediate = CalculateGS(unit)
    if immediate > 0 and guid then
        self.GSCache[guid] = immediate
        return immediate
    end
    
    -- If we don't have it, trigger an inspect request
    DoSilentInspect(unit)
    return 0
end
