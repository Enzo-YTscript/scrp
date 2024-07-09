local ArrayField = loadstring(game:HttpGet("https://raw.githubusercontent.com/Enzo-YTscript/Ui-Library/main/ArrayfieldLibraryUI"))()

local Window = ArrayField:CreateWindow({
    Name = "Arm Wrestle",
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
        Title = "Arm Wrestle",
        Subtitle = "Key System",
        Note = "Key In Description",
        FileName = "NinjaLegendsKeyEnzoYT",
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

--- MAIN TAB    
local TabMain = Window:CreateTab("HOME", nil) -- Title, Image
local SectionMain = TabMain:CreateSection("Farm",false)

local isClaiming = false
local claimCoroutine

local Toggle = TabMain:CreateToggle({
    Name = "Auto Claim Gift",
    SectionParent = SectionMain,
    CurrentValue = false,
    Callback = function(v)
        isClaiming = v
        if isClaiming then
            claimCoroutine = coroutine.create(function()
                while isClaiming do
                    for i = 1, 12 do
                        if not isClaiming then
                            return
                        end
                        local args = {[1] = i}
                        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("TimedRewardService"):WaitForChild("RE"):WaitForChild("onClaim"):FireServer(unpack(args))
                        wait(0.01)
                    end
                end
            end)
            coroutine.resume(claimCoroutine)
        else
            -- Stop the coroutine when the toggle is turned off
            isClaiming = false
            if claimCoroutine then
                coroutine.yield(claimCoroutine)
            end
        end
    end,
})

-- Fungsi untuk mendapatkan daftar nama NPC dari setiap zona
local function getNPCList()
    local npcs = {}
    local armWrestling = workspace:WaitForChild("GameObjects"):WaitForChild("ArmWrestling")

    for _, zone in pairs(armWrestling:GetChildren()) do
        local npcParent = zone:FindFirstChild("NPC")
        if npcParent then
            for _, npc in pairs(npcParent:GetChildren()) do
                table.insert(npcs, "Zone: " .. zone.Name .. " || NPC Name: " .. npc.Name)
            end
        end
    end
    
    -- Mengurutkan daftar NPC berdasarkan zona dan nama NPC
    table.sort(npcs, function(a, b)
        local zoneA, nameA = a:match("Zone: (.+) || NPC Name: (.+)")
        local zoneB, nameB = b:match("Zone: (.+) || NPC Name: (.+)")
        
        if tonumber(zoneA) and tonumber(zoneB) then
            if tonumber(zoneA) == tonumber(zoneB) then
                return nameA < nameB
            else
                return tonumber(zoneA) < tonumber(zoneB)
            end
        elseif tonumber(zoneA) then
            return true
        elseif tonumber(zoneB) then
            return false
        else
            if zoneA == zoneB then
                return nameA < nameB
            else
                return zoneA < zoneB
            end
        end
    end)

    return npcs
end

-- Inisialisasi dropdown dengan daftar NPC
local npcDropdown
local function createNPCDropdown()
    npcDropdown = TabMain:CreateDropdown({
        Name = "Select NPC",
        SectionParent = SectionMain,
        Options = getNPCList(),
        CurrentOption = "None",
        Callback = function(option)
            getgenv().selectedNPC = option:match("NPC Name: (.+)")
            getgenv().selectedZone = option:match("Zone: (.+) ||")  -- Menyimpan zona yang dipilih
        end
    })
end

createNPCDropdown()

-- Inisialisasi variabel global untuk auto farming
getgenv().AutoFarm = false
getgenv().selectedNPC = "None"
getgenv().selectedZone = "None"

-- Fungsi untuk auto farming
local function autoFarm()
    while getgenv().AutoFarm do
        if getgenv().selectedNPC and getgenv().selectedNPC ~= "None" then
            local npcPath = workspace:WaitForChild("GameObjects"):WaitForChild("ArmWrestling"):WaitForChild(getgenv().selectedZone):WaitForChild("NPC"):FindFirstChild(getgenv().selectedNPC):WaitForChild("Table")
            if npcPath then
                local args = {
                    [1] = getgenv().selectedNPC,
                    [2] = npcPath,
                    [3] = getgenv().selectedZone
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ArmWrestleService"):WaitForChild("RE"):WaitForChild("onEnterNPCTable"):FireServer(unpack(args))
            end
        end
        wait(1) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
    end
end

-- Menambahkan toggle untuk auto farming ke UI
local AutoFarmToggle = TabMain:CreateToggle({
    Name = "Start Farming",
    SectionParent = SectionMain,
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        if Value then
            autoFarm()
        end
    end
})

-- Menambahkan toggle untuk Auto Tap NPC ke UI
local AutoTapNPCToggle = TabMain:CreateToggle({
    Name = "Auto Tap NPC",
    SectionParent = SectionMain,
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoTapNPC = Value
        while getgenv().AutoTapNPC do
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ArmWrestleService"):WaitForChild("RE"):WaitForChild("onClickRequest"):FireServer()
            wait(0.000000000000000000000001) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
        end
    end
})

local TrainMain = TabMain:CreateSection("Train",false)
-- Fungsi untuk mendapatkan daftar nama Zone
local function getZoneList()
    local zones = {}
    local zoneParent = workspace:WaitForChild("Zones")
    for _, zone in pairs(zoneParent:GetChildren()) do
        table.insert(zones, zone.Name)
    end
    
    -- Mengurutkan daftar zona
    table.sort(zones, function(a, b)
        if tonumber(a) and tonumber(b) then
            return tonumber(a) < tonumber(b)
        elseif tonumber(a) then
            return true
        elseif tonumber(b) then
            return false
        else
            return a < b
        end
    end)

    return zones
end

-- Inisialisasi dropdown dengan daftar Zone
local zoneDropdown
local function createZoneDropdown()
    zoneDropdown = TabMain:CreateDropdown({
        Name = "Select Zone To Train",
        SectionParent = TrainMain,
        Options = getZoneList(),
        CurrentOption = "None",
        Callback = function(option)
            getgenv().selectedTrainingZone = option
        end
    })
end

createZoneDropdown()

-- Inisialisasi dropdown dengan daftar opsi latihan
local whatToTrainDropdown
local function createWhatToTrainDropdown()
    whatToTrainDropdown = TabMain:CreateDropdown({
        Name = "Select What To Train",
        SectionParent = TrainMain,
        Options = {"Dumbells", "Hands", "Knuckles"},
        CurrentOption = "Dumbells",
        Callback = function(option)
            getgenv().selectedTraining = option
        end
    })
end

createWhatToTrainDropdown()

-- Inisialisasi variabel global untuk auto training
getgenv().AutoTrain = false
getgenv().selectedTrainingZone = "None"
getgenv().selectedTraining = "Dumbells"
local initialAutoTrainExecuted = false
local unequipExecuted = false

-- Peta berat berdasarkan zona
local weightMapping = {
    ["1"] = "250Kg",
    ["2"] = "4000Kg",
    ["3"] = "45000Kg",
    ["4"] = "300000Kg",
    ["5"] = "...",
    ["6"] = "3T",
    ["7"] = "150T",
    ["8"] = "1QD",
    ["9"] = "50QD",
    ["Garden"] = "...",
    ["JazzClub"] = "...",
    ["Rewind"] = "Rewind12",
}

-- Fungsi untuk eksekusi satu kali sebelum auto training
local function executeInitialFunction()
    local weight = weightMapping[getgenv().selectedTrainingZone]
    if weight then
        local args = {
            [1] = getgenv().selectedTrainingZone,
            [2] = getgenv().selectedTraining == "Hands" and "Grips" or getgenv().selectedTraining,
            [3] = weight
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RE"):WaitForChild("onEquipRequest"):FireServer(unpack(args))
    end
end

-- Fungsi untuk unequip satu kali
local function executeUnequipFunction()
    local args = {}
    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RE"):WaitForChild("onUnequipRequest"):FireServer(unpack(args))
end

-- Fungsi untuk auto training
local function autoTrain()
    while getgenv().AutoTrain do
        if not unequipExecuted then
            executeUnequipFunction()
            unequipExecuted = true
        end

        if not initialAutoTrainExecuted then
            executeInitialFunction()
            initialAutoTrainExecuted = true
        end

        local zonePath = workspace:WaitForChild("Zones"):FindFirstChild(getgenv().selectedTrainingZone)
        if zonePath then
            local args = {
                [1] = {
                    ["Value"] = getgenv().selectedTraining,
                    ["AutoType"] = "AutoTrain"
                }
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("IdleTeleportService"):WaitForChild("RF"):WaitForChild("SetLatestTeleportData"):InvokeServer(unpack(args))
        end
        game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ToolService"):WaitForChild("RE"):WaitForChild("onClick"):FireServer()
        wait(0.00000000000001) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
    end
end

-- Menambahkan toggle untuk auto training ke UI
local AutoTrainToggle = TabMain:CreateToggle({
    Name = "Start Training",
    SectionParent = TrainMain,
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoTrain = Value
        if Value then
            initialAutoTrainExecuted = false
            unequipExecuted = false
            autoTrain()
        end
    end
})

--- Tab Event 
local EventTab = Window:CreateTab("Event", nil) -- Title, Image
local EventSection = EventTab:CreateSection("Event Stuff")

local isSpinEventActive = false
local spinEventCoroutine

local SpinEventToggle = TabMain:CreateToggle({
    Name = "Spin Event Summer",
    SectionParent = EventSection,
    CurrentValue = false,
    Callback = function(Value)
        isSpinEventActive = Value
        if isSpinEventActive then
            spinEventCoroutine = coroutine.create(function()
                local args = {
                    [1] = "Kraken's Fortune"
                }
                while isSpinEventActive do
                    game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("SpinnerService"):WaitForChild("RF"):WaitForChild("Spin"):InvokeServer(unpack(args))
                    wait(0.00000000000001) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
                end
            end)
            coroutine.resume(spinEventCoroutine)
        else
            if spinEventCoroutine then
                coroutine.yield(spinEventCoroutine)
            end
        end
    end
})

local isSpinEventAtlantisActive = false
local spinEventAtlantisCoroutine

local SpinEventAtlantisToggle = TabMain:CreateToggle({
    Name = "Spin Event Atlantis",
    SectionParent = EventSection,
    CurrentValue = false,
    Callback = function(Value)
        isSpinEventAtlantisActive = Value
        if isSpinEventAtlantisActive then
            spinEventAtlantisCoroutine = coroutine.create(function()
                local args = {
                    [1] = "Atlantis Fortune"
                }
                while isSpinEventAtlantisActive do
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.SpinnerService.RF.Spin:InvokeServer(unpack(args))
                    wait(0.01) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
                end
            end)
            coroutine.resume(spinEventAtlantisCoroutine)
        else
            if spinEventAtlantisCoroutine then
                coroutine.yield(spinEventAtlantisCoroutine)
            end
        end
    end
})

---local isSpinEvent4thofJulyFortuneActive = false
---local spinEvent4thofJulyFortuneCoroutine
---
---local SpinEventAtlantisToggle = TabMain:CreateToggle({
---    Name = "Spin Event 4th of July Fortune",
---    SectionParent = OtherSection,
---    CurrentValue = false,
---    Callback = function(Value)
---        isSpinEvent4thofJulyFortuneActive = Value
---        if isSpinEvent4thofJulyFortuneActive then
---            spinEvent4thofJulyFortuneCoroutine = coroutine.create(function()
---                local args = {
---                    [1] = "4th of July Fortune"
---                }
---                while isSpinEvent4thofJulyFortuneActive do
---                    game:GetService("ReplicatedStorage").Packages.Knit.Services.SpinnerService.RF.Spin:InvokeServer(unpack(args))
---                    wait(0.01) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
---                end
---            end)
---            coroutine.resume(spinEvent4thofJulyFortuneCoroutine)
---        else
---            if spinEvent4thofJulyFortuneCoroutine then
---                coroutine.yield(spinEvent4thofJulyFortuneCoroutine)
---            end
---        end
---    end
---})

--- Tab Other 
local OtherTab = Window:CreateTab("Other", nil) -- Title, Image
local OtherSection = OtherTab:CreateSection("Other Stuff")

local function createSpinButton()
    OtherTab:CreateButton({
        Name = "Spin",
        SectionParent = OtherSection,
        Callback = function()
            local args = {
                [1] = false
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("SpinService"):WaitForChild("RE"):WaitForChild("onSpinRequest"):FireServer(unpack(args))
        end
    })
end

createSpinButton()

local RebirthSection = OtherTab:CreateSection("Rebirth",false)
-- Rebirth function
local isRebirthActive = false
local rebirthCoroutine

local isSuperRebirthActive = false
local superRebirthCoroutine

local RebirthToggle = TabMain:CreateToggle({
    Name = "Rebirth",
    SectionParent = RebirthSection,
    CurrentValue = false,
    Callback = function(Value)
        isRebirthActive = Value
        if isRebirthActive then
            rebirthCoroutine = coroutine.create(function()
                while isRebirthActive do
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.RebirthService.RE.onRebirthRequest:FireServer()
                    wait(0.1) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
                end
            end)
            coroutine.resume(rebirthCoroutine)
        else
            if rebirthCoroutine then
                coroutine.yield(rebirthCoroutine)
            end
        end
    end
})

local SuperRebirthToggle = TabMain:CreateToggle({
    Name = "Super Rebirth",
    SectionParent = RebirthSection,
    CurrentValue = false,
    Callback = function(Value)
        isSuperRebirthActive = Value
        if isSuperRebirthActive then
            superRebirthCoroutine = coroutine.create(function()
                while isSuperRebirthActive do
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.RebirthService.RE.onSuperRebirth:FireServer()
                    wait(1) -- Interval waktu antara interaksi (dalam detik, sesuaikan dengan kebutuhan)
                end
            end)
            coroutine.resume(superRebirthCoroutine)
        else
            if superRebirthCoroutine then
                coroutine.yield(superRebirthCoroutine)
            end
        end
    end
})

local FishSection = OtherTab:CreateSection("Fish", false)
-- Initialize global variables for auto features
getgenv().AutoFish = false
getgenv().FishingInterval = 0.0000001 -- Default interval time in seconds (adjust as needed)
getgenv().SelectedPond = "Regular"
getgenv().AutoSellFish = false
getgenv().AutoGarden = false
getgenv().AutoUpgradeSnacks = false

-- Function for auto fishing
local function autoFish()
    while getgenv().AutoFish do
        -- Start catching fish
        local argsStart = {
            [1] = getgenv().SelectedPond
        }
        game:GetService("ReplicatedStorage").Packages.Knit.Services.NetService.RF.StartCatching:InvokeServer(unpack(argsStart))
        
        -- Verify catch with provided arguments
        local verifyArgsList = {
            {42, 46.21813527867198},
            {35, 33.440803369507194},
            {296, 297.9361462816596},
            {158, 161.09991836175323},
            {285, 270.6669566780329},
            {271, 279.7603152282536}
        }

        for _, args in ipairs(verifyArgsList) do
            game:GetService("ReplicatedStorage").Packages.Knit.Services.NetService.RF.VerifyCatch:InvokeServer(unpack(args))
        end

        wait(getgenv().FishingInterval) -- Interval time between each fishing cycle (in seconds)
    end
end

-- Function for auto selling fish
local function autoSellFish()
    while getgenv().AutoSellFish do
        for i = 1, 3 do
            local argsSell = {
                [1] = "Fisherman",
                [2] = i
            }
            game:GetService("ReplicatedStorage").Packages.Knit.Services.MerchantService.RF.BuyItem:InvokeServer(unpack(argsSell))
            wait(0.00001) -- Interval time between sales
        end
    end
end

-- Fungsi untuk mengambil daftar seeds yang memiliki "/1" pada namanya
local function getSeedList()
    local seedList = {}
    local seedsStorage = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Inventory.Display.Items.MainFrame.ScrollingFrame.SeedsStorage.Objects

    for _, seed in pairs(seedsStorage:GetChildren()) do
        if seed.Name:match("/1") then
            local seedName = seed.Name:match("([^/]+)") -- Mengambil nama seed tanpa "/1"
            table.insert(seedList, seedName)
        end
    end

    return seedList
end

-- Daftar seeds yang diperoleh secara otomatis
local seedList = getSeedList()

-- Fungsi untuk auto gardening
local function autoGarden()
    local harvestArgsList = {1, 2, 3, 4, 5, 6}

    while getgenv().AutoGarden do
        -- Harvesting
        for _, id in ipairs(harvestArgsList) do
            local success, err = pcall(function()
                local args = {[1] = tostring(id)}
                game:GetService("ReplicatedStorage").Packages.Knit.Services.ItemPlantingService.RF.Harvest:InvokeServer(unpack(args))
            end)
            if not success then
                warn("Error harvesting item with ID:", id, "Error:", err)
            end
        end
        wait(0.00000000000001) -- Adjust the interval as needed
        
        -- Planting
        for _, seed in ipairs(seedList) do
            for i = 1, 6 do
                local success, err = pcall(function()
                    local plantArgs = {seed, tostring(1), tostring(i)}
                    game:GetService("ReplicatedStorage").Packages.Knit.Services.ItemPlantingService.RF.Plant:InvokeServer(unpack(plantArgs))
                end)
                if not success then
                    warn("Error planting item:", seed, "at slot:", i, "Error:", err)
                end
            end
        end
        wait(0.00000000000001) -- Adjust the interval as needed
    end
end

-- Fungsi untuk mengambil daftar snack yang memiliki "/1" pada namanya
local function getSnackList()
    local snackList = {}
    local snacksStorage = game:GetService("Players").LocalPlayer.PlayerGui.GameUI.Menus.Inventory.Display.Items.MainFrame.ScrollingFrame.SnacksStorage.Objects

    for _, snack in pairs(snacksStorage:GetChildren()) do
        if snack.Name:match("/1") then
            local snackName = snack.Name:match("([^/]+)") -- Mengambil nama snack tanpa "/1"
            table.insert(snackList, snackName)
        end
    end

    return snackList
end

-- Daftar snack yang diperoleh secara otomatis
local snackList = getSnackList()

-- Fungsi untuk auto upgrading snacks
local function autoUpgradeSnacks()
    local tierList = {1, 2}

    while getgenv().AutoUpgradeSnacks do
        local coroutines = {}
        for _, snack in ipairs(snackList) do
            for _, tier in ipairs(tierList) do
                table.insert(coroutines, coroutine.create(function()
                    local args = {
                        {
                            ["Item"] = snack,
                            ["Tier"] = tier
                        }
                    }
                    -- Attempt to upgrade snack and catch any errors
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage").Packages.Knit.Services.ItemCraftingService.RF.UpgradeSnack:InvokeServer(unpack(args))
                    end)
                    if not success then
                        warn("Error upgrading snack:", snack, "to tier:", tier, "Error:", err)
                    end
                end))
            end
        end
        
        -- Jalankan semua coroutine
        for _, co in ipairs(coroutines) do
            coroutine.resume(co)
        end

        wait(0.0000001) -- Interval yang sangat kecil untuk mempercepat proses (sesuaikan dengan kebutuhan)
    end
end


-- Adding toggles and dropdown to the UI
local AutoFishToggle = OtherTab:CreateToggle({
    Name = "Auto Fish",
    SectionParent = FishSection,
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoFish = Value
        if Value then
            spawn(autoFish)
        end
    end
})

local AutoSellFishToggle = OtherTab:CreateToggle({
    Name = "Auto Sell Fish",
    SectionParent = FishSection,
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoSellFish = Value
        if Value then
            spawn(autoSellFish)
        end
    end
})

-- Adding GardenSection and Auto Garden toggle
local GardenSection = OtherTab:CreateSection("Garden", false)

-- Menambahkan toggle untuk Auto Garden ke UI
local AutoGardenToggle = OtherTab:CreateToggle({
    Name = "Auto Garden",
    SectionParent = GardenSection,
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoGarden = Value
        if Value then
            spawn(autoGarden)
        end
    end
})

-- Menambahkan toggle untuk Auto Upgrade Snacks ke UI
local AutoUpgradeSnacksToggle = OtherTab:CreateToggle({
    Name = "Auto Upgrade Snacks",
    SectionParent = GardenSection,
    CurrentValue = false,
    Callback = function(Value)
        getgenv().AutoUpgradeSnacks = Value
        if Value then
            spawn(autoUpgradeSnacks)
        end
    end
})


--- Tab teleport 
local TeleTab = Window:CreateTab("Teleport", nil) -- Title, Image
local TeleSection = TeleTab:CreateSection("No Unlock Zone")

-- Posisi zona untuk teleportasi
local zonePositions = {
    ["Zone 1"] = CFrame.new(-10271.158203125, 1.66973876953125, 46.93609619140625),
    ["Zone 2"] = CFrame.new(-10287.3311, -159.776077, 2815.09399, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Zone 3"] = CFrame.new(11620.255859375, 6.0537261962890625, 25.494232177734375),
    ["Zone 4"] = CFrame.new(-10335.298828125, 3.0494019985198975, -605.9071655273438),
    ["Zone 5"] = CFrame.new(-10294.3984375, 1.2994019985198975, -1417.257080078125),
    ["Zone 6"] = CFrame.new(470.99981689453125, 35.51490020751953, -118.7999267578125),
    ["Zone 7"] = CFrame.new(-9760.46875, 47.96651077270508, 580.4580078125),
    ["Zone 8"] = CFrame.new(-1533.918212890625, 44.458778381347656, -51.14201354980469),
    ["Zone 9"] = CFrame.new(-12350.458984375, 68.79398345947266, 1435.894775390625),
    ["Zone 10"] = CFrame.new(-6152.36083984375, -100.4520034790039, -1636.3961181640625),
    ["Zone Garden"] = CFrame.new(-10658.03125, 1.856773018836975, 109.11421966552734),
    ["Zone JazzClub"] = CFrame.new(-3592.89013671875, 53.08951187133789, -3531.012451171875),
    ["Zone Rewind"] = CFrame.new(-3437.69921875, -29.89999771118164, -5113),
}

-- Fungsi untuk teleportasi ke zone
local function teleportToZone(zoneName)
    local position = zonePositions[zoneName]
    if position then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = position
    end
end

-- Menambahkan tombol untuk teleportasi ke zone
local teleportButtons = {}
local zoneNames = {"Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6", "Zone 7", "Zone 8", "Zone 9", "Zone 10", "Zone Garden", "Zone JazzClub", "Zone Rewind"}

for i, zoneName in ipairs(zoneNames) do
    teleportButtons[i] = TeleTab:CreateButton({
        Name = "Teleport To " .. zoneName,
		SectionParent = TeleSection,
        Callback = function()
            teleportToZone(zoneName)
        end
    })
end


local GameSection = TeleTab:CreateSection("Teleport")

-- Fungsi untuk teleportasi ke zona menggunakan ZoneService
local function teleportToZone(zoneName)
    local args = {
        [1] = workspace.Zones:FindFirstChild(zoneName).Interactables.Teleports.Locations.Spawn
    }
    game:GetService("ReplicatedStorage").Packages.Knit.Services.ZoneService.RE.teleport:FireServer(unpack(args))
end

-- Menambahkan tombol untuk teleportasi ke setiap zona
local gameTeleportButtons = {}
local zoneNames = getZoneList()

for i, zoneName in ipairs(zoneNames) do
    gameTeleportButtons[i] = TeleTab:CreateButton({
        Name = "Teleport To Zone " .. zoneName,
        SectionParent = GameSection,
        Callback = function()
            teleportToZone(zoneName)
        end
    })
end

--- Tab Egg 
local EggTab = Window:CreateTab("Egg", nil) -- Title, Image
local EggSection = EggTab:CreateSection("EGG")

-- Inisialisasi dropdown untuk egg selection terlebih dahulu untuk menghindari masalah 'nil'
local eggDropdown = nil

-- Fungsi untuk mendapatkan daftar egg dari zona yang dipilih
local function getEggList(zone)
    local eggs = {}
    local zones = workspace:FindFirstChild("Zones")

    if zones then
        local selectedZone = zones:FindFirstChild(zone)
        if selectedZone then
            local eggFolderInteractables = selectedZone:FindFirstChild("Interactables") and selectedZone.Interactables:FindFirstChild("Eggs")
            local eggFolderMap = selectedZone:FindFirstChild("Map") and selectedZone.Map:FindFirstChild("Eggs")
            
            if eggFolderInteractables then
                for _, egg in pairs(eggFolderInteractables:GetChildren()) do
                    local eggName = egg.Name:gsub(" Egg$", "")
                    table.insert(eggs, eggName)
                end
            end
            
            if eggFolderMap then
                for _, egg in pairs(eggFolderMap:GetChildren()) do
                    local eggName = egg.Name:gsub(" Egg$", "")
                    table.insert(eggs, eggName)
                end
            end
        end
    end
    
    table.sort(eggs)
    print("Eggs found in zone " .. zone .. ": " .. table.concat(eggs, ", ")) -- Debugging
    return eggs
end

-- Fungsi untuk memperbarui dropdown egg berdasarkan zona yang dipilih
local function updateEggDropdown(zone)
    local eggs = getEggList(zone)
    print("Updating egg dropdown for zone: " .. zone) -- Debugging
    if eggDropdown then
        eggDropdown:Refresh(eggs, "None")
    else
        print("Error: eggDropdown is nil")
    end
end


-- Fungsi untuk mendapatkan daftar zona
local function getZoneList()
    local zones = {}
    local zoneParent = workspace:FindFirstChild("Zones")
    if zoneParent then
        for _, zone in pairs(zoneParent:GetChildren()) do
            table.insert(zones, zone.Name)
        end
        
        -- Mengurutkan daftar zona
        table.sort(zones, function(a, b)
            if tonumber(a) and tonumber(b) then
                return tonumber(a) < tonumber(b)
            elseif tonumber(a) then
                return true
            elseif tonumber(b) then
                return false
            else
                return a < b
            end
        end)
    end
    return zones
end

-- Inisialisasi dropdown untuk zone selection
local zoneDropdown = nil

local function createZoneDropdown()
    local zones = getZoneList()
    print("Zones available: " .. table.concat(zones, ", ")) -- Debugging

    zoneDropdown = EggTab:CreateDropdown({
        Name = "Select Zone",
        SectionParent = EggSection,
        Options = zones,
        CurrentOption = "None",
        Callback = function(option)
            getgenv().selectedZoneForEgg = option
            updateEggDropdown(option)
        end
    })
end

-- Panggil fungsi untuk inisialisasi zoneDropdown
createZoneDropdown()

-- Membuat dropdown untuk egg selection
local function createEggDropdown()
    eggDropdown = EggTab:CreateDropdown({
        Name = "Choose Egg",
        SectionParent = EggSection,
        Options = {},
        CurrentOption = "None",
        Callback = function(option)
            getgenv().selectedEgg = option
        end
    })
end

-- Panggil fungsi untuk inisialisasi eggDropdown
createEggDropdown()

-- Membuat dropdown untuk "Hatch Amount"
local hatchAmountDropdown = EggTab:CreateDropdown({
    Name = "Hatch Amount",
    SectionParent = EggSection,
    Options = {"1", "3", "8"},
    CurrentOption = "",
    Callback = function(option)
        getgenv().hatchAmount = tonumber(option)
    end
})



-- Membuat dropdown untuk "Auto Delete Pets"
local autoDeletePetsDropdown1 = EggTab:CreateDropdown({
    Name = "Auto Delete Pets 1",
    SectionParent = EggSection,
    Options = {}, -- Ini akan diisi nanti
    CurrentOption = "None",
    Callback = function(option)
        getgenv().autoDeletePet1 = option
    end
})

local autoDeletePetsDropdown2 = EggTab:CreateDropdown({
    Name = "Auto Delete Pets 2",
    SectionParent = EggSection,
    Options = {}, -- Ini akan diisi nanti
    CurrentOption = "None",
    Callback = function(option)
        getgenv().autoDeletePet2 = option
    end
})

local autoDeletePetsDropdown3 = EggTab:CreateDropdown({
    Name = "Auto Delete Pets 3",
    SectionParent = EggSection,
    Options = {}, -- Ini akan diisi nanti
    CurrentOption = "None",
    Callback = function(option)
        getgenv().autoDeletePet3 = option
    end
})

local autoDeletePetsDropdown4 = EggTab:CreateDropdown({
    Name = "Auto Delete Pets 4",
    SectionParent = EggSection,
    Options = {}, -- Ini akan diisi nanti
    CurrentOption = "None",
    Callback = function(option)
        getgenv().autoDeletePet4 = option
    end
})

local autoDeletePetsDropdown5 = EggTab:CreateDropdown({
    Name = "Auto Delete Pets 5",
    SectionParent = EggSection,
    Options = {}, -- Ini akan diisi nanti
    CurrentOption = "None",
    Callback = function(option)
        getgenv().autoDeletePet5 = option
    end
})

local autoDeletePetsDropdown6 = EggTab:CreateDropdown({
    Name = "Auto Delete Pets 6",
    SectionParent = EggSection,
    Options = {}, -- Ini akan diisi nanti
    CurrentOption = "None",
    Callback = function(option)
        getgenv().autoDeletePet6 = option
    end
})

-- Fungsi untuk mendapatkan daftar pets
local function getPetList()
    local pets = {}
    local petFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Pets") and game:GetService("ReplicatedStorage").Pets:FindFirstChild("Normal")
    
    if petFolder then
        for _, pet in pairs(petFolder:GetChildren()) do
            table.insert(pets, pet.Name)
        end
    end
    
    table.sort(pets)
    return pets
end

-- Mengisi autoDeletePetsDropdown dengan daftar pets
local function updatePetDropdown()
    local pets = getPetList()
    autoDeletePetsDropdown1:Refresh(pets, "None")
    autoDeletePetsDropdown2:Refresh(pets, "None")
    autoDeletePetsDropdown3:Refresh(pets, "None")
	autoDeletePetsDropdown4:Refresh(pets, "None")
	autoDeletePetsDropdown5:Refresh(pets, "None")
	autoDeletePetsDropdown6:Refresh(pets, "None")
end

updatePetDropdown()

-- Menambahkan toggle untuk "Auto Hatch" ke UI
local autoHatchToggle = EggTab:CreateToggle({
    Name = "Auto Hatch",
    SectionParent = EggSection,
    CurrentValue = false,
    Callback = function(value)
        getgenv().autoHatch = value
        if value then
            startAutoHatch()
        end
    end
})

-- Fungsi untuk memulai auto hatching
function startAutoHatch()
    spawn(function()
        while getgenv().autoHatch do
            if not getgenv().selectedEgg or not getgenv().hatchAmount then
                return
            end

            local deletePets = {}
            if getgenv().autoDeletePet1 and getgenv().autoDeletePet1 ~= "None" then
                deletePets[getgenv().autoDeletePet1] = true
            end
            if getgenv().autoDeletePet2 and getgenv().autoDeletePet2 ~= "None" then
                deletePets[getgenv().autoDeletePet2] = true
            end
            if getgenv().autoDeletePet3 and getgenv().autoDeletePet3 ~= "None" then
                deletePets[getgenv().autoDeletePet3] = true
            end
            if getgenv().autoDeletePet4 and getgenv().autoDeletePet4 ~= "None" then
                deletePets[getgenv().autoDeletePet4] = true
            end
            if getgenv().autoDeletePet5 and getgenv().autoDeletePet5 ~= "None" then
                deletePets[getgenv().autoDeletePet5] = true
            end
            if getgenv().autoDeletePet6 and getgenv().autoDeletePet6 ~= "None" then
                deletePets[getgenv().autoDeletePet6] = true
            end			
            local args
            if getgenv().hatchAmount == 1 then
                args = {
                    [1] = getgenv().selectedEgg,
                    [2] = deletePets,
                    [4] = false
                }
            elseif getgenv().hatchAmount == 3 then
                args = {
                    [1] = getgenv().selectedEgg,
                    [2] = deletePets,
                    [4] = true
                }
            elseif getgenv().hatchAmount == 8 then
                args = {
                    [1] = getgenv().selectedEgg,
                    [2] = deletePets,
                    [4] = true,
                    [5] = true
                }
            end

            game:GetService("ReplicatedStorage").Packages.Knit.Services.EggService.RF.purchaseEgg:InvokeServer(unpack(args))
            wait(0.00000000000001) -- Wait for 1 millisecond after hatching the selected amount
        end
    end)
end

-- Function to start hatch event
function startHatchEvent()
    spawn(function()
        while getgenv().hatchEvent do
            if not getgenv().hatchAmountEvent then
                return
            end

            for i = 1, getgenv().hatchAmountEvent do
                local args = {
                    [1] = getgenv().hatchAmountEvent
                }
                game:GetService("ReplicatedStorage").Packages.Knit.Services.EventService.RF.ClaimEgg:InvokeServer(unpack(args))
                wait(0.0000001) -- Short delay between hatches
            end
            wait(0.00000000000001) -- Wait for 1 second after hatching the selected amount
        end
    end)
end

-- Create dropdown for "Hatch Amount Event"
local hatchAmountEventDropdown = EggTab:CreateDropdown({
    Name = "Hatch Amount Event",
    SectionParent = EggSection,
    Options = {"1", "3", "8", "50", "100", "1000"},
    CurrentOption = "",
    Callback = function(option)
        getgenv().hatchAmountEvent = tonumber(option)
    end
})

-- Create toggle for "Hatch Event"
local hatchEventToggle = EggTab:CreateToggle({
    Name = "Hatch Event",
    SectionParent = EggSection,
    CurrentValue = false,
    Callback = function(value)
        getgenv().hatchEvent = value
        if value then
            startHatchEvent()
        end
    end
})