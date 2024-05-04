local ArrayField = loadstring(game:HttpGet("https://raw.githubusercontent.com/Enzo-YTscript/Ui-Library/main/ArrayfieldLibrary"))()

local Window = Rayfield:CreateWindow({
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
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Toy Simulator Halloween 🎃",
      Subtitle = "Key System",
      Note = "Key In Description",
      FileName = "ToySimKeyEnzoYT", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
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
    local Tab = Window:CreateTab("HOME", nil) -- Title, Image
	local Section = Tab:CreateSection("Farm",false)

---- player	
	local player = game.Players.LocalPlayer
	local isAutoFarming = false

	local function collectCoin(target)
    local targetPosition = target.PrimaryPart.Position
    local playerPosition = player.Character.HumanoidRootPart.Position
    local distance = (targetPosition - playerPosition).Magnitude

    if distance <= 1000 then -- Jarak maksimum untuk mengambil koin
        player.Character:SetPrimaryPartCFrame(target.PrimaryPart.CFrame * CFrame.new(0, 0, -3)) -- Teleportasi ke koin
        wait(0.5) -- Tunggu sejenak untuk memastikan karakter telah sampai ke koin
        target:Destroy() -- Menghapus koin dari permainan (opsional, tergantung pada game Anda)
        player.Character:SetPrimaryPartCFrame(playerStartCFrame) -- Teleportasi kembali ke posisi awal
    end
end

	local AuroFarm = {}
    Tab:CreateToggle({
        Name = "Auto Farm Coins",
        SectionParent = Farm,
        CurrentValue = false,
        Callback = function(v)
        isAutoFarming = v
        while isAutoFarming do
            local target = nil
            local maxdistance = math.huge
            for i, v in pairs(workspace.Misc.Items:GetChildren()) do
                if not v:FindFirstChild("ClickDetector") then continue end
                local dist = (v.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist > maxdistance then continue end

                target = v
                maxdistance = dist
            end
            if target then
                fireclickdetector(target.ClickDetector)
                game:GetService("ReplicatedStorage").Remotes.Hit:FireServer()
            else
                print("Tidak ada objek dengan ClickDetector di dekat Anda")
            end
            wait(00000000000000000.1) -- Tunggu 1 detik sebelum mencoba lagi
        end
    end,
})

	Tab:CreateSpacing(nil,10)
	local autoCollectToggle = {}
    Tab:CreateToggle({
	Name = "Auto Collect",
        SectionParent = Farm,
        CurrentValue = false,
        Callback = function(v)
getgenv().collect = Value

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

	local AuroCollectGift = {}
    Tab:CreateToggle({
        Name = "Auto Collect Gift",
        SectionParent = Farm,
        CurrentValue = false,
        Callback = function(v)
        for i = 1, 15 do
            local args = {[1] = i}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Rewards"):FireServer(unpack(args))
            wait(000000000000000.1)
        end
    end,
})

	local AutoStartArenaEnabled = false
	
	local AutoStartArena = {}
    Tab:CreateToggle({
        Name = "Auto Start Arena",
        SectionParent = Farm,
        CurrentValue = false,
        Callback = function(value)
        AutoStartArenaEnabled = value
        if AutoStartArenaEnabled then
            while AutoStartArenaEnabled do
                wait(3) -- Tunggu selama 3 detik sebelum memulai Arena
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Start"):FireServer()
            end
        end
    end,
})

-- Fungsi untuk mendapatkan daftar area berdasarkan dunia (Earth atau Cyberverse)
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
