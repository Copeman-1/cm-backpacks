-- Main client logic for backpack management
local currentBackpacks = {}
local playerLoaded = false

-- Get current backpacks from player inventory
local function UpdateBackpackList()
    local items = {}
    local playerData = CMBridge.GetPlayerData()
    
    if not playerData then return {} end
    
    -- Get items based on inventory system
    if CMBridge.Inventory == 'ox_inventory' then
        items = exports.ox_inventory:GetPlayerItems()
    else
        items = playerData.items or {}
    end
    
    local backpacks = {}
    local count = 0
    
    for slot, item in pairs(items) do
        if item and CMBackpacks.IsBackpack(item.name) then
            local metadata = CMBridge.Inventory == 'ox_inventory' and item.metadata or item.info
            
            if metadata and metadata.id then
                table.insert(backpacks, {
                    name = item.name,
                    slot = slot,
                    id = metadata.id,
                    metadata = metadata
                })
                count = count + 1
            end
        end
    end
    
    return backpacks, count
end

-- Player loaded event
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerLoaded = true
    currentBackpacks = {}
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    playerLoaded = false
    currentBackpacks = {}
end)

-- ESX player loaded
RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    playerLoaded = true
    currentBackpacks = {}
end)

-- Inventory update events
RegisterNetEvent('QBCore:Player:SetPlayerData', function(PlayerData)
    if playerLoaded then
        local backpacks, count = UpdateBackpackList()
        currentBackpacks = backpacks
    end
end)

-- ox_inventory events
if CMBridge.Inventory == 'ox_inventory' then
    RegisterNetEvent('ox_inventory:updateInventory', function()
        if playerLoaded then
            local backpacks, count = UpdateBackpackList()
            currentBackpacks = backpacks
        end
    end)
end

-- Initialize on resource start if player already loaded
CreateThread(function()
    Wait(1000)
    if CMBridge.GetPlayerData() then
        playerLoaded = true
        local backpacks, count = UpdateBackpackList()
        currentBackpacks = backpacks
    end
end)

-- Export functions
exports('GetCurrentBackpacks', function()
    return currentBackpacks
end)

exports('UpdateBackpackList', function()
    return UpdateBackpackList()
end)


