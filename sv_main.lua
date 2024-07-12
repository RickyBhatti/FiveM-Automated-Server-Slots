local print = print
local GetCurrentResourceName = GetCurrentResourceName
local GetConvarInt = GetConvarInt
local SetConvar = SetConvar

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
        print("The default amount of slots has been changed to " .. startingSlots .. " slots.")
    end
end)

AddEventHandler("playerConnecting", function()
    currentPlayerCount = currentPlayerCount + 1
    if currentPlayerCount < currentPlayerSlots then return end

    currentPlayerSlots = currentPlayerSlots + slotIncrement
    if currentPlayerSlots > maxSlots then 
        currentPlayerSlots = maxSlots 
        print("The server has reached the maximum amount of slots, defaulting to " .. maxSlots .. " slots.")
    end

    SetConvar("sv_maxClients", currentPlayerSlots)
    print("The server has been adjusted to " .. currentPlayerSlots .. " slots from " .. currentPlayerSlots - slotIncrement .. " slots.")
end)

AddEventHandler("playerDropped", function()
    currentPlayerCount = currentPlayerCount - 1
    if currentPlayerCount > currentPlayerSlots - slotIncrement then return end

    currentPlayerSlots = currentPlayerSlots - slotIncrement
    if currentPlayerSlots < startingSlots then 
        currentPlayerSlots = startingSlots 
        print("The server has reached the minimum amount of slots, defaulting to " .. startingSlots .. " slots.")
    end

    SetConvar("sv_maxClients", currentPlayerSlots)
    print("The server has been adjusted to " .. currentPlayerSlots .. " slots from " .. currentPlayerSlots + slotIncrement .. " slots.")
end)