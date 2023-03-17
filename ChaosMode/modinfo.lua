name = "Chat Plays"
description = "Let twitch chat ruin your game."
author = "Cesnek"
version = "0.5"

forumthread = "/"
--icon atlas = "modicom.xml"
--icon = "modicon.tex"

client_only_mod = true
dst_compatible = true

api_version = 10

configuration_options = {
    {
        name = "Debug Mode",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = false
    },

    {
        name = "Timer",
        options = {
            {description = "30s", data = 30},
            {description = "45s", data = 45},
            {description = "60s", data = 60},
            {description = "75s", data = 75},
            {description = "90s", data = 90},
            {description = "120s", data = 120},
        },
        default = 60
    },

    {
        name = "GrowGiant",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "GrowTiny",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "hideCrafting",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fullHealth",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fullHunger",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fullSanity",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "halfHealth",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "halfHunger",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "halfSanity",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "oneHealth",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "zeroHunger",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "zeroSanity",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "speedup",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "slowdown",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropInventory",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropArmour",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropHand",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropHandOverTime",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportLag",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "makeHot",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "makeCold",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "shuffleInventory",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "healthRegen",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "hungerRegen",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "sanityRegen",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "poison",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnLightning",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnMeteor",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "rainingFrogs",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "rain",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "nightFalls",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "wakeUp",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "tileChanger",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnEvilFlowers",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "treePrison",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fruitFly",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "treesAttackClose",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "treesAttackRange",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnButterflies",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnHounds",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnSheep",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnWarg",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnTentacles",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "starterTools",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fakeGoldTools",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "shrooms",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "nightVisionEffect",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnFirePit",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnIcePit",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "ghostScreen",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportRandom",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportHermit",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportSpawn",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

}