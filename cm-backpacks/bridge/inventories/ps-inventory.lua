-- PS-Inventory specific bridge functions
-- PS-Inventory is similar to QB-Inventory

PSInventoryBridge = {}

-- Open Stash for PS-Inventory
function PSInventoryBridge.OpenStash(source, stashId, slots, maxWeight)
    CMBackpacks.DebugPrint('Using ps-inventory stash system')
    
    -- Register the stash
    local success = pcall(function()
        exports['ps-inventory']:RegisterStash(stashId, slots, maxWeight)
    end)
    
    if not success then
        CMBackpacks.DebugPrint('Failed to register ps-inventory stash', 'error')
        return false
    end
    
    -- Open the stash
    TriggerClientEvent('inventory:client:SetCurrentStash', source, stashId)
    TriggerClientEvent('inventory:client:OpenInventory', source, 'stash', stashId)
    
    CMBackpacks.DebugPrint('ps-inventory stash opened', 'success')
    return true
end

-- Get Stash Items for PS-Inventory
function PSInventoryBridge.GetStashItems(stashId)
    local result = MySQL.query.await('SELECT items FROM stashitems WHERE stash = ?', {stashId})
    
    if result and result[1] and result[1].items then
        return json.decode(result[1].items) or {}
    end
    
    return {}
end

-- Save Stash for PS-Inventory
function PSInventoryBridge.SaveStash(stashId, items)
    MySQL.Async.execute('UPDATE stashitems SET items = @items WHERE stash = @stash', {
        ['@stash'] = stashId,
        ['@items'] = json.encode(items)
    })
end