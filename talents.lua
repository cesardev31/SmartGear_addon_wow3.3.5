------------------------------------------------------------------------
-- SmartGear · talents.lua
-- Talent-tree detection and per-spec stat weight tables.
-- Compatible with WoW 3.3.5a (Interface 30300).
------------------------------------------------------------------------

------------------------------------------------------------------------
-- DetectSpec()
-- Iterates the three talent tabs and picks the one with the most
-- points spent.  Stores the result in SmartGear.specIndex (1-3)
-- and SmartGear.specName (localised tree name).
------------------------------------------------------------------------
function SmartGear:DetectSpec()
    local maxPoints = 0
    local specIndex = 1
    local specName  = "Unknown"

    for i = 1, GetNumTalentTabs() do
        local name, _, pointsSpent = GetTalentTabInfo(i)
        if pointsSpent > maxPoints then
            maxPoints = pointsSpent
            specIndex = i
            specName  = name
        end
    end

    self.specIndex = specIndex
    self.specName  = specName
    return specIndex, specName
end

------------------------------------------------------------------------
-- Stat-weight keys  (GetItemStats key → readable name)
------------------------------------------------------------------------
-- The keys returned by GetItemStats() in 3.3.5a use tokens like
-- "ITEM_MOD_CRIT_RATING_SHORT".  We map only the ones we care about.
------------------------------------------------------------------------
SmartGear.STAT_KEYS = {
    ITEM_MOD_SPELL_POWER_SHORT          = "SpellPower",
    ITEM_MOD_HIT_RATING_SHORT           = "Hit",
    ITEM_MOD_HASTE_RATING_SHORT         = "Haste",
    ITEM_MOD_CRIT_RATING_SHORT          = "Crit",
    ITEM_MOD_ATTACK_POWER_SHORT         = "AttackPower",
    ITEM_MOD_STRENGTH_SHORT             = "Strength",
    ITEM_MOD_AGILITY_SHORT              = "Agility",
    ITEM_MOD_STAMINA_SHORT              = "Stamina",
    ITEM_MOD_INTELLECT_SHORT            = "Intellect",
    ITEM_MOD_SPIRIT_SHORT               = "Spirit",
    ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT = "ArmorPen",
    ITEM_MOD_EXPERTISE_RATING_SHORT     = "Expertise",
    ITEM_MOD_DEFENSE_SKILL_RATING_SHORT = "Defense",
    ITEM_MOD_DODGE_RATING_SHORT         = "Dodge",
    ITEM_MOD_PARRY_RATING_SHORT         = "Parry",
    ITEM_MOD_BLOCK_RATING_SHORT         = "Block",
    ITEM_MOD_BLOCK_VALUE_SHORT          = "BlockValue",
    ITEM_MOD_RESILIENCE_RATING_SHORT    = "Resilience",
}

------------------------------------------------------------------------
-- STAT WEIGHTS
-- Table layout:  CLASS → { [specIndex] = { statName = weight, … } }
--
-- Each class has three talent trees, indexed 1-3 in the same order
-- the client returns them via GetTalentTabInfo().
--
-- ★  To add or tweak values simply edit the numbers below.
-- ★  Any stat not listed defaults to 0.
------------------------------------------------------------------------

SmartGear.STAT_WEIGHTS = {}

-- ======================================================================
--  WARRIOR  (1 Arms · 2 Fury · 3 Protection)
-- ======================================================================
SmartGear.STAT_WEIGHTS["WARRIOR"] = {
    [1] = { -- Arms
        Strength    = 1.0,
        AttackPower = 0.5,
        ArmorPen    = 0.9,
        Crit        = 0.7,
        Hit         = 0.8,
        Expertise   = 0.75,
        Haste       = 0.5,
        Agility     = 0.4,
    },
    [2] = { -- Fury
        Strength    = 1.0,
        AttackPower = 0.5,
        ArmorPen    = 0.8,
        Crit        = 0.8,
        Hit         = 0.9,
        Expertise   = 0.75,
        Haste       = 0.6,
        Agility     = 0.4,
    },
    [3] = { -- Protection
        Stamina     = 1.0,
        Defense     = 0.9,
        Dodge       = 0.7,
        Parry       = 0.65,
        Block       = 0.5,
        BlockValue  = 0.4,
        Expertise   = 0.6,
        Hit         = 0.5,
        Strength    = 0.3,
    },
}

-- ======================================================================
--  PALADIN  (1 Holy · 2 Protection · 3 Retribution)
-- ======================================================================
SmartGear.STAT_WEIGHTS["PALADIN"] = {
    [1] = { -- Holy
        SpellPower = 1.0,
        Intellect  = 0.9,
        Crit       = 0.7,
        Haste      = 0.85,
        Spirit     = 0.3,
        Hit        = 0.0,
    },
    [2] = { -- Protection
        Stamina    = 1.0,
        Defense    = 0.9,
        Dodge      = 0.7,
        Parry      = 0.65,
        Block      = 0.5,
        BlockValue = 0.4,
        Expertise  = 0.6,
        Hit        = 0.5,
        Strength   = 0.35,
    },
    [3] = { -- Retribution
        Strength    = 1.0,
        AttackPower = 0.5,
        Crit        = 0.7,
        Hit         = 0.8,
        Expertise   = 0.75,
        Haste       = 0.6,
        ArmorPen    = 0.5,
        Agility     = 0.3,
    },
}

-- ======================================================================
--  HUNTER  (1 Beast Mastery · 2 Marksmanship · 3 Survival)
-- ======================================================================
SmartGear.STAT_WEIGHTS["HUNTER"] = {
    [1] = { -- Beast Mastery
        Agility     = 1.0,
        AttackPower = 0.5,
        Hit         = 0.9,
        Crit        = 0.7,
        ArmorPen    = 0.6,
        Haste       = 0.65,
        Intellect   = 0.2,
    },
    [2] = { -- Marksmanship
        Agility     = 1.0,
        AttackPower = 0.5,
        ArmorPen    = 0.9,
        Hit         = 0.85,
        Crit        = 0.7,
        Haste       = 0.6,
        Intellect   = 0.2,
    },
    [3] = { -- Survival
        Agility     = 1.0,
        AttackPower = 0.5,
        Hit         = 0.9,
        Crit        = 0.75,
        Haste       = 0.6,
        ArmorPen    = 0.5,
        Intellect   = 0.2,
    },
}

-- ======================================================================
--  ROGUE  (1 Assassination · 2 Combat · 3 Subtlety)
-- ======================================================================
SmartGear.STAT_WEIGHTS["ROGUE"] = {
    [1] = { -- Assassination
        Agility     = 1.0,
        AttackPower = 0.5,
        Hit         = 0.9,
        Expertise   = 0.8,
        Crit        = 0.7,
        Haste       = 0.75,
        ArmorPen    = 0.5,
    },
    [2] = { -- Combat
        Agility     = 1.0,
        AttackPower = 0.5,
        ArmorPen    = 0.9,
        Expertise   = 0.85,
        Hit         = 0.8,
        Crit        = 0.65,
        Haste       = 0.7,
    },
    [3] = { -- Subtlety
        Agility     = 1.0,
        AttackPower = 0.5,
        Hit         = 0.85,
        Expertise   = 0.8,
        Crit        = 0.7,
        Haste       = 0.65,
        ArmorPen    = 0.6,
    },
}

-- ======================================================================
--  PRIEST  (1 Discipline · 2 Holy · 3 Shadow)
-- ======================================================================
SmartGear.STAT_WEIGHTS["PRIEST"] = {
    [1] = { -- Discipline
        SpellPower = 1.0,
        Intellect  = 0.9,
        Haste      = 0.8,
        Crit       = 0.7,
        Spirit     = 0.5,
        Hit        = 0.0,
    },
    [2] = { -- Holy
        SpellPower = 1.0,
        Intellect  = 0.9,
        Haste      = 0.85,
        Crit       = 0.6,
        Spirit     = 0.7,
        Hit        = 0.0,
    },
    [3] = { -- Shadow
        SpellPower = 1.0,
        Hit        = 0.9,
        Haste      = 0.85,
        Crit       = 0.65,
        Spirit     = 0.5,
        Intellect  = 0.6,
    },
}

-- ======================================================================
--  DEATH KNIGHT  (1 Blood · 2 Frost · 3 Unholy)
-- ======================================================================
SmartGear.STAT_WEIGHTS["DEATHKNIGHT"] = {
    [1] = { -- Blood (Tank)
        Stamina    = 1.0,
        Defense    = 0.9,
        Dodge      = 0.75,
        Parry      = 0.7,
        Expertise  = 0.6,
        Hit        = 0.5,
        Strength   = 0.4,
    },
    [2] = { -- Frost (DPS)
        Strength    = 1.0,
        AttackPower = 0.5,
        Hit         = 0.9,
        Expertise   = 0.8,
        ArmorPen    = 0.7,
        Crit        = 0.65,
        Haste       = 0.6,
    },
    [3] = { -- Unholy (DPS)
        Strength    = 1.0,
        AttackPower = 0.5,
        Hit         = 0.9,
        Haste       = 0.8,
        Crit        = 0.65,
        Expertise   = 0.7,
        ArmorPen    = 0.5,
    },
}

-- ======================================================================
--  SHAMAN  (1 Elemental · 2 Enhancement · 3 Restoration)
-- ======================================================================
SmartGear.STAT_WEIGHTS["SHAMAN"] = {
    [1] = { -- Elemental
        SpellPower = 1.0,
        Hit        = 0.9,
        Haste      = 0.85,
        Crit       = 0.7,
        Intellect  = 0.6,
    },
    [2] = { -- Enhancement
        Agility     = 1.0,
        AttackPower = 0.5,
        Hit         = 0.9,
        Expertise   = 0.85,
        Crit        = 0.7,
        Haste       = 0.65,
        ArmorPen    = 0.5,
        Strength    = 0.4,
    },
    [3] = { -- Restoration
        SpellPower = 1.0,
        Intellect  = 0.9,
        Haste      = 0.85,
        Crit       = 0.7,
        Spirit     = 0.3,
    },
}

-- ======================================================================
--  MAGE  (1 Arcane · 2 Fire · 3 Frost)
-- ======================================================================
SmartGear.STAT_WEIGHTS["MAGE"] = {
    [1] = { -- Arcane
        SpellPower = 1.0,
        Hit        = 0.9,
        Haste      = 0.8,
        Crit       = 0.6,
        Intellect  = 0.5,
        Spirit     = 0.3,
    },
    [2] = { -- Fire
        SpellPower = 1.0,
        Hit        = 0.9,
        Crit       = 0.85,
        Haste      = 0.7,
        Intellect  = 0.5,
    },
    [3] = { -- Frost
        SpellPower = 1.0,
        Hit        = 0.9,
        Haste      = 0.85,
        Crit       = 0.7,
        Intellect  = 0.5,
    },
}

-- ======================================================================
--  WARLOCK  (1 Affliction · 2 Demonology · 3 Destruction)
-- ======================================================================
SmartGear.STAT_WEIGHTS["WARLOCK"] = {
    [1] = { -- Affliction
        SpellPower = 1.0,
        Hit        = 0.9,
        Haste      = 0.85,
        Crit       = 0.55,
        Spirit     = 0.5,
        Intellect  = 0.45,
    },
    [2] = { -- Demonology
        SpellPower = 1.0,
        Hit        = 0.9,
        Haste      = 0.8,
        Crit       = 0.65,
        Spirit     = 0.4,
        Intellect  = 0.5,
    },
    [3] = { -- Destruction
        SpellPower = 1.0,
        Hit        = 0.9,
        Crit       = 0.8,
        Haste      = 0.75,
        Intellect  = 0.5,
    },
}

-- ======================================================================
--  DRUID  (1 Balance · 2 Feral Combat · 3 Restoration)
-- ======================================================================
SmartGear.STAT_WEIGHTS["DRUID"] = {
    [1] = { -- Balance
        SpellPower = 1.0,
        Hit        = 0.9,
        Haste      = 0.85,
        Crit       = 0.7,
        Spirit     = 0.4,
        Intellect  = 0.55,
    },
    [2] = { -- Feral (Cat DPS / Bear Tank hybrid weights)
        Agility     = 1.0,
        AttackPower = 0.5,
        ArmorPen    = 0.9,
        Crit        = 0.7,
        Hit         = 0.8,
        Expertise   = 0.75,
        Strength    = 0.55,
        Haste       = 0.5,
        Stamina     = 0.3,
    },
    [3] = { -- Restoration
        SpellPower = 1.0,
        Intellect  = 0.9,
        Haste      = 0.85,
        Spirit     = 0.8,
        Crit       = 0.6,
    },
}

------------------------------------------------------------------------
-- GetWeights()  – returns the stat-weight table for the current spec
------------------------------------------------------------------------
function SmartGear:GetWeights()
    local _, englishClass = UnitClass("player")
    local weights = self.STAT_WEIGHTS[englishClass]
    if weights and weights[self.specIndex] then
        return weights[self.specIndex]
    end
    -- Fallback: equal weights so scoring never errors
    return { SpellPower = 1, Hit = 1, Haste = 1, Crit = 1,
             AttackPower = 1, Strength = 1, Agility = 1 }
end
