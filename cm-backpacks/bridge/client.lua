-- Client-side framework bridge with auto-detection
CMBridge = {}
CMBridge.Framework = nil
CMBridge.Inventory = nil
CMBridge.Clothing = nil

local PlayerData = {}
local PlayerLoaded = false

-- Detect Framework
local function DetectFramework()
    if Config.Framework then
        return Config.Framework
    end
    
    -- Check for QBox (newer fork)
    if GetResourceState('qbx_core') == 'started' then
        return 'qbox'
    end
    
    -- Check for QBCore
    if GetResourceState('qb-core') == 'started' then
        return 'qb-core'
    end
    
    -- Check for ESX
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
    
    -- Check for ox_inventory
    if GetResourceState('ox_inventory') == 'started' then
        return 'ox_inventory'
    end
    
    -- Check for qb-inventory
    if GetResourceState('qb-inventory') == 'started' then
        return 'qb-inventory'
    end
    
    -- Check for qs-inventory
    if GetResourceState('qs-inventory') == 'started' then
        return 'qs-inventory'
    end
    
    -- Check for ps-inventory
    if GetResourceState('ps-inventory') == 'started' then
        return 'ps-inventory'
    end
    
    return 'qb-inventory' -- Default fallback
end

-- Detect Clothing System
local function DetectClothing()
    if Config.ClothingScript then
        return Config.ClothingScript
    end
    
    -- Check for illenium-appearance
    if GetResourceState('illenium-appearance') == 'started' then
        return 'illenium-appearance'
    end
    
    -- Check for fivem-appearance
    if GetResourceState('fivem-appearance') == 'started' then
        return 'fivem-appearance'
    end
    
    -- Check for qb-clothing
    if GetResourceState('qb-clothing') == 'started' then
        return 'qb-clothing'
    end
    
    -- Check for esx_skin
    if GetResourceState('esx_skin') == 'started' then
        return 'esx_skin'
    end
    
    return 'illenium-appearance' -- Default fallback
end

-- Initialize Framework
function CMBridge.InitFramework()
    CMBridge.Framework = DetectFramework()
    CMBridge.Inventory = DetectInventory()
    CMBridge.Clothing = DetectClothing()
    
    print('^2[cm-backpacks] Framework: ' .. (CMBridge.Framework or 'NONE') .. '^0')
    print('^2[cm-backpacks] Inventory: ' .. CMBridge.Inventory .. '^0')
    print('^2[cm-backpacks] Clothing: ' .. CMBridge.Clothing .. '^0')
    
    if CMBridge.Framework == 'qb-core' then
        local QBCore = exports['qb-core']:GetCoreObject()
        
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
            PlayerData = QBCore.Functions.GetPlayerData()
            PlayerLoaded = true
            TriggerEvent('cm-backpacks:client:playerLoaded')
        end)
        
        RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
            PlayerData = {}
            PlayerLoaded = false
            TriggerEvent('cm-backpacks:client:playerUnloaded')
        end)
        
        RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
            PlayerData = data
        end)
        
    elseif CMBridge.Framework == 'qbox' then
        local QBCore = exports.qbx_core:GetCoreObject()
        
        RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
            PlayerData = QBCore.Functions.GetPlayerData()
            PlayerLoaded = true
            TriggerEvent('cm-backpacks:client:playerLoaded')
        end)
        
        RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
            PlayerData = {}
            PlayerLoaded = false
            TriggerEvent('cm-backpacks:client:playerUnloaded')
        end)
        
        RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
            PlayerData = data
        end)
        
    elseif CMBridge.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
        
        RegisterNetEvent('esx:playerLoaded', function(xPlayer)
            PlayerData = xPlayer
            PlayerLoaded = true
            TriggerEvent('cm-backpacks:client:playerLoaded')
        end)
        
        RegisterNetEvent('esx:onPlayerLogout', function()
            PlayerData = {}
            PlayerLoaded = false
            TriggerEvent('cm-backpacks:client:playerUnloaded')
        end)
    end
end

-- Get Player Data
function CMBridge.GetPlayerData()
    if CMBridge.Framework == 'qb-core' or CMBridge.Framework == 'qbox' then
        local QBCore = CMBridge.Framework == 'qbox' and exports.qbx_core:GetCoreObject() or exports['qb-core']:GetCoreObject()
        return QBCore.Functions.GetPlayerData()
    elseif CMBridge.Framework == 'esx' then
        return ESX.GetPlayerData()
    end
    return PlayerData
end

-- Check if player is loaded
function CMBridge.IsPlayerLoaded()
    return PlayerLoaded
end

-- Notifications
function CMBridge.Notify(message, type, duration)
    type = type or 'info'
    duration = duration or 5000
    
    if CMBridge.Framework == 'qb-core' or CMBridge.Framework == 'qbox' then
        local QBCore = CMBridge.Framework == 'qbox' and exports.qbx_core:GetCoreObject() or exports['qb-core']:GetCoreObject()
        QBCore.Functions.Notify(message, type, duration)
    elseif CMBridge.Framework == 'esx' then
        ESX.ShowNotification(message)
    else
        -- Fallback to basic notification
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, false)
    end
end

-- Progress Bar
function CMBridge.Progress(label, duration, callback)
    if GetResourceState('progressbar') == 'started' then
        exports['progressbar']:Progress({
            name = 'backpack_action',
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true
            }
        }, callback)
    elseif GetResourceState('qb-core') == 'started' then
        local QBCore = exports['qb-core']:GetCoreObject()
        QBCore.Functions.Progressbar('backpack_action', label, duration, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        }, {}, {}, {}, callback)
    else
        -- Fallback: just wait
        Citizen.Wait(duration)
        if callback then callback(false) end
    end
end

-- Get Player Job
function CMBridge.GetJob()
    local playerData = CMBridge.GetPlayerData()
    
    if CMBridge.Framework == 'qb-core' or CMBridge.Framework == 'qbox' then
        return playerData.job and playerData.job.name or nil
    elseif CMBridge.Framework == 'esx' then
        return playerData.job and playerData.job.name or nil
    end
    
    return nil
end

-- Get Player Identifier
function CMBridge.GetIdentifier()
    local playerData = CMBridge.GetPlayerData()
    
    if CMBridge.Framework == 'qb-core' or CMBridge.Framework == 'qbox' then
        return playerData.citizenid
    elseif CMBridge.Framework == 'esx' then
        return playerData.identifier
    end
    
    return nil
end

-- Get Ped Gender
function CMBridge.GetGender(ped)
    ped = ped or PlayerPedId()
    
    if CMBridge.Clothing == 'illenium-appearance' or CMBridge.Clothing == 'fivem-appearance' then
        local model = GetEntityModel(ped)
        if model == GetHashKey('mp_m_freemode_01') then
            return 'male'
        elseif model == GetHashKey('mp_f_freemode_01') then
            return 'female'
        end
    end
    
    -- Fallback to native check
    if IsPedMale(ped) then
        return 'male'
    else
        return 'female'
    end
end

-- Get Current Appearance
function CMBridge.GetAppearance()
    if CMBridge.Clothing == 'illenium-appearance' then
        return exports['illenium-appearance']:getPedAppearance(PlayerPedId())
    elseif CMBridge.Clothing == 'fivem-appearance' then
        return exports['fivem-appearance']:getPedAppearance(PlayerPedId())
    elseif CMBridge.Clothing == 'qb-clothing' then
        -- QBCore clothing format
        local ped = PlayerPedId()
        local appearance = {}
        
        for i = 0, 11 do
            appearance[i] = {
                drawable = GetPedDrawableVariation(ped, i),
                texture = GetPedTextureVariation(ped, i)
            }
        end
        
        return appearance
    end
    
    return {}
end

-- Set Clothing Component
function CMBridge.SetClothing(component, drawable, texture)
    local ped = PlayerPedId()
    
    if CMBridge.Clothing == 'illenium-appearance' then
        local appearance = exports['illenium-appearance']:getPedAppearance(ped)
        if not appearance.components then appearance.components = {} end
        appearance.components[component] = { drawable = drawable, texture = texture }
        exports['illenium-appearance']:setPedAppearance(ped, appearance)
        
    elseif CMBridge.Clothing == 'fivem-appearance' then
        exports['fivem-appearance']:setClothes(ped, component, { drawable = drawable, texture = texture })
        
    elseif CMBridge.Clothing == 'qb-clothing' then
        SetPedComponentVariation(ped, component, drawable, texture, 0)
        
    elseif CMBridge.Clothing == 'esx_skin' then
        TriggerEvent('skinchanger:change', 'bags_1', drawable)
        TriggerEvent('skinchanger:change', 'bags_2', texture)
    else
        -- Fallback to native
        SetPedComponentVariation(ped, component, drawable, texture, 0)
    end
end

-- Input Dialog
function CMBridge.Input(header, inputs)
    if GetResourceState('qb-input') == 'started' then
        local dialog = exports['qb-input']:ShowInput({
            header = header,
            submitText = "Submit",
            inputs = inputs
        })
        return dialog
    elseif GetResourceState('ox_lib') == 'started' then
        local input = lib.inputDialog(header, inputs)
        if input then
            local result = {}
            for i, v in ipairs(inputs) do
                result[v.name] = input[i]
            end
            return result
        end
        return nil
    else
        -- Fallback text input
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128)
        while UpdateOnscreenKeyboard() == 0 do
            Wait(0)
        end
        
        if GetOnscreenKeyboardResult() then
            local result = GetOnscreenKeyboardResult()
            return { [inputs[1].name] = result }
        end
        return nil
    end
end

-- Initialize on resource start
CreateThread(function()
    Wait(500)
    CMBridge.InitFramework()
end)
