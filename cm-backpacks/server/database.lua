-- No custom tables needed - inventory systems handle their own stash storage

CreateThread(function()
    -- QS-Inventory uses: inventory_stash (created by QS)
    -- QB-Inventory uses: stashitems (created by QB)
    -- OX-Inventory: Handles storage internally
    -- PS-Inventory uses: stashitems (created by PS)
    -- No custom tables required for basic backpack functionality!
    
    if Config.Debug then
        print('^2[cm-backpacks] Using inventory system native storage (no custom tables)^0')
    end
end)