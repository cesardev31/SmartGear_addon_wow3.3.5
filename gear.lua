------------------------------------------------------------------------
-- SmartGear · gear.lua
-- Item stat extraction, score calculation, and equipped-gear scanning.
-- Compatible with WoW 3.3.5a (Interface 30300).
------------------------------------------------------------------------

------------------------------------------------------------------------
-- GetItemStatsTable(itemLink) → { statName = value, … }
-- Wraps the native GetItemStats() and translates its weird key tokens
-- into the readable names defined in SmartGear.STAT_KEYS.
------------------------------------------------------------------------
function SmartGear:GetItemStatsTable(itemLink)
    if not itemLink then return {} end

    local raw = {}
    GetItemStats(itemLink, raw)           -- fills raw with ITEM_MOD_* keys

    local stats = {}
    for token, value in pairs(raw) do
        local nice = self.STAT_KEYS[token]
        if nice then
            stats[nice] = (stats[nice] or 0) + value
        end
    end
    return stats
end

------------------------------------------------------------------------
-- ScoreItem(itemLink) → number
-- Multiplies every stat on the item by the current spec's weight and
-- returns the sum.
------------------------------------------------------------------------
function SmartGear:ScoreItem(itemLink)
    if not itemLink then return 0 end

    local stats   = self:GetItemStatsTable(itemLink)
    local weights = self:GetWeights()
    local score   = 0

    for stat, value in pairs(stats) do
        local w = weights[stat] or 0
        score = score + (value * w)
    end
    return score
end

------------------------------------------------------------------------
-- GetItemLevel(itemLink) → number or 0
-- Uses GetItemInfo() to pull the item level.
------------------------------------------------------------------------
function SmartGear:GetItemLevel(itemLink)
    if not itemLink then return 0 end
    local _, _, _, iLevel = GetItemInfo(itemLink)
    return iLevel or 0
end

------------------------------------------------------------------------
-- GetEquipSlot(itemLink) → slotID or nil
-- Returns the inventory slot ID an item would occupy, using the
-- EQUIP_LOC_TO_SLOT map defined in core.lua.
------------------------------------------------------------------------
function SmartGear:GetEquipSlot(itemLink)
    if not itemLink then return nil end
    local _, _, _, _, _, _, _, _, equipLoc = GetItemInfo(itemLink)
    if not equipLoc or equipLoc == "" then return nil end
    return self.EQUIP_LOC_TO_SLOT[equipLoc]
end

------------------------------------------------------------------------
-- ScanGear()
-- Iterates every equipped slot, calculates per-slot score & ilvl,
-- and stores totals in SmartGear.totalScore / SmartGear.avgItemLevel.
-- Also checks for missing gems and enchants.
------------------------------------------------------------------------
function SmartGear:ScanGear()
    local totalScore  = 0
    local totalILevel = 0
    local slotCount   = 0

    self.gearWarnings = self.gearWarnings or {}
    wipe(self.gearWarnings)

    for name, slotID in pairs(self.SLOT_IDS) do
        local link = GetInventoryItemLink("player", slotID)
        if link then
            totalScore  = totalScore  + self:ScoreItem(link)
            totalILevel = totalILevel + self:GetItemLevel(link)
            slotCount   = slotCount   + 1

            -- Check gems & enchants for this slot
            self:CheckGemAndEnchant(slotID, link)
        end
    end

    self.totalScore   = math.floor(totalScore + 0.5)
    self.avgItemLevel = (slotCount > 0) and math.floor(totalILevel / slotCount + 0.5) or 0
end

------------------------------------------------------------------------
-- CheckGemAndEnchant(slotID, itemLink)
-- Inspects the tooltip text for the given equipped item to detect
-- missing gem sockets and enchantments.  Results are stored in
-- SmartGear.gearWarnings[slotID].
------------------------------------------------------------------------

-- Socket colour strings that appear in un-gemmed sockets
-- (Loaded from locales.lua)

function SmartGear:CheckGemAndEnchant(slotID, itemLink)
    if not itemLink then return end

    -- Use a hidden scanning tooltip so we don't pollute the visible one
    local tip = self:GetScanTooltip()
    tip:ClearLines()
    tip:SetInventoryItem("player", slotID)

    local numLines    = tip:NumLines()
    local missingGem  = false
    local hasEnchant  = false

    for i = 1, numLines do
        local left = _G[tip:GetName() .. "TextLeft" .. i]
        if left then
            local text = left:GetText() or ""

            -- Empty socket?
            for _, pat in ipairs(SmartGear_L["SOCKET_PATTERNS"]) do
                if text:find(pat) then
                    missingGem = true
                end
            end

            -- Enchant line usually starts with pattern or is on line 2
            for _, pat in ipairs(SmartGear_L["ENCHANT_PATTERNS"]) do
                if text:find(pat) then
                    hasEnchant = true
                end
            end
        end
    end

    -- Heuristic: weapons, chest, legs, head, shoulders, gloves, boots,
    -- bracers, cloak can be enchanted.  Skip neck/ring/trinket.
    local enchantableSlots = {
        [1]=true, [3]=true, [5]=true, [6]=true, [7]=true, [8]=true,
        [9]=true, [10]=true, [15]=true, [16]=true, [17]=true, [18]=true,
    }

    local warnings = {}
    if missingGem then
        table.insert(warnings, SmartGear_L["MISSING_GEM"])
    end
    if enchantableSlots[slotID] and not hasEnchant then
        table.insert(warnings, SmartGear_L["MISSING_ENCHANT"])
    end

    if #warnings > 0 then
        self.gearWarnings[slotID] = warnings
    end
end

------------------------------------------------------------------------
-- GetScanTooltip() → tooltip frame (created lazily)
-- Hidden tooltip used exclusively for text scanning.
------------------------------------------------------------------------
function SmartGear:GetScanTooltip()
    if not self.scanTooltip then
        local tip = CreateFrame("GameTooltip", "SmartGearScanTooltip", nil, "GameTooltipTemplate")
        tip:SetOwner(UIParent, "ANCHOR_NONE")
        self.scanTooltip = tip
    end
    return self.scanTooltip
end
