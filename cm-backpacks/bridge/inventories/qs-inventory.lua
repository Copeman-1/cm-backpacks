-- QS-Inventory specific bridge functions
-- This file handles all QS-Inventory specific integrations

QSInventoryBridge = {}

-- Open Stash for QS-Inventory
function QSInventoryBridge.OpenStash(source, stashId, slots, maxWeight)
    CMBackpacks.DebugPrint('Using qs-inventory stash system')
    
    -- Get player object
    local PlayerObj = CMBridge.GetPlayer(source)
    if not PlayerObj then
        CMBackpacks.DebugPrint('Could not get player object', 'error')
        return false
    end
    
    -- CRITICAL: Check and fix player state
    local playerState = Player(source).state
    local wasBusy = playerState.inv_busy
    
    if wasBusy then
        CMBackpacks.DebugPrint('Player inv_busy was TRUE, forcing to FALSE', 'warning')
        Player(source).state:set('inv_busy', false, true)
        Wait(50)
        CMBackpacks.DebugPrint('inv_busy state cleared', 'success')
    end
    
    -- Method 1: Try the player's OpenInventory function (most reliable for recent qs-inventory)
    if PlayerObj.Functions and PlayerObj.Functions.OpenInventory then
        CMBackpacks.DebugPrint('Using Player.Functions.OpenInventory')
        local success = pcall(function()
            PlayerObj.Functions.OpenInventory('stash', stashId, {
                maxweight = maxWeight,
                slots = slots
            })
        end)
        
        if success then
            CMBackpacks.DebugPrint('Opened via Player.Functions.OpenInventory', 'success')
            return true
        end
    end
    
    CMBackpacks.DebugPrint('Player.Functions.OpenInventory not available, trying other methods')
    
    -- QS-Inventory requires "Stash_" prefix
    local qsStashId = 'Stash_' .. stashId
    
    CMBackpacks.DebugPrint('Backpack stash ID: ' .. qsStashId)
    
    -- Register/create the stash in database
    local dbSuccess = pcall(function()
        MySQL.Async.execute('INSERT INTO inventory_stash (stash, items) VALUES (@stash, @items) ON DUPLICATE KEY UPDATE stash = @stash', {
            ['@stash'] = qsStashId,
            ['@items'] = '[]'
        })
    end)
    
    if dbSuccess then
        CMBackpacks.DebugPrint('Stash database entry created', 'success')
    end
    
    Wait(100)
    
    -- Register with qs-inventory using SERVER export (slots, maxweight order)
    local success = pcall(function()
        exports['qs-inventory']:RegisterStash(qsStashId, slots, maxWeight)
    end)
    
    if not success then
        CMBackpacks.DebugPrint('RegisterStash failed', 'error')
        return false
    end
    
    CMBackpacks.DebugPrint('Stash registered, opening...', 'success')
    Wait(100)
    
    -- Trigger client to open using QS-Inventory's documented method
    TriggerClientEvent('cm-backpacks:client:openQSStash', source, qsStashId, maxWeight, slots)
    
    CMBackpacks.DebugPrint('Client trigger sent', 'success')
    return true
end

-- Get Stash Items for QS-Inventory
function QSInventoryBridge.GetStashItems(stashId)
    local qsStashId = 'Stash_' .. stashId
    local result = MySQL.query.await('SELECT items FROM inventory_stash WHERE stash = ?', {qsStashId})
    
    if result and result[1] and result[1].items then
        return json.decode(result[1].items) or {}
    end
    
    return {}
end

-- Save Stash for QS-Inventory
function QSInventoryBridge.SaveStash(stashId, items)
    local qsStashId = 'Stash_' .. stashId
    MySQL.Async.execute('UPDATE inventory_stash SET items = @items WHERE stash = @stash', {
        ['@stash'] = qsStashId,
        ['@items'] = json.encode(items)
    })
end