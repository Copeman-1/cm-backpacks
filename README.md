# 🎒 CM-Backpacks

A lightweight, framework-agnostic backpack system for FiveM servers. Modular inventory support with no visual clutter — just pure functionality.

> **Current version: 2.1.0** — see [Changelog](#-changelog) for what's new.

---

## ✨ Features

- 🔄 **Multi-Inventory Support** — Works with OX, QS, QB and PS inventories
- 🏢 **Job-Locked Backpacks** — Restrict certain backpacks to specific jobs/grades
- 📦 **Item Restrictions** — Whitelist or blacklist items per backpack type
- 🚫 **Carry Limits** — Configurable maximum backpacks per player
- ⌨️ **Player Keybind** — Open your backpack with a key; players can remap it in FiveM settings
- 👕 **Clothing-as-Items Support** — If your server uses a clothing-as-items system, backpacks can be worn in the backpack clothing slot
- 🔧 **Easy Configuration** — Single config file with clear examples
- 🎮 **Plug & Play** — Auto-detects framework and inventory system

---

## 📋 Requirements

| Requirement | Options |
|---|---|
| Framework | QBCore, QBox, or ESX |
| Inventory | OX Inventory, QS-Inventory, QB-Inventory, or PS-Inventory |
| Database | oxmysql |

**No SQL installation required.** Each inventory system uses its own stash tables.

---

## 🚀 Installation

1. Download and extract `cm-backpacks` to your resources folder
2. Add `ensure cm-backpacks` to your `server.cfg`
3. Add backpack items to your inventory (see [Item Configuration](#-item-configuration) below)
4. Restart your server

---

## ⌨️ Keybind

Players can open their backpack directly via a configurable keybind without touching the inventory context menu.

- Default key is set in `config.lua` (`Config.Keybind.DefaultKey`)
- Players can remap it individually in **Settings → Keybinds → FiveM → cm-backpacks** — their preference is saved automatically by FiveM
- Disable entirely with `Config.Keybind.Enabled = false`

---

## 📦 Item Configuration

Add backpack items to your inventory's shared items file. Each inventory system has a slightly different format.

### OX Inventory

Add to `ox_inventory/data/items.lua`:

```lua
['backpack1'] = {
    label = 'Small Backpack',
    weight = 500,
    stack = false,
    close = true,
    consume = 0,
    description = 'A small backpack. Provides 20 additional inventory slots.',
    client = {
        export = 'cm-backpacks.UseBackpack'  -- required for ox_inventory
    }
},

['backpack2'] = {
    label = 'Medium Backpack',
    weight = 750,
    stack = false,
    close = true,
    consume = 0,
    description = 'A medium backpack. Provides 30 additional inventory slots.',
    client = {
        export = 'cm-backpacks.UseBackpack'
    }
},

['backpack3'] = {
    label = 'Large Backpack',
    weight = 1000,
    stack = false,
    close = true,
    consume = 0,
    description = 'A large backpack. Provides 40 additional inventory slots.',
    client = {
        export = 'cm-backpacks.UseBackpack'
    }
},

['duffle1'] = {
    label = 'Duffel Bag',
    weight = 750,
    stack = false,
    close = true,
    consume = 0,
    description = 'A duffel bag for carrying materials. Provides 25 inventory slots.',
    client = {
        export = 'cm-backpacks.UseBackpack'
    }
},

['paramedicbag'] = {
    label = 'Paramedic Bag',
    weight = 500,
    stack = false,
    close = true,
    consume = 0,
    description = 'A medical supply bag. Provides 15 inventory slots. (Job Locked)',
    client = {
        export = 'cm-backpacks.UseBackpack'
    }
},

['policebag'] = {
    label = 'Evidence Bag',
    weight = 500,
    stack = false,
    close = true,
    consume = 0,
    description = 'A police evidence bag. Provides 20 inventory slots. (Job Locked)',
    client = {
        export = 'cm-backpacks.UseBackpack'
    }
},
```

> ⚠️ **The `client.export` field is required for ox_inventory.** Without it the backpack item will not open when used.

### QS-Inventory / QB-Inventory / PS-Inventory

Add to your shared items file (`qs-inventory/shared/items.lua`, `qb-core/shared/items.lua`, etc.):

```lua
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
    ['description'] = 'A small backpack. Provides 20 additional inventory slots.'
},

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
    ['description'] = 'A medium backpack. Provides 30 additional inventory slots.'
},

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
    ['description'] = 'A large backpack. Provides 40 additional inventory slots.'
},

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

---

## 🖼️ Images

Place backpack images in your inventory's images folder:

| Inventory | Path |
|---|---|
| OX Inventory | `ox_inventory/web/images/` |
| QS-Inventory | `qs-inventory/html/images/` |
| QB-Inventory | `qb-inventory/html/images/` |
| PS-Inventory | `ps-inventory/html/images/` |

Image names: `backpack1.png`, `backpack2.png`, `backpack3.png`, `duffle1.png`, `paramedicbag.png`, `policebag.png`

---

## ⚙️ Configuration

Edit `config.lua` to customise backpacks. Key settings:

```lua
Config.Debug = false  -- set true for troubleshooting

-- Keybind (players can remap in FiveM settings)
Config.Keybind = {
    Enabled     = true,
    Command     = 'openbackpack',
    DefaultKey  = 'B',
    Description = 'Open backpack',
}

-- Carry restrictions
Config.RestrictMultipleBackpacks = true
Config.MaxAllowedBackpacks = 2

-- Backpack definitions
Config.Backpacks = {
    {
        item = 'backpack1',
        label = 'Small Backpack',
        slots = 20,
        itemWeight = 500,    -- weight of the item in the player's inventory (ox_inventory)
        maxWeight = 200000,  -- max weight the stash can hold (ox_inventory)
        size = 200000,       -- used by qb/qs/ps inventories
    },
    {
        item = 'backpack2',
        label = 'Medium Backpack',
        slots = 30,
        itemWeight = 750,
        maxWeight = 300000,
        size = 300000,
        blacklist = {        -- items NOT allowed in this backpack
            'weapon_pistol',
            'water'
        }
    },
    {
        item = 'duffle1',
        label = 'Duffel Bag',
        slots = 25,
        itemWeight = 750,
        maxWeight = 250000,
        size = 250000,
        whitelist = {        -- ONLY these items allowed
            'iron',
            'steel',
            'copper'
        }
    },
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
}
```

> **ox_inventory note:** Use `itemWeight` for how much the bag weighs in the player's pocket and `maxWeight` for the stash capacity. These are separate values — previously both used `weight` which caused the item to weigh the same as its storage capacity.

---

## 🎨 Supported Inventories

| Inventory | Status | Stash Storage |
|---|---|---|
| OX Inventory | ✅ Tested | Internal (`ox_inventory` table) |
| QS-Inventory | ✅ Tested | `inventory_stash` |
| QB-Inventory | ✅ Supported | `stashitems` |
| PS-Inventory | ✅ Supported | `stashitems` |

---

## 🔧 Troubleshooting

**Backpack not opening?**
1. Set `Config.Debug = true` in `config.lua`
2. Check F8 console and server console for errors
3. For ox_inventory — ensure the item has `client = { export = 'cm-backpacks.UseBackpack' }` in `items.lua`
4. For qb/qs/ps — ensure `useable = true` and `unique = true` are set on the item

**Items disappearing after close and reopen?**
- Ensure your inventory system is up to date
- For ox_inventory — items are saved periodically and on server stop; do not restart the resource mid-session

**Job-locked backpack accessible to wrong job?**
- Verify job names match exactly (case-sensitive)
- Check player's current job with `/job`

**Keybind not showing in FiveM settings?**
- The keybind registers on client resource start — rejoin after ensuring `cm-backpacks` is started

---

## 📝 Changelog

### v2.1.0
- **New:** Player-configurable keybind to open backpack directly (remappable in FiveM settings)
- **New:** Clothing-as-items support — backpack items can be placed in the backpack clothing slot and appear on the player's character. Works with any clothing-as-items resource.
- **Config:** New `Config.Keybind` block — set `Enabled = false` to disable

### v2.0.0
- **New:** ox_inventory `client.export` support — backpack items now use the correct ox pattern (`client = { export = 'cm-backpacks.UseBackpack' }`) instead of `registerHook`
- **New:** Split `itemWeight` and `maxWeight` in config — item weight and stash capacity are now separate values
- **Fixed:** Backpack stash not opening on ox_inventory — replaced non-existent `forceOpenInventory` export with correct client-side `openInventory` call
- **Fixed:** Items vanishing on close and reopen — slot metadata is now fetched fresh via `GetSlot` on each use, preventing a new stash ID being generated every open

### v1.0.0
- Initial release

---

## 📝 License

MIT License — free to use and modify.

## 💬 Support

- Open an issue on GitHub
- Check existing issues for solutions

---

## 🙏 Credits

**Author:** Copeman  
**Framework support:** QBCore, QBox, ESX  
**Inventory support:** OX, QS, QB, PS

---

*Made with ❤️ for the FiveM community*
