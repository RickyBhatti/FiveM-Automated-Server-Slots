local print = print
local GetCurrentResourceName = GetCurrentResourceName
local GetConvarInt = GetConvarInt
local SetConvar = SetConvar

local startingSlots, slotIncrement, maxSlots = Config.startingSlots, Config.slotIncrement, Config.maxSlots

local defaultSlots = GetConvarInt("sv_playerSlots", 32)
local currentPlayerSlots = defaultSlots
local currentPlayerCount = 0

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    if defaultSlots == startingSlots then return end

    defaultSlots = startingSlots
    currentPlayerSlots = startingSlots
    SetConvar("sv_maxClients", startingSlots)
    print("The default amount of slots has been changed to " .. startingSlots .. " slots.")
end)

AddEventHandler("playerConnecting", function()
    currentPlayerCount = currentPlayerCount + 1
    if currentPlayerCount < currentPlayerSlots then return end

    currentPlayerSlots = currentPlayerSlots + slotIncrement
    if currentPlayerSlots > maxSlots then 
        currentPlayerSlots = maxSlots
        print("The server has reached the maximum amount of slots defined in the configuration file, defaulting to " .. maxSlots .. " slots.")
    end

    SetConvar("sv_maxClients", currentPlayerSlots)
    print("Player slots have been increased to " .. currentPlayerSlots .. " slots from " .. currentPlayerSlots - slotIncrement .. " slots, current player count: " .. currentPlayerCount)
end)

AddEventHandler("playerDropped", function()
    currentPlayerCount = currentPlayerCount - 1
    if currentPlayerCount > currentPlayerSlots - slotIncrement then return end

    currentPlayerSlots = currentPlayerSlots - slotIncrement
    if currentPlayerSlots < startingSlots then 
        currentPlayerSlots = startingSlots 
        print("The server has reached the minimum amount of slots defined in the configuration file, defaulting to " .. startingSlots .. " slots.")
    end

    SetConvar("sv_maxClients", currentPlayerSlots)
    print("Player slots have been decreased to " .. currentPlayerSlots .. " slots from " .. currentPlayerSlots + slotIncrement .. " slots, current player count: " .. currentPlayerCount)
end)