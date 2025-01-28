Config = {}

Config.Lang = "ru" -- Available options: "eng", "ru"

-- Main Hunting Settings
Config.HuntingZone = vector3(-1498.12, 4578.19, 35.36) -- Hunting zone coordinates
Config.SpawnRadius = 750.0 -- Radius for spawning animals
Config.ZoneCheckRadius = 800.0 -- Radius for checking if the player is in the hunting zone

-- Map Markers
Config.Markers = {
    Start = vector3(-1493.67, 4971.6, 63.91), -- Start hunting point
    End = vector3(-1491.92, 4975.19, 63.73), -- End hunting point
}

-- Animal Spawn Settings
Config.MaxAnimals = 10 -- Maximum number of animals in the zone
Config.SpawnChance = { -- Spawn chance for each animal (in percentages)
    ["a_c_deer"] = 40,
    ["a_c_rabbit_01"] = 30,
    ["a_c_mtlion"] = 20,
    ["a_c_crow"] = 10,
}

-- List of Animals
Config.Animals = {
    {
        name = "deer",
        model = "a_c_deer",
        reward = "deer_carcass"
    },
    {
        name = "rabbit",
        model = "a_c_rabbit_01",
        reward = "rabbit_carcass"
    },
    {
        name = "mtlion",
        model = "a_c_mtlion",
        reward = "mtlion_carcass"
    },
    {
        name = "crow",
        model = "a_c_crow",
        reward = "bird_carcass"
    }
}

-- qb-target Settings
Config.Target = {
    Enabled = true, -- Enable or disable qb-target interactions
    Harvest = {
        label = "Harvest Animal",
        icon = "fas fa-hand-paper", -- Icon for harvesting
        distance = 2.0 -- Interaction distance
    },
    Markers = {
        Start = {
            label = "Start Hunting",
            icon = "fas fa-play", -- Icon for starting hunting
            distance = 2.0 -- Interaction distance
        },
        End = {
            label = "End Hunting",
            icon = "fas fa-stop", -- Icon for ending hunting
            distance = 2.0 -- Interaction distance
        }
    }
}
