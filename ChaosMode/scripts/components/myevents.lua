local GLOBAL = _G
local net = GLOBAL.TheNet
local player = GLOBAL.AllPlayers[1]

local event_holder = nil
local last_positions = nil
local last_item = nil
local last_tile = {}
local fn_player = 'local player = ThePlayer '


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------- Helper functions ----------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

local findPrefabsStr = 'local function findPrefabs(prefab, dist) ' ..
    'local x, y, z  = ThePlayer:GetPosition():Get() ' ..
    'local ents = TheSim:FindEntities(x,y,z, dist) ' ..
    'for k,v in pairs(ents) do ' ..
        'if v.prefab == prefab then ' ..
            'return v ' ..
        'end ' ..
    'end ' ..
'end '


local function generateRandomNumbers(range, n)
    if range < n then
        return {}
    end
    --math.randomseed(os.time())
    local result = {}
    while #result ~= n do
        local add = true
        local curr = math.random(range)
        for _, v in pairs(result) do
            if v == curr then
                add = false
                break
            end
        end
        if add then
            result[#result+1] = curr
        end
    end
    return result
end

function SendCommand(fnstr)
	local x, _, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
	local is_valid_time_to_use_remote = net:GetIsClient() and net:GetIsServerAdmin()
	if is_valid_time_to_use_remote then
		net:SendRemoteExecute(fnstr, x, z)
	else
		ExecuteConsoleCommand(fnstr)
	end
end

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
----------------- Visual change ------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function GrowGiant(rev)
    local fnstr = fn_player .. 'local size = '
    if rev then fnstr = fnstr .. '1 ' else fnstr = fnstr .. '3 ' end
    fnstr = fnstr .. 
    'player.Transform:SetScale(size,size,size) ' ..
    'player.components.locomotor:SetExternalSpeedMultiplier(player, "myEvents", 1 / size)'
    SendCommand(fnstr)
end

local function GrowTiny(rev)
    local fnstr = fn_player .. 'local size = '
    if rev then fnstr = fnstr .. '1 ' else fnstr = fnstr .. '0.25 ' end
    fnstr = fnstr .. 
    'player.Transform:SetScale(size,size,size) ' ..
    'player.components.locomotor:SetExternalSpeedMultiplier(player, "myEvents", 1 / size)'
    SendCommand(fnstr)
end

local function hideCrafting(rev)
    if rev then
        player.HUD.controls.craftingmenu:Show()
        return
    end
    player.HUD.controls.craftingmenu:Close()
    player.HUD.controls.craftingmenu:Hide()
end

local function ghostScreen(rev)
    if rev then
        player.components.playervision:SetGhostVision(false)
        return
    end 
    player.components.playervision:SetGhostVision(true)
end

local function goggleScreen(rev)
    if rev then
        player.components.playervision:ForceGoggleVision(false)
        return
    end 
    player.components.playervision:ForceGoggleVision(true)
end

local function moonStorm(rev)
    if rev then
        local fnstr = 'TheWorld:PushEvent("ms_stopthemoonstorms")'
        SendCommand(fnstr)
        return
    end
    local fnstr = 'TheWorld:PushEvent("ms_startthemoonstorms")'
    SendCommand(fnstr)
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------- Position change -----------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

--Not working with Lag Compensation: Predictive otherwise works fine
local function  teleportRandom(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local w, h = TheWorld.Map:GetSize() ' ..
	'w = (w - w/2) * TILE_SCALE ' ..
	'h = (h - h/2) * TILE_SCALE ' ..
	'local x, z = math.random() * w * 2, math.random() * h * 2 ' ..
    'while TheWorld.Map:IsOceanAtPoint(x - w, 0, z - h) or ' ..
        'TheWorld.Map:GetTileAtPoint(x - w, 0, z - h) == 1 or ' ..     --Outside of map 
        'TheWorld.Map:GetTileAtPoint(x - w, 0, z - h) == 65535 do ' .. --IMPASSABLE = 1, INVALID = 65535,
            'x, z = math.random() * w * 2, math.random() * h * 2 '..
    'end ' ..
    'player.Transform:SetPosition(x - w, 0, z - h)'
    SendCommand(fnstr)
end

--Not working with Lag Compensation: Predictive otherwise works fine
local function teleportSpawn(rev)
    if rev then return end
    local fnstr = findPrefabsStr .. fn_player ..
    'local inst = findPrefabs("multiplayer_portal", 9001) ' ..
    'if inst == nil then inst = findPrefabs("multiplayer_portal_moonrock", 9001) end ' ..
    'if inst ~= nil then ' ..
        'local x, y, z = inst.Transform:GetWorldPosition() ' ..
        'player.Transform:SetPosition(x, y, z) ' ..
    'end'
    SendCommand(fnstr)
end

local function teleportLag(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        last_positions = nil
        return
    end
    last_positions = {}
    event_holder = player:DoPeriodicTask(0.5, function()
        last_positions[#last_positions+1] = {player:GetPosition():Get()}
        if math.random() < .5 and 3 < #last_positions then
            local back_index = math.random(1, math.min(#last_positions - 1, 10))
            local tmp = last_positions[#last_positions - back_index]
            local fnstr = fn_player .. 
            'player.Transform:SetPosition( ' .. tmp[1] .. ', ' .. tmp[2] .. ', ' .. tmp[3] ..')'
            SendCommand(fnstr)
        end
    end)
end

--Not working with Lag Compensation: Predictive otherwise works fine
local function teleportHermit(rev)
    if rev then return end
    local fnstr = findPrefabsStr .. fn_player .. 
    'local inst = findPrefabs("hermitcrab", 9001) ' ..
    'if inst ~= nil then ' ..
        'local x, y, z = inst.Transform:GetWorldPosition() ' ..
        'player.Transform:SetPosition(x, y, z) ' ..
    'end'
    SendCommand(fnstr)
end

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
------------------ Stats change ------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function fullHealth(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.health:SetPercent(1) '
    SendCommand(fnstr)
    --local chat_string = "Full heal"
    --net:Announce(chat_string)
end

local function halfHealth(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.health:SetPercent(0.5)'
    SendCommand(fnstr)
    --local chat_string = "Health = 50%"
    --net:Announce(chat_string)
end

local function oneHealth(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.health:SetPercent(0.001)'
    SendCommand(fnstr)
    --local chat_string = "one Hp"
    --net:Announce(chat_string)
end

local function randomHealth(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.health:SetPercent(math.random())'
    SendCommand(fnstr)
    --local chat_string = "Random Hp"
    --net:Announce(chat_string)
end

local function fullSanity(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.sanity:SetPercent(1)'
    SendCommand(fnstr)
    --local chat_string = "Full sanity"
    --net:Announce(chat_string)
end

local function halfSanity(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.sanity:SetPercent(0.5)'
    SendCommand(fnstr)
    --local chat_string = "sanity = 50%"
    --net:Announce(chat_string)
end

local function zeroSanity(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.sanity:SetPercent(0.001)'
    SendCommand(fnstr)
    --local chat_string = "zero sanity"
    --net:Announce(chat_string)
end

local function randomSanity(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.sanity:SetPercent(math.random())'
    SendCommand(fnstr)
    --local chat_string = "Random sanity"
    --net:Announce(chat_string)
end

local function fullHunger(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.hunger:SetPercent(1)'
    SendCommand(fnstr)
    --local chat_string = "Full hunger"
    --net:Announce(chat_string)
end

local function halfHunger(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.hunger:SetPercent(0.5)'
    SendCommand(fnstr)
    --local chat_string = "Hunger = 50%"
    --net:Announce(chat_string)
end

local function zeroHunger(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.hunger:SetPercent(0.000001)'
    SendCommand(fnstr)
    --local chat_string = "zero hunger"
    --net:Announce(chat_string)
end

local function randomHunger(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.hunger:SetPercent(math.random())'
    SendCommand(fnstr)
    --local chat_string = "Random hunger"
    --net:Announce(chat_string)
end


--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
---------------- Inventory change ----------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function dropInventory(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.inventory:DropEverything()'
    SendCommand(fnstr)
    --local chat_string = "Drop Inventory"
    --net:Announce(chat_string)
end

local function dropHand(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local curr_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) ' ..
    'if curr_item ~= nil then player.components.inventory:DropItem(curr_item) end'
    SendCommand(fnstr)
    --local chat_string = "Drop Hands"
    --net:Announce(chat_string)
end

local function dropArmour(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local curr_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ' ..
    'if curr_item ~= nil then player.components.inventory:DropItem(curr_item) end ' ..
    'curr_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY) ' ..
    'if curr_item ~= nil then player.components.inventory:DropItem(curr_item) end'
    SendCommand(fnstr)
    --local chat_string = "Drop Armour"
    --net:Announce(chat_string)
end

local function shuffleInventory(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local current_inventory = {} ' ..
    --Load items
    'for i = 1, 15 do ' ..
        'current_inventory[i] = player.components.inventory:RemoveItemBySlot(i) ' ..
    'end ' ..
    --Shuffle items
    'for i = 1, 50 do ' ..
        'local x = (i % 15) + 1 ' ..
        'local y = math.random(x, 15) ' ..
        'current_inventory[x], current_inventory[y] = current_inventory[y], current_inventory[x] ' ..
    'end ' ..
    --Store items
    'for i = 1, 15 do ' ..
        'if current_inventory[i] ~= nil then player.components.inventory:GiveItem(current_inventory[i], i) end ' ..
    'end'
    SendCommand(fnstr)
    --local chat_string = "Shuffle inventory"
    --net:Announce(chat_string)
end

local function dropHandOverTime(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        return
    end
    event_holder = player:DoPeriodicTask(1.5, function()
        if math.random() < 0.5 then
            dropHand(nil)
        end
    end)
end

local function rotAll(rev)
    if rev then return end
    local fnstr = fn_player ..
    'for i = 1, 15 do ' ..
        'local item = player.components.inventory.itemslots[i] ' ..
        'if item ~= nil then ' ..
            'if item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled") then ' ..
                'local size = 1 ' ..
                'if item.components.stackable ~= nil then ' ..
                    'size = item.components.stackable:StackSize() ' ..
                'end ' ..
                'player.components.inventory:RemoveItemBySlot(i) ' ..
                'for j = 1, size do ' ..
                    'local inst = c_spawn("spoiled_food") ' ..
                    'player.components.inventory:GiveItem(inst, i) ' ..
                'end ' ..
            'end ' ..
        'end ' ..
    'end'
    SendCommand(fnstr)
end

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------------------- Effects ---------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local function makeCold(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.temperature:SetTemperature(0)'
    SendCommand(fnstr)
    --local chat_string = "Cold"
    --net:Announce(chat_string)
end

local function makeHot(rev)
    if rev then return end
    local fnstr = fn_player ..
    'player.components.temperature:SetTemperature(50)'
    SendCommand(fnstr)
    --local chat_string = "Hot"
    --net:Announce(chat_string)
end

local function makeWeak(rev)
    local fnstr = fn_player .. 'player.components.combat.damagemultiplier = '
    if rev then fnstr = fnstr .. '1' else fnstr = fnstr .. '0.25' end
    SendCommand(fnstr)
    --local chat_string = "Weak"
    --net:Announce(chat_string)
end

local function makeStrong(rev)
    local fnstr = fn_player .. 'player.components.combat.damagemultiplier = '
    if rev then fnstr = fnstr .. '1' else fnstr = fnstr .. '2' end
    SendCommand(fnstr)
    --local chat_string = "Strong"
    --net:Announce(chat_string)
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
        local fnstr = fn_player ..
        'if player.components.health:GetPercent() < 1 then ' ..
            'player.components.health:SetPercent(player.components.health:GetPercent() + 0.02) ' ..
        'end'
        SendCommand(fnstr)
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
        local fnstr = fn_player ..
        'if player.components.hunger:GetPercent() < 1 then ' ..
            'player.components.hunger:SetPercent(player.components.hunger:GetPercent() + 0.02) ' .. 
        'end'
        SendCommand(fnstr)
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
        local fnstr = fn_player ..
        'if player.components.sanity:GetPercent() < 1 then ' ..
            'player.components.sanity:SetPercent(player.components.sanity:GetPercent() + 0.02) ' ..
        'end'
        SendCommand(fnstr)
    end)
end

local function poison(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        return
    end
    event_holder = player:DoPeriodicTask(1.5, function()
        local fnstr = fn_player ..
        'if player.components.health:GetPercent() > 0.01 then ' ..
            'player.components.health:SetPercent(player.components.health:GetPercent() - 0.01) ' ..
        'end'
        SendCommand(fnstr)
    end)
end

--Not working
local function keepMoving(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        player.components.locomotor:Stop()
        return
    end
    event_holder = player:DoPeriodicTask(0.01, function()
        local fnstr = fn_player ..
        'player.components.locomotor:RunInDirection(180 - ' .. GLOBAL.TheCamera:GetHeading() .. ')'
    end)
end

local function speedup(rev)
    local fnstr = fn_player .. 'player.components.locomotor:SetExternalSpeedMultiplier(player, "myEventsSpeed", '
    if rev then fnstr = fnstr .. '1)' else fnstr = fnstr .. '2)' end
    SendCommand(fnstr)
end

local function slowdown(rev)
    local fnstr = fn_player .. 'player.components.locomotor:SetExternalSpeedMultiplier(player, "myEventsSpeed", '
    if rev then fnstr = fnstr .. '1)' else fnstr = fnstr .. '0.5)' end
    SendCommand(fnstr)
end

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-------------- Environment Effects ---------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

local function spawnLightning(rev)
    if rev then return end
    local fnstr = 'TheWorld:PushEvent("ms_sendlightningstrike", ConsoleWorldPosition())'
    SendCommand(fnstr)
end

local function spawnMeteor(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("shadowmeteor") ' ..
    'inst.Transform:SetPosition(x, y, z)'
    SendCommand(fnstr)
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
        if n < 15 then
            return
        end
        local fnstr = fn_player ..
        'local x, y, z = player:GetPosition():Get() ' ..
        'local inst = c_spawn("frog") ' ..
        'inst.sg:GoToState("fall") ' ..
        'inst.Transform:SetPosition(x + math.random(-15, 15), 35, z + math.random(-15, 15))'
        SendCommand(fnstr)
    end)
end

local function rain(rev)
    if rev then return end
    local fnstr = 'TheWorld:PushEvent("ms_forceprecipitation")'
    SendCommand(fnstr)
end

local function nightFalls(rev)
    if rev then return end
    local fnstr = 'TheWorld:PushEvent("ms_setphase", "night")'
    SendCommand(fnstr)
end

local function wakeUp(rev)
    if rev then return end
    local fnstr = 'TheWorld:PushEvent("ms_nextcycle")'
    SendCommand(fnstr)
end

local function tileChanger(rev)
    if rev then
        if event_holder ~= nil then
            event_holder:Cancel()
            event_holder = nil
        end
        last_tile = {}
        return
    end
    local useable_tile_list = {2,3,4,5,6,7,8,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,30,31,32,35,36,37,38,39,41,42,43,44,45,46,47}
    event_holder = player:DoPeriodicTask(0.25, function ()
        local x, y = TheWorld.Map:GetTileCoordsAtPoint(TheWorld.Map:GetTileCenterPoint(player:GetPosition():Get()))
        if not TheWorld.Map:IsOceanAtPoint(TheWorld.Map:GetTileCenterPoint(player:GetPosition():Get())) and (last_tile[1] ~= x or last_tile[2] ~= y) then
            last_tile = {x, y}
            TheWorld.Map:SetTile(x, y, useable_tile_list[math.random(#useable_tile_list)])
        end
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
    --Maybe add axe
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x+2, y, z) ' ..
    'inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x+1, y, z+1) ' ..
    'inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x, y, z+2) ' ..
    'inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x-1, y, z+1) ' ..
    'inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x-2, y, z) ' ..
    'inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x-1, y, z-1) ' ..
    'inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x, y, z-2) ' ..
    'inst = c_spawn("evergreen_normal") ' ..
    'inst.Transform:SetPosition(x+1, y, z-1)'
    SendCommand(fnstr)
end

local function spawnEvilFlowers(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'for i = -2, 2 do ' ..
        'for j = -2, 2 do ' ..
            'local inst = c_spawn("flower_evil") ' ..
            'inst.Transform:SetPosition(x+i*2, y, z+j*2) ' ..
        'end ' ..
    'end'
    SendCommand(fnstr)
end

local function spawnIcePit(rev)
    if rev then
        local fnstr = 'c_find("deer_ice_circle"):Remove()'
        SendCommand(fnstr)
        return
    end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local last_item = c_spawn("deer_ice_circle") ' ..
    'last_item.Transform:SetPosition(x, y, z)'
    SendCommand(fnstr)
end

local function spawnFirePit(rev)
    if rev then
        local fnstr = 'c_find("deer_fire_circle"):Remove()'
        SendCommand(fnstr)
        return
    end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local last_item = c_spawn("deer_fire_circle") ' ..
    'last_item.Transform:SetPosition(x, y, z)'
    SendCommand(fnstr)
end

local function treesAttackClose(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("leif") ' ..
    'inst.Transform:SetPosition(x, y, z)'
    SendCommand(fnstr)
end

local function treesAttackRange(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("deciduoustree") ' ..
    'inst.Transform:SetPosition(x, y, z) ' ..
    'inst:StartMonster(true)'
    SendCommand(fnstr)
end

local function fruitFly(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("lordfruitfly") ' ..
    'inst.Transform:SetPosition(x, y, z)'
    SendCommand(fnstr)
end

local function spawnButterflies(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local n = math.random(20) ' ..
    'for i = 1, n do ' ..
        'local inst = c_spawn("butterfly") ' ..
        'inst.Transform:SetPosition(x + math.random(-15, 15), y, z + math.random(-15, 15)) ' ..
    'end'
    SendCommand(fnstr)
end

local function spawnHounds(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local hounds = {"hound", "firehound", "icehound"} ' ..
    'local inst = c_spawn(hounds[math.random(3)]) ' ..
    'inst.Transform:SetPosition(x + 10, y, z) ' ..
    'local inst = c_spawn(hounds[math.random(3)]) ' ..
    'inst.Transform:SetPosition(x - 10, y, z) ' ..
    'local inst = c_spawn(hounds[math.random(3)]) ' ..
    'inst.Transform:SetPosition(x, y, z + 10) ' ..
    'local inst = c_spawn(hounds[math.random(3)]) ' ..
    'inst.Transform:SetPosition(x, y, z - 10)'
    SendCommand(fnstr)
end

local function spawnTentacles(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("tentacle") ' ..
    'inst.Transform:SetPosition(x + 2, y, z) ' ..
    'local inst = c_spawn("tentacle") ' ..
    'inst.Transform:SetPosition(x - 2, y, z) ' ..
    'local inst = c_spawn("tentacle") ' ..
    'inst.Transform:SetPosition(x, y, z + 2) ' ..
    'local inst = c_spawn("tentacle") ' ..
    'inst.Transform:SetPosition(x, y, z - 2)'
    SendCommand(fnstr)
    -- Maybe future feature -> change ground to MARSH
    --[[
    x, y = TheWorld.Map:GetTileCoordsAtPoint(TheWorld.Map:GetTileCenterPoint(x, y, z))
    for i = -1, 1 do
        for j = -1, 1 do
            --TODO If player on ocean
            TheWorld.Map:SetTile(x + i, y + j, 8)
        end
    end
    --]]
end

local function spawnSheep(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("spat") ' ..
    'inst.Transform:SetPosition(x, y, z)'
    SendCommand(fnstr)
end

local function spawnWarg(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local x, y, z = player:GetPosition():Get() ' ..
    'local inst = c_spawn("warg") ' ..
    'inst.Transform:SetPosition(x, y, z)'
    SendCommand(fnstr)
end

-- TODO edit for caves version of mod
local function bonusChest(rev)
    if rev then
        last_item:Remove()
        last_item = nil
        return end
    local w, h = TheWorld.Map:GetSize()
	w = (w - w/2) * TILE_SCALE
	h = (h - h/2) * TILE_SCALE
	local x, z = math.random() * w * 2, math.random() * h * 2
    while TheWorld.Map:IsOceanAtPoint(x - w, 0, z - h) or
        TheWorld.Map:GetTileAtPoint(x - w, 0, z - h) == 1 or     --Outside of map 
        TheWorld.Map:GetTileAtPoint(x - w, 0, z - h) == 65535 do --IMPASSABLE = 1, INVALID = 65535,
		    x, z = math.random() * w * 2, math.random() * h * 2
	end
    local ents = GLOBAL.Ents
    local inst = ents[TheSim:SpawnPrefab("treasurechest")]
    inst.Transform:SetPosition(x - w, 0, z - h)

    inst.components.container:GiveItem(ents[TheSim:SpawnPrefab("axe")]) --TODO
    print(x - w, z - h) --TODO
    last_item = inst
end

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
------------------- Item spawn -------------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]

local function starterTools(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local inst = c_spawn("axe") ' ..
    'player.components.inventory:GiveItem(inst) ' ..
    'inst = c_spawn("pickaxe") ' ..
    'player.components.inventory:GiveItem(inst) ' ..
    'inst = c_spawn("shovel") ' ..
    'player.components.inventory:GiveItem(inst) ' ..
    'inst = c_spawn("farm_hoe") ' ..
    'player.components.inventory:GiveItem(inst) ' ..
    'inst = c_spawn("spear") ' ..
    'player.components.inventory:GiveItem(inst)'
    SendCommand(fnstr)
end

local function shrooms(rev)
    if rev then return end
    local fnstr = fn_player ..
    'for i = 1, 10 do ' ..
        'local inst = c_spawn("red_cap") ' ..
        'player.components.inventory:GiveItem(inst) ' ..    
        'inst = c_spawn("green_cap") ' ..
        'player.components.inventory:GiveItem(inst) ' ..
        'inst = c_spawn("blue_cap") ' ..
        'player.components.inventory:GiveItem(inst) ' ..
    'end'
    SendCommand(fnstr)
end

local function fakeGoldTools(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local inst = c_spawn("goldenaxe") ' ..
    'if inst ~= nil then inst.components.finiteuses:SetUses(0.25) end ' ..
    'player.components.inventory:GiveItem(inst) ' ..
    'inst = c_spawn("goldenpickaxe") ' ..
    'if inst ~= nil then inst.components.finiteuses:SetUses(0.25) end ' ..
    'player.components.inventory:GiveItem(inst) ' ..
    'inst = c_spawn("goldenshovel") ' ..
    'if inst ~= nil then inst.components.finiteuses:SetUses(0.25) end ' ..
    'player.components.inventory:GiveItem(inst)'
    SendCommand(fnstr)
    return "Gold tools"
end

local function realGoldTools(rev)
    if rev then return end
    local fnstr = fn_player ..
    'local tools = {"goldenaxe", "goldenpickaxe", "goldenshovel"} ' ..
    'local inst = c_spawn(tools[math.random(3)]) ' ..
    'player.components.inventory:GiveItem(inst) ' ..
    'local inst = c_spawn(tools[math.random(3)]) ' ..
    'player.components.inventory:GiveItem(inst)'
    SendCommand(fnstr)
    return "Gold tools"
end

local function nightVisionEffect(rev)
    if rev then
        local fnstr = fn_player ..
        'if last_item ~= nil then ' ..
            'last_item:Remove() ' ..
            'last_item = nil ' ..
        'else ' ..
            'player.components.talker:Say("Neni to dobre") ' ..
        'end'
        SendCommand(fnstr)
        return
    end
    local fnstr = fn_player ..
    'local curr_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD) ' ..
    'if curr_item ~= nil then ' ..
        'player.components.inventory:DropItem(curr_item) ' ..
    'end ' ..
    'last_item = c_spawn("molehat") ' ..
    'player.components.inventory:Equip(last_item)'
    SendCommand(fnstr)
end

local function wonkeyCurse(rev)
    if rev then
        local fnstr = fn_player ..
        'for i = 1, 15 do ' ..
            'player.components.inventory:RemoveItemBySlot(i) ' ..
        'end ' ..
        'player.components.cursable:RemoveCurse("MONKEY", 150, false)'
        SendCommand(fnstr)
        return
    end
    local fnstr = fn_player ..
    'player.components.inventory:DropEverything() ' ..
    'for i = 1, 150 do ' ..
        'local inst = c_spawn("cursed_monkey_token") ' ..
        'player.components.inventory:GiveItem(inst) ' .. 
    'end'
    SendCommand(fnstr)
end

--[[
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--------------- Class declaration ----------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
]]


local MagicEvents = Class(function (self)
    -- Working:
    -- GrowGiant, GrowTiny, hideCrafting, fullHealth, fullHunger, fullSanity, halfHealth, halfHunger, halfSanity, oneHealth, zeroHunger, zeroSanity,
    -- speedup, slowdown, dropInventory, dropArmour, dropHand, dropHandOverTime
    -- teleportLag, makeHot, makeCold, shuffleInventory, healthRegen, hungerRegen, sanityRegen, poison
    -- spawnLightning, spawnMeteor, rainingFrogs, rain, nightFalls, wakeUp, tileChanger
    -- spawnEvilFlowers, treePrison, fruitFly, treesAttackClose, treesAttackRange, spawnButterflies, spawnHounds
    -- spawnSheep, spawnWarg, spawnTentacles, starterTools, fakeGoldTools, shrooms, nightVisionEffect, spawnFirePit, spawnIcePit
    -- ghostScreen

    -- Working with restriction:
    -- teleportRandom, teleportHermit, teleportSpawn

    -- Not Working:
    -- keepMoving
    
    self.random_events = {teleportRandom, speedup, slowdown, tileChanger}
    self.random_events_names = {"Random tp", "Speed", "Slow", "Floor is changing"}

    self.all_events = {GrowGiant, GrowTiny, hideCrafting, fullHealth, fullHunger, fullSanity, halfHealth, halfHunger,
        halfSanity, oneHealth, zeroHunger, zeroSanity, speedup, slowdown, dropInventory, dropArmour, dropHand,
        dropHandOverTime, rotAll, teleportLag, makeHot, makeCold, shuffleInventory, healthRegen, hungerRegen, sanityRegen,
        poison, spawnLightning, spawnMeteor, rainingFrogs, rain, nightFalls, wakeUp, tileChanger, spawnEvilFlowers,
        treePrison, fruitFly, treesAttackClose, treesAttackRange, spawnButterflies, spawnHounds, spawnSheep, spawnWarg,
        spawnTentacles, starterTools, fakeGoldTools, realGoldTools, shrooms, nightVisionEffect, wonkeyCurse, spawnFirePit,
        spawnIcePit, ghostScreen, goggleScreen, moonStorm, teleportRandom, teleportHermit, teleportSpawn}
    self.all_events_names = {"Giant", "Tiny", "No crafting", "Restore health", "Restore hunger", "Restore sanity", "Half health",
        "Half hunger", "Half sanity", "One health", "Zero hunger", "Zero sanity", "Speed", "Slow", "Drop inventory", "Drop armour",
        "Drop hand", "Slippery hands", "Rot everything", "Bad connection", "Hot weather", "Cold weather", "Inventory shuffle", "Health regeneration",
        "Hunger regeneration", "Sanity regeneration", "Poison", "Lightning", "Meteor", "Frog rain", "Rain", "Night", "Morning",
        "Floor is changing", "Evil flowers", "Tree prison", "Fruit fly", "Trees attack (close)", "Trees attack (range)", "Butterflies",
        "Hounds", "Sheep", "Warg", "Tentacles", "Starter tools", "Gold tools (fake)", "Gold tools (real)", "Shrooms", "Nightvision",
        "Wonkey curse", "Firepit", "Icepit", "Ghost vision", "Goggles vision", "Moonstorm", "Random tp", "Hermit tp", "Spawn tp"}
        
    self.number_of_options = 4
    self.last_event = nil
    self.curr_events = {}
    self.curr_events_names = {}
end)

function MagicEvents:update_available_events(event_status)
    self.random_events = {}
    self.random_events_names = {}
    for i = 1, #event_status do
        if event_status[i] then
            self.random_events[#self.random_events + 1] = self.all_events[i]
            self.random_events_names[#self.random_events_names + 1] = self.all_events_names[i]
        end
    end
    if #self.random_events < self.number_of_options then
        self.random_events = {teleportRandom, speedup, slowdown, tileChanger}
        self.random_events_names = {"teleportRandom", "speedup", "slowdown", "tileChanger"}
    end
end

function MagicEvents:update_numer_of_events(n)
    self.number_of_options = n
end

function MagicEvents:generate_random_event()
    local numbers = generateRandomNumbers(#self.random_events, self.number_of_options)
    for k, v in ipairs(numbers) do
        self.curr_events[k] = self.random_events[v]
        self.curr_events_names[k] = self.random_events_names[v]
    end
end

function MagicEvents:execute_random_event(event_num)
    player = GLOBAL.ThePlayer or GLOBAL.AllPlayers[1]
    if event_num ~= nil then
        if player == nil then
            print("Player == nil in execute_random_event")
        end
        if player ~= nil then
            local event_text = self.curr_events[event_num](nil) -- Execute chosen event
            event_text = event_text or self.curr_events_names[event_num]
            --SendCommand(fn_player .. 'player.components.talker:Say("' .. event_text .. '")')
            TheNet:Say(event_text) -- Announce current event
            self.last_event = self.curr_events[event_num] -- Store last event
        end
    end
    self.generate_random_event(self)
    return self.curr_events_names
end

function MagicEvents:revert_last_event()
    if player == nil then
        print("Player == nil in revert_last_event")
    end
    if player ~= nil then
        if self.last_event ~= nil then self.last_event("ret") end --Does not matter value, parameter just can't be nil
    end
end

return MagicEvents()