local startingSlots, maxSlots, slotIncrement = Config.startingSlots, Config.maxSlots, Config.slotIncrement
local defaultSlots = GetConvarInt("sv_playerSlots", 32)
local currentPlayerSlots = defaultSlots
local currentPlayerCount = 0

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    if defaultSlots ~= startingSlots then
        defaultSlots = startingSlots
        currentPlayerSlots = startingSlots
        SetConvar("sv_maxClients", startingSlots)
    end
end)

AddEventHandler("playerConnecting", function()
    currentPlayerCount = currentPlayerCount + 1
    if currentPlayerCount < currentPlayerSlots then return end

    currentPlayerSlots = currentPlayerSlots + slotIncrement
    if currentPlayerSlots > maxSlots then currentPlayerSlots = maxSlots end

    SetConvar("sv_maxClients", currentPlayerSlots)
end)

AddEventHandler("playerDropped", function()
    currentPlayerCount = currentPlayerCount - 1
    if currentPlayerCount > currentPlayerSlots - slotIncrement then return end

    currentPlayerSlots = currentPlayerSlots - slotIncrement
    if currentPlayerSlots < startingSlots then currentPlayerSlots = startingSlots end

    SetConvar("sv_maxClients", currentPlayerSlots)
end)