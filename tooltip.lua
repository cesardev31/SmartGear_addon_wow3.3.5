------------------------------------------------------------------------
-- SmartGear · tooltip.lua
-- GameTooltip hook: shows item level, upgrade/downgrade info, and
-- gem / enchant warnings when hovering items.
-- Compatible with WoW 3.3.5a (Interface 30300).
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Colour helpers
------------------------------------------------------------------------
local COLOR_GREEN  = "|cff00ff00"
local COLOR_RED    = "|cffff4444"
local COLOR_YELLOW = "|cffffff00"
local COLOR_GREY   = "|cff888888"
local COLOR_CYAN   = "|cff00ccff"
local COLOR_CLOSE  = "|r"

------------------------------------------------------------------------
-- AddScoreLine(tooltip, label, value, colour)
-- Appends a nicely formatted line to the tooltip.
------------------------------------------------------------------------
local function AddLine(tooltip, text)
    tooltip:AddLine(text)
    tooltip:Show()   -- recalculate height
end

------------------------------------------------------------------------
-- OnTooltipSetItem  – the main hook
------------------------------------------------------------------------
local function OnTooltipSetItem(tooltip)
    -- Grab the item link from the tooltip
    local _, itemLink = tooltip:GetItem()
    if not itemLink then return end

    -- Avoid adding lines more than once per tooltip display
    if tooltip.smartGearDone then return end
    tooltip.smartGearDone = true

    --------------------------------------------------------------------
    -- 1.  Item Level
    --------------------------------------------------------------------
    local iLevel = SmartGear:GetItemLevel(itemLink)
    if iLevel and iLevel > 0 then
        AddLine(tooltip, COLOR_CYAN .. SmartGear_L["ITEM_LEVEL"] .. ": " .. iLevel .. COLOR_CLOSE)
    end

    --------------------------------------------------------------------
    -- 2.  Score of hovered item
    --------------------------------------------------------------------
    local hoveredScore = SmartGear:ScoreItem(itemLink)

    --------------------------------------------------------------------
    -- 3.  Find which slot this item belongs to
    --------------------------------------------------------------------
    local slotID = SmartGear:GetEquipSlot(itemLink)
    if not slotID then
        -- Can't determine slot (e.g. consumable, bag, quest item)
        if hoveredScore > 0 then
            AddLine(tooltip, COLOR_GREY .. "SmartGear " .. SmartGear_L["SCORE"] .. ": " ..
                    math.floor(hoveredScore + 0.5) .. COLOR_CLOSE)
        end
        return
    end

    --------------------------------------------------------------------
    -- 4.  Handle ring / trinket dual-slot comparison
    --     Pick the equipped item with the lowest score so the
    --     comparison is against the "weakest" of the pair.
    --------------------------------------------------------------------
    local equippedLink
    if slotID == 11 then  -- finger
        local r1 = GetInventoryItemLink("player", 11)
        local r2 = GetInventoryItemLink("player", 12)
        if r1 and r2 then
            equippedLink = (SmartGear:ScoreItem(r1) <= SmartGear:ScoreItem(r2)) and r1 or r2
        else
            equippedLink = r1 or r2
        end
    elseif slotID == 13 then  -- trinket
        local t1 = GetInventoryItemLink("player", 13)
        local t2 = GetInventoryItemLink("player", 14)
        if t1 and t2 then
            equippedLink = (SmartGear:ScoreItem(t1) <= SmartGear:ScoreItem(t2)) and t1 or t2
        else
            equippedLink = t1 or t2
        end
    else
        equippedLink = GetInventoryItemLink("player", slotID)
    end

    --------------------------------------------------------------------
    -- 5.  Comparison
    --------------------------------------------------------------------
    local equippedScore = SmartGear:ScoreItem(equippedLink)  -- 0 if nil

    AddLine(tooltip, " ")  -- blank spacer

    -- Hovered item score
    AddLine(tooltip, COLOR_CYAN .. "SmartGear " .. SmartGear_L["SCORE"] .. ": " ..
            math.floor(hoveredScore + 0.5) .. COLOR_CLOSE)

    if equippedLink then
        local diff    = hoveredScore - equippedScore
        local absDiff = math.floor(math.abs(diff) + 0.5)

        if diff > 0.5 then
            -- Upgrade ▲
            AddLine(tooltip, COLOR_GREEN .. SmartGear_L["UPGRADE"] .. " +" ..
                    absDiff .. COLOR_CLOSE)
        elseif diff < -0.5 then
            -- Downgrade ▼
            AddLine(tooltip, COLOR_RED .. SmartGear_L["DOWNGRADE"] .. " -" ..
                    absDiff .. COLOR_CLOSE)
        else
            AddLine(tooltip, COLOR_GREY .. SmartGear_L["SAME_SCORE"] .. COLOR_CLOSE)
        end

        -- Equipped score for reference
        AddLine(tooltip, COLOR_GREY .. SmartGear_L["EQUIPPED_SCORE"] .. ": " ..
                math.floor(equippedScore + 0.5) .. COLOR_CLOSE)
    else
        AddLine(tooltip, COLOR_YELLOW .. SmartGear_L["NO_EQUIPPED"] .. COLOR_CLOSE)
    end

    --------------------------------------------------------------------
    -- 6.  Gem / Enchant warnings for the EQUIPPED item in that slot
    --------------------------------------------------------------------
    if equippedLink and SmartGear.gearWarnings then
        local warns = SmartGear.gearWarnings[slotID]
        if warns then
            for _, w in ipairs(warns) do
                AddLine(tooltip, COLOR_YELLOW .. w .. COLOR_CLOSE)
            end
        end
    end
end

------------------------------------------------------------------------
-- Hook installation
-- We reset the "done" flag every time a new tooltip is shown so the
-- info is freshly computed each hover.
------------------------------------------------------------------------
GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)

GameTooltip:HookScript("OnTooltipCleared", function(self)
    self.smartGearDone = nil
end)

------------------------------------------------------------------------
-- Also hook the shopping comparison tooltips (Shift-hover)
------------------------------------------------------------------------
if ShoppingTooltip1 then
    ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    ShoppingTooltip1:HookScript("OnTooltipCleared", function(self)
        self.smartGearDone = nil
    end)
end
if ShoppingTooltip2 then
    ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem)
    ShoppingTooltip2:HookScript("OnTooltipCleared", function(self)
        self.smartGearDone = nil
    end)
end
