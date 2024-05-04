local ArrayField = loadstring(game:HttpGet("https://raw.githubusercontent.com/Enzo-YTscript/Ui-Library/main/ArrayfieldLibrary"))()

local Window = ArrayField:CreateWindow({
    Name = "Toy Simulator Halloween 🎃",
    LoadingTitle = "SUBSCRIBE ENZO-YT",
    LoadingSubtitle = "by ENZO-YT",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Enzo-YT Script"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Toy Simulator Halloween 🎃",
        Subtitle = "Key System",
        Note = "Key In Description",
        FileName = "ToySimKeyEnzoYT",
        SaveKey = false,
        GrabKeyFromSite = true,
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

-- Anti Afk
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- MAIN TAB
local Tab = Window:CreateTab("HOME", nil)
local Section = Tab:CreateSection("Farm", false)

-- player
local player = game.Players.LocalPlayer
-- Auto Farm Coins
local AutoFarmCoinsEnabled = false

local function FireServerOnTarget(target)
    game:GetService("ReplicatedStorage").Remotes.Hit:FireServer()
end

local function FindNearestTarget()
    local nearestTarget = nil
    local maxDistance = math.huge

    for _, target in pairs(workspace.Misc.Items:GetChildren()) do
        if target:IsA("Model") and target:FindFirstChild("ClickDetector") then
            local distance = (target.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < maxDistance then
                maxDistance = distance
                nearestTarget = target
            end
        end
    end

    return nearestTarget
end

local function AutoFarmCoins()
    while AutoFarmCoinsEnabled do
        local target = FindNearestTarget()
        if target then
            fireclickdetector(target.ClickDetector)
            FireServerOnTarget(target)
        else
            print("No objects with ClickDetector nearby.")
        end
        wait(1)  -- Adjust the wait time as needed
    end
end

Tab:CreateToggle({
    Name = "Auto Farm Coins",
    SectionParent = Section,
    CurrentValue = false,
    Callback = function(value)
        AutoFarmCoinsEnabled = value
        if AutoFarmCoinsEnabled then
            AutoFarmCoins()
        end
    end,
})


Tab:CreateSpacing(nil, 10)
local autoCollectToggle = {}
Tab:CreateToggle({
    Name = "Auto Collect",
    SectionParent = Section,
    CurrentValue = false,
    Callback = function(v)
        getgenv().collect = v

        while true do
            if getgenv().collect then
                local player = game.Players.LocalPlayer
                local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")

                for _, Drops in ipairs(game.Workspace.Misc.Drops:GetChildren()) do
                    if Drops:IsA("BasePart") then
                        Drops.CFrame = CFrame.new(humanoidRootPart.Position)
                    end
                end
            end

            wait(0.1)
        end
    end,
})

local AutoCollectGift = {}
Tab:CreateToggle({
    Name = "Auto Collect Gift",
    SectionParent = Section,
    CurrentValue = false,
    Callback = function(v)
        for i = 1, 15 do
            local args = {[1] = i}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Rewards"):FireServer(unpack(args))
            wait(0.1)
        end
    end,
})

local AutoStartArenaEnabled = false

local AutoStartArena = {}
Tab:CreateToggle({
    Name = "Auto Start Arena",
    SectionParent = Section,
    CurrentValue = false,
    Callback = function(value)
        AutoStartArenaEnabled = value
        if AutoStartArenaEnabled then
            while AutoStartArenaEnabled do
                wait(3)
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Start"):FireServer()
            end
        end
    end,
})

-- Functions for getting area list based on world (Earth or Cyberverse)
local function autohatch(world, area, tier, tripleHatch)
    local args = {
        [1] = world,
        [2] = area,
        [3] = "tier_" .. tier,
        [4] = tripleHatch
    }
    HatchRemote:FireServer(unpack(args))
end

local function startAutoHatch()
    local selectedWorld = getgenv().selectedWorld
    local selectedArea = getgenv().selectedArea
    local selectedTier = getgenv().selectedTier
    local tripleHatch = getgenv().tripleHatch

    if selectedWorld == "Earth" then
        autohatch("Earth", selectedArea, selectedTier, tripleHatch)
    elseif selectedWorld == "Cyberverse" then
        autohatch("Cyberverse", selectedArea, selectedTier, tripleHatch)
    end
end

-- TAB EGG
local Tab2 = Window:CreateTab("EGG", nil) -- Title, Image
local Egg = Tab2:CreateSection("🥚 Auto EGG",false)

local ManualAreasCyberverse = {"Cyber Town", "Robo Road", "Cyber Adventure", "Robo Expedition", "Cyber Kingdom", "Robo Life", "Cyber Expedition", "Robo Forest", "Robo Land", "The Second Portal"}

local ManualAreasEarth = {"Town", "Frosty Kingdom", "Desert Adventure", "Jungle Expedition", "Dinosaur Kingdom", "Farm Life", "Mountain Expedition", "Fantasy Forest", "Aqua Land", "The Portal"}

local selectedCyberverseArea = nil
local selectedEarthArea = nil

local EarthAreaDropdown = Egg:CreateDropdown({
    Name = "Select Area Earth",
    Options = ManualAreasEarth,
    CurrentOption = {""},
    MultiSelection = false,
    Flag = "Dropdown1",
    Callback = function(Option)
        getgenv().selectedWorld = "Earth"
        getgenv().selectedArea = Option[1]
        if getgenv().AutoHatchEgg then
            startAutoHatch()
        end
    end
})

local CyberverseAreaDropdown = Egg:CreateDropdown({
    Name = "Select Area Cyberverse",
    Options = ManualAreasCyberverse,
    CurrentOption = {""},
    MultiSelection = false,
    Flag = "Dropdown2",
    Callback = function(Option)
        getgenv().selectedWorld = "Cyberverse"
        getgenv().selectedArea = Option[1]
        if getgenv().AutoHatchEgg then
            startAutoHatch()
        end
    end
})

local HatchTypeDropdown = Egg:CreateDropdown({
    Name = "Select Hatch Type",
    Options = {"1 Hatch", "3 Hatch"},
    CurrentOption = {""},
    MultiSelection = false,
    Flag = "Dropdown3",
    Callback = function(Option)
        local hatchOptions = {
            ["1 Hatch"] = false,
            ["3 Hatch"] = true
        }

        local tripleHatch = hatchOptions[Option[1]]
        getgenv().tripleHatch = tripleHatch

        if getgenv().AutoHatchEgg then
            startAutoHatch()
        end
    end
})

local TierDropdown = Egg:CreateDropdown({
    Name = "Select Tier",
    Options = {"Tier_1", "Tier_2", "Tier_3", "Tier_4"},
    CurrentOption = {""},
    MultiSelection = false,
    Flag = "Dropdown4",
    Callback = function(Option)
        local tierOptions = {
            ["Tier_1"] = 1,
            ["Tier_2"] = 2,
            ["Tier_3"] = 3,
            ["Tier_4"] = 4
        }

        getgenv().selectedTier = tierOptions[Option[1]] or 1
        if getgenv().AutoHatchEgg then
            autohatch()
        end
    end
})

local isAutoHatching = false

local function startAutoHatch()
    isAutoHatching = true
    while isAutoHatching do
        local selectedWorld = getgenv().selectedWorld
        local selectedArea = getgenv().selectedArea
        local selectedTier = getgenv().selectedTier
        local tripleHatch = getgenv().tripleHatch

        if selectedWorld == "Earth" then
            autohatch("Earth", selectedArea, selectedTier, tripleHatch)
        elseif selectedWorld == "Cyberverse" then
            autohatch("Cyberverse", selectedArea, selectedTier, tripleHatch)
        end

        wait(2)
    end
end

local AutoHatchToggle = Egg:CreateToggle({
    Name = "Auto Hatch Egg",
    SectionParent = Egg,
    CurrentValue = false,
    Callback = function(value)
        getgenv().AutoHatchEgg = value
        if getgenv().AutoHatchEgg then
            startAutoHatch()
        end
    end,
})

-- TAB TELEPORT
local Tab3 = Window:CreateTab("Teleport")
local Tele = Tab3:CreateSection("Teleport", "note : Need Teleport Gempass")

local RealmDropdown = Tele:CreateDropdown({
    Name = "Select Realm",
    Options = {"Earth", "Cyberverse"},
    Flag = "Dropdown1",
    CurrentOption = {""},
    Callback = function(Option)
        getgenv().selectedRealm = Option[1]
    end,
})

local EarthAreaDropdown = Tele:CreateDropdown({
    Name = "Select Area Earth",
    Options = {"Town", "Frosty Kingdom", "Desert Adventure", "Jungle Expedition", "Pirate Cove", "Cerberus Realm", "Dinosaur Kingdom", "Farm Life", "Mountain Expedition", "Fantasy Forest", "Aqua Land", "Hydra Room", "The Portal"},
    CurrentOption = {""},
    Flag = "Dropdown2",
    Callback = function(Option)
        if getgenv().selectedRealm == "Earth" then
            getgenv().selectedAreaEarth = Option[1]
        end
    end,
})

local CyberTownAreaDropdown = Tele:CreateDropdown({
    Name = "Select Area CyberTown",
    Options = {"Cyber Town", "Robo Road", "Cyber Adventure", "Robo Expedition", "Cyborg Cerberus Room", "Cyber Kingdom", "Robo Life", "Cyber Expedition", "Robo Forest", "Robo Land", "Robo Hydra Room", "The Second Portal"},
    CurrentOption = {""},
    Flag = "Dropdown3",
    Callback = function(Option)
        if getgenv().selectedRealm == "Cyberverse" then
            getgenv().selectedAreaCyberTown = Option[1]
        end
    end,
})

local TeleportButton = Tele:CreateButton({
    Name = "Teleport",
    Callback = function()
        if getgenv().selectedRealm and ((getgenv().selectedRealm == "Earth" and getgenv().selectedAreaEarth) or (getgenv().selectedRealm == "Cyberverse" and getgenv().selectedAreaCyberTown)) then
            local selectedArea = getgenv().selectedRealm == "Earth" and getgenv().selectedAreaEarth or getgenv().selectedAreaCyberTown
            local args = {
                [1] = getgenv().selectedRealm,
                [2] = selectedArea
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Teleport"):FireServer(unpack(args))
        else
            warn("Select Realm and Area first.")
        end
    end,
})

