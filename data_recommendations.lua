------------------------------------------------------------------------
-- SmartGear · data_recommendations.lua
-- Contains arrays for Instance Tiers, Gems, and Enchant Recommendations
------------------------------------------------------------------------

local SmartGear = _G.SmartGear
local L = SmartGear.L

SmartGear.InstanceTiers = {
    { min = 0,    max = 2499, title = L["TIER_NORMAL"] },
    { min = 2500, max = 3199, title = L["TIER_HEROIC"] },
    { min = 3200, max = 3899, title = L["TIER_T7"] },
    { min = 3900, max = 4599, title = L["TIER_T8"] },
    { min = 4600, max = 5099, title = L["TIER_T9"] },
    { min = 5100, max = 5499, title = L["TIER_ICC10"] },
    { min = 5500, max = 5899, title = L["TIER_ICC25"] },
    { min = 5900, max = 9999, title = L["TIER_ICC_HC"] },
}

-- Note: The spec keys match the output from GetTalentTabInfo in talents.lua
SmartGear.SpecRecommendations = {
    ["WARRIOR"] = {
        ["Armas"] = { gems = L["GEM_ARP_STR"], enchants = L["ENCH_MELEE_DPS"] },
        ["Furia"] = { gems = L["GEM_ARP_STR"], enchants = L["ENCH_MELEE_DPS"] },
        ["Protección"] = { gems = L["GEM_STAM_DODGE"], enchants = L["ENCH_TANK"] },
        ["Arms"] = { gems = L["GEM_ARP_STR"], enchants = L["ENCH_MELEE_DPS"] },
        ["Fury"] = { gems = L["GEM_ARP_STR"], enchants = L["ENCH_MELEE_DPS"] },
        ["Protection"] = { gems = L["GEM_STAM_DODGE"], enchants = L["ENCH_TANK"] },
    },
    ["PALADIN"] = {
        ["Sagrado"] = { gems = L["GEM_INT_SP"], enchants = L["ENCH_HEALER"] },
        ["Protección"] = { gems = L["GEM_STAM_DEF"], enchants = L["ENCH_TANK"] },
        ["Reprensión"] = { gems = L["GEM_STR_CRT"], enchants = L["ENCH_MELEE_DPS"] },
        ["Holy"] = { gems = L["GEM_INT_SP"], enchants = L["ENCH_HEALER"] },
        ["Retribution"] = { gems = L["GEM_STR_CRT"], enchants = L["ENCH_MELEE_DPS"] },
    },
    ["HUNTER"] = {
        ["Bestias"] = { gems = L["GEM_AGI_AP"], enchants = L["ENCH_RANGED_AGI"] },
        ["Puntería"] = { gems = L["GEM_ARP_AGI"], enchants = L["ENCH_RANGED_ARP"] },
        ["Supervivencia"] = { gems = L["GEM_AGI_CRT"], enchants = L["ENCH_RANGED_AGI"] },
        ["Beast Mastery"] = { gems = L["GEM_AGI_AP"], enchants = L["ENCH_RANGED_AGI"] },
        ["Marksmanship"] = { gems = L["GEM_ARP_AGI"], enchants = L["ENCH_RANGED_ARP"] },
        ["Survival"] = { gems = L["GEM_AGI_CRT"], enchants = L["ENCH_RANGED_AGI"] },
    },
    ["ROGUE"] = {
        ["Asesinato"] = { gems = L["GEM_AP_HASTE"], enchants = L["ENCH_MELEE_DPS"] },
        ["Combate"] = { gems = L["GEM_ARP_AGI"], enchants = L["ENCH_MELEE_DPS"] },
        ["Sutileza"] = { gems = L["GEM_AGI_AP"], enchants = L["ENCH_MELEE_DPS"] },
        ["Assassination"] = { gems = L["GEM_AP_HASTE"], enchants = L["ENCH_MELEE_DPS"] },
        ["Combat"] = { gems = L["GEM_ARP_AGI"], enchants = L["ENCH_MELEE_DPS"] },
        ["Subtlety"] = { gems = L["GEM_AGI_AP"], enchants = L["ENCH_MELEE_DPS"] },
    },
    ["PRIEST"] = {
        ["Disciplina"] = { gems = L["GEM_SP_INT"], enchants = L["ENCH_HEALER"] },
        ["Sagrado"] = { gems = L["GEM_SP_SPIRIT"], enchants = L["ENCH_HEALER"] },
        ["Sombra"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Discipline"] = { gems = L["GEM_SP_INT"], enchants = L["ENCH_HEALER"] },
        ["Holy"] = { gems = L["GEM_SP_SPIRIT"], enchants = L["ENCH_HEALER"] },
        ["Shadow"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
    },
    ["DEATHKNIGHT"] = {
        ["Sangre"] = { gems = L["GEM_STAM_PARRY"], enchants = L["ENCH_TANK"] },
        ["Escarcha"] = { gems = L["GEM_STR_ARP"], enchants = L["ENCH_MELEE_DPS"] },
        ["Profano"] = { gems = L["GEM_STR_HASTE"], enchants = L["ENCH_MELEE_DPS"] },
        ["Blood"] = { gems = L["GEM_STAM_PARRY"], enchants = L["ENCH_TANK"] },
        ["Frost"] = { gems = L["GEM_STR_ARP"], enchants = L["ENCH_MELEE_DPS"] },
        ["Unholy"] = { gems = L["GEM_STR_HASTE"], enchants = L["ENCH_MELEE_DPS"] },
    },
    ["SHAMAN"] = {
        ["Elemental"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Mejora"] = { gems = L["GEM_AP_HASTE"], enchants = L["ENCH_MELEE_DPS"] },
        ["Restauración"] = { gems = L["GEM_SP_MP5"], enchants = L["ENCH_HEALER"] },
        ["Enhancement"] = { gems = L["GEM_AP_HASTE"], enchants = L["ENCH_MELEE_DPS"] },
        ["Restoration"] = { gems = L["GEM_SP_MP5"], enchants = L["ENCH_HEALER"] },
    },
    ["MAGE"] = {
        ["Arcano"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Fuego"] = { gems = L["GEM_SP_CRT"], enchants = L["ENCH_CASTER"] },
        ["Escarcha"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Arcane"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Fire"] = { gems = L["GEM_SP_CRT"], enchants = L["ENCH_CASTER"] },
        ["Frost"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
    },
    ["WARLOCK"] = {
        ["Aflicción"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Demonología"] = { gems = L["GEM_SP_SPIRIT"], enchants = L["ENCH_CASTER"] },
        ["Destrucción"] = { gems = L["GEM_SP_CRT"], enchants = L["ENCH_CASTER"] },
        ["Affliction"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Demonology"] = { gems = L["GEM_SP_SPIRIT"], enchants = L["ENCH_CASTER"] },
        ["Destruction"] = { gems = L["GEM_SP_CRT"], enchants = L["ENCH_CASTER"] },
    },
    ["DRUID"] = {
        ["Equilibrio"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Combate Feral"] = { gems = L["GEM_ARP_AGI"], enchants = L["ENCH_FERAL"] },
        ["Restauración"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_HEALER"] },
        ["Balance"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_CASTER"] },
        ["Feral Combat"] = { gems = L["GEM_ARP_AGI"], enchants = L["ENCH_FERAL"] },
        ["Restoration"] = { gems = L["GEM_SP_HASTE"], enchants = L["ENCH_HEALER"] },
    }
}
