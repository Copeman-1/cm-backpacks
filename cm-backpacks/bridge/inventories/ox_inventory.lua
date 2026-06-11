-- OX Inventory specific bridge functions
-- This file handles all OX Inventory specific integrations

OXInventoryBridge = {}

-- Open Stash for OX Inventory
function OXInventoryBridge.OpenStash(source, stashId, slots, maxWeight)
    CMBackpacks.DebugPrint('Using ox_inventory RegisterStash')

    -- Register the stash with ox_inventory (safe to call multiple times)
    local success = pcall(function()
        exports.ox_inventory:RegisterStash(stashId, 'Backpack', slots, maxWeight, nil)
    end)

    if not success then
        CMBackpacks.DebugPrint('Failed to register ox_inventory stash', 'error')
        return false
    end

    CMBackpacks.DebugPrint('OX stash registered, telling client to open...', 'success')

    -- forceOpenInventory does not exist in ox_inventory/piotreq fork.
    -- Instead tell the client to open it via the standard ox_inventory client event.
    TriggerClientEvent('cm-backpacks:client:openOXStash', source, stashId)

    return true
end

-- Get Stash Items for OX Inventory
function OXInventoryBridge.GetStashItems(stashId)
    local success, items = pcall(function()
        return exports.ox_inventory:GetInventoryItems(stashId)
    end)
    
    if success and items then
        return items
    end
    
    return {}
end

-- Save Stash for OX Inventory
function OXInventoryBridge.SaveStash(stashId, items)
    -- OX Inventory handles saving automatically
    -- No manual save needed
    CMBackpacks.DebugPrint('OX Inventory auto-saves, no manual save needed')
end