local require = GLOBAL.require
local io = GLOBAL.io
local myevents = require "components/myevents"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local TEMPLATES = require "widgets/templates"
require "constants"

--print("Hello world!")

--local net = GLOBAL.TheNet
--local player = GLOBAL.AllPlayers[1]

--Variables
local vote_counts = {}
local vote_participants = {}
local loop_counter = 0
local option_window = {}
local options = {}
local transfer_file = "textak.txt"

--TMP functions
local function k()
    myevents:execute_random_event(1)
end

local function l()
    myevents:execute_random_event(2)
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

local function update_button_text()
    option_window[1]:SetText("1: " .. (options[1] or "Error") .. " " .. (vote_counts["1"] or "0"))
    option_window[2]:SetText("2: " .. (options[2] or "Error") .. " " .. (vote_counts["2"] or "0"))
end

local function set_button_position(button, pos_x, pos_y)
    local screensize = {GLOBAL.TheSim:GetScreenSize()}
    local new_x = screensize[1] * (pos_x/1920)
    local new_y = screensize[2] * (pos_y/1080)
    button:SetPosition(new_x, new_y, 0)
end

local function button_create(text, x_pos, y_pos, x_scale, y_scale)
    local new_button = ImageButton()

    new_button:SetScale(x_scale, y_scale)

    --new_button:SetPosition(x_pos, y_pos, 0)
    set_button_position(new_button, x_pos, y_pos)

    new_button:Show()

    new_button:SetText(text)

    return new_button
end

local function resolve_votes()
    print("Resolve_votes")
    local vote_option = 1
    if vote_counts["1"] == nil then
        vote_option = 2
    elseif vote_counts["2"] == nil then
        vote_option = 1
    elseif vote_counts["1"] > vote_counts["2"] then
        vote_option = 1
    else
        vote_option = 2
    end

    vote_counts = {}
    vote_participants = {}

    if option_window[1] == nil then
        option_window[1] = button_create("text", 1835, 800, 1, 1)
    end
    if option_window[2] == nil then
        option_window[2] = button_create("text", 1835, 760, 1, 1)
    end

    local op1, op2 = myevents:execute_random_event(vote_option)
    options[1] = op1
    options[2] = op2

    --Button position is currenty stationary and visible in the right corner only when in full screen mode
    --TODO change in future
    --set_button_position(option_window[1], 1835, 800)
    --set_button_position(option_window[2], 1835, 760)

    update_button_text()

end

--for testing purposes, delete in future
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_HOME, k)
GLOBAL.TheInput:AddKeyDownHandler(GLOBAL.KEY_END, l)


AddPrefabPostInit("world", function (inst)
    inst:DoPeriodicTask(3, function ()
        --if used to get first set of effects
        if loop_counter == 0 then
            resolve_votes()
        end
        brain()
        update_button_text()
        loop_counter = loop_counter + 1
        if loop_counter == 121 then -- base counter = 11
            resolve_votes()
            loop_counter = 1
        end
    end)
  end)
