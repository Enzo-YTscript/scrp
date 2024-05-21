local ArrayField = loadstring(game:HttpGet("https://raw.githubusercontent.com/Enzo-YTscript/Ui-Library/main/ArrayfieldLibraryUI"))()

local Window = ArrayField:CreateWindow({
   Name = "Toilet Defense",
   LoadingTitle = "SUBSCRIBE ENZO-YT",
   LoadingSubtitle = "by ENZO-YT",
        ConfigurationSaving = {
            Enabled = false,
            FolderName = nil, -- Create a custom folder for your hub/game
            FileName = "ArrayField"
        },
        Discord = {
            Enabled = true,
            Invite = "https://discord.gg/WBCnspE9", -- The Discord invite code, do not include discord.gg/
            RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
        KeySystem = true, -- Set this to true to use our key system
        KeySettings = {
            Title = "Toilet Defense",
            Subtitle = "Key System",
            Note = "SUBSCRIBE ENZO-YT",
            FileName = "ToiletDefenseKeys",
            SaveKey = true,
            GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like ArrayField to get the key from
            Key = {"https://pastebin.com/raw/iJCXgQGb"},
            Actions = {
                [1] = {
                    Text = 'Click here to copy the key link',
                    OnPress = function()

                    end,
                }
            },
        }
    })

-- MAIN TAB    
local TabMain = Window:CreateTab("HOME", nil) -- Title, Image
local SectionMain = TabMain:CreateSection("Main", false)

-- Function template for toggles
local function createToggle(name, args)
    local active = false
    
    local function action()
        while active do
            game:GetService("ReplicatedStorage").RDT:FireServer(unpack(args))
            wait(3)
        end
    end

    TabMain:CreateToggle({
        Name = name,
        SectionParent = SectionMain,
        CurrentValue = false,
        Callback = function(Value)
            active = Value
            if Value then
                spawn(action)
            end
        end
    })
end

-- Create toggles
createToggle("Give Coin", {7})
createToggle("Random Rare", {3})
createToggle("Random Epic", {5})
createToggle("Random Legendary", {6})
createToggle("Random Mythic", {8})


-- Infinite Jump
local Misc = TabMain:CreateButton({
    Name = "Infinite Jump",
    SectionParent = SectionMain,
    Callback = function()
        -- The function that takes place when the button is pressed
        _G.infinjump = not _G.infinjump
        if _G.infinJumpStarted == nil then
            -- Ensures this only runs once to save resources
            _G.infinJumpStarted = true

            -- Notifies readiness
            game.StarterGui:SetCore("SendNotification", {Title="Youtube Hub"; Text="Infinite Jump Activated!"; Duration=5;})

            -- The actual infinite jump
            local plr = game:GetService('Players').LocalPlayer
            local m = plr:GetMouse()
            m.KeyDown:connect(function(k)
                if _G.infinjump then
                    if k:byte() == 32 then
                        humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                        humanoid:ChangeState('Jumping')
                        wait()
                        humanoid:ChangeState('Seated')
                    end
                end
            end)
        end
    end,
})

-- Walk Speed Slider
local Slider = TabMain:CreateSlider({
    Name = "Walk Speed",
    SectionParent = SectionMain,
    Range = {0, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})