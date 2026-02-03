# 🎒 CM-Backpacks

A lightweight, backpack system for FiveM servers. Simple inventory expansion with no visual clutter - just pure functionality.

## ✨ Features

- 🔄 **Multi-Inventory Support** - Works with QS, QB, OX, and PS inventories
- 🏢 **Job-Locked Backpacks** - Restrict certain backpacks to specific jobs
- 📦 **Item Restrictions** - Whitelist/blacklist items per backpack
- 🚫 **Carry Limits** - Configurable maximum backpacks per player
- 🔧 **Easy Configuration** - Simple config with clear examples
- 🎮 **Plug & Play** - Auto-detects framework and inventory system

## 📋 Requirements

- **Framework**: QBCore, QBox, or ESX
- **Inventory**: QS-Inventory, QB-Inventory, OX Inventory, or PS-Inventory
- **Database**: oxmysql

## 🚀 Installation

1. Download and extract `cm-backpacks` to your resources folder
2. Add `ensure cm-backpacks` to your `server.cfg`
3. Add backpack items to your inventory (see Item Configuration below)
4. Restart your server

**No SQL installation required!** Each inventory system uses its own stash tables.

## 🎮 How to Use

1. Obtain a backpack (buy from shop, admin command, etc.)
2. Place backpack in hotbar slots (1-6)
3. Press the hotbar key to open the backpack stash
4. Store items and enjoy extra inventory space!

## 📦 Item Configuration

Add backpack items to your inventory's shared items file:

### QS-Inventory
FOR QB-CORE use `qb-core/shared/items.lua`:
Add to `qs-inventory/shared/items.lua`:

```lua
-- Small Backpack
['backpack1'] = {
    ['name'] = 'backpack1',
    ['label'] = 'Small Backpack',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'backpack1.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A small backpack for carrying extra items. Provides 20 additional inventory slots.'
},

-- Medium Backpack
['backpack2'] = {
    ['name'] = 'backpack2',
    ['label'] = 'Medium Backpack',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'backpack2.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A medium backpack for carrying extra items. Provides 30 additional inventory slots.'
},

-- Large Backpack
['backpack3'] = {
    ['name'] = 'backpack3',
    ['label'] = 'Large Backpack',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'backpack3.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A large backpack for carrying extra items. Provides 40 additional inventory slots.'
},

-- Duffel Bag
['duffle1'] = {
    ['name'] = 'duffle1',
    ['label'] = 'Duffel Bag',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'duffle1.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A duffel bag for carrying materials. Provides 25 inventory slots.'
},

-- Paramedic Bag (Job Locked)
['paramedicbag'] = {
    ['name'] = 'paramedicbag',
    ['label'] = 'Paramedic Bag',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'paramedicbag.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A medical supply bag. Provides 15 inventory slots. (Job Locked)'
},

-- Police Evidence Bag (Job Locked)
['policebag'] = {
    ['name'] = 'policebag',
    ['label'] = 'Evidence Bag',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'policebag.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A police evidence bag. Provides 20 inventory slots. (Job Locked)'
},
```

### QB-Inventory / PS-Inventory

Add to `qb-core/shared/items.lua`:

```lua
-- Small Backpack
['backpack1'] = {
    ['name'] = 'backpack1',
    ['label'] = 'Small Backpack',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'backpack1.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A small backpack for carrying extra items. Provides 20 additional inventory slots.'
},

-- Medium Backpack
['backpack2'] = {
    ['name'] = 'backpack2',
    ['label'] = 'Medium Backpack',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'backpack2.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A medium backpack for carrying extra items. Provides 30 additional inventory slots.'
},

-- Large Backpack
['backpack3'] = {
    ['name'] = 'backpack3',
    ['label'] = 'Large Backpack',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'backpack3.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A large backpack for carrying extra items. Provides 40 additional inventory slots.'
},

-- Duffel Bag
['duffle1'] = {
    ['name'] = 'duffle1',
    ['label'] = 'Duffel Bag',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'duffle1.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A duffel bag for carrying materials. Provides 25 inventory slots.'
},

-- Paramedic Bag (Job Locked)
['paramedicbag'] = {
    ['name'] = 'paramedicbag',
    ['label'] = 'Paramedic Bag',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'paramedicbag.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A medical supply bag. Provides 15 inventory slots. (Job Locked)'
},

-- Police Evidence Bag (Job Locked)
['policebag'] = {
    ['name'] = 'policebag',
    ['label'] = 'Evidence Bag',
    ['weight'] = 1000,
    ['type'] = 'item',
    ['image'] = 'policebag.png',
    ['unique'] = true,
    ['useable'] = true,
    ['shouldClose'] = true,
    ['combinable'] = nil,
    ['description'] = 'A police evidence bag. Provides 20 inventory slots. (Job Locked)'
},
```

### OX Inventory

Add to `ox_inventory/data/items.lua`:

```lua
['backpack1'] = {
    label = 'Small Backpack',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A small backpack for carrying extra items. Provides 20 additional inventory slots.',
    client = {
        image = 'backpack1.png',
    }
},

['backpack2'] = {
    label = 'Medium Backpack',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A medium backpack for carrying extra items. Provides 30 additional inventory slots.',
    client = {
        image = 'backpack2.png',
    }
},

['backpack3'] = {
    label = 'Large Backpack',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A large backpack for carrying extra items. Provides 40 additional inventory slots.',
    client = {
        image = 'backpack3.png',
    }
},

['duffle1'] = {
    label = 'Duffel Bag',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A duffel bag for carrying materials. Provides 25 inventory slots.',
    client = {
        image = 'duffle1.png',
    }
},

['paramedicbag'] = {
    label = 'Paramedic Bag',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A medical supply bag. Provides 15 inventory slots. (Job Locked)',
    client = {
        image = 'paramedicbag.png',
    }
},

['policebag'] = {
    label = 'Evidence Bag',
    weight = 1000,
    stack = false,
    close = true,
    description = 'A police evidence bag. Provides 20 inventory slots. (Job Locked)',
    client = {
        image = 'policebag.png',
    }
},
```

## ⚙️ Configuration

Edit `config.lua` to customize backpacks:

```lua
-- Debug Mode
Config.Debug = false  -- Set to true for troubleshooting

-- Carry Restrictions
Config.RestrictMultipleBackpacks = true
Config.MaxAllowedBackpacks = 2

-- Backpack Configurations
Config.Backpacks = {
    {
        item = 'backpack1',
        label = 'Small Backpack',
        slots = 20,
        weight = 200000,
        size = 200000,
    },
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
    -- Add more backpacks...
}
```

### Item Restrictions

```lua
{
    item = 'backpack2',
    label = 'Medium Backpack',
    slots = 30,
    weight = 300000,
    size = 300000,
    blacklist = { -- Items NOT allowed
        'weapon_pistol',
        'water'
    }
},

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
}
```

## 🖼️ Images

Place backpack images in your inventory's images folder:
- QS-Inventory: `qs-inventory/html/images/`
- QB-Inventory: `qb-inventory/html/images/`
- OX Inventory: `ox_inventory/web/images/`
- PS-Inventory: `ps-inventory/html/images/`

Image names: `backpack1.png`, `backpack2.png`, `backpack3.png`, `duffle1.png`, `paramedicbag.png`, `policebag.png`

## 🎨 Supported Inventories

| Inventory | Status | Stash Table |
|-----------|--------|-------------|
| QS-Inventory | ✅ Tested | `inventory_stash` |
| QB-Inventory | ✅ Supported | `stashitems` |
| OX Inventory | ✅ Supported | Internal |
| PS-Inventory | ✅ Supported | `stashitems` |

## 🔧 Troubleshooting

**Backpack not opening?**
1. Set `Config.Debug = true` in config.lua
2. Check F8 console and server console for errors
3. Ensure backpack item is set as `useable = true` and `unique = true`
4. Verify you're using a supported inventory system

**Items disappearing?**
- Ensure your inventory system is up to date
- Check that the backpack has `unique = true` in item definition

**Job-locked backpack accessible to wrong job?**
- Verify job names match exactly (case-sensitive)
- Check player's current job with `/job` command

## 📝 License

This project is licensed under the MIT License - feel free to use and modify!

## 💬 Support

For issues, suggestions, or support:
- Open an issue on GitHub
- Check existing issues for solutions

## 🙏 Credits

- **Author**: Copeman
- **Version**: 1.0.0
- **Framework Support**: QBCore, QBox, ESX
- **Inventory Support**: QS, QB, OX, PS

---

Made with ❤️ for the FiveM community
