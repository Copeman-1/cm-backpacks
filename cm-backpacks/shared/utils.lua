-- Shared utility functions
CMBackpacks = {}
CMBackpacks.Framework = nil
CMBackpacks.InventorySystem = nil
CMBackpacks.ClothingSystem = nil

-- Debug print function (only prints if Config.Debug is true)
function CMBackpacks.DebugPrint(message, level)
    if not Config.Debug then return end
    
    level = level or 'info'
    local prefix = '^3[cm-backpacks DEBUG]^0'
    
    if level == 'error' then
        prefix = '^1[cm-backpacks ERROR]^0'
    elseif level == 'success' then
        prefix = '^2[cm-backpacks SUCCESS]^0'
    elseif level == 'warning' then
        prefix = '^1[cm-backpacks WARNING]^0'
    end
    
    print(prefix .. ' ' .. message)
end

-- Cache backpack configurations
local BackpackCache = {}

-- Initialize backpack cache
function CMBackpacks.InitializeBackpacks()
    for _, backpack in ipairs(Config.Backpacks) do
        if not backpack.item then
            print('^1[cm-backpacks] ERROR: Backpack configuration missing item name^0')
        else
            -- Convert whitelist/blacklist to hash tables for faster lookup
            if backpack.whitelist then
                local temp = {}
                for _, itemName in ipairs(backpack.whitelist) do
                    temp[string.lower(itemName)] = true
                end
                backpack.whitelist = temp
            end
            
            if backpack.blacklist then
                local temp = {}
                for _, itemName in ipairs(backpack.blacklist) do
                    temp[string.lower(itemName)] = true
                end
                backpack.blacklist = temp
            end
            
            BackpackCache[backpack.item] = backpack
        end
    end
end

-- Check if item is a backpack
function CMBackpacks.IsBackpack(itemName)
    return BackpackCache[itemName] ~= nil
end

-- Get backpack configuration
function CMBackpacks.GetBackpackConfig(itemName)
    return BackpackCache[itemName]
end

-- Get all backpack configurations
function CMBackpacks.GetAllBackpacks()
    return BackpackCache
end

-- Check if item is allowed in backpack
function CMBackpacks.IsItemAllowed(backpackConfig, itemName)
    if not backpackConfig then return false end
    
    local lowerItemName = string.lower(itemName)
    
    -- Check whitelist (if exists, ONLY whitelisted items allowed)
    if backpackConfig.whitelist then
        return backpackConfig.whitelist[lowerItemName] == true
    end
    
    -- Check blacklist (if exists, blacklisted items NOT allowed)
    if backpackConfig.blacklist then
        return backpackConfig.blacklist[lowerItemName] ~= true
    end
    
    -- No restrictions
    return true
end

-- Generate unique ID for backpack (QS-Inventory compatible format)
function CMBackpacks.GenerateId(identifier, characterName)
    -- Generate random alphanumeric ID (10 characters) to match QS-Inventory format
    -- Example: 6430q2723i
    local chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    local id = ''
    for i = 1, 10 do
        local rand = math.random(1, #chars)
        id = id .. chars:sub(rand, rand)
    end
    return id
end

-- Get locale string
function CMBackpacks.Locale(key, ...)
    local locale = Config.Locales[Config.Locale] or Config.Locales['en']
    local str = locale[key] or key
    
    if ... then
        return string.format(str, ...)
    end
    
    return str
end

-- Initialize on resource start
CreateThread(function()
    CMBackpacks.InitializeBackpacks()
    if Config.Debug then
        print('^2[cm-backpacks] Loaded ' .. #Config.Backpacks .. ' backpack configurations^0')
    end
end)
