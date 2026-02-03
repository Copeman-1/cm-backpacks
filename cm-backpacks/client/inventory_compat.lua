-- Client-side inventory compatibility and debugging

-- Hook into the inventory open event with conditional debug
RegisterNetEvent('qb-inventory:client:openInventory', function(items, other)
    if Config.Debug then
        print('^3[cm-backpacks CLIENT] qb-inventory:client:openInventory triggered!^0')
        print('^3[cm-backpacks CLIENT] Items count: ' .. (items and #items or 'nil') .. '^0')
        print('^3[cm-backpacks CLIENT] Other data: ' .. (other and json.encode(other) or 'nil') .. '^0')
        print('^3[cm-backpacks CLIENT] SetNuiFocus should be called now^0')
    end
end)

-- QS-Inventory stash opening handler
RegisterNetEvent('cm-backpacks:client:openQSStash', function(stashId, maxWeight, slots)
    if Config.Debug then
        print('^3[cm-backpacks CLIENT] Opening QS stash: ' .. stashId .. '^0')
    end
    
    -- Set current stash
    TriggerEvent('inventory:client:SetCurrentStash', stashId)
    
    Wait(50)
    
    -- Trigger the server event from client (this is how QS-Inventory expects it)
    local other = {
        maxweight = maxWeight,
        slots = slots
    }
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, other)
    
    if Config.Debug then
        print('^2[cm-backpacks CLIENT] QS stash open triggered^0')
    end
end)

-- Add client-side debug for inventory events (if debug enabled)
if Config.Debug and (CMBridge.Inventory == 'qb-inventory' or CMBridge.Inventory == 'ps-inventory' or CMBridge.Inventory == 'qs-inventory') then
    
    -- Listen for SetCurrentStash
    RegisterNetEvent('inventory:client:SetCurrentStash', function(stashId)
        print('^3[cm-backpacks CLIENT] SetCurrentStash called with: ' .. tostring(stashId) .. '^0')
    end)
    
    -- Listen for OpenInventory
    RegisterNetEvent('inventory:client:OpenInventory', function(...)
        local args = {...}
        print('^3[cm-backpacks CLIENT] OpenInventory called with args:^0')
        for i, v in ipairs(args) do
            print('^3  Arg ' .. i .. ': ' .. tostring(v) .. ' (type: ' .. type(v) .. ')^0')
        end
    end)
    
    -- Listen for qb-inventory specific event
    RegisterNetEvent('qb-inventory:client:OpenInventory', function(...)
        local args = {...}
        print('^3[cm-backpacks CLIENT] qb-inventory:client:OpenInventory called^0')
        for i, v in ipairs(args) do
            print('^3  Arg ' .. i .. ': ' .. tostring(v) .. ' (type: ' .. type(v) .. ')^0')
        end
    end)
end

-- Test if NUI is receiving data (only if debug enabled)
if Config.Debug then
    RegisterNUICallback('DebugTest', function(data, cb)
        print('^2[cm-backpacks CLIENT] NUI callback received: ' .. json.encode(data) .. '^0')
        cb('ok')
    end)
    
    -- Test NUI communication
    CreateThread(function()
        Wait(5000)
        print('^3[cm-backpacks CLIENT] Testing NUI communication...^0')
        SendNUIMessage({
            action = 'debug',
            message = 'Testing from client'
        })
    end)
end

-- Listen for inventory close to update backpack visual
RegisterNetEvent('inventory:client:ItemBox', function(itemData, type)
    if Config.Debug then
        print('^3[cm-backpacks CLIENT] ItemBox event: ' .. type .. '^0')
    end
end)
