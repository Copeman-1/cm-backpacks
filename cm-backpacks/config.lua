Config = {}

-- ============================================
-- DEBUG SETTINGS
-- ============================================
-- Debug Mode - Controls all debug output
-- Set to false in production to disable:
-- - Server console debug messages (DebugPrint)
-- - Client F8 console debug messages
-- - Initialization messages (Framework/Inventory detection)
-- - Success/warning messages
Config.Debug = false  -- Set to true for troubleshooting

-- ============================================
-- FRAMEWORK & INVENTORY
-- ============================================
-- Framework Detection (auto-detects, or set manually: 'qb-core', 'qbox', or nil)
Config.Framework = nil -- Leave nil for auto-detection

-- Inventory System (auto-detects, or set manually: 'qb-inventory', 'ox_inventory', 'qs-inventory')
Config.Inventory = nil -- Leave nil for auto-detection

-- Maximum inventory slots (used for backpack detection)
Config.MaxInventorySlots = 41

-- ============================================
-- BACKPACK RESTRICTIONS
-- ============================================
-- Backpack Carry Restrictions
Config.RestrictMultipleBackpacks = true
Config.MaxAllowedBackpacks = 2

-- ============================================
-- DURATION SETTINGS
-- ============================================
-- Duration Settings (in milliseconds)
Config.Duration = {
    Open = 1000
}

-- ============================================
-- BACKPACK CONFIGURATIONS
-- ============================================
Config.Backpacks = {
    -- Small Backpack
    {
        item = 'backpack1',
        label = 'Small Backpack',
        slots = 20,
        weight = 200000, -- ox_inventory uses weight
        size = 200000,   -- qb-inventory/qs-inventory uses size
    },
    
    -- Medium Backpack
    {
        item = 'backpack2',
        label = 'Medium Backpack',
        slots = 30,
        weight = 300000,
        size = 300000,
        blacklist = { -- Items NOT allowed in this backpack
            'weapon_pistol',
            'water'
        }
    },
    
    -- Large Backpack
    {
        item = 'backpack3',
        label = 'Large Backpack',
        slots = 40,
        weight = 400000,
        size = 400000,
    },
    
    -- Duffel Bag
    {
        item = 'duffle1',
        label = 'Duffel Bag',
        slots = 25,
        weight = 250000,
        size = 250000,
        whitelist = { -- ONLY these items allowed
            'iron',
            'steel',
            'copper'
        }
    },
    
    -- Paramedic Bag (Job-locked)
    {
        item = 'paramedicbag',
        label = 'Paramedic Bag',
        slots = 15,
        weight = 150000,
        size = 150000,
        jobLock = {
            jobs = {'ambulance', 'doctor'},
            grades = {0, 1, 2, 3, 4}
        }
    },
    
    -- Police Evidence Bag (Job-locked)
    {
        item = 'policebag',
        label = 'Evidence Bag',
        slots = 20,
        weight = 200000,
        size = 200000,
        jobLock = {
            jobs = {'police'},
            grades = {0, 1, 2, 3, 4}
        }
    }
}

-- ============================================
-- ITEM RESTRICTIONS
-- ============================================
-- Global Blacklist (items that can NEVER go in ANY backpack)
Config.GlobalBlacklist = {
    -- 'backpack1',  -- Uncomment to prevent backpacks in backpacks
    -- 'weapon_heavysniper',
}

-- Global Whitelist (if set, ONLY these items allowed in backpacks)
-- Leave empty {} to allow all items (recommended)
Config.GlobalWhitelist = {
    -- 'sandwich',
    -- 'water',
}
