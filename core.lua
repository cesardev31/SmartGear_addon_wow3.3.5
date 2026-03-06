------------------------------------------------------------------------
-- SmartGear · core.lua
-- Global namespace, event dispatcher and utility helpers.
------------------------------------------------------------------------

-- Addon-wide namespace  ------------------------------------------------
SmartGear = SmartGear or {}
SmartGear.version = "3.0"

------------------------------------------------------------------------
-- Utility: colored print
------------------------------------------------------------------------
function SmartGear:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ccff[SmartGear]|r " .. tostring(msg))
end

------------------------------------------------------------------------
-- Event frame – central event dispatcher
------------------------------------------------------------------------
local eventFrame = CreateFrame("Frame", "SmartGearEventFrame", UIParent)
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
eventFrame:RegisterEvent("UPDATE_INVENTORY_ALERTS") -- Durability changes

eventFrame:SetScript("OnEvent", function(self, event, ...)
    -- On login / reload: detect spec, scan gear and refresh UI
    if event == "PLAYER_ENTERING_WORLD" then
        SmartGear:DetectSpec()
        SmartGear:ScanGear()
        SmartGear:UpdatePanel()
        SmartGear:UpdateSlotOverlays()
        SmartGear:Print("v" .. SmartGear.version .. " loaded. " .. SmartGear.L["CMD_SPEC"] .. " " .. (SmartGear.specName or SmartGear.L["UNKNOWN"]))

    -- When a piece of gear changes: rescan and refresh UI
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        SmartGear:ScanGear()
        SmartGear:UpdatePanel()
        SmartGear:UpdateSlotOverlays()
        
    -- Durability update
    elseif event == "UPDATE_INVENTORY_ALERTS" then
        SmartGear:UpdateSlotOverlays()
    end
end)

------------------------------------------------------------------------
-- Slot map: inventory slot IDs used by the API
------------------------------------------------------------------------
SmartGear.SLOT_IDS = {
    INVSLOT_HEAD        = 1,
    INVSLOT_NECK        = 2,
    INVSLOT_SHOULDER    = 3,
    INVSLOT_BACK        = 15,
    INVSLOT_CHEST       = 5,
    INVSLOT_WRIST       = 9,
    INVSLOT_HANDS       = 10,
    INVSLOT_WAIST       = 6,
    INVSLOT_LEGS        = 7,
    INVSLOT_FEET        = 8,
    INVSLOT_FINGER0     = 11,
    INVSLOT_FINGER1     = 12,
    INVSLOT_TRINKET0    = 13,
    INVSLOT_TRINKET1    = 14,
    INVSLOT_MAINHAND    = 16,
    INVSLOT_OFFHAND     = 17,
    INVSLOT_RANGED      = 18,
}

------------------------------------------------------------------------
-- Reverse lookup: inv-slot name → equipment slot string
-- Used to figure out which equipped slot an item would go into.
------------------------------------------------------------------------
SmartGear.EQUIP_LOC_TO_SLOT = {
    INVTYPE_HEAD        = 1,
    INVTYPE_NECK        = 2,
    INVTYPE_SHOULDER    = 3,
    INVTYPE_CLOAK       = 15,
    INVTYPE_BODY        = 4,
    INVTYPE_CHEST       = 5,
    INVTYPE_ROBE        = 5,
    INVTYPE_WRIST       = 9,
    INVTYPE_HAND        = 10,
    INVTYPE_WAIST       = 6,
    INVTYPE_LEGS        = 7,
    INVTYPE_FEET        = 8,
    INVTYPE_FINGER      = 11,  -- first ring slot
    INVTYPE_TRINKET     = 13,  -- first trinket slot
    INVTYPE_WEAPON      = 16,
    INVTYPE_2HWEAPON    = 16,
    INVTYPE_WEAPONMAINHAND = 16,
    INVTYPE_WEAPONOFFHAND  = 17,
    INVTYPE_HOLDABLE    = 17,
    INVTYPE_SHIELD      = 17,
    INVTYPE_RANGED      = 18,
    INVTYPE_RANGEDRIGHT = 18,
    INVTYPE_THROWN       = 18,
    INVTYPE_RELIC        = 18,
}
