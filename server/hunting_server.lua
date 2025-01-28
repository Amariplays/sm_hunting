local QBCore = exports['qb-core']:GetCoreObject()

-- Награды за добычу
local rewards = {
    deer_carcass = {
        items = {
            {name = "meat", amount = 4},
            {name = "leather", amount = 2}
        },
        money = 25
    },
    rabbit_carcass = {
        items = {
            {name = "meat", amount = 1},
            {name = "leather", amount = 1}
        },
        money = 15
    },
    mtlion_carcass = {
        items = {
            {name = "meat", amount = 3},
            {name = "leather", amount = 3}
        },
        money = 50
    },
    bird_carcass = {
        items = {
            {name = "meat", amount = 1},
            {name = "feathers", amount = 2}
        },
        money = 5
    }
}

-- Проверка лицензии на оружие
QBCore.Functions.CreateCallback('hunting:checkWeaponLicense', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local licenseTable = Player.PlayerData.metadata["licences"]
    
    if licenseTable.weapon then
        cb(true)
    else
        cb(false)
    end
end)

local QBCore = exports['qb-core']:GetCoreObject()

-- Event for harvesting animal reward
RegisterServerEvent('hunting:harvestAnimal', function(reward)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.AddItem(reward, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[reward], 'add')
    end
end)
