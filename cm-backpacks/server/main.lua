local openBackpacks = {}

-- Count player's backpacks
local function CountPlayerBackpacks(source)
    local count = 0
    local items = CMBridge.GetPlayerItems(source)
    
    if items then
        for _, item in pairs(items) do
            if item and CMBackpacks.IsBackpack(item.name) then
                count = count + 1
            end
        end
    end
    
    return count
end

-- Validate backpack ownership
local function ValidateBackpackOwnership(source, itemName, backpackId)
    local items = CMBridge.SearchItem(source, itemName)
    
    if CMBridge.Inventory == 'ox_inventory' then
        local playerItems = CMBridge.GetPlayerItems(source)
        for _, item in pairs(playerItems) do
            if item.name == itemName and item.metadata and (item.metadata.ID == backpackId or item.metadata.id == backpackId) then
                return true, item
            end
        end
    else
        if items and type(items) == 'table' then
            for _, item in pairs(items) do
                local metadata = item.info or {}
                if metadata.ID == backpackId or metadata.id == backpackId then
                    return true, item
                end
            end
        end
    end
    
    return false, nil
end

-- Check for nested backpacks
local function CheckForNestedBackpacks(stashItems, backpackId, source)
    local hasNested = false
    
    for slot, item in pairs(stashItems) do
        if item and CMBackpacks.IsBackpack(item.name) then
            local metadata = CMBridge.GetMetadata(item)
            local itemId = metadata.ID or metadata.id
            
            if itemId == backpackId then
                CMBridge.Notify(source, CMBackpacks.Locale('backpack_inception'), 'error')
                CMBridge.AddItem(source, item.name, item.count or item.amount or 1, metadata)
                stashItems[slot] = nil
                hasNested = true
            else
                CMBridge.Notify(source, CMBackpacks.Locale('nested_backpack'), 'error')
                CMBridge.AddItem(source, item.name, item.count or item.amount or 1, metadata)
                stashItems[slot] = nil
                hasNested = true
            end
        end
    end
    
    return hasNested
end

-- Open backpack stash
local function OpenBackpack(source, backpackId, itemName)
    local backpackConfig = CMBackpacks.GetBackpackConfig(itemName)
    
    if not backpackConfig then
        CMBackpacks.DebugPrint('No config found for: ' .. itemName, 'error')
        return
    end
    
    CMBackpacks.DebugPrint('OpenBackpack called - source: ' .. source .. ', ID: ' .. backpackId .. ', item: ' .. itemName)
    
    -- Check if already open
    if openBackpacks[backpackId] then
        CMBackpacks.DebugPrint('Backpack already open! Clearing stale entry...', 'warning')
        openBackpacks[backpackId] = nil
    end
    
    -- Check player state
    local playerState = Player(source).state
    CMBackpacks.DebugPrint('Player state inv_busy: ' .. tostring(playerState.inv_busy))
    
    local stashId = backpackId
    local slots = backpackConfig.slots or 20
    local maxWeight = backpackConfig.maxWeight or backpackConfig.size or 200000
    
    CMBackpacks.DebugPrint('Stash ID: ' .. stashId)
    CMBackpacks.DebugPrint('Slots: ' .. slots .. ', Weight/Size: ' .. maxWeight .. ', Inventory: ' .. CMBridge.Inventory)
    
    -- Open the stash
    CMBackpacks.DebugPrint('Calling CMBridge.OpenStash...')
    local success = CMBridge.OpenStash(source, stashId, slots, maxWeight)
    
    CMBackpacks.DebugPrint('OpenStash returned: ' .. tostring(success))
    
    if success then
        openBackpacks[backpackId] = {
            source = source,
            itemName = itemName,
            timestamp = os.time()
        }
        CMBackpacks.DebugPrint('Backpack registered as open, client should see inventory now', 'success')
    end
end

-- Close backpack stash
local function CloseBackpack(source, backpackId)
    if not openBackpacks[backpackId] then return end
    
    -- Get stash items
    local stashItems = CMBridge.GetStashItems(backpackId)
    
    -- Check for nested backpacks
    if CheckForNestedBackpacks(stashItems, backpackId, source) then
        CMBridge.SaveStash(backpackId, stashItems)
    end
    
    -- Clear tracking
    openBackpacks[backpackId] = nil
    CMBackpacks.DebugPrint('Backpack closed: ' .. backpackId)
end

-- Use backpack item
local function UseBackpack(source, item)
    CMBackpacks.DebugPrint('[cm-backpacks DEBUG] UseBackpack called for source: ' .. source .. ', item: ' .. item.name)
    
    local Player = CMBridge.GetPlayer(source)
    if not Player then 
        CMBackpacks.DebugPrint('Could not get player object', 'error')
        return 
    end
    
    local identifier = CMBridge.GetIdentifier(Player)
    CMBackpacks.DebugPrint('[cm-backpacks DEBUG] Player identifier: ' .. tostring(identifier))
    
    local backpackConfig = CMBackpacks.GetBackpackConfig(item.name)
    if not backpackConfig then
        CMBackpacks.DebugPrint('No config found for: ' .. item.name, 'error')
        return
    end
    
    -- Get or create metadata
    -- Note: ox_inventory sends metadata as empty table {} which json-encodes as []
    -- Normalise to ensure we always have a real table
    local metadata = item.metadata or item.info or {}
    if type(metadata) ~= 'table' then metadata = {} end
    CMBackpacks.DebugPrint('[cm-backpacks DEBUG] Metadata: ' .. json.encode(metadata))

    -- For ox_inventory, always re-fetch metadata directly from the slot to get the
    -- authoritative value - the item table we received may be stale/empty
    if CMBridge.Inventory == 'ox_inventory' and item.slot then
        local freshSlot = exports.ox_inventory:GetSlot(source, item.slot)
        if freshSlot and freshSlot.metadata then
            metadata = freshSlot.metadata
            CMBackpacks.DebugPrint('[cm-backpacks DEBUG] Fresh metadata from GetSlot: ' .. json.encode(metadata))
        end
    end

    -- Check if backpack has an ID
    local backpackId = metadata.ID or metadata.id
    
    if not backpackId then
        -- Generate new ID for this backpack
        backpackId = CMBackpacks.GenerateId(identifier, CMBridge.GetCharacterName(Player))
        CMBackpacks.DebugPrint('[cm-backpacks SUCCESS] Generated new ID: ' .. backpackId, 'success')
        
        -- Update metadata
        metadata.ID = backpackId
        metadata.weight = backpackConfig.itemWeight or 500
        metadata.slots = backpackConfig.slots or 20
        metadata.quality = 100
        
        -- Update item metadata
        if CMBridge.Inventory == 'ox_inventory' then
            exports.ox_inventory:SetMetadata(source, item.slot, metadata)
            -- Verify it saved
            Wait(50)
            local verify = exports.ox_inventory:GetSlot(source, item.slot)
            if verify and verify.metadata and (verify.metadata.ID or verify.metadata.id) then
                CMBackpacks.DebugPrint('[cm-backpacks SUCCESS] Metadata verified in slot: ' .. json.encode(verify.metadata), 'success')
            else
                CMBackpacks.DebugPrint('[cm-backpacks ERROR] SetMetadata did not persist! Slot metadata: ' .. json.encode(verify and verify.metadata or 'nil'), 'error')
            end
        else
            item.info = metadata
            Player.Functions.SetInventory(Player.PlayerData.items)
        end
        
        CMBackpacks.DebugPrint('[cm-backpacks SUCCESS] Metadata saved', 'success')
    else
        CMBackpacks.DebugPrint('[cm-backpacks DEBUG] Using existing ID: ' .. backpackId)
    end
    
    CMBackpacks.DebugPrint('[cm-backpacks DEBUG] Backpack config found, slots: ' .. (backpackConfig.slots or 20))
    
    -- Check job lock
    if backpackConfig.jobLock then
        local playerJob = CMBridge.GetJob(Player)
        local playerGrade = CMBridge.GetJobGrade(Player)
        local allowed = false
        
        for _, job in ipairs(backpackConfig.jobLock.jobs) do
            if playerJob == job then
                if not backpackConfig.jobLock.grades or #backpackConfig.jobLock.grades == 0 then
                    allowed = true
                    break
                else
                    for _, grade in ipairs(backpackConfig.jobLock.grades) do
                        if playerGrade == grade then
                            allowed = true
                            break
                        end
                    end
                end
            end
        end
        
        if not allowed then
            CMBridge.Notify(source, CMBackpacks.Locale('job_restricted'), 'error')
            return
        end
    end
    
    -- Check carry restrictions
    if Config.RestrictMultipleBackpacks then
        local count = CountPlayerBackpacks(source)
        
        if count > Config.MaxAllowedBackpacks then
            CMBridge.Notify(source, CMBackpacks.Locale('too_many_backpacks', Config.MaxAllowedBackpacks), 'error')
            return
        end
    end
    
    -- Open the backpack
    OpenBackpack(source, backpackId, item.name)
end

-- Event: Close backpack
RegisterNetEvent('cm-backpacks:server:closeBackpack', function(backpackId)
    CloseBackpack(source, backpackId)
end)

-- Event: Player drops backpack
RegisterNetEvent('cm-backpacks:server:dropBackpack', function(backpackId)
    CloseBackpack(source, backpackId)
end)

-- ox_inventory net event handler
-- Lives here so it has direct access to the local UseBackpack function.
-- For qb/qs/ps inventories this event is never triggered; they use CreateUseableItem directly.
RegisterNetEvent('cm-backpacks:server:useBackpack')
AddEventHandler('cm-backpacks:server:useBackpack', function(itemName, slot, metadata)
    local source = source
    print('^3[cm-backpacks SERVER] useBackpack received - source: ' .. tostring(source) .. ', item: ' .. tostring(itemName) .. '^0')

    local item = {
        name     = itemName,
        slot     = slot,
        metadata = metadata or {},
        info     = metadata or {},
    }

    UseBackpack(source, item)
end)

-- Register useable items (qb/qs/ps only - ox uses client.export in items.lua)
CreateThread(function()
    Wait(2000)
    
    local backpacks = CMBackpacks.GetAllBackpacks()
    
    local useQSMethod = CMBridge.Inventory == 'qs-inventory' and _G.CreateUsableItem ~= nil
    
    if Config.Debug then
        if useQSMethod then
            print('^2[cm-backpacks] Using QS-Inventory CreateUsableItem method^0')
        else
            print('^2[cm-backpacks] Using standard registration method^0')
        end
    end
    
    for itemName, config in pairs(backpacks) do
        if useQSMethod then
            CreateUsableItem(itemName, function(source, item)
                UseBackpack(source, item)
            end)
        else
            CMBridge.RegisterUseable(itemName, function(source, item)
                UseBackpack(source, item)
            end)
        end
        
        if Config.Debug then
            print('^2[cm-backpacks] Registered useable item: ' .. itemName .. '^0')
        end
    end
end)

-- Event: Player used keybind to open backpack
RegisterNetEvent('cm-backpacks:server:keybindOpen')
AddEventHandler('cm-backpacks:server:keybindOpen', function()
    local source = source
    local items = CMBridge.GetPlayerItems(source)
    if not items then return end

    -- Find the first backpack in the player's inventory
    local foundItem = nil
    for _, item in pairs(items) do
        if item and CMBackpacks.IsBackpack(item.name) then
            foundItem = item
            break
        end
    end

    if not foundItem then
        CMBridge.Notify(source, 'You don\'t have a backpack.', 'error')
        return
    end

    UseBackpack(source, foundItem)
end)

-- Clean up stale entries periodically
CreateThread(function()
    while true do
        Wait(300000) -- Check every 5 minutes
        
        local currentTime = os.time()
        for backpackId, data in pairs(openBackpacks) do
            if currentTime - data.timestamp > 1800 then
                CMBackpacks.DebugPrint('Cleaning up stale backpack: ' .. backpackId)
                openBackpacks[backpackId] = nil
            end
        end
    end
end)
