------------------------------------------------------------------------
-- SmartGear · locales.lua
-- Contains multi-language strings and translation logic.
------------------------------------------------------------------------

local SmartGear = _G.SmartGear
local L = {}
SmartGear.L = L

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
    L["GS_SCORE"] = "GearScore"
    
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
    
    -- Recommendations UI
    L["REC_TITLE"] = "SmartGear: Recomendaciones"
    L["REC_CLICK_DESC"] = "|cff00ff00Click para Ver Requisitos y Recomendaciones|r"
    L["REC_DUNGEONS"] = "Mazmorras y Bandas Sugeridas:"
    L["REC_STATS"] = "Recomendaciones para tu Clase/Talo:"
    L["REC_GEMS"] = "Gemas Óptimas:"
    L["REC_ENCHANTS"] = "Encantamientos Principales:"
    L["REC_UNKNOWN_SPEC"] = "Especialización Desconocida"
    
    L["TIER_NORMAL"] = "Mazmorras Normales (Lvl 70-80)"
    L["TIER_HEROIC"] = "Mazmorras Heroicas (Fase 1)"
    L["TIER_T7"] = "Naxxramas, OS, EoE (Tier 7)"
    L["TIER_T8"] = "Ulduar, PdC Normal (Tier 8)"
    L["TIER_T9"] = "PdC Heroico, Onyxia, Forjas/Foso"
    L["TIER_ICC10"] = "ICC 10 Normal / ICC 5 Heroicas (Tier 10)"
    L["TIER_ICC25"] = "ICC 25 Normal / ICC 10 Heroico"
    L["TIER_ICC_HC"] = "ICC 25 Heroico / Sagrario Rubí (Tier 10 HC)"
    
    L["GEM_ARP_STR"] = "Rojo: Penetr. Armadura o Fuerza | Meta: Crítico/Daño"
    L["GEM_STAM_DODGE"] = "Azul: Aguante | Rojo: Esquivar/Parada | Meta: Aguante"
    L["GEM_STAM_DEF"] = "Azul: Aguante | Amarillo: Defensa/Golpe | Meta: Aguante"
    L["GEM_INT_SP"] = "Amarillo: Intelecto | Rojo: Poder con Hechizos"
    L["GEM_STR_CRT"] = "Rojo: Fuerza | Amarillo: Crítico o Fuerza"
    L["GEM_AGI_AP"] = "Rojo: Agilidad o Poder de Ataque | Meta: Crítico/Daño"
    L["GEM_ARP_AGI"] = "Rojo: Penetr. Armadura o Agilidad | Meta: Crítico/Daño"
    L["GEM_AGI_CRT"] = "Rojo: Agilidad | Amarillo: Crítico | Meta: Crítico/Daño"
    L["GEM_AP_HASTE"] = "Rojo: Poder Ataque | Amarillo: Celeridad/PA"
    L["GEM_SP_INT"] = "Rojo: Poder con Hechizos | Amarillo: Intelecto"
    L["GEM_SP_SPIRIT"] = "Rojo: Poder con Hechizos | Azul: Espíritu"
    L["GEM_SP_HASTE"] = "Rojo: Poder con Hechizos | Amarillo: Celeridad/PH"
    L["GEM_STAM_PARRY"] = "Azul: Aguante | Rojo: Parada/Esquivar | Meta: Aguante"
    L["GEM_STR_ARP"] = "Rojo: Fuerza o Penetr. Armadura"
    L["GEM_STR_HASTE"] = "Rojo: Fuerza | Amarillo: Fuerza/Celeridad"
    L["GEM_SP_MP5"] = "Rojo: Poder con Hechizos | Amarillo/Azul: MP5"
    L["GEM_SP_CRT"] = "Rojo: Poder con Hechizos | Amarillo: Crítico o PH"
    
    L["ENCH_MELEE_DPS"] = "Rabiar (Arma), +10 Estadísticas (Pecho), +50 PA (Capa/Brazales), +44 PA (Guantes)"
    L["ENCH_TANK"] = "Amparo Hojas/Drenaje (Arma), +275 Vida (Pecho), Aguante (Escudo/Botas)"
    L["ENCH_HEALER"] = "Poder Hech./Intelecto (Arma), +10 Estadísticas (Pecho), MP5 (Capa/Pecho)"
    L["ENCH_RANGED_AGI"] = "Precisión (Arma Rango), +10 Estadísticas (Pecho), +20 Agilidad (Guantes)"
    L["ENCH_RANGED_ARP"] = "Precisión (Arma Rango), +10 Estadísticas (Pecho), Agilidad/AP (Capa)"
    L["ENCH_CASTER"] = "Magia Negra/Poder Hech. (Arma), +10 Estadísticas (Pecho), Celeridad/PH (Capa)"
    L["ENCH_FERAL"] = "Mangosta/Rabiar (Arma), +10 Estadísticas (Pecho), +20 Agilidad/PA (Guantes)"

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
    L["GS_SCORE"] = "GearScore"
    
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
    
    -- Recommendations UI
    L["REC_TITLE"] = "SmartGear: Recommendations"
    L["REC_CLICK_DESC"] = "|cff00ff00Click to view Requirements & Recommendations|r"
    L["REC_DUNGEONS"] = "Suggested Dungeons & Raids:"
    L["REC_STATS"] = "Class & Spec Recommendations:"
    L["REC_GEMS"] = "Optimal Gems:"
    L["REC_ENCHANTS"] = "Core Enchants:"
    L["REC_UNKNOWN_SPEC"] = "Unknown Specialization"
    
    L["TIER_NORMAL"] = "Normal Dungeons (Lvl 70-80)"
    L["TIER_HEROIC"] = "Heroic Dungeons (Phase 1)"
    L["TIER_T7"] = "Naxxramas, OS, EoE (Tier 7)"
    L["TIER_T8"] = "Ulduar, ToC Normal (Tier 8)"
    L["TIER_T9"] = "ToC Heroic, Onyxia, Forge/Pit"
    L["TIER_ICC10"] = "ICC 10 Normal / ICC 5 Heroics (Tier 10)"
    L["TIER_ICC25"] = "ICC 25 Normal / ICC 10 Heroic"
    L["TIER_ICC_HC"] = "ICC 25 Heroic / Ruby Sanctum (Tier 10 HC)"
    
    L["GEM_ARP_STR"] = "Red: Armor Pen. or Strength | Meta: Crit/Dmg"
    L["GEM_STAM_DODGE"] = "Blue: Stamina | Red: Dodge/Parry | Meta: Stamina"
    L["GEM_STAM_DEF"] = "Blue: Stamina | Yellow: Defense/Hit | Meta: Stamina"
    L["GEM_INT_SP"] = "Yellow: Intellect | Red: Spell Power"
    L["GEM_STR_CRT"] = "Red: Strength | Yellow: Crit/Strength"
    L["GEM_AGI_AP"] = "Red: Agility or Attack Power | Meta: Crit/Dmg"
    L["GEM_ARP_AGI"] = "Red: Armor Pen. or Agility | Meta: Crit/Dmg"
    L["GEM_AGI_CRT"] = "Red: Agility | Yellow: Crit | Meta: Crit/Dmg"
    L["GEM_AP_HASTE"] = "Red: Attack Power | Yellow: Haste/Attack Power"
    L["GEM_SP_INT"] = "Red: Spell Power | Yellow: Intellect"
    L["GEM_SP_SPIRIT"] = "Red: Spell Power | Blue: Spirit"
    L["GEM_SP_HASTE"] = "Red: Spell Power | Yellow: Haste/SP"
    L["GEM_STAM_PARRY"] = "Blue: Stamina | Red: Parry/Dodge | Meta: Stamina"
    L["GEM_STR_ARP"] = "Red: Strength or Armor Pen."
    L["GEM_STR_HASTE"] = "Red: Strength | Yellow: Strength/Haste"
    L["GEM_SP_MP5"] = "Red: Spell Power | Yellow/Blue: MP5"
    L["GEM_SP_CRT"] = "Red: Spell Power | Yellow: Crit/SP"
    
    L["ENCH_MELEE_DPS"] = "Berserking (Wep), +10 Stats (Chest), +50 AP (Cloak/Wrist), +44 AP (Gloves)"
    L["ENCH_TANK"] = "Blade Ward/Blood Drain (Wep), +275 HP/Def (Chest), Stamina (Shield/Boots)"
    L["ENCH_HEALER"] = "Spell Power/Int (Wep), +10 Stats (Chest), MP5 (Cloak/Chest)"
    L["ENCH_RANGED_AGI"] = "Accuracy (Ranged), +10 Stats (Chest), +20 Agility (Gloves)"
    L["ENCH_RANGED_ARP"] = "Accuracy (Ranged), +10 Stats (Chest), Agility/AP (Cloak)"
    L["ENCH_CASTER"] = "Black Magic/Spell Power (Wep), +10 Stats (Chest), Haste/SP (Cloak)"
    L["ENCH_FERAL"] = "Mongoose/Berserking (Wep), +10 Stats (Chest), +20 Agi/AP (Gloves)"
end
