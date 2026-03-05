------------------------------------------------------------------------
-- SmartGear · locales.lua
-- Localization for English and Spanish clients.
------------------------------------------------------------------------

local addonName, addon = ...
local L = {}
addon.L = L

local locale = GetLocale()

if locale == "esES" or locale == "esMX" then
    L["SCORE"] = "Puntuación"
    L["AVG_ILVL"] = "Nivel de Objeto Medio"
    L["ITEM_LEVEL"] = "Nivel de Objeto"
    L["UPGRADE"] = "\226\150\178 Mejora"
    L["DOWNGRADE"] = "\226\150\188 Empeora"
    L["SAME_SCORE"] = "= Misma puntuación que equipado"
    L["EQUIPPED_SCORE"] = "Puntuación Equipado"
    L["NO_EQUIPPED"] = "No hay objeto equipado en esta ranura"
    L["MISSING_GEM"] = "\226\154\160 Falta gema"
    L["MISSING_ENCHANT"] = "\226\154\160 Falta encantamiento"
    L["UNKNOWN"] = "Desconocido"
    
    L["CMD_RESCAN"] = "Equipamiento reescaneado."
    L["CMD_SPEC"] = "Especialización detectada:"
    L["CMD_WARN_SLOT"] = "Ranura"
    L["CMD_NO_WARN"] = "No se han detectado gemas o encantamientos faltantes."
    L["CMD_HELP"] = "Comandos: /sg scan | /sg spec | /sg warnings"
    
    L["SOCKET_PATTERNS"] = {
        "Ranura roja",
        "Ranura azul",
        "Ranura amarilla",
        "Ranura meta",
        "Ranura prismática",
    }
    L["ENCHANT_PATTERNS"] = {
        "^Encantar",
        "Encantado:",
        "^%+%d+",
    }
else
    -- Default English
    L["SCORE"] = "Score"
    L["AVG_ILVL"] = "Avg iLvl"
    L["ITEM_LEVEL"] = "Item Level"
    L["UPGRADE"] = "\226\150\178 Upgrade"
    L["DOWNGRADE"] = "\226\150\188 Downgrade"
    L["SAME_SCORE"] = "= Same score as equipped"
    L["EQUIPPED_SCORE"] = "Equipped Score"
    L["NO_EQUIPPED"] = "No item equipped in this slot"
    L["MISSING_GEM"] = "\226\154\160 Missing gem"
    L["MISSING_ENCHANT"] = "\226\154\160 Missing enchant"
    L["UNKNOWN"] = "Unknown"
    
    L["CMD_RESCAN"] = "Gear rescanned."
    L["CMD_SPEC"] = "Detected spec:"
    L["CMD_WARN_SLOT"] = "Slot"
    L["CMD_NO_WARN"] = "No missing gems or enchants detected."
    L["CMD_HELP"] = "Commands: /sg scan | /sg spec | /sg warnings"
    
    L["SOCKET_PATTERNS"] = {
        "Red Socket",
        "Blue Socket",
        "Yellow Socket",
        "Meta Socket",
        "Prismatic Socket",
    }
    L["ENCHANT_PATTERNS"] = {
        "^Enchant",
        "Enchanted:",
        "^%+%d+",
    }
end

-- Globalize for easy access in other files
SmartGear_L = L
