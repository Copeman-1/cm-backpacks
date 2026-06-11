-- Server-side framework bridge with auto-detection
CMBridge = {}
CMBridge.Framework = nil
CMBridge.Inventory = nil
CMBridge.InventoryBridge = nil  -- NEW: Holds inventory-specific bridge module

-- Helper function
function table.length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- Framework objects
QBCore = nil
ESX = nil

-- Detect Framework
local function DetectFramework()
    if Config.Framework then
        return Config.Framework
    end
    
    if GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    end
    
    if GetResourceState('qb-core') == 'started' then
        return 'qb-core'
    end
    
    if GetResourceState('es_extended') == 'started' then
        return 'esx'
    end
    
    return nil
end

-- Detect Inventory System
local function DetectInventory()
    if Config.Inventory then
        return Config.Inventory
    end
    
    if GetResourceState('ox_inventory') == 'started' then
        return 'ox_inventory'
    end
    
    if GetResourceState('qs-inventory') == 'started' then
        return 'qs-inventory'
    end
    
    if GetResourceState('qb-inventory') == 'started' then
        return 'qb-inventory'
    end
    
    if GetResourceState('ps-inventory') == 'started' then
        return 'ps-inventory'
    end
    
    return 'qb-inventory'
end

-- Initialize Framework
function CMBridge.InitFramework()
    CMBridge.Framework = DetectFramework()
    CMBridge.Inventory = DetectInventory()
    
    -- Initialize framework objects
    if CMBridge.Framework == 'qb-core' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif CMBridge.Framework == 'qbox' then
        QBCore = exports.qbx_core:GetCoreObject()
    elseif CMBridge.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    end
    
    print('^2[cm-backpacks] Server Framework: ' .. (CMBridge.Framework or 'NONE') .. '^0')
    print('^2[cm-backpacks] Server Inventory: ' .. CMBridge.Inventory .. '^0')
    
    -- Load inventory-specific bridge module
    -- Since the files are already loaded via fxmanifest, we can reference them directly
    -- The inventory bridge files return their table, so we need to call them
    if CMBridge.Inventory == 'qs-inventory' then
        CMBridge.InventoryBridge = QSInventoryBridge
    elseif CMBridge.Inventory == 'qb-inventory' then
        CMBridge.InventoryBridge = QBInventoryBridge
    elseif CMBridge.Inventory == 'ox_inventory' then
        CMBridge.InventoryBridge = OXInventoryBridge
    elseif CMBridge.Inventory == 'ps-inventory' then
        CMBridge.InventoryBridge = PSInventoryBridge
    end
    
    if CMBridge.InventoryBridge then
        print('^2[cm-backpacks] Loaded inventory bridge: ' .. CMBridge.Inventory .. '^0')
    else
        print('^1[cm-backpacks] No inventory bridge found for: ' .. CMBridge.Inventory .. '^0')
        CMBridge.InventoryBridge = nil
    end
end

-- Get Player Object
function CMBridge.GetPlayer(source)
    if CMBridge.Framework == 'qb-core' then
        local QBCore = exports['qb-core']:GetCoreObject()
        return QBCore.Functions.GetPlayer(source)
    elseif CMBridge.Framework == 'qbox' then
        return exports.qbx_core:GetPlayer(source)
    elseif CMBridge.Framework == 'esx' then
        local ESX = exports['es_extended']:getSharedObject()
        return ESX.GetPlayerFromId(source)
    end
    return nil
end

-- Get Player Identifier
function CMBridge.GetIdentifier(Player)
    if not Player then return nil end
    
    if CMBridge.Framework == 'qb-core' or CMBridge.Framework == 'qbox' then
        return Player.PlayerData.citizenid
    elseif CMBridge.Framework == 'esx' then
        return Player.identifier
    end
    
    return nil
end

-- Get Player Character Name (firstname + lastname)
function CMBridge.GetCharacterName(Player)
    if not Player then return nil end
    
    if CMBridge.Framework == 'qb-core' or CMBridge.Framework == 'qbox' then
        if Player.PlayerData.charinfo then
            local firstname = Player.PlayerData.charinfo.firstname or ''
            local lastname = Player.PlayerData.charinfo.lastname or ''
            return firstname .. lastname -- Concatenate without space for ID
        end
    elseif CMBridge.Framework == 'esx' then
        if Player.getName then
            return Player.getName():gsub("%s+", "") -- Remove spaces
        end
    end
    
    return nil
end

-- Get Player Job
function CMBridge.GetJob(Player)
    if not Player then return nil end
    
    if CMBridge.Framework == 'qb-core' or CMBridge.Framework == 'qbox' then
        return Player.PlayerData.job.name
    elseif CMBridge.Framework == 'esx' then
        return Player.job.name
    end
    
    return nil
end

-- Notifications
function CMBridge.Notify(source, message, type, duration)
    type = type or 'info'
    duration = duration or 5000
    
    if CMBridge.Framework == 'qb-core' then
        local QBCore = exports['qb-core']:GetCoreObject()
        TriggerClientEvent('QBCore:Notify', source, message, type, duration)
    elseif CMBridge.Framework == 'qbox' then
        TriggerClientEvent('QBCore:Notify', source, message, type, duration)
    elseif CMBridge.Framework == 'esx' then
        TriggerClientEvent('esx:showNotification', source, message)
    else
        TriggerClientEvent('cm-backpacks:client:notify', source, message, type, duration)
    end
end

-- Get Player Items
function CMBridge.GetPlayerItems(source)
    if CMBridge.Inventory == 'ox_inventory' then
        local items = exports.ox_inventory:GetInventoryItems(source)
        return items or {}
        
    elseif CMBridge.Inventory == 'qs-inventory' then
        local Player = CMBridge.GetPlayer(source)
        if Player then
            return Player.PlayerData.items or {}
        end
        
    elseif CMBridge.Inventory == 'qb-inventory' or CMBridge.Inventory == 'ps-inventory' then
        local Player = CMBridge.GetPlayer(source)
        if Player then
            return Player.PlayerData.items or {}
        end
    end
    
    return {}
end

-- Search for Item by Name
function CMBridge.SearchItem(source, itemName)
    if CMBridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:Search(source, 'count', itemName)
        
    elseif CMBridge.Inventory == 'qs-inventory' or CMBridge.Inventory == 'qb-inventory' or CMBridge.Inventory == 'ps-inventory' then
        local Player = CMBridge.GetPlayer(source)
        if Player then
            local items = Player.Functions.GetItemsByName(itemName)
            return items or {}
        end
    end
    
    return nil
end

-- Get Item by Slot
function CMBridge.GetItemBySlot(source, slot)
    if CMBridge.Inventory == 'ox_inventory' then
        local item = exports.ox_inventory:GetSlot(source, slot)
        return item
        
    elseif CMBridge.Inventory == 'qs-inventory' or CMBridge.Inventory == 'qb-inventory' or CMBridge.Inventory == 'ps-inventory' then
        local Player = CMBridge.GetPlayer(source)
        if Player and Player.PlayerData.items[slot] then
            return Player.PlayerData.items[slot]
        end
    end
    
    return nil
end

-- Add Item
function CMBridge.AddItem(source, itemName, amount, metadata)
    amount = amount or 1
    metadata = metadata or {}
    
    if CMBridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:AddItem(source, itemName, amount, metadata)
        
    elseif CMBridge.Inventory == 'qs-inventory' or CMBridge.Inventory == 'qb-inventory' or CMBridge.Inventory == 'ps-inventory' then
        local Player = CMBridge.GetPlayer(source)
        if Player then
            return Player.Functions.AddItem(itemName, amount, nil, metadata)
        end
    end
    
    return false
end

-- Remove Item
function CMBridge.RemoveItem(source, itemName, amount, slot)
    amount = amount or 1
    
    if CMBridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:RemoveItem(source, itemName, amount, nil, slot)
        
    elseif CMBridge.Inventory == 'qs-inventory' or CMBridge.Inventory == 'qb-inventory' or CMBridge.Inventory == 'ps-inventory' then
        local Player = CMBridge.GetPlayer(source)
        if Player then
            return Player.Functions.RemoveItem(itemName, amount, slot)
        end
    end
    
    return false
end

-- Get Item Metadata
function CMBridge.GetMetadata(item)
    if not item then return {} end
    
    if CMBridge.Inventory == 'ox_inventory' then
        return item.metadata or {}
    else
        return item.info or {}
    end
end

-- Set Item Metadata
function CMBridge.SetMetadata(source, item, metadata)
    if CMBridge.Inventory == 'ox_inventory' then
        if item.slot then
            exports.ox_inventory:SetMetadata(source, item.slot, metadata)
        end
    else
        -- For QB-based inventories (including qs-inventory), update the item info
        local Player = CMBridge.GetPlayer(source)
        if Player and item.slot then
            Player.PlayerData.items[item.slot].info = metadata
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
    end
end

-- Register Useable Item
function CMBridge.RegisterUseable(itemName, callback)
    if CMBridge.Inventory == 'ox_inventory' then
        -- ox_inventory uses client.export in items.lua, not server-side registration.
        -- The net event cm-backpacks:server:useBackpack is handled in server/main.lua
        -- where UseBackpack() is defined, so nothing to register here.

    elseif CMBridge.Inventory == 'qs-inventory' or CMBridge.Inventory == 'qb-inventory' or CMBridge.Inventory == 'ps-inventory' then
        if CMBridge.Framework == 'qb-core' then
            local QBCore = exports['qb-core']:GetCoreObject()
            QBCore.Functions.CreateUseableItem(itemName, callback)
        elseif CMBridge.Framework == 'qbox' then
            exports.qbx_core:CreateUseableItem(itemName, callback)
        end
    end
end


-- Open Stash/Storage - Delegates to inventory-specific bridge
function CMBridge.OpenStash(source, stashId, slots, maxWeight)
    CMBackpacks.DebugPrint("OpenStash called - Inventory: " .. CMBridge.Inventory .. ", StashID: " .. stashId)
    
    if CMBridge.InventoryBridge and CMBridge.InventoryBridge.OpenStash then
        return CMBridge.InventoryBridge.OpenStash(source, stashId, slots, maxWeight)
    else
        CMBackpacks.DebugPrint("No inventory bridge loaded", "error")
        return false
    end
end

-- Get Stash Items - Delegates to inventory-specific bridge
function CMBridge.GetStashItems(stashId)
    if CMBridge.InventoryBridge and CMBridge.InventoryBridge.GetStashItems then
        return CMBridge.InventoryBridge.GetStashItems(stashId)
    end
    return {}
end

-- Save Stash Items - Delegates to inventory-specific bridge
function CMBridge.SaveStash(stashId, items)
    if CMBridge.InventoryBridge and CMBridge.InventoryBridge.SaveStash then
        CMBridge.InventoryBridge.SaveStash(stashId, items)
    end
end

-- Check if player has item
function CMBridge.HasItem(source, itemName, amount)
    amount = amount or 1
    
    if CMBridge.Inventory == 'ox_inventory' then
        local count = exports.ox_inventory:Search(source, 'count', itemName)
        return count >= amount
        
    else
        local Player = CMBridge.GetPlayer(source)
        if Player then
            local item = Player.Functions.GetItemByName(itemName)
            if item then
                local itemAmount = item.amount or item.count or 0
                return itemAmount >= amount
            end
        end
    end
    
    return false
end

-- Initialize on resource start
CreateThread(function()
    Wait(500)
    CMBridge.InitFramework()
end)