-- OX Inventory specific bridge functions
-- This file handles all OX Inventory specific integrations

OXInventoryBridge = {}

-- Open Stash for OX Inventory
function OXInventoryBridge.OpenStash(source, stashId, slots, maxWeight)
    CMBackpacks.DebugPrint('Using ox_inventory RegisterStash')
    
    -- Register the stash with ox_inventory
    local success = pcall(function()
        exports.ox_inventory:RegisterStash(stashId, 'Backpack', slots, maxWeight, nil)
    end)
    
    if not success then
        CMBackpacks.DebugPrint('Failed to register ox_inventory stash', 'error')
        return false
    end
    
    CMBackpacks.DebugPrint('OX stash registered, opening...', 'success')
    
    -- Open the stash for the player
    local opened = pcall(function()
        exports.ox_inventory:forceOpenInventory(source, 'stash', stashId)
    end)
    
    if opened then
        CMBackpacks.DebugPrint('OX Inventory stash opened successfully', 'success')
        return true
    else
        CMBackpacks.DebugPrint('Failed to open OX Inventory stash', 'error')
        return false
    end
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