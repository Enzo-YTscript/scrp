local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source'))()

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
-- TAB EGG
	local Tab2 = Window:CreateTab("EGG", nil) -- Title, Image
	local Egg = Tab:CreateSection("🥚 Auto EGG",false)

local ManualAreasCyberverse = {"Cyber Town", "Robo Road", "Cyber Adventure", "Robo Expedition", "Cyber Kingdom", "Robo Life", "Cyber Expedition",  "Robo Forest", "Robo Land", "The Second Portal",}

local ManualAreasEarth = {"Town", "Frosty Kingdom", "Desert Adventure", "Jungle Expedition", "Dinosaur Kingdom", "Farm Life", "Mountain Expedition", "Fantasy Forest", "Aqua Land", "The Portal"}

local selectedCyberverseArea = nil
local selectedEarthArea = nil

local EarthAreaDropdown = Tab:CreateDropdown({
        Name = "Select Area Earth",
		SectionParent = Egg,
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

local CyberverseAreaDropdown = Tab:CreateDropdown({
    Name = "Select Area Cyberverse",
	SectionParent = Egg,
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

local HatchTypeDropdown = Tab:CreateDropdown({
	Name = "Select Hatch Type",
	SectionParent = Egg,
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

local TierDropdown = Tab:CreateDropdown({
	Name = "Select Tier",
	SectionParent = Egg,
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

        wait(1) -- Tunggu 2 detik sebelum menjalankan lagi (sesuaikan dengan kebutuhan)
    end
end

local AutoHatchToggle = Tab:CreateToggle({
    Name = "Auto Hatch Egg",
        SectionParent = Egg,
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

--TAB TELEPORT
	local Tab3 = Window:CreateTab("Teleport") -- Title, Image	
	local Tele = Tab:CreateSection("Teleport", "note : Need Teleport Gempass")
	
-- Membuat dropdown Realm
local RealmDropdown = Tab:CreateDropdown({
	Name = "Select Realm",
    Options = {"Earth", "Cyberverse"},
	SectionParent = Tele,	
	Flag = "Dropdown1",
	CurrentOption = {""},
    Callback = function(Option)
        getgenv().selectedRealm = Option[1]
    end,
})

-- Membuat dropdown Area untuk Earth
local EarthAreaDropdown = Tab:CreateDropdown({
	Name = "Select Area Earth",
    Options = {"Town", "Frosty Kingdom", "Desert Adventure", "Jungle Expedition", "Pirate Cove", "Cerberus Realm",
    "Dinosaur Kingdom", "Farm Life", "Mountain Expedition", "Fantasy Forest", "Aqua Land", "Hydra Room", "The Portal"}, -- Ganti dengan daftar Area untuk Earth
    CurrentOption = {""},
	SectionParent = Tele,	
	Flag = "Dropdown2",
Callback = function(Option)
        if getgenv().selectedRealm == "Earth" then
            getgenv().selectedAreaEarth = Option[1]
        end
    end,
})

-- Membuat dropdown Area untuk CyberTown
local CyberTownAreaDropdown = Tab:CreateDropdown({
	Name = "Select Area CyberTown",
    Options = {"Cyber Town", "Robo Road", "Cyber Adventure", "Robo Expedition", "Cyborg Cerberus Room", "Cyber Kingdom",
    "Robo Life", "Cyber Expedition", "Robo Forest", "Robo Land", "Robo Hydra Room", "The Second Portal",}, -- Ganti dengan daftar Area untuk CyberTown
    CurrentOption = {""},
	SectionParent = Tele,	
	Flag = "Dropdown3",
    Callback = function(Option)
        if getgenv().selectedRealm == "Cyberverse" then
            getgenv().selectedAreaCyberTown = Option[1]
        end
    end,
})

-- Membuat tombol Teleport
local TeleportButton = Tab:CreateButton({
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
            warn("Pilih Realm dan Area terlebih dahulu.")
        end
    end,
})

--TAB F2PTab
	local Tab4 = Window:CreateTab("F2PTab") -- Title, Image	
	local F2PSec = Tab:CreateSection("F2P")

-- Membuat tombol untuk memicu aksi pertama
local Booster1Button = Tab:CreateButton({
Name = "DropsBooster",
SectionParent = F2P,
    Callback = function()
        local args = {[1] = "Booster", [2] = "DropsBooster"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("F2PStore"):FireServer(unpack(args))
    end,
})

-- Membuat tombol untuk memicu aksi kedua
local Booster2Button = Tab:CreateButton({
Name = "PowerBooster",
SectionParent = F2P,
    Callback = function()
        local args = {[1] = "Booster", [2] = "PowerBooster"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("F2PStore"):FireServer(unpack(args))
    end,
})

-- Membuat tombol untuk memicu aksi ketiga
local Booster3Button = Tab:CreateButton({
Name = "MegaLuckBooster",
SectionParent = F2P,
Callback = function()
        local args = {[1] = "Booster", [2] = "MegaLuckBooster"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("F2PStore"):FireServer(unpack(args))
    end,
})

-- Membuat tombol untuk memicu aksi keempat
local Booster4Button = Tab:CreateButton({
Name = "LuckBooster",
SectionParent = F2P,
Callback = function()
        local args = {[1] = "Booster", [2] = "LuckBooster"}
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("F2PStore"):FireServer(unpack(args))
    end,
})


	
--TAB MISC
	local Tab5 = Window:CreateTab("Misc") -- Title, Image
	local MiscSec = Tab:CreateSection("MISC",false)	
-- inf jump
	local Misc = {}
	Tab:CreateButton({
	Name = "Infinite Jump",
	SectionParent = MiscSec,
	Callback = function()
-- The function that takes place when the button is pressed
	_G.infinjump = not _G.infinjump

	if _G.infinJumpStarted == nil then
--Ensures this only runs once to save resources
	_G.infinJumpStarted = true
	
--Notifies readiness
	game.StarterGui:SetCore("SendNotification", {Title="Youtube Hub"; Text="Infinite Jump Activated!"; Duration=5;})

--The actual infinite jump
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

--- speed
Tab:CreateSpacing(nil,10)
    Misc.Slider = Tab:CreateSlider({
        Name = "Walk Speed",
		SectionParent = MiscSec,
        Range = {0, 100},
        Increment = 10,
        Suffix = "Speed",
        CurrentValue = 10,
        Flag = "Slider1",
        Callback = function(Value)
          game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})	
