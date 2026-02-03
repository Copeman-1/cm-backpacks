-- QB-Inventory specific bridge functions
-- This file handles all QB-Inventory specific integrations

QBInventoryBridge = {}

-- Open Stash for QB-Inventory
function QBInventoryBridge.OpenStash(source, stashId, slots, maxWeight)
    CMBackpacks.DebugPrint('Using qb-inventory OpenInventory export')
    
    -- CRITICAL: Check and fix player state
    local playerState = Player(source).state
    local wasBusy = playerState.inv_busy
    
    if wasBusy then
        CMBackpacks.DebugPrint('Player inv_busy was TRUE, forcing to FALSE', 'warning')
        Player(source).state:set('inv_busy', false, true)
        Wait(50)
        CMBackpacks.DebugPrint('inv_busy state cleared', 'success')
    else
        CMBackpacks.DebugPrint('Player inv_busy was already false', 'success')
    end
    
    -- Prepare stash data
    local stashData = {
        maxweight = maxWeight,
        slots = slots,
        label = 'Backpack'
    }
    
    -- Try to open using the OpenInventory export
    local success, result = pcall(function()
        return exports['qb-inventory']:OpenInventory(source, stashId, stashData)
    end)
    
    if success then
        CMBackpacks.DebugPrint('QB-Inventory stash opened successfully', 'success')
        return true
    else
        CMBackpacks.DebugPrint('Failed to open QB-Inventory stash: ' .. tostring(result), 'error')
        return false
    end
end

-- Get Stash Items for QB-Inventory
function QBInventoryBridge.GetStashItems(stashId)
    local result = MySQL.query.await('SELECT items FROM stashitems WHERE stash = ?', {stashId})
    
    if result and result[1] and result[1].items then
        return json.decode(result[1].items) or {}
    end
    
    return {}
end

-- Save Stash for QB-Inventory
function QBInventoryBridge.SaveStash(stashId, items)
    MySQL.Async.execute('UPDATE stashitems SET items = @items WHERE stash = @stash', {
        ['@stash'] = stashId,
        ['@items'] = json.encode(items)
    })
end