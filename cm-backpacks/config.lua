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
-- KEYBIND
-- ============================================
-- Allows players to open their backpack via a keybind.
-- The default key can be changed per-player in FiveM settings → Keybinds → cm-backpacks.
Config.Keybind = {
    Enabled     = true,
    Command     = 'openbackpack',   -- /openbackpack command (also used as the keybind id)
    DefaultKey  = '6',              -- default key (any FiveM key name)
    Description = 'Open backpack',  -- label shown in the FiveM keybinds menu
}

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
        itemWeight = 5,    -- how much the backpack itself weighs in the player's inventory
        maxWeight = 200000,  -- max weight the backpack can hold (ox_inventory)
        size = 200000,       -- qb-inventory/qs-inventory uses size
    },
    
    -- Medium Backpack
    {
        item = 'backpack2',
        label = 'Medium Backpack',
        slots = 30,
        itemWeight = 750,
        maxWeight = 300000,
        size = 300000,
        blacklist = {
            'weapon_pistol',
            'water'
        }
    },
    
    -- Large Backpack
    {
        item = 'backpack3',
        label = 'Large Backpack',
        slots = 40,
        itemWeight = 1000,
        maxWeight = 400000,
        size = 400000,
    },
    
    -- Duffel Bag
    {
        item = 'duffle1',
        label = 'Duffel Bag',
        slots = 25,
        itemWeight = 750,
        maxWeight = 250000,
        size = 250000,
        whitelist = {
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
        itemWeight = 500,
        maxWeight = 150000,
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
        itemWeight = 500,
        maxWeight = 200000,
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
