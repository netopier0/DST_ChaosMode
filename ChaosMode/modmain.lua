local require = GLOBAL.require
local io = GLOBAL.io
local myevents = require "components/myevents"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/templates"
require "constants"


local mod_config_options = {GetModConfigData("GrowGiant"), GetModConfigData("GrowTiny"), GetModConfigData("hideCrafting"),
    GetModConfigData("fullHealth"), GetModConfigData("fullHunger"), GetModConfigData("fullSanity"), GetModConfigData("halfHealth"),
    GetModConfigData("halfHunger"), GetModConfigData("halfSanity"), GetModConfigData("oneHealth"), GetModConfigData("zeroHunger"),
    GetModConfigData("zeroSanity"), GetModConfigData("speedup"), GetModConfigData("slowdown"), GetModConfigData("dropInventory"),
    GetModConfigData("dropArmour"), GetModConfigData("dropHand"), GetModConfigData("dropHandOverTime"), GetModConfigData("teleportLag"),
    GetModConfigData("makeHot"), GetModConfigData("makeCold"), GetModConfigData("shuffleInventory"), GetModConfigData("healthRegen"),
    GetModConfigData("hungerRegen"), GetModConfigData("sanityRegen"), GetModConfigData("poison"), GetModConfigData("spawnLightning"),
    GetModConfigData("spawnMeteor"), GetModConfigData("rainingFrogs"), GetModConfigData("rain"), GetModConfigData("nightFalls"),
    GetModConfigData("wakeUp"), GetModConfigData("tileChanger"), GetModConfigData("spawnEvilFlowers"), GetModConfigData("treePrison"),
    GetModConfigData("fruitFly"), GetModConfigData("treesAttackClose"), GetModConfigData("treesAttackRange"), GetModConfigData("spawnButterflies"),
    GetModConfigData("spawnHounds"), GetModConfigData("spawnSheep"), GetModConfigData("spawnWarg"), GetModConfigData("spawnTentacles"),
    GetModConfigData("starterTools"), GetModConfigData("fakeGoldTools"), GetModConfigData("shrooms"), GetModConfigData("nightVisionEffect"),
    GetModConfigData("spawnFirePit"), GetModConfigData("spawnIcePit"), GetModConfigData("ghostScreen"), GetModConfigData("teleportRandom"),
    GetModConfigData("teleportHermit"), GetModConfigData("teleportSpawn")}

local debug_mode =  GetModConfigData("Debug Mode")

--Variables
local vote_counts = {}
local vote_participants = {}
local loop_counter = 0
local vote_option_widget = {}
local options = {}
local num_of_options = 4
local transfer_file = "textak.txt"

--Debug mode funtions
local function k()
    if debug_mode then
        options = myevents:execute_random_event(1)
    end
end

local function l()
    if debug_mode then
        options = myevents:execute_random_event(2)
    end
end

local function m()
    if debug_mode then
        options = myevents:execute_random_event(3)
    end
end

local function n()
    if debug_mode then
        options = myevents:execute_random_event(4)
    end
end

--vote counter
--expects data in format:
--[identifier]: [vote]

local function brain()
    if io ~= nil then
        local open = io.open
        local file = open(transfer_file, "r")

        if not file then return nil end

        local lines = file:lines()

        for line in lines do
            line = line:gsub("[\n\r\t]", "")
            local pos_of_semicolom = string.find(line, ":")
            if pos_of_semicolom ~= nil and #line == pos_of_semicolom + 2 then
                local current_participant = line:sub(1, pos_of_semicolom-1)
                local current_vote = line:sub(pos_of_semicolom + 2, pos_of_semicolom + 2)
                if vote_participants[current_participant] == nil then
                    vote_participants[current_participant] = current_vote
                    print(current_participant, current_vote)
                    if vote_counts[current_vote] == nil then
                        vote_counts[current_vote] = 1
                    else
                        vote_counts[current_vote] = vote_counts[current_vote] + 1
                    end
                end
            end
        end

        file:close()
        open(transfer_file, "w"):close()
    end
end


local function resolve_votes()

    if #options == 0 then
        options = myevents:execute_random_event()
        return
    end

    local vote_option = math.random(num_of_options)
    local max_votes = -1

    for i = 1, num_of_options do
        if max_votes < (vote_counts[tostring(i)] or -1) then
            max_votes = vote_counts[tostring(i)]
            vote_option = i
        end
    end

    vote_counts = {}
    vote_participants = {}

    options = myevents:execute_random_event(vote_option)
end

-- For testing purposes, works only in debug mode
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_HOME, k)
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_END, l)
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_PAGEUP, m)
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_PAGEDOWN, n)


local function VoteWidgetPosition(controls, screensize, pos)
    local hudscale = controls.top_root:GetScale()
    local screen_w_full, screen_h_full = GLOBAL.unpack(screensize)
    local screen_w = screen_w_full/hudscale.x
    local screen_h = screen_h_full/hudscale.y

    local position_x = (-1 * controls.vote_widget[pos].coordssize.w / 2)
        + (1 * screen_w / 2) + (-1 * 150)
    local position_y = (-1 * controls.vote_widget[pos].coordssize.h / 2)
        + (0 * screen_h / 2) + (-1 * -40) + (-1 * 50 * pos)

    controls.vote_widget[pos]:SetPosition(position_x, position_y, 0)
end

local function CountdownWidgetPosition(controls, screensize)
    local hudscale = controls.top_root:GetScale()
    local screen_w_full, screen_h_full = GLOBAL.unpack(screensize)
    local screen_w = screen_w_full/hudscale.x
    local screen_h = screen_h_full/hudscale.y

    local position_x = (-1 * controls.time_widget.coordssize.w / 2)
        + (1 * screen_w / 2) + (-1 * 150)
    local position_y = (-1 * controls.time_widget.coordssize.h / 2)
        + (0 * screen_h / 2) + (-1 * -40) + (-1 * 50 * 5)

    controls.time_widget:SetPosition(position_x, position_y, 0)
end


local function DisplayVotes(controls)
    controls.inst:DoTaskInTime(0, function ()
        options = myevents:execute_random_event() -- Initialize events
        local VoteWidget = require "widgets/voting"
        controls.vote_widget = {}

        for i=1, num_of_options do
            controls.vote_widget[i] = controls.top_root:AddChild(VoteWidget(1))
            local screensize = {GLOBAL.TheSim:GetScreenSize()}
            VoteWidgetPosition(controls, screensize, i)

            local OnUpdate_base = controls.OnUpdate
            controls.OnUpdate = function (self, dt)
                OnUpdate_base(self, dt)

                local votesString = i .. ": " .. (options[i] or "Error") .. " " .. (vote_counts[tostring(i)] or "0")
                controls.vote_widget[i].button:SetText(votesString)

                local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
                if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
                    VoteWidgetPosition(controls, curscreensize, i)
                    screensize = curscreensize
                end
            end
        end
        vote_option_widget = controls.vote_widget
    end)


    -- CountDown
    controls.inst:DoTaskInTime(0, function ()
        options = myevents:execute_random_event() -- Initialize events
        local VoteWidget = require "widgets/voting"
        controls.time_widget = nil

        controls.time_widget  = controls.top_root:AddChild(VoteWidget(1))
        local screensize = {GLOBAL.TheSim:GetScreenSize()}
        CountdownWidgetPosition(controls, screensize)

        local OnUpdate_base = controls.OnUpdate
        controls.OnUpdate = function (self, dt)
            OnUpdate_base(self, dt)

            local votesString = 100 - loop_counter
            controls.time_widget.button:SetText(votesString)

            local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
            if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
                CountdownWidgetPosition(controls, curscreensize)
                screensize = curscreensize
            end
        end

    end)
end

AddPrefabPostInit("world", function (inst)
    inst:DoPeriodicTask(1, function ()

        --if used to get first set of effects
        if loop_counter == 0 then
            myevents:update_available_events(mod_config_options)
            brain()
            vote_counts = {}
            vote_participants = {}
            options = myevents:execute_random_event(nil)
            loop_counter = 1
        end
        brain()
        
        if not debug_mode then
            loop_counter = loop_counter + 1
        end

        if loop_counter == 60 then
            resolve_votes()
            loop_counter = 1
        end
    end)
  end)

AddClassPostConstruct("widgets/controls", DisplayVotes)