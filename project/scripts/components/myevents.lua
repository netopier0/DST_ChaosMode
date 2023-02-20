local GLOBAL = _G
local net = GLOBAL.TheNet
local player = GLOBAL.AllPlayers[1]

local event_holder = nil

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------- Helper functions ----------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

local function givePlayerItem(item, count)
    local ents = GLOBAL.Ents
    for i = 1, count or 1 do
        local inst = ents[TheSim:SpawnPrefab(item)]
        if inst == nil then
            print("Cant spawn item" .. item)
            return
        end
        player.components.inventory:GiveItem(inst)
    end
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
----------------- Visual change ------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function GrowGiant(rev)
    local size
    if rev then
        size = 1
    else
        size = 3
        local chat_string = "Giant"
        net:Announce(chat_string)
    end
    player.Transform:SetScale(size,size,size)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "myEvents", 1 / size)
end

local function GrowTiny(rev)
    local size
    if rev then
        size = 1
    else
        size = 0.25
        local chat_string = "Tiny"
        net:Announce(chat_string)
    end
    player.Transform:SetScale(size,size,size)
    player.components.locomotor:SetExternalSpeedMultiplier(player, "myEvents", 1 / size)
end

local function hideCrafting(rev)
    if rev then
        player.HUD.controls.craftingmenu:Show()
        return
    end
    player.HUD.controls.craftingmenu:Close()
    player.HUD.controls.craftingmenu:Hide()
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
------------------ Stats change ------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function fullHealth(rev)
    if rev then return end
    player.components.health:SetPercent(1)
    local chat_string = "Full heal"
    net:Announce(chat_string)
end

local function halfHealth(rev)
    if rev then return end
    player.components.health:SetPercent(0.5)
    local chat_string = "Health = 50%"
    net:Announce(chat_string)
end

local function oneHealth(rev)
    if rev then return end
    player.components.health:SetPercent(0.001)
    local chat_string = "one Hp"
    net:Announce(chat_string)
end

local function fullSanity(rev)
    if rev then return end
    player.components.sanity:SetPercent(1)
    local chat_string = "Full sanity"
    net:Announce(chat_string)
end

local function halfSanity(rev)
    if rev then return end
    --local player = GLOBAL.ThePlayer
    player.components.sanity:SetPercent(0.5)
    local chat_string = "sanity = 50%"
    net:Announce(chat_string)
end

local function zeroSanity(rev)
    if rev then return end
    player.components.sanity:SetPercent(0.001)
    local chat_string = "zero sanity"
    net:Announce(chat_string)
end

local function fullHunger(rev)
    if rev then return end
    player.components.hunger:SetPercent(1)
    local chat_string = "Full hunger"
    net:Announce(chat_string)
end

local function halfHunger(rev)
    if rev then return end
    player.components.hunger:SetPercent(0.5)
    local chat_string = "Hunger = 50%"
    net:Announce(chat_string)
end

local function zeroHunger(rev)
    if rev then return end
    player.components.hunger:SetPercent(0.000001)
    local chat_string = "zero hunger"
    net:Announce(chat_string)
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------- Inventory change ----------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function dropInventory(rev)
    if rev then return end
    player.components.inventory:DropEverything()
    local chat_string = "Drop Inventory"
    net:Announce(chat_string)
end

local function dropHand(rev)
    if rev then return end
    local curr_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if curr_item ~= nil then
        player.components.inventory:DropItem(curr_item)
    end
    local chat_string = "Drop Hands"
    net:Announce(chat_string)
end

local function dropArmour(rev)
    if rev then return end
    local curr_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
    if curr_item ~= nil then
        player.components.inventory:DropItem(curr_item)
    end
    curr_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
    if curr_item ~= nil then
        player.components.inventory:DropItem(curr_item)
    end
    local chat_string = "Drop Armour"
    net:Announce(chat_string)
end

local function shuffleInventory(rev)
    if rev then return end
    local current_inventory = {}
    --Load items
    for i = 1,15 do
        current_inventory[i] = player.components.inventory:RemoveItemBySlot(i)
    end
    --Shuffle items
    for i = 1, 50 do
        local x = (i % 15) + 1
        local y = math.random(x, 15)
        current_inventory[x], current_inventory[y] = current_inventory[y], current_inventory[x]
    end
    --Store items
    for i = 1,15 do
        if current_inventory[i] ~= nil then
            player.components.inventory:GiveItem(current_inventory[i], i)
        end
    end
    local chat_string = "Shuffle inventory"
    net:Announce(chat_string)
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------------------- Effects ---------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function makeCold(rev)
    if rev then return end
    player.components.temperature:SetTemperature(0)
    local chat_string = "Cold"
    net:Announce(chat_string)
end

local function makeHot(rev)
    if rev then return end
    player.components.temperature:SetTemperature(50)
    local chat_string = "Hot"
    net:Announce(chat_string)
end

local function makeWeak(rev)
    if rev then player.components.combat.damagemultiplier = 1 return end
    player.components.combat.damagemultiplier = 0.25
    local chat_string = "Weak"
    net:Announce(chat_string)
end

local function makeStrong(rev)
    if rev then player.components.combat.damagemultiplier = 1 return end
    player.components.combat.damagemultiplier = 2
    local chat_string = "Strong"
    net:Announce(chat_string)
end

local function healthRegen(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        return
    end
    event_holder = player:DoPeriodicTask(1.5, function()
        if player.components.health:GetPercent() < 1 then
            player.components.health:SetPercent(player.components.health:GetPercent() + 0.02)
        end
    end)
end

local function hungerRegen(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        return
    end
    event_holder = player:DoPeriodicTask(1.5, function()
        if player.components.hunger:GetPercent() < 1 then
            player.components.hunger:SetPercent(player.components.hunger:GetPercent() + 0.02)
        end
    end)
end

local function sanityRegen(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        return
    end
    event_holder = player:DoPeriodicTask(1.5, function()
        if player.components.sanity:GetPercent() < 1 then
            player.components.sanity:SetPercent(player.components.sanity:GetPercent() + 0.02)
        end
    end)
end

local function moveUp(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        player.components.locomotor:Stop()
        return
    end
    event_holder = player:DoPeriodicTask(0.01, function()
        player.components.locomotor:RunInDirection(180 - GLOBAL.TheCamera:GetHeading())
    end)
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------------- Environment Effects ---------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

local function spawnLightning(rev)
    if rev then return end
    TheWorld:PushEvent("ms_sendlightningstrike", ConsoleWorldPosition())
end

local function spawnMeteor(rev)
    if rev then return end
    local x, y, z = player:GetPosition():Get()
    local ents = GLOBAL.Ents
    local inst = ents[TheSim:SpawnPrefab("shadowmeteor")]
    inst.Transform:SetPosition(x, y, z)
end

local function rainingFrogs(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        return
    end
    event_holder = player:DoPeriodicTask(0.33, function()
        local n = math.random(20)
        if n < 10 then
            return
        end
        local x, y, z = player:GetPosition():Get()
        local ents = GLOBAL.Ents
        local inst = ents[TheSim:SpawnPrefab("frog")]
        inst.sg:GoToState("fall")
        inst.Transform:SetPosition(x + math.random(-15, 15), 35, z + math.random(-15, 15))
    end)
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
------------------ Entity spawn ------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


-- player:GetPosition():Get() == player.Transform:GetWorldPosition()
-- x,z su pre pohyb, y je pre výšku
--player.Transform:SetPosition(x + 2, y, z)
local function treePrison(rev)
    if rev then return end
    local x, y, z = player:GetPosition():Get()
    local ents = GLOBAL.Ents
    local inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x+2, y, z)
    inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x+1, y, z+1)
    inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x, y, z+2)
    inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x-1, y, z+1)
    inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x-2, y, z)
    inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x-1, y, z-1)
    inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x, y, z-2)
    inst = ents[TheSim:SpawnPrefab("evergreen_normal")]
    inst.Transform:SetPosition(x+1, y, z-1)
end

local function treesAttackClose(rev)
    if rev then return end
    local x, y, z = player:GetPosition():Get()
    local ents = GLOBAL.Ents
    local inst = ents[TheSim:SpawnPrefab("leif")]
    inst.Transform:SetPosition(x, y, z)
end

local function treesAttackRange(rev)
    if rev then return end
    local x, y, z = player:GetPosition():Get()
    local ents = GLOBAL.Ents
    local inst = ents[TheSim:SpawnPrefab("deciduoustree")]
    inst.Transform:SetPosition(x, y, z)
    inst:StartMonster(true)
end

local function spawnButterflies(rev)
    if rev then return end
    local x, y, z = player:GetPosition():Get()
    local ents = GLOBAL.Ents
    local n = math.random(20)
    for i = 1, n do
        local inst = ents[TheSim:SpawnPrefab("butterfly")]
        inst.Transform:SetPosition(x + math.random(-15, 15), y, z + math.random(-15, 15))
    end
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
------------------- Item spawn -------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

local function starterTools(rev)
    if rev then return end
    givePlayerItem("axe")
    givePlayerItem("pickaxe")
    givePlayerItem("shovel")
    givePlayerItem("farm_hoe")
    givePlayerItem("spear")
end

local function shrooms(rev)
    if rev then return end
    givePlayerItem("red_cap", 10)
    givePlayerItem("green_cap", 10)
    givePlayerItem("blue_cap", 10)
end

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------------- Class declaration ----------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local MagicEvents = Class(function (self)
    --[==[
    self.random_events = {GrowGiant, GrowTiny, hideCrafting, --[[oneHealth,]] halfHealth, fullHealth,
    --[[zeroSanity,]] halfSanity, fullSanity, --[[zeroHunger,]] halfHunger, fullHunger,
    dropInventory, dropHand, dropArmour, shuffleInventory, makeCold, makeHot, makeWeak, makeStrong,
    treePrison, treesAttackClose, treesAttackRange, spawnButterflies}
    --]==]
    
    -- to test: hideCrafting, GrowGiant, GrowTiny
    self.random_events = {shuffleInventory, moveUp, moveUp}
    self.random_events_names = {"shuffleInventory", "moveUp", "moveUp"}
    --[==[
    --TODO Change Names of events
    self.random_events_names = {"GrowGiant", "GrowTiny", "hideCrafting", --[[oneHealth,]] "halfHealth", "fullHealth", 
    --[[zeroSanity,]] "halfSanity", "fullSanity", --[[zeroHunger,]] "halfHunger", "fullHunger",
    "dropInventory", "dropHand", "dropArmour", "shuffleInventory", "makeCold", "makeHot", "makeWeak", "makeStrong",
    "treePrison", "treesAttackClose", "treesAttackRange", "spawnButterflies"}
    --]==]
    self.last_event = nil
    self.curr_events = {}
    self.curr_events_names = {}
end)

--[=[
-- newline == medzere
local random_events = {GrowGiant, GrowTiny, --[[oneHealth,]] halfHealth, fullHealth, 
--[[zeroSanity,]] halfSanity, fullSanity, --[[zeroHunger,]] halfHunger, fullHunger,
treePrison, dropInventory, makeCold, makeHot, makeWeak, makeStrong}

local random_events_names = {"GrowGiant", "GrowTiny", --[[oneHealth,]] "halfHealth", "fullHealth", 
--[[zeroSanity,]] "halfSanity", "fullSanity", --[[zeroHunger,]] "halfHunger", "fullHunger",
"treePrison", "dropInventory", "makeCold", "makeHot", "makeWeak", "makeStrong"}
]=]

function MagicEvents:generate_random_event()
    --TODO set math.randomseed()
    local x = math.random(#self.random_events)
    self.curr_events[1] = self.random_events[x]
    self.curr_events_names[1] = self.random_events_names[x]
    self.curr_events[2] = nil --So new event will be generated
    while self.curr_events[1] == self.curr_events[2] or self.curr_events[2] == nil do
        x = math.random(#self.random_events)
        self.curr_events[2] = self.random_events[x]
        self.curr_events_names[2] = self.random_events_names[x]
    end
end

function MagicEvents:execute_random_event(event_num)
    if self.curr_events == nil or #self.curr_events == 0 then
        player = GLOBAL.ThePlayer or GLOBAL.AllPlayers[1]
        self.generate_random_event(self)
        net:Announce("1: " .. self.curr_events_names[1])
        net:Announce("2: " .. self.curr_events_names[2])
        return self.curr_events_names[1], self.curr_events_names[2]
    end
    if player == nil then
        print("Player == Nil")
    end
    if self.last_event ~= nil then
        self.last_event("ret") -- Does not matter value, parameter just can't be nil
    end
    self.curr_events[event_num](nil)
    self.last_event = self.curr_events[event_num]
    self.generate_random_event(self)
    net:Announce("1: " .. self.curr_events_names[1])
    net:Announce("2: " .. self.curr_events_names[2])

    return self.curr_events_names[1], self.curr_events_names[2]
end

return MagicEvents()