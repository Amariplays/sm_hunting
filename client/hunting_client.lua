local QBCore = exports['qb-core']:GetCoreObject()
local isHunting = false
local spawnedAnimals = {}
local deadAnimals = {}

-- Function to check weapon license important!!
local function CheckWeaponLicense(callback)
    local Player = QBCore.Functions.GetPlayerData()
    local hasLicense = false

    if Player.metadata.licenses.weapon then
        hasLicense = true
    end

    callback(hasLicense)
end

-- Function to cleanup hunting
local function CleanupHunting()
    for _, animal in ipairs(spawnedAnimals) do
        DeleteEntity(animal.entity)
    end

    spawnedAnimals = {}
    isHunting = false
end

-- Function to spawn animals
local function SpawnAnimals()
    while isHunting and #spawnedAnimals < Config.MaxAnimals do
        local model, reward = nil, nil

        for animal, chance in pairs(Config.SpawnChance) do
            if math.random(0, 100) <= chance then
                model = animal
                for _, data in pairs(Config.Animals) do
                    if data.model == animal then
                        reward = data.reward
                        break
                    end
                end
                break
            end
        end

        if model and reward then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(10)
            end

            local x = math.random(-Config.SpawnRadius, Config.SpawnRadius)
            local y = math.random(-Config.SpawnRadius, Config.SpawnRadius)
            local z = Config.HuntingZone.z

            local animal = CreatePed(28, model, Config.HuntingZone.x + x, Config.HuntingZone.y + y, z, 0.0, true, true)
            SetEntityAsMissionEntity(animal, true, true)

            table.insert(spawnedAnimals, {entity = animal, reward = reward})
        end

        Wait(5000)
    end
end

-- Function to create harvesting prompt
local function CreateHarvestPrompt(entity, reward)
    if Config.Target.Enabled then
        exports['qb-target']:AddTargetEntity(entity, {
            options = {
                {
                    label = Config.Target.Harvest.label,
                    icon = Config.Target.Harvest.icon,
                    action = function()
                        TriggerServerEvent('hunting:harvestAnimal', reward)
                        DeleteEntity(entity)
                        deadAnimals[entity] = nil

                        for k, v in pairs(spawnedAnimals) do
                            if v.entity == entity then
                                table.remove(spawnedAnimals, k)
                                break
                            end
                        end

                        QBCore.Functions.Notify("Animal harvested successfully", "success")
                    end,
                },
            },
            distance = Config.Target.Harvest.distance
        })
    end
end

-- Function to setup hunting markers
local function SetupHuntingMarkers()
    if Config.Target.Enabled then
        -- Start marker
        exports['qb-target']:AddCircleZone("hunting_start", Config.Markers.Start, 1.5, {
            name = "hunting_start",
            debugPoly = false,
        }, {
            options = {
                {
                    label = Config.Target.Markers.Start.label,
                    icon = Config.Target.Markers.Start.icon,
                    action = function()
                        if not isHunting then
                            CheckWeaponLicense(function(hasLicense)
                                if hasLicense then
                                    isHunting = true
                                    SpawnAnimals()
                                    QBCore.Functions.Notify("Hunting started", "success")
                                else
                                    QBCore.Functions.Notify("You don't have a weapon license", "error")
                                end
                            end)
                        else
                            QBCore.Functions.Notify("You're already hunting", "error")
                        end
                    end,
                },
            },
            distance = Config.Target.Markers.Start.distance
        })

        -- End marker
        exports['qb-target']:AddCircleZone("hunting_end", Config.Markers.End, 1.5, {
            name = "hunting_end",
            debugPoly = false,
        }, {
            options = {
                {
                    label = Config.Target.Markers.End.label,
                    icon = Config.Target.Markers.End.icon,
                    action = function()
                        if isHunting then
                            CleanupHunting()
                            QBCore.Functions.Notify("Hunting ended", "success")
                        else
                            QBCore.Functions.Notify("You're not hunting", "error")
                        end
                    end,
                },
            },
            distance = Config.Target.Markers.End.distance
        })
    end
end

-- Start script
CreateThread(function()
    SetupHuntingMarkers()
end)
