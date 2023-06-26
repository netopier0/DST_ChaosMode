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
        name = "Number of options",
        options = {
            {description = "2", data = 2},
            {description = "3", data = 3},
            {description = "4", data = 4},
        },
        default = 4
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
            {description = "5m", data = 300},
            {description = "10m", data = 600},
            {description = "15m", data = 900},
            {description = "20m", data = 1200},
            {description = "30m", data = 1800},
        },
        default = 60
    },

    {
        name = "Duration of event",
        options = {
            {description = "15s", data = 15},
            {description = "30s", data = 30},
            {description = "45s", data = 45},
            {description = "60s", data = 60},
            {description = "75s", data = 75},
            {description = "90s", data = 90},
            {description = "120s", data = 120},
            {description = "5m", data = 300},
            {description = "10m", data = 600},
            {description = "15m", data = 900},
            {description = "20m", data = 1200},
            {description = "30m", data = 1800},
        },
        default = 60
    },

    {
        name = "GrowGiant",
        label = "Giant",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "GrowTiny",
        label = "Tiny",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "hideCrafting",
        label = "No crafting",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fullHealth",
        label = "Restore health",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fullHunger",
        label = "Restore hunger",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fullSanity",
        label = "Restore sanity",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "halfHealth",
        label = "Half health",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "halfHunger",
        label = "Half hunger",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "halfSanity",
        label = "Half sanity",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "oneHealth",
        label = "One health",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "zeroHunger",
        label = "Zero hunger",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "zeroSanity",
        label = "Zero sanity",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "speedup",
        label = "Speed",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "slowdown",
        label = "Slow",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropInventory",
        label = "Drop inventory",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropArmour",
        label = "Drop armour",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropHand",
        label = "Drop hand",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "dropHandOverTime",
        label = "Slippery hands",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "rotAll",
        label = "Rot everything",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportLag",
        label = "Bad connection",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "makeHot",
        label = "Hot weather",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "makeCold",
        label = "Cold weather",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "shuffleInventory",
        label = "Inventory shuffle",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "healthRegen",
        label = "Health regeneration",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "hungerRegen",
        label = "Hunger regeneration",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "sanityRegen",
        label = "Sanity regeneration",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "poison",
        label = "Poison",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnLightning",
        label = "Lightning",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnMeteor",
        label = "Meteor",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "rainingFrogs",
        label = "Frog rain",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "rain",
        label = "Rain",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "nightFalls",
        label = "Night",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "wakeUp",
        label = "Morning",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "tileChanger",
        label = "Floor is changing",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnEvilFlowers",
        label = "Evil flowers",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "treePrison",
        label = "Tree prison",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fruitFly",
        label = "Fruit fly",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "treesAttackClose",
        label = "Trees attack (close)",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "treesAttackRange",
        label = "Trees attack (range)",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnButterflies",
        label = "Butterflies",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnHounds",
        label = "Hounds",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnSheep",
        label = "Sheep",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnWarg",
        label = "Warg",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnTentacles",
        label = "Tentacles",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "starterTools",
        label = "Starter tools",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "fakeGoldTools",
        label = "Gold tools (fake)",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "realGoldTools",
        label = "Gold tools (real)",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "shrooms",
        label = "Shrooms",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "nightVisionEffect",
        label = "Nightvision",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "wonkeyCurse",
        label = "Wonkey curse",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnFirePit",
        label = "Firepit",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "spawnIcePit",
        label = "Icepit",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "ghostScreen",
        label = "Ghost vision",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "goggleScreen",
        label = "Goggles vision",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = false
    },

    {
        name = "moonStorm",
        label = "Moonstorm",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportRandom",
        label = "Random tp",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportHermit",
        label = "Hermit tp",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

    {
        name = "teleportSpawn",
        label = "Spawn tp",
        options = {
            {description = "On", data = true},
            {description = "Off", data = false},
        },
        default = true
    },

}